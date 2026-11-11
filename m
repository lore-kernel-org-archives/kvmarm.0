Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409117;
	b=497ju0EqymrzTG8LIGQa7KxEIYuDl9YW2Kt2KRYgmINO4Yb5RjSDmvmcM3iTXqF9sl+N
	 d7zwXqgB7+NwbFop0x9sdDpRJaSleiSL6ihCZf821e962Lv+SsIyy9fIc2PaVHawLcShY
	 /hqTJedCPwyDHjj0gq9c3LVifMrG4lrttYBG7sVsOaCDt/eunrn6sACQJlfcJl7RWK4G4
	 quUziJEhZOHkWOORgtVUuNYfnf/lsbOoANsPU22r2QrSJHj7K4WpKi2tGOhRvu+r04F4r
	 lqxdqQYxa4Ndfiu9BiM5gyviyK25csm5oCvc0FS2tH9qVF6DWki5BHosPjhlBOEWwOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409117;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JVMGCcXWWA0vMf8u1/szVsWXOH76oZ5eBumqkqzZuow=;
	b=EOInv3hEA6AZkea4a2yDwUfThxDSsQl/uriZHes+nwiqYhuv5j/qChrO77JhiRJGj45y
	 z9MVQStShXJ3+yH79z5zGCaRLAImcPn71VBXCZVKI19GCXflWrs76bGnPUX+lEq77d7qW
	 h8kYk7ZKi+HvZYtX1fD1RR1hSX+V0NuS3Whuu/RDNTh7nFqjR/Ujm/EvMR5dJD4d89z74
	 92S5UL96rFlkVv2gqRpFmzzljKO8/UgqtP3WccuiKM+5NbIZgWDybFgy6fStjXPa17Zc5
	 qjVh/JOze0N1JDlCqxZGfp0PuQGEKyihz83jESxg+ALdmZLPu8mkG/gEVN9v9US0Qsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KO143zNE;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAC7606A8BB;
	Wed, 11 Nov 2026 14:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCAC7606A8BB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KO143zNE
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41DBE1682;
	Wed, 11 Nov 2026 06:58:33 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1CDD3F632;
	Wed, 11 Nov 2026 06:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409116; bh=esz5iAQplnzxOKWyh87pqTVfFUwALx8RS9BSnwkPNAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO143zNEV+HSZKUQGyfCFNTDAf+4o9eeo653cWB5ro9PEuXLV71vHGsCFIfBV6iUB
	 vF7/Fj/yioiHcpauZCLbkoraJQAFAFRQZ037sxWOPxVKAAOZTQqgYDGhJ82oTlaFGA
	 VXltAMqLbvYHkVZEABGXk/xZEa0FwZG7cnNFFtp4=
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
Subject: [PATCH v2 05/12] KVM: arm64: Handle attributes in stage2_unmap_range
Date: Wed, 11 Nov 2026 14:57:49 +0000
Message-ID: <20261111145758.217946-6-steven.price@arm.com>
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

With the introduction of private memory support, we need to
handle invalidation requests with filters for a given type.
Add support for passing the attributes down.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++-
 arch/arm64/kvm/mmu.c              | 31 +++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7948b177bf13..d672d87ffe62 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -234,6 +234,7 @@ struct kvm_vcpu_ops {
 };
 
 struct kvm_gfn_range;
+enum kvm_gfn_range_filter;
 struct kvm_s2_fault_desc;
 
 struct kvm_vm_s2_ops {
@@ -244,7 +245,8 @@ struct kvm_vm_s2_ops {
 					  u64 nr_pages);
 	void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start, u64 size,
-				      bool may_block);
+				      bool may_block,
+				      enum kvm_gfn_range_filter filter);
 	int (*vm_mem_abort)(const struct kvm_s2_fault_desc *s2fd);
 };
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 434502e8c4f9..c5aeb3a58417 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -324,7 +324,8 @@ static int kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt,
 
 static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
 				      phys_addr_t start,
-				      u64 size, bool may_block)
+				      u64 size, bool may_block,
+				      enum kvm_gfn_range_filter filter)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	int (*fn)(struct kvm_pgtable *, u64, u64);
@@ -339,14 +340,16 @@ static void kvm_vm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
 
 static void pkvm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
 				    phys_addr_t start,
-				    u64 size, bool may_block)
+				    u64 size, bool may_block,
+				    enum kvm_gfn_range_filter filter)
 {
 	WARN_ON(stage2_apply_range(mmu, start, start + size,
 				   pkvm_pgtable_stage2_unmap, may_block));
 }
 
 static void no_stage2_unmap_range(struct kvm_s2_mmu *mmu,
-				  phys_addr_t start, u64 size, bool may_block)
+				  phys_addr_t start, u64 size, bool may_block,
+				  enum kvm_gfn_range_filter filter)
 {
 }
 
@@ -388,25 +391,36 @@ static int kvm_pgtable_stage2_unmap_tracked(struct kvm_pgtable *pgt, u64 addr, u
 }
 
 /**
- * kvm_stage2_unmap_range -- Clear stage2 page table entries to unmap a range
+ * kvm_stage2_unmap_range_filter -- Clear stage2 page table entries to unmap a
+ * range
  * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
  * @may_block: Whether or not we are permitted to block
+ * @filter: Filter for the ipa range (private and/or shared)
  *
  * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
  * be called while holding mmu_lock otherwise another faulting VCPU may
  * come in and mess with things behind our backs.
  */
-void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
-			    u64 size, bool may_block)
+static void kvm_stage2_unmap_range_filter(struct kvm_s2_mmu *mmu, phys_addr_t start,
+					  u64 size, bool may_block,
+					  enum kvm_gfn_range_filter filter)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
 
-	kvm->arch.vm_s2_ops->vm_stage2_unmap_range(mmu, start, size, may_block);
+	kvm->arch.vm_s2_ops->vm_stage2_unmap_range(mmu, start, size,
+						   may_block, filter);
+}
+
+void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
+			    u64 size, bool may_block)
+{
+	kvm_stage2_unmap_range_filter(mmu, start, size, may_block,
+				      KVM_FILTER_PRIVATE | KVM_FILTER_SHARED);
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
@@ -2597,7 +2611,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, may_block);
+	kvm_stage2_unmap_range_filter(&kvm->arch.mmu, gpa, size, may_block,
+				      range->attr_filter);
 	kvm_nested_unmap_cipa_range(kvm, gpa, size, may_block);
 
 	return false;
-- 
2.43.0

