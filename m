Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4667B
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:59:13 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id w17-20020a25c711000000b008673e821352so9539566ybe.6
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 08:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfnhNEO0qYqIhXOTY/DBVHuHgYeXN1mb64E/Y2nHvZo=;
        b=OY7lNGmecD6RBy6Mhr6OImmD0/FXI0fhdJXYXMiw0o1/dLG4IgaHT0JQPRHBTeUf58
         5msr1aZj1lI9GcLS3wNywd8pPkEPwX7CktwYIK2exFcSNz3XIykgMYJa1y9i/sn4QfU3
         uTyEyl2awA7X1QdbQctHSB+ITmUtfAp/b7mZkHE/76pFn/J7kOo5at3a5Jb/PHS7Rxe1
         2hI8UeRYIsfuT2KoZ7FedmvXfz1NAL3CIqA+oKq6tSknbCcF2k3REZLEbHJlSy5fC6nL
         cyJLwUo5vCVDbSeX+DFhFUfNAR+U9E0+NFVNp9CGunZ4nImhdk1gSffO6QDHbCZbJfgu
         uziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfnhNEO0qYqIhXOTY/DBVHuHgYeXN1mb64E/Y2nHvZo=;
        b=sXU1wr0ybT8dGdeg6ZCHNxe1oOtcnZFWLemfoqj9CIBqJKPCw5SjeZIL9sgY9cn9P7
         x2u/adQXpEKDYpbzr8FW6/0N6xejqKaBkpEQzFB0z0z6ptCygoDVj/fVLAnFGBdu+OS7
         +JMSOXp1v3Q308HCpQeyGgQTPbaj9LLcxdxtUX5UfWwmA4dzvj/2ZvHixYAB+cpWiSPM
         lbx82QvCuFUrFlvM9qOerfYJJ7FzP4qVP4trtl5fyhpXX5wnecK4uZ/OsFOv+GBKdldj
         dIDFelCDDlK12DO2tJIy0hNpzRmUvXNB383ZMjxsHJVNBHMQ1KqMWfaZYqNAHxU82vY+
         Lt3Q==
X-Gm-Message-State: AO0yUKV4QaHiNhGPi7t3UV3u8YlG9QfZawgVPuEjNZD5ioVu5dsDoQig
	e8oGsb/TEDuM6OAYsdoQIc7CdaBPB3KWYg==
X-Google-Smtp-Source: AK7set+7/xe5sxL/rI27WlC2RLSsQTQOrFJS8uuHs7s4BpRCKIiQCqgpucmxVo0v5s3NXepw3PwSRNz7QMdrRg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:a046:0:b0:525:b3c5:f175 with SMTP id
 x67-20020a81a046000000b00525b3c5f175mr1462276ywg.453.1675702752713; Mon, 06
 Feb 2023 08:59:12 -0800 (PST)
Date: Mon,  6 Feb 2023 16:58:50 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-12-ricarkol@google.com>
Subject: [PATCH v2 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
index f6fb2bdaab71..da2fbd04fb01 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1084,8 +1084,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
@@ -1098,6 +1098,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
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
@@ -1884,7 +1891,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
-		 * cache around for any of the other cases.
+		 * cache around for any of the other cases. Keeping the cache
+		 * is useful for succesive KVM_CLEAR_DIRTY_LOG calls, which is
+		 * not handled in this function.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
-- 
2.39.1.519.gcb327c4b5f-goog

