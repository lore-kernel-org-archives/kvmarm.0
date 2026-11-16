Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847512;
	b=RvAUBqfse96Z0YyswNPeh7GEv/Yg5MXqTByTIWeWbB1Su/PT3UW/hwVHMgyw1NK9pgnY
	 +OYQrmwkALpUPmQS9y+P7iGkyNHbM/iKW/f1soUfqgnPVHZ4luh8IaTFwBDjL5lVqBE71
	 Y1Oa6qpy6Ad7nlX5ro1zp4EJHZ+LPStY6VGhkKbbaQB2LlHSfqjCzN71yOvH4l6zEPO6T
	 zTckdTAX3t8bwfJ7leLiD4Sd2RMQnVMPZYpEacsr7jtXVEwwb/pp4EEOsqGcbWXTPpe08
	 n17bR87mnpO/nxZ4beYd+CJYmOtJxrXgoM993ZEYMkf2QhuojRbuJbsOgkTp2fAc9iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847512;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IlR5hn1DvVbekTSMBsoU1pIyzOICN77vYydqnIPvkWc=;
	b=hUtA6Pvt6LBUr/kbkNumE4cNB3HdF5wj1DzJ2knYh/rCBLhCtgc8POPIqU7fBj4aSWGC
	 W7yB0LHo8IjVx9LL720xLbZZom/66AG/c9N/VbIwpQ2pMiSGMmzvqpMg5zCKYmUuwSgRl
	 jiBfiT7A53XAiQ6XwlkouuG6dtcXKCCRmloOgNNk98M4QN2xMYsMKcLfIhhRkOmt7KqcB
	 KgK5KyfUyIWjtyEb9OFcFap2PCww9tMtLXxnKzuFb9F5fm76g9GNVSjV21tJD8ZYOUXfp
	 1TYlYXLlD4UBSBbWHTrqs/J/anC8EdHLKE4pIYrZlZtlOmM/y9Zs8/0kKl9H/2/7Pqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=J1ql3GHj;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED8E606A329;
	Mon, 16 Nov 2026 16:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ED8E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=J1ql3GHj
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDCFC1A25;
	Mon, 16 Nov 2026 08:45:08 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 542D53F763;
	Mon, 16 Nov 2026 08:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794847511; bh=Ub0AUVWUvLzOwgM2l/CD4QdHvd5gHwZN7u9aO1oG8iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1ql3GHjjhtxyfRb+8WiCAWvWeWs4RAveW4uwYlAR46PAgIaA3jeoezXINFgLrplI
	 IPUxL3HwYap8zjWqO3OGxpAgTRXOnoJLPyDL6wVMMwpBQqQcnWev3Sg9jDYow7/+Rv
	 QChTwCUoQRTnPbecpbqg0IZctx3ripAOWoj3VXw4=
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
Subject: [PATCH v3 10/11] KVM: arm64: Dispatch stage-2 destruction by VM flavor
Date: Mon, 16 Nov 2026 16:43:56 +0000
Message-ID: <20261116164358.142785-11-steven.price@arm.com>
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

Select the stage-2 destruction functions through the VM's stage-2
operations. This keeps the native and pKVM paths explicit and lets a
Realm provide its own destruction callback when Realm stage-2
operations are registered.

The Realm callback will only free the root RTT pages, because RMI
teardown destroys the non-root RTTs separately.

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v2:
- New patch in v3; split stage-2 destruction dispatch out of the
  Realm stage-2 MMU operations patch.
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/mmu.c              | 37 ++++++++++++++++++-------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2c8cd9a1dd52..52ccb8b4ccb2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -242,6 +242,7 @@ struct kvm_vm_s2_ops {
 	int (*vm_flush_remote_tlbs)(struct kvm *kvm);
 	int (*vm_flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
 					  u64 nr_pages);
+	void (*vm_stage2_destroy)(struct kvm_pgtable *pgt);
 	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start, u64 size,
 				      bool may_block,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9b371159be92..46a83c58c12f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1026,35 +1026,39 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
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
 
+static void kvm_vm_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	stage2_destroy_range(pgt, kvm_pgtable_stage2_destroy_range);
+	kvm_pgtable_stage2_destroy_pgd(pgt);
+}
+
+static void pkvm_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	stage2_destroy_range(pgt, pkvm_pgtable_stage2_destroy_range);
+	pkvm_pgtable_stage2_destroy_pgd(pgt);
+}
+
 static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
-	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
-
-	/*
-	 * Realm RTTs are inaccessible to the host and may contain stale data
-	 * after the RMM has released them. The non-root RTTs are explicitly
-	 * destroyed through RMI before the RD is destroyed; only the root PGD
-	 * pages remain to be freed here.
-	 */
-	if (!kvm_vm_is_realm(kvm))
-		stage2_destroy_range(pgt, 0, BIT(ia_bits));
 
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
+	kvm->arch.vm_s2_ops->vm_stage2_destroy(pgt);
 }
 
 /**
@@ -3267,6 +3271,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 }
 
 static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
 	.vm_age_gfn			= no_age_gfn,
@@ -3276,6 +3281,7 @@ static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
 };
 
 static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
 	.vm_age_gfn			= pkvm_age_gfn,
@@ -3285,6 +3291,7 @@ static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
 };
 
 static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
+	.vm_stage2_destroy		= kvm_vm_stage2_destroy,
 	.vm_flush_remote_tlbs		= kvm_vm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= kvm_vm_flush_remote_tlbs_range,
 	.vm_age_gfn			= kvm_vm_age_gfn,
-- 
2.43.0

