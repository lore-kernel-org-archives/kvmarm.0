Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0287B45A2AA
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 10:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322025; cv=none; b=lhp9DyOvyNACOL2FSmzAfOWaDr66JcALHhGnRPtRmSX9m4SqvDdeLvmQz4xOIVd6wElHG3JmLr/LU//1wity4pvshH2a2MyA/XRQ/OlSixvEyMFOP44/atOyHpGcYGsy+qTod/GajTfi7BKylbK7yEKiHGrSib7FCdNJ9WYsHGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322025; c=relaxed/simple;
	bh=q8b/IF40I1EjZuCj1A0d+zd8jdpLqWvWNJRxKNN3/lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duIUu8hJ/aGsV4hCQa92AiFDvophZh/WkQP8DJFcLwZjcxUukRS4ME/d1/6Pf/4TjRAYLhMAzyAB7rqodw+v8zMtLCCJQRx2TUTLn4QQDyvHr3dRTiTKro+74JpN6g9oQfyhG6aUHZpUaLqb0XomVUSRxTcOxt7+eH7HlnoQH5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UqEE8O+2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UqEE8O+2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43FA9202C;
	Wed, 29 Jul 2026 03:46:59 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F2883F66F;
	Wed, 29 Jul 2026 03:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785322023; bh=q8b/IF40I1EjZuCj1A0d+zd8jdpLqWvWNJRxKNN3/lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqEE8O+2ELBgIowNaCHrxKC18Fs6lH8FOQphvvvaKdtWBgcIQc+3G1bJecIW/R2m5
	 pNLhzFmPWaIli9F7XCj8+fzRRyrO3wccERiFpphCWaS4pkV0KwvGotDFHJpWR7SPEK
	 3saNPP4cy/+z0i/oEiUZd9/F0WF2VDvrExBd8gtY=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v3 10/11] KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
Date: Wed, 29 Jul 2026 11:45:45 +0100
Message-ID: <20260729104548.3439958-11-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729104548.3439958-1-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4468; i=leo.bras@arm.com; h=from:subject; bh=q8b/IF40I1EjZuCj1A0d+zd8jdpLqWvWNJRxKNN3/lQ=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLIyb17vnak+/9q0F3e3rfaPmcn55m9k1WOGI3OCKhq3W R96JG7q1lHKwiDGxSArpsgi+2j+Kp7vUzKOXPmxAGYOKxPIEAYuTgGYSOZ+hv8VpjLSR3+v5NrG c3CvgZbN3DUdcxTUQ4/pSkXvPew85/cZhv+Z0UcCp0uX1noqHexpLw056Lj2UNFxJsdlHzl2cev ZxXMAAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
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
 arch/arm64/kvm/dirty_bit.c             | 77 ++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
index d368a23a84b3..f785a7aad9e8 100644
--- a/arch/arm64/include/asm/kvm_dirty_bit.h
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -8,29 +8,42 @@
 #define __ARM64_KVM_DIRTY_BIT_H__
 
 #include <asm/kvm_pgtable.h>
 
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
 	return system_supports_hacdbs() &&  kvm->arch.mmu.pgt &&
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
index d7e624f9b630..ca9cfefe0893 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -352,10 +352,87 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
 		}
 
 		ret = -EAGAIN;
 	}
 
 	write_unlock(&kvm->mmu_lock);
 	kfree(hw_entries);
 
 	return ret;
 }
+
+int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *ring,
+				int *nr_entries_reset)
+{
+	u64 *hw_entries __free(kfree) = NULL;
+	u64 ttwl;
+	s64 cur_slot = S64_MAX;
+	int i, ret;
+	struct kvm_memory_slot *memslot;
+
+	if (signal_pending(current))
+		return -EINTR;
+
+	ttwl = HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
+
+	hw_entries = kmalloc(max(ring->size * sizeof(u64), PAGE_SIZE), GFP_KERNEL);
+	if (!hw_entries)
+		return -ENOMEM;
+
+	for (i = 0; i < ring->size; i++) {
+		struct kvm_dirty_gfn *entry;
+		gfn_t gfn;
+		u32 entry_slot;
+		u64 entry_offset;
+
+		entry = &ring->dirty_gfns[(ring->reset_index + i) &
+					  (ring->size - 1)];
+
+		if (!kvm_dirty_gfn_harvested(entry))
+			break;
+
+		entry_slot = READ_ONCE(entry->slot);
+		entry_offset = READ_ONCE(entry->offset);
+
+		if (entry_slot != cur_slot) {
+			memslot = kvm_dirty_ring_get_memslot(kvm, entry_slot);
+			if (!memslot)
+				return -EFAULT;
+
+			cur_slot = entry_slot;
+		}
+
+		if (entry_offset >= memslot->npages)
+			return -EFAULT;
+
+		gfn = memslot->base_gfn + entry_offset;
+
+		hw_entries[i] = (gfn_to_gpa(gfn) & HDBSS_ENTRY_IPA) |
+				  ttwl | HDBSS_ENTRY_VALID;
+	}
+
+	if (i == 0)
+		return 0;
+
+	write_lock(&kvm->mmu_lock);
+	ret = dirty_bit_clear(kvm, hw_entries, i);
+	write_unlock(&kvm->mmu_lock);
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
+	if (ret < i)
+		return -EAGAIN;
+
+	return ret;
+}
-- 
2.55.0

