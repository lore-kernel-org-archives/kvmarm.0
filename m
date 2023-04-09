Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E7184F
	for <kvmarm@lists.linux.dev>; Sun,  9 Apr 2023 06:30:23 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id m21-20020a17090ab79500b002401201f1f9so1642223pjr.2
        for <kvmarm@lists.linux.dev>; Sat, 08 Apr 2023 23:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021823; x=1683613823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t9rdDM0DIHaJA1wTPBjn9eVH40DD8OG4+XbeMa8HFig=;
        b=RKxUOB3y7sFWAACxhdDtnYlSmJsZekw+A8rGo8ThBPr9MqCSHcpYLbxIcFIbz+OFWm
         D34DLtaHrSki64Q2UBRZsBC2H3lsa1jM52NQX48I4phlQzdYNucEwlJ1Q+o9hMPBjn6P
         AacxQXGuVAKeG1xPKPX/MZq7XRtjlRM85dDHQvH541BC4Odc7LrnqQ0o5hD4W4qcSgG8
         ZZYQvSl0SQ5OpQJYGhY/9ZPcWOuvRvoE35OnnyNtI9yFXAKdBUMvOcXUW/zSoYH6m4Om
         ErkMfxyRsggpukJOEPHn2yQwq833yYgCWy3flZwjuJ52Oj+cu9UNGcueaFX6p0oer4NC
         pbQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021823; x=1683613823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t9rdDM0DIHaJA1wTPBjn9eVH40DD8OG4+XbeMa8HFig=;
        b=Y5jCnGhBRT/6SJOHkaYU7ovhZJWcVjZqH5SbQZb+Ll5FGSytqgUhK4ILdPO7PST7Hx
         W7cN+A1pBK2+kssbmHi1PYRzE7VY71N05eEIGV/7Qf9mOL26xw8eeawJlrYwhedIf0Kf
         i4wyI/3nlXHBHLWKUWnnh6NP5GekIV6J8T+FJ9BfweYyzC7Ox+CEd1k34thhO1W0YfDf
         dW6oIUYm4mdsXqJMGh97gB6QBFEv2mJ71y4pJeSwdOjnivBszNiP8Kz10WTjgQOVDS0T
         oVsjVcA6iuJCqFLrqH/38fJNPHnsOiBFDxT7wWD4nNt543mZ4Wmga2lrkA35tsK6yXqp
         YXvQ==
X-Gm-Message-State: AAQBX9ecH5lwOeTEjcccpa/rf89tiOv93nrwxFzXffMBy1psCmF18qDP
	p+sDm4wPahKQ2b9tJub8wXkIBa4NICDNww==
X-Google-Smtp-Source: AKy350biOI9x2UVlkdbQxs6COE9ClrZsaVxSEeLj8cGsL5GkgmswBxG2pljsUVDWjOuoSIaH7RrYg3tH/kgY5w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:da85:b0:19f:2aa4:b1e5 with SMTP
 id j5-20020a170902da8500b0019f2aa4b1e5mr2459015plx.2.1681021823248; Sat, 08
 Apr 2023 23:30:23 -0700 (PDT)
Date: Sun,  9 Apr 2023 06:29:59 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-13-ricarkol@google.com>
Subject: [PATCH v7 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
which has the benefit of splitting the cost of splitting a memslot
across multiple ioctls.

Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.
And do not split when enabling dirty logging if
KVM_DIRTY_LOG_INITIALLY_SET is set.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 16fa24f761152..50488daab0f4d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1094,8 +1094,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
  * @mask:	The mask of pages at offset 'gfn_offset' in this memory
  *		slot to enable dirty logging on
  *
- * Writes protect selected pages to enable dirty logging for them. Caller must
- * acquire kvm->mmu_lock.
+ * Writes protect selected pages to enable dirty logging, and then
+ * splits them to PAGE_SIZE. Caller must acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -1108,6 +1108,17 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * Eager-splitting is done when manual-protect is set.  We
+	 * also check for initially-all-set because we can avoid
+	 * eager-splitting if initially-all-set is false.
+	 * Initially-all-set equal false implies that huge-pages were
+	 * already split when enabling dirty logging: no need to do it
+	 * again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.40.0.577.gac1e443424-goog

