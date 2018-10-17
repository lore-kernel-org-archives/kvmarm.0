From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v3 3/7] arm64/kvm: add a userspace option to enable pointer authentication
Date: Wed, 17 Oct 2018 16:17:56 +0530
Message-ID: <1539773280-4159-4-git-send-email-amit.kachhap@arm.com>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This feature will allow the KVM guest to allow the handling of
pointer authentication instructions or to treat them as undefined
if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
supply this parameter instead of creating a new API.

A new register is not created to pass this parameter via
SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
supplied is enough to select this feature.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 Documentation/virtual/kvm/api.txt |  2 ++
 arch/arm/include/asm/kvm_host.h   |  4 ++++
 arch/arm64/include/asm/kvm_host.h |  8 ++++----
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 arch/arm64/kvm/handle_exit.c      |  2 +-
 arch/arm64/kvm/hyp/ptrauth-sr.c   | 16 ++++++++++++++++
 arch/arm64/kvm/reset.c            |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 8 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 647f941..45f3b94 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2585,6 +2585,8 @@ Possible features:
 	  Depends on KVM_CAP_ARM_PSCI_0_2.
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
+	- KVM_ARM_VCPU_PTRAUTH: Emulate Pointer authentication for the CPU.
+	  Depends on KVM_CAP_ARM_PTRAUTH and only on arm64 architecture.
 
 
 4.83 KVM_ARM_PREFERRED_TARGET
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 0ad3c3f..4543afc 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -353,6 +353,10 @@ static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_vcpu_ptrauth_start(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_vcpu_ptrauth_stop(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ecba6d5..e909d96 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -43,7 +43,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
@@ -440,19 +440,19 @@ static inline bool kvm_arch_check_sve_has_vhe(void)
 
 void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
+bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu);
 static inline void kvm_arm_vcpu_ptrauth_start(struct kvm_vcpu *vcpu)
 {
 	/* Enable ptrauth for the vcpu */
-	if (system_supports_ptrauth())
+	if (system_supports_ptrauth() && kvm_arm_vcpu_ptrauth_allowed(vcpu))
 		kvm_arm_vcpu_ptrauth_enable(vcpu);
 }
 static inline void kvm_arm_vcpu_ptrauth_stop(struct kvm_vcpu *vcpu)
 {
 	/* Disable ptrauth for the vcpu */
-	if (system_supports_ptrauth())
+	if (system_supports_ptrauth() && kvm_arm_vcpu_ptrauth_allowed(vcpu))
 		kvm_arm_vcpu_ptrauth_disable(vcpu);
 }
-
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arch_hardware_unsetup(void) {}
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
index 798158d..95eb4e6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -180,7 +180,7 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
  */
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 {
-	if (system_supports_ptrauth())
+	if (system_supports_ptrauth() && kvm_arm_vcpu_ptrauth_allowed(vcpu))
 		kvm_arm_vcpu_ptrauth_enable(vcpu);
 	else
 		kvm_inject_undefined(vcpu);
diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
index 6e96908..3c718f5 100644
--- a/arch/arm64/kvm/hyp/ptrauth-sr.c
+++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
@@ -71,3 +71,19 @@ void __no_ptrauth __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
 	__ptrauth_save_state(guest_ctxt);
 	__ptrauth_restore_state(host_ctxt);
 }
+
+/**
+ * kvm_arm_vcpu_ptrauth_allowed - checks if ptrauth feature is present in vcpu
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * This function will be used to enable/disable ptrauth in guest as configured
+ * by the KVM userspace API.
+ */
+bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
+{
+	if (test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features))
+		return true;
+	else
+		return false;
+}
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e37c78b..e32d666 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -85,6 +85,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_EVENTS:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_PTRAUTH:
+		r = system_supports_ptrauth();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 251be35..d886878 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -953,6 +953,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_NESTED_STATE 157
 #define KVM_CAP_ARM_INJECT_SERROR_ESR 158
 #define KVM_CAP_MSR_PLATFORM_INFO 159
+#define KVM_CAP_ARM_PTRAUTH 160
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4
