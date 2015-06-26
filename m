From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
Subject: [PATCH] arm64: KVM: Enable minimalistic support for Thunder
Date: Fri, 26 Jun 2015 12:51:24 -0700
Message-ID: <1435348284-32132-1-git-send-email-tchalamarla@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F23365715C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 15:40:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cQvveFdStmuJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2015 15:40:42 -0400 (EDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0093.outbound.protection.outlook.com [65.55.169.93])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C58215715B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 15:40:42 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, rrichter@cavium.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to allow KVM to run on Thunder implementations, add the
minimal support required.

Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
---
 arch/arm64/include/asm/cputype.h     | 3 +++
 arch/arm64/include/uapi/asm/kvm.h    | 3 ++-
 arch/arm64/kvm/guest.c               | 6 ++++++
 arch/arm64/kvm/sys_regs_generic_v8.c | 2 ++
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index a84ec60..f603dcd 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -63,6 +63,7 @@
 	((partnum)		<< MIDR_PARTNUM_SHIFT))
 
 #define ARM_CPU_IMP_ARM		0x41
+#define ARM_CPU_IMP_CAVIUM		0x43
 #define ARM_CPU_IMP_APM		0x50
 
 #define ARM_CPU_PART_AEM_V8	0xD0F
@@ -72,6 +73,8 @@
 
 #define APM_CPU_PART_POTENZA	0x000
 
+#define ARM_CPU_PART_THUNDER	0x0A1
+
 #define ID_AA64MMFR0_BIGENDEL0_SHIFT	16
 #define ID_AA64MMFR0_BIGENDEL0_MASK	(0xf << ID_AA64MMFR0_BIGENDEL0_SHIFT)
 #define ID_AA64MMFR0_BIGENDEL0(mmfr0)	\
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d268320..6c4c556 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -59,8 +59,9 @@ struct kvm_regs {
 #define KVM_ARM_TARGET_CORTEX_A57	2
 #define KVM_ARM_TARGET_XGENE_POTENZA	3
 #define KVM_ARM_TARGET_CORTEX_A53	4
+#define KVM_ARM_TARGET_CAVIUM_THUNDER	5
 
-#define KVM_ARM_NUM_TARGETS		5
+#define KVM_ARM_NUM_TARGETS		6
 
 /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
 #define KVM_ARM_DEVICE_TYPE_SHIFT	0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9535bd5..3751f37 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -291,6 +291,12 @@ int __attribute_const__ kvm_target_cpu(void)
 			return KVM_ARM_TARGET_XGENE_POTENZA;
 		};
 		break;
+	case ARM_CPU_IMP_CAVIUM:
+		switch (part_number) {
+		case ARM_CPU_PART_THUNDER:
+			return KVM_ARM_TARGET_CAVIUM_THUNDER;
+		};
+		break;
 	};
 
 	return -EINVAL;
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 475fd29..0e48ee8 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -94,6 +94,8 @@ static int __init sys_reg_genericv8_init(void)
 					  &genericv8_target_table);
 	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
 					  &genericv8_target_table);
+	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_CAVIUM_THUNDER,
+					  &genericv8_target_table);
 
 	return 0;
 }
-- 
2.1.0
