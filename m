Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF0C0A3
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:41:11 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-52ecbe73389so192016477b3.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=StR+74krGGTgWPxrXAKcCJpxcExEyTLa2S1rKGKBE7U=;
        b=e6Gi4e+cbLeu66LwiTaPMhueVBhr7BlocGl5tGwiajFyh+p3K9pDGnZ7X+L2kYXHAh
         ivOD+xFuHrN1nRHA7Xp5erBkW+Mdc1IJRTYwIeBAgEawCx/8QkipQHzneBgBszdJO/tv
         o0IxXtl2iKUywfNfpCv6vQTGoZEjNW94ZAGvrDCtH+dhxPHwUQLjt8Pefby+D5Ja8AfG
         CiBoU5Dx5am+ou/zFIoVNNjUuEabrdRjAzb2JtWla/dR1S7WFUBh098MffV/c6ATbm5C
         LXIx88BxaVpA/hS3Py2NB/Ro2eTEs74sTVjqhu25Y9qu83rtaJJzngCGuxxAXK+8VjqH
         tpaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StR+74krGGTgWPxrXAKcCJpxcExEyTLa2S1rKGKBE7U=;
        b=FA8JLzTTdKFVdzFbzjZSbdhUQsbkqiI9rcGKOP9lmL8uzVp/xU+J4+zzrG3+SKjJJ3
         PpB4ZvEfF/jvsjV4DCfahugNPVT3PQZfAKOyGrFKAg5SYD+FLd40ZbGY1CaVCw395tOY
         P/thbDYGyVID41bZpzVxZaOFf1TWd9Izv7cHSATEmyKKNL5enckw9mut+b8XDRDHlFsT
         2oyzGVJODEtqrmrdwcMH6ZyifXogt5nwFN6Mw8ZeJahtQjdd5CiGTF6QaBoMbzaa7frc
         bPWrRvVYllteULZhUi1Q8lrNmYd5090++c/Kr4BBuU66TDIRCbB0A3sXJedu50jp2of+
         XE7w==
X-Gm-Message-State: AO0yUKX7Hzf6mB62UCxm5kVs9va0ooKcvDWR0aAUmYEw1Z1skUYsb/vU
	ZlLMuoYV2TYOOGoXzNqqXkdEswvk65ZVbA==
X-Google-Smtp-Source: AK7set9khod89pqa9EAzfAIMDU0IbaXhUFI+dxpKK1xXtGcDGKjv4aqEsEy5oFaUCRAykkKDZuf7tw4SGFw1ig==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:8c:0:b0:80b:a1c7:e81a with SMTP id
 b12-20020a5b008c000000b0080ba1c7e81amr347663ybp.253.1676482870226; Wed, 15
 Feb 2023 09:41:10 -0800 (PST)
Date: Wed, 15 Feb 2023 17:40:46 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-13-ricarkol@google.com>
Subject: [PATCH v3 12/12] KVM: arm64: Use local TLBI on permission relaxation
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

Broadcasted TLB invalidations (TLBI) are usually less performant than their
local variant. In particular, we observed some implementations that take
millliseconds to complete parallel broadcasted TLBIs.

It's safe to use local, non-shareable, TLBIs when relaxing permissions on a
PTE in the KVM case for a couple of reasons. First, according to the ARM
Arm (DDI 0487H.a D5-4913), permission relaxation does not need
break-before-make.  Second, KVM does not set the VTTBR_EL2.CnP bit, so each
PE has its own TLB entry for the same page. KVM could tolerate that when
doing permission relaxation (i.e., not having changes broadcasted to all
PEs).

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  4 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 10 ++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 54 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c       |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c       | 32 ++++++++++++++++++
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544..bb17b2ead4c7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -68,6 +68,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
@@ -225,6 +226,9 @@ extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
+extern void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
+					 phys_addr_t ipa,
+					 int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b..c6bf1e49ca93 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -125,6 +125,15 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
+static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
+	DECLARE_REG(int, level, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
+}
+
 static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -315,6 +324,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa_nsh),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f589..ef2b70587f93 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -109,6 +109,60 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
+				  phys_addr_t ipa, int level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(nshst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	/*
+	 * We could do so much better if we had the VA as well.
+	 * Instead, we invalidate Stage-2 for this IPA, and the
+	 * whole of Stage-1. Weep...
+	 */
+	ipa >>= 12;
+	__tlbi_level(ipas2e1, ipa, level);
+
+	/*
+	 * We have to ensure completion of the invalidation at Stage-2,
+	 * since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
+	 * the Stage-1 invalidation happened first.
+	 */
+	dsb(nsh);
+	__tlbi(vmalle1);
+	dsb(nsh);
+	isb();
+
+	/*
+	 * If the host is running at EL1 and we have a VPIPT I-cache,
+	 * then we must perform I-cache maintenance at EL2 in order for
+	 * it to have an effect on the guest. Since the guest cannot hit
+	 * I-cache lines allocated with a different VMID, we don't need
+	 * to worry about junk out of guest reset (we nuke the I-cache on
+	 * VMID rollover), but we do need to be careful when remapping
+	 * executable pages for the same guest. This can happen when KSM
+	 * takes a CoW fault on an executable page, copies the page into
+	 * a page that was previously mapped in the guest and then needs
+	 * to invalidate the guest view of the I-cache for that page
+	 * from EL1. To solve this, we invalidate the entire I-cache when
+	 * unmapping a page from a guest if we have a VPIPT I-cache but
+	 * the host is running at EL1. As above, we could do better if
+	 * we had the VA.
+	 *
+	 * The moral of this story is: if you have a VPIPT I-cache, then
+	 * you should be running with VHE enabled.
+	 */
+	if (icache_is_vpipt())
+		icache_inval_all_pou();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e2fb78398b3d..801ae328b66e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1148,7 +1148,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
 				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 24cef9b87f9e..e69da550cdc5 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -111,6 +111,38 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
+				  phys_addr_t ipa, int level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(nshst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	/*
+	 * We could do so much better if we had the VA as well.
+	 * Instead, we invalidate Stage-2 for this IPA, and the
+	 * whole of Stage-1. Weep...
+	 */
+	ipa >>= 12;
+	__tlbi_level(ipas2e1, ipa, level);
+
+	/*
+	 * We have to ensure completion of the invalidation at Stage-2,
+	 * since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
+	 * the Stage-1 invalidation happened first.
+	 */
+	dsb(nsh);
+	__tlbi(vmalle1);
+	dsb(nsh);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
-- 
2.39.1.637.g21b0678d19-goog

