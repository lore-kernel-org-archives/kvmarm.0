From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 15/23] arm64: KVM: VHE: Implement VHE
 activate/deactivate_traps
Date: Thu, 11 Feb 2016 18:39:56 +0000
Message-ID: <1455216004-19499-16-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C44D749C02
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nc-cm5K6xC0s for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E94049C17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:37 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Running the kernel in HYP mode requires the HCR_E2H bit to be set
at all times, and the HCR_TGE bit to be set when running as a host
(and cleared when running as a guest). At the same time, the vector
 must be set to the current role of the kernel (either host or
hypervisor), and a couple of system registers differ between VHE
and non-VHE.

We implement these by using another set of alternate functions
that get dynamically patched.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h     |  3 +-
 arch/arm64/include/asm/kvm_emulate.h |  3 ++
 arch/arm64/kvm/hyp/switch.c          | 53 ++++++++++++++++++++++++++++++++----
 3 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index f416714..95ee31e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,7 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
 #define HCR_RW_SHIFT	31
@@ -81,7 +82,7 @@
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
 #define HCR_VIRT_EXCP_MASK (HCR_VA | HCR_VI | HCR_VF)
 #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
-
+#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* Hyp System Control Register (SCTLR_EL2) bits */
 #define SCTLR_EL2_EE	(1 << 25)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 779a587..ae7cdac 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -29,6 +29,7 @@
 #include <asm/kvm_mmio.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
+#include <asm/virt.h>
 
 unsigned long *vcpu_reg32(const struct kvm_vcpu *vcpu, u8 reg_num);
 unsigned long *vcpu_spsr32(const struct kvm_vcpu *vcpu);
@@ -43,6 +44,8 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+	if (is_kernel_in_hyp_mode())
+		vcpu->arch.hcr_el2 |= HCR_E2H;
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 }
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 0d82ae9..e609942 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -15,6 +15,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <asm/kvm_asm.h>
+
 #include "hyp.h"
 
 static bool __hyp_text __fpsimd_enabled_nvhe(void)
@@ -36,6 +38,31 @@ bool __hyp_text __fpsimd_enabled(void)
 	return __fpsimd_is_enabled()();
 }
 
+static void __hyp_text __activate_traps_vhe(void)
+{
+	u64 val;
+
+	val = read_sysreg(cpacr_el1);
+	val |= CPACR_EL1_TTA;
+	val &= ~CPACR_EL1_FPEN;
+	write_sysreg(val, cpacr_el1);
+
+	write_sysreg(__kvm_hyp_vector, vbar_el1);
+}
+
+static void __hyp_text __activate_traps_nvhe(void)
+{
+	u64 val;
+
+	val = CPTR_EL2_DEFAULT;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TFP;
+	write_sysreg(val, cptr_el2);
+}
+
+static hyp_alternate_select(__activate_traps_arch,
+			    __activate_traps_nvhe, __activate_traps_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
@@ -55,20 +82,34 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(val, hcr_el2);
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
+	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	__activate_traps_arch()();
+}
 
-	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TFP;
-	write_sysreg(val, cptr_el2);
+static void __hyp_text __deactivate_traps_vhe(void)
+{
+	extern char vectors[];	/* kernel exception vectors */
 
-	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg(CPACR_EL1_FPEN, cpacr_el1);
+	write_sysreg(vectors, vbar_el1);
 }
 
-static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
+static void __hyp_text __deactivate_traps_nvhe(void)
 {
 	write_sysreg(HCR_RW, hcr_el2);
+	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
+}
+
+static hyp_alternate_select(__deactivate_traps_arch,
+			    __deactivate_traps_nvhe, __deactivate_traps_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
+{
+	__deactivate_traps_arch()();
 	write_sysreg(0, hstr_el2);
 	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
-	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
-- 
2.1.4
