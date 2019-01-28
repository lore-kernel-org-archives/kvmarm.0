From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v5 4/5] arm64/kvm: add a userspace option to enable pointer
 authentication
Date: Mon, 28 Jan 2019 12:28:45 +0530
Message-ID: <1548658727-14271-5-git-send-email-amit.kachhap@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E5F4A380
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QtNhq0aT0ULO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 01:59:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D6EF4A3C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 01:59:31 -0500 (EST)
In-Reply-To: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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
Cc: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 Documentation/arm64/pointer-authentication.txt |  9 +++++----
 Documentation/virtual/kvm/api.txt              |  4 ++++
 arch/arm/include/asm/kvm_host.h                |  4 ++++
 arch/arm64/include/asm/kvm_host.h              |  7 ++++---
 arch/arm64/include/uapi/asm/kvm.h              |  1 +
 arch/arm64/kvm/handle_exit.c                   |  3 ++-
 arch/arm64/kvm/hyp/ptrauth-sr.c                | 13 +++++++++++++
 arch/arm64/kvm/reset.c                         |  3 +++
 include/uapi/linux/kvm.h                       |  1 +
 9 files changed, 37 insertions(+), 8 deletions(-)

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
+	  instructions or treats them as undefined if not set.
 
 
 4.83 KVM_ARM_PREFERRED_TARGET
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index b200c14..b6950df 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -346,6 +346,10 @@ static inline int kvm_arm_have_ssbd(void)
 static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c798d0c..4a6ec40 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -43,7 +43,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 5
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
@@ -453,14 +453,15 @@ static inline bool kvm_arch_requires_vhe(void)
 
 void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
+bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)
 {
 	/* Disable ptrauth and use it in a lazy context via traps */
-	if (has_vhe() && kvm_supports_ptrauth())
+	if (has_vhe() && kvm_supports_ptrauth()
+			&& kvm_arm_vcpu_ptrauth_allowed(vcpu))
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
index 5b980e7..c0e5dcd 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -179,7 +179,8 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
  */
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 {
-	if (has_vhe() && kvm_supports_ptrauth())
+	if (has_vhe() && kvm_supports_ptrauth()
+			&& kvm_arm_vcpu_ptrauth_allowed(vcpu))
 		kvm_arm_vcpu_ptrauth_enable(vcpu);
 	else
 		kvm_inject_undefined(vcpu);
diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
index 0576c01..369624f 100644
--- a/arch/arm64/kvm/hyp/ptrauth-sr.c
+++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
@@ -42,3 +42,16 @@ void __no_ptrauth __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
 	ptrauth_keys_store((struct ptrauth_keys *) &guest_ctxt->sys_regs[APIAKEYLO_EL1]);
 	ptrauth_keys_switch((struct ptrauth_keys *) &host_ctxt->sys_regs[APIAKEYLO_EL1]);
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
+	return test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features);
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
