Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B522A37BE64;
	Fri, 27 Mar 2026 11:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611385; cv=none; b=cBMXervuFClyyU9biA56xMWlKQsvviq7qa1bQ/FCgmyx04Lpx7ahfWPl5Rc8+IgCi0H/RoevtBiiiNSvG4bcOiQEwYJWZ3BPev599u0z7uekunT/+p7N/k4M/v3f8Goa8W6ABLtNO0/ta+9m0Uy0Qn2wyGBq4u0JIkG09h3k08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611385; c=relaxed/simple;
	bh=Tjg+Jvv6iW6EHjiAndffoIAOp2L95gUPpDv4cEd09gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+/1edWYq7ssOnYs9uLEfjM+QxXEE0bJOuaJSpYAERvHVf8nF0j97smfQ0xSPT9jnPYN/D1W+paeu6FdMtCEU2x+02RC75kiKphjKszPy4cIdM5L7ECMJfKNu6CxygxcHq40f2/BnCPmGB7QI1PGpUNczZzYWs9Qlh+peHPF180=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUcs87Hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUcs87Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7336EC19423;
	Fri, 27 Mar 2026 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611385;
	bh=Tjg+Jvv6iW6EHjiAndffoIAOp2L95gUPpDv4cEd09gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUcs87HkfcseEjTDzjZMQI1mIoR4FF2m4m7bVK7GC+lKSViH6QwcgpRgOZfo7Thmt
	 9X7e9eIPk3A7/Y2GrVGazsQqUBuWBGWuo5KXErncKu3l++/6k45ehpxYVEw+7xvUIH
	 oCZGVlh51xJ0sxI2iNYRBA/cT/hA87oWFUX1O9zVeUV2AmruZWpEFbeTk46iL6Kx19
	 jreeMjjRkRc+0v0m1ehyc6/614ryAKH+ckRM353rhR3u24AlpdIeO7dGHdIJ93K7Mg
	 lBbrAt9CPYZouAmP6lnK6D2zpvT3h2fohSUVVwGKjcBDPi2LscwUvR8TYeC/Y45SwT
	 4esQXX2g+sN2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UF-00000006K4a-1EHs;
	Fri, 27 Mar 2026 11:36:23 +0000
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
Subject: [PATCH v2 05/30] KVM: arm64: Extract stage-2 permission logic in user_mem_abort()
Date: Fri, 27 Mar 2026 11:35:53 +0000
Message-ID: <20260327113618.4051534-6-maz@kernel.org>
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

Extract the logic that computes the stage-2 protections and checks for
various permission faults (e.g., execution faults on non-cacheable
memory) into a new helper function, kvm_s2_fault_compute_prot(). This
helper also handles injecting atomic/exclusive faults back into the
guest when necessary.

This refactoring step separates the permission computation from the
mapping logic, making the main fault handler flow clearer.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 163 +++++++++++++++++++++++--------------------
 1 file changed, 87 insertions(+), 76 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f2c2200ccd8d..d1ffdce18631a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1809,6 +1809,89 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	return 1;
 }
 
+static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
+{
+	struct kvm *kvm = fault->vcpu->kvm;
+
+	/*
+	 * Check if this is non-struct page memory PFN, and cannot support
+	 * CMOs. It could potentially be unsafe to access as cacheable.
+	 */
+	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
+		if (fault->is_vma_cacheable) {
+			/*
+			 * Whilst the VMA owner expects cacheable mapping to this
+			 * PFN, hardware also has to support the FWB and CACHE DIC
+			 * features.
+			 *
+			 * ARM64 KVM relies on kernel VA mapping to the PFN to
+			 * perform cache maintenance as the CMO instructions work on
+			 * virtual addresses. VM_PFNMAP region are not necessarily
+			 * mapped to a KVA and hence the presence of hardware features
+			 * S2FWB and CACHE DIC are mandatory to avoid the need for
+			 * cache maintenance.
+			 */
+			if (!kvm_supports_cacheable_pfnmap())
+				return -EFAULT;
+		} else {
+			/*
+			 * If the page was identified as device early by looking at
+			 * the VMA flags, vma_pagesize is already representing the
+			 * largest quantity we can map.  If instead it was mapped
+			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+			 * and must not be upgraded.
+			 *
+			 * In both cases, we don't let transparent_hugepage_adjust()
+			 * change things at the last minute.
+			 */
+			fault->s2_force_noncacheable = true;
+		}
+	} else if (fault->logging_active && !fault->write_fault) {
+		/*
+		 * Only actually map the page as writable if this was a write
+		 * fault.
+		 */
+		fault->writable = false;
+	}
+
+	if (fault->exec_fault && fault->s2_force_noncacheable)
+		return -ENOEXEC;
+
+	/*
+	 * Guest performs atomic/exclusive operations on memory with unsupported
+	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
+	 * and trigger the exception here. Since the memslot is valid, inject
+	 * the fault back to the guest.
+	 */
+	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
+		kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
+		return 1;
+	}
+
+	if (fault->nested)
+		adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
+
+	if (fault->writable)
+		fault->prot |= KVM_PGTABLE_PROT_W;
+
+	if (fault->exec_fault)
+		fault->prot |= KVM_PGTABLE_PROT_X;
+
+	if (fault->s2_force_noncacheable) {
+		if (fault->vfio_allow_any_uc)
+			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+		else
+			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
+	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
+		fault->prot |= KVM_PGTABLE_PROT_X;
+	}
+
+	if (fault->nested)
+		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
+
+	return 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1863,68 +1946,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	ret = 0;
 
-	/*
-	 * Check if this is non-struct page memory PFN, and cannot support
-	 * CMOs. It could potentially be unsafe to access as cacheable.
-	 */
-	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
-		if (fault->is_vma_cacheable) {
-			/*
-			 * Whilst the VMA owner expects cacheable mapping to this
-			 * PFN, hardware also has to support the FWB and CACHE DIC
-			 * features.
-			 *
-			 * ARM64 KVM relies on kernel VA mapping to the PFN to
-			 * perform cache maintenance as the CMO instructions work on
-			 * virtual addresses. VM_PFNMAP region are not necessarily
-			 * mapped to a KVA and hence the presence of hardware features
-			 * S2FWB and CACHE DIC are mandatory to avoid the need for
-			 * cache maintenance.
-			 */
-			if (!kvm_supports_cacheable_pfnmap())
-				ret = -EFAULT;
-		} else {
-			/*
-			 * If the page was identified as device early by looking at
-			 * the VMA flags, fault->vma_pagesize is already representing the
-			 * largest quantity we can map.  If instead it was mapped
-			 * via __kvm_faultin_pfn(), fault->vma_pagesize is set to PAGE_SIZE
-			 * and must not be upgraded.
-			 *
-			 * In both cases, we don't let transparent_hugepage_adjust()
-			 * change things at the last minute.
-			 */
-			fault->s2_force_noncacheable = true;
-		}
-	} else if (fault->logging_active && !fault->write_fault) {
-		/*
-		 * Only actually map the page as fault->writable if this was a write
-		 * fault.
-		 */
-		fault->writable = false;
+	ret = kvm_s2_fault_compute_prot(fault);
+	if (ret == 1) {
+		ret = 1; /* fault injected */
+		goto out_put_page;
 	}
-
-	if (fault->exec_fault && fault->s2_force_noncacheable)
-		ret = -ENOEXEC;
-
 	if (ret)
 		goto out_put_page;
 
-	/*
-	 * Guest performs atomic/exclusive operations on memory with unsupported
-	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
-	 * and trigger the exception here. Since the fault->memslot is valid, inject
-	 * the fault back to the guest.
-	 */
-	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
-		kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
-		ret = 1;
-		goto out_put_page;
-	}
-
-	if (fault->nested)
-		adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
-
 	kvm_fault_lock(kvm);
 	pgt = fault->vcpu->arch.hw_mmu->pgt;
 	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
@@ -1961,24 +1990,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (fault->writable)
-		fault->prot |= KVM_PGTABLE_PROT_W;
-
-	if (fault->exec_fault)
-		fault->prot |= KVM_PGTABLE_PROT_X;
-
-	if (fault->s2_force_noncacheable) {
-		if (fault->vfio_allow_any_uc)
-			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
-		else
-			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
-		fault->prot |= KVM_PGTABLE_PROT_X;
-	}
-
-	if (fault->nested)
-		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
-
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
-- 
2.47.3

