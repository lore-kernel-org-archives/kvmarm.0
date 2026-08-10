Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E12D443E47
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 20:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786395120; cv=none; b=eg096BxREvhg4EkspjLYD7CI5zG9F+gBnxNYEMd4en1/g63mJO5uHLVPRiQ1CX8jAPq/Sv/hk0vq+6UowRlI4lHkU4cVmg809J3FSv/1deyusidbyY9qQMVyaMc2Y4JgCkGZ0AktPaefO9kiMfcqfHDcc27utitnq+ypvEs+XSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786395120; c=relaxed/simple;
	bh=ulWcug5FR5A8S6ih5KiWhVhUwpQ0/EYi/o4gse2V6ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWH7BZvhjnpw8+54S3nP+LM23jGk7C7Hsk8+gyyIZJhcA2iNytCk6DuWHB/WCjWf4mL95yxwMEmgGFf875YHegcG//btG+Vsp2SYwAnLMu8vBa+H7BxABIT1TfTG28BvZYWptJ6SP8XUfiVuDwPFfQRSt0K2gL5Aw3m6Xlsqmd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fmLOTLUM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fmLOTLUM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 009C614BF;
	Mon, 10 Aug 2026 13:51:54 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F67A3F673;
	Mon, 10 Aug 2026 13:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786395117; bh=ulWcug5FR5A8S6ih5KiWhVhUwpQ0/EYi/o4gse2V6ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmLOTLUMUkm3jSxi2mHi2jLK4kmZz/fqGjfpyPxxPxrV32tOxQw/DQG+rv/AcEeC8
	 Dot5WoK+xd1g4XH/I+DZdnpVis5gDquwMUsYcN7VcqI6QAWK3CdQPL2MqtHXcCm95c
	 jMZ2ax7HFA71xBLCC75+zluGUYsYdOH5NI2tGPuc=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v5 4/6] KVM: arm64: nv: Track guest stage-2 mapping removal
Date: Mon, 10 Aug 2026 21:50:36 +0100
Message-ID: <20260810205038.118843-5-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260810205038.118843-1-weilin.chang@arm.com>
References: <20260810205038.118843-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_stage2_unmap_range() is the helper to remove mappings from the
stage-2 page tables. It is called during guest TLBI handling, memslot
removal, nested mmu reuse, etc.

Teach it about the guest stage-2 tracking trees and remove mappings from
there when shadow mappings are removed. This keeps the tracking trees
from having stale mappings pile up.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h   |  5 ++++-
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/mmu.c                | 23 +++++++++++++++++++++--
 arch/arm64/kvm/nested.c             | 28 ++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0695c4ef93f1..0bb83be1dd4f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -340,7 +340,10 @@ struct kvm_arch {
 	size_t nested_mmus_size;
 	int nested_mmus_next;
 
-	/* Guest s2 tracking trees access serialization. */
+	/*
+	 * Serializes guest s2 tracking trees access when the mmu_lock
+	 * is only held for read.
+	 */
 	spinlock_t guest_s2_tracking_lock;
 
 	/* Interrupt controller */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 560b78b3f5ff..ffa3fa01f3cd 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -80,6 +80,8 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 extern void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 					gpa_t nested_ipa, size_t map_size,
 					struct kvm_guest_s2_mapping *mapping);
+extern void kvm_remove_guest_s2_mappings(struct kvm_s2_mmu *mmu,
+					 gpa_t nipa, size_t size);
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cea968921041..ddd1bbede227 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -314,6 +314,19 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * we then fully enforce cacheability of RAM, no matter what the guest
  * does.
  */
+
+static int kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	int ret;
+
+	ret = kvm_pgtable_stage2_unmap(pgt, addr, size);
+	if (ret)
+		return ret;
+
+	kvm_remove_guest_s2_mappings(pgt->mmu, addr, size);
+	return 0;
+}
+
 /**
  * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @mmu:   The KVM stage-2 MMU pointer
@@ -331,11 +344,17 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	phys_addr_t end = start + size;
+	int (*fn)(struct kvm_pgtable *, u64, u64);
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
-	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stage2_unmap),
-				   may_block));
+
+	if (kvm_is_nested_s2_mmu(kvm, mmu))
+		fn = kvm_pgtable_stage2_unmap_tracked;
+	else
+		fn = KVM_PGT_FN(kvm_pgtable_stage2_unmap);
+
+	WARN_ON(stage2_apply_range(mmu, start, end, fn, may_block));
 }
 
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 646b628bba17..2a4c86df404c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -877,6 +877,34 @@ void kvm_record_guest_s2_mapping(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 	interval_tree_insert(&mapping->canonical, &kvm->arch.mmu.guest_s2_mappings);
 }
 
+void kvm_remove_guest_s2_mappings(struct kvm_s2_mmu *mmu, gpa_t nipa,
+				  size_t size)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	struct interval_tree_node *node, *next;
+	struct kvm_guest_s2_mapping *mapping;
+	gpa_t nipa_end = nipa + size - 1;
+
+	/*
+	 * Guest s2 tracking interval trees are only accessed while holding the
+	 * mmu_lock, hence we don't have to take guest_s2_tracking_lock if the
+	 * mmu_lock is held for write.
+	 */
+	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
+
+	node = interval_tree_iter_first(&mmu->guest_s2_mappings, nipa, nipa_end);
+	while (node) {
+		next = interval_tree_iter_next(node, nipa, nipa_end);
+		mapping = container_of(node, struct kvm_guest_s2_mapping,
+				       nested);
+		interval_tree_remove(&mapping->nested, &mmu->guest_s2_mappings);
+		interval_tree_remove(&mapping->canonical,
+				     &kvm->arch.mmu.guest_s2_mappings);
+		kfree(mapping);
+		node = next;
+	}
+}
+
 void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 {
 	/* CnP being set denotes an invalid entry */
-- 
2.43.0

