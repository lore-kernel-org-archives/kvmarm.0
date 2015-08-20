From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 12/25] arm64/kvm: Add generic v8 KVM target
Date: Thu, 20 Aug 2015 17:28:50 +0100
Message-ID: <1440088143-4722-13-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

This patch adds a generic ARM v8 KVM target cpu type for use
by the new CPUs which eventualy ends up using the common sys_reg
table. For backward compatibility the existing targets have been
preserved. Any new target CPU that can be covered by generic v8
sys_reg tables should make use of the new generic target.

Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Acked-by: Marc Zyngier <Marc.Zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h    | 10 ++++++++--
 arch/arm64/kvm/guest.c               |  3 ++-
 arch/arm64/kvm/sys_regs_generic_v8.c |  2 ++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d82f3f3..0cd7b59 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -53,14 +53,20 @@ struct kvm_regs {
 	struct user_fpsimd_state fp_regs;
 };
 
-/* Supported Processor Types */
+/*
+ * Supported CPU Targets - Adding a new target type is not recommended,
+ * unless there are some special registers not supported by the
+ * genericv8 syreg table.
+ */
 #define KVM_ARM_TARGET_AEM_V8		0
 #define KVM_ARM_TARGET_FOUNDATION_V8	1
 #define KVM_ARM_TARGET_CORTEX_A57	2
 #define KVM_ARM_TARGET_XGENE_POTENZA	3
 #define KVM_ARM_TARGET_CORTEX_A53	4
+/* Generic ARM v8 target */
+#define KVM_ARM_TARGET_GENERIC_V8	5
 
-#define KVM_ARM_NUM_TARGETS		5
+#define KVM_ARM_NUM_TARGETS		6
 
 /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
 #define KVM_ARM_DEVICE_TYPE_SHIFT	0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 48868d8..d250160 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -295,7 +295,8 @@ int __attribute_const__ kvm_target_cpu(void)
 		break;
 	};
 
-	return -EINVAL;
+	/* Return a default generic target */
+	return KVM_ARM_TARGET_GENERIC_V8;
 }
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 475fd29..1e45768 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -94,6 +94,8 @@ static int __init sys_reg_genericv8_init(void)
 					  &genericv8_target_table);
 	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
 					  &genericv8_target_table);
+	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_GENERIC_V8,
+					  &genericv8_target_table);
 
 	return 0;
 }
-- 
2.1.4

