Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C9B26F28A
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136524; cv=none; b=qSqLhciw4fANp20+gbxmkc53Bwu/2dC0IOqOOtNO3CKhrzGk5de+YtILY0iwpwfUN5rLDPLdjA47UaRLFqJ02gnGcVMB0oUYSJD0799NuL4kTHH2dEsOnfBzwqz4eAyN26cbJ7ReRlJXMEdYrzvANLEYxrw3xFpvY704CGcVYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136524; c=relaxed/simple;
	bh=LmVBJI0b/J7GXGXX+m/JKpng/ZuYNuhZrQv02eDoluk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrlSzps0Qo+/P4+j1th3jmJxjQEJxXzhgolDMBYnHuwkrAC5PV1KZjUjcOELIQa/ja44k8pdHdDgG+90O1fB0gBF9sPi4UC4zzSXvAwkmbFybh1HdwQV1pOJs5h+sYLIT1lF3iVaukZGclsD4OrAqSRRA2l4ukKfEsOesIX6P6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4CD01BCB;
	Fri, 14 Nov 2025 08:08:34 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46E483F5A1;
	Fri, 14 Nov 2025 08:08:40 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 27/35] KVM: arm64: Make MTE functions public
Date: Fri, 14 Nov 2025 16:07:08 +0000
Message-ID: <20251114160717.163230-28-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sanitise_mte_tags() (renamed to kvm_sanitise_mte_tags()) and
kvm_vma_mte_allowed() public, to be used by the SPE virtualization code.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 +++
 arch/arm64/kvm/mmu.c             | 9 +++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4069f2ce642..37b84e9d4337 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -183,6 +183,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
+bool kvm_vma_mte_allowed(struct vm_area_struct *vma);
+void kvm_sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn, unsigned long size);
+
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int __init kvm_mmu_init(u32 *hyp_va_bits);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..8abba9619c58 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1434,13 +1434,14 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
  * Must be called with kvm->mmu_lock held to ensure the memory remains mapped
  * while the tags are zeroed.
  */
-static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
-			      unsigned long size)
+void kvm_sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn, unsigned long size)
 {
 	unsigned long i, nr_pages = size >> PAGE_SHIFT;
 	struct page *page = pfn_to_page(pfn);
 	struct folio *folio = page_folio(page);
 
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	if (!kvm_has_mte(kvm))
 		return;
 
@@ -1462,7 +1463,7 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	}
 }
 
-static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
+bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
@@ -1833,7 +1834,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!fault_is_perm && !s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
-			sanitise_mte_tags(kvm, pfn, vma_pagesize);
+			kvm_sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
 			ret = -EFAULT;
 			goto out_unlock;
-- 
2.51.2

