Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847484;
	b=nIIVZV5v+gIVwB0a7jf+FhOVWTzoGFG+e81GVHFUDAMwpAC/u8YzgGR79Hi546kGKZEO
	 bpSQC9SgktFGiItu8bisdEtLzlVZobbGenqhf9E25zPzR5FgaU6ewW+V7Zh6cfo0SAlYj
	 vdEuAeHWjnuWXbNI7rcR61+/oEtrBnNBRdDVxe506t/LrodwXg1aeGPkQr72d/m6RIGyz
	 n1TFXGiBNKSd/lXOH2RDF8Wtuaks4lG1zys8tC71DGL/TCmWCiwHpq/wJysG807+HGZwV
	 Mdzaz1awGn/NUIere3SGyziSyCbhRCo4G83azg9yN6t3BWb6QF1ExE3BzX7+9u7/hoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847484;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f+kD4cpBlDIVWrb2kWFqjpIR6WZ8jJEM8dUZrrkb16A=;
	b=sfRA+WmFbQGPKhQMVl3c8pRYOR8id3PsrnW8xQb7RtrFdR4mi4fKQTEFM+sXEMBZ0/2a
	 Raj/H6UYaVZmx68RgRRiPUNHAGyIf/yyxHo20KfihWShIpj5OvzU6pxi9NtPo95rDatCl
	 GlMSs6P75uERZS6UkxdTPSgZYEs3s7e0chCNJrIcS/94ccAeCV1X56ttJ+A4zld/Rlus4
	 uu/PfblmI8k+Z/eELIQqdDslDH49C3X/Ka0AwnxtFGsGrLV7S4FXpDCKLgK0t5rHfpR8O
	 GxlU6sFEJI9zP9WT+Ap2T4NAAmH2G8Z8N+AadhgRvRrkejoVnzToU2Z4JxLwEs+Ayeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d6fe9L8+;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1520B606A33B;
	Mon, 16 Nov 2026 16:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1520B606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d6fe9L8+
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 839EC1A25;
	Mon, 16 Nov 2026 08:44:40 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1DCE3F763;
	Mon, 16 Nov 2026 08:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794847483; bh=MNDnJbINpedewLnuuBoOrPlRki0xWpfY7Fr/VhoqB/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6fe9L8+yRUrZRHJctHKwZbM5aWGNRk0pDkGoIeuuiM/S8N1gWbPCKbdRlBcz9FmC
	 rCPiRcWcWiacd0MjvMPnAQD3F72nGkPGLo0plwcoJBQr/vKGt0vo4nHOelT3ilOjo8
	 gS++NtX+35fPuadzEtcmmspyd/Gzmo8xPdSkPH1o=
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
Subject: [PATCH v3 05/11] KVM: arm64: CCA: Tear down RTTs
Date: Mon, 16 Nov 2026 16:43:51 +0000
Message-ID: <20261116164358.142785-6-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116164358.142785-1-steven.price@arm.com>
References: <20261116164358.142785-1-steven.price@arm.com>
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

The RMM owns the stage 2 page tables for a realm, and KVM must request
that the RMM creates/destroys entries as necessary. The physical pages
to store the page tables are delegated to the realm as required, and can
be undelegated when no longer used.

Creating new RTTs is the easy part, tearing down is a little more
tricky. The result of realm_rtt_destroy() can be used to effectively
walk the tree and destroy the entries (undelegating pages that were
given to the realm).

Tear down a created Realm whether it is still new or has been activated.
Unmap the Realm IPA space once during stage-2 teardown. Defer
destruction of non-root RTTs until final Realm destruction, after
REALM_TERMINATE and before destroying the RD; root RTTs remain until the
RD has gone away.

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v2:
- Use the actual stage-2 start level and correct the RTT skip
  granularity. Free SRO state on final teardown errors.

Changes since v1:
- Tear down created Realms in both NEW and ACTIVE states. Fix the
  RTT start level, page accounting on failed undelegation, and
  handling of RTT granules returned by RMI.
---
 arch/arm64/include/asm/kvm_rmi.h |   9 ++
 arch/arm64/kvm/mmu.c             |  18 ++-
 arch/arm64/kvm/rmi.c             | 194 +++++++++++++++++++++++++++++++
 3 files changed, 220 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 6994756a14e6..dd16c004b831 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -57,6 +57,7 @@ enum realm_state {
  * @sro: Preallocated SRO state context for Realm MMU operations
  * @state: The lifetime state machine for the realm
  * @ia_bits: Number of valid Input Address bits in the IPA
+ * @stage2_unmapped: The Realm stage-2 mappings have been removed
  */
 struct realm {
 	phys_addr_t rd_phys;
@@ -70,11 +71,19 @@ struct realm {
 	struct rmi_sro_state *sro;
 	enum realm_state state;
 	unsigned int ia_bits;
+	bool stage2_unmapped;
 };
 
 u32 kvm_rmm_ipa_limit(void);
 
 int kvm_init_realm(struct kvm *kvm);
 void kvm_destroy_realm(struct kvm *kvm);
+int kvm_realm_teardown_stage2(struct kvm *kvm);
+
+static inline bool kvm_realm_is_private_address(struct realm *realm,
+						unsigned long addr)
+{
+	return !(addr & BIT(realm->ia_bits - 1));
+}
 
 #endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ac72db3d4505..9baf2352d2a8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1145,9 +1145,25 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
+static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	mutex_lock(&kvm->arch.config_lock);
+	if (kvm_realm_state(kvm) == REALM_STATE_NEW ||
+	    kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
+		kvm_set_realm_state(kvm, REALM_STATE_DYING);
+		WARN_ON(kvm_realm_teardown_stage2(kvm));
+	}
+	mutex_unlock(&kvm->arch.config_lock);
+}
+
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	if (kvm_realm_is_created(kvm))
+		kvm_realm_uninit_stage2(&kvm->arch.mmu);
+	else
+		kvm_free_stage2_pgd(&kvm->arch.mmu);
 	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 57f59b618a96..74b89da4e801 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -16,22 +16,213 @@ u32 kvm_rmm_ipa_limit(void)
 	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
 }
 
+static int get_start_level(struct realm *realm)
+{
+	/*
+	 * kvm_init_ipa_range() enforces a minimum of 32 IPA bits
+	 * (ARM64_MIN_PARANGE_BITS).
+	 */
+	return 4 - stage2_pgtable_levels(realm->ia_bits);
+}
+
+static void free_rtt(phys_addr_t phys)
+{
+	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
+	if (rmi_free_delegated_page(phys))
+		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
+}
+
+/*
+ * realm_rtt_destroy - Destroy an RTT at @level for @addr.
+ *
+ * Returns - Result of the RMI_RTT_DESTROY call, and:
+ * @rtt_granule:	RTT granule, if the RTT was destroyed.
+ * @next_addr:		IPA corresponding to the next possible valid entry we
+ *			can target
+ */
+static long realm_rtt_destroy(struct realm *realm, unsigned long addr,
+			      int level, phys_addr_t *rtt_granule,
+			      unsigned long *next_addr)
+{
+	unsigned long out_rtt;
+	long ret;
+
+	ret = rmi_rtt_destroy(realm->rd_phys, addr, level,
+			      &out_rtt, next_addr);
+
+	if (ret == RMI_SUCCESS)
+		*rtt_granule = out_rtt;
+
+	return ret;
+}
+
+static int realm_tear_down_rtt_level(struct realm *realm, int level,
+				     unsigned long start, unsigned long end)
+{
+	ssize_t map_size;
+	unsigned long addr, next_addr;
+
+	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
+		return -EINVAL;
+
+	map_size = kvm_granule_size(level - 1);
+	if (WARN_ON(!IS_ALIGNED(start, map_size)))
+		return -EINVAL;
+
+	for (addr = start; addr < end; addr = next_addr) {
+		phys_addr_t rtt_granule;
+		long ret;
+		unsigned long align_addr = ALIGN(addr, map_size);
+
+		next_addr = ALIGN(addr + 1, map_size);
+
+		if (next_addr > end || align_addr != addr) {
+			/*
+			 * The target range is smaller than what this level
+			 * covers, recurse deeper.
+			 */
+			ret = realm_tear_down_rtt_level(realm,
+							level + 1,
+							addr,
+							min(next_addr, end));
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		ret = realm_rtt_destroy(realm, addr, level,
+					&rtt_granule, &next_addr);
+		if (ret < 0)
+			return ret;
+
+		switch (RMI_RESULT_STATUS(ret)) {
+		case RMI_SUCCESS:
+			free_rtt(rtt_granule);
+			break;
+		case RMI_ERROR_RTT:
+			if (next_addr > addr) {
+				/* Missing RTT, skip */
+				break;
+			}
+			/*
+			 * We tear down the RTT range for the full IPA
+			 * space, after everything is unmapped. Also we
+			 * descend down only if we cannot tear down a
+			 * top level RTT. Thus RMM must be able to walk
+			 * to the requested level. e.g., a block mapping
+			 * exists at L1 or L2.
+			 */
+			if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) != level))
+				return -EBUSY;
+			if (WARN_ON(level == KVM_PGTABLE_LAST_LEVEL))
+				return -EBUSY;
+
+			/*
+			 * The table has active entries in it, recurse deeper
+			 * and tear down the RTTs.
+			 */
+			next_addr = ALIGN(addr + 1, map_size);
+			ret = realm_tear_down_rtt_level(realm,
+							level + 1,
+							addr,
+							next_addr);
+			if (ret)
+				return ret;
+			/*
+			 * Now that the child RTTs are destroyed,
+			 * retry at this level.
+			 */
+			next_addr = addr;
+			break;
+		default:
+			WARN_ON(1);
+			return -ENXIO;
+		}
+	}
+
+	return 0;
+}
+
+static int realm_tear_down_rtt_range(struct realm *realm,
+				     unsigned long start, unsigned long end)
+{
+	/*
+	 * Root level RTTs can only be destroyed after the RD is destroyed. So
+	 * tear down everything below the root level
+	 */
+	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
+					 start, end);
+}
+
+static int realm_destroy_rtts(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	unsigned int ia_bits = realm->ia_bits;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	return realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits));
+}
+
+static void realm_unmap_stage2(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (realm->stage2_unmapped)
+		return;
+
+	write_lock(&kvm->mmu_lock);
+	kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
+			       BIT(realm->ia_bits - 1), true);
+	write_unlock(&kvm->mmu_lock);
+
+	realm->stage2_unmapped = true;
+}
+
+int kvm_realm_teardown_stage2(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	realm_unmap_stage2(kvm);
+	return 0;
+}
+
 void kvm_destroy_realm(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
 	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
 
+	/*
+	 * Serialize final RMM teardown with Realm creation and stage-2 teardown,
+	 * which also access Realm state under config_lock.
+	 */
+	guard(mutex)(&kvm->arch.config_lock);
+
 	if (!kvm_realm_is_created(kvm))
 		goto out_free_sro;
 
 	kvm_set_realm_state(kvm, REALM_STATE_DYING);
 
+	/*
+	 * REALM_DESTROY requires the realm to be non-live: all RECs must have
+	 * been destroyed and the root RTTs must be empty. Unmap the IPA space
+	 * and destroy any non-root RTTs before tearing down the RD. The root
+	 * RTT pages are still owned by the RMM at this point, so keep the KVM
+	 * pgtable alive until after REALM_DESTROY and undelegation.
+	 */
+	realm_unmap_stage2(kvm);
+
 	if (realm->rd_phys) {
 		phys_addr_t rd_phys = realm->rd_phys;
 
 		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
 			goto out_free_sro;
 
+		if (WARN_ON(realm_destroy_rtts(kvm)))
+			goto out_free_sro;
+
 		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
 			goto out_free_sro;
 		rmi_free_delegated_page(rd_phys);
@@ -44,6 +235,9 @@ void kvm_destroy_realm(struct kvm *kvm)
 
 	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
 
+	/* Now that the realm is destroyed, free the entry-level RTTs. */
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+
 out_free_sro:
 	kfree(realm->sro);
 	realm->sro = NULL;
-- 
2.43.0

