Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7A27B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:41:07 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-52eb75aeecdso219999047b3.13
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nrtMx6TrkFkoW1XsVkkCg0nYPFSgGL/zgAXXLCUbxoA=;
        b=olqOFUaKy4fzih8FETukMjC7YoFXtFwExUociwOkJSBqpLEiNZ1Aq2yXJWXMQ189Ol
         I8aLOo3tkih7ZMYi6trp+YU21MiFBxCY6rWj2Lwpqf3gJV2KErIAZzcdY8Ru7Q+RMdEI
         cYP21yCivjkC39Rkaa+oF94oHTukfK40WO8T1Ckw538QslXXwJKumpiutEuuiM1AnSeM
         qmSRensyU0eLpbnAVormcGmsAgEvkHtLd1cqQPz7fbuJTMbG4nugqc6RPRBKIi9ejhxh
         F0eJ9BouN8WKDh8c4pECQGX/XKFERnITTFPFLeWGh5fsAKGfCDXLXVIe28lz29gjXgTm
         1eRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nrtMx6TrkFkoW1XsVkkCg0nYPFSgGL/zgAXXLCUbxoA=;
        b=1Fkh6BFqKDdNs3Z6kRGI3uceeFk4Ea+3NRokamJF+XaJ8ZwkTlwVGr0g/LptpLGGxP
         1X481ONWmCbcOEiqjy+84CGnTotg7YHDwDrBcwmdboMi2frThnrN1E6L/STFDdBQPELT
         uUMBnw3m5N/oM0A6NpgTtD69ztmYI2CeMZJrw+3lQgNq0Oh9Cb2PBLyDbZaDM6IGmYvI
         fZl/NQqFBnSo9SG55ljJH2WYkiZEFSa0kx4NnZ88wzdd9U3pPuVpByE0GiCcMOs1SliT
         26BQ/l4fr6tZLxYcYcFsi2C0fZ3+RhVnDnp61RVdR7I5Ci/0TvHDabCoqbVGCr1Wh/3j
         ImLQ==
X-Gm-Message-State: AO0yUKWkTlYQEGhlIU1KQr0apR2mTGTkBn01sQSVhLErRuVcEBtAHffs
	qvyhFqTlDLYjmQ3Dr+kFMXPi7rY505jlKQ==
X-Google-Smtp-Source: AK7set/+vFFUglB+7J7yLG0KP0XnkWAywvEniFOHVJyqqST56hjd8xD3AEZlFdgClBZ6tU6iBYFMuhAN4re0Tg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9392:0:b0:8ce:bfa1:a131 with SMTP id
 a18-20020a259392000000b008cebfa1a131mr528807ybm.215.1676482866741; Wed, 15
 Feb 2023 09:41:06 -0800 (PST)
Date: Wed, 15 Feb 2023 17:40:44 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-11-ricarkol@google.com>
Subject: [PATCH v3 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 20458251c85e..8e9d612dda00 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1056,28 +1056,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
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
@@ -1104,17 +1082,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
2.39.1.637.g21b0678d19-goog

