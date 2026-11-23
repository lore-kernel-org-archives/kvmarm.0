Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430620;
	b=ARDCpIOTZ3LDgjMYeQa4NRD0vAxfUMrCve6Af7S8aQ+F9nvSFJXyRLtIBjFFI1xxHazt
	 egjw8G5/zzxTwDb3Bzda4zDLtKKHsClGaeCq33QWA0ZzAXKTz9zSZlF9nj1k5IAFOggcc
	 JvrXJv+E1KCauWWK8YelibsHlezTwTMHcNHZkEhb1cCuT3FQXpr9nqq8lfyKy0otd5xgC
	 MOOnFq1flaVzDbsv6GRnOc8GN5wGd/qL+tnFjr7SGlnhrNW5EZ1jj/UDTSXUYuXaoxNg8
	 bqcy+TpOU3AHllkghs1VFbUyHy0KkIAlLslF+60Rmscc3ChR7cYsqgvpienir8Z5+yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430620;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=u75N2UHCo0Q1IQlaoRk+wtzVKvHVQ52rjy0wDjruBvY=;
	b=UAfEnDztBpmo+bmVWYYfe8lq/Te+RwNV9ld5Z73aOfSZoyWEIW+J8VkxOrA1kq6FMHr3
	 j3h6d4BGCdFeciU8No57dZ3zPCSbsk4IpF+R8RQDPFWCGy7Ab4xKvnS2emeeU5FHaG/3V
	 Q2h+UiTi3hf9/XMXrwth4nj/FKMOrx8p/6xJ/ZP2vVy6w2cPKNN0SOow2oHbDUd7KI8VY
	 9veAvcn/0gzA2NoJ1Xvs1ghOxYr2psbFFT2wU8nsZrOF4IBQrHS1QKRHd88BcEeA08lA0
	 BiZexFgj9jy8zKeMy+DPXdAN8EySUuJ/r6xiH+GafqDPFO5L6yVAPOi3TOUWuVcI6+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GMFzn4c6;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD09E606A334;
	Mon, 23 Nov 2026 10:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD09E606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GMFzn4c6
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AF711476;
	Mon, 23 Nov 2026 02:43:36 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBC023F632;
	Mon, 23 Nov 2026 02:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430619; bh=XPK8ICnszazWaOOfoo2WmCdjdXKFyVejf/EIua6bpzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMFzn4c6f/tEnXI1562O6v0JYndteS9LFOgaoMftuMVWOj6JNgVH3OPtiNvEwHJ34
	 iQ6rrjFbYCPDhl/2rSmibPVl+pIoEf684sZIxj80ChFR3ul7nWFZ7ZgVsdT9sr5zgR
	 OUsd/lukwjTYuppHOw5URnMz9O4SQjsV7+cX9v4U=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
	Kohei Enju <enju.kohei@fujitsu.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v4 11/11] KVM: arm64: CCA: Add Realm stage-2 MMU operations
Date: Mon, 23 Nov 2026 10:42:31 +0000
Message-ID: <20261123104233.95710-12-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123104233.95710-1-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Register the Realm stage-2 MMU operations now that the RMM mapping
and unmapping helpers are available. Route unmapping through the
RMM, and use the Realm-specific fault handler for Realm memory faults.

The RMM handles TLB invalidation when stage-2 mappings change, so
the host has no separate TLB flush to perform. Realm stage-2 does
not support access flags, including for shared IPAs.

Realm teardown destroys non-root RTTs through RMI, so the Realm
stage-2 destruction callback frees only the root RTT pages.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v3:
- Register realm_mem_abort() as the Realm stage-2 fault handler.

Changes since v2:
- Move common stage-2 destruction dispatch to a separate patch;
  retain the Realm-specific destruction callback here.
---
 arch/arm64/kvm/mmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 870dc7e2699b..274dfe8ea364 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -191,6 +191,12 @@ static int kvm_vm_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+static int realm_flush_remote_tlbs(struct kvm *kvm)
+{
+	/* Nothing to do here, RMM does the job */
+	return 0;
+}
+
 /**
  * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
@@ -218,6 +224,13 @@ static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
 	return 0;
 }
 
+static int realm_flush_remote_tlbs_range(struct kvm *kvm,
+					 gfn_t gfn, u64 nr_pages)
+{
+	/* Nothing to do here, RMM does the job */
+	return 0;
+}
+
 int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
 				     gfn_t gfn, u64 nr_pages)
 {
@@ -353,6 +366,15 @@ static void no_stage2_unmap_range(struct kvm_s2_mmu *mmu,
 {
 }
 
+static void realm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
+				     phys_addr_t start, u64 size, bool may_block,
+				     enum kvm_gfn_range_filter filter)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	kvm_realm_unmap_range_filter(kvm, start, size, may_block, filter);
+}
+
 /*
  * Unmapping vs dcache management:
  *
@@ -1054,6 +1076,17 @@ static void pkvm_stage2_destroy(struct kvm_pgtable *pgt)
 	pkvm_pgtable_stage2_destroy_pgd(pgt);
 }
 
+static void realm_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	/*
+	 * Realm RTTs are inaccessible to the host and may contain stale data
+	 * after the RMM has released them. The non-root RTTs are explicitly
+	 * destroyed through RMI before the RD is destroyed; only the root PGD
+	 * pages remain to be freed here.
+	 */
+	kvm_pgtable_stage2_destroy_pgd(pgt);
+}
+
 static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
@@ -2486,7 +2519,7 @@ static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		return user_mem_abort(s2fd, NULL, kvm_s2_fault_map, false);
 }
 
-static int __maybe_unused realm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+static int realm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
 
@@ -3389,6 +3422,16 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
 	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
+static const struct kvm_vm_s2_ops realm_vm_s2_ops = {
+	.vm_stage2_destroy		= realm_stage2_destroy,
+	.vm_flush_remote_tlbs		= realm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= realm_flush_remote_tlbs_range,
+	.vm_age_gfn			= no_age_gfn,
+	.vm_test_age_gfn		= no_age_gfn,
+	.vm_stage2_unmap_range		= realm_stage2_unmap_range,
+	.vm_mem_abort			= realm_mem_abort,
+};
+
 #define KVM_VM_S2_OPS(flavor, ops)		\
 		[(flavor)] = &(ops)
 
@@ -3397,7 +3440,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
 	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
-	[VM_REALM] = NULL,
+	KVM_VM_S2_OPS(VM_REALM, realm_vm_s2_ops),
 };
 
 static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
-- 
2.43.0

