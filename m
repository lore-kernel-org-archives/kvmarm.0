From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH RFC 5/6] arm: virt: Enable generic type CPU in virt machine
Date: Mon, 16 Jan 2017 17:27:00 +0800
Message-ID: <1484558821-15512-6-git-send-email-zhaoshenglong@huawei.com>
References: <1484558821-15512-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21404405D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:27:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TLEtd+Ot3mWA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jan 2017 04:26:58 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C63C4018B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:26:43 -0500 (EST)
In-Reply-To: <1484558821-15512-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-arm@nongnu.org
Cc: qemu-devel@nongnu.org, wu.wubin@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 hw/arm/virt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 4b301c2..49b7b65 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -166,6 +166,7 @@ static const char *valid_cpus[] = {
     "cortex-a15",
     "cortex-a53",
     "cortex-a57",
+    "generic",
     "host",
     NULL
 };
-- 
2.0.4
