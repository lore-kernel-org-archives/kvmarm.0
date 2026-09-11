Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FC6486B8F
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134690; cv=none; b=g9Fr1WQAKrFLl53tQ4qVLqfX0FjMEp5tFnsFhPbujY295RaCodRDoBpOGUrb1Sgt/jQXJdeesdyVIQyMwtnJOSg/211X4JtXpUmfzbKB9CF9IT39XykZ1tmGKCgr1tAwLrDRwQ2dMWPlUW1lNIimNsJCfPw95dW6foM4E5uKrrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134690; c=relaxed/simple;
	bh=IQ/M8Yl1AKnwD4zyPZUtvUDc/UWcLbbj0qjCSRElLK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pp/lQ8Ob/O4wauCbxXpgvMWZLX4PZlqUPqcYaHlwpv2T7wbo8+vqcjVAjNZmWbjQgskPX1oDThB9alfIqDd2ipxOLe6kYLplmlUmUfU7iyLvxHUZVKbajjXrrhR9xOPbY/RIe+QOR9LNKp45fNCkYNZ5I7XwVb0MyWOh/yB520k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FQNhKZKJ; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FQNhKZKJ"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49b0e6638e3so7170205e9.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134684; x=1789739484; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HszkVWFP7Noq8WhHATPc5LOgdotiy1DdsO2MJHAL+IE=;
        b=FQNhKZKJ+msBGFEDuNWJ9vahrv2oKSBQq9tgNfq+SgPhOsZoaxEsytFrW6xc1SXQ5U
         zYHvJ4rL8EmR0mg0+hRLt+iJ8u3YYUFBWFVnbTamwVn+06RjdPRz0P5TtKD5nYBinvA7
         CuDkjJEVY1tw7Ula8EqgSAAUpXkVQZtmuchRWw8MZHyOFVy+chaL4WMNlMrYYrHC/P4B
         Q8e8QqFme+0D0djXIzw2ayxvvzUWltLPNsX5+xHERgDsfX4oZtY7rocnVunrSwo4sDoH
         hJoFY4zCfBZvnqFIYb9JsxalWFVlLJV1cxcD1zyjQvvM+RPwVCAj9swDRFAniZxCjWmp
         MFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134684; x=1789739484;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HszkVWFP7Noq8WhHATPc5LOgdotiy1DdsO2MJHAL+IE=;
        b=OrcoH4kI/WhdLZaNqtYD4kfWIcLNN1GwbXzTyCN+KgbX6mJ/7ruNrGxLldXBBChdVJ
         fmLGxoA+T0ni23XW/Wwy8jkRT/VCpeHgGg0yQX9Seao7glMzasPreEXF71LFCPUeNMbx
         0+ndNzfT8Ztctply3Mmp/8e6Qjf3TCQPbNa3+uG+RZF73MHBTERDxxbR7/JAa3hDGznp
         UK4bnVhjEf9MR+PDl1kMuSBUszGrzdcc2mSXC6vybvOyG9eZExSIlmm+q6gjOgHMBBln
         gzoyjX3DTi/mXSD/LgGtZ5Quo0B5oi/uNMSjtO7bKOd6P6If+k+evYTp7HLasErmmn8d
         GRTw==
X-Forwarded-Encrypted: i=1; AKwUvByIrnVVNMzbcPZKOQhohyUAftvENZv8yeY/bdV8rS4bJR7YGb8dXDz5vS8eMs0vwIz9FgvPBp4=@lists.linux.dev
X-Gm-Message-State: AFuF++lY3V3XgiKIzpSOnWXvp3hPaOpCOZRvPBj+Xhdt0oZoO3xi21WV
	SXGzIF+c1hpSqkMT1aNXLBjue8rVdNMDxYbuubqo2dbVgAyUbY/HA70b/nTn99qx0wdZUmpBnXA
	cxB1r9yM1+v9Nbf8rOx/KhA==
X-Received: from wmnp7.prod.google.com ([2002:a05:600c:2e87:b0:495:5ec9:83bb])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b02:b0:49d:1f32:c911 with SMTP id 5b1f17b1804b1-49e61982fb0mr51570255e9.3.1789134683428;
 Fri, 11 Sep 2026 06:51:23 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:49 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-19-vdonnefort@google.com>
Subject: [PATCH v2 18/22] KVM: arm64: Add __pkvm_host_split_guest HVC
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This HVC allows the host to break an existing block in a protected VM. This
will later allow the guest to share a sub-region of an existing
huge-mapping with the host.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  22 +++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 127 ++++++++++++++++--
 4 files changed, 138 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ec59f0fe9374..a67d171c86d0 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -105,6 +105,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_split_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 7904a95ab8ac..f9604f9a92dc 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -50,6 +50,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
+int __pkvm_host_split_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7ef7da69f48b..cc0e1061d584 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -540,6 +540,27 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static void handle___pkvm_host_split_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, gfn, host_ctxt, 1);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 2);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int ret = -EINVAL;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || !pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		goto out;
+
+	ret = pkvm_refill_memcache(hyp_vcpu);
+	if (ret)
+		goto out;
+
+	ret = __pkvm_host_split_guest(gfn, nr_pages, hyp_vcpu);
+
+out:
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -958,6 +979,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
 	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
+	HANDLE_FUNC(__pkvm_host_split_guest),
 	HANDLE_FUNC(__pkvm_reserve_vm),
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2e8c241f76c9..f4943c2a237f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -578,6 +578,12 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 
 #define KVM_HOST_DONATION_PTE_OWNER_MASK	GENMASK(3, 1)
 #define KVM_HOST_DONATION_PTE_EXTRA_MASK	GENMASK(59, 4)
+static kvm_pte_t host_stage2_encode_annotation(u8 owner_id, u64 meta)
+{
+	return FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, owner_id) |
+	       FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
+}
+
 static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
 						 u8 owner_id, u64 meta)
 {
@@ -596,8 +602,7 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
 	if (!FIELD_FIT(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta))
 		return -EINVAL;
 
-	annotation = FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, owner_id) |
-		     FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
+	annotation = host_stage2_encode_annotation(owner_id, meta);
 	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
 			      addr, size, &host_s2_pool,
 			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
@@ -649,10 +654,8 @@ static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
 	       FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
 }
 
-static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
-				       u64 *gfn)
+static int host_stage2_decode_gfn_meta(kvm_pte_t pte, pkvm_handle_t *handle, u64 *gfn)
 {
-	pkvm_handle_t handle;
 	u64 meta;
 
 	if (WARN_ON(kvm_pte_valid(pte)))
@@ -667,17 +670,59 @@ static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
 		return -EPERM;
 
 	meta = FIELD_GET(KVM_HOST_DONATION_PTE_EXTRA_MASK, pte);
-	handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
-	*vm = get_vm_by_handle(handle);
-	if (!*vm) {
-		/* We probably raced with teardown; try again */
-		return -EAGAIN;
-	}
-
+	*handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
 	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
 	return 0;
 }
 
+static int host_stage2_split_gfn_meta(phys_addr_t phys, u64 ipa, u64 size, struct pkvm_hyp_vm *vm)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = &host_mmu.mm_ops;
+	struct kvm_pgtable *pgt = &host_mmu.pgt;
+	kvm_pte_t pte, *table, *ptep;
+	pkvm_handle_t handle;
+	s8 level;
+	u64 gfn;
+	int ret;
+
+	ret = kvm_pgtable_get_leaf(pgt, phys, &pte, &level);
+	if (ret)
+		return ret;
+
+	if (kvm_granule_size(level) != size)
+		return -EINVAL;
+
+	ret = host_stage2_decode_gfn_meta(pte, &handle, &gfn);
+	if (ret)
+		return ret;
+
+	if (handle != vm->kvm.arch.pkvm.handle || gfn != (ipa >> PAGE_SHIFT))
+		return -EINVAL;
+
+	table = mm_ops->zalloc_page(&host_s2_pool);
+	if (!table)
+		return -ENOMEM;
+
+	ptep = table;
+	while (ptep < table + PTRS_PER_PTE) {
+		u64 meta = host_stage2_encode_gfn_meta(vm, gfn);
+		kvm_pte_t annotation = host_stage2_encode_annotation(PKVM_ID_GUEST, meta);
+
+		*ptep = FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK, KVM_HOST_INVALID_PTE_TYPE_DONATION) |
+			annotation;
+
+		mm_ops->get_page(ptep);
+		ptep++;
+		gfn++;
+	}
+
+	ret = kvm_pgtable_stage2_table_install(pgt, phys, size, table);
+	if (ret)
+		kvm_pgtable_stage2_free_unlinked(mm_ops, table, level);
+
+	return ret;
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
@@ -1328,6 +1373,7 @@ static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_h
 				      u64 *gfn)
 {
 	enum pkvm_page_state state;
+	pkvm_handle_t handle;
 	kvm_pte_t pte;
 	s8 level;
 	int ret;
@@ -1356,10 +1402,16 @@ static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_h
 	if (level < KVM_PGTABLE_LAST_LEVEL - 1)
 		return -E2BIG;
 
-	ret = host_stage2_decode_gfn_meta(pte, vm, gfn);
+	ret = host_stage2_decode_gfn_meta(pte, &handle, gfn);
 	if (ret)
 		return ret;
 
+	*vm = get_vm_by_handle(handle);
+	if (!*vm) {
+		/* We probably raced with teardown; try again */
+		return -EAGAIN;
+	}
+
 	*size = kvm_granule_size(level);
 
 	return 0;
@@ -1755,6 +1807,55 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	return 0;
 }
 
+int __pkvm_host_split_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct kvm_hyp_memcache *mc = &vcpu->vcpu.arch.pkvm_memcache;
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 size = nr_pages << PAGE_SHIFT;
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	kvm_pte_t pte, *table;
+	phys_addr_t phys;
+	s8 level;
+	int ret;
+
+	if (!vcpu->vcpu.arch.pkvm_memcache.nr_pages)
+		return -ENOMEM;
+
+	if (size != PMD_SIZE || !IS_ALIGNED(ipa, PMD_SIZE))
+		return -EINVAL;
+
+	level = KVM_PGTABLE_LAST_LEVEL - 1;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &phys);
+	if (ret)
+		goto unlock;
+
+	table = kvm_pgtable_stage2_create_unlinked(&vm->pgt, kvm_pte_to_phys(pte), level,
+						   kvm_pgtable_stage2_pte_prot(pte),
+						   mc, true);
+	if (IS_ERR(table)) {
+		ret = PTR_ERR(table);
+		goto unlock;
+	}
+
+	ret = host_stage2_split_gfn_meta(phys, ipa, size, vm);
+	if (ret) {
+		kvm_pgtable_stage2_free_unlinked(&vm->mm_ops, table, level);
+		goto unlock;
+	}
+
+	WARN_ON(kvm_pgtable_stage2_table_install(&vm->pgt, ipa, size, table));
+
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 #ifdef CONFIG_NVHE_EL2_DEBUG
 struct pkvm_expected_state {
 	enum pkvm_page_state host;
-- 
2.55.0.1007.g17ff1f9808-goog

