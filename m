Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409131;
	b=WwqpD80z+pfNbxQ/0tEvt4dhPyyfqdwrIJf2Nzs1828jZxmz37t0njeQEXIecGYOLO7y
	 o1V7qug39kCWj4swNg6t3sNP4BcmFqavVQa2AvN/iBJAiSCHMAjW7BTZF5C+7hOgUbrT9
	 dgnKZ2KxJJaBj6ZNBllTzSwmW8a7jXPF3j70a5eczvM7CEq5dNIxDqDpShOmX4mhdqlyU
	 Zyu/xGNHI/33SpTVcq7vn2M4Nf7Zt0MfQjmkwer8QaifOvMuXJrvKDEaheHGCdaJLJsfD
	 ba9s0EqSPYYmfnXK2LNrovvhcPQKsJ709JCj9pSLamieUNZVKV2FzIZMSTLqYAb8tDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409131;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=w0cV+cWFxmI87rDFqGc1/Zuznxjmm+2ubSDt2SXKnMs=;
	b=t779u99jUeAAE3BFbEssUKD0Dv+CtI7FsQ0yCaovpzJrGYYp3G4oPpw1KneifT8MQJIa
	 EHCIngXDXexuAOjaDFEHO/dvJiNGI5YfcioqaLVbSVhoUPU6oRMmkX6JB+tcS2ADNy3CU
	 NdU0gBohZC2+aX0wFxAq0eCd8ZzKqKG/y0glKdb1+7pbx14R3+ph33xo4SyceGYWMPS1C
	 lyuQnbycD5no/aTzNmudlV8yUXMVLgWzAPiBCJslNeE4RUyJgJHPsB6af5MK9VWss3j4Y
	 TnYK1gaoLPkbKP0KRaABCsgIvJplUk4V8vzKkHAOik6ymTnlVhT5+eLa9EtqnH8IDKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=egAu9PXT;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15415606A8A7;
	Wed, 11 Nov 2026 14:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15415606A8A7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=egAu9PXT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E7761682;
	Wed, 11 Nov 2026 06:58:47 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9EC93F632;
	Wed, 11 Nov 2026 06:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409130; bh=dTkl7J7Cc2VkG4kc2eu1y/BoR6chEsXrpuujAv8GNhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egAu9PXTq25OCPcwa/jP7R+l02g03CgT8Vx90rSqSOUEeHjMSDh4ev9a6OepUO5dQ
	 8I1rF5Nd4BzldWQ9mkFWjUXvtRHJfWiI+JQQeTHX5Ox2uzsBbFvNhCBX+MFParek8h
	 4B/lNxH/E3W5onBSVgRSPOTKlHEyPDMRpligPoDs=
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH v2 08/12] KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
Date: Wed, 11 Nov 2026 14:57:52 +0000
Message-ID: <20261111145758.217946-9-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111145758.217946-1-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the RMI RTT creation and unmap helpers needed by CCA Realm stage-2
memory operations. REC exit handling and guest requested RIPAS changes
follow in the vCPU series.

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v1:
- Rework RTT creation and folding around missing or existing RTTs.
  Use a shared RMI block-size helper and handle alignment, partial
  progress and errors in range operations.
---
 arch/arm64/include/asm/kvm_rmi.h |   8 +
 arch/arm64/kvm/rmi.c             | 378 ++++++++++++++++++++++++++++++-
 drivers/firmware/arm_rmm/rmi.c   |  10 -
 include/linux/arm-rmi-cmds.h     |   8 +
 4 files changed, 385 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 58d825e40bdf..e64c3bcce160 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -81,6 +81,14 @@ int kvm_init_realm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
 int kvm_realm_teardown_stage2(struct kvm *kvm);
 
+enum kvm_gfn_range_filter;
+
+void kvm_realm_unmap_range_filter(struct kvm *kvm,
+				  unsigned long ipa,
+				  unsigned long size,
+				  bool may_block,
+				  enum kvm_gfn_range_filter attr_filter);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index b904e6541fb0..5aa34d68de59 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -11,14 +11,6 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/virt.h>
 
-static inline unsigned long rmi_rtt_level_mapsize(int level)
-{
-	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
-		return PAGE_SIZE;
-
-	return (1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
-}
-
 u32 kvm_rmm_ipa_limit(void)
 {
 	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
@@ -29,6 +21,75 @@ static int get_start_level(struct realm *realm)
 	return 4 - max(2, stage2_pgtable_levels(realm->ia_bits));
 }
 
+static int find_map_level(struct realm *realm,
+			  unsigned long start,
+			  unsigned long end)
+{
+	int level = KVM_PGTABLE_LAST_LEVEL;
+
+	while (level > get_start_level(realm)) {
+		unsigned long map_size = kvm_granule_size(level - 1);
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
+static int undelegate_range_desc(unsigned long desc)
+{
+	unsigned long size = rmi_addr_block_size_to_bytes(RMI_ADDR_RANGE_BLOCK_SIZE(desc));
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
 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
@@ -36,6 +97,32 @@ static void free_rtt(phys_addr_t phys)
 		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
 }
 
+static long realm_rtt_create(struct realm *realm,
+			     unsigned long addr,
+			     int level,
+			     phys_addr_t phys)
+{
+	addr = ALIGN_DOWN(addr, kvm_granule_size(level - 1));
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
+	addr = ALIGN_DOWN(addr, kvm_granule_size(level - 1));
+	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
+
+	if (ret == RMI_SUCCESS && rtt_granule)
+		*rtt_granule = out_rtt;
+
+	return ret;
+}
+
 /*
  * realm_rtt_destroy - Destroy an RTT at @level for @addr.
  *
@@ -60,6 +147,47 @@ static long realm_rtt_destroy(struct realm *realm, unsigned long addr,
 	return ret;
 }
 
+static int realm_create_rtt_levels(struct realm *realm,
+				   unsigned long ipa,
+				   int level,
+				   int max_level,
+				   struct kvm_mmu_memory_cache *mc)
+{
+	long ret = 0;
+	phys_addr_t rtt = PHYS_ADDR_MAX;
+
+	while (level++ < max_level) {
+		if (rtt == PHYS_ADDR_MAX)
+			rtt = alloc_rtt(mc);
+		if (rtt == PHYS_ADDR_MAX)
+			return -ENOMEM;
+
+		ret = realm_rtt_create(realm, ipa, level, rtt);
+		if (ret < 0)
+			break;
+
+		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT &&
+		    RMI_RESULT_DATA_LEVEL(ret) == level - 1) {
+			/* The RTT already exists, reuse the granule at the next level. */
+			ret = 0;
+			continue;
+		}
+
+		if (ret) {
+			WARN(1, "Failed to create RTT at level %d: %ld\n",
+			     level, ret);
+			ret = -ENXIO;
+			break;
+		}
+		rtt = PHYS_ADDR_MAX;
+	}
+
+	if (rtt != PHYS_ADDR_MAX)
+		free_rtt(rtt);
+
+	return ret;
+}
+
 static int realm_tear_down_rtt_level(struct realm *realm, int level,
 				     unsigned long start, unsigned long end)
 {
@@ -69,7 +197,9 @@ static int realm_tear_down_rtt_level(struct realm *realm, int level,
 	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
 		return -EINVAL;
 
-	map_size = rmi_rtt_level_mapsize(level - 1);
+	map_size = kvm_granule_size(level - 1);
+	if (WARN_ON(!IS_ALIGNED(start, map_size)))
+		return -EINVAL;
 
 	for (addr = start; addr < end; addr = next_addr) {
 		phys_addr_t rtt_granule;
@@ -156,12 +286,94 @@ static int realm_tear_down_rtt_range(struct realm *realm,
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
+	map_size = kvm_granule_size(level - 1);
+
+	for (addr = start; addr < end; addr = next_addr) {
+		phys_addr_t rtt_granule;
+		long ret;
+
+		next_addr = ALIGN(addr + 1, map_size);
+
+		ret = realm_rtt_fold(realm, addr, level, &rtt_granule);
+		if (ret < 0)
+			return ret;
+
+		switch (RMI_RESULT_STATUS(ret)) {
+		case RMI_SUCCESS:
+			free_rtt(rtt_granule);
+			break;
+		case RMI_ERROR_RTT: {
+			int err_level = RMI_RESULT_DATA_LEVEL(ret);
+
+			if (err_level < level) {
+				/* No RTT at this level; skip the missing ancestor. */
+				if (WARN_ON(err_level < get_start_level(realm)))
+					return -EINVAL;
+				next_addr = ALIGN(addr + 1,
+						  kvm_granule_size(err_level - 1));
+				break;
+			}
+			if (level == KVM_PGTABLE_LAST_LEVEL) {
+				not_folded++;
+				break;
+			}
+			/* Recurse a level deeper */
+			ret = realm_fold_rtt_level(realm,
+						   level + 1,
+						   addr,
+						   min(next_addr, end));
+			if (ret < 0)
+				return ret;
+			if (ret) {
+				not_folded++;
+				break;
+			}
+			/* Try once more after folding the child RTTs. */
+			ret = realm_rtt_fold(realm, addr, level, &rtt_granule);
+			if (ret < 0)
+				return ret;
+			if (RMI_RESULT_STATUS(ret) == RMI_SUCCESS) {
+				free_rtt(rtt_granule);
+				break;
+			}
+			if (RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT) {
+				WARN_ON(1);
+				return -ENXIO;
+			}
+			not_folded++;
+			break;
+		}
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
 	unsigned int ia_bits = realm->ia_bits;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
+	if (WARN_ON_ONCE(!realm->stage2_unmapped))
+		return -EINVAL;
 
 	return realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits));
 }
@@ -191,6 +403,154 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
 	return 0;
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
+	/*
+	 * Callers may pass either an IPA range or its shared alias. Add the
+	 * shared bit only for the former. Use addition so an exclusive end at
+	 * shared_bit advances to the end of the IPA space.
+	 */
+	if (start < shared_bit) {
+		start += shared_bit;
+		end += shared_bit;
+	}
+
+	for (addr = start; addr < end; addr = next_addr) {
+		long ret;
+
+		ret = rmi_rtt_unprot_unmap(rd, addr, end, RMI_ADDR_TYPE_NONE,
+					   0, &next_addr, NULL, NULL);
+		if (WARN_ON(ret < 0))
+			return;
+
+		switch (RMI_RESULT_STATUS(ret)) {
+		case RMI_SUCCESS:
+			break;
+		case RMI_ERROR_RTT: {
+			int err_level = RMI_RESULT_DATA_LEVEL(ret);
+			int level = find_map_level(realm, addr, end);
+
+			if (WARN_ON(err_level > KVM_PGTABLE_LAST_LEVEL))
+				return;
+
+			if (err_level >= level) {
+				/* Nothing present, so skip */
+				next_addr = ALIGN(addr + 1,
+						  kvm_granule_size(err_level));
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
+		ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
+					 &next_addr, &out_range, NULL);
+		if (WARN_ON(ret < 0))
+			return;
+
+		switch (RMI_RESULT_STATUS(ret)) {
+		case RMI_SUCCESS:
+			ret = undelegate_range_desc(out_range);
+			if (WARN_ON(ret))
+				return;
+			break;
+		case RMI_ERROR_RTT: {
+			int err_level = RMI_RESULT_DATA_LEVEL(ret);
+			int level = find_map_level(realm, addr, end);
+
+			if (WARN_ON(err_level > KVM_PGTABLE_LAST_LEVEL))
+				return;
+
+			if (err_level >= level) {
+				/* Nothing present, so skip this RTT entry. */
+				next_addr = ALIGN(addr + 1,
+						  kvm_granule_size(err_level));
+				break;
+			}
+
+			ret = realm_create_rtt_levels(realm, addr, err_level,
+						      level, NULL);
+			if (WARN_ON(ret))
+				return;
+			/* Retry with the RTT levels in place. */
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
+void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
+				  unsigned long size, bool may_block,
+				  enum kvm_gfn_range_filter attr_filter)
+{
+	unsigned long end = start + size;
+	struct realm *realm = &kvm->arch.realm;
+
+	if (!kvm_realm_is_created(kvm))
+		return;
+
+	end = min(BIT(realm->ia_bits - 1), end);
+
+	if (attr_filter & KVM_FILTER_SHARED)
+		realm_unmap_shared_range(kvm, start, end, may_block);
+	if (attr_filter & KVM_FILTER_PRIVATE)
+		realm_unmap_private_range(kvm, start, end, may_block);
+}
+
 void kvm_destroy_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 77255a90e0a6..a9f42c9a4f79 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 
 #include <asm/memory.h>
-#include <asm/pgtable-hwdef.h>
 
 /* RMM v2.0 defines RmiFeatureRegister0 to RmiFeatureRegister4. */
 static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
@@ -183,15 +182,6 @@ int rmi_free_delegated_page(phys_addr_t phys)
 }
 EXPORT_SYMBOL_GPL(rmi_free_delegated_page);
 
-/*
- * Convert the RmiAddrBlockSize to actual size. This is used in RmiDonateReq
- * and RmiAddrRangeDesc*.
- */
-static unsigned long rmi_addr_block_size_to_bytes(unsigned long block_size_fld)
-{
-	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - block_size_fld));
-}
-
 /*
  * free_addr_range: Free memory described by the address range entry, which may
  *		    be partially consumed by RMM.
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 6f43eac7c7be..71ba94eb72c0 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -13,8 +13,16 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <asm/pgtable-hwdef.h>
+
 #define RMI_MAX_ADDR_LIST	256
 
+/* Convert the block size used by RmiDonateReq and RmiAddrRangeDesc. */
+static inline unsigned long rmi_addr_block_size_to_bytes(unsigned long block_size)
+{
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - block_size));
+}
+
 struct rmi_sro_state {
 	struct arm_smccc_1_2_regs regs;
 	int addr_count;
-- 
2.43.0

