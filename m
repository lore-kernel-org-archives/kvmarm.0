Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E57742AFB5;
	Mon,  3 Aug 2026 13:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764763; cv=none; b=Rr+jqRumWODdl2eStug8iJaLxadT9V1AXENEi04wjLVD9oGEXNPyTjVFQstO7S8dLlyC4Tu7oULkC31riDQEtsYJ6f6/sVUWpoEdpA3xNtaFpneupvdGhyPhGXJbsTwJ/ecj50V0nHvpO76OzpZhg4VavY7gpIx7e0Ep0mMrr2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764763; c=relaxed/simple;
	bh=D3rmKR33hCAfWHrfdoSfi5LciefckTekrl6s2h/SJ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AspY0pqQ9rkb1+/b/hXKPbH+zkKFSTARhSRweHx5zv2uhQu9SwhJSZHciGlYO/mRFN7FA/9qNYa0ev4kIv1sH1WbYnHen1jSAKcd6g5eWYXSxGcKTp1hlt/7/OQNzoQUGQKljXbAxJUUq3LtSPcWx17rdASBdFNvKVElx/jpyH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MMMsavny; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MMMsavny"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEBAC1476;
	Mon,  3 Aug 2026 06:45:56 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF5403F66F;
	Mon,  3 Aug 2026 06:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764760; bh=D3rmKR33hCAfWHrfdoSfi5LciefckTekrl6s2h/SJ3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMMsavny4J4ESoteQjAOh1WpxAz8t29ZqB7TAHFE9vPROBFXqRrzGFjOAhFaMlBSi
	 fF3zkXofpA5y2mBTrIjTmIjtXAjU983ILUUcUlzpHM5mkKnS+4xN4rdH5XpFJ93jaE
	 inYciD8VY2HyweZan3e9H8iq9hRmxhJ+JtCHt9b8=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 22/45] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
Date: Mon,  3 Aug 2026 14:43:38 +0100
Message-ID: <20260803134403.80630-23-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The guest can request that a region of its protected address space is
switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
RSI_IPA_STATE_SET. This causes a guest exit with the
RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
protected region to unprotected (or back), exiting to the VMM to make
the necessary changes to the guest_memfd and memslot mappings. On the
next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
calls.

The VMM may wish to reject the RIPAS change requested by the guest. For
now it can only do this by no longer scheduling the VCPU as we don't
currently have a usecase for returning that rejection to the guest, but
by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
open for adding a new ioctl in the future for this purpose.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Propagate negative error returns.
Changes since v14:
 * Use addition rather than bitwise OR for adding the shared_bit in
   realm_unmap_shared_range(), this handles the case where the region
   includes the last address (which means 'end' already has the bit
   set).
Changes since v13:
 * Switch to the new RMI_RTT_UNPROT_UNMAP range-based API.
 * Drop ugly hack for RMM bug which errored when the RIPAS was already
   set to the desired value.
Changes since v12:
 * Switch to the new RMM v2.0 RMI_RTT_DATA_UNMAP which can unmap an
   address range.
Changes since v11:
 * Combine the "Allow VMM to set RIPAS" patch into this one to avoid
   adding functions before they are used.
 * Drop the CAP for setting RIPAS and adapt to changes from previous
   patches.
Changes since v10:
 * Add comment explaining the assignment of rec->run->exit.ripas_base in
   kvm_complete_ripas_change().
Changes since v8:
 * Make use of ripas_change() from a previous patch to implement
   realm_set_ipa_state().
 * Update exit.ripas_base after a RIPAS change so that, if instead of
   entering the guest we exit to user space, we don't attempt to repeat
   the RIPAS change (triggering an error from the RMM).
Changes since v7:
 * Rework the loop in realm_set_ipa_state() to make it clear when the
   'next' output value of rmi_rtt_set_ripas() is used.
New patch for v7: The code was previously split awkwardly between two
other patches.
---
 arch/arm64/include/asm/kvm_rmi.h |   6 +
 arch/arm64/kvm/mmu.c             |   8 +-
 arch/arm64/kvm/rmi.c             | 473 +++++++++++++++++++++++++++++++
 3 files changed, 484 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 1e5026039458..751659a48be3 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -107,6 +107,12 @@ int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 int kvm_rec_handle_request(struct kvm_vcpu *vcpu);
 bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret);
 
+void kvm_realm_unmap_range(struct kvm *kvm,
+			   unsigned long ipa,
+			   unsigned long size,
+			   bool unmap_private,
+			   bool may_block);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cd06881c1497..dcc2ab08d0e4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -319,6 +319,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
  * @may_block: Whether or not we are permitted to block
+ * @only_shared: If true then protected mappings should not be unmapped
  *
  * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
  * be called while holding mmu_lock (unless for freeing the stage2 pgd before
@@ -326,7 +327,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * with things behind our backs.
  */
 static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
-				 bool may_block)
+				 bool may_block, bool only_shared)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	phys_addr_t end = start + size;
@@ -343,7 +344,7 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
 		return;
 
-	__unmap_stage2_range(mmu, start, size, may_block);
+	__unmap_stage2_range(mmu, start, size, may_block, false);
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
@@ -2467,7 +2468,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+			     range->may_block,
+			     !(range->attr_filter & KVM_FILTER_PRIVATE));
 
 	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 92085b88f427..a7202054c8e6 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -35,6 +35,83 @@ static int get_start_level(struct realm *realm)
 	return 4 - stage2_pgtable_levels(realm->ia_bits);
 }
 
+static int find_map_level(struct realm *realm,
+			  unsigned long start,
+			  unsigned long end)
+{
+	int level = KVM_PGTABLE_LAST_LEVEL;
+
+	while (level > get_start_level(realm)) {
+		unsigned long map_size = rmi_rtt_level_mapsize(level - 1);
+
+		if (!IS_ALIGNED(start, map_size) ||
+		    (start + map_size) > end)
+			break;
+
+		level--;
+	}
+
+	return level;
+}
+
+static unsigned long rmi_range_entry_size(int rmi_size)
+{
+	if (WARN_ON(rmi_size > KVM_PGTABLE_LAST_LEVEL))
+		return 0;
+
+	return kvm_granule_size(KVM_PGTABLE_LAST_LEVEL - rmi_size);
+}
+
+static int undelegate_range_desc(unsigned long desc)
+{
+	unsigned long size = rmi_range_entry_size(RMI_ADDR_RANGE_SIZE(desc));
+	unsigned long count = RMI_ADDR_RANGE_COUNT(desc);
+	unsigned long addr = RMI_ADDR_RANGE_ADDR(desc);
+	unsigned long state = RMI_ADDR_RANGE_STATE(desc);
+
+	if (state == RMI_OP_MEM_UNDELEGATED)
+		return 0;
+
+	if (size * count == 0)
+		return 0;
+
+	return rmi_undelegate_range(addr, size * count);
+}
+
+static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
+{
+	phys_addr_t phys;
+	void *virt;
+
+	if (mc) {
+		virt = kvm_mmu_memory_cache_alloc(mc);
+	} else {
+		virt = (void *)__get_free_page(GFP_ATOMIC | __GFP_ZERO |
+					       __GFP_ACCOUNT);
+	}
+
+	if (!virt)
+		return PHYS_ADDR_MAX;
+
+	phys = virt_to_phys(virt);
+	if (rmi_delegate_page(phys)) {
+		free_page((unsigned long)virt);
+		return PHYS_ADDR_MAX;
+	}
+
+	return phys;
+}
+
+static phys_addr_t alloc_rtt(struct kvm_mmu_memory_cache *mc)
+{
+	phys_addr_t phys = alloc_delegated_granule(mc);
+
+	if (phys != PHYS_ADDR_MAX)
+		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
+
+	return phys;
+}
+
 static void free_rtt(phys_addr_t phys)
 {
 	if (free_delegated_page(phys))
@@ -43,6 +120,32 @@ static void free_rtt(phys_addr_t phys)
 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
 }
 
+static long realm_rtt_create(struct realm *realm,
+			     unsigned long addr,
+			     int level,
+			     phys_addr_t phys)
+{
+	addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
+	return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
+}
+
+static long realm_rtt_fold(struct realm *realm,
+			   unsigned long addr,
+			   int level,
+			   phys_addr_t *rtt_granule)
+{
+	unsigned long out_rtt;
+	long ret;
+
+	addr = ALIGN_DOWN(addr, rmi_rtt_level_mapsize(level - 1));
+	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
+
+	if (rtt_granule)
+		*rtt_granule = out_rtt;
+
+	return ret;
+}
+
 /*
  * realm_rtt_destroy - Destroy an RTT at @level for @addr.
  *
@@ -66,6 +169,43 @@ static long realm_rtt_destroy(struct realm *realm, unsigned long addr,
 	return ret;
 }
 
+static int realm_create_rtt_levels(struct realm *realm,
+				   unsigned long ipa,
+				   int level,
+				   int max_level,
+				   struct kvm_mmu_memory_cache *mc)
+{
+	while (level++ < max_level) {
+		phys_addr_t rtt = alloc_rtt(mc);
+		long ret;
+
+		if (rtt == PHYS_ADDR_MAX)
+			return -ENOMEM;
+
+		ret = realm_rtt_create(realm, ipa, level, rtt);
+		if (ret < 0) {
+			free_rtt(rtt);
+			return ret;
+		}
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
+		    RMI_RETURN_INDEX(ret) == level - 1) {
+			/* The RTT already exists, continue */
+			free_rtt(rtt);
+			continue;
+		}
+
+		if (ret) {
+			WARN(1, "Failed to create RTT at level %d: %ld\n",
+			     level, ret);
+			free_rtt(rtt);
+			return -ENXIO;
+		}
+	}
+
+	return 0;
+}
+
 static int realm_tear_down_rtt_level(struct realm *realm, int level,
 				     unsigned long start, unsigned long end)
 {
@@ -162,6 +302,64 @@ static int realm_tear_down_rtt_range(struct realm *realm,
 					 start, end);
 }
 
+/*
+ * Returns 0 on successful fold, a negative value on error, a positive value if
+ * we were not able to fold all tables at this level.
+ */
+static int realm_fold_rtt_level(struct realm *realm, int level,
+				unsigned long start, unsigned long end)
+{
+	int not_folded = 0;
+	ssize_t map_size;
+	unsigned long addr, next_addr;
+
+	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
+		return -EINVAL;
+
+	map_size = rmi_rtt_level_mapsize(level - 1);
+
+	for (addr = start; addr < end; addr = next_addr) {
+		phys_addr_t rtt_granule;
+		long ret;
+		unsigned long align_addr = ALIGN(addr, map_size);
+
+		next_addr = ALIGN(addr + 1, map_size);
+
+		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
+		if (ret < 0)
+			return ret;
+
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			free_rtt(rtt_granule);
+			break;
+		case RMI_ERROR_RTT:
+			if (level == KVM_PGTABLE_LAST_LEVEL ||
+			    RMI_RETURN_INDEX(ret) < level) {
+				not_folded++;
+				break;
+			}
+			/* Recurse a level deeper */
+			ret = realm_fold_rtt_level(realm,
+						   level + 1,
+						   addr,
+						   next_addr);
+			if (ret < 0) {
+				return ret;
+			} else if (ret == 0) {
+				/* Try again at this level */
+				next_addr = addr;
+			}
+			break;
+		default:
+			WARN_ON(1);
+			return -ENXIO;
+		}
+	}
+
+	return not_folded;
+}
+
 static int realm_destroy_rtts(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
@@ -206,6 +404,279 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
 	return realm_destroy_rtts(kvm);
 }
 
+static void realm_unmap_shared_range(struct kvm *kvm,
+				     unsigned long start,
+				     unsigned long end,
+				     bool may_block)
+{
+	struct realm *realm = &kvm->arch.realm;
+	unsigned long rd = virt_to_phys(realm->rd);
+	unsigned long next_addr, addr;
+	unsigned long shared_bit = BIT(realm->ia_bits - 1);
+
+	if (start >= end)
+		return;
+
+	start += shared_bit;
+	end += shared_bit;
+
+	for (addr = start; addr < end; addr = next_addr) {
+		long ret;
+
+		ret = rmi_rtt_unprot_unmap(rd, addr, end, RMI_ADDR_TYPE_NONE,
+					   0, &next_addr, NULL, NULL);
+		if (WARN_ON(ret < 0))
+			return;
+
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			break;
+		case RMI_ERROR_RTT: {
+			int err_level = RMI_RETURN_INDEX(ret);
+			int level = find_map_level(realm, addr, end);
+
+			if (err_level >= level) {
+				/* Nothing present, so skip */
+				next_addr = addr + rmi_rtt_level_mapsize(err_level);
+				break;
+			}
+
+			ret = realm_create_rtt_levels(realm, addr, err_level,
+						      level, NULL);
+			if (WARN_ON(ret))
+				return;
+			/* Retry with the RTT levels in place */
+			next_addr = addr;
+			break;
+		}
+		default:
+			WARN_ON(1);
+			return;
+		}
+
+		if (may_block)
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+	}
+
+	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
+			     start, end);
+}
+
+static void realm_unmap_private_range(struct kvm *kvm,
+				      unsigned long start,
+				      unsigned long end,
+				      bool may_block)
+{
+	struct realm *realm = &kvm->arch.realm;
+	unsigned long rd = virt_to_phys(realm->rd);
+	unsigned long next_addr, addr;
+	long ret;
+
+	for (addr = start; addr < end; addr = next_addr) {
+		unsigned long out_range;
+		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
+		/* TODO: Optimise using RMI_ADDR_TYPE_LIST */
+
+retry:
+		ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
+					 &next_addr, &out_range, NULL);
+		if (WARN_ON(ret < 0))
+			return;
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+			phys_addr_t rtt;
+
+			if (next_addr > addr)
+				continue; /* UNASSIGNED */
+
+			rtt = alloc_rtt(NULL);
+			if (WARN_ON(rtt == PHYS_ADDR_MAX))
+				return;
+			ret = realm_rtt_create(realm, addr,
+					       RMI_RETURN_INDEX(ret) + 1, rtt);
+			if (WARN_ON(ret)) {
+				free_rtt(rtt);
+				return;
+			}
+			goto retry;
+		} else if (WARN_ON(ret)) {
+			continue;
+		}
+
+		ret = undelegate_range_desc(out_range);
+		if (WARN_ON(ret))
+			break;
+
+		if (may_block)
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+	}
+
+	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
+			     start, end);
+}
+
+void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
+			   unsigned long size, bool unmap_private,
+			   bool may_block)
+{
+	unsigned long end = start + size;
+	struct realm *realm = &kvm->arch.realm;
+
+	if (!kvm_realm_is_created(kvm))
+		return;
+
+	end = min(BIT(realm->ia_bits - 1), end);
+
+	realm_unmap_shared_range(kvm, start, end, may_block);
+	if (unmap_private)
+		realm_unmap_private_range(kvm, start, end, may_block);
+}
+
+enum ripas_action {
+	RIPAS_INIT,
+	RIPAS_SET,
+};
+
+static int ripas_change(struct kvm *kvm,
+			struct kvm_vcpu *vcpu,
+			unsigned long ipa,
+			unsigned long end,
+			enum ripas_action action,
+			unsigned long *top_ipa)
+{
+	struct realm *realm = &kvm->arch.realm;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+	phys_addr_t rec_phys;
+	struct kvm_mmu_memory_cache *memcache = NULL;
+	long ret = 0;
+
+	if (vcpu) {
+		rec_phys = vcpu->arch.rec.rec_phys;
+		memcache = &vcpu->arch.mmu_page_cache;
+
+		WARN_ON(action != RIPAS_SET);
+	} else {
+		WARN_ON(action != RIPAS_INIT);
+	}
+
+	while (ipa < end) {
+		unsigned long next = ~0;
+
+		switch (action) {
+		case RIPAS_INIT:
+			ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
+			break;
+		case RIPAS_SET:
+			ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
+						&next);
+			break;
+		}
+
+		if (ret < 0)
+			goto out;
+
+		switch (RMI_RETURN_STATUS(ret)) {
+		case RMI_SUCCESS:
+			ipa = next;
+			break;
+		case RMI_ERROR_RTT: {
+			int err_level = RMI_RETURN_INDEX(ret);
+			int level = find_map_level(realm, ipa, end);
+
+			/*
+			 * If the operation failed at deeper level than
+			 * what is required for the address range, this
+			 * implies encountering an unexpected entry,
+			 * (e.g., RIPAS_DESTROYED), which the RMM prevents
+			 * us from modifying. This is only applicable for
+			 * RMI_RTT_INIT_RIPAS. All the other requests
+			 * are generated by the Realm and thus RMM should
+			 * be able to allow the transition.
+			 */
+			if (action == RIPAS_INIT && WARN_ON_ONCE(err_level >= level))
+				return -ENXIO;
+
+			ret = realm_create_rtt_levels(realm, ipa, err_level,
+						      level, memcache);
+			if (ret)
+				goto out;
+			/* Retry with the RTT levels in place */
+			break;
+		}
+		default:
+			WARN_ON(1);
+			ret = -ENXIO;
+			goto out;
+		}
+	}
+
+out:
+	if (top_ipa)
+		*top_ipa = ipa;
+
+	return ret;
+}
+
+static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
+			       unsigned long start,
+			       unsigned long end,
+			       unsigned long ripas,
+			       unsigned long *top_ipa)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int ret = ripas_change(kvm, vcpu, start, end, RIPAS_SET, top_ipa);
+
+	if (!ret && ripas == RMI_EMPTY && *top_ipa != start)
+		realm_unmap_private_range(kvm, start, *top_ipa, false);
+
+	return ret;
+}
+
+static int kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long base = rec->run->exit.ripas_base;
+	unsigned long top = rec->run->exit.ripas_top;
+	unsigned long ripas = rec->run->exit.ripas_value;
+	unsigned long top_ipa = base;
+	int ret;
+
+	do {
+		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		write_lock(&kvm->mmu_lock);
+		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
+		write_unlock(&kvm->mmu_lock);
+
+		if (ret == -ENOMEM) {
+			/* If no progress, then stop */
+			if (top_ipa == base)
+				break;
+			base = top_ipa;
+			continue;
+		}
+
+		if (WARN_RATELIMIT(ret,
+				   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
+				   base, top, ripas))
+			break;
+
+		base = top_ipa;
+	} while (base < top);
+
+	/*
+	 * If this function is called again before the REC_ENTER call then
+	 * avoid calling realm_set_ipa_state() again by changing to the value
+	 * of ripas_base for the part that has already been covered. The RMM
+	 * ignores the contains of the rec_exit structure so this doesn't
+	 * affect the RMM.
+	 */
+	rec->run->exit.ripas_base = base;
+
+	return 1;
+}
+
 int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -224,6 +695,8 @@ int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
 					vcpu_get_reg(vcpu, rt);
 		}
 		break;
+	case RMI_EXIT_RIPAS_CHANGE:
+		return kvm_complete_ripas_change(vcpu);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unhandled realm exit_reason");
 		return -ENXIO;
-- 
2.43.0

