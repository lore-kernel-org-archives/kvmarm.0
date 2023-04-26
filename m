Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B41538F
	for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 17:23:52 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-b8bf9f09340so12581888276.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 10:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529831; x=1685121831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HI+oatUUv/hyWZVU9asMS8OgWec2vFlYNBnSZZ+827s=;
        b=E5HLyhsg4fh2rB7YS3IEvnXlYhe9NY8ZbQ3GtfZVmNqUwiadhxWogvENU2aWX0T8+J
         6bb6VHZZlF9V4h4Fpfag/sWQ16YjeK000UzmuNitWpVzU0+EOA63bEg86ntGy1Cr+o7c
         k/Tffx+4nZ9ZHxU9jnWTefJX5pbX4GwonrP30Jr08+uNeoj+LdTMBhW0++eQNaRQTAHf
         qVSOHR1Waon3yW9tGZv930mwJTQJ+aqu9qziRKO5mWy8bkLTAhRTSpy5lgC/QxBreaAD
         4OT9R7tZYDAbnc2T8FgyuT5jcS60nEag/NUZHrOd2vjbRTnxW8XSUrKMXfAyTZI/E7Ma
         ofRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529831; x=1685121831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HI+oatUUv/hyWZVU9asMS8OgWec2vFlYNBnSZZ+827s=;
        b=e4K7Vg4lwpBVzBifNxuYyhC3aog1b64W5SV6A5YVHG8QtvuhoFNl4sDsE2zySPUV6H
         BSWqlPUDNbBOdSrCciPiDU5JQN446/7GYtl4/r0CcKrZCswiPT06ZTbswYWyQXEko6hS
         qITGrobxg3nhRL4IrI4H9XzHlahJnl1sOZTvI2rokYJbxJJJnYI1rcxM7FP+D2qDo93h
         a+JOEzx/Y9N24TCncJT2uTfQjUGCmbzje0dM5aEf6nK5RY0h4Rhkl03OqFNr5teSVR5h
         0T4yR6964K3jy6XeMP9WvMDSBBG7w7eE/PunZS4A1+WegaP3ogw3qq6GEhdBE38oBBkZ
         cjmQ==
X-Gm-Message-State: AAQBX9eFsSYGAolIZPN0Hp0bF73RXh4vQ9ajmg80FG8vL4G7lg1H4aEz
	zdPb+AkpmAS1SlRP74OxxxsBySVvOXwJ6w==
X-Google-Smtp-Source: AKy350aXoicyAxjftzI+FFzRq6Casq3GZjrNkpXiWTgnB23i+RxaEm45FQuhnswIDdXV8awskgaT4XlGiZA2Kw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d013:0:b0:b99:4473:ed93 with SMTP id
 h19-20020a25d013000000b00b994473ed93mr6748483ybg.4.1682529831436; Wed, 26 Apr
 2023 10:23:51 -0700 (PDT)
Date: Wed, 26 Apr 2023 17:23:28 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-11-ricarkol@google.com>
Subject: [PATCH v8 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4256c4a307531..835e4b8f4e5c3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1059,28 +1059,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
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
@@ -1110,17 +1088,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
2.40.1.495.gc816e09b53d-goog

