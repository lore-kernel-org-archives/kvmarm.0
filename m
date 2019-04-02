From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v8 8/9] KVM: arm64: Add capability to advertise ptrauth for guest
Date: Tue,  2 Apr 2019 07:57:16 +0530
Message-ID: <1554172037-4516-9-git-send-email-amit.kachhap@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch advertises the capability of two cpu feature called address
pointer authentication and generic pointer authentication. These
capabilities depend upon system support for pointer authentication and
VHE mode.

The current arm64 KVM partially implements pointer authentication and
support of address/generic authentication are tied together. However,
separate ABI requirements for both of them is added so that the future
isolated implementation will not require any ABI changes.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---

Changes since v7:
* Created 2 capabilities KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC
  instead of one KVM_CAP_ARM_PTRAUTH [Kristina Martsenko].
* Added documentation here itself instead of in a new patch.

 Documentation/virtual/kvm/api.txt | 3 +++
 arch/arm64/kvm/reset.c            | 6 ++++++
 include/uapi/linux/kvm.h          | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index aaa048d..9b56892 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2661,8 +2661,11 @@ Possible features:
 	  Depends on KVM_CAP_ARM_PMU_V3.
 	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
 	  for the CPU and supported only on arm64 architecture.
+	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
 	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
 	  for the CPU and supported only on arm64 architecture.
+	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
+	  More details on Documentation/arm64/pointer-authentication.txt.
 
 
 4.83 KVM_ARM_PREFERRED_TARGET
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 717afed..8aa8982 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -92,6 +92,12 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_VM_IPA_SIZE:
 		r = kvm_ipa_limit;
 		break;
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+		r = has_vhe() && system_supports_address_auth();
+		break;
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		r = has_vhe() && system_supports_generic_auth();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6d4ea4b..500ac2b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -988,6 +988,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
 #define KVM_CAP_HYPERV_CPUID 167
+#define KVM_CAP_ARM_PTRAUTH_ADDRESS 168
+#define KVM_CAP_ARM_PTRAUTH_GENERIC 169
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4
