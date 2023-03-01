Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40948BEE
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 21:09:49 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id r13-20020a25760d000000b0096c886848c9so1664185ybc.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 13:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3PeO1BbXZoKnKTqikGOhua/uQ/4m0gR3AAlD74X8P8s=;
        b=A4lJPfSQKRYCnc/9amFiPPf7+Bjeka6AhKG66HJhpw94GfrOuYOKqQV9yQu/j60gVu
         VjS3ACS1WbmzP6AZ6BoI1nnf/7IbPY1UAv9vTxYRcjhNTfs6VUlwbBrVFunEoNgOQhD3
         g8bLbR4d30xvSiEudDHlT4qdpvXTpbCN9tU42JHwEwW19HPKsYDYXnT5wGE3mNFoqkuS
         Z7B2i5Npz5xZFdajfQ1Y/LRd5YwvFI9sBhA5SIEREIw6O770ukE47IlsJ8AilnaDV9fg
         BlACSnxqtrQkpP8EltNz1I0jZeXjRdtow6c+aaLGW1Yv+YBl+A52NMBqk57t4JyXMF8m
         sHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3PeO1BbXZoKnKTqikGOhua/uQ/4m0gR3AAlD74X8P8s=;
        b=4mTuQx2406ovVtH6zUl+Ej9d00C81VGry3/VFfL0J9O5qVVoE6TzF/bT9kw15/5vWa
         yzOLR5ye2eisJg+K12lk7Jr4VMFoKGG12ZkAlgarfE1BKjaSdslyKmR/GG3M3Tb6nr3o
         Wn+d3URS2YvdWt3LjQimdSz/z2TnheyP048FWYsM1DEzqVl/J28hiKQw0QvM2UL0tz2N
         pS8e2Ok8sYgZUvzrbYfLTJrDK4T0r1XritYPTUvaI5tIVpwMXgWVZGyA/XbZcuxxKQJt
         cLzYBaenBHdw/3h4ljXbhIh+DMYQTBZbPHZndizHWLHukaOVd4jX+JtuLojn4ljc2Vaw
         br/g==
X-Gm-Message-State: AO0yUKUos1PFMqiDk8/hFSX5Or9YaX5sCF8luDF0JaXnM1TBW9LtmaSB
	XHnShCa44p3rB0CXm+wgobyRsYtPP7AnDQ==
X-Google-Smtp-Source: AK7set8JGzUU9TcO158ugv/5oUa4xXqtNymTEf1o1Wa7afCjiaOVkQdrKBvIE7MHjEBH7Kug5DMgAIdmTaWuSg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7442:0:b0:533:9ba2:2661 with SMTP id
 p63-20020a817442000000b005339ba22661mr14ywc.41.1677704988874; Wed, 01 Mar
 2023 13:09:48 -0800 (PST)
Date: Wed,  1 Mar 2023 21:09:26 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-11-ricarkol@google.com>
Subject: [PATCH v5 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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
2.39.2.722.g9855ee24e9-goog

