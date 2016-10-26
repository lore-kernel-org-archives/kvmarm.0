From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v2 6/8] arm: KVM: Handle trappable TLB instructions
Date: Wed, 26 Oct 2016 18:41:46 +0100
Message-ID: <20161026174148.17172-7-punit.agrawal@arm.com>
References: <20161026174148.17172-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E852240421
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2016 13:42:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qhDkbQzjEMdo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Oct 2016 13:42:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 871AA40699
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2016 13:42:44 -0400 (EDT)
In-Reply-To: <20161026174148.17172-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

It is possible to enable selective trapping of guest TLB maintenance
instructions executed in lower privilege levels to HYP mode. This
feature can be used to monitor guest TLB operations.

Add support to emulate the TLB instructions when their execution traps
to hyp mode.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h |  1 +
 arch/arm/kvm/coproc.c          | 55 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/tlb.c         | 33 +++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index d7ea6bc..00a6511 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -66,6 +66,7 @@ extern char __kvm_hyp_vector[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern void __kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 opcode, u64 regval);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 3e5e419..593edeb 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -205,6 +205,23 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool emulate_tlb_invalidate(struct kvm_vcpu *vcpu,
+				   const struct coproc_params *p,
+				   const struct coproc_reg *r)
+{
+	/*
+	 * Based on system register encoding from ARM v8 ARM
+	 * (DDI 0487A.k F5.1.103)
+	 */
+	u32 opcode = p->Op1 << 21 | p->CRn << 16 | p->Op2 << 5 | p->CRm << 0;
+
+	kvm_call_hyp(__kvm_emulate_tlb_invalidate,
+		     vcpu->kvm, opcode, p->Rt1);
+	trace_kvm_tlb_invalidate(*vcpu_pc(vcpu), opcode);
+
+	return true;
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set.  If the guest enables the MMU, we stop trapping the VM
@@ -354,6 +371,44 @@ static const struct coproc_reg cp15_regs[] = {
 	{ CRn( 7), CRm( 6), Op1( 0), Op2( 2), is32, access_dcsw},
 	{ CRn( 7), CRm(10), Op1( 0), Op2( 2), is32, access_dcsw},
 	{ CRn( 7), CRm(14), Op1( 0), Op2( 2), is32, access_dcsw},
+
+	/* TLBIALLIS */
+	{ CRn( 8), CRm( 3), Op1( 0), Op2( 0), is32, emulate_tlb_invalidate},
+	/* TLBIMVAIS */
+	{ CRn( 8), CRm( 3), Op1( 0), Op2( 1), is32, emulate_tlb_invalidate},
+	/* TLBIASIDIS */
+	{ CRn( 8), CRm( 3), Op1( 0), Op2( 2), is32, emulate_tlb_invalidate},
+	/* TLBIMVAAIS */
+	{ CRn( 8), CRm( 3), Op1( 0), Op2( 3), is32, emulate_tlb_invalidate},
+	/* TLBIMVALIS */
+	{ CRn( 8), CRm( 3), Op1( 0), Op2( 5), is32, emulate_tlb_invalidate},
+	/* TLBIMVAALIS */
+	{ CRn( 8), CRm( 3), Op1( 0), Op2( 7), is32, emulate_tlb_invalidate},
+	/* ITLBIALL */
+	{ CRn( 8), CRm( 5), Op1( 0), Op2( 0), is32, emulate_tlb_invalidate},
+	/* ITLBIMVA */
+	{ CRn( 8), CRm( 5), Op1( 0), Op2( 1), is32, emulate_tlb_invalidate},
+	/* ITLBIASID */
+	{ CRn( 8), CRm( 5), Op1( 0), Op2( 2), is32, emulate_tlb_invalidate},
+	/* DTLBIALL */
+	{ CRn( 8), CRm( 6), Op1( 0), Op2( 0), is32, emulate_tlb_invalidate},
+	/* DTLBIMVA */
+	{ CRn( 8), CRm( 6), Op1( 0), Op2( 1), is32, emulate_tlb_invalidate},
+	/* DTLBIASID */
+	{ CRn( 8), CRm( 6), Op1( 0), Op2( 2), is32, emulate_tlb_invalidate},
+	/* TLBIALL */
+	{ CRn( 8), CRm( 7), Op1( 0), Op2( 0), is32, emulate_tlb_invalidate},
+	/* TLBIMVA */
+	{ CRn( 8), CRm( 7), Op1( 0), Op2( 1), is32, emulate_tlb_invalidate},
+	/* TLBIASID */
+	{ CRn( 8), CRm( 7), Op1( 0), Op2( 2), is32, emulate_tlb_invalidate},
+	/* TLBIMVAA */
+	{ CRn( 8), CRm( 7), Op1( 0), Op2( 3), is32, emulate_tlb_invalidate},
+	/* TLBIMVAL */
+	{ CRn( 8), CRm( 7), Op1( 0), Op2( 5), is32, emulate_tlb_invalidate},
+	/* TLBIMVAAL */
+	{ CRn( 8), CRm( 7), Op1( 0), Op2( 7), is32, emulate_tlb_invalidate},
+
 	/*
 	 * L2CTLR access (guest wants to know #CPUs).
 	 */
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index 7296528..cfa7cf6 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -61,3 +61,36 @@ void __hyp_text __kvm_flush_vm_context(void)
 	write_sysreg(0, ICIALLUIS);
 	dsb(ish);
 }
+
+static void __hyp_text __switch_to_guest_regime(struct kvm *kvm)
+{
+	write_sysreg(kvm->arch.vttbr, VTTBR);
+	isb();
+}
+
+static void __hyp_text __switch_to_host_regime(void)
+{
+	write_sysreg(0, VTTBR);
+}
+
+void __hyp_text
+__kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 opcode, u64 regval)
+{
+	kvm = kern_hyp_va(kvm);
+
+	__switch_to_guest_regime(kvm);
+
+	/*
+	 *  TLB maintenance operations are broadcast to
+	 *  inner-shareable domain when HCR_FB is set (default for
+	 *  KVM).
+	 *
+	 *  Nuke all Stage 1 TLB entries for the VM. This will kill
+	 *  performance but it's always safe to do as we don't leave
+	 *  behind any strays in the TLB
+	 */
+	write_sysreg(0, TLBIALLIS);
+	isb();
+
+	__switch_to_host_regime();
+}
-- 
2.9.3
