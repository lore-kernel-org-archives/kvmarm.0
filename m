Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409152;
	b=mUeDDonNcOTydKBYzY/T5dHo85sR8W63rdHdlGrC1wQmf31Lf8kjUuN+P/y/rBj4fEHb
	 eEl+u5WoT3JD9347jcggCvfO5naLdlyJLcZVURi4SEj3o6aZinEDoNON+ZMOMmw2FyjLx
	 DMKzeQNAV9osZtBMcezgHtLBHuXfaGxAOCwgyvms5qdW/FDSip8DUJD2pMKYkMV0DpF5t
	 ov7DHhrHFL7TOJirw36YMyGwy91+8rWHyxrbCVmXMTxYsbNIQqErEbWW0W2ObcN1Y6cHf
	 TLZh4gRnhAPU+XtKbVi0K9vAd/3aT3z26JpZ909J12HJURUeN6BYZBjeO7vHWXIuNKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409152;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=h/au/usfZE/TfBBMZivfikC70G+5kRYRhls8qJotySE=;
	b=eZkhvk4lBnPjr4CvIVJrdR+JiyKzP3cQ8bTHufOfrb1Qpnk0q2Udzi5Cz7LS1FnxtqDH
	 uEjGsM8KeqqYnVQEwbMxq59Y/YS7hSH7KczXFf7eqWqLPd0YXPLOgY9EwTXCRolYjba79
	 S9x87rdK9eBxx6Xg//raKzTxEyR4eTQtRt2lWz/6+oUeKyFQbQwW6dFcD547A4bvliz7T
	 JjvAC9FBNvQIOyyXPKsnMm3CNwrBYSOSzyV2gyRg3wRx4KYEMPCXBFseXRs1NC6NXujA2
	 +xptwLh0QKusQxOodHIY9C2W80sGs43/CQnOaZpMVif/xxMYN1emElQOCHRbAtYQnLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=az1q8nPg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03494606B6A4;
	Wed, 11 Nov 2026 14:59:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03494606B6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=az1q8nPg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DFCB1576;
	Wed, 11 Nov 2026 06:59:07 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5F2E3F632;
	Wed, 11 Nov 2026 06:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409150; bh=DrbIuSnaXWHO+3/nsY1BLqsSk0ZejQGKrsYqRy9iELs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=az1q8nPgnHHODRc74qEHNPtIoSNwdKhF1Z16xfod8gPHw7ZIc29fxuDGNYmm68uhD
	 PGuPpQLJtnuI94KrsCOCVC4UT+HMrs1qhCKUoFYEoLdvyP338dx8beCL4YHkfDvFEF
	 pmXQ8G0Is2am36g1cLzbnyGpY61g3otIyQMl9PSs=
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
Subject: [PATCH v2 12/12] KVM: arm64: CCA: Add Realm stage-2 MMU operations
Date: Wed, 11 Nov 2026 14:57:56 +0000
Message-ID: <20261111145758.217946-13-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Register the Realm stage-2 MMU operations now that the RMM mapping
and unmapping helpers are available. Route unmapping through the
RMM, and use the existing fault handler for Realm memory faults.

The RMM handles TLB invalidation when stage-2 mappings change, so
the host has no separate TLB flush to perform. Realm stage-2 does
not support access flags, including for shared IPAs.

Dispatch stage-2 destruction according to the VM flavor. Realm
teardown destroys non-root RTTs through RMI, so the host frees
only the root RTT pages.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v1:
- Dispatch stage-2 destruction by VM flavor. Free only the Realm
  root RTT pages after RMI teardown while preserving the native
  and pKVM destruction paths.
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/mmu.c              | 72 ++++++++++++++++++++++++++-----
 2 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a82b18a3e4e5..33b1bd2740d3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -243,6 +243,7 @@ struct kvm_vm_s2_ops {
 	int (*vm_flush_remote_tlbs)(struct kvm *kvm);
 	int (*vm_flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
 					  u64 nr_pages);
+	void (*vm_stage2_destroy)(struct kvm_pgtable *pgt);
 	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start, u64 size,
 				      bool may_block,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b6c61d7890c8..b416bc2ff69c 100644
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
@@ -1026,35 +1048,50 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
  * cond_resched() periodically to prevent hogging the CPU for a long time
  * and schedule something else, if required.
  */
-static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
-				   phys_addr_t end)
+static void stage2_destroy_range(struct kvm_pgtable *pgt,
+				 void (*destroy_range)(struct kvm_pgtable *pgt,
+						       u64 addr, u64 size))
 {
+	u64 addr = 0;
+	u64 end = BIT(VTCR_EL2_IPA(pgt->mmu->vtcr));
 	u64 next;
 
 	do {
 		next = stage2_range_addr_end(addr, end);
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
-							     next - addr);
+		destroy_range(pgt, addr, next - addr);
 		if (next != end)
 			cond_resched();
 	} while (addr = next, addr != end);
 }
 
-static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
+static void kvm_vm_stage2_destroy(struct kvm_pgtable *pgt)
 {
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
-	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
+	stage2_destroy_range(pgt, kvm_pgtable_stage2_destroy_range);
+	kvm_pgtable_stage2_destroy_pgd(pgt);
+}
+
+static void pkvm_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	stage2_destroy_range(pgt, pkvm_pgtable_stage2_destroy_range);
+	pkvm_pgtable_stage2_destroy_pgd(pgt);
+}
 
+static void realm_stage2_destroy(struct kvm_pgtable *pgt)
+{
 	/*
 	 * Realm RTTs are inaccessible to the host and may contain stale data
 	 * after the RMM has released them. The non-root RTTs are explicitly
 	 * destroyed through RMI before the RD is destroyed; only the root PGD
 	 * pages remain to be freed here.
 	 */
-	if (!kvm_vm_is_realm(kvm))
-		stage2_destroy_range(pgt, 0, BIT(ia_bits));
+	kvm_pgtable_stage2_destroy_pgd(pgt);
+}
 
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
+static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+
+	kvm->arch.vm_s2_ops->vm_stage2_destroy(pgt);
 }
 
 /**
@@ -3285,6 +3322,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 }
 
 static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
 	.vm_age_gfn			= no_age_gfn,
@@ -3294,6 +3332,7 @@ static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
 };
 
 static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
 	.vm_age_gfn			= pkvm_age_gfn,
@@ -3303,6 +3342,7 @@ static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
 };
 
 static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
+	.vm_stage2_destroy		= kvm_vm_stage2_destroy,
 	.vm_flush_remote_tlbs		= kvm_vm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= kvm_vm_flush_remote_tlbs_range,
 	.vm_age_gfn			= kvm_vm_age_gfn,
@@ -3311,6 +3351,16 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
 	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
+static const struct kvm_vm_s2_ops realm_vm_s2_ops = {
+	.vm_stage2_destroy		= realm_stage2_destroy,
+	.vm_flush_remote_tlbs		= realm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= realm_flush_remote_tlbs_range,
+	.vm_age_gfn			= no_age_gfn,
+	.vm_test_age_gfn		= no_age_gfn,
+	.vm_stage2_unmap_range		= realm_stage2_unmap_range,
+	.vm_mem_abort			= kvm_vm_mem_abort,
+};
+
 #define KVM_VM_S2_OPS(flavor, ops)		\
 		[(flavor)] = &(ops)
 
@@ -3319,7 +3369,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
 	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
-	[VM_REALM] = NULL,
+	KVM_VM_S2_OPS(VM_REALM, realm_vm_s2_ops),
 };
 
 static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
-- 
2.43.0

