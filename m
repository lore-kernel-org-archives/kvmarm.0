From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v6 4/6] arm64/kvm: add a userspace option to enable pointer authentication
Date: Tue, 19 Feb 2019 14:54:29 +0530
Message-ID: <1550568271-5319-5-git-send-email-amit.kachhap@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This feature will allow the KVM guest to allow the handling of
pointer authentication instructions or to treat them as undefined
if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
supply this parameter instead of creating a new API.

A new register is not created to pass this parameter via
SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
supplied is enough to enable this feature.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 Documentation/arm64/pointer-authentication.txt |  9 +++++----
 Documentation/virtual/kvm/api.txt              |  4 ++++
 arch/arm64/include/asm/kvm_host.h              |  3 ++-
 arch/arm64/include/uapi/asm/kvm.h              |  1 +
 arch/arm64/kvm/handle_exit.c                   |  2 +-
 arch/arm64/kvm/hyp/ptrauth-sr.c                | 16 +++++++++++++++-
 arch/arm64/kvm/reset.c                         |  3 +++
 arch/arm64/kvm/sys_regs.c                      | 26 +++++++++++++-------------
 include/uapi/linux/kvm.h                       |  1 +
 9 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
index a25cd21..0529a7d 100644
--- a/Documentation/arm64/pointer-authentication.txt
+++ b/Documentation/arm64/pointer-authentication.txt
@@ -82,7 +82,8 @@ pointers).
 Virtualization
 --------------
 
-Pointer authentication is not currently supported in KVM guests. KVM
-will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
-the feature will result in an UNDEFINED exception being injected into
-the guest.
+Pointer authentication is enabled in KVM guest when virtual machine is
+created by passing a flag (KVM_ARM_VCPU_PTRAUTH) requesting this feature
+to be enabled. Without this flag, pointer authentication is not enabled
+in KVM guests and attempted use of the feature will result in an UNDEFINED
+exception being injected into the guest.
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 356156f..1e646fb 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2642,6 +2642,10 @@ Possible features:
 	  Depends on KVM_CAP_ARM_PSCI_0_2.
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
+	- KVM_ARM_VCPU_PTRAUTH: Emulate Pointer authentication for the CPU.
+	  Depends on KVM_CAP_ARM_PTRAUTH and only on arm64 architecture. If
+	  set, then the KVM guest allows the execution of pointer authentication
+	  instructions. Otherwise, KVM treats these instructions as undefined.
 
 
 4.83 KVM_ARM_PREFERRED_TARGET
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1bacf78..2768a53 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -43,7 +43,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
@@ -451,6 +451,7 @@ static inline bool kvm_arch_requires_vhe(void)
 	return false;
 }
 
+bool kvm_arm_vcpu_ptrauth_allowed(const struct kvm_vcpu *vcpu);
 static inline bool kvm_supports_ptrauth(void)
 {
 	return has_vhe() && system_supports_address_auth() &&
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 97c3478..5f82ca1 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -102,6 +102,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_PTRAUTH		4 /* VCPU uses address authentication */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 7622ab3..d9f583b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -179,7 +179,7 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
  */
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 {
-	if (kvm_supports_ptrauth())
+	if (kvm_arm_vcpu_ptrauth_allowed(vcpu))
 		kvm_arm_vcpu_ptrauth_enable(vcpu);
 	else
 		kvm_inject_undefined(vcpu);
diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
index 528ee6e..6846a23 100644
--- a/arch/arm64/kvm/hyp/ptrauth-sr.c
+++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
@@ -93,9 +93,23 @@ void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 
-	if (kvm_supports_ptrauth()) {
+	if (kvm_arm_vcpu_ptrauth_allowed(vcpu)) {
 		kvm_arm_vcpu_ptrauth_disable(vcpu);
 		host_ctxt = vcpu->arch.host_cpu_context;
 		__ptrauth_save_state(host_ctxt);
 	}
 }
+
+/**
+ * kvm_arm_vcpu_ptrauth_allowed - checks if ptrauth feature is allowed by user
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * This function will be used to check userspace option to have ptrauth or not
+ * in the guest kernel.
+ */
+bool kvm_arm_vcpu_ptrauth_allowed(const struct kvm_vcpu *vcpu)
+{
+	return kvm_supports_ptrauth() &&
+		test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features);
+}
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b72a3dd..987e0c3c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -91,6 +91,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_VM_IPA_SIZE:
 		r = kvm_ipa_limit;
 		break;
+	case KVM_CAP_ARM_PTRAUTH:
+		r = kvm_supports_ptrauth();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 12529df..f7bcc60 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1055,7 +1055,7 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 }
 
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
+static u64 read_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
@@ -1071,7 +1071,7 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
 					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
 					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
-		if (!kvm_supports_ptrauth()) {
+		if (!kvm_arm_vcpu_ptrauth_allowed(vcpu)) {
 			kvm_debug("ptrauth unsupported for guests, suppressing\n");
 			val &= ~ptrauth_mask;
 		}
@@ -1095,7 +1095,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_id_reg(r, raz);
+	p->regval = read_id_reg(vcpu, r, raz);
 	return true;
 }
 
@@ -1124,17 +1124,17 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
-			bool raz)
+static int __get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			void __user *uaddr, bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
-	const u64 val = read_id_reg(rd, raz);
+	const u64 val = read_id_reg(vcpu, rd, raz);
 
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
-			bool raz)
+static int __set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			void __user *uaddr, bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
 	int err;
@@ -1145,7 +1145,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
 		return err;
 
 	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(rd, raz))
+	if (val != read_id_reg(vcpu, rd, raz))
 		return -EINVAL;
 
 	return 0;
@@ -1154,25 +1154,25 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(rd, uaddr, false);
+	return __get_id_reg(vcpu, rd, uaddr, false);
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(rd, uaddr, false);
+	return __set_id_reg(vcpu, rd, uaddr, false);
 }
 
 static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			  const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(rd, uaddr, true);
+	return __get_id_reg(vcpu, rd, uaddr, true);
 }
 
 static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			  const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(rd, uaddr, true);
+	return __set_id_reg(vcpu, rd, uaddr, true);
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d4ea4b..a553477 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -988,6 +988,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
 #define KVM_CAP_HYPERV_CPUID 167
+#define KVM_CAP_ARM_PTRAUTH 168
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4
