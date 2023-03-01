Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AE18BEF
	for <kvmarm@lists.linux.dev>; Wed,  1 Mar 2023 21:09:48 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso1675402ybi.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 13:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9dXTqLteclKP7ykUjHGgGAe2d1P6jiwOHz0hIPOMm10=;
        b=ou6dhW0Lv/la3qTIj45HoE6QCVoQax7IFOViGUppwWJZ7rLXlh2GX4+m1mGhRyUAH1
         3xslsWjPi2mhT2iwdv/oyxrhHG7R3joGh9i7uiZhJ0Zr8nXDYow82AHS83hKl/vUIfDW
         zgOu1SUa3H8zpR70l6VLiuEm78ON1s9/SLg0o5gaFZZIGzKVFFO4fspI+hgeL4PwCeL5
         BJaeytWGQUrYVheWoNCUZJpSPxO+K94oJ9ZlqvVRxIYi1aumovo65PJm/YezZgA5PK4U
         UJ75E0V2wxlSquWc7iIEjpbP3/wnLwTUkywgdY61Laq999YvfH/Fla45V5GCwGksy5qe
         he0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dXTqLteclKP7ykUjHGgGAe2d1P6jiwOHz0hIPOMm10=;
        b=6xIHgBjod3p81USqtjLFVbZAYenwOp+43/xCH3hw+bMkLum/4Zf3bpAeKJXBy7JvFi
         c2L+z9KSzz80vEIGtX2ApmyJJlRUZ8VVue1FzMhCvBVlc8vsZrBZvhAnw0Xb/eRsthXL
         vv2WWNCa+Q9IYUVn1RW3jES6Gp3NCJcY77ROoXJ5VtIOV3+CeuGIlY0zlAQOkqeFOJyL
         w5mzJObNPzvqjRJDsVUYg5QmS/EwHqjzpPs46PrtsZDT5QPHvPsvacROygT3bllBNZRG
         xy8cUj49zTiPexbaOb/7Gx6ZeXVypvw/MtQNQIR0IZ7dCT+HbveYrGpYpfGgv1b0YbUj
         TR3A==
X-Gm-Message-State: AO0yUKX7GLzBgH92wheATQbmUPozAp6NWftuQ4FNYZNc1aCXKx7Yn1vS
	rTW97+GgjJTw+WTyqeGw0v21fChDc+VImg==
X-Google-Smtp-Source: AK7set8hPwFbM6ppaQmV7LpD61SrZTZ2fA3S5by+DLDxU/NdyQo8waJkdChULEZAyaTYCg9+Ou/jU6rhlwjoyg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:b664:0:b0:52e:c77d:3739 with SMTP id
 h36-20020a81b664000000b0052ec77d3739mr4762235ywk.9.1677704987215; Wed, 01 Mar
 2023 13:09:47 -0800 (PST)
Date: Wed,  1 Mar 2023 21:09:25 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-10-ricarkol@google.com>
Subject: [PATCH v5 09/12] KVM: arm64: Split huge pages when dirty logging is enabled
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Split huge pages eagerly when enabling dirty logging. The goal is to
avoid doing it while faulting on write-protected pages, which
negatively impacts guest performance.

A memslot marked for dirty logging is split in 1GB pieces at a time.
This is in order to release the mmu_lock and give other kernel threads
the opportunity to run, and also in order to allocate enough pages to
split a 1GB range worth of huge pages (or a single 1GB huge page).
Note that these page allocations can fail, so eager page splitting is
best-effort.  This is not a correctness issue though, as huge pages
can still be split on write-faults.

The benefits of eager page splitting are the same as in x86, added
with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
the TDP MMU when dirty logging is enabled"). For example, when running
dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
all of their memory after dirty logging is enabled decreased by 44%
from 2.58s to 1.42s.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 118 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 116 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e2ada6588017..20458251c85e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,14 +31,21 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
-static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
+static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
+					   phys_addr_t size)
 {
-	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
 	phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
 
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
+static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
+
+	return __stage2_range_addr_end(addr, end, size);
+}
+
 /*
  * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
  * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
@@ -71,6 +78,77 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 	return ret;
 }
 
+static bool need_topup_split_page_cache_or_resched(struct kvm *kvm, uint64_t min)
+{
+	struct kvm_mmu_memory_cache *cache;
+
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		return true;
+
+	cache = &kvm->arch.mmu.split_page_cache;
+	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
+}
+
+/*
+ * Get the maximum number of page-tables needed to split a range of
+ * blocks into PAGE_SIZE PTEs. It assumes the range is already mapped
+ * at the PMD level, or at the PUD level if allowed.
+ */
+static int kvm_mmu_split_nr_page_tables(u64 range)
+{
+	int n = 0;
+
+	if (KVM_PGTABLE_MIN_BLOCK_LEVEL < 2)
+		n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
+	n += DIV_ROUND_UP_ULL(range, PMD_SIZE);
+	return n;
+}
+
+static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
+				    phys_addr_t end)
+{
+	struct kvm_mmu_memory_cache *cache;
+	struct kvm_pgtable *pgt;
+	int ret;
+	u64 next;
+	u64 chunk_size = kvm->arch.mmu.split_page_chunk_size;
+	int cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
+
+	if (chunk_size == 0)
+		return 0;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	cache = &kvm->arch.mmu.split_page_cache;
+
+	do {
+		if (need_topup_split_page_cache_or_resched(kvm,
+							   cache_capacity)) {
+			write_unlock(&kvm->mmu_lock);
+			cond_resched();
+			/* Eager page splitting is best-effort. */
+			ret = __kvm_mmu_topup_memory_cache(cache,
+							   cache_capacity,
+							   cache_capacity);
+			write_lock(&kvm->mmu_lock);
+			if (ret)
+				break;
+		}
+
+		pgt = kvm->arch.mmu.pgt;
+		if (!pgt)
+			return -EINVAL;
+
+		next = __stage2_range_addr_end(addr, end, chunk_size);
+		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr,
+					       cache, cache_capacity);
+		if (ret)
+			break;
+	} while (addr = next, addr != end);
+
+	return ret;
+}
+
 #define stage2_apply_range_resched(kvm, addr, end, fn)			\
 	stage2_apply_range(kvm, addr, end, fn, true)
 
@@ -772,6 +850,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
 static void stage2_unmap_memslot(struct kvm *kvm,
@@ -999,6 +1078,31 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
+/**
+ * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
+ *				   pages for memory slot
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot to split
+ *
+ * Acquires kvm->mmu_lock. Called with kvm->slots_lock mutex acquired,
+ * serializing operations for VM memory regions.
+ */
+static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
+	phys_addr_t start, end;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	start = memslot->base_gfn << PAGE_SHIFT;
+	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	write_lock(&kvm->mmu_lock);
+	kvm_mmu_split_huge_pages(kvm, start, end);
+	write_unlock(&kvm->mmu_lock);
+}
+
 /*
  * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
  * dirty pages.
@@ -1790,6 +1894,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 			return;
 
 		kvm_mmu_wp_memory_region(kvm, new->id);
+		kvm_mmu_split_memory_region(kvm, new->id);
+	} else {
+		/*
+		 * Free any leftovers from the eager page splitting cache. Do
+		 * this when deleting, moving, disabling dirty logging, or
+		 * creating the memslot (a nop). Doing it for deletes makes
+		 * sure we don't leak memory, and there's no need to keep the
+		 * cache around for any of the other cases.
+		 */
+		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
 }
 
-- 
2.39.2.722.g9855ee24e9-goog

