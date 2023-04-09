Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E6A184F
	for <kvmarm@lists.linux.dev>; Sun,  9 Apr 2023 06:30:21 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-632389f445cso199089b3a.0
        for <kvmarm@lists.linux.dev>; Sat, 08 Apr 2023 23:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021821; x=1683613821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DAHpZ5VA0/88CNPtujqxSmY6+I/b85LKu7OPkhrJSbg=;
        b=q7TC4JTrKVBF9z1700EzmBQBjOFN1WWUIlEuAuZHPheN//5Bsh+yDnT3s/2aK6LmKp
         uKtDg7mQlcRsD4beWehNLIhXZB0Csd0ucWn+aqcn6E/2yGjb8+b8GLmYRu5i8hHtsUI8
         qraYa7RnUAotnGpEIDhAZAsiiYkRHOPLEbW1hURl9y9L6mGPB/yKYdtGgYgkYEJeVJPl
         hxgN+RbeYuYzO0ef/27AtkqzCUgoXmsqGKgVfYfzIpt+bX1FKB0NV5DU7RDS4UeZINEa
         JlAYtXJbD36G4s+s2phdtC23y88m0WdJw9/yutgC7U/FeOaELKOm+VUrGGeqEwh40WgC
         +OrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021821; x=1683613821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DAHpZ5VA0/88CNPtujqxSmY6+I/b85LKu7OPkhrJSbg=;
        b=xjft/4KroFUAktXwaOmiC0V/XmZt32lNjX6SdogsedN35a1t2HNE9F9r7FLtgePypy
         5xKw3YWsM51sIW51bBpN7aC12x0vn0PHwvLat8tMN6A9b+a+iBRLR9YnFZ9FVd+ys7rj
         wG9qZyB66jevap2/6gOctnfF3e14F+H+c90b+NfLMNix/wfBU9+2TxmuVNAFkrXnmNrp
         UPDzr6InTjESRwUbvQ9MTQQXFrP+nJ4cEQ2oNlBh02AxuZw8H71RaaKSJ2fycVg/soay
         po/1OK1lsxPUAJE/ldtxJgb1QmZp+ovR6MV8G78EvZjs4G4OaK1OYruFMoNJ9U40kuPb
         s1pQ==
X-Gm-Message-State: AAQBX9dBo0OJsu4gi2S7js1H6B76r2SmcrON8fTtpwAAfu4H8AVSZzX8
	wSozLjXO/5SUsUcRByDqcvXQgoriF4kthg==
X-Google-Smtp-Source: AKy350b92rK5WddPt/h3QXYZkckoE4xL9x4teub1YJzF0S7X6hRgcQUTVUbKlG3ZHvbzOrYaqUDWJmRSunnvsg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2185:b0:625:644c:65f2 with SMTP
 id h5-20020a056a00218500b00625644c65f2mr1653573pfi.3.1681021821610; Sat, 08
 Apr 2023 23:30:21 -0700 (PDT)
Date: Sun,  9 Apr 2023 06:29:58 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-12-ricarkol@google.com>
Subject: [PATCH v7 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the functionality of kvm_mmu_write_protect_pt_masked() into its
caller, kvm_arch_mmu_enable_log_dirty_pt_masked().  This will be used
in a subsequent commit in order to share some of the code in
kvm_arch_mmu_enable_log_dirty_pt_masked().

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index aaefabd8de89d..16fa24f761152 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1058,28 +1058,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	kvm_flush_remote_tlbs(kvm);
 }
 
-/**
- * kvm_mmu_write_protect_pt_masked() - write protect dirty pages
- * @kvm:	The KVM pointer
- * @slot:	The memory slot associated with mask
- * @gfn_offset:	The gfn offset in memory slot
- * @mask:	The mask of dirty pages at offset 'gfn_offset' in this memory
- *		slot to be write protected
- *
- * Walks bits set in mask write protects the associated pte's. Caller must
- * acquire kvm_mmu_lock.
- */
-static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-		struct kvm_memory_slot *slot,
-		gfn_t gfn_offset, unsigned long mask)
-{
-	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
-	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
-	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
-
-	stage2_wp_range(&kvm->arch.mmu, start, end);
-}
-
 /**
  * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
  *				   pages for memory slot
@@ -1109,17 +1087,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
 }
 
 /*
- * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
- * dirty pages.
+ * kvm_arch_mmu_enable_log_dirty_pt_masked() - enable dirty logging for selected pages.
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot associated with mask
+ * @gfn_offset:	The gfn offset in memory slot
+ * @mask:	The mask of pages at offset 'gfn_offset' in this memory
+ *		slot to enable dirty logging on
  *
- * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
- * enable dirty logging for them.
+ * Writes protect selected pages to enable dirty logging for them. Caller must
+ * acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		gfn_t gfn_offset, unsigned long mask)
 {
-	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.40.0.577.gac1e443424-goog

