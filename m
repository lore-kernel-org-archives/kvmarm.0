From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 25/31] KVM: arm64: Emulate TLBI VAE2* instrutions
Date: Mon,  2 Oct 2017 22:11:07 -0500
Message-ID: <1507000273-3735-23-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E40E649D31
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XNJc3M6o4auf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:48 -0400 (EDT)
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com
 [209.85.223.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B69849D26
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:47 -0400 (EDT)
Received: by mail-io0-f169.google.com with SMTP id h66so6432593ioh.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:07 -0700 (PDT)
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

Emulate TLBI VAE2* instruction executed in the virtual EL2. Based on the
same principle as TLBI ALLE2 instruction, we can simply emulate those
instructions by executing corresponding VAE1* instructions with the
virtual EL2's VMID assigned by the host hypervisor.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/kvm/hyp/tlb.c         | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        | 25 +++++++++++++++++++++----
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4bded9d..cd7fb85 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -55,6 +55,7 @@
 extern void __kvm_tlb_flush_vmid_ipa(u64 vttbr, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(u64 vttbr);
 extern void __kvm_tlb_flush_local_vmid(u64 vttbr);
+extern void __kvm_tlb_vae2(u64 vttbr, u64 va, u64 sys_encoding);
 
 extern void __kvm_at_insn(struct kvm_vcpu *vcpu, unsigned long vaddr,
 			  bool el2_regime, int sys_encoding);
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 680b960..bd8b92c 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -151,3 +151,31 @@ void __hyp_text __kvm_flush_vm_context(void)
 	asm volatile("ic ialluis" : : );
 	dsb(ish);
 }
+
+void __hyp_text __kvm_tlb_vae2(u64 vttbr, u64 va, u64 sys_encoding)
+{
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest()(vttbr);
+
+	/* Execute the EL1 version of TLBI VAE2* instruction */
+	switch (sys_encoding) {
+	case TLBI_VAE2IS:
+		__tlbi(vae1is, va);
+		break;
+	case TLBI_VALE2IS:
+		__tlbi(vale1is, va);
+		break;
+	case TLBI_VAE2:
+		__tlbi(vae1, va);
+		break;
+	case TLBI_VALE2:
+		__tlbi(vale1, va);
+		break;
+	default:
+		break;
+	}
+	dsb(nsh);
+	isb();
+
+	__tlb_switch_to_host()();
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 90329b7..a1ae8fb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1778,6 +1778,23 @@ static bool handle_alle2is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool handle_vae2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+		       const struct sys_reg_desc *r)
+{
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	u64 vttbr = kvm_get_vttbr(&mmu->el2_vmid, mmu);
+	int sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	/*
+	 * Based on the same principle as TLBI ALLE2 instruction emulation, we
+	 * emulate TLBI VAE2* instructions by executing corresponding TLBI VAE1*
+	 * instructions with the virtual EL2's VMID assigned by the host
+	 * hypervisor.
+	 */
+	kvm_call_hyp(__kvm_tlb_vae2, vttbr, p->regval, sys_encoding);
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1862,16 +1879,16 @@ static bool handle_alle2is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2IS, handle_alle2is, NULL),
-	SYS_INSN_TO_DESC(TLBI_VAE2IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VAE2IS, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1IS, NULL, NULL),
-	SYS_INSN_TO_DESC(TLBI_VALE2IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VALE2IS, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2E1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2, handle_alle2, NULL),
-	SYS_INSN_TO_DESC(TLBI_VAE2, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VAE2, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1, NULL, NULL),
-	SYS_INSN_TO_DESC(TLBI_VALE2, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VALE2, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VMALLS12E1, NULL, NULL),
 };
 
-- 
1.9.1
