Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18706C0A3
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:41:09 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id t13-20020a62d14d000000b005a89856900eso6496856pfl.14
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vu28Y8xmwb9cUbiZLOcUlnlRr/eoSKPO/7e0jwLh0zg=;
        b=fi5dr/Uea0vWmNPTbL8OTE7Sg/ja0hoM43OAqbCs0x3g9IKAZGWp/yvpN92i7p1Pqk
         HDiqy8ftwQlT1NnGwLBeG3r2RNUuNo42LD9XyKLyZK1OBNVyPjfLSx8x/qiZoat58ED4
         ZhMjD1xnNQHDltJUUIBshDHFj+1otVDLMxZi4ClCnhyAiANNXSDcGXpYYEtgKi6BY+sJ
         0llIR230lm3+FX0UJ0yOANAbMm8We6kBlNyi6mgvHTbJbe9l2CtlTkhxRZbeDU2Ad5VZ
         JvrTUPjKhMZOS3R8PQ6jJfttf0zKpEaqfLC8U4pjEfdMhnhx9rFD+r+kns0343NShOQo
         i9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vu28Y8xmwb9cUbiZLOcUlnlRr/eoSKPO/7e0jwLh0zg=;
        b=4MsUGZdCBjdEukoqqByEzG6HiQvTdGZr8/QNW3BbAN+6vZ7ehV2rP6Tj1kushpuaRe
         HrXCljhJF1/HBb9zeV2SI+wB3GYqdwQCqTh5+rO4gp67PiR91tRYuQB1IMF/e+nmQYO7
         T4En/BqULZ88sQ0A7cvOox4rYpfF71myRIAjDVfUjUADRMKoDvqAACO+Nv9JTjQB0hWy
         z824SskbiZW4EtlA8EO2SX1kyaUI2UobYFV/cngPIiQ9tGQdWhJp5GeT2FQyOFkRxLf+
         6Kq/txCic0EGdoXn0bXXIXayBSSrSG3IbZ0C+Nxt7/ITuGZVHzz2flZaTRr+a5C5llMC
         zd9w==
X-Gm-Message-State: AO0yUKXIeToIAy+BbQDemm6s9AcVBDVpxfkg0EObVJ1MurgyIQy8PvGK
	Psot9rw0zzLupkacqmGVdRiuak9aQ8uzTQ==
X-Google-Smtp-Source: AK7set8FvdjfeCrotVKOoVGb7sZBHpXmtdM1wOtJMGO9tmeqveUBHmj/eNHuv8/HOqcKyZxF5XRd4OT1S6jTJQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:7419:0:b0:4fb:b856:a30f with SMTP id
 p25-20020a637419000000b004fbb856a30fmr488302pgc.11.1676482868552; Wed, 15 Feb
 2023 09:41:08 -0800 (PST)
Date: Wed, 15 Feb 2023 17:40:45 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-12-ricarkol@google.com>
Subject: [PATCH v3 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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
2.39.1.637.g21b0678d19-goog

