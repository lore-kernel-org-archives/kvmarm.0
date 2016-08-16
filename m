From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC PATCH 6/7] arm64: KVM: Handle trappable TLB instructions
Date: Tue, 16 Aug 2016 11:45:11 +0100
Message-ID: <1471344312-26685-7-git-send-email-punit.agrawal@arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Punit Agrawal <punit.agrawal@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The ARMv8 architecture allows trapping of TLB maintenane instructions
from EL0/EL1 to higher exception levels. On encountering a trappable TLB
instruction in a guest, an exception is taken to EL2.

Add functionality to handle emulating the TLB instructions.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h |   1 +
 arch/arm64/kvm/hyp/tlb.c         | 146 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        |  81 ++++++++++++++++++++++
 arch/arm64/kvm/trace.h           |  16 +++++
 4 files changed, 244 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7561f63..1ac1cc3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -49,6 +49,7 @@ extern char __kvm_hyp_vector[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern void __kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 sysreg, u64 regval);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 4cda100..e0a0309 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -78,3 +78,149 @@ static void __hyp_text __tlb_flush_vm_context(void)
 }
 
 __alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
+
+/* Intentionally empty functions */
+static void __hyp_text __switch_to_hyp_role_nvhe(void) { }
+static void __hyp_text __switch_to_host_role_nvhe(void) { }
+
+static void __hyp_text __switch_to_hyp_role_vhe(void)
+{
+	u64 hcr = read_sysreg(hcr_el2);
+
+	hcr &= ~HCR_TGE;
+	write_sysreg(hcr, hcr_el2);
+}
+
+static void __hyp_text __switch_to_host_role_vhe(void)
+{
+	u64 hcr = read_sysreg(hcr_el2);
+
+	hcr |= HCR_TGE;
+	write_sysreg(hcr, hcr_el2);
+}
+
+static hyp_alternate_select(__switch_to_hyp_role,
+			    __switch_to_hyp_role_nvhe,
+			    __switch_to_hyp_role_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+static hyp_alternate_select(__switch_to_host_role,
+			    __switch_to_host_role_nvhe,
+			    __switch_to_host_role_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+static void __hyp_text __switch_to_guest_regime(struct kvm *kvm)
+{
+	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	__switch_to_hyp_role();
+	isb();
+}
+
+static void __hyp_text __switch_to_host_regime(void)
+{
+	__switch_to_host_role();
+	write_sysreg(0, vttbr_el2);
+}
+
+/*
+ *  AArch32 TLB maintenance instructions trapping to EL2
+ */
+#define TLBIALLIS			sys_reg(0, 0, 8, 3, 0)
+#define TLBIMVAIS			sys_reg(0, 0, 8, 3, 1)
+#define TLBIASIDIS			sys_reg(0, 0, 8, 3, 2)
+#define TLBIMVAAIS			sys_reg(0, 0, 8, 3, 3)
+#define TLBIMVALIS			sys_reg(0, 0, 8, 3, 5)
+#define TLBIMVAALIS			sys_reg(0, 0, 8, 3, 7)
+#define ITLBIALL			sys_reg(0, 0, 8, 5, 0)
+#define ITLBIMVA			sys_reg(0, 0, 8, 5, 1)
+#define ITLBIASID			sys_reg(0, 0, 8, 5, 2)
+#define DTLBIALL			sys_reg(0, 0, 8, 6, 0)
+#define DTLBIMVA			sys_reg(0, 0, 8, 6, 1)
+#define DTLBIASID			sys_reg(0, 0, 8, 6, 2)
+#define TLBIALL				sys_reg(0, 0, 8, 7, 0)
+#define TLBIMVA				sys_reg(0, 0, 8, 7, 1)
+#define TLBIASID			sys_reg(0, 0, 8, 7, 2)
+#define TLBIMVAA			sys_reg(0, 0, 8, 7, 3)
+#define TLBIMVAL			sys_reg(0, 0, 8, 7, 5)
+#define TLBIMVAAL			sys_reg(0, 0, 8, 7, 7)
+
+/*
+ * ARMv8 ARM: Table C5-4 TLB maintenance instructions
+ * (Ref: ARMv8 ARM C5.1 version: ARM DDI 0487A.j)
+ */
+#define TLBI_VMALLE1IS			sys_reg(1, 0, 8, 3, 0)
+#define TLBI_VAE1IS			sys_reg(1, 0, 8, 3, 1)
+#define TLBI_ASIDE1IS			sys_reg(1, 0, 8, 3, 2)
+#define TLBI_VAAE1IS			sys_reg(1, 0, 8, 3, 3)
+#define TLBI_VALE1IS			sys_reg(1, 0, 8, 3, 5)
+#define TLBI_VAALE1IS			sys_reg(1, 0, 8, 3, 7)
+#define TLBI_VMALLE1			sys_reg(1, 0, 8, 7, 0)
+#define TLBI_VAE1			sys_reg(1, 0, 8, 7, 1)
+#define TLBI_ASIDE1			sys_reg(1, 0, 8, 7, 2)
+#define TLBI_VAAE1			sys_reg(1, 0, 8, 7, 3)
+#define TLBI_VALE1			sys_reg(1, 0, 8, 7, 5)
+#define TLBI_VAALE1			sys_reg(1, 0, 8, 7, 7)
+
+void __hyp_text
+__kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 sys_op, u64 regval)
+{
+	kvm = kern_hyp_va(kvm);
+
+	/*
+	 * Switch to the guest before performing any TLB operations to
+	 * target the appropriate VMID
+	 */
+	__switch_to_guest_regime(kvm);
+
+	/*
+	 *  TLB maintenance operations broadcast to inner-shareable
+	 *  domain when HCR_FB is set (default for KVM).
+	 */
+	switch (sys_op) {
+	case TLBIALL:
+	case TLBIALLIS:
+	case ITLBIALL:
+	case DTLBIALL:
+	case TLBI_VMALLE1:
+	case TLBI_VMALLE1IS:
+		__tlbi(vmalle1is);
+		break;
+	case TLBIMVA:
+	case TLBIMVAIS:
+	case ITLBIMVA:
+	case DTLBIMVA:
+	case TLBI_VAE1:
+	case TLBI_VAE1IS:
+		__tlbi(vae1is, regval);
+		break;
+	case TLBIASID:
+	case TLBIASIDIS:
+	case ITLBIASID:
+	case DTLBIASID:
+	case TLBI_ASIDE1:
+	case TLBI_ASIDE1IS:
+		__tlbi(aside1is, regval);
+		break;
+	case TLBIMVAA:
+	case TLBIMVAAIS:
+	case TLBI_VAAE1:
+	case TLBI_VAAE1IS:
+		__tlbi(vaae1is, regval);
+		break;
+	case TLBIMVAL:
+	case TLBIMVALIS:
+	case TLBI_VALE1:
+	case TLBI_VALE1IS:
+		__tlbi(vale1is, regval);
+		break;
+	case TLBIMVAAL:
+	case TLBIMVAALIS:
+	case TLBI_VAALE1:
+	case TLBI_VAALE1IS:
+		__tlbi(vaale1is, regval);
+		break;
+	}
+	isb();
+
+	__switch_to_host_regime();
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b0b225c..ca0b80f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -790,6 +790,18 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool emulate_tlb_invalidate(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				  const struct sys_reg_desc *r)
+{
+	u32 opcode = sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	kvm_call_hyp(__kvm_emulate_tlb_invalidate,
+		     vcpu->kvm, opcode, p->regval);
+	trace_kvm_tlb_invalidate(*vcpu_pc(vcpu), opcode);
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -849,6 +861,35 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b01), Op1(0b000), CRn(0b0111), CRm(0b1110), Op2(0b010),
 	  access_dcsw },
 
+	/*
+	 * ARMv8 ARM: Table C5-4 TLB maintenance instructions
+	 * (Ref: ARMv8 ARM C5.1 version: ARM DDI 0487A.j)
+	 */
+	/* TLBI VMALLE1IS */
+	{ Op0(1), Op1(0), CRn(8), CRm(3), Op2(0), emulate_tlb_invalidate },
+	/* TLBI VAE1IS */
+	{ Op0(1), Op1(0), CRn(8), CRm(3), Op2(1), emulate_tlb_invalidate },
+	/* TLBI ASIDE1IS */
+	{ Op0(1), Op1(0), CRn(8), CRm(3), Op2(2), emulate_tlb_invalidate },
+	/* TLBI VAAE1IS */
+	{ Op0(1), Op1(0), CRn(8), CRm(3), Op2(3), emulate_tlb_invalidate },
+	/* TLBI VALE1IS */
+	{ Op0(1), Op1(0), CRn(8), CRm(3), Op2(5), emulate_tlb_invalidate },
+	/* TLBI VAALE1IS */
+	{ Op0(1), Op1(0), CRn(8), CRm(3), Op2(7), emulate_tlb_invalidate },
+	/* TLBI VMALLE1 */
+	{ Op0(1), Op1(0), CRn(8), CRm(7), Op2(0), emulate_tlb_invalidate },
+	/* TLBI VAE1 */
+	{ Op0(1), Op1(0), CRn(8), CRm(7), Op2(1), emulate_tlb_invalidate },
+	/* TLBI ASIDE1 */
+	{ Op0(1), Op1(0), CRn(8), CRm(7), Op2(2), emulate_tlb_invalidate },
+	/* TLBI VAAE1 */
+	{ Op0(1), Op1(0), CRn(8), CRm(7), Op2(3), emulate_tlb_invalidate },
+	/* TLBI VALE1 */
+	{ Op0(1), Op1(0), CRn(8), CRm(7), Op2(5), emulate_tlb_invalidate },
+	/* TLBI VAALE1 */
+	{ Op0(1), Op1(0), CRn(8), CRm(7), Op2(7), emulate_tlb_invalidate },
+
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
 	/* MDCCINT_EL1 */
@@ -1337,6 +1378,46 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 7), CRm(10), Op2( 2), access_dcsw },
 	{ Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },
 
+	/*
+	 * TLB operations
+	 */
+	/* TLBIALLIS */
+	{ Op1( 0), CRn( 8), CRm( 3), Op2( 0), emulate_tlb_invalidate},
+	/* TLBIMVAIS */
+	{ Op1( 0), CRn( 8), CRm( 3), Op2( 1), emulate_tlb_invalidate},
+	/* TLBIASIDIS */
+	{ Op1( 0), CRn( 8), CRm( 3), Op2( 2), emulate_tlb_invalidate},
+	/* TLBIMVAAIS */
+	{ Op1( 0), CRn( 8), CRm( 3), Op2( 3), emulate_tlb_invalidate},
+	/* TLBIMVALIS */
+	{ Op1( 0), CRn( 8), CRm( 3), Op2( 5), emulate_tlb_invalidate},
+	/* TLBIMVAALIS */
+	{ Op1( 0), CRn( 8), CRm( 3), Op2( 7), emulate_tlb_invalidate},
+	/* ITLBIALL */
+	{ Op1( 0), CRn( 8), CRm( 5), Op2( 0), emulate_tlb_invalidate},
+	/* ITLBIMVA */
+	{ Op1( 0), CRn( 8), CRm( 5), Op2( 1), emulate_tlb_invalidate},
+	/* ITLBIASID */
+	{ Op1( 0), CRn( 8), CRm( 5), Op2( 2), emulate_tlb_invalidate},
+	/* DTLBIALL */
+	{ Op1( 0), CRn( 8), CRm( 6), Op2( 0), emulate_tlb_invalidate},
+	/* DTLBIMVA */
+	{ Op1( 0), CRn( 8), CRm( 6), Op2( 1), emulate_tlb_invalidate},
+	/* DTLBIASID */
+	{ Op1( 0), CRn( 8), CRm( 6), Op2( 2), emulate_tlb_invalidate},
+	/* TLBIALL */
+	{ Op1( 0), CRn( 8), CRm( 7), Op2( 0), emulate_tlb_invalidate},
+	/* TLBIMVA */
+	{ Op1( 0), CRn( 8), CRm( 7), Op2( 1), emulate_tlb_invalidate},
+	/* TLBIASID */
+	{ Op1( 0), CRn( 8), CRm( 7), Op2( 2), emulate_tlb_invalidate},
+	/* TLBIMVAA */
+	{ Op1( 0), CRn( 8), CRm( 7), Op2( 3), emulate_tlb_invalidate},
+	/* TLBIMVAL */
+	{ Op1( 0), CRn( 8), CRm( 7), Op2( 5), emulate_tlb_invalidate},
+	/* TLBIMVAAL */
+	{ Op1( 0), CRn( 8), CRm( 7), Op2( 7), emulate_tlb_invalidate},
+
 	/* PMU */
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcnten },
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index 7fb0008..c4d577f 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -166,6 +166,22 @@ TRACE_EVENT(kvm_set_guest_debug,
 	TP_printk("vcpu: %p, flags: 0x%08x", __entry->vcpu, __entry->guest_debug)
 );
 
+TRACE_EVENT(kvm_tlb_invalidate,
+	TP_PROTO(unsigned long vcpu_pc, u32 opcode),
+	TP_ARGS(vcpu_pc, opcode),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, vcpu_pc)
+		__field(u32, opcode)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc = vcpu_pc;
+		__entry->opcode = opcode;
+	),
+
+	TP_printk("vcpu_pc=0x%16lx opcode=%08x", __entry->vcpu_pc, __entry->opcode)
+);
 
 #endif /* _TRACE_ARM64_KVM_H */
 
-- 
2.8.1
