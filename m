Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1537B
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:59:11 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id g5-20020a62e305000000b00593dc84b678so6746165pfh.18
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 08:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bcuhZaZfjdzxoj++f8hFmgmqHpfnylwDUPS0Pw8clPQ=;
        b=MInBsXbldMdDJwWtvpfnfFyFCrS23cE+ASyvEQ8FoOoGcTWFygbgofdsH5q5La6PMZ
         VUWqyoFVE77VHQcWst4hCiz6l1nfDPStWD9OTCK3VXYMljearuxhg1of2GBVm0cEWbf8
         Zk5LgdyXz0YsXeT0z+k9iibjRiqpfkDYWXhvJOFM2q7RrHVO1w5uiDlZUc7fXjMplsUQ
         5/R9GyzZaGCoNmtVkxkpXZFm7pflvCVW6+5LkV9wT1qJzTUOvPEncfgLVhKxvYOJWsrX
         wBf1P4ylR+Rla/bxprWC4or6kE0lloewAgHSfDP4O6hCs9k59d9TNary4Nd2MLwJra0c
         l7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bcuhZaZfjdzxoj++f8hFmgmqHpfnylwDUPS0Pw8clPQ=;
        b=MLk4u/HZA/ZlHuB7d28L+mBnPApSD7g/SYi8EDNssUq+I4KZyIdO0H+WpHa2kKIS1G
         bbMKXG7uNFB6zSxi4C/Xf55f5gpJyXf5S/BUw+623kqTUWkYiIubMCJmap0wHe8eeQZJ
         KvXBIOusKfxCa5ONLd/PH6/EKfrmNGpPuHMhL3NvMIj7nJbfk9dw6IRx5vozkg44XjDB
         M9mAgMugzmhqhq219hkefCdDbP57jpWJXkXbwEdjdMn/cqFQekoSJ5tvyoKIVETw8wwZ
         0/xgKXzPgpejZfRrgt4XIuXaI3pt5CWynpzxjPsG8h7sIPHhJiBTmbR7kRpbQA1SDAhu
         xhpg==
X-Gm-Message-State: AO0yUKVRK18kGxv20XYVdmUvs2s41xbf+ASf5N/Fr9isa75yKk/cVq5m
	+gm3eZJS7hQdxWW6rQM5S76XKmKYm7+BSQ==
X-Google-Smtp-Source: AK7set9Nl/4SZbvIylvDER1Y3w+aUZz91bVitx+VkfIqunHAOTb6TNcjgAKRaNOyA8sq9SV13N49sSXzl6b7tw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:ca11:b0:230:cff0:52ef with SMTP
 id x17-20020a17090aca1100b00230cff052efmr506917pjt.81.1675702751082; Mon, 06
 Feb 2023 08:59:11 -0800 (PST)
Date: Mon,  6 Feb 2023 16:58:49 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-11-ricarkol@google.com>
Subject: [PATCH v2 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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
index 73f8b3953f6a..f6fb2bdaab71 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1051,28 +1051,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
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
@@ -1099,17 +1077,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
2.39.1.519.gcb327c4b5f-goog

