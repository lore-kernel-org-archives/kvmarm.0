Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B081426B94A
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 12:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831872; cv=none; b=gQ5r1xhBQmilg+9fE9wRnI43DJ8jfc+rQLss6vu3KxvqRYINCg9G9OrANulVLgWDAGAwlAVRp4jvIOTRgZwfQSHKPJcAcWN6kqLJK9CUEXKbWeK199Wy53q3jkMQrDDKYE1RXDLRm9Jmc85e3FVvqXVpDZhYGNp34xjgqlB+uaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831872; c=relaxed/simple;
	bh=JaLT/KjNRBZh9+0850W3wd8IYoUjk5dJsmWjAJvso/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I39t03QUkpZgc+edzPIbJ/2H1tOgtAxRjDSlzWPr11qorDN5s/rPsHK0V6o7aLxybps074MxDp46OgZ8+KBZSi4srRQ77AQxaeiXOaXg9y8GAr2QA4z5p/17CssvCO+ZeSxlMIaSHKtCB9xJkS0HGIaxK5fzx3onvTdaJgdLEOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sdbg/bUn; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sdbg/bUn"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-441c122fa56so32535245e9.2
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747831869; x=1748436669; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7M7SlMUFeV39FEEkrPwE8OC1rT3wLxQcFUOhbBKeO9k=;
        b=sdbg/bUnwyx/v4V9IXDHHrK1p3sCD6eByQlXaNm7w3A4yZU2usy/C5n3+WFw0SexhB
         VUWQ/e5k30KKIhcyquxC6AZoFCwsHbLTDwN/uyoJ7AkQlh30EuF3unpjP2J5g/X/RQod
         C993MsSPOa/oc7WR/qZMIbmPw0SnuFoLQrd8Y01Ion0T+VjtAbvU1AIvuEqb7P/owlJS
         J0+Oofy2iz99Fy+EH6oTqc+a1hTp8S5hWabBCBm2pRsWVQn1Afg4Ug8RaSZ/O6mI/vCp
         mZy8HQKcPwpTl2FX3Cnm8OBA49kz5cGlrHMs8mgD3+twgaOpbbYxuiS2A5W7x7udiEce
         Murw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831869; x=1748436669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7M7SlMUFeV39FEEkrPwE8OC1rT3wLxQcFUOhbBKeO9k=;
        b=xHAO5Dn8UHpRuDEta2Usy25IkbkkTvHxUNHOfm5ukUo8knbaCi0crVmVPZFsAEr1iM
         3FUpSuBs8yV1lkd+PPlgoGcfPHmZZY9M2MXFkkTt0aqGJ7TwcX/nWoMJiuYbir9QjIDB
         5XRorCH2T2iZKX8cAawN4xC7WZjyRU+NTm+LGJffXWjM+8pENEesncdIwvF7+ylfkcS/
         D8i6r5LaZRyDu+RS9bNZVLez3IoULGyXWSEMGgFmnviok7pcv9T6KqTktD7TXZlsNrHs
         dS4eC9wdg8J4Lp12NCP1BckGu6ldAVV2q5PYywhOIJ6OSSVGr7HECY8xP9PM/keB1ZZZ
         tkWg==
X-Forwarded-Encrypted: i=1; AJvYcCWmJmW3y0KIL6VXGdRN84ket6YAWgkE9FXPX5WIJmkm36yH+ewmuPP0NuXNqF8Ua4+z2TGY3HI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDpwxamuKjmALVmK0rOkMsDVBpcaVjAi9fmzfyeCPNw07EiueI
	Uv0hSvCfFmasmAspg8qSw0Y7q/J5phXuFWi7jOIphVx4t0J6ez7ZusilV7UwBHSBaok4eFzX+9M
	lxSjYeTPvQihSRQXzA3Ubvg==
X-Google-Smtp-Source: AGHT+IGzvZe0qsIMITdMGvOXox9m77g+LizJVljcVxc1w9tT6r24QPzVy99fVozUqNSwp/zxZoBOGxUHRrMqjUb7
X-Received: from wrs19.prod.google.com ([2002:a05:6000:653:b0:3a3:678b:a096])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2903:b0:3a3:6e62:d8e8 with SMTP id ffacd0b85a97d-3a36e62db92mr11279266f8f.55.1747831869174;
 Wed, 21 May 2025 05:51:09 -0700 (PDT)
Date: Wed, 21 May 2025 13:48:27 +0100
In-Reply-To: <20250521124834.1070650-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250521124834.1070650-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250521124834.1070650-4-vdonnefort@google.com>
Subject: [PATCH v6 03/10] KVM: arm64: Add a range to __pkvm_host_share_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for np-guest. Add a
nr_pages argument to the __pkvm_host_share_guest hypercall. This range
supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512 on a
4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 26016eb9323f..47aa7b01114f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -39,7 +39,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
-int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
+int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 59db9606e6e1..4d3d215955c3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -245,7 +245,8 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
+	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
@@ -260,7 +261,7 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 	if (ret)
 		goto out;
 
-	ret = __pkvm_host_share_guest(pfn, gfn, hyp_vcpu, prot);
+	ret = __pkvm_host_share_guest(pfn, gfn, nr_pages, hyp_vcpu, prot);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 53bb029698c8..8051235ea194 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -695,10 +695,9 @@ static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
 	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
 }
 
-static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
+static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
 					  u64 size, enum pkvm_page_state state)
 {
-	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	struct check_walk_data d = {
 		.desired	= state,
 		.get_page_state	= guest_get_page_state,
@@ -907,48 +906,72 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
-int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
+static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *size)
+{
+	if (nr_pages == 1) {
+		*size = PAGE_SIZE;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 ipa = hyp_pfn_to_phys(gfn);
-	struct hyp_page *page;
+	u64 size;
 	int ret;
 
 	if (prot & ~KVM_PGTABLE_PROT_RWX)
 		return -EINVAL;
 
-	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
+	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
+	ret = check_range_allowed_memory(phys, phys + size);
 	if (ret)
 		return ret;
 
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __guest_check_page_state_range(vcpu, ipa, PAGE_SIZE, PKVM_NOPAGE);
+	ret = __guest_check_page_state_range(vm, ipa, size, PKVM_NOPAGE);
 	if (ret)
 		goto unlock;
 
-	page = hyp_phys_to_page(phys);
-	switch (get_host_state(page)) {
-	case PKVM_PAGE_OWNED:
-		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
-		break;
-	case PKVM_PAGE_SHARED_OWNED:
-		if (page->host_share_guest_count)
-			break;
-		/* Only host to np-guest multi-sharing is tolerated */
-		fallthrough;
-	default:
-		ret = -EPERM;
-		goto unlock;
+	for_each_hyp_page(page, phys, size) {
+		switch (get_host_state(page)) {
+		case PKVM_PAGE_OWNED:
+			continue;
+		case PKVM_PAGE_SHARED_OWNED:
+			if (page->host_share_guest_count == U32_MAX) {
+				ret = -EBUSY;
+				goto unlock;
+			}
+
+			/* Only host to np-guest multi-sharing is tolerated */
+			if (page->host_share_guest_count)
+				continue;
+
+			fallthrough;
+		default:
+			ret = -EPERM;
+			goto unlock;
+		}
 	}
 
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+	for_each_hyp_page(page, phys, size) {
+		set_host_state(page, PKVM_PAGE_SHARED_OWNED);
+		page->host_share_guest_count++;
+	}
+
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
 				       pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
-	page->host_share_guest_count++;
 
 unlock:
 	guest_unlock_component(vm);
@@ -1169,6 +1192,9 @@ static void assert_page_state(void)
 	struct pkvm_hyp_vcpu *vcpu = &selftest_vcpu;
 	u64 phys = hyp_virt_to_phys(virt);
 	u64 ipa[2] = { selftest_ipa(), selftest_ipa() + PAGE_SIZE };
+	struct pkvm_hyp_vm *vm;
+
+	vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 
 	host_lock_component();
 	WARN_ON(__host_check_page_state_range(phys, size, selftest_state.host));
@@ -1179,8 +1205,8 @@ static void assert_page_state(void)
 	hyp_unlock_component();
 
 	guest_lock_component(&selftest_vm);
-	WARN_ON(__guest_check_page_state_range(vcpu, ipa[0], size, selftest_state.guest[0]));
-	WARN_ON(__guest_check_page_state_range(vcpu, ipa[1], size, selftest_state.guest[1]));
+	WARN_ON(__guest_check_page_state_range(vm, ipa[0], size, selftest_state.guest[0]));
+	WARN_ON(__guest_check_page_state_range(vm, ipa[1], size, selftest_state.guest[1]));
 	guest_unlock_component(&selftest_vm);
 }
 
@@ -1218,7 +1244,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
@@ -1237,7 +1263,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
 
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
@@ -1249,7 +1275,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
 
 	hyp_unpin_shared_mem(virt, virt + size);
@@ -1268,7 +1294,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
@@ -1279,8 +1305,8 @@ void pkvm_ownership_selftest(void *base)
 
 	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
 	selftest_state.guest[0] = PKVM_PAGE_SHARED_BORROWED;
-	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, vcpu, prot);
+	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
@@ -1289,7 +1315,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.guest[1] = PKVM_PAGE_SHARED_BORROWED;
-	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn + 1, vcpu, prot);
+	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
 	WARN_ON(hyp_virt_to_page(virt)->host_share_guest_count != 2);
 
 	selftest_state.guest[0] = PKVM_NOPAGE;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 83a737484046..0285e2cd2e7f 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -347,7 +347,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, prot);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, 1, prot);
 	if (ret) {
 		/* Is the gfn already mapped due to a racing vCPU? */
 		if (ret == -EPERM)
-- 
2.49.0.1112.g889b7c5bd8-goog

