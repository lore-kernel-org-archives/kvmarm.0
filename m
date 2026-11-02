Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628849;
	b=tIv8p9hfOGtEiXy6Zuh6hKnLQLw4Ld2Jqu12EQp7nqmB4cz4Gh9JiV7TayEg/menYcs4
	 3fX5vSm4dBKc9GfMk5NxhFyzEtUH+AVItYWDtbk0ld0pomxKqB98Jawe4BohtJwvj58ot
	 sOVMPE05IyXxHx3VAXrjY10AK7z/Osew9kOSfojmzqL8ZDCLMcWGFiMgUQc2LhjOKBvkX
	 pkPyxFRKJe2Wz5Noz+vbhPKs1ymvEx0Zr4GJXfbYc/IaUKA/+TEx3LsPCWehsZUYWfbO1
	 nsYFcq3V6Y/8d5pKc9qrkJ9x/K/mhSAgMReZWC8zBLXCkq2yp29OxLs3QrICVsg4p9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628849;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9ZGjrl9PKr+uswQ5PtAFNWT30SOg7tsoOCxTlci38Jo=;
	b=dZiwQ2pJxQltVMMTmTOKNWWtDOvmDMh2V2JobSJ6ennDfEI0wDpdmKOPXsRHdP+IKlEM
	 c2XJemiMNwBTCgt0DPu5QJN79lE53Ox/rU79F9X62W3Mx2lsISGmQm+l2aWr9fiNzxr6u
	 86ALmt1PrChdWpOzb9vEwrfqftXRPuwuYvbKscelP222D3a2fPX5vVGGENub20hKRuoNr
	 T1u/zrexpUrOE1Q9n/tPcCGNR1sDVrwnA15GIxaKvwl5D6tVozKtJUkdbqahecrqT64xS
	 xw0O4oRC64agvL9HiKYQO7KdNL/kEt7K/KbXf3KgzFsjNHEzd/WCF18YRqL8qYkNs2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k8DEx1go;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C0B60A2609;
	Mon,  2 Nov 2026 14:14:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1C0B60A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k8DEx1go
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C8B22A6B;
	Mon,  2 Nov 2026 06:14:05 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D1473F59E;
	Mon,  2 Nov 2026 06:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793628848; bh=hq8zqoA0yJY5Rs0XikoK6TYOnBWWZZOHAdmOCWfeoyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8DEx1go+S+RK7LnUOEiNdIDAPjKvarwjqVHps7d23+fkffEMbtYHN7GSGw0JFhax
	 B4mSljD6SfWVrxnWfLhfic5Tlsq74YHy7HLQM7ib0/6wZDXjFd5wv+04Iu6GIWs892
	 Gdh1vZIhG5q/z/B2Z5gci1StrvvR0kIVFj7lAE5U=
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
Subject: [PATCH 08/11] KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
Date: Mon,  2 Nov 2026 14:12:59 +0000
Message-ID: <20261102141304.126883-9-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102141304.126883-1-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
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
 arch/arm64/include/asm/kvm_rmi.h |  14 ++
 arch/arm64/kvm/rmi.c             | 346 +++++++++++++++++++++++++++++++
 2 files changed, 360 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 58d825e40bdf..72a9449f00d7 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -81,6 +81,20 @@ int kvm_init_realm(struct kvm *kvm);
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
+void kvm_realm_unmap_range(struct kvm *kvm,
+			   unsigned long ipa,
+			   unsigned long size,
+			   bool unmap_private,
+			   bool may_block);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index f190143b33ba..1066f767f85d 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -34,6 +34,83 @@ static int get_start_level(struct realm *realm)
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
+	unsigned long size = rmi_range_entry_size(RMI_ADDR_RANGE_BLOCK_SIZE(desc));
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
 	if (rmi_free_delegated_page(phys))
@@ -42,6 +119,32 @@ static void free_rtt(phys_addr_t phys)
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
@@ -65,6 +168,43 @@ static long realm_rtt_destroy(struct realm *realm, unsigned long addr,
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
+		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT &&
+		    RMI_RESULT_DATA_LEVEL(ret) == level - 1) {
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
@@ -161,6 +301,64 @@ static int realm_tear_down_rtt_range(struct realm *realm,
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
+		switch (RMI_RESULT_STATUS(ret)) {
+		case RMI_SUCCESS:
+			free_rtt(rtt_granule);
+			break;
+		case RMI_ERROR_RTT:
+			if (level == KVM_PGTABLE_LAST_LEVEL ||
+			    RMI_RESULT_DATA_LEVEL(ret) < level) {
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
@@ -196,6 +394,154 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
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
+		if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
+			phys_addr_t rtt;
+
+			if (next_addr > addr)
+				continue; /* UNASSIGNED */
+
+			rtt = alloc_rtt(NULL);
+			if (WARN_ON(rtt == PHYS_ADDR_MAX))
+				return;
+			ret = realm_rtt_create(realm, addr,
+					       RMI_RESULT_DATA_LEVEL(ret) + 1, rtt);
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
+void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
+			   unsigned long size, bool unmap_private,
+			   bool may_block)
+{
+	enum kvm_gfn_range_filter attr_filter = KVM_FILTER_SHARED;
+
+	if (unmap_private)
+		attr_filter |= KVM_FILTER_PRIVATE;
+
+	kvm_realm_unmap_range_filter(kvm, start, size, may_block, attr_filter);
+}
+
 void kvm_destroy_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
-- 
2.43.0

