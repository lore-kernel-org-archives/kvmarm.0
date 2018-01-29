From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 08/16] arm/arm64: KVM: Advertise SMCCC v1.1
Date: Mon, 29 Jan 2018 17:45:51 +0000
Message-ID: <20180129174559.1866-9-marc.zyngier@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

The new SMC Calling Convention (v1.1) allows for a reduced overhead
when calling into the firmware, and provides a new feature discovery
mechanism.

Make it visible to KVM guests.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/arm/psci.txt | 12 +++++++-----
 arch/arm/kvm/handle_exit.c             |  2 +-
 arch/arm64/kvm/handle_exit.c           |  2 +-
 include/kvm/arm_psci.h                 |  2 +-
 include/linux/arm-smccc.h              | 13 +++++++++++++
 virt/kvm/arm/psci.c                    | 24 +++++++++++++++++++++++-
 6 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
index 2e49a4e9f084..aafdab887b04 100644
--- a/Documentation/virtual/kvm/arm/psci.txt
+++ b/Documentation/virtual/kvm/arm/psci.txt
@@ -13,7 +13,7 @@ a migration causes a different PSCI version to be exposed out of the
 blue to an unsuspecting guest.
 
 In order to remedy this situation, KVM exposes a set of "firmware
-pseuodo-registers" that can be manipulated using the GET/SET_ONE_REG
+pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
 interface. These registers can be saved/restored by userspace, and set
 to a convenient value if required.
 
@@ -21,8 +21,10 @@ The following register is defined:
 
 * KVM_REG_ARM_PSCI_VERSION:
 
-  - Only valid if the vcpu has KVM_ARM_VCPU_PSCI_0_2 feature set
-  - Returns the current PSCI version on GET_ONE_REG
-  - Allows any supported PSCI version compatible with v0.2 to be set
-    with SET_ONE_REG
+  - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
+    (and thus has already been initialized)
+  - Returns the current PSCI version on GET_ONE_REG (defaulting to the
+    highest PSCI version implemented by KVM and compatible with v0.2)
+  - Allows any PSCI version implemented by KVM and compatible with
+    v0.2 to be set with SET_ONE_REG
   - Affects the whole VM (even if the register view is per-vcpu)
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index e020cc82c4b1..a4520c7118d2 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -36,7 +36,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		      kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
-	ret = kvm_psci_call(vcpu);
+	ret = kvm_hvc_call_handler(vcpu);
 	if (ret < 0) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
 		return 1;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97e8d64a203d..bb6e1518d819 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -52,7 +52,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
-	ret = kvm_psci_call(vcpu);
+	ret = kvm_hvc_call_handler(vcpu);
 	if (ret < 0) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
 		return 1;
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index f2fa7d752c4e..4876bfac2195 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -26,7 +26,7 @@
 #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
 
 int kvm_psci_version(struct kvm_vcpu *vcpu);
-int kvm_psci_call(struct kvm_vcpu *vcpu);
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 struct kvm_one_reg;
 
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 4c5bca38c653..dc68aa5a7261 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -60,6 +60,19 @@
 #define ARM_SMCCC_QUIRK_NONE		0
 #define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
 
+#define ARM_SMCCC_VERSION_1_0		0x10000
+#define ARM_SMCCC_VERSION_1_1		0x10001
+
+#define ARM_SMCCC_VERSION_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0)
+
+#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 1)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 682f9be6264b..3bb336ac7d7d 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -15,6 +15,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/preempt.h>
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
@@ -353,6 +354,7 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 		case PSCI_0_2_FN_SYSTEM_OFF:
 		case PSCI_0_2_FN_SYSTEM_RESET:
 		case PSCI_1_0_FN_PSCI_FEATURES:
+		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
 			break;
 		default:
@@ -407,7 +409,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  * Errors:
  * -EINVAL: Unrecognized PSCI function
  */
-int kvm_psci_call(struct kvm_vcpu *vcpu)
+static int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu)) {
 	case KVM_ARM_PSCI_1_0:
@@ -421,6 +423,26 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 	};
 }
 
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+{
+	u32 func_id = smccc_get_function(vcpu);
+	u32 val;
+
+	switch (func_id) {
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		val = ARM_SMCCC_VERSION_1_1;
+		break;
+	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+		val = -1;	/* Nothing supported yet */
+		break;
+	default:
+		return kvm_psci_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
+
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
 	return 1;		/* PSCI version */
-- 
2.14.2
