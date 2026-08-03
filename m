Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70EF3749F4
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751867; cv=none; b=N+Mv2tewrqwkbeTAAgBh9WAeWmC4If9aBfDbCaRdn7HrpbSb5FuEH3a+WfzP/h1MV6cWHieuzCRogrSnPc5XtgQYZeX9U6HDJPCuyOchbCX+uXG18eJGXQosgEPagy8OcPnmSc5GV9iRzwf0kJnqd2doMlZ8d6yDhF9PwkDwDtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751867; c=relaxed/simple;
	bh=Rb7l9OJdXc33/a9Si/s/RyOePNKYZ/le56nZBLMWLxE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C6rVOY5sRCFZb7DmVs5ab1Z16u9cIuXefGfSTJi2tTk08WRR1fLIaQrSS706lNLDrfMI6ysusngcd8Lrq4bU4J8UnADsAM3ILbpLgGrz6gYAdh6WPfwqx4/eB0qk4Z04B3UVP/J4H3n/4lKf4KRkTyvgC4e/RwFOOYY/mEXcrJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T0+rCFrQ; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T0+rCFrQ"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954a93c565so10552535e9.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751864; x=1786356664; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/RjpfE+FJ37Ev6ign0yo/K+qLNpZCdAJBKXqZ1Mh2Lw=;
        b=T0+rCFrQlaz05jZ82R90KhIrsSo9QbTr5Bnw7RlnJaMMsBJcfj/2LD/c4vu9x+HNFl
         UopMgLtMzXj6z7JB9ytdXhU6O4pZX+nQAS5jtjAHETWs39rkG29u32SY0pU7dsGntmhf
         AyYe09Ub+legdbkYYp8aJjXi83uKbtoMafjbxR14k7rN8H8wPdiIVYSTfotiYPc3OUGQ
         qUXKCSlhc59lDC7lzWS/tKZrzVONMuD4zK0KN6ZL75bFSmstqkaqmkilBrdWNeqP0+j9
         whO07xQlaGBRSiFUws9v4FYhfkQt3+aux3ve0kA0EXLijiZjeYLowpWcFdlTtP2L08O4
         9JMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751864; x=1786356664;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/RjpfE+FJ37Ev6ign0yo/K+qLNpZCdAJBKXqZ1Mh2Lw=;
        b=Pv/yVlVF1omGx6kqT4MdkITCD9sV4b6pBrbuwfQonb3MuLrMzT83wpOlteMwrzIW/e
         vxrIjZiIE+tQlIz69OdY+Xp6vlvUUklq9VBNp9g23LC+6iLfBNo4Zi3OCPWtmzjkxge4
         PNbaCEK4+2H0Yz0SwUiW6MDLFAAy/xSgQyDW3L7Am5TfzBBHuiBxwz7iU0OQJWfUIrBZ
         UI5c2uPm7779rpXREgjy5kahcfEtIhjR+Kt0XjrvNTd7zAgvt3djbvM7UN00IbRwPhTb
         wezyxH7ae2/NCUVeMqAXXOLoR8mR4WZ0ucKe8UWiNEGflhCYSUq7/an+G/dewA89AZcI
         XWsQ==
X-Forwarded-Encrypted: i=1; AHgh+RrGcfy9ZZ4KJxgB7ZAMkXTSCBqdLD+gxf/JI69rongroTb0BIN88j70R3WbDGyPfBh4BPCIKTE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWNaazLGMOeaxBgVNsFzlNYjpPGVr/TL8f1c7cNeYYXHLQSHjG
	XvPekwtBQqaLAr6/afyGqPCqKanfcRkkPXtrkCoTl6tLvk77n77Do9jKW7cPgxk1SMBOip/Q0eK
	23S0e9hOrr1tgUaDzImIzMw==
X-Received: from wmop13.prod.google.com ([2002:a05:600c:468d:b0:495:6163:c602])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:840f:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-4980c64520fmr180963625e9.2.1785751863432;
 Mon, 03 Aug 2026 03:11:03 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:52 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-9-vdonnefort@google.com>
Subject: [PATCH 08/20] KVM: arm64: Add a range to __pkvm_host_reclaim_page_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs, add a
nr_pages argument to the __pkvm_host_reclaim_page_guest() hypercall. This
range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512
on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index c13f258fffb7..678bb55c694a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -42,7 +42,7 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu);
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
-int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
+int __pkvm_host_reclaim_page_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index f04cea5ff389..0d17e59d5335 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -74,7 +74,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva);
 
-int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
+int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn, u64 nr_pages);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c7a8c2eea157..18d314ea034c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -624,8 +624,9 @@ static void handle___pkvm_reclaim_dying_guest_page(struct kvm_cpu_context *host_
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_reclaim_dying_guest_page(handle, gfn);
+	cpu_reg(host_ctxt, 1) = __pkvm_reclaim_dying_guest_page(handle, gfn, nr_pages);
 }
 
 static void handle___pkvm_start_teardown_vm(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 9ea448895c15..ce637f1a55b3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -891,7 +891,8 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
 	return check_page_state_range(&vm->pgt, addr, size, &d);
 }
 
-static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep, u64 *physp)
+static int __get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa,
+				 kvm_pte_t *ptep, u64 *physp, s8 *levelp)
 {
 	kvm_pte_t pte;
 	u64 phys;
@@ -905,20 +906,32 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
 		return -EHWPOISON;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
-	if (level != KVM_PGTABLE_LAST_LEVEL)
-		return -E2BIG;
 
 	phys = kvm_pte_to_phys(pte);
-	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
+	ret = check_range_allowed_memory(phys, phys + kvm_granule_size(level));
 	if (WARN_ON(ret))
 		return ret;
 
 	*ptep = pte;
 	*physp = phys;
+	*levelp = level;
 
 	return 0;
 }
 
+static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, u64 size,
+			       kvm_pte_t *ptep, u64 *physp)
+{
+	s8 level;
+	int ret;
+
+	ret = __get_valid_guest_pte(vm, ipa, ptep, physp, &level);
+	if (ret)
+		return ret;
+
+	return kvm_granule_size(level) == size ? 0 : -E2BIG;
+}
+
 int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
@@ -1001,7 +1014,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
+	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
 	if (ret)
 		goto unlock;
 
@@ -1033,7 +1046,7 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
+	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
 	if (ret)
 		goto unlock;
 
@@ -1285,6 +1298,14 @@ static void hyp_poison_page(phys_addr_t phys)
 	hyp_fixmap_unmap();
 }
 
+static void hyp_poison_range(phys_addr_t phys, u64 size)
+{
+	u64 offset;
+
+	for (offset = 0; offset < size; offset += PAGE_SIZE)
+		hyp_poison_page(phys + offset);
+}
+
 static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
 				      u64 *gfn)
 {
@@ -1337,7 +1358,7 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 
 	ipa = hyp_pfn_to_phys(gfn);
 	guest_lock_component(vm);
-	ret = get_valid_guest_pte(vm, ipa, &pte, &pa);
+	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &pa);
 	if (ret)
 		goto unlock_guest;
 
@@ -1365,35 +1386,40 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 	return ret;
 }
 
-int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+int __pkvm_host_reclaim_page_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 {
 	u64 ipa = hyp_pfn_to_phys(gfn);
 	kvm_pte_t pte;
 	u64 phys;
+	u64 size;
 	int ret;
 
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &phys);
 	if (ret)
 		goto unlock;
 
 	switch (guest_get_page_state(pte, ipa)) {
 	case PKVM_PAGE_OWNED:
-		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE));
-		hyp_poison_page(phys);
+		WARN_ON(__host_check_page_state_range(phys, size, PKVM_NOPAGE));
+		hyp_poison_range(phys, size);
 		break;
 	case PKVM_PAGE_SHARED_OWNED:
-		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
+		WARN_ON(__host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED));
 		break;
 	default:
 		ret = -EPERM;
 		goto unlock;
 	}
 
-	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE));
-	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
+	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, size));
+	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
 
 unlock:
 	guest_unlock_component(vm);
@@ -1546,11 +1572,10 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	ret = __get_valid_guest_pte(vm, ipa, &pte, &phys, &level);
 	if (ret)
 		return ret;
-	if (!kvm_pte_valid(pte))
-		return -ENOENT;
+
 	if (size && kvm_granule_size(level) != size)
 		return -E2BIG;
 
@@ -1561,11 +1586,6 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	if (state != PKVM_PAGE_SHARED_BORROWED)
 		return -EPERM;
 
-	phys = kvm_pte_to_phys(pte);
-	ret = check_range_allowed_memory(phys, phys + size);
-	if (WARN_ON(ret))
-		return ret;
-
 	for_each_hyp_page(page, phys, size) {
 		if (get_host_state(page) != PKVM_PAGE_SHARED_OWNED)
 			return -EPERM;
@@ -1937,7 +1957,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.guest[1] = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_reclaim_page_guest, gfn + 1, vm);
+	assert_transition_res(0,	__pkvm_host_reclaim_page_guest, gfn + 1, 1, vm);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index b7ec535da86b..8f5d32cdb4eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -952,7 +952,7 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
 	unmap_donated_memory_noclear(addr, size);
 }
 
-int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
+int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn, u64 nr_pages)
 {
 	struct pkvm_hyp_vm *hyp_vm = get_pkvm_hyp_vm(handle);
 	int ret = -EINVAL;
@@ -961,7 +961,7 @@ int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
 		return ret;
 
 	if (hyp_vm->kvm.arch.pkvm.is_dying)
-		ret = __pkvm_host_reclaim_page_guest(gfn, hyp_vm);
+		ret = __pkvm_host_reclaim_page_guest(gfn, nr_pages, hyp_vm);
 
 	put_pkvm_hyp_vm(hyp_vm);
 	return ret;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 58d8474b563e..a9645480d164 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -373,7 +373,8 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 		struct page *page;
 
 		ret = kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest_page,
-					handle, mapping->gfn);
+					handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			continue;
 
-- 
2.55.0.508.g3f0d502094-goog

