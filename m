From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 28/31] KVM: arm64: Emulate TLBI IPAS2E1* instructions
Date: Mon,  2 Oct 2017 22:11:10 -0500
Message-ID: <1507000273-3735-26-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCB2549D2F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9KUyDY73NWC8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:53 -0400 (EDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com
 [209.85.214.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF41449D5C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:50 -0400 (EDT)
Received: by mail-it0-f46.google.com with SMTP id 85so9983191ith.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:10 -0700 (PDT)
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

Based on the same principle as TLBI ALLE1(IS) and TLBI VMALLS12E1(IS)
emulation, we clear the mappings in the shadow stage-2 page tables and
invalidate TLB entries. We do it only for one mapping for the current
VMID from the guest hypervisor's view.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5fd47ad..eb91f00 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1849,6 +1849,36 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	u64 vttbr;
+	struct kvm_s2_mmu *mmu;
+	bool ret;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	/*
+	 * Clear a mapping in the shadow page tables and invalidate the stage
+	 * 2 TLB entries via kvm_tlb_flush_vmid_ipa() for the current
+	 * VMID and the given ipa.
+	 */
+	ret = kvm_nested_s2_clear_curr_vmid(vcpu, p->regval, PAGE_SIZE);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (!ret) {
+		/*
+		 * Invalidate TLB entries explicitly for the case that the
+		 * current VMID is for the host OS in the VM; we don't manage
+		 * shadow stage 2 page tables for it.
+		 */
+		mmu = &vcpu->kvm->arch.mmu;
+		vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, vttbr, p->regval);
+	}
+
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1930,15 +1960,15 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(AT_S12E1W, handle_s12w, NULL),
 	SYS_INSN_TO_DESC(AT_S12E0R, handle_s12r, NULL),
 	SYS_INSN_TO_DESC(AT_S12E0W, handle_s12w, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, NULL, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2E1IS, handle_ipas2e1is, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, handle_ipas2e1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2IS, handle_alle2is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VAE2IS, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1IS, handle_alle1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VALE2IS, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, handle_vmalls12e1is, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2E1, NULL, NULL),
-	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2E1, handle_ipas2e1is, NULL),
+	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, handle_ipas2e1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2, handle_alle2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VAE2, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1, handle_alle1is, NULL),
-- 
1.9.1
