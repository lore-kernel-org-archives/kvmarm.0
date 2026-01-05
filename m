Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FA7332EA3
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628280; cv=none; b=sArEBc3RwoKnkAXo81JNhhvLI4NmToKXnN25ZTZJ0LTLQxDS/GSfuvHSsfcLAt7d3YnC9y6Op1qDwTv2Lgu/L6BSiOgCTGt1Bb7sbS+xXpFc6NCSBTNlBOCZy1Vew5qmDybJMlSBKZD1CulYhcIekFJeNkCalyayinBwPiOz4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628280; c=relaxed/simple;
	bh=ZfA4UiYzGCQK0cKgopfw/hgwBoFVIptbiSIx9OCxWUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR33mzDAZvW7pgyn6/0R5EQA+lzGyCY5mL1rPVkA9nwU17iaY1WIm7GngekC0zQKT+fJ/QmgIdCXowxaUuQlip9g/01r59XklDi/zA1wj/lo2ipCeq9geRvuyzD16sDYcKIHQktaqd2qbWEKeVZBSqqkNrqhimrLfLK1/AzWCzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=In5EPAjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="In5EPAjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A18C19421;
	Mon,  5 Jan 2026 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628280;
	bh=ZfA4UiYzGCQK0cKgopfw/hgwBoFVIptbiSIx9OCxWUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=In5EPAjsQr2rW6Ope7CCN5D7aJR9li8Br8OtEK2+f6DaLBHPgjB5rcSWySgbbWD8n
	 KTt+oMf1bdU7tKV+kOn48VmtKs856C8skddVug2eTzfVZa6oWMAOHHExJ1w1+AW30q
	 k3qiV8Y3QeYQofFgXr+lV1LwavNDwUrvkTLCdepJD807C5StAWelnRh9cgzDSIy9w4
	 PH7Zbyr9VwIkXidDso6IG8Bb/QWEK0jVT9n9ZE6rDwnd5uK8/xwGVKcR6IAH3xXlDK
	 XT8lCS5Ycq1GCW/qBq7XhWQOl8xYyBda3CAIGxTQDAoMLILQ0idC3z0KC1Fa6ZkLuz
	 8+gPYMheh1rWw==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 29/30] KVM: arm64: Register 'selftest_vm' in the VM table
Date: Mon,  5 Jan 2026 15:49:37 +0000
Message-ID: <20260105154939.11041-30-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 53 ++++---------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 49 +++++++++++++++++
 3 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index e41a128b0854..3ad644111885 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -77,6 +77,8 @@ static __always_inline void __load_host_stage2(void)
 
 #ifdef CONFIG_NVHE_EL2_DEBUG
 void pkvm_ownership_selftest(void *base);
+struct pkvm_hyp_vcpu *init_selftest_vm(void *virt);
+void teardown_selftest_vm(void);
 #else
 static inline void pkvm_ownership_selftest(void *base) { }
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a586ca922258..f59f5e24ddda 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1609,53 +1609,18 @@ struct pkvm_expected_state {
 
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
@@ -1670,10 +1635,10 @@ static void assert_page_state(void)
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
@@ -1686,14 +1651,15 @@ void pkvm_ownership_selftest(void *base)
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
@@ -1817,6 +1783,7 @@ void pkvm_ownership_selftest(void *base)
 	selftest_state.hyp = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, 1);
 
+	teardown_selftest_vm();
 	selftest_page->refcount = 1;
 	hyp_put_page(&host_s2_pool, virt);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 2890328f4a78..6dc90ccc99a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -696,6 +696,55 @@ void __pkvm_unreserve_vm(pkvm_handle_t handle)
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
2.52.0.351.gbe84eed79e-goog

