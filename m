Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C9C4ADD8E
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636723; cv=none; b=vA42H3LZ86bTo73MRU9nFOI6ajgmEzQ9YdjQyTzqhYNXht86X9+tZzkWjmeBFy+eNmLR1Szx8kLw1wRC2NzL055o59mJ3nojKzEWECY5bNG4/q+0bhtbQdpOdOdUtolFTKZ8Qfc3eM23kM5oaJJS0bHJbr3gL1+ZO06NeslM8HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636723; c=relaxed/simple;
	bh=9pjYOIEzdyKNdQkNYW5OL/VC49oIe6n7Ll8yQAOYXfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YU/RUlUa5r+HqH63rflNV4hASpJOOGXAswnEm/2CmltfZAZe2bMUlQJDn/gOJO1C9IODp8hXagRswB3Zzyx4YrjnXP7xX8jHEc3hH68R7XCSszxmvgTJeEoZZCDLfPWvlaoiG7zpPm3lVbDrqHVIc5SCmmDrL7dWJ+Dw8kzwWvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fGAgII4S; arc=none smtp.client-ip=91.218.175.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fGAgII4S"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9pjYOIEzdyKNdQkNYW5OL/VC49oIe6n7Ll8yQAOYXfg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789636718; v=1; x=1790241518;
 b=fGAgII4SOg0hosuZF62MUB97l48QjCncM+VdydLjbNWkq/qCiFowC4O8bNupmEwuuVIbwVdq
 kIh/pb5a78w2kWRfJSF7bzP4Y4pWcT2hZQvAW7WNLfUzuGOsKerbozzr37ZqjzwrhrS7hsaa5x0
 eKQfOO7e3NQ3MdUvmXSZ3baQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 669cc4c428177e18;
	Thu, 17 Sep 2026 09:18:38 +0000
X-Mizu-Trace-ID: 669cc4c428177e18
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	qperret@google.com,
	vdonnefort@google.com,
	martijnbogaard@google.com,
	seiden@linux.ibm.com,
	tabba@google.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/4] KVM: arm64: Honour the requested IPA size under pKVM
Date: Thu, 17 Sep 2026 10:18:25 +0100
Message-Id: <20260917091826.2639205-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917091826.2639205-1-fuad.tabba@linux.dev>
References: <20260917091826.2639205-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM gives every VM the host's IPA limit, whatever
KVM_VM_TYPE_ARM_IPA_SIZE requested, so vgic_init fails on any pKVM host
whose limit exceeds 40 bits: the addresses it expects a 40-bit VM to
reject are in range. EL2 also sizes the guest's stage 2 from the host
stage 2's VTCR, which on a 64K kernel built for 48-bit PAs on a 52-bit
part is 48 bits where the limit is 52: a memslot above 2^48 the host
accepts returns -ERANGE on the guest's first access.

Have EL2 take the IPA size from the VTCR the host sized the VM and the
donated pgd with, bounded by kvm_get_ipa_max(), and drop the host-side
override, so the request is checked and honoured as on any other host.

Fixes: 60dfe093ec13 ("KVM: arm64: Instantiate guest stage-2 page-tables at EL2")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 20 ++++++++++++++++----
 arch/arm64/kvm/mmu.c           |  4 +---
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3770315b50361..85fc14b7a5bc3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -423,7 +423,8 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 }
 
 static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
-			     unsigned int nr_vcpus, pkvm_handle_t handle)
+			     unsigned int nr_vcpus, pkvm_handle_t handle,
+			     u64 vtcr)
 {
 	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
 	int idx = vm_handle_to_idx(handle);
@@ -439,7 +440,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	/* VMID 0 is reserved for the host */
 	atomic64_set(&mmu->vmid.id, idx + 1);
 
-	mmu->vtcr = host_mmu.arch.mmu.vtcr;
+	mmu->vtcr = vtcr;
 	mmu->arch = &hyp_vm->kvm.arch;
 	mmu->pgt = &hyp_vm->pgt;
 }
@@ -826,6 +827,8 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	unsigned int nr_vcpus;
 	pkvm_handle_t handle;
 	void *pgd = NULL;
+	u32 phys_shift;
+	u64 vtcr;
 	int ret;
 
 	ret = hyp_pin_shared_mem(host_kvm, host_kvm + 1);
@@ -844,8 +847,17 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		goto err_unpin_kvm;
 	}
 
+	phys_shift = VTCR_EL2_IPA(READ_ONCE(host_kvm->arch.mmu.vtcr));
+	if (phys_shift < ARM64_MIN_PARANGE_BITS ||
+	    phys_shift > kvm_get_ipa_max(id_aa64mmfr0_el1_sys_val)) {
+		ret = -EINVAL;
+		goto err_unpin_kvm;
+	}
+	vtcr = kvm_get_vtcr(id_aa64mmfr0_el1_sys_val, id_aa64mmfr1_el1_sys_val,
+			    phys_shift);
+
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
-	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
+	pgd_size = kvm_pgtable_stage2_pgd_size(vtcr);
 	if (!IS_ALIGNED(pgd_hva, pgd_size)) {
 		ret = -EINVAL;
 		goto err_unpin_kvm;
@@ -861,7 +873,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	if (!pgd)
 		goto err_remove_mappings;
 
-	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
+	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle, vtcr);
 
 	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
 	if (ret)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4af..5a3a4863f3d13 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -909,9 +909,7 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	u32 phys_shift;
 
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
-	if (is_protected_kvm_enabled()) {
-		phys_shift = kvm_ipa_limit;
-	} else if (phys_shift) {
+	if (phys_shift) {
 		if (phys_shift > kvm_ipa_limit ||
 		    phys_shift < ARM64_MIN_PARANGE_BITS)
 			return -EINVAL;
-- 
2.39.5

