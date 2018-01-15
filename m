From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 08/13] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Mon, 15 Jan 2018 19:39:01 +0000
Message-ID: <20180115193906.30053-9-james.morse@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CECB449E2F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z4ipXgh0EbaX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 14:36:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89A1349DFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:54 -0500 (EST)
In-Reply-To: <20180115193906.30053-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Prior to v8.2's RAS Extensions, the HCR_EL2.VSE 'virtual SError' feature
generated an SError with an implementation defined ESR_EL1.ISS, because we
had no mechanism to specify the ESR value.

On Juno this generates an all-zero ESR, the most significant bit 'ISV'
is clear indicating the remainder of the ISS field is invalid.

With the RAS Extensions we have a mechanism to specify this value, and the
most significant bit has a new meaning: 'IDS - Implementation Defined
Syndrome'. An all-zero SError ESR now means: 'RAS error: Uncategorized'
instead of 'no valid ISS'.

Add KVM support for the VSESR_EL2 register to specify an ESR value when
HCR_EL2.VSE generates a virtual SError. Change kvm_inject_vabt() to
specify an implementation-defined value.

We only need to restore the VSESR_EL2 value when HCR_EL2.VSE is set, KVM
save/restores this bit during __{,de}activate_traps() and hardware clears the
bit once the guest has consumed the virtual-SError.

Future patches may add an API (or KVM CAP) to pend a virtual SError with
a specified ESR.

Cc: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changes since v4:
 * Fixed an uncatagorized typo

 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/include/asm/kvm_host.h    |  3 +++
 arch/arm64/include/asm/sysreg.h      |  1 +
 arch/arm64/kvm/hyp/switch.c          |  3 +++
 arch/arm64/kvm/inject_fault.c        | 13 ++++++++++++-
 5 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5f28dfa14cee..6d3614795197 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -64,6 +64,11 @@ static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
 	vcpu->arch.hcr_el2 = hcr;
 }
 
+static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
+{
+	vcpu->arch.vsesr_el2 = vsesr;
+}
+
 static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dcdd08edf5a5..3014b39b8fe2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -280,6 +280,9 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
+	u64 vsesr_el2;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 115b89aeec00..aec10f75a43c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -355,6 +355,7 @@
 
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
 
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 324f4202cdd5..b425b8aab45b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -94,6 +94,9 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(val, hcr_el2);
 
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (val & HCR_VSE))
+		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	/*
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 8ecbcb40e317..60666a056944 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -164,14 +164,25 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
+static void pend_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
+{
+	vcpu_set_vsesr(vcpu, esr);
+	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+}
+
 /**
  * kvm_inject_vabt - inject an async abort / SError into the guest
  * @vcpu: The VCPU to receive the exception
  *
  * It is assumed that this code is called from the VCPU thread and that the
  * VCPU therefore is not currently executing guest code.
+ *
+ * Systems with the RAS Extensions specify an imp-def ESR (ISV/IDS = 1) with
+ * the remaining ISS all-zeros so that this error is not interpreted as an
+ * uncategorized RAS error. Without the RAS Extensions we can't specify an ESR
+ * value, so the CPU generates an imp-def value.
  */
 void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+	pend_guest_serror(vcpu, ESR_ELx_ISV);
 }
-- 
2.15.1
