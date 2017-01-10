From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 4/9] arm: KVM: Handle trappable TLB instructions
Date: Tue, 10 Jan 2017 11:38:51 +0000
Message-ID: <20170110113856.7183-5-punit.agrawal@arm.com>
References: <20170110113856.7183-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D5D7405B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJ3WM3+glL4m for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 06:38:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87DE540430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 06:38:22 -0500 (EST)
In-Reply-To: <20170110113856.7183-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

It is possible to enable selective trapping of guest TLB maintenance
instructions executed in lower privilege levels to HYP mode. This
feature can be used to monitor guest TLB operations.

Add support to emulate the TLB instructions when their execution traps
to hyp mode. Also keep track of the number of emulated operations.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h  |  2 ++
 arch/arm/include/asm/kvm_host.h |  1 +
 arch/arm/kvm/coproc.c           | 56 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/tlb.c          | 33 ++++++++++++++++++++++++
 4 files changed, 92 insertions(+)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 8ef05381984b..782034a5a3c3 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -67,6 +67,8 @@ extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 opcode,
+					 u64 regval);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d5423ab15ed5..26f0c8a0b790 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -205,6 +205,7 @@ struct kvm_vcpu_stat {
 	u64 mmio_exit_user;
 	u64 mmio_exit_kernel;
 	u64 exits;
+	u64 tlb_invalidate;
 };
 
 #define vcpu_cp15(v,r)	(v)->arch.ctxt.cp15[r]
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 3e5e4194ef86..b978b0bf211e 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -205,6 +205,24 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
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
+	++vcpu->stat.tlb_invalidate;
+
+	return true;
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set.  If the guest enables the MMU, we stop trapping the VM
@@ -354,6 +372,44 @@ static const struct coproc_reg cp15_regs[] = {
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
index 6d810af2d9fd..d2b86100d1bb 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -76,3 +76,36 @@ void __hyp_text __kvm_flush_vm_context(void)
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
2.11.0
