Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC21421880;
	Thu, 30 Apr 2026 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777547773; cv=none; b=ZslQfL0kFes0M7aR8MWuVz8yCh9hOOTn44SghgAewcwh5H3Sr2NR1Ha2hECDo2TNsc1f1GmdLKHZqmYo3lRFc3dq9td71eMiz7rJGm0gIiR5rt907YOF7fdIkJH6cnJxZ+TCjICOgkcJXbGCL3wXfFTCUTgIDfdd0xL0lJdaDmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777547773; c=relaxed/simple;
	bh=fPffxhpzXsn8izUh0F0BUdbzOcL0eKYDh++M+0U1pJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZpR592Xi6ZjHmurOwP1GwjCh2BGiVNv11zR+MdsjFClx+FuRODjccgIzPyXDpls2jG69Yiz3In4+caY0J6JamagaWoBxQYf5DGXImvWdA/C2oadSk2zNX7TPkTBbx8ACBrylrXS5fqoJvAg0kI2fWNWRjfmpVbCrKJ5KrxmBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F2Fribgv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F2Fribgv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AA86356B;
	Thu, 30 Apr 2026 04:16:05 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F1B03F763;
	Thu, 30 Apr 2026 04:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777547770; bh=fPffxhpzXsn8izUh0F0BUdbzOcL0eKYDh++M+0U1pJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2FribgvepEhj4KmtyowEbRPZ1k2UjwoGhsaeKYWQ/KdYmhB4cIuuC7AG87K6o8Kr
	 NwV01a4Jq8sUYRkmJ/N9azU5WKc96Ax+s+LKNDutqQIndBM0DZSPzZ/CizOJBU6yq8
	 qFSgzNc/18I0HhkgGm5tOqP81PSmbV2v//O2qyYc=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v1 11/12] KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
Date: Thu, 30 Apr 2026 12:14:15 +0100
Message-ID: <20260430111424.3479613-13-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430111424.3479613-2-leo.bras@arm.com>
References: <20260430111424.3479613-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement arm64 version of kvm_arch_dirty_ring_clear() making use of
FEAT_HACDBS.

It works by transversing the dirty-ring and converting its entries into
HDBSS entries based on the slot offset.

The resulting HDBSS array is then fed to the HACDBS mechanism that walks
the pagetable marking writable-dirty pages as writable-clean.

Only successfully cleaned entries are set as invalid on the dirty-ring, so
in case of error, falling back to generic software cleaning will take care
of any remaining entry in the dirty-ring.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/kvm_dirty_bit.h | 13 +++++
 arch/arm64/kvm/dirty_bit.c             | 66 ++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
index 3d749f979c67..d76c109937d8 100644
--- a/arch/arm64/include/asm/kvm_dirty_bit.h
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -26,29 +26,42 @@ DECLARE_PER_CPU(struct hacdbs, hacdbs_pcp);
 void __init kvm_hacdbs_init(void);
 void kvm_hacdbs_cpu_up(void);
 void kvm_hacdbs_cpu_down(void);
 
 int __kvm_arch_dirty_log_clear(struct kvm *kvm,
 			       struct kvm_memory_slot *memslot,
 			       struct kvm_clear_dirty_log *log,
 			       unsigned long *bitmap,
 			       bool *flush);
 
+int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *ring,
+				int *nr_entries_reset);
+
 static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
 {
 	return this_cpu_read(hacdbs_pcp.status) == HACDBS_IDLE &&
 	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
 }
 
 static inline int kvm_arch_dirty_log_clear(struct kvm *kvm,
 					   struct kvm_memory_slot *memslot,
 					   struct kvm_clear_dirty_log *log,
 					   unsigned long *bitmap,
 					   bool *flush)
 {
 	if (!kvm_arch_dirty_clear_enabled(kvm))
 		return -EPERM;
 
 	return __kvm_arch_dirty_log_clear(kvm, memslot, log, bitmap, flush);
 }
 
+static inline int kvm_arch_dirty_ring_clear(struct kvm *kvm,
+					    struct kvm_dirty_ring *ring,
+					    int *nr_entries_reset)
+{
+	if (!kvm_arch_dirty_clear_enabled(kvm))
+		return -EPERM;
+
+	return __kvm_arch_dirty_ring_clear(kvm, ring, nr_entries_reset);
+}
+
 #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index 0b7dcb8467c0..b99808a36469 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -256,20 +256,86 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
 
 		ret = -EAGAIN;
 	}
 
 	write_unlock(&kvm->mmu_lock);
 	kfree(hw_entries);
 
 	return ret;
 }
 
+int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *ring,
+				int *nr_entries_reset)
+{
+	u64 *hw_entries;
+	u64 slot_offset = 0;
+	u64 ttwl;
+	int i, ret;
+	u32 slot = -1;
+
+	if (signal_pending(current))
+		return -EINTR;
+
+	ttwl = hdbss_get_ttwl(kvm->arch.mmu.split_page_chunk_size);
+
+	hw_entries = kmalloc(max(ring->size * sizeof(u64), PAGE_SIZE), GFP_KERNEL);
+	if (!hw_entries)
+		return -ENOMEM;
+
+	for (i = 0; i < ring->size; i++) {
+		struct kvm_dirty_gfn *entry;
+		gfn_t gfn;
+
+		entry = &ring->dirty_gfns[(ring->reset_index + i) &
+					  (ring->size - 1)];
+
+		if (!kvm_dirty_gfn_harvested(entry))
+			break;
+
+		if (entry->slot != slot) {
+			struct kvm_memory_slot *memslot;
+
+			memslot = kvm_dirty_ring_get_memslot(kvm, entry->slot);
+			slot = entry->slot;
+			slot_offset = memslot->base_gfn;
+		}
+
+		gfn = slot_offset + entry->offset;
+
+		hw_entries[i] = (gfn_to_gpa(gfn) & HDBSS_ENTRY_IPA) |
+				ttwl | HDBSS_ENTRY_VALID;
+	}
+
+	ret = dirty_bit_clear(kvm, hw_entries, i);
+
+	/* Set as invalid all successfully cleaned entries */
+	for (int j = 0; j < ret; j++) {
+		struct kvm_dirty_gfn *entry;
+
+		entry = &ring->dirty_gfns[(ring->reset_index + j) &
+					  (ring->size - 1)];
+
+		kvm_dirty_gfn_set_invalid(entry);
+	}
+
+	/* In case of error, try software cleaning from the faulting entry */
+	ring->reset_index += ret;
+	*nr_entries_reset += ret;
+
+	kfree(hw_entries);
+
+	if (ret < i)
+		return -EFAULT;
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
-- 
2.54.0

