#!/bin/sh
# 功能：接收单个magnet链接，通过aria2 RPC添加任务并附加Tracker
# 用法：./aria2-add-magnet.sh 'magnet:?xt=urn:btih:你的BT哈希值&dn=文件名'

# 配置参数（沿用你的原配置，可按需修改）
tracker_url='https://cf.trackerslist.com/best_aria2.txt'
aria2_rpc_path='http://localhost:6800/jsonrpc'
aria2_rpc_passwd='finalserver'

# 1. 检查是否传入磁力链接参数
if [ $# -eq 0 ]; then
    echo "错误：请传入一个magnet链接作为参数！"
    echo "用法：$0 'magnet:?xt=urn:btih:xxx&dn=xxx'"
    exit 1
fi

magnet_link="$1"  # 第一个参数作为磁力链接

# 2. 获取Tracker列表（和你的原脚本逻辑一致）
echo "正在获取最新Tracker列表..."
tracker=$(curl -s -L "$tracker_url")

# 3. 检查Tracker是否获取成功
if [ -z "$tracker" ]; then
    echo "错误：获取Tracker失败！请检查网络或Tracker地址是否有效"
    exit 1
fi

echo "成功获取Tracker（共$(echo "$tracker" | wc -l)个），正在提交任务..."

# 4. 调用aria2 RPC添加任务（核心逻辑）
# 注意：认证方式沿用你的「token:密码」格式，bt-tracker参数直接使用获取到的Tracker（换行分隔）
curl -s -X POST "$aria2_rpc_path" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "aria2.addUri",
    "id": "aria2-add-magnet-script",
    "params": [
      "token:'"$aria2_rpc_passwd"'",
      ["'"$magnet_link"'"],
      {
        "bt-tracker": "'"$tracker"'"
      }
    ]
  }' | jq .  # jq用于格式化输出（可选，没有jq可删除该部分）

# 5. 输出结果提示
if [ $? -eq 0 ]; then
    echo -e "\n任务提交成功！"
else
    echo -e "\n错误：任务提交失败！请检查aria2是否在运行、RPC端口是否正确"
    exit 1
fi
