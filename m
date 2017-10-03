From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 30/31] KVM: arm64: Emulate TLBI instructions accesible
 from EL1
Date: Mon,  2 Oct 2017 22:11:12 -0500
Message-ID: <1507000273-3735-28-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A152F49D41
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zGAVIRqoXKfY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:54 -0400 (EDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com
 [209.85.214.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DA98406BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:53 -0400 (EDT)
Received: by mail-it0-f46.google.com with SMTP id y138so10006063itc.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:12 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Even though a guest hypervisor can execute TLBI instructions that are
accesible at EL1 without trap, it's wrong; All those TLBI instructions
work based on current VMID, and when running a guest hypervisor current
VMID is the one for itself, not the one from the virtual vttbr_el2. So
letting a guest hypervisor execute those TLBI instructions results in
invalidating its own TLB entries and leaving invalid TLB entries
unhandled.

Therefore we trap and emulate those TLBI instructions. The emulation is
simple; we find a shadow VMID mapped to the virtual vttbr_el2, set it in
the physical vttbr_el2, then execute the same instruction in EL2.

We don't set HCR_EL2.TTLB bit yet.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/include/asm/sysreg.h  | 15 ++++++++++++
 arch/arm64/kvm/hyp/tlb.c         | 52 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu-nested.c      |  3 +--
 arch/arm64/kvm/sys_regs.c        | 50 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index cd7fb85..ce331d7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -56,6 +56,7 @@
 extern void __kvm_tlb_flush_vmid(u64 vttbr);
 extern void __kvm_tlb_flush_local_vmid(u64 vttbr);
 extern void __kvm_tlb_vae2(u64 vttbr, u64 va, u64 sys_encoding);
+extern void __kvm_tlb_el1_instr(u64 vttbr, u64 val, u64 sys_encoding);
 
 extern void __kvm_at_insn(struct kvm_vcpu *vcpu, unsigned long vaddr,
 			  bool el2_regime, int sys_encoding);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6681be1..601f431 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -347,6 +347,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 bool kvm_nested_s2_clear_curr_vmid(struct kvm_vcpu *vcpu, phys_addr_t start,
 				   u64 size);
+struct kvm_nested_s2_mmu *lookup_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 53df733..fd6b98a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -386,10 +386,25 @@
 
 /* TLBI instructions */
 #define TLBI_Op0	1
+#define TLBI_Op1_EL1	0	/* Accessible from EL1 or higher */
 #define TLBI_Op1_EL2	4	/* Accessible from EL2 or higher */
 #define TLBI_CRn	8
+#define tlbi_insn_el1(CRm, Op2)	sys_insn(TLBI_Op0, TLBI_Op1_EL1, TLBI_CRn, (CRm), (Op2))
 #define tlbi_insn_el2(CRm, Op2)	sys_insn(TLBI_Op0, TLBI_Op1_EL2, TLBI_CRn, (CRm), (Op2))
 
+#define TLBI_VMALLE1IS	tlbi_insn_el1(3, 0)
+#define TLBI_VAE1IS	tlbi_insn_el1(3, 1)
+#define TLBI_ASIDE1IS	tlbi_insn_el1(3, 2)
+#define TLBI_VAAE1IS	tlbi_insn_el1(3, 3)
+#define TLBI_VALE1IS	tlbi_insn_el1(3, 5)
+#define TLBI_VAALE1IS	tlbi_insn_el1(3, 7)
+#define TLBI_VMALLE1	tlbi_insn_el1(7, 0)
+#define TLBI_VAE1	tlbi_insn_el1(7, 1)
+#define TLBI_ASIDE1	tlbi_insn_el1(7, 2)
+#define TLBI_VAAE1	tlbi_insn_el1(7, 3)
+#define TLBI_VALE1	tlbi_insn_el1(7, 5)
+#define TLBI_VAALE1	tlbi_insn_el1(7, 7)
+
 #define TLBI_IPAS2E1IS	tlbi_insn_el2(0, 1)
 #define TLBI_IPAS2LE1IS	tlbi_insn_el2(0, 5)
 #define TLBI_ALLE2IS	tlbi_insn_el2(3, 0)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index bd8b92c..096c234 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -179,3 +179,55 @@ void __hyp_text __kvm_tlb_vae2(u64 vttbr, u64 va, u64 sys_encoding)
 
 	__tlb_switch_to_host()();
 }
+
+void __hyp_text __kvm_tlb_el1_instr(u64 vttbr, u64 val, u64 sys_encoding)
+{
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest()(vttbr);
+
+	/* Execute the same instruction as the guest hypervisor did */
+	switch (sys_encoding) {
+	case TLBI_VMALLE1IS:
+		__tlbi(vmalle1is);
+		break;
+	case TLBI_VAE1IS:
+		__tlbi(vae1is, val);
+		break;
+	case TLBI_ASIDE1IS:
+		__tlbi(aside1is, val);
+		break;
+	case TLBI_VAAE1IS:
+		__tlbi(vaae1is, val);
+		break;
+	case TLBI_VALE1IS:
+		__tlbi(vale1is, val);
+		break;
+	case TLBI_VAALE1IS:
+		__tlbi(vaale1is, val);
+		break;
+	case TLBI_VMALLE1:
+		__tlbi(vmalle1);
+		break;
+	case TLBI_VAE1:
+		__tlbi(vae1, val);
+		break;
+	case TLBI_ASIDE1:
+		__tlbi(aside1, val);
+		break;
+	case TLBI_VAAE1:
+		__tlbi(vaae1, val);
+		break;
+	case TLBI_VALE1:
+		__tlbi(vale1, val);
+		break;
+	case TLBI_VAALE1:
+		__tlbi(vaale1, val);
+		break;
+	default:
+		break;
+	}
+	dsb(nsh);
+	isb();
+
+	__tlb_switch_to_host()();
+}
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index 2189f2b..8826eaa 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -332,8 +332,7 @@ void kvm_nested_s2_free(struct kvm *kvm)
 		__kvm_free_stage2_pgd(kvm, &nested_mmu->mmu);
 }
 
-static struct kvm_nested_s2_mmu *lookup_nested_mmu(struct kvm_vcpu *vcpu,
-						   u64 vttbr)
+struct kvm_nested_s2_mmu *lookup_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr)
 {
 	struct kvm_nested_s2_mmu *mmu;
 	u64 virtual_vmid;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 89e73af..1dcbe70 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -983,6 +983,11 @@ static bool forward_at_traps(struct kvm_vcpu *vcpu)
 	return forward_traps(vcpu, HCR_AT);
 }
 
+static bool forward_ttlb_traps(struct kvm_vcpu *vcpu)
+{
+	return forward_traps(vcpu, HCR_TTLB);
+}
+
 /* This function is to support the recursive nested virtualization */
 bool forward_nv_traps(struct kvm_vcpu *vcpu)
 {
@@ -1896,6 +1901,37 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	u64 virtual_vttbr = vcpu_sys_reg(vcpu, VTTBR_EL2);
+	u64 vttbr;
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	int sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	nested_mmu = lookup_nested_mmu(vcpu, virtual_vttbr);
+	if (!nested_mmu) {
+		/*
+		 * If we can't find a shadow VMID, it is either the virtual
+		 * VMID is for the host OS or the nested VM having the virtual
+		 * VMID is never executed. (Note that we create a showdow VMID
+		 * when entering a VM.) For the former, we can flush TLB
+		 * entries belonging to the host OS in a VM. For the latter, we
+		 * don't have to do anything. Since we can't differentiate
+		 * between those cases, just do what we can do for the former.
+		 */
+		mmu = &vcpu->kvm->arch.mmu;
+	} else {
+		mmu = &nested_mmu->mmu;
+	}
+
+	vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+	kvm_call_hyp(__kvm_tlb_el1_instr, vttbr, p->regval, sys_encoding);
+
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1971,6 +2007,20 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(AT_S1E0W, handle_s1e01, forward_at_traps),
 	SYS_INSN_TO_DESC(AT_S1E1RP, handle_s1e01, forward_at_traps),
 	SYS_INSN_TO_DESC(AT_S1E1WP, handle_s1e01, forward_at_traps),
+
+	SYS_INSN_TO_DESC(TLBI_VMALLE1IS, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VAE1IS, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_ASIDE1IS, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VAAE1IS, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VALE1IS, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VAALE1IS, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VMALLE1, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VAE1, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_ASIDE1, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VAAE1, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VALE1, handle_tlbi_el1, forward_ttlb_traps),
+	SYS_INSN_TO_DESC(TLBI_VAALE1, handle_tlbi_el1, forward_ttlb_traps),
+
 	SYS_INSN_TO_DESC(AT_S1E2R, handle_s1e2, forward_nv_traps),
 	SYS_INSN_TO_DESC(AT_S1E2W, handle_s1e2, forward_nv_traps),
 	SYS_INSN_TO_DESC(AT_S12E1R, handle_s12r, forward_nv_traps),
-- 
1.9.1
