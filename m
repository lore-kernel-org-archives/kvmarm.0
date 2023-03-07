Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BA536E
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:15 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536c8bcae3bso123265827b3.2
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pxHXXFOzzPtwBytDTC3DJkgO49OCnlzta01APx3XRoY=;
        b=nj/c+LEQmDR3kTSgRRFj/Gf2yKA5uMA9WHuiQKtfyl0Cgt1idBG16QiUDxM3VOKJLW
         2QgLWoN42UOUUF/XJAIxdB0g5996QWHSl1b2EYqzH/Uc39menAy95Ls6YVr5Q4d9+FiQ
         nlJ6wGmYGtNEMWyfgGB8fYaEHGBL+j0ftq+rnrsIUcUT0c3ltL1Nx9FURFUMBMUZt6q6
         DbrCE5qRjl70S4SigIUvM6wNYgCEnXDYpdnnQrT5GdO84Xkr/ycK17e/96iP13EE5JQC
         n3IwZWYckEoV9HQII0A29MCIOXPjx6WfFgdrGTZcUZ86MDkWrCvGYtGZKnVnYrwdu4sF
         4TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxHXXFOzzPtwBytDTC3DJkgO49OCnlzta01APx3XRoY=;
        b=Mobb2+Q+CgKLwkjBjvYUUXhZZj4dh8+z8yizBvWzKej/OCr0/E4Ax82ARqHSNrjP9H
         2iXTgoOVR72dIpObAsW/gz1OnZtCFyrzuMd46GwZt6p2+GJxdZqUjJkrBkzUG8UwTxz9
         tT6mK8AmVmfkTiIorJ9sygOP9o767zXZq+hlMdS1f4RZVlO0JZuK1bQO7G5sqwBjC1AK
         DvSAs55XfzC0OEwrg5EbOp+It5pI0mF1typvAiIiBVMEgPAFuC2cBawg0+3KRK7RUgbt
         RZnhF+LGi0mfMthttZuJDJCUfVb89INaNRCV4bW0MfR4zRBcRIvkYWcQ+U8MB8GAasXd
         Vy0w==
X-Gm-Message-State: AO0yUKVi0z45zWkXkO3ROMw/2E1/AQUKwOQnGqYYVw9Y9Gx+cFxA1u/4
	eJ9LZRaUF4iLS5VmozvOrBm74MrYaTsRWw==
X-Google-Smtp-Source: AK7set/QPG5XWbwT+rXjxMWSbAg7uofBayxdEsaP1/+8DML9BhxrSFvP0atmTt2hqDzmmsQ06l4NdFlLgMdgug==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:151:b0:afa:d8b5:8e82 with SMTP
 id p17-20020a056902015100b00afad8b58e82mr5595371ybh.6.1678160774501; Mon, 06
 Mar 2023 19:46:14 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:53 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-11-ricarkol@google.com>
Subject: [PATCH v6 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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
index b1b8da5f8b6c..910aea6bbd1e 100644
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
2.40.0.rc0.216.gc4246ad0f0-goog

