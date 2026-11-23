Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430588;
	b=KRLLdNI06HCkp6XM9PttaxgzcYeoyCPAT2p3KdO/c26aM3r6px7V8z6DKVNTWWQ5/sq6
	 475dhxbHJagnmLRVrwkfAWDo5En5kxTda8SxR1k7qu5pDJsxj425Cvq/ktbq1qf8hV+oA
	 75i5nAsXQKgj+KroXcKi2NnZ/U1Q8eBC4l0aO4WcXReKl2bBsA0rXdJuz/evnD2y+hcWW
	 WDA38n+FcNfbSZMG0DVwbrIHj3s7YK3nLT+CF0UslUvviUGNj+FfPWZK+3/Htdh8KWg+p
	 yvTlf4HthkhxX9HERC1+H0JBRbHd8lf4vqT2fkdGHR0kXwL+XJvKHNroVH9KrUoJKsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430588;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WbiL5/GYCFyPRi9wxcNOxReRn+PG6ihd/hVXfoyN+yE=;
	b=21JlIvjjsRpNoyNqSSz5ruYxmYHzD//+qrx9xlFGoKUntrIo3PT4RtCVDkUbwu4g37KW
	 bWXgqkJctV3QCF17gmehwjt29ojelXX/88hDC9/4Qw/3ghGcSmuSO3Vfp8aq0iu/LmD4B
	 q/wQwyNzAYex6Qp8U31RaSieIx6IUzS6Gqrpr/vVuHdFEhYbZZ/GTNFc08XNHu19fxflk
	 phY+y9/XaFlGjxSos62qRdT2NtiKkP5H0vw+4+bWOmeZTCioZfrDMuuakAURBNVV2JnPV
	 CQAxKGravJpAV2VzTviRKw9jXE2uJd5FdIZn3OhWAxz7qaIJSIdlHI0TtqLUtEltttg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eb7d7T6Q;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9611C606A332;
	Mon, 23 Nov 2026 10:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9611C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eb7d7T6Q
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D16419F6;
	Mon, 23 Nov 2026 02:43:04 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE7143F632;
	Mon, 23 Nov 2026 02:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430587; bh=BuGA/lGbRxntNDSJ5lrDnQcY0TNEaN6MEZe2N7wWYbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eb7d7T6QXknPO5Y5o6OC3bX4RMKfl8aezQtbBL6lYkw/fDAgnOxTd3GAMt9N4VzNb
	 Rk+gfXiUEVXOq2qoAd7Hn+Y0ZFYcrWdfv6AGdyHIONQhLLBu7p6/YgdRsbwHNAAAQa
	 vo8DNPppbcX9vH79p/LkBO7iHKbWgOn7+1328L5Y=
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
Subject: [PATCH v4 04/11] KVM: arm64: Dispatch stage-2 destruction by VM flavor
Date: Mon, 23 Nov 2026 10:42:24 +0000
Message-ID: <20261123104233.95710-5-steven.price@arm.com>
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

Select the stage-2 destruction functions through the VM's stage-2
operations. This keeps the native and pKVM paths explicit and lets a
Realm provide its own destruction callback when Realm stage-2
operations are registered.

The Realm callback will only free the root RTT pages, because RMI
teardown destroys the non-root RTTs separately.

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v3:
- Move before basic Realm infrastructure and declare the page-table
  type for the new callback.

Changes since v2:
- New patch in v3; split stage-2 destruction dispatch out of the
  Realm stage-2 MMU operations patch.
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 30 +++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9d6258b213d1..3ddeddfacd06 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -234,6 +234,7 @@ struct kvm_vcpu_ops {
 
 struct kvm_gfn_range;
 enum kvm_gfn_range_filter;
+struct kvm_pgtable;
 struct kvm_s2_fault_desc;
 
 struct kvm_vm_s2_ops {
@@ -242,6 +243,7 @@ struct kvm_vm_s2_ops {
 	int (*vm_flush_remote_tlbs)(struct kvm *kvm);
 	int (*vm_flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
 					  u64 nr_pages);
+	void (*vm_stage2_destroy)(struct kvm_pgtable *pgt);
 	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start, u64 size,
 				      bool may_block,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8a9a80c7cfab..fab915ddeaab 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1018,26 +1018,39 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
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
-	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
 
-	stage2_destroy_range(pgt, 0, BIT(ia_bits));
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
+	kvm->arch.vm_s2_ops->vm_stage2_destroy(pgt);
 }
 
 /**
@@ -3146,6 +3159,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 }
 
 static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
 	.vm_age_gfn			= no_age_gfn,
@@ -3155,6 +3169,7 @@ static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
 };
 
 static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
+	.vm_stage2_destroy		= pkvm_stage2_destroy,
 	.vm_flush_remote_tlbs		= pkvm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= pkvm_flush_remote_tlbs_range,
 	.vm_age_gfn			= pkvm_age_gfn,
@@ -3164,6 +3179,7 @@ static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
 };
 
 static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
+	.vm_stage2_destroy		= kvm_vm_stage2_destroy,
 	.vm_flush_remote_tlbs		= kvm_vm_flush_remote_tlbs,
 	.vm_flush_remote_tlbs_range	= kvm_vm_flush_remote_tlbs_range,
 	.vm_age_gfn			= kvm_vm_age_gfn,
-- 
2.43.0

