From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 49/55] KVM: arm64: Fixes to toggle_cache for nesting
Date: Mon,  9 Jan 2017 01:24:45 -0500
Message-ID: <1483943091-1364-50-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F7440669
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tka4gfIas5ui for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:55 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87AE44069A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:52 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5l5006197
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:34 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 2BD8F7E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:34 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 0FF6D7E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:34 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QXnv057923
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:33 -0500
Received: by mail-qk0-f199.google.com with SMTP id t84so100998870qke.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:33 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

So far we were flushing almost the entire universe whenever a VM would
load/unload the SCTLR_EL1 and the two versions of that register had
different MMU enabled settings.  This turned out to be so slow that it
prevented forward progress for a nested VM, because a scheduler timer
tick interrupt would always be pending when we reached the nested VM.

To avoid this problem, we consider the SCTLR_EL2 when evaluating if
caches are on or off when entering virtual EL2 (because this is the
value that we end up shadowing onto the hardware EL1 register).

We also reduce the scope of the flush operation to only flush shadow
stage 2 page table state of the particular VCPU toggling the caches
instead of the shadow stage 2 state of all possible VCPUs.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/kvm/mmu.c               | 31 ++++++++++++++++++++++++++++++-
 arch/arm64/include/asm/kvm_mmu.h |  7 ++++++-
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 68fc8e8..344bc01 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -422,6 +422,35 @@ static void stage2_flush_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+/**
+ * Same as above but only flushed shadow state for specific vcpu
+ */
+static void stage2_flush_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int idx;
+	struct kvm_nested_s2_mmu __maybe_unused *nested_mmu;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	slots = kvm_memslots(kvm);
+	kvm_for_each_memslot(memslot, slots)
+		stage2_flush_memslot(&kvm->arch.mmu, memslot);
+
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+	list_for_each_entry_rcu(nested_mmu, &vcpu->kvm->arch.nested_mmu_list,
+				list) {
+		kvm_stage2_flush_range(&nested_mmu->mmu, 0, KVM_PHYS_SIZE);
+	}
+#endif
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 static void clear_hyp_pgd_entry(pgd_t *pgd)
 {
 	pud_t *pud_table __maybe_unused = pud_offset(pgd, 0UL);
@@ -2074,7 +2103,7 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 	 * Clean + invalidate does the trick always.
 	 */
 	if (now_enabled != was_enabled)
-		stage2_flush_vm(vcpu->kvm);
+		stage2_flush_vcpu(vcpu);
 
 	/* Caches are now on, stop trapping VM ops (until a S/W op) */
 	if (now_enabled)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 2086296..7754f3e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -241,7 +241,12 @@ static inline bool kvm_page_empty(void *ptr)
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
+	u32 mode = vcpu->arch.ctxt.gp_regs.regs.pstate & PSR_MODE_MASK;
+
+	if (mode != PSR_MODE_EL2h && mode != PSR_MODE_EL2t)
+		return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
+	else
+		return (vcpu_el2_reg(vcpu, SCTLR_EL2) & 0b101) == 0b101;
 }
 
 static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
-- 
1.9.1
