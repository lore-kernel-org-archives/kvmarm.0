Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CBC2417E0
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620163; cv=none; b=mD7mMbtcNzML5COhqzTzTE/hYpxV+ni0dAkQqI13epOMZldpPx31EBBKM8okmbXqCon4cd9JbmL12OzDqXiT6Vi4QZ6DRitpfMSaEvCBtlHHd71a5LPx7TmOtnkJ8+5y/yVYorSOatYQ9bteRyIjwVSWcJkSFQ+WQGK7M82sTk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620163; c=relaxed/simple;
	bh=9RpKZ0bXiI/fWPzhGQTQbJUnI1YJY1TLakR0WLPJF/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMhaYUmmBOFTTRk0wuhM3dQDfeYhf2tGfSVioaMHvl8ppIbCJRJzB6QMBHqMwieSTOY6yroUaKHl89nHnDjHGxVQ1YUp6vohlKFj3KEY+7OxO3lJ/E3TboxcDbkwouspt/zObBfyoufqTpDgn2DX5qyZ9OlC67N40JEkwvS4oS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5MDBwBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5MDBwBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F334C2BCB2;
	Fri, 27 Mar 2026 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620163;
	bh=9RpKZ0bXiI/fWPzhGQTQbJUnI1YJY1TLakR0WLPJF/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5MDBwBx21N5kItEpY/eOPfXfW8Bo+ZFZT3TeibXzW2fMCV6J3/YhGAbXlUHac6Kj
	 aO7mj4J/dQSpriItwQlXovs2y28rLoGxUForbjPQtR4PaD+zF2dXQMMbOIa1+lsswx
	 +nY9LrQYPt/4p9B/VeZq9b6vCcyS3T+BL+FPIUHua266JAvVEKCInV20aYNgMCZo6+
	 BKDF8jUc1tume30qnQRDqMhZSEZT+1Q25czJJLD3FdUE6RDuKAss0HTyWCkgSILRJk
	 JQI2T4/cLdk41sbAXCx65DysuJQdo4JBkEwiNZawriXxBMmJ0QV0Tw/8yYaemAQIRS
	 1STrCWcUvIjjw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 34/38] KVM: arm64: Register 'selftest_vm' in the VM table
Date: Fri, 27 Mar 2026 14:00:33 +0000
Message-ID: <20260327140039.21228-35-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for extending the pKVM page ownership selftests to cover
forceful reclaim of donated pages, rework the creation of the
'selftest_vm' so that it is registered in the VM table while the tests
are running.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 53 ++++---------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 49 +++++++++++++++++
 3 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 99d8398afe20..5031879ccb87 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -76,6 +76,8 @@ static __always_inline void __load_host_stage2(void)
 
 #ifdef CONFIG_NVHE_EL2_DEBUG
 void pkvm_ownership_selftest(void *base);
+struct pkvm_hyp_vcpu *init_selftest_vm(void *virt);
+void teardown_selftest_vm(void);
 #else
 static inline void pkvm_ownership_selftest(void *base) { }
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 6525f9fa274c..b2c9ea105701 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1646,53 +1646,18 @@ struct pkvm_expected_state {
 
 static struct pkvm_expected_state selftest_state;
 static struct hyp_page *selftest_page;
-
-static struct pkvm_hyp_vm selftest_vm = {
-	.kvm = {
-		.arch = {
-			.mmu = {
-				.arch = &selftest_vm.kvm.arch,
-				.pgt = &selftest_vm.pgt,
-			},
-		},
-	},
-};
-
-static struct pkvm_hyp_vcpu selftest_vcpu = {
-	.vcpu = {
-		.arch = {
-			.hw_mmu = &selftest_vm.kvm.arch.mmu,
-		},
-		.kvm = &selftest_vm.kvm,
-	},
-};
-
-static void init_selftest_vm(void *virt)
-{
-	struct hyp_page *p = hyp_virt_to_page(virt);
-	int i;
-
-	selftest_vm.kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
-	WARN_ON(kvm_guest_prepare_stage2(&selftest_vm, virt));
-
-	for (i = 0; i < pkvm_selftest_pages(); i++) {
-		if (p[i].refcount)
-			continue;
-		p[i].refcount = 1;
-		hyp_put_page(&selftest_vm.pool, hyp_page_to_virt(&p[i]));
-	}
-}
+static struct pkvm_hyp_vcpu *selftest_vcpu;
 
 static u64 selftest_ipa(void)
 {
-	return BIT(selftest_vm.pgt.ia_bits - 1);
+	return BIT(selftest_vcpu->vcpu.arch.hw_mmu->pgt->ia_bits - 1);
 }
 
 static void assert_page_state(void)
 {
 	void *virt = hyp_page_to_virt(selftest_page);
 	u64 size = PAGE_SIZE << selftest_page->order;
-	struct pkvm_hyp_vcpu *vcpu = &selftest_vcpu;
+	struct pkvm_hyp_vcpu *vcpu = selftest_vcpu;
 	u64 phys = hyp_virt_to_phys(virt);
 	u64 ipa[2] = { selftest_ipa(), selftest_ipa() + PAGE_SIZE };
 	struct pkvm_hyp_vm *vm;
@@ -1707,10 +1672,10 @@ static void assert_page_state(void)
 	WARN_ON(__hyp_check_page_state_range(phys, size, selftest_state.hyp));
 	hyp_unlock_component();
 
-	guest_lock_component(&selftest_vm);
+	guest_lock_component(vm);
 	WARN_ON(__guest_check_page_state_range(vm, ipa[0], size, selftest_state.guest[0]));
 	WARN_ON(__guest_check_page_state_range(vm, ipa[1], size, selftest_state.guest[1]));
-	guest_unlock_component(&selftest_vm);
+	guest_unlock_component(vm);
 }
 
 #define assert_transition_res(res, fn, ...)		\
@@ -1723,14 +1688,15 @@ void pkvm_ownership_selftest(void *base)
 {
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RWX;
 	void *virt = hyp_alloc_pages(&host_s2_pool, 0);
-	struct pkvm_hyp_vcpu *vcpu = &selftest_vcpu;
-	struct pkvm_hyp_vm *vm = &selftest_vm;
+	struct pkvm_hyp_vcpu *vcpu;
 	u64 phys, size, pfn, gfn;
+	struct pkvm_hyp_vm *vm;
 
 	WARN_ON(!virt);
 	selftest_page = hyp_virt_to_page(virt);
 	selftest_page->refcount = 0;
-	init_selftest_vm(base);
+	selftest_vcpu = vcpu = init_selftest_vm(base);
+	vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 
 	size = PAGE_SIZE << selftest_page->order;
 	phys = hyp_virt_to_phys(virt);
@@ -1854,6 +1820,7 @@ void pkvm_ownership_selftest(void *base)
 	selftest_state.hyp = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, 1);
 
+	teardown_selftest_vm();
 	selftest_page->refcount = 1;
 	hyp_put_page(&host_s2_pool, virt);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ebfd9904ede6..794a19fa911d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -727,6 +727,55 @@ void __pkvm_unreserve_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 }
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+static struct pkvm_hyp_vm selftest_vm = {
+	.kvm = {
+		.arch = {
+			.mmu = {
+				.arch = &selftest_vm.kvm.arch,
+				.pgt = &selftest_vm.pgt,
+			},
+		},
+	},
+};
+
+static struct pkvm_hyp_vcpu selftest_vcpu = {
+	.vcpu = {
+		.arch = {
+			.hw_mmu = &selftest_vm.kvm.arch.mmu,
+		},
+		.kvm = &selftest_vm.kvm,
+	},
+};
+
+struct pkvm_hyp_vcpu *init_selftest_vm(void *virt)
+{
+	struct hyp_page *p = hyp_virt_to_page(virt);
+	int i;
+
+	selftest_vm.kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
+	WARN_ON(kvm_guest_prepare_stage2(&selftest_vm, virt));
+
+	for (i = 0; i < pkvm_selftest_pages(); i++) {
+		if (p[i].refcount)
+			continue;
+		p[i].refcount = 1;
+		hyp_put_page(&selftest_vm.pool, hyp_page_to_virt(&p[i]));
+	}
+
+	selftest_vm.kvm.arch.pkvm.handle = __pkvm_reserve_vm();
+	insert_vm_table_entry(selftest_vm.kvm.arch.pkvm.handle, &selftest_vm);
+	return &selftest_vcpu;
+}
+
+void teardown_selftest_vm(void)
+{
+	hyp_spin_lock(&vm_table_lock);
+	remove_vm_table_entry(selftest_vm.kvm.arch.pkvm.handle);
+	hyp_spin_unlock(&vm_table_lock);
+}
+#endif /* CONFIG_NVHE_EL2_DEBUG */
+
 /*
  * Initialize the hypervisor copy of the VM state using host-donated memory.
  *
-- 
2.53.0.1018.g2bb0e51243-goog

