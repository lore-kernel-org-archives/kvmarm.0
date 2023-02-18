Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCED62F
	for <kvmarm@lists.linux.dev>; Sat, 18 Feb 2023 03:23:35 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536587ff9e1so25266897b3.21
        for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 19:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/7R5ej6h5zuscnhDtO9neYKca8wJ2+Nh25+D9oE7OQ=;
        b=QWh2YpfYuo1Bfp/DWb7P1qu9AZTfi4z3+0VDnUgv9G8S/FKTe0KwQIo2XnOwqOUNCD
         Qqb3gg7L7eUd+HW1qxOdJkLGa6RO3/wMiSQX+crjekFgmKhpMEQRy1MAr+BTBEN6OE9A
         FILlJ+jDXycDLFwBrqWce2U3kZpZaqhkkNk/i5VeDLcM805jSPv2S2rG/juJMzCAgEHz
         eRzynL7TEmbH4KK21ecLpK9lZqwXv6fQCPFymTtDku1V3MfY61ABXV9i9FgltsxwyFrc
         WVLkuuWWiqbsdmOmVs/TSlZIY4Bp+SARwyaFujoZEbICpOdM+WpWG6Z9XMKjJEFBUaxS
         Czfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/7R5ej6h5zuscnhDtO9neYKca8wJ2+Nh25+D9oE7OQ=;
        b=z1j8kULGJk+J7IjvpqQAZvY917zKHWdMESR+gyjJDeKC3tcqIzzIQDjCnFgtu2FSsZ
         gtHe3u35lsZmb8sGWXkOzoqi9ethKHibb3sElihoML2mS6fbZ6GlKQQNEvnwDkZEn2Ug
         GfdU64Q6yvAj4LmfZun9PyLSTeCLtYgTRFSe15o2NGiiMn7T+dh4h0mwQo2sDaKfr4GM
         Cm3xin8qhs3PRT9erKpR5FabrK2XmUzDxmEHCzZkJSCKOGKaMcVGDzCSVFUa1vqlU+Vi
         Br51tevEDDEVhD4brF5va30GsT+HpViC24lTXqA6U154S0udeHIE9Sy21itEC6t3ON/f
         9obQ==
X-Gm-Message-State: AO0yUKXpVFMeRi4wrAmuTh0KDPMi7qFZSn/PuoN2lSYWEjb8YA2goFHD
	pWsezVnC+L6uVQaXXCrf18Hz726dJMkbRA==
X-Google-Smtp-Source: AK7set/aW9Y72FZsVzf91MozQGe+Q5u8KbHZsA4913mkF0aisI+PQiLGbO+5m+8JXKTzoIvJ3HdXMG8LAlFMCg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9e92:0:b0:900:c3fd:a093 with SMTP id
 p18-20020a259e92000000b00900c3fda093mr897185ybq.684.1676690614628; Fri, 17
 Feb 2023 19:23:34 -0800 (PST)
Date: Sat, 18 Feb 2023 03:23:13 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-12-ricarkol@google.com>
Subject: [PATCH v4 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
 arch/arm64/kvm/mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8e9d612dda00..5dae0e6a697f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1089,8 +1089,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
@@ -1103,6 +1103,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * If initially-all-set mode is not set, then huge-pages were already
+	 * split when enabling dirty logging: no need to do it again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1889,7 +1896,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
-		 * cache around for any of the other cases.
+		 * cache around for any of the other cases. Keeping the cache
+		 * is useful for successive KVM_CLEAR_DIRTY_LOG calls, which is
+		 * not handled in this function.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
-- 
2.39.2.637.g21b0678d19-goog

