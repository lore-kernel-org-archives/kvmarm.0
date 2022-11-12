Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C691A42
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:35 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id o15-20020a17090aac0f00b00212e93524c0so6703164pjq.2
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zGg5qpt/N/L+7x9jBKqpcMeXFwv5fWMYVI5N+PjKgU=;
        b=F/QDe6+1BvTXnyFLOg8gmQXYeT1rQN+sOHZw5/jn/OIBg/ksieVuSU4RzXZqbOs6hn
         aNj63YtnreOXtjSpmZLavBBDWoKmI03HxKlfoMz3hB9W602bO1TYehJR+fIsGRF2s/zZ
         kx9eXb8+bZHkcyoh3xmjRsCjZJC8lYCvIdEXGhaFPLUysIDdId6lqbqIa6Zgm85IFCSZ
         rApV/opjPoYkVYAQjpoVccRv/EF5McPBadihotqfKUFYIuStVJxwmOk8b2kA3I/gnIYT
         O1Y+ZrnCEx6xISo+PAodbia8LsljVtUpxMEZUQLiK+M7/xgL1P5nctTNvIAmgDM2yXjf
         Ttdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zGg5qpt/N/L+7x9jBKqpcMeXFwv5fWMYVI5N+PjKgU=;
        b=57ob5g1lr9nWdSgJ3+VmXJe2u5s7OmQaSQQHOnRLbM7m9pSTNCwofO8e3X6eiEgdx8
         I2+uQRqhdmUfdoDl0owSVGWs6JZGf0PrUovrj5/dlpYqR4QoFw/jlj/wInYm4giPWghE
         GG8Jt9yLOvusiPEJSzo4tGgMY06uHQxph3bPr1lt2gvYgjh/NfesdM9eQKeLCmJIXEbX
         n8rna/GSb0yXda5ijCTkLVRfXj0zXH7ruksxQ62bOF98qiV7nE4ob08UljBDYwIaq4wB
         TrNenpBFRZpLShVrt4vRnrxkT2iKc1aUr1VoxeCZwTs5hOzQQ9lDkHmPK2MHkU06/xxN
         IS2w==
X-Gm-Message-State: ANoB5pn7lKdOSIEAAj+2hFVGVLqSZ1vbmeRzBYQA21F8yOcXrzZbUUkj
	P7KRaPpxFrF9MbQa8IyiEjABU0O5pcx8WA==
X-Google-Smtp-Source: AA0mqf4lNmUCe4aprIz7lgD/9R+sooPtJqmagrCa4wPvpU7RVYrs0Whp+W9dnK4MbP2UeTGIJf0U7NvtOtUO4g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:8dcd:0:b0:56c:674a:16f0 with SMTP id
 j13-20020aa78dcd000000b0056c674a16f0mr6285637pfr.10.1668241054624; Sat, 12
 Nov 2022 00:17:34 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:12 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-11-ricarkol@google.com>
Subject: [RFC PATCH 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081712.KDcufanV_iTYVewpamXcWuY2A7V2ONCCEdHA7P4UFso@z>

Move the functionality of kvm_mmu_write_protect_pt_masked() into its
caller, kvm_arch_mmu_enable_log_dirty_pt_masked().  This will be used in a
subsequent commit in order to share some of the code in
kvm_arch_mmu_enable_log_dirty_pt_masked().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f2753d9deb19..7881df411643 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1045,28 +1045,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
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
@@ -1091,17 +1069,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
2.38.1.431.g37b22c650d-goog

