From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 24/31] KVM: arm64: Emulate TLBI ALLE2(IS) instruction
Date: Mon,  2 Oct 2017 22:11:06 -0500
Message-ID: <1507000273-3735-22-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B170949D3D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id clJCW+BJmjai for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:47 -0400 (EDT)
Received: from mail-it0-f49.google.com (mail-it0-f49.google.com
 [209.85.214.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C43649D2B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:46 -0400 (EDT)
Received: by mail-it0-f49.google.com with SMTP id 85so9735952ith.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:05 -0700 (PDT)
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

Emulate TLBI ALLE2(IS) instruction executed in the virtual EL2. Since we
emulate the virtual EL2 in the EL1, we invalidate EL1&0 regime stage 1
TLB entries with setting vttbr_el2 having the VMID of the virtual EL2.

Note that we are able to emulate TLBI ALLE2IS precisely by only
invalidating stage 1 TLB entries via TLBI VMALL1IS instruction, but to
make it simeple, we reuse the existing function, __kvm_tlb_flush_vmid(),
which invalidates both of stage 1 and 2 TLB entries.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7950ee0..90329b7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1747,6 +1747,37 @@ static bool handle_s12w(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return handle_s12(vcpu, p, r, true);
 }
 
+static bool handle_alle2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	u64 vttbr = kvm_get_vttbr(&mmu->el2_vmid, mmu);
+
+	/*
+	 * To emulate invalidating all EL2 regime stage 1 TLB entries,
+	 * invalidate EL1&0 regime stage 1 TLB entries with the virtual EL2's
+	 * VMID.
+	 */
+	kvm_call_hyp(__kvm_tlb_flush_local_vmid, vttbr);
+	return true;
+}
+
+static bool handle_alle2is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	u64 vttbr = kvm_get_vttbr(&mmu->el2_vmid, mmu);
+
+	/*
+	 * To emulate invalidating all EL2 regime stage 1 TLB entries for all
+	 * PEs, executing TLBI VMALLE1IS is enough. But reuse the existing
+	 * interface for the simplicity; invalidating stage 2 entries doesn't
+	 * affect the correctness.
+	 */
+	kvm_call_hyp(__kvm_tlb_flush_vmid, vttbr);
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1830,14 +1861,14 @@ static bool handle_s12w(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(AT_S12E0W, handle_s12w, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, NULL, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE2IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE2IS, handle_alle2is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VAE2IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_VALE2IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2E1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, NULL, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE2, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE2, handle_alle2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VAE2, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_VALE2, NULL, NULL),
-- 
1.9.1
