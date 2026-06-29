Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C203FFAC3;
	Mon, 29 Jun 2026 11:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731950; cv=none; b=rgYxbgY7chLITVJ3uAqP8G3HYtl6rxoczTvB72Kfyevep5M1n0SIkewlnLewsFqvtQ0cTf0plXf7vYvUGJmpFQnekY177JhptF8AreOqCHGkwCDRDDZ9KqigiW6i5e5a+JXCRD+040qBSltE4nZ1V6eI5EkzYi9ng++v1n4RUro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731950; c=relaxed/simple;
	bh=llU5AQbHg35wrtXCD5rpILCyyyjG3sSsUTYLusL7cqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8SRVJMg3oOIeF3u7qEh32TqyBSf3RT+iZ7Y76YDQB6VINSWH/qsU2EYGQDkm0DhbQODqMbloy2PihifRh7k1l7D28EKiwvfuWCMR9GA6jmtzysvkrkA+tGSPqc1VkxNjnE/bgqSuRcN7l67xMC9XMA5eXKZb1ZEIhTMYzu2UT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ng7TBA0+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ng7TBA0+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA43F2BC0;
	Mon, 29 Jun 2026 04:19:02 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 122773F905;
	Mon, 29 Jun 2026 04:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731947; bh=llU5AQbHg35wrtXCD5rpILCyyyjG3sSsUTYLusL7cqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ng7TBA0+4UNUh7zGYinUVOXh/jS7wIp/OtpcGJBnqYtnjzPFHYJGm8DpN7eY2vVKt
	 /QsweWNgGnJFdBzMhG9YzqUoqkvst02fVzmJ4ue9Y4no5isMUgRDX4tv8L1vjqBh/u
	 ESp4gSbdV5trqGGTbPQRs4m0PasrI4UxGaLYLStg=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v2 08/13] KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine
Date: Mon, 29 Jun 2026 12:17:56 +0100
Message-ID: <20260629111820.1873540-9-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629111820.1873540-1-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9263; i=leo.bras@arm.com; h=from:subject; bh=llU5AQbHg35wrtXCD5rpILCyyyjG3sSsUTYLusL7cqk=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKcQhLPdWtOlTfVDOSyiJ6pWVQZ1C609q3Vrv5/BxvDl id03o3pKGVhEONikBVTZJF9NH8Vz/cpGUeu/FgAM4eVCWQIAxenAEykJ5KR4dr7aYcDpcx2f101 0aHIvmEtuy1z7oX7D8MK+5Y9f/dXpo6RYUfykdeV5f69BnX7X98r38R+2nyD6qQDzG5hO/lfczv HMgIA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Implement arm64 version of kvm_arch_dirty_log_clear() making use of
FEAT_HACDBS.

It works by transversing the dirty-bitmap and converting the set bits into
HDBSS entries in a 64-page blocks granularity.

The resulting HDBSS array is then fed to the HACDBS mechanism that walks
the pagetable marking writable-dirty pages as writable-clean.

In case of error, rewrite all unprocessed entries, including the faulting
one, to the dirty-bitmap and fall back to generic software cleaning.

In case of the options to "manual protect + init set" are enabled, do
the hugepage splitting in the same fashion as the generic software
cleaning, i.e. in 64-page blocks. For that, remove the static qualifier
from kvm_mmu_split_huge_pages() and make the function available on
kvm_host.h.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/kvm_dirty_bit.h |  24 ++++
 include/linux/kvm_host.h               |   3 +
 arch/arm64/kvm/dirty_bit.c             | 146 +++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                   |   4 +-
 4 files changed, 175 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
index 904e59f95b7e..3d749f979c67 100644
--- a/arch/arm64/include/asm/kvm_dirty_bit.h
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -20,11 +20,35 @@ struct hacdbs {
 	enum hacdbs_status status;
 	int size;
 };
 
 DECLARE_PER_CPU(struct hacdbs, hacdbs_pcp);
 
 void __init kvm_hacdbs_init(void);
 void kvm_hacdbs_cpu_up(void);
 void kvm_hacdbs_cpu_down(void);
 
+int __kvm_arch_dirty_log_clear(struct kvm *kvm,
+			       struct kvm_memory_slot *memslot,
+			       struct kvm_clear_dirty_log *log,
+			       unsigned long *bitmap,
+			       bool *flush);
+
+static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
+{
+	return this_cpu_read(hacdbs_pcp.status) == HACDBS_IDLE &&
+	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
+}
+
+static inline int kvm_arch_dirty_log_clear(struct kvm *kvm,
+					   struct kvm_memory_slot *memslot,
+					   struct kvm_clear_dirty_log *log,
+					   unsigned long *bitmap,
+					   bool *flush)
+{
+	if (!kvm_arch_dirty_clear_enabled(kvm))
+		return -EPERM;
+
+	return __kvm_arch_dirty_log_clear(kvm, memslot, log, bitmap, flush);
+}
+
 #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d3..7ea6ed7ce203 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1662,20 +1662,23 @@ void kvm_arch_disable_virtualization_cpu(void);
 bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 void kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
+int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
+			     phys_addr_t end);
+
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
  * All architectures that want to use vzalloc currently also
  * need their own kvm_arch_alloc_vm implementation.
  */
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
 	return kzalloc_obj(struct kvm, GFP_KERNEL_ACCOUNT);
 }
 #endif
diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index e4283828b780..d05af3de78be 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -98,20 +98,166 @@ static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
 	 * No DSB is needed here, as kvm_flush_remote_tlbs_memslot() that happens
 	 * later in generic dirty-cleaning code already performs a DSB before
 	 * doing the TLBI.
 	 */
 
 	preempt_enable();
 
 	return ret;
 }
 
+static inline void hdbss_to_bitmap(u64 *hdbss_array, int start, int end,
+				   unsigned long *dirty_bitmap,
+				   unsigned long long offset)
+{
+	u64 w = (gpa_to_gfn(hdbss_array[start]) - offset) / BITS_PER_LONG;
+	u64 mask = 0;
+	int idx = start;
+
+	do {
+		u64 entry = (gpa_to_gfn(hdbss_array[idx]) - offset);
+
+		if (entry / BITS_PER_LONG == w) {
+			mask |= BIT(entry % BITS_PER_LONG);
+		} else {
+			atomic_long_or(mask, (atomic_long_t *)&dirty_bitmap[w]);
+			w = entry / BITS_PER_LONG;
+			mask = BIT(entry % BITS_PER_LONG);
+		}
+	} while (++idx < end);
+	atomic_long_or(mask, (atomic_long_t *)&dirty_bitmap[w]);
+}
+
+static inline int mask_to_hdbss(unsigned long *mask, u64 *hw_entries, const gfn_t offset,
+				u64 ttwl, int idx, int entries_sz)
+{
+	while (idx < entries_sz) {
+		int j = __ffs(*mask);
+		u64 a = gfn_to_gpa(offset + j);
+
+		hw_entries[idx++] = (a & HDBSS_ENTRY_IPA) |
+				    ttwl |
+				    HDBSS_ENTRY_VALID;
+
+		*mask &= ~BIT(j);
+		if (!*mask)
+			break;
+	}
+
+	return idx;
+}
+
+int __kvm_arch_dirty_log_clear(struct kvm *kvm,
+			       struct kvm_memory_slot *memslot,
+			       struct kvm_clear_dirty_log *log,
+			       unsigned long *bitmap,
+			       bool *flush)
+{
+	int ret = 0;
+	int idx = 0;
+	unsigned long *dirty_bitmap = memslot->dirty_bitmap;
+	u64 *hw_entries;
+	const int entries_sz = PAGE_SIZE / sizeof(*hw_entries);
+	u64 ttwl;
+	u64 start, end;
+	gfn_t base_gfn;
+
+	hw_entries = kmalloc_objs(u64, entries_sz, GFP_KERNEL);
+	if (!hw_entries)
+		return -ENOMEM;
+
+	ttwl = HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
+
+	if (log) {
+		start = log->first_page / BITS_PER_LONG;
+		end = start + DIV_ROUND_UP(log->num_pages, BITS_PER_LONG);
+		base_gfn = memslot->base_gfn + log->first_page % BITS_PER_LONG;
+	} else {
+		start = 0;
+		end = kvm_dirty_bitmap_bytes(memslot) / sizeof(long);
+		base_gfn = memslot->base_gfn;
+	}
+
+	write_lock(&kvm->mmu_lock);
+
+	for (unsigned long i = start; i < end; i++) {
+		unsigned long mask;
+		gfn_t offset;
+		atomic_long_t *p;
+
+		if (log) { /* Clean only what is in the input bitmap */
+			mask = bitmap[i];
+			if (!mask)
+				continue;
+
+			p = (atomic_long_t *)&dirty_bitmap[i];
+			mask &= atomic_long_fetch_andnot(mask, p);
+		} else { /* Clean everything */
+			if (!dirty_bitmap[i])
+				continue;
+
+			mask = xchg(&dirty_bitmap[i], 0);
+			bitmap[i] = mask;
+		}
+
+		if (!mask)
+			continue;
+
+		offset = base_gfn + i * BITS_PER_LONG;
+
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			kvm_mmu_split_huge_pages(kvm,
+						 gfn_to_gpa(offset + __ffs(mask)),
+						 gfn_to_gpa(offset + __fls(mask) + 1));
+
+		do {
+			idx = mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_sz);
+			if (idx >= entries_sz) {
+				ret = dirty_bit_clear(kvm, hw_entries, idx);
+				*flush = *flush || ret > 0;
+				if (ret != idx) {
+					/* Save bits not converted back to bitmap */
+					atomic_long_or(mask, (atomic_long_t *)&dirty_bitmap[i]);
+					goto out_err;
+				}
+				idx = 0;
+			}
+		} while (mask);
+	}
+
+	if (idx != 0) {
+		ret = dirty_bit_clear(kvm, hw_entries, idx);
+		*flush = *flush || ret > 0;
+	}
+out_err:
+	if (unlikely(ret != idx)) {
+		/*
+		 * In case there is an error and not all entries in HACDBS get
+		 * cleaned, we have to mark the dirty bits back in the bitmap,
+		 * as that will be used by the software routine.
+		 *
+		 * Entries should be in order, since they were extraxed from
+		 * the dirty-bitmap, so batching the atomic writes is efficient.
+		 */
+
+		if (ret < idx)
+			hdbss_to_bitmap(hw_entries, ret, idx, dirty_bitmap, memslot->base_gfn);
+
+		ret = -EAGAIN;
+	}
+
+	write_unlock(&kvm->mmu_lock);
+	kfree(hw_entries);
+
+	return ret;
+}
+
 static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
 {
 	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
 	unsigned long err = FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons);
 
 	switch (err) {
 	case HACDBSCONS_EL2_ERR_REASON_NOF:
 		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
 		break;
 	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e086c01a9325..2f9d90c35668 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -110,22 +110,22 @@ static bool need_split_memcache_topup_or_resched(struct kvm *kvm)
 
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
 		return true;
 
 	chunk_size = kvm->arch.mmu.split_page_chunk_size;
 	min = kvm_mmu_split_nr_page_tables(chunk_size);
 	cache = &kvm->arch.mmu.split_page_cache;
 	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
 }
 
-static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
-				    phys_addr_t end)
+int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
+			     phys_addr_t end)
 {
 	struct kvm_mmu_memory_cache *cache;
 	struct kvm_pgtable *pgt;
 	int ret, cache_capacity;
 	u64 next, chunk_size;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	chunk_size = kvm->arch.mmu.split_page_chunk_size;
 	cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
-- 
2.54.0

