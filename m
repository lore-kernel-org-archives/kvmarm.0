From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 26/31] KVM: arm64: Emulate TLBI ALLE1(IS)
Date: Mon,  2 Oct 2017 22:11:08 -0500
Message-ID: <1507000273-3735-24-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F23F49D67
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hQW11tBrsga1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:49 -0400 (EDT)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com
 [209.85.214.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84CE749D2F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:48 -0400 (EDT)
Received: by mail-it0-f41.google.com with SMTP id m123so10019050ita.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:12:08 -0700 (PDT)
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

TLBI ALLE1(IS) instruction invalidates all EL1&0 regime stage 1 and 2
TLB entries (on all PEs in the same Inner Shareable domain). To emulate
these instructions, we first need to clear all the mappings in the
shadow page tables since executing those instructions implies the change
of mappings in the stage 2 page tables maintained by the guest
hypervisor.  We then need to invalidate all EL1&0 regime stage 1 and 2
TLB entries of all VMIDs, which are assigned by the host hypervisor, for
this VM.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a1ae8fb..5a82de9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1795,6 +1795,31 @@ static bool handle_vae2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+
+	if (vcpu->kvm->arch.mmu.vmid.vmid_gen) {
+		/*
+		 * Invalidate the stage 1 and 2 TLB entries for the host OS
+		 * in a VM only if there is one.
+		 */
+		kvm_call_hyp(__kvm_tlb_flush_vmid, vttbr);
+	}
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	/*
+	 * Clear all mappings in the shadow page tables and invalidate the stage
+	 * 1 and 2 TLB entries via kvm_tlb_flush_vmid_ipa().
+	 */
+	kvm_nested_s2_clear(vcpu->kvm);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1880,14 +1905,14 @@ static bool handle_vae2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2IS, handle_alle2is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VAE2IS, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE1IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE1IS, handle_alle1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VALE2IS, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2E1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2, handle_alle2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VAE2, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_ALLE1, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_ALLE1, handle_alle1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VALE2, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VMALLS12E1, NULL, NULL),
 };
-- 
1.9.1
