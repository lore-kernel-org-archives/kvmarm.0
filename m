Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A7A37D11E;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611386; cv=none; b=jFfr0hRJBId2OK33j4QmvVwQTfZ8gnchQZhfb4XFFWX/C0Uu2m0OY8LKWJrz4hautMlmBPlqBjkQBlA2eK16XVU3cRwbUYjhmZvPDcfPeBlUnf4I+83rBePBa89Ydo6dR67BtN/OI1Is2eKnMhzMLc6fEqz5VK3OzFSCHs27F90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611386; c=relaxed/simple;
	bh=Fw24B69UdWG8tT1576V07MnXjKKcYHGqI4N1eSecYzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvymWbxgauz6mfRT/sTAwSnx45Cmra/3+igP1I8FocxS5gyyQkVzsWPaPD57xdFWapXqISnlRm6bN72az45lVuK8aUtx/UBt6wQQNX4FcCVb9rZ4g8iEC9jzjW6ZOF41ZX2sKAOgckJ2faeS97ul6s+Lz6jVaQFiHCTyS4TTQ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUjfwrhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUjfwrhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6524C4AF0B;
	Fri, 27 Mar 2026 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611386;
	bh=Fw24B69UdWG8tT1576V07MnXjKKcYHGqI4N1eSecYzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUjfwrhU8/2YI2h7rjVsUStl2rFCPruc/+lRY3u/NCt9PHiQMbS1YNmJ2NM7Y55Ir
	 hO1M9smpq0SXvR/wAB3fIG2yrIEagCtyP9vf7Zse+GMFlbkaeH4fMMezdufFSEsyDt
	 u29l/6o95eWBsJSLHWdv8FcY5Os+E0p83sNT/zBwulcYQbd0A+abLvfR0rTySyQNq/
	 UtG2JP6o2HaWW+rllTIraMvle4asQVL3jGZAHcw57FguFz6/6oV+TCHmR0VZ5w67bl
	 G0N78hq8W1PBnkK+oYXwE1D5JNHqeJ3QrA4Oedi9vM8UfDnHnlDGzYYJrMxz+V9RMH
	 bx0YOpddlWuxg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UG-00000006K4a-03Bb;
	Fri, 27 Mar 2026 11:36:24 +0000
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
Subject: [PATCH v2 08/30] KVM: arm64: Remove redundant state variables from struct kvm_s2_fault
Date: Fri, 27 Mar 2026 11:35:56 +0000
Message-ID: <20260327113618.4051534-9-maz@kernel.org>
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

Remove redundant variables vma_shift and vfio_allow_any_uc from struct
kvm_s2_fault as they are easily derived or checked when needed.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5572b127f8663..1b991300735be 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1721,10 +1721,8 @@ struct kvm_s2_fault {
 	bool mte_allowed;
 	bool is_vma_cacheable;
 	bool s2_force_noncacheable;
-	bool vfio_allow_any_uc;
 	unsigned long mmu_seq;
 	phys_addr_t ipa;
-	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active;
@@ -1749,9 +1747,9 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 		return -EFAULT;
 	}
 
-	fault->vma_shift = kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot, fault->nested,
-						   &fault->force_pte, &fault->ipa);
-	fault->vma_pagesize = 1UL << fault->vma_shift;
+	fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
+							     fault->nested, &fault->force_pte,
+							     &fault->ipa);
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
@@ -1764,8 +1762,6 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 	fault->gfn = fault->ipa >> PAGE_SHIFT;
 	fault->mte_allowed = kvm_vma_mte_allowed(vma);
 
-	fault->vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
-
 	fault->vm_flags = vma->vm_flags;
 
 	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
@@ -1796,7 +1792,7 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
 	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(fault->hva, fault->vma_shift);
+		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
 		return 0;
 	}
 	if (is_error_noslot_pfn(fault->pfn))
@@ -1874,7 +1870,7 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
 	if (fault->s2_force_noncacheable) {
-		if (fault->vfio_allow_any_uc)
+		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
 			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
 			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
@@ -1978,7 +1974,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		.logging_active = memslot_is_logging(memslot),
 		.force_pte = memslot_is_logging(memslot),
 		.s2_force_noncacheable = false,
-		.vfio_allow_any_uc = false,
 		.prot = KVM_PGTABLE_PROT_R,
 	};
 	struct kvm_s2_fault *fault = &fault_data;
-- 
2.47.3

