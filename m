Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10BF372B53;
	Fri, 27 Mar 2026 11:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611384; cv=none; b=pamK2eYsd81SV+uGHXhLKrQSC2tcKU80qu0Lb+N+BfjHs1wnEWHA7Hm6KEpQxEA3oab4mbLDlSLVXViOkpSsDjwLWTEjGLsIa9+aae7RFcDje14qAwyXHGcwvsh07c9lQXYg1jYYTt5wSRHxDI+js4RBb+hUT6V3ii8yxXFBmh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611384; c=relaxed/simple;
	bh=U/PKqCUlAT/TOev+JwhAPViP0XDCLZ0/w+lW7PCS+Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwcqWQvvhALB6jbgO89MCtW1JfahMVP0SfAx/8AbdxC0O6r0bbFOP+UlTjgVx8PtBBKXBAVkPtHYZJ1ca/onZ7meS51F4RxAa0rWJPlfMNu7BdC2lizaAlv20FChYpBpgzJpYKxVzbVRtBP40nYNoJ8JQhRILEDuk2Avb9KU49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V86HSKiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V86HSKiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9DAC2BC86;
	Fri, 27 Mar 2026 11:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611384;
	bh=U/PKqCUlAT/TOev+JwhAPViP0XDCLZ0/w+lW7PCS+Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V86HSKiq3eAShqiWZqeACsnmopf6aRaKqTlb43I7zapRzU7cmTlbSgh+eLZiG4wji
	 J4kZLMpI+jYi+ba8a6iH9BoINGw55QrHjRrGYK9pM7N5xMPaC+Y2/NfunLGj+GVcpN
	 5ujMuKMfmpXvbm3J7jij+caVLPAAEF0XpV8H4w3baDkmqgU9libjt8pSWTfTkHbraV
	 FIh7CQKkvBnkGfG94hIOHrPIeCKYSBb2occ//wAhIrKVLvKOOXWcUzqzF7YzHrs8AC
	 /sqzwLheTA8+MHmgefDNnnxai373bf38UUIX87qCnafFx2OwGPyj1eKj1PUoQf5CWI
	 8XsdVnFUd0jYw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UE-00000006K4a-1M4s;
	Fri, 27 Mar 2026 11:36:22 +0000
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
Subject: [PATCH v2 01/30] KVM: arm64: Extract VMA size resolution in user_mem_abort()
Date: Fri, 27 Mar 2026 11:35:49 +0000
Message-ID: <20260327113618.4051534-2-maz@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

As part of an effort to refactor user_mem_abort() into smaller, more
focused helper functions, extract the logic responsible for determining
the VMA shift and page size into a new static helper,
kvm_s2_resolve_vma_size().

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 130 ++++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 17d64a1e11e5c..f8064b2d32045 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1639,6 +1639,77 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	return ret != -EAGAIN ? ret : 0;
 }
 
+static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
+				     unsigned long hva,
+				     struct kvm_memory_slot *memslot,
+				     struct kvm_s2_trans *nested,
+				     bool *force_pte, phys_addr_t *ipa)
+{
+	short vma_shift;
+	long vma_pagesize;
+
+	if (*force_pte)
+		vma_shift = PAGE_SHIFT;
+	else
+		vma_shift = get_vma_page_shift(vma, hva);
+
+	switch (vma_shift) {
+#ifndef __PAGETABLE_PMD_FOLDED
+	case PUD_SHIFT:
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+			break;
+		fallthrough;
+#endif
+	case CONT_PMD_SHIFT:
+		vma_shift = PMD_SHIFT;
+		fallthrough;
+	case PMD_SHIFT:
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+			break;
+		fallthrough;
+	case CONT_PTE_SHIFT:
+		vma_shift = PAGE_SHIFT;
+		*force_pte = true;
+		fallthrough;
+	case PAGE_SHIFT:
+		break;
+	default:
+		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
+	}
+
+	vma_pagesize = 1UL << vma_shift;
+
+	if (nested) {
+		unsigned long max_map_size;
+
+		max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
+
+		*ipa = kvm_s2_trans_output(nested);
+
+		/*
+		 * If we're about to create a shadow stage 2 entry, then we
+		 * can only create a block mapping if the guest stage 2 page
+		 * table uses at least as big a mapping.
+		 */
+		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
+
+		/*
+		 * Be careful that if the mapping size falls between
+		 * two host sizes, take the smallest of the two.
+		 */
+		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
+			max_map_size = PMD_SIZE;
+		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
+			max_map_size = PAGE_SIZE;
+
+		*force_pte = (max_map_size == PAGE_SIZE);
+		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
+		vma_shift = __ffs(vma_pagesize);
+	}
+
+	return vma_shift;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1695,65 +1766,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (force_pte)
-		vma_shift = PAGE_SHIFT;
-	else
-		vma_shift = get_vma_page_shift(vma, hva);
-
-	switch (vma_shift) {
-#ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-			break;
-		fallthrough;
-#endif
-	case CONT_PMD_SHIFT:
-		vma_shift = PMD_SHIFT;
-		fallthrough;
-	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
-			break;
-		fallthrough;
-	case CONT_PTE_SHIFT:
-		vma_shift = PAGE_SHIFT;
-		force_pte = true;
-		fallthrough;
-	case PAGE_SHIFT:
-		break;
-	default:
-		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
-	}
-
+	vma_shift = kvm_s2_resolve_vma_size(vma, hva, memslot, nested,
+					    &force_pte, &ipa);
 	vma_pagesize = 1UL << vma_shift;
 
-	if (nested) {
-		unsigned long max_map_size;
-
-		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
-
-		ipa = kvm_s2_trans_output(nested);
-
-		/*
-		 * If we're about to create a shadow stage 2 entry, then we
-		 * can only create a block mapping if the guest stage 2 page
-		 * table uses at least as big a mapping.
-		 */
-		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
-
-		/*
-		 * Be careful that if the mapping size falls between
-		 * two host sizes, take the smallest of the two.
-		 */
-		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
-			max_map_size = PMD_SIZE;
-		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
-			max_map_size = PAGE_SIZE;
-
-		force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
-		vma_shift = __ffs(vma_pagesize);
-	}
-
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
 	 * mapping size to ensure we find the right PFN and lay down the
-- 
2.47.3

