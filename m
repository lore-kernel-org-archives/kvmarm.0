Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628844;
	b=rvvrfTfy8TWpm+7DFU2kOSnS/1XpHwRpHOL97kNDsN/Ba333M8lc6u3JqkIGBdPPZGVs
	 OwSxqivrzvJ8AToaNwVcQI7NM82ezFRTWjiyKrXj6lko79fLINfGcxUYGifznk7QlQHC2
	 wSQhgXp+K4W0qlK5gYzuc7oxPSSkiwPjykjJmbSYUd1SiE6pJovTRKO/T/t+83XH9tcxu
	 HbDu1PzgeSef0V9Rn20joLe53sx45RYWuWqYpV2V07KX5Rt4C/oLo9SImJO+DOqgP5xM3
	 8hT+IISvETe9iAAepC8clQgqHlJguIFXKQT5qYIuMIQIRKXdqCpGm5J/wPFhkoTaZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628844;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hhfgOVJdNtvAKvMMAlMB+tTG2sdyeu2GcY5bkTFaCl4=;
	b=Ph0KH/fxd1vVkPaIrtdwtb8K5zUE2Gt2bZxPEaRgbcS3Hjfh1ApzCpBqmJQEQSvIO0N0
	 Wnv/fm1i/ZGj87t25rsslw39ff7NH6bZHXuooJ0V7Ug6GbNZnwMDmESiJ680H4otRoiEI
	 +WfDANYVZT+pv/aa2crpQFSFOwSIIMd0CMJXsey+wywDO6T2J5opzCwc28LQhdqzPyBDP
	 ltakvhk2C2m7MSI0q35R5tSqTbGAd95RfXH2tmfGy72zPkaaTqQcaeG8I55y8qJjJYFfu
	 oxxWIoErtXbYKa8b0EJZqnqYb0cMCSAk7eCq9kntJcJRp0yAiMGIo60LwxCv7r5cIoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tNVEtYz1;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A554C60A260C;
	Mon,  2 Nov 2026 14:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A554C60A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tNVEtYz1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1CBE19F0;
	Mon,  2 Nov 2026 06:13:59 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FCEC3F59E;
	Mon,  2 Nov 2026 06:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793628843; bh=6t1ZbeHw0asCe0zzWHPtNRjhDSD2fGCqJ1RNvTWHPZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNVEtYz1hz0TPuKO5dVNcPawZukohIzIi6eZYl3kx2gtIMI53teMRfvtIfR7bwX3K
	 1siJdGKrrmudBE8SGH48shj+P7Z4AYSXHWSJxMDtxLwrBtoPcqQxZZ50Q6A7rShFWb
	 DVBJwiRlG2uKAUY2I0Uz4c4IecU/HTKk+2LkTztk=
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
Subject: [PATCH 07/11] KVM: arm64: CCA: Tear down RTTs
Date: Mon,  2 Nov 2026 14:12:58 +0000
Message-ID: <20261102141304.126883-8-steven.price@arm.com>
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

The RMM owns the stage 2 page tables for a realm, and KVM must request
that the RMM creates/destroys entries as necessary. The physical pages
to store the page tables are delegated to the realm as required, and can
be undelegated when no longer used.

Creating new RTTs is the easy part, tearing down is a little more
tricky. The result of realm_rtt_destroy() can be used to effectively
walk the tree and destroy the entries (undelegating pages that were
given to the realm).

Unmap the Realm IPA space once during stage-2 teardown. Defer destruction
of non-root RTTs until final Realm destruction, after REALM_TERMINATE and
before destroying the RD; root RTTs remain until the RD has gone away.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rmi.h |   9 ++
 arch/arm64/kvm/mmu.c             |  17 ++-
 arch/arm64/kvm/rmi.c             | 189 +++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index f1a1ed6b91f5..58d825e40bdf 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -57,6 +57,7 @@ enum realm_state {
  * @sro: Preallocated SRO state context for Realm MMU operations
  * @state: The lifetime state machine for the realm
  * @ia_bits: Number of valid Input Address bits in the IPA
+ * @stage2_unmapped: The Realm stage-2 mappings have been removed
  */
 struct realm {
 	void *rd;
@@ -70,6 +71,7 @@ struct realm {
 	struct rmi_sro_state *sro;
 	enum realm_state state;
 	unsigned int ia_bits;
+	bool stage2_unmapped;
 };
 
 void kvm_init_rmi(void);
@@ -77,5 +79,12 @@ u32 kvm_rmm_ipa_limit(void);
 
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
index b049ea67d9af..51fda7b2ff7f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1145,9 +1145,24 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
+static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	mutex_lock(&kvm->arch.config_lock);
+	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
+		kvm_set_realm_state(kvm, REALM_STATE_DYING);
+		WARN_ON(kvm_realm_teardown_stage2(kvm));
+	}
+	mutex_unlock(&kvm->arch.config_lock);
+}
+
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	if (kvm_vm_is_realm(kvm))
+		kvm_realm_uninit_stage2(&kvm->arch.mmu);
+	else
+		kvm_free_stage2_pgd(&kvm->arch.mmu);
 	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 45ecbaa467d1..f190143b33ba 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -11,6 +11,14 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/virt.h>
 
+static inline unsigned long rmi_rtt_level_mapsize(int level)
+{
+	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
+		return PAGE_SIZE;
+
+	return (1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
+}
+
 static bool rmi_has_feature(int reg, unsigned long feature)
 {
 	return !!u64_get_bits(rmi_feat_reg(reg), feature);
@@ -21,11 +29,180 @@ u32 kvm_rmm_ipa_limit(void)
 	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
 }
 
+static int get_start_level(struct realm *realm)
+{
+	return 4 - stage2_pgtable_levels(realm->ia_bits);
+}
+
+static void free_rtt(phys_addr_t phys)
+{
+	if (rmi_free_delegated_page(phys))
+		return;
+
+	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
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
+	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
+			      &out_rtt, next_addr);
+
+	*rtt_granule = out_rtt;
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
+	map_size = rmi_rtt_level_mapsize(level - 1);
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
 
+	guard(mutex)(&kvm->arch.config_lock);
+
 	if (!kvm_realm_is_created(kvm)) {
 		kfree(realm->sro);
 		realm->sro = NULL;
@@ -34,12 +211,24 @@ void kvm_destroy_realm(struct kvm *kvm)
 
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
 	if (realm->rd) {
 		phys_addr_t rd_phys = virt_to_phys(realm->rd);
 
 		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
 			return;
 
+		if (WARN_ON(realm_destroy_rtts(kvm)))
+			return;
+
 		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
 			return;
 		rmi_free_delegated_page(rd_phys);
-- 
2.43.0

