From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 2/3] KVM: arm/arm64: Add save/restore support for firmware
 workaround state
Date: Mon, 15 Apr 2019 12:15:41 +0100
Message-ID: <20190415111542.119788-3-andre.przywara@arm.com>
References: <20190415111542.119788-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACD154A4B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 07:16:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nlwCWQVhY6GX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 07:16:00 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF8D4A483
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 07:15:59 -0400 (EDT)
In-Reply-To: <20190415111542.119788-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>, kvmarm@lists.cs.columbia.edu, Steven Price <steven.price@arm.com>, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM implements the firmware interface for mitigating cache speculation
vulnerabilities. Guests may use this interface to ensure mitigation is
active.
If we want to migrate such a guest to a host with a different support
level for those workarounds, migration might need to fail, to ensure that
critical guests don't loose their protection.

Introduce a way for userland to save and restore the workarounds state.
On restoring we do checks that make sure we don't downgrade our
mitigation level.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h   |  10 ++
 arch/arm/include/uapi/asm/kvm.h      |  12 +++
 arch/arm64/include/asm/kvm_emulate.h |  14 +++
 arch/arm64/include/uapi/asm/kvm.h    |  10 ++
 virt/kvm/arm/psci.c                  | 139 ++++++++++++++++++++++++---
 5 files changed, 170 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 8927cae7c966..663a02d7e6f4 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -283,6 +283,16 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK;
 }
 
+static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
+						      bool flag)
+{
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	*vcpu_cpsr(vcpu) |= PSR_E_BIT;
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 4602464ebdfb..dfce6fdbd03b 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -214,6 +214,18 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
 					 KVM_REG_ARM_FW | ((r) & 0xffff))
 #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
+	/* Higher values mean better protection. */
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
+	/* Higher values mean better protection. */
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	3
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	(1U << 4)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d3842791e1c4..c00c17c9adb6 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -348,6 +348,20 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.workaround_flags & VCPU_WORKAROUND_2_FLAG;
+}
+
+static inline void kvm_arm_set_vcpu_workaround_2_flag(struct kvm_vcpu *vcpu,
+						      bool flag)
+{
+	if (flag)
+		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
+	else
+		vcpu->arch.workaround_flags &= ~VCPU_WORKAROUND_2_FLAG;
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 97c3478ee6e7..e75a81a7716f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -225,6 +225,16 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 					 KVM_REG_ARM_FW | ((r) & 0xffff))
 #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN	1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	3
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     (1U << 4)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 1da53e0e38f7..c82d90aad3ea 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -449,42 +449,103 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return 1;		/* PSCI version */
+	return 3;		/* PSCI version and two workaround registers */
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices))
+	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
+		return -EFAULT;
+
+	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, uindices++))
+		return -EFAULT;
+
+	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
 		return -EFAULT;
 
 	return 0;
 }
 
+#define KVM_REG_FEATURE_LEVEL_WIDTH	4
+#define KVM_REG_FEATURE_LEVEL_MASK	(BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
+
+/*
+ * Convert the workaround level into an easy-to-compare number, where higher
+ * values mean better protection.
+ */
+static int get_kernel_wa_level(u64 regid)
+{
+	switch (regid) {
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+		switch (kvm_arm_harden_branch_predictor()) {
+		case KVM_BP_HARDEN_UNKNOWN:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
+		case KVM_BP_HARDEN_NEEDED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
+		case KVM_BP_HARDEN_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED;
+		}
+		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		switch (kvm_arm_have_ssbd()) {
+		case KVM_SSBD_FORCE_DISABLE:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
+		case KVM_SSBD_KERNEL:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL;
+		case KVM_SSBD_FORCE_ENABLE:
+		case KVM_SSBD_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED;
+		case KVM_SSBD_UNKNOWN:
+		default:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN;
+		}
+	}
+
+	return -EINVAL;
+}
+
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
-		void __user *uaddr = (void __user *)(long)reg->addr;
-		u64 val;
+	void __user *uaddr = (void __user *)(long)reg->addr;
+	u64 val;
 
+	switch (reg->id) {
+	case KVM_REG_ARM_PSCI_VERSION:
 		val = kvm_psci_version(vcpu, vcpu->kvm);
-		if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
-			return -EFAULT;
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 
-		return 0;
+		if (val == KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL &&
+		    kvm_arm_get_vcpu_workaround_2_flag(vcpu))
+			val |= KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED;
+		break;
+	default:
+		return -ENOENT;
 	}
 
-	return -EINVAL;
+	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
 }
 
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
-		void __user *uaddr = (void __user *)(long)reg->addr;
-		bool wants_02;
-		u64 val;
+	void __user *uaddr = (void __user *)(long)reg->addr;
+	u64 val;
+	int wa_level;
+
+	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
 
-		if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
-			return -EFAULT;
+	switch (reg->id) {
+	case KVM_REG_ARM_PSCI_VERSION:
+	{
+		bool wants_02;
 
 		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
 
@@ -501,6 +562,54 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			vcpu->kvm->arch.psci_version = val;
 			return 0;
 		}
+		break;
+	}
+
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
+			return -EINVAL;
+
+		if (get_kernel_wa_level(reg->id) < val)
+			return -EINVAL;
+
+		return 0;
+
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
+			    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
+			return -EINVAL;
+
+		wa_level = val & KVM_REG_FEATURE_LEVEL_MASK;
+
+		if (get_kernel_wa_level(reg->id) < wa_level)
+			return -EINVAL;
+
+		/* The enabled bit must not be set unless the level is AVAIL. */
+		if (wa_level != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL &&
+		    wa_level != val)
+			return -EINVAL;
+
+		/* Are we finished or do we need to check the enable bit ? */
+		if (kvm_arm_have_ssbd() != KVM_SSBD_KERNEL)
+			return 0;
+
+		/*
+		 * If this kernel supports the workaround to be switched on
+		 * or off, make sure it matches the requested setting.
+		 */
+		switch (wa_level) {
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
+			kvm_arm_set_vcpu_workaround_2_flag(vcpu,
+			    val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED);
+			break;
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED:
+			kvm_arm_set_vcpu_workaround_2_flag(vcpu, true);
+			break;
+		}
+
+		return 0;
+	default:
+		return -ENOENT;
 	}
 
 	return -EINVAL;
-- 
2.17.1
