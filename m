Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937479;
	b=s9lCpkUtT6kS6R4AdVn1VCk0K9Q/WcAs4EgCDjxCYAXU3Bk/2mSGluUXUkmMcALlKMNk
	 2GWDTj7luPbnAyeIPYgTh/srEKGgZFjHkVJqNT2jgHdf5HH8UNwyOGy6GyT6/oUKJmidH
	 BUF3JRYZY+0uExE/qEC0bl58ao+/jE7iIk3sFn9tViBDhuUGcAP2xPgfBAm6HufRdFcCW
	 yiE+FecO/HvyCjnkkZBTTqBufyrXj8fwj0q19iLeaK8qL3To7WdTxxGZGCnIjn2weDA9I
	 EcJHKAKJWRGuevOojJF3XMvedWi/uYpfjlJ7HUI3UkNSiLap2q/C6Q3D2mAzRd+ohTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=vPvX/ht4pBJqftClHYRwuIyyxHqkO02bFtcdw128LA8=;
	b=nq6cjgrbFQNgO3zfScinNxeV2jnQj0ft9HUybVGT9AdkK3ROFx5zniUPDF3GSM9h8JZh
	 HOZVd9M9yrk06O0xmFzX3pb5usMOAuYpjMqeEzm5UeYC7Sh8iTk6h5tHsRIqgHBXRXyvQ
	 8aOgVmUk6qV/inn7s1doUsh/BLQc89VrZvO2WrewL8g8+qP/hFLYceNQVJfrlBnb4T9hG
	 SG/82N8L9mansNT5/9d27juQ4CESdN6a4YdSspU5jGs+1/sx6N0akxCENyd+EhR+BNS14
	 RoK/pwwzxEL2Ntlmp2zjleZOl+bZn7tbrSQ7bW2UJP2gk0zJop50MLipqgGkZKy+MQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oyyBwCeJ;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A769606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A769606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oyyBwCeJ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a2065a2ef9so2603865e9.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937478; x=1795542278; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vPvX/ht4pBJqftClHYRwuIyyxHqkO02bFtcdw128LA8=;
        b=oyyBwCeJ9xRWLsyYbD9O9hPEzpU7aCUVrzPJU72Q0juS1CaWZ1Pizmvn+cRgV8g6AS
         0OIiaLfLeVxqPFmhjiFIN1Vl7mfiTvJGQkkwvCbJTjztS5iTklJao0Zp9ZMw924yxIxH
         UxbY2BT+dPpIoXGQ3iW+jrmcVGXUWLJuBUXJxb1yyqtuTOGyZxGiiv0+hD51J1b9K4Hv
         jPZFyDdMEBjB9972YyY/jTFJRk/QB7VqfJlPMqF/R3az7l2t0XrWEQtqWnASr/HGmN8q
         73MobNK6/bBeC+czMODFJhVzDgFZssIMIJaJ6lNgLJapO/cOLqADl8QxJYnuaDUZxgqy
         yH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937478; x=1795542278;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vPvX/ht4pBJqftClHYRwuIyyxHqkO02bFtcdw128LA8=;
        b=oerihljdrUKv0kVD5L685HzFM39pSik9GKmt8hVibHzNLKdJFM26Rg5eHpB/SY2Xcs
         p03sC8W8di84kfFCVjMrFYfa3MPN497S12N7ctImcS1C1I+J+CDZXdQTP568f+AM/xf7
         FrgRcqNMJlIVpbsZzesZw5K4A0gCKs/9eQacgkxGEEMxFG7s/A62htLmrWte8NWcgeAQ
         fEVIt8c7GRRd0eB4Mmyyk2jbQLT4/h7KidjEJtt7UyvAJP2wXnkmKI/3aFrGtyt5Ruir
         XyinIYUvRXF7YBXrxBR3HxrfQOg3qJpH5sGQsse4EB/3iCJwK+ELCdV2U3P/s052XGv7
         mfdw==
X-Forwarded-Encrypted: i=1; AL+hErH3Pq/06Nh4fJPeVlOVdUAxGT2dHhQzLoa5IskM0BmMyhloAEDtk+UbdOcbTex3Pb98rBPx/Ok=@lists.linux.dev
X-Gm-Message-State: APuU4Z/mnU3l5M7UQlEj9b4UR7ZMiBrdqGegokQbi6xvfWRCkFu5gv95
	zgldd5uRFtb4P9vEwaiw7sKMDpMeOmhKTsYpaJyQCKHHMeFab+IpDx6hxKAmpRHpQ0NPdiloKLZ
	46YAF6J4FCd57wYv2QqZ/KQ==
X-Received: from wmcq3.prod.google.com ([2002:a05:600c:c103:b0:4bb:7ad9:3047])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:e555:10b0:4a3:59c9:a747 with SMTP id 5b1f17b1804b1-4bb55a4e55emr218858865e9.17.1794937477736;
 Tue, 17 Nov 2026 09:44:37 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:58 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-20-vdonnefort@google.com>
Subject: [PATCH v4 19/23] KVM: arm64: Add __pkvm_host_split_guest HVC
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
 arch/arm64/include/asm/kvm_hcall.h            |   2 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  18 +++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 127 ++++++++++++++++--
 5 files changed, 136 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 872185f9ac53..9efbd3b50901 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -112,6 +112,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_split_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index e54a4631a378..94eecb24d2c5 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -234,6 +234,8 @@ DECLARE_KVM_HOST_HCALL(int, __pkvm_host_test_clear_young_guest,
 	pkvm_handle_t, handle, u64, gfn, u64, nr_pages, bool, mkold)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
 	u64, gfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_host_split_guest,
+	u64, gfn, u64, nr_pages)
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_reserve_vm)
 DECLARE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
 	pkvm_handle_t, handle)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index a991be3d4c9a..c82b1d6352d5 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -50,6 +50,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
+int __pkvm_host_split_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 bool addr_is_hyp_text(phys_addr_t phys);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 41817f45115d..e7b798253dc3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1072,6 +1072,23 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
 	return __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
 }
 
+DEFINE_KVM_HOST_HCALL(int, __pkvm_host_split_guest,
+	u64, gfn, u64, nr_pages)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int ret;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || !pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return -EINVAL;
+
+	ret = pkvm_refill_memcache(hyp_vcpu);
+	if (ret)
+		return ret;
+
+	return __pkvm_host_split_guest(gfn, nr_pages, hyp_vcpu);
+}
+
 /*
  * PKVM_HOST_STATE_DIRTY names the authoritative copy, the host's when set.
  * A loaded protected vCPU takes the request at its next entry instead.
@@ -1599,6 +1616,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
 	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
+	HANDLE_FUNC(__pkvm_host_split_guest),
 	HANDLE_FUNC(__pkvm_reserve_vm),
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 88af0aec1ea9..e264cfd41e0c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -589,6 +589,12 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 
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
@@ -607,8 +613,7 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
 	if (!FIELD_FIT(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta))
 		return -EINVAL;
 
-	annotation = FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, owner_id) |
-		     FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
+	annotation = host_stage2_encode_annotation(owner_id, meta);
 	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
 			      addr, size, &host_s2_pool,
 			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
@@ -672,10 +677,8 @@ static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
 	       FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
 }
 
-static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
-				       u64 *gfn)
+static int host_stage2_decode_gfn_meta(kvm_pte_t pte, pkvm_handle_t *handle, u64 *gfn)
 {
-	pkvm_handle_t handle;
 	u64 meta;
 
 	if (WARN_ON(kvm_pte_valid(pte)))
@@ -690,17 +693,59 @@ static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
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
+	ret = kvm_pgtable_get_leaf(pgt, phys, &pte, &level, 0);
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
+	ret = kvm_pgtable_stage2_table_install(pgt, table, phys, level);
+	if (ret)
+		kvm_pgtable_stage2_free_unlinked(mm_ops, table, level);
+
+	return ret;
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
@@ -1351,6 +1396,7 @@ static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_h
 				      u64 *gfn)
 {
 	enum pkvm_page_state state;
+	pkvm_handle_t handle;
 	kvm_pte_t pte;
 	s8 level;
 	int ret;
@@ -1379,10 +1425,16 @@ static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_h
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
@@ -1778,6 +1830,55 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	return 0;
 }
 
+int __pkvm_host_split_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct kvm_hyp_memcache *mc = &vcpu->vcpu.arch.stage2_mc;
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 size = nr_pages << PAGE_SHIFT;
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	kvm_pte_t pte, *table;
+	phys_addr_t phys;
+	s8 level;
+	int ret;
+
+	if (!mc->nr_pages)
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
+	ret = host_stage2_try(host_stage2_split_gfn_meta, phys, ipa, size, vm);
+	if (ret) {
+		kvm_pgtable_stage2_free_unlinked(&vm->mm_ops, table, level);
+		goto unlock;
+	}
+
+	WARN_ON(kvm_pgtable_stage2_table_install(&vm->pgt, table, ipa, level));
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
2.56.1.708.g77570a6a1d-goog

