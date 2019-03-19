From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v7 6/10] KVM: arm64: Add vcpu feature flags to control ptrauth accessibility
Date: Tue, 19 Mar 2019 14:00:39 +0530
Message-ID: <1552984243-7689-7-git-send-email-amit.kachhap@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Since Pointer authentication will be enabled or disabled on a
per-vcpu basis, vcpu feature flags are added in order to know which
vcpus have it enabled from userspace.

This features will allow the KVM guest to allow the handling of
pointer authentication instructions or to treat them as undefined
if not set.

The helper macro added checks the feature flag along with
other conditions such as VHE mode present and system supports
pointer address/generic authentication.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_host.h | 8 +++++++-
 arch/arm64/include/uapi/asm/kvm.h | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e3ccd7b..9dd2918 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -45,7 +45,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 4
+#define KVM_VCPU_MAX_FEATURES 6
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
@@ -491,6 +491,12 @@ static inline bool kvm_arch_requires_vhe(void)
 	return false;
 }
 
+#define vcpu_has_ptrauth(vcpu)	(has_vhe() && \
+		system_supports_address_auth() && \
+		system_supports_generic_auth() && \
+		test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) && \
+		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
+
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 97c3478..8806f71 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -102,6 +102,8 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	4 /* VCPU uses address authentication */
+#define KVM_ARM_VCPU_PTRAUTH_GENERIC	5 /* VCPU uses generic authentication */
 
 struct kvm_vcpu_init {
 	__u32 target;
-- 
2.7.4
