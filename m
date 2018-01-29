From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 06/16] arm/arm64: KVM: Implement PSCI 1.0 support
Date: Mon, 29 Jan 2018 17:45:49 +0000
Message-ID: <20180129174559.1866-7-marc.zyngier@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

PSCI 1.0 can be trivially implemented by having PSCI 0.2 and
the FEATURES call. Of, and returning 1.0 as the PSCI version.

We happily ignore everything else, as it is optional.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_psci.h |  1 +
 virt/kvm/arm/psci.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 3a408c846c09..e7f69c0dc249 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -21,6 +21,7 @@
 #define PSCI_VERSION(x,y)	((((x) & 0x7fff) << 16) | ((y) & 0xffff))
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
+#define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
 
 int kvm_psci_version(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 053654082bd4..6299501f7664 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -315,6 +315,47 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
+{
+	u32 psci_fn = smccc_get_function(vcpu);
+	u32 feature;
+	unsigned long val;
+	int ret = 1;
+
+	switch(psci_fn) {
+	case PSCI_0_2_FN_PSCI_VERSION:
+		val = KVM_ARM_PSCI_1_0;
+		break;
+	case PSCI_1_0_FN_PSCI_FEATURES:
+		feature = smccc_get_arg1(vcpu);
+		switch(feature) {
+		case PSCI_0_2_FN_PSCI_VERSION:
+		case PSCI_0_2_FN_CPU_SUSPEND:
+		case PSCI_0_2_FN64_CPU_SUSPEND:
+		case PSCI_0_2_FN_CPU_OFF:
+		case PSCI_0_2_FN_CPU_ON:
+		case PSCI_0_2_FN64_CPU_ON:
+		case PSCI_0_2_FN_AFFINITY_INFO:
+		case PSCI_0_2_FN64_AFFINITY_INFO:
+		case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+		case PSCI_0_2_FN_SYSTEM_OFF:
+		case PSCI_0_2_FN_SYSTEM_RESET:
+		case PSCI_1_0_FN_PSCI_FEATURES:
+			val = 0;
+			break;
+		default:
+			val = PSCI_RET_NOT_SUPPORTED;
+			break;
+		}
+		break;
+	default:
+		return kvm_psci_0_2_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return ret;
+}
+
 static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -357,6 +398,8 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu)) {
+	case KVM_ARM_PSCI_1_0:
+		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
 		return kvm_psci_0_2_call(vcpu);
 	case KVM_ARM_PSCI_0_1:
-- 
2.14.2
