Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23C3A42
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:37 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id t5-20020a5b07c5000000b006dfa2102debso981484ybq.4
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ei5KTNcwhvdEV4DEpNFWL2FLBtddGkRWDZ/PZs/pyI=;
        b=a19I5M6QD8ehxktbvDkxtPw0UrpG81hnIry+JL2VyC+pmJlCLjUTQU9D3tS4gRNcCU
         qdp/5z/jxiSnVMaqHsIyg8amm+Nl2PQ+GVBxqPMbV7Y+4Qel7yqwPcuWWOFzFhQZIN0R
         GYroxUY6ffo0v/rEOhQml+75jUUl6lAOZiTa2QnBE68tXsAFz0+PBWKHa+BOGDaZ5IER
         a11qT3xsYQfdwNbi3qNoxzKIkwtdV1D+8O1INKn/UsojFZXoTVb7znNF/s0uoMPeg2o6
         XqTzxzckjG64tlCy9itEM7wEL74IrzNod9jraA/KC4u6PP+bao/Vj3O8nlguA7aDZaUT
         2FZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ei5KTNcwhvdEV4DEpNFWL2FLBtddGkRWDZ/PZs/pyI=;
        b=MJU4hKn1ILu8k7HNJo4v/iMMBm34/pW+gkLeVzEF2O4Sne/823sp62s0Ajm/FrPkFX
         oRqDvcBNucLLP10tlhte6FTgCFV92kEzpgFj+jtRP9Surf4Wh9C0u44AV4S5391FnZe5
         +3pMVcZR6qKGR8A4GqQ8hCZYjLK1m7FPvMQ1vibHCopBHjk8uWdOF/BKrrytWr66cBr0
         GWY1miGHcWzrBbAcwigKP/221rNKqwq/ydb/HMalw20wxW5JroxuptWF/i4M/kfAs2ZP
         xlhgtEV2PalXvZb+mThzzn0VhqpAy1qxOn1u43qsnGkjbpzA/ZY7rbP843wCwSLYIcTS
         gnuQ==
X-Gm-Message-State: ANoB5plSaBYL8zaw4+HdGgMxE5YJ8KynyRNeDApNQ2mC4VEHSw0xBXAq
	q7Uqz8W5LEc/TqGOT2yg+BOSinZTNU0ddQ==
X-Google-Smtp-Source: AA0mqf76MOJIlJMgyK8SACjurwBgdmgD8UMbYjNn4NyBxOTE9EDQqi80GPLESjM3J7HUUAm7YnPRl075qddTHg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:50e:0:b0:6dd:657d:ffc8 with SMTP id
 14-20020a25050e000000b006dd657dffc8mr3797725ybf.269.1668241056148; Sat, 12
 Nov 2022 00:17:36 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:13 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-12-ricarkol@google.com>
Subject: [RFC PATCH 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081713.zvyRgszfuvrkoxsMDyWdmHqWOCVdDyzfYmUPnsXc7tY@z>

This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
which has the benefit of splitting the cost of splitting a memslot
across multiple ioctls.

Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.  And
do not split when enabling dirty logging if KVM_DIRTY_LOG_INITIALLY_SET
is set.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7881df411643..b8211d833cc1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1076,8 +1076,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
  * @mask:	The mask of pages at offset 'gfn_offset' in this memory
  *		slot to enable dirty logging on
  *
- * Writes protect selected pages to enable dirty logging for them. Caller must
- * acquire kvm->mmu_lock.
+ * Splits selected pages to PAGE_SIZE and then writes protect them to enable
+ * dirty logging for them. Caller must acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -1090,6 +1090,14 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * If initially-all-set mode is not set, then huge-pages were already
+	 * split when enabling dirty logging: no need to do it again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm) &&
+	    READ_ONCE(eager_page_split))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1474,10 +1482,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (fault_status == FSC_PERM && vma_pagesize == fault_granule)
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
-	else
+	else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, KVM_PGTABLE_WALK_SHARED);
+	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
@@ -1887,7 +1896,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
-		 * cache around for any of the other cases.
+		 * cache around for any of the other cases. Keeping the cache
+		 * is useful for succesive KVM_CLEAR_DIRTY_LOG calls, which is
+		 * not handled in this function.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
-- 
2.38.1.431.g37b22c650d-goog

