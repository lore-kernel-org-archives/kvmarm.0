From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 09/16] arm/arm64: KVM: Turn kvm_psci_version into a static inline
Date: Mon, 29 Jan 2018 17:45:52 +0000
Message-ID: <20180129174559.1866-10-marc.zyngier@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

We're about to need kvm_psci_version in HYP too. So let's turn it
into a static inline, and pass the kvm structure as a second
parameter (so that HYP can do a kern_hyp_va on it).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 20 ++++++++++++--------
 include/kvm/arm_psci.h      | 27 ++++++++++++++++++++++++++-
 virt/kvm/arm/psci.c         | 23 ++---------------------
 3 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 036e1f3d77a6..408c04d789a5 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -19,6 +19,8 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
+#include <kvm/arm_psci.h>
+
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
@@ -350,14 +352,16 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (exit_code == ARM_EXCEPTION_TRAP &&
 	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC64 ||
-	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC32) &&
-	    vcpu_get_reg(vcpu, 0) == PSCI_0_2_FN_PSCI_VERSION) {
-		u64 val = PSCI_RET_NOT_SUPPORTED;
-		if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
-			val = 2;
-
-		vcpu_set_reg(vcpu, 0, val);
-		goto again;
+	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC32)) {
+		u32 val = vcpu_get_reg(vcpu, 0);
+
+		if (val == PSCI_0_2_FN_PSCI_VERSION) {
+			val = kvm_psci_version(vcpu, kern_hyp_va(vcpu->kvm));
+			if (unlikely(val == KVM_ARM_PSCI_0_1))
+				val = PSCI_RET_NOT_SUPPORTED;
+			vcpu_set_reg(vcpu, 0, val);
+			goto again;
+		}
 	}
 
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 4876bfac2195..32978b578002 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -18,6 +18,8 @@
 #ifndef __KVM_ARM_PSCI_H__
 #define __KVM_ARM_PSCI_H__
 
+#include <linux/kvm_host.h>
+
 #define PSCI_VERSION(x,y)	((((x) & 0x7fff) << 16) | ((y) & 0xffff))
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
@@ -25,7 +27,30 @@
 
 #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
 
-int kvm_psci_version(struct kvm_vcpu *vcpu);
+/*
+ * We need the KVM pointer independently from the vcpu as we can call
+ * this from HYP, and need to apply kern_hyp_va on it...
+ */
+static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+	/*
+	 * Our PSCI implementation stays the same across versions from
+	 * v0.2 onward, only adding the few mandatory functions (such
+	 * as FEATURES with 1.0) that are required by newer
+	 * revisions. It is thus safe to return the latest, unless
+	 * userspace has instructed us otherwise.
+	 */
+	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
+		if (kvm->arch.psci_version)
+			return kvm->arch.psci_version;
+
+		return KVM_ARM_PSCI_LATEST;
+	}
+
+	return KVM_ARM_PSCI_0_1;
+}
+
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 struct kvm_one_reg;
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 3bb336ac7d7d..a021b62ed762 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -126,7 +126,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 	if (!vcpu->arch.power_off) {
-		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
+		if (kvm_psci_version(source_vcpu, kvm) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
 			return PSCI_RET_INVALID_PARAMS;
@@ -235,25 +235,6 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
 }
 
-int kvm_psci_version(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Our PSCI implementation stays the same across versions from
-	 * v0.2 onward, only adding the few mandatory functions (such
-	 * as FEATURES with 1.0) that are required by newer
-	 * revisions. It is thus safe to return the latest, unless
-	 * userspace has instructed us otherwise.
-	 */
-	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
-		if (vcpu->kvm->arch.psci_version)
-			return vcpu->kvm->arch.psci_version;
-
-		return KVM_ARM_PSCI_LATEST;
-	}
-
-	return KVM_ARM_PSCI_0_1;
-}
-
 static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -411,7 +392,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  */
 static int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
-	switch (kvm_psci_version(vcpu)) {
+	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
 	case KVM_ARM_PSCI_1_0:
 		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
-- 
2.14.2
