Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E15391
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:16 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id bw25-20020a056a00409900b005a9d0e66a7aso6472353pfb.5
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ygqX7cYaXDWkUbcA+/8gfKKiXYuqG9E9j8+54ijaRhI=;
        b=UdTnjJR7diqCGdoPrwymK8BVf2lIJswPqqOkE9ieVHPG32C3/AxTqH18MvIqTpgNfs
         f9cSw/RpRxTpxdGUJssaGIH7B1x2fTjtL0fWX8KrXbvpU0jwDsN7LEZkcR3zsh5bnHzp
         9FrzMZQEAKIBx90HXg0Iab/s2eZNRua6hCxF7I4XhPJjanaONXxQVF3QXN6J/FtMRJp4
         LMnTqKC1bKyZzIFqRa4+ObK2Pvqo3Mq2D+DfuaxhJtreC3fCXFUwUYkEXXJtpKlgxcoZ
         k7B+HRC0oaPlarVnjzJweOW9wAn7eADmgauRTxut0/dZ9W+pGmUmSo8zOkmSiLxtgFsx
         WJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ygqX7cYaXDWkUbcA+/8gfKKiXYuqG9E9j8+54ijaRhI=;
        b=bScQ+/4waS9sGUkAs4fGwLyLpd57ItTXdvqIZNTz2SICbiZ46F8n+Rvs1K99zHDBFd
         PYEvd0DITvv2ATHpttwxeeVmjeVeLjEQMWQfkdGvr3TbH6xBefAJFZa5RWQVMWifBJOd
         +H/5cWszaGFjSHTiyK0wr+vhHDgwTMGVc2YAs0kz+9jqOzZ+aQeXesvF3lXrQoe/PZBC
         kj2+aYjpTmvm8OeYy2m2pBoLU7uveLdO9zCQ4LTQy+eGhk0Tl1+m2Z7kre5OYnpfDp5J
         cuIZweDAwl+lR5+ViKsXZ805hLTafqp7w34f1TMyQzU7ELQ5Ktrg2zPce2h3uYAmuTyw
         oNnw==
X-Gm-Message-State: AO0yUKXNGr0JZOjcCJw1R9LACFLZwti8yvkbqZBpQ+rpRuaovnkkpfuW
	+jEArYURfSRAFeK9Cl1LO/g1+wrFoBebtA==
X-Google-Smtp-Source: AK7set9RrPF1bWr9sfzbU55TuzyilEy7iLjQ4Qc3mOoUfD5BSrWI3TYPI784ZQIhAOP0QbH+0RUdUxhh2/lIeA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a62:860d:0:b0:5f4:fe6d:fafa with SMTP id
 x13-20020a62860d000000b005f4fe6dfafamr5651514pfd.0.1678160776437; Mon, 06 Mar
 2023 19:46:16 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:54 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-12-ricarkol@google.com>
Subject: [PATCH v6 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
index 910aea6bbd1e..d54223b5db97 100644
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
2.40.0.rc0.216.gc4246ad0f0-goog

