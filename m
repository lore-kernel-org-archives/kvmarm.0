Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB63D391E46;
	Fri, 27 Mar 2026 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611390; cv=none; b=Zqd35Xg2gS61KYCZqP3Gogqz27c49XdX9UvSR/MvGWR59bpDsevdA51748jkMSBDwHqvBsLjjO3Pn8SZUEFn8EjIo0Xu5IYDJMkCbuWSmiwKc7GCEBJkVpEh0NSBzUhy+v2ODasiJYJ8N09MxItfatmjzdDpn3NbAkGlXkzuAAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611390; c=relaxed/simple;
	bh=tqFovywmBvcvEZzUbRpB8s3MtVGzdsQRy1BeOyGDLjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMJ5/SEIR8OjzbUtDidj2G6gP1fD0iZ6BMiuolD9aQ/h0D4WYC8VF8/DR0Mf1+o+dQbRy3ZJCCY7ZNTFW1qEgUMn1cMV3/5A44r00ZaQGjfT8XFNhd5u71pXLsK/tVW9O9Be5dtRN2rnk+k5NQ5VI4rpf2gTxADuSB6iRp1ZtvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbJ4iZPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbJ4iZPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA94C2BCB6;
	Fri, 27 Mar 2026 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611390;
	bh=tqFovywmBvcvEZzUbRpB8s3MtVGzdsQRy1BeOyGDLjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbJ4iZPlpBPayPoKRnIv+D4m5rE/zKdcvYTJ0mlfvCv7ManGeASG5cxNuXkAQWd0H
	 i7vV2h5i73vyhtBjsLuy8oH8B7WOnOCkE2S+1Y7stsJQucfjfkAgy4oYI7q8i9rqMC
	 USWZh8Tcww+ddXMauNmr3IAnDEI3n4C3JLmOZGtpHxxc/KgitTnWDmozignhhK9XZa
	 vAi4FLoohQ3vXFHx+gNv6Xz01Ylqk/U5MAfAJYA48rXmgqlgpyUxV+56szrXgWk+K4
	 xG+ewIkLPSK2TdraRpwMsOqFICAvX+6nEYYNCFr1rlKi9kk9jNM9JUFNEUYutkdTmz
	 gMgaPfM/UXzJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UK-00000006K4a-2o0H;
	Fri, 27 Mar 2026 11:36:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 27/30] KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
Date: Fri, 27 Mar 2026 11:36:15 +0000
Message-ID: <20260327113618.4051534-28-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Attributes computed for devices are computed very late in the fault
handling process, meanning they are mutable for that long.

Introduce both 'device' and 'map_non_cacheable' attributes to the
vma_info structure, allowing that information to be set in stone
earlier, in kvm_s2_fault_pin_pfn().

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 52 ++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 61b979365c6ee..23245ee7b1ec2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1656,9 +1656,11 @@ struct kvm_s2_fault_vma_info {
 	struct page	*page;
 	kvm_pfn_t	pfn;
 	gfn_t		gfn;
+	bool		device;
 	bool		mte_allowed;
 	bool		is_vma_cacheable;
 	bool		map_writable;
+	bool		map_non_cacheable;
 };
 
 static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
@@ -1728,7 +1730,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 }
 
 struct kvm_s2_fault {
-	bool s2_force_noncacheable;
 	enum kvm_pgtable_prot prot;
 };
 
@@ -1738,7 +1739,6 @@ static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
 }
 
 static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
-				     struct kvm_s2_fault *fault,
 				     struct kvm_s2_fault_vma_info *s2vi)
 {
 	struct vm_area_struct *vma;
@@ -1794,12 +1794,11 @@ static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
 }
 
 static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
-				struct kvm_s2_fault *fault,
 				struct kvm_s2_fault_vma_info *s2vi)
 {
 	int ret;
 
-	ret = kvm_s2_fault_get_vma_info(s2fd, fault, s2vi);
+	ret = kvm_s2_fault_get_vma_info(s2fd, s2vi);
 	if (ret)
 		return ret;
 
@@ -1814,16 +1813,6 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 		return -EFAULT;
 	}
 
-	return 1;
-}
-
-static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
-				     struct kvm_s2_fault *fault,
-				     const struct kvm_s2_fault_vma_info *s2vi)
-{
-	struct kvm *kvm = s2fd->vcpu->kvm;
-	bool writable = s2vi->map_writable;
-
 	/*
 	 * Check if this is non-struct page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cacheable.
@@ -1842,8 +1831,10 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 			 * S2FWB and CACHE DIC are mandatory to avoid the need for
 			 * cache maintenance.
 			 */
-			if (!kvm_supports_cacheable_pfnmap())
+			if (!kvm_supports_cacheable_pfnmap()) {
+				kvm_release_faultin_page(s2fd->vcpu->kvm, s2vi->page, true, false);
 				return -EFAULT;
+			}
 		} else {
 			/*
 			 * If the page was identified as device early by looking at
@@ -1855,9 +1846,24 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 			 * In both cases, we don't let transparent_hugepage_adjust()
 			 * change things at the last minute.
 			 */
-			fault->s2_force_noncacheable = true;
+			s2vi->map_non_cacheable = true;
 		}
-	} else if (memslot_is_logging(s2fd->memslot) && !kvm_is_write_fault(s2fd->vcpu)) {
+
+		s2vi->device = true;
+	}
+
+	return 1;
+}
+
+static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
+				     struct kvm_s2_fault *fault,
+				     const struct kvm_s2_fault_vma_info *s2vi)
+{
+	struct kvm *kvm = s2fd->vcpu->kvm;
+	bool writable = s2vi->map_writable;
+
+	if (!s2vi->device && memslot_is_logging(s2fd->memslot) &&
+	    !kvm_is_write_fault(s2fd->vcpu)) {
 		/*
 		 * Only actually map the page as writable if this was a write
 		 * fault.
@@ -1865,7 +1871,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		writable = false;
 	}
 
-	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && fault->s2_force_noncacheable)
+	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && s2vi->map_non_cacheable)
 		return -ENOEXEC;
 
 	/*
@@ -1888,7 +1894,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
-	if (fault->s2_force_noncacheable)
+	if (s2vi->map_non_cacheable)
 		fault->prot |= (s2vi->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
 			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
 	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
@@ -1897,7 +1903,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	if (s2fd->nested)
 		adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
 
-	if (!kvm_s2_fault_is_perm(s2fd) && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
+	if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (!s2vi->mte_allowed)
 			return -EFAULT;
@@ -1937,7 +1943,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 * backed by a THP and thus use block mapping if possible.
 	 */
 	if (mapping_size == PAGE_SIZE &&
-	    !(s2vi->max_map_size == PAGE_SIZE || fault->s2_force_noncacheable)) {
+	    !(s2vi->max_map_size == PAGE_SIZE || s2vi->map_non_cacheable)) {
 		if (perm_fault_granule > PAGE_SIZE) {
 			mapping_size = perm_fault_granule;
 		} else {
@@ -1951,7 +1957,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		}
 	}
 
-	if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
+	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
 		sanitise_mte_tags(kvm, pfn, mapping_size);
 
 	/*
@@ -2020,7 +2026,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
-	ret = kvm_s2_fault_pin_pfn(s2fd, &fault, &s2vi);
+	ret = kvm_s2_fault_pin_pfn(s2fd, &s2vi);
 	if (ret != 1)
 		return ret;
 
-- 
2.47.3

