From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 27/31] KVM: arm64: Emulate TLBI VMALLS12E1(IS)
 instruction
Date: Mon,  2 Oct 2017 22:11:09 -0500
Message-ID: <1507000273-3735-25-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B395049D64
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lp-w2evn86F1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:53 -0400 (EDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com
 [209.85.214.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72B0649D67
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:50 -0400 (EDT)
Received: by mail-it0-f44.google.com with SMTP id y138so10005995itc.5
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

Based on the same principle as TLBI ALLE1(IS) emulation, we clear the
mappings in the shadow stage-2 page tables and invalidate TLB entries.
But this time we do it only for the current VMID from the guest
hypervisor's perspective, not for all VMIDs.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/kvm_mmu.h |  2 ++
 arch/arm64/kvm/mmu-nested.c      | 23 +++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        | 33 +++++++++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 239bb89..6681be1 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -345,6 +345,8 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 void kvm_nested_s2_clear(struct kvm *kvm);
 void kvm_nested_s2_flush(struct kvm *kvm);
 int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
+bool kvm_nested_s2_clear_curr_vmid(struct kvm_vcpu *vcpu, phys_addr_t start,
+				   u64 size);
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index a440d7b..2189f2b 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -349,6 +349,29 @@ static struct kvm_nested_s2_mmu *lookup_nested_mmu(struct kvm_vcpu *vcpu,
 	return NULL;
 }
 
+/*
+ * Clear mappings in the shadow stage 2 page tables for the current VMID from
+ * the perspective of the guest hypervisor.
+ * This function expects kvm->mmu_lock to be held.
+ */
+bool kvm_nested_s2_clear_curr_vmid(struct kvm_vcpu *vcpu, phys_addr_t start,
+				   u64 size)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	u64 vttbr = vcpu_sys_reg(vcpu, VTTBR_EL2);
+
+	/*
+	 * Look up a mmu that is used for the current VMID from the guest
+	 * hypervisor's view.
+	 */
+	nested_mmu = lookup_nested_mmu(vcpu, vttbr);
+	if (!nested_mmu)
+		return false;
+
+	kvm_unmap_stage2_range(vcpu->kvm, &nested_mmu->mmu, start, size);
+	return true;
+}
+
 /**
  * create_nested_mmu - create mmu for the given virtual VMID
  *
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5a82de9..5fd47ad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1820,6 +1820,35 @@ static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				const struct sys_reg_desc *r)
+{
+	u64 vttbr;
+	struct kvm_s2_mmu *mmu;
+	bool ret;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	/*
+	 * Clear mappings in the shadow page tables and invalidate the stage
+	 * 1 and 2 TLB entries via kvm_tlb_flush_vmid_ipa() for the current
+	 * VMID.
+	 */
+	ret = kvm_nested_s2_clear_curr_vmid(vcpu, 0, KVM_PHYS_SIZE);
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
+		kvm_call_hyp(__kvm_tlb_flush_vmid, vttbr);
+	}
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -1907,14 +1936,14 @@ static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	SYS_INSN_TO_DESC(TLBI_VAE2IS, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1IS, handle_alle1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VALE2IS, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VMALLS12E1IS, handle_vmalls12e1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2E1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_IPAS2LE1, NULL, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE2, handle_alle2, NULL),
 	SYS_INSN_TO_DESC(TLBI_VAE2, handle_vae2, NULL),
 	SYS_INSN_TO_DESC(TLBI_ALLE1, handle_alle1is, NULL),
 	SYS_INSN_TO_DESC(TLBI_VALE2, handle_vae2, NULL),
-	SYS_INSN_TO_DESC(TLBI_VMALLS12E1, NULL, NULL),
+	SYS_INSN_TO_DESC(TLBI_VMALLS12E1, handle_vmalls12e1is, NULL),
 };
 
 #define reg_to_match_value(x)						\
-- 
1.9.1
