From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH RFC 2/6] target: arm: Add the qemu target for
 KVM_ARM_TARGET_GENERIC_V8
Date: Mon, 16 Jan 2017 17:26:57 +0800
Message-ID: <1484558821-15512-3-git-send-email-zhaoshenglong@huawei.com>
References: <1484558821-15512-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A624018B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:27:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9NacDeosmmTU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jan 2017 04:27:01 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A250B400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:26:38 -0500 (EST)
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
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index a2c9518..fc01ac5 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -128,6 +128,7 @@ MISMATCH_CHECK(QEMU_PSCI_RET_DISABLED, PSCI_RET_DISABLED)
 #define QEMU_KVM_ARM_TARGET_CORTEX_A57 2
 #define QEMU_KVM_ARM_TARGET_XGENE_POTENZA 3
 #define QEMU_KVM_ARM_TARGET_CORTEX_A53 4
+#define QEMU_KVM_ARM_TARGET_GENERIC_V8 5
 
 /* There's no kernel define for this: sentinel value which
  * matches no KVM target value for either 64 or 32 bit
@@ -140,6 +141,7 @@ MISMATCH_CHECK(QEMU_KVM_ARM_TARGET_FOUNDATION_V8, KVM_ARM_TARGET_FOUNDATION_V8)
 MISMATCH_CHECK(QEMU_KVM_ARM_TARGET_CORTEX_A57, KVM_ARM_TARGET_CORTEX_A57)
 MISMATCH_CHECK(QEMU_KVM_ARM_TARGET_XGENE_POTENZA, KVM_ARM_TARGET_XGENE_POTENZA)
 MISMATCH_CHECK(QEMU_KVM_ARM_TARGET_CORTEX_A53, KVM_ARM_TARGET_CORTEX_A53)
+MISMATCH_CHECK(QEMU_KVM_ARM_TARGET_GENERIC_V8, KVM_ARM_TARGET_GENERIC_V8)
 #else
 MISMATCH_CHECK(QEMU_KVM_ARM_TARGET_CORTEX_A15, KVM_ARM_TARGET_CORTEX_A15)
 MISMATCH_CHECK(QEMU_KVM_ARM_TARGET_CORTEX_A7, KVM_ARM_TARGET_CORTEX_A7)
-- 
2.0.4
