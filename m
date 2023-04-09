Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C637184F
	for <kvmarm@lists.linux.dev>; Sun,  9 Apr 2023 06:30:20 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id u11-20020a17090341cb00b001a22d27406bso424297ple.13
        for <kvmarm@lists.linux.dev>; Sat, 08 Apr 2023 23:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021820; x=1683613820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=igOAuz0r1I5hEA8P4Bo74bcWKKXOHEcP0nYYkCmfiag=;
        b=E7yG1q3IKNdHqcK/SdlJAqbCxmy9CsG1Tolzabddr4MPAw70ToSdoDR44cSmJ8B4jF
         zhs39hkzcTG6IZ+fJZx5YLk90vvMGoI0srDkH8d89dNR+pJ4CWGoAL/4wM4hub8tBrz3
         Xmcr6FWplkpy/5S4bVOsoawG1Xtd9EgBNWAY2C4t8/IzziO7abveboRdPSV0ogWrJtkp
         45dQVusJ/3wbTtdaAfkeo5m+s9YKnF17DX47974aW1/NinsT4E/5Ja8BnpZ+XQ0kQhKL
         t0pDN6jE3Z+z9XZXbosoY3a5mRg1HTveMCaAtneGwbhFxAjvBU5ZovIxxJ4f4yrUtYpY
         PmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021820; x=1683613820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=igOAuz0r1I5hEA8P4Bo74bcWKKXOHEcP0nYYkCmfiag=;
        b=f34eqNI9nJ6O3mCsox9a9AlneMKyRks0/gJ3yG4JMOlYjNqUXzQRl46lE/CkknNt9X
         Fu8s62EfKjrNda2ie/kcVEohYdkrm8tYKvg6EgsbXr5V69jgn0j8w1QS1ulpwJa3vhkT
         n4SrkkA7p2Pru/ULarvEJauDQWc+MUyyNqkgzddUqDhGWZIrxlYwL62viEWQrGO1Wr6a
         K8KAp02mom+a7oAqHflbHFOV/Kh4y65ANQUgwxosq/BZBu5sDUvrqDGpu5grJcWKKegF
         iJYt/OFQBcY6+qsTb9E6CP/UdWAd54EQnPkr+gIg4Yvv2pgOUDfRtluIJ9aC+YOJMFIW
         fGQA==
X-Gm-Message-State: AAQBX9e9lqTtE1Qm+ASQ17ch2ucbG87VCEnpVMsY+p/ZamQxYbUDczp8
	gOURNtTZEq8jWdLoCSpk+Y4EusVHda7vUw==
X-Google-Smtp-Source: AKy350YSBrvguPlC4BjtLQ9kjRG7E/3WtRpDfhSM5FEF4pdpk/J4GyCI2B4LNfWwunsLJo7IpNhZTtJxpdvivA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f685:b0:1a0:d6b:1211 with SMTP id
 l5-20020a170902f68500b001a00d6b1211mr2427944plg.6.1681021820147; Sat, 08 Apr
 2023 23:30:20 -0700 (PDT)
Date: Sun,  9 Apr 2023 06:29:57 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-11-ricarkol@google.com>
Subject: [PATCH v7 09/12] KVM: arm64: Split huge pages when dirty logging is enabled
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 123 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 121 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 898985b09321a..aaefabd8de89d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,14 +31,21 @@ static phys_addr_t __ro_after_init hyp_idmap_vector;
 
 static unsigned long __ro_after_init io_map_base;
 
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
@@ -75,6 +82,79 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 #define stage2_apply_range_resched(mmu, addr, end, fn)			\
 	stage2_apply_range(mmu, addr, end, fn, true)
 
+/*
+ * Get the maximum number of page-tables pages needed to split a range
+ * of blocks into PAGE_SIZE PTEs. It assumes the range is already
+ * mapped at level 2, or at level 1 if allowed.
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
+static bool need_split_memcache_topup_or_resched(struct kvm *kvm)
+{
+	struct kvm_mmu_memory_cache *cache;
+	u64 chunk_size, min;
+
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		return true;
+
+	chunk_size = kvm->arch.mmu.split_page_chunk_size;
+	min = kvm_mmu_split_nr_page_tables(chunk_size);
+	cache = &kvm->arch.mmu.split_page_cache;
+	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
+}
+
+static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
+				    phys_addr_t end)
+{
+	struct kvm_mmu_memory_cache *cache;
+	struct kvm_pgtable *pgt;
+	int ret, cache_capacity;
+	u64 next, chunk_size;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	chunk_size = kvm->arch.mmu.split_page_chunk_size;
+	cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
+
+	if (chunk_size == 0)
+		return 0;
+
+	cache = &kvm->arch.mmu.split_page_cache;
+
+	do {
+		if (need_split_memcache_topup_or_resched(kvm)) {
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
+		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache);
+		if (ret)
+			break;
+	} while (addr = next, addr != end);
+
+	return ret;
+}
+
 static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 {
 	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
@@ -773,6 +853,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
 static void stage2_unmap_memslot(struct kvm *kvm,
@@ -999,6 +1080,34 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
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
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	phys_addr_t start, end;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	slots = kvm_memslots(kvm);
+	memslot = id_to_memslot(slots, slot);
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
@@ -1790,6 +1899,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.40.0.577.gac1e443424-goog

