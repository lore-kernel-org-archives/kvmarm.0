Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078BEC43219
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D9E4B7F8;
	Sat, 12 Nov 2022 03:17:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gRmqVgvPm5yp; Sat, 12 Nov 2022 03:17:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78B284B850;
	Sat, 12 Nov 2022 03:17:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3694B78C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Eu6E+iGUKKE for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:35 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B3684B82E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:35 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 h185-20020a636cc2000000b0046fc6e0065dso3510510pgc.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=kZdiCwoQUslLMvUfPoBcctbbagIcTEzETvPskUUEe+LlHR6r4BAxbZuv98gF5ve4Dl
 lSbdoBVJXjmWuabH0vFmJpKD78i3Iks6OR6WAxPwO0kL7sQ6YdoaDSiuZldFYsK2R2wE
 28Mn4I7Rw1LrtXjUORtWu1KAL71SyVcidSCtRSTAv4IFlO69lLGgAjL3EMjEO1JlB/VX
 XIbIB6Q73Q1vWuUM9ZuOLsZb5L+kLNoiXyAu7jAdDnv31cLm9lT3/ntFxgyXgAaIMre9
 C084phpkW0tYe6KMWnXcFOyTwLtqKH0f0uu7nMZWQtVVsvKyggPvB1pRwFBB8jwC88dY
 9Pfg==
X-Gm-Message-State: ANoB5plaOuQXw9XSQCdyq94ly76oKdOLCGo5E0knpLTsfZf6iqszd4s/
 RbpvRb17lQOgzQ6jJLQROTyuEKhA/SKebw==
X-Google-Smtp-Source: AA0mqf4lNmUCe4aprIz7lgD/9R+sooPtJqmagrCa4wPvpU7RVYrs0Whp+W9dnK4MbP2UeTGIJf0U7NvtOtUO4g==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:8dcd:0:b0:56c:674a:16f0 with SMTP id
 j13-20020aa78dcd000000b0056c674a16f0mr6285637pfr.10.1668241054624; Sat, 12
 Nov 2022 00:17:34 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:12 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-11-ricarkol@google.com>
Subject: [RFC PATCH 10/12] KVM: arm64: Open-code
 kvm_mmu_write_protect_pt_masked()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
