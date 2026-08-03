Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F5B3749F4
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751878; cv=none; b=rHtVPQ2+r5CylfOBzAQlPbuhe4zk73ZSadzDwlTRnn+UTtX+thB7xEYq4/3sQR+oJeSXdpRJhGTpx8RAE3R1MrBaLsluUEdz+aRTEx8aZ/IpHoFrQm20IU7d0XDe+XlPc7bUN2w1hM9pabYEILVjKiMRqMjB8VRaJyenpsUbMRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751878; c=relaxed/simple;
	bh=/r9EyE/slBHIryyPlRC12PzhPYyHpx8XFMsRDmb+NKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HceFdYMAuHAoUWQDX5KiRZIoEsz6MmA417VUbpJ9ady44ulR33xwycVsSMGndn2dkVCCztao7OvEr91BvcHmjU0gac5LrRHo5ktG8cAZ28w5+R3JH1oKYRxJK5dkGXoYgTjOQChxz6OEuNY2HVQ195cOXs8MmUK1/YFVFM28PTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NFs7xbwX; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NFs7xbwX"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495529a93f9so20067245e9.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751874; x=1786356674; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=guvJM9Her1jXvvCU0BN7In2IeI4vlLTOEKQWq0g2vDU=;
        b=NFs7xbwX6UmRcUNte4aWw1GBjrhVpIkhtmkkeYTbewTjSA9yU0Z1LINhYD2bi9izAk
         m0kPs7pmEu/wpYuK5HPUWHGMqlwvrxtTiLuAD4crc5KPz28UAwVaNZOu16peU0A2+SDt
         HOvN1V0eVigTYd2w+CgjeRJXnmWf0Iq3GZCy7SbRit3yuGyOznOLpfW5F4hZE4Yl6+m0
         +zyiyPJJuWv0bazCkViVcl9Y77FPvyjQeYVi5uy3pkkpWOHOhE7j0biwEohK78WV7uIH
         kAulJTFTszPPRwjEC2XDMTpwmcEkUjEwhY2wHifR6joRZXPAjxBDwafjlaer1wCNr1jU
         u1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751874; x=1786356674;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=guvJM9Her1jXvvCU0BN7In2IeI4vlLTOEKQWq0g2vDU=;
        b=Vdw44skNLJdEs55xnbpaNDr6cedN5psn01BV0vmnNWcxUN3OlSh506sQMHQPpmyrsF
         DElXFvOdVsNuEhEnhdUmnoOYlWZ4b6BhYQym6Sza+RrBiTrRZlMEtq3WBqV7HePZ6pfE
         ewCOwVHkfef7fASqhTvKOuk8nLIj+COOUtG6FGyUX9NIQwfmto6f33MP04mlDUTtRn3s
         FGMmCX1Uid20nleYhrm5K6Z0Bj6Y3bF4413PW72sf2gn8CvAYhJG5gFZMG3DTCuUVnEM
         fXBlQKRx6CXCEzXI+xqhUZcS/Bamlv5Ur4LN9C+b4bH13Nx6FUE7zOeN+/H6RSO15QoQ
         rf7g==
X-Forwarded-Encrypted: i=1; AHgh+Rp3eUdmM9S/XLHxUC4Rgas1u3y9Ed00wsnAawRCNW4a2emKYuvJkOC/FRZmMKuCa0BROh2eOas=@lists.linux.dev
X-Gm-Message-State: AOJu0YznvfW+fFBrADR1PrKPW4NNGerhw1o7ISUQW7VJ1/EVczzCQ2yP
	ZV34pNBUAwwcPceE0tB4+BHZDpiYbzl+fVhYkYkxUQ2ETkX+JC1BrLhgZVtce2ROFMuJhqrI9rX
	/Vu8ILwJfTa1lWB4XFU0kRw==
X-Received: from wmpn28.prod.google.com ([2002:a05:600c:181c:b0:493:b78f:716b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:840f:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-4980c64520fmr180976105e9.2.1785751873934;
 Mon, 03 Aug 2026 03:11:13 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:09:00 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-17-vdonnefort@google.com>
Subject: [PATCH 16/20] KVM: arm64: Add __pkvm_host_split_guest HVC
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This HVC allows the host to break an existing block in a protected VM. This
will later allow the guest to share a sub-region of an existing
huge-mapping with the host.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 00ba99c85874..3cd99ff6fd9b 100644
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
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..355573d53fed 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -824,8 +824,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * kvm_pgtable_stage2_split() is best effort: it tries to break as many
  * blocks in the input range as allowed by @mc_capacity.
  */
-int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
-			     struct kvm_mmu_memory_cache *mc);
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
 
 /**
  * kvm_pgtable_walk() - Walk a page-table.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 41813bb93b2e..baafbd7ca215 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -216,8 +216,7 @@ int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_
 				    enum kvm_pgtable_walk_flags flags);
 void pkvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
 				 enum kvm_pgtable_walk_flags flags);
-int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
-			      struct kvm_mmu_memory_cache *mc);
+int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
 void pkvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level);
 kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
 					       enum kvm_pgtable_prot prot, void *mc,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 9d4604d93b98..85438026dc43 100644
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
index ff8b7ac8dd56..75cf1b4df3a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -393,6 +393,30 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
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
+	if (!hyp_vcpu)
+		goto out;
+
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
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
@@ -764,6 +788,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
 	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
+	HANDLE_FUNC(__pkvm_host_split_guest),
 	HANDLE_FUNC(__pkvm_reserve_vm),
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index e16dde4c5f4b..71ebd1856cb0 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -642,10 +642,8 @@ static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
 	       FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
 }
 
-static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
-				       u64 *gfn)
+static int host_stage2_decode_gfn_meta(kvm_pte_t pte, pkvm_handle_t *handle, u64 *gfn)
 {
-	pkvm_handle_t handle;
 	u64 meta;
 
 	if (WARN_ON(kvm_pte_valid(pte)))
@@ -660,14 +658,49 @@ static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
 		return -EPERM;
 
 	meta = FIELD_GET(KVM_HOST_DONATION_PTE_EXTRA_MASK, pte);
-	handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
-	*vm = get_vm_by_handle(handle);
-	if (!*vm) {
-		/* We probably raced with teardown; try again */
-		return -EAGAIN;
+	*handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
+	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
+	return 0;
+}
+
+static int host_stage2_split_gfn_meta(phys_addr_t phys, u64 ipa, u64 size, struct pkvm_hyp_vm *vm)
+{
+	pkvm_handle_t handle;
+	kvm_pte_t pte;
+	u64 gfn, end;
+	s8 level;
+	int ret;
+
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
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
+	end = phys + size;
+	while (phys < end) {
+		u64 meta = host_stage2_encode_gfn_meta(vm, gfn);
+		kvm_pte_t annotation = FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_GUEST) |
+				       FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
+
+		ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+				      phys, PAGE_SIZE, &host_s2_pool,
+				      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
+		if (WARN_ON(ret))
+			return ret;
+
+		phys += PAGE_SIZE;
+		gfn++;
 	}
 
-	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
 	return 0;
 }
 
@@ -1321,6 +1354,7 @@ static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_h
 				      u64 *gfn)
 {
 	enum pkvm_page_state state;
+	pkvm_handle_t handle;
 	kvm_pte_t pte;
 	s8 level;
 	int ret;
@@ -1349,10 +1383,16 @@ static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_h
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
@@ -1748,6 +1788,39 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	return 0;
 }
 
+int __pkvm_host_split_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct kvm_hyp_memcache *mc = &vcpu->vcpu.arch.pkvm_memcache;
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 size = nr_pages << PAGE_SHIFT;
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	phys_addr_t phys;
+	kvm_pte_t pte;
+	int ret;
+
+	if (size != PMD_SIZE)
+		return -EINVAL;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &phys);
+	if (ret)
+		goto unlock;
+
+	ret = host_stage2_split_gfn_meta(phys, ipa, size, vm);
+	if (ret)
+		goto unlock;
+
+	ret = kvm_pgtable_stage2_split(&vm->pgt, ipa, size, mc);
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
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c4ebae0544d4..986b5a19b07a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1537,9 +1537,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
-	struct kvm_mmu_memory_cache *mc = ctx->arg;
-	struct kvm_s2_mmu *mmu;
+	struct stage2_map_data *data = ctx->arg;
 	kvm_pte_t pte = ctx->old, new, *childp;
+	struct kvm_s2_mmu *mmu = data->mmu;
+	void *mc = data->memcache;
 	enum kvm_pgtable_prot prot;
 	s8 level = ctx->level;
 	bool force_pte;
@@ -1554,30 +1555,37 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!kvm_pte_valid(pte))
 		return 0;
 
-	nr_pages = stage2_block_get_nr_page_tables(level);
-	if (nr_pages < 0)
-		return nr_pages;
-
-	if (mc->nobjs >= nr_pages) {
-		/* Build a tree mapped down to the PTE granularity. */
+	if (unlikely(is_protected_kvm_enabled())) {
+		/* pKVM only supports splitting PMD-level blocks */
+		if (level != KVM_PGTABLE_LAST_LEVEL - 1)
+			return -EINVAL;
 		force_pte = true;
 	} else {
-		/*
-		 * Don't force PTEs, so create_unlinked() below does
-		 * not populate the tree up to the PTE level. The
-		 * consequence is that the call will require a single
-		 * page of level 2 entries at level 1, or a single
-		 * page of PTEs at level 2. If we are at level 1, the
-		 * PTEs will be created recursively.
-		 */
-		force_pte = false;
-		nr_pages = 1;
+		struct kvm_mmu_memory_cache *host_mc = mc;
+
+		nr_pages = stage2_block_get_nr_page_tables(level);
+		if (nr_pages < 0)
+			return nr_pages;
+
+		if (host_mc->nobjs >= nr_pages) {
+			/* Build a tree mapped down to the PTE granularity. */
+			force_pte = true;
+		} else if (host_mc->nobjs) {
+			/*
+			 * Don't force PTEs, so create_unlinked() below does
+			 * not populate the tree up to the PTE level. The
+			 * consequence is that the call will require a single
+			 * page of level 2 entries at level 1, or a single
+			 * page of PTEs at level 2. If we are at level 1, the
+			 * PTEs will be created recursively.
+			 */
+			force_pte = false;
+			nr_pages = 1;
+		} else {
+			return -ENOMEM;
+		}
 	}
 
-	if (mc->nobjs < nr_pages)
-		return -ENOMEM;
-
-	mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
 	phys = kvm_pte_to_phys(pte);
 	prot = kvm_pgtable_stage2_pte_prot(pte);
 
@@ -1601,13 +1609,16 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
-			     struct kvm_mmu_memory_cache *mc)
+int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc)
 {
+	struct stage2_map_data data = {
+		.mmu		= pgt->mmu,
+		.memcache	= mc,
+	};
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_split_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
-		.arg	= mc,
+		.arg	= &data,
 	};
 	int ret;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 2dc67e8d1aaa..379bdc2b258a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -613,8 +613,7 @@ kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys
 	return NULL;
 }
 
-int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
-			      struct kvm_mmu_memory_cache *mc)
+int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc)
 {
 	WARN_ON_ONCE(1);
 	return -EINVAL;
-- 
2.55.0.508.g3f0d502094-goog

