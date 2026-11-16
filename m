Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847518;
	b=roE3jjMzFwSHQA7o84NledOQZ+X5TCXL1tLbFKaxzH/xmhk1FwgucfZ2iFSw7U2ug7IG
	 gDzjyOS6MbfUB/b164r9QLpr7H4hn4UPwk9lh6mFN2q+QB5n7NmG/Pai5Zm/TDVrAl0sI
	 0SdciEN3Veolrc9XsfGX9QMknvciTNvUKhtgal3IbwQTE7OJOH+8arrhR4jkkwtR8jIqA
	 YSrdVUy7Zyv/Sm3TVOAPd/tVCctJH/wbD8z76UvSfRWtvfJyHlbhJduzmjwZBHs6tiyCA
	 cfp7mVI1VCoaER3IwxQnh/uA93b5tVy8UDzCCiGiPWGkboE9ztKjUvqEZmGGwsSIgdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847518;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nN1hlfbWMZiUhrReuCs8Rab+J6X4/1YOAvpzYEO13/4=;
	b=s90YuUILM4DPAFzIqCOvpm/8JWh1sBd4N/996J803RTuxQi38bLL+Tex1aOu6Ec9WCSw
	 PgLGE0UxMHM7C7ViqNPUq60R2BBIx/Ff1kTSyVDHoj8QvA+dJkd7mv3+afw6Uqe6rNdFK
	 W1cdsXzYNYdVFx6v9Ltjh+QnWJ+Ov8Cl22X/58oUn/JNpfo7h8JqPlfJZMd0th6q7NqE8
	 hXwSvyZTU8yn0Ey1cV+yg78dgaG9MIGFqGTmMnUb6CQieiWpuPQiEApVlGCUNrwntonji
	 Nid1YjcCG9cKSEzsx3K3AwyldN5/jOwUrQnIMvB8+Nhv4oVZ8vyY/UFh/CWJq52OskQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JoWu4uDm;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF24D606A31C;
	Mon, 16 Nov 2026 16:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF24D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JoWu4uDm
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 390CF143D;
	Mon, 16 Nov 2026 08:45:14 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3752C3F763;
	Mon, 16 Nov 2026 08:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794847517; bh=6jiy4DXehM5pygXK/+BEi+n70xvUykgSiUqMnkGlBbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoWu4uDmgaFjwgPRICvKxQ8XcxV3SfKqr0FMR/fsKEefKCpXBoViT1Wi3EF7QRVJO
	 ER1njMvQ43SNqu7HTF7b5imWtG0+vQOxRbBKV/7M9g98JZsD+X0StPwFuSD+qdjMeL
	 8Nm4Q6AOpCen6AQpW/AD9kP6lfDf5PKLTr6ADihc=
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
Subject: [PATCH v3 11/11] KVM: arm64: CCA: Add Realm stage-2 MMU operations
Date: Mon, 16 Nov 2026 16:43:57 +0000
Message-ID: <20261116164358.142785-12-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Register the Realm stage-2 MMU operations now that the RMM mapping
and unmapping helpers are available. Route unmapping through the
RMM, and use the existing fault handler for Realm memory faults.

The RMM handles TLB invalidation when stage-2 mappings change, so
the host has no separate TLB flush to perform. Realm stage-2 does
not support access flags, including for shared IPAs.

Realm teardown destroys non-root RTTs through RMI, so the Realm
stage-2 destruction callback frees only the root RTT pages.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v2:
- Move common stage-2 destruction dispatch to the preceding patch;
  retain the Realm-specific destruction callback here.
---
 arch/arm64/kvm/mmu.c | 45 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 46a83c58c12f..b3fa03d411fb 100644
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
@@ -3300,6 +3333,16 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
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
 
@@ -3308,7 +3351,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
 	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
-	[VM_REALM] = NULL,
+	KVM_VM_S2_OPS(VM_REALM, realm_vm_s2_ops),
 };
 
 static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
-- 
2.43.0

