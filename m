Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBED3822B8;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611386; cv=none; b=COvnSwkADTYTP6sfwz0UWYTCy7cvTnpFgRG2Z/z2+3L8scjoACyWl2ehsfOsoTBs6kxf4I3vRp5LwiMcGVhQsm+BGgOLOOoTP1c/50q9Ip2vHUztV5e1uqhyqs9e0cKXiV4es5zXmA+s84sF89PNH84LIWFmAcoDI/iSYvB0IWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611386; c=relaxed/simple;
	bh=h5y0qz3kbgq48wbW8h/YhcujOIT4D9Kb6TNwgAVFX+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYkNdg3Mk8MNQi0K+3JDUqrdmCnYmwvFGi5Um0uxgox3kd14CiOPPD3+V27S9KZdrmXBZS1DfpOJ4UM140Gih3PahvFx4ZwN3fOoFQlnwvzGSMFj2F5sKOQGAaice/GNyQZ/DFxKxnlxcu+AfRqGcWfoKDSzfS1JzN0g5omP79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEoiIuio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEoiIuio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5E5C2BC86;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611386;
	bh=h5y0qz3kbgq48wbW8h/YhcujOIT4D9Kb6TNwgAVFX+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEoiIuioxPdJiRU2/mbqxLBcJZIB9Rj8cPlplxNxKzdGcVuwngwsXEo4ZToMJLVme
	 yu+hPbMR6AlFOXHCzy2SZ8FwBJZh1v0vb3cx7D6KYEa6cMAWZQ6lwxlHs0c/yNJXG7
	 Kv4j5eCX3Ama9akdloVJuZZYllq9ZHhDIhXnVRDNeKq9CXv9vGW85Zibb2kgk5GmMc
	 Y6Rusr6589VRANl4YXIwZpCi1Ql0eMcccSd4kLrfyh6m3Ise+EP6AY8469TTrXmBST
	 yrfLR+AdEhZTAsn518av2DpNdj9+0tsHE9Li3v1OolUjGDZNvRD5kghtdrxrxto0x1
	 zUtxv320uAGQw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UG-00000006K4a-2BaR;
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
Subject: [PATCH v2 10/30] KVM: arm64: Initialize struct kvm_s2_fault completely at declaration
Date: Fri, 27 Mar 2026 11:35:58 +0000
Message-ID: <20260327113618.4051534-11-maz@kernel.org>
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

Simplify the initialization of struct kvm_s2_fault in user_mem_abort().

Instead of partially initializing the struct via designated initializers
and then sequentially assigning the remaining fields (like write_fault
and topup_memcache) further down the function, evaluate those
dependencies upfront.

This allows the entire struct to be fully initialized at declaration. It
also eliminates the need for the intermediate fault_data variable and
its associated fault pointer, reducing boilerplate.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e77b0b60697f6..2b85daaa4426b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1962,8 +1962,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
-	int ret = 0;
-	struct kvm_s2_fault fault_data = {
+	bool write_fault = kvm_is_write_fault(vcpu);
+	bool logging_active = memslot_is_logging(memslot);
+	struct kvm_s2_fault fault = {
 		.vcpu = vcpu,
 		.fault_ipa = fault_ipa,
 		.nested = nested,
@@ -1971,19 +1972,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		.hva = hva,
 		.fault_is_perm = fault_is_perm,
 		.ipa = fault_ipa,
-		.logging_active = memslot_is_logging(memslot),
-		.force_pte = memslot_is_logging(memslot),
-		.s2_force_noncacheable = false,
+		.logging_active = logging_active,
+		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
+		.fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
+		.write_fault = write_fault,
+		.exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
+		.topup_memcache = !fault_is_perm || (logging_active && write_fault),
 	};
-	struct kvm_s2_fault *fault = &fault_data;
 	void *memcache;
+	int ret;
 
-	if (fault->fault_is_perm)
-		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
-	fault->write_fault = kvm_is_write_fault(fault->vcpu);
-	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
-	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
+	VM_WARN_ON_ONCE(fault.write_fault && fault.exec_fault);
 
 	/*
 	 * Permission faults just need to update the existing leaf entry,
@@ -1991,9 +1991,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	fault->topup_memcache = !fault->fault_is_perm ||
-				(fault->logging_active && fault->write_fault);
-	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
+	ret = prepare_mmu_memcache(vcpu, fault.topup_memcache, &memcache);
 	if (ret)
 		return ret;
 
@@ -2001,17 +1999,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
-	ret = kvm_s2_fault_pin_pfn(fault);
+	ret = kvm_s2_fault_pin_pfn(&fault);
 	if (ret != 1)
 		return ret;
 
-	ret = kvm_s2_fault_compute_prot(fault);
+	ret = kvm_s2_fault_compute_prot(&fault);
 	if (ret) {
-		kvm_release_page_unused(fault->page);
+		kvm_release_page_unused(fault.page);
 		return ret;
 	}
 
-	return kvm_s2_fault_map(fault, memcache);
+	return kvm_s2_fault_map(&fault, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.47.3

