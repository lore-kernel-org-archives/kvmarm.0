From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH] arm64: KVM: Enable support for Cortex-A72
Date: Wed, 24 Aug 2016 15:21:37 +0800
Message-ID: <1472023297-2756-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 795E740BDA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 03:15:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1bzRDc7IL5uL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 03:15:50 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70D8140B58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 03:15:47 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to allow KVM to run on Cortex-A72 physical cpus, enable KVM
support for Cortex-A72.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/cputype.h     | 1 +
 arch/arm64/include/uapi/asm/kvm.h    | 3 ++-
 arch/arm64/kvm/guest.c               | 2 ++
 arch/arm64/kvm/sys_regs_generic_v8.c | 2 ++
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 9d9fd4b..cf1f638 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -76,6 +76,7 @@
 #define ARM_CPU_PART_FOUNDATION		0xD00
 #define ARM_CPU_PART_CORTEX_A57		0xD07
 #define ARM_CPU_PART_CORTEX_A53		0xD03
+#define ARM_CPU_PART_CORTEX_A72		0xD08
 
 #define APM_CPU_PART_POTENZA		0x000
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f209ea1..af8fbeb 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -65,8 +65,9 @@ struct kvm_regs {
 #define KVM_ARM_TARGET_CORTEX_A53	4
 /* Generic ARM v8 target */
 #define KVM_ARM_TARGET_GENERIC_V8	5
+#define KVM_ARM_TARGET_CORTEX_A72	6
 
-#define KVM_ARM_NUM_TARGETS		6
+#define KVM_ARM_NUM_TARGETS		7
 
 /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
 #define KVM_ARM_DEVICE_TYPE_SHIFT	0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 32fad75..7eed92e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -293,6 +293,8 @@ int __attribute_const__ kvm_target_cpu(void)
 			return KVM_ARM_TARGET_CORTEX_A53;
 		case ARM_CPU_PART_CORTEX_A57:
 			return KVM_ARM_TARGET_CORTEX_A57;
+		case ARM_CPU_PART_CORTEX_A72:
+			return KVM_ARM_TARGET_CORTEX_A72;
 		};
 		break;
 	case ARM_CPU_IMP_APM:
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index ed90578..cf823e1 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -92,6 +92,8 @@ static int __init sys_reg_genericv8_init(void)
 					  &genericv8_target_table);
 	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_CORTEX_A57,
 					  &genericv8_target_table);
+	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_CORTEX_A72,
+					  &genericv8_target_table);
 	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
 					  &genericv8_target_table);
 	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_GENERIC_V8,
-- 
2.0.4
