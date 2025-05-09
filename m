Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0435129551C
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 13:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746796643; cv=none; b=tufe6iNeqzuscWzhQRTfbb47viGz1lwJcNtOVhukdJyRzf+FAy+kjg6DzoO2U0C7Umt1SiHex2gKwRkyQJJlO45fZ1AH3s+06mD3DI66Q60nxe3nUvs9PMvQgMmV6Xlqt0tFE9FW15CsA5Qx6ZoNa3APD2CC0yUv0wqg83RXT5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746796643; c=relaxed/simple;
	bh=USNeLo6EV+eJ2K7Z7M9W89y3eGFJUG0YD1EYaPCtqwU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OkbSDmC+5Uy7URbdbCv0DXCtPdBwUNe6uqf/mZACdrBYLECeL4KcvCazYtbm5YJAUOrxUrmBi7nRvG1LXkkSK7LH+AonBZ3j0aJHBmCpRE9UNM2nQHyjTpFOJEcwrDlZ/lNfLQtcNUBjTW6+Zl5cwIPryQR9ou22mVgZb9vyVWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vj4PhzJ3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vj4PhzJ3"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so11569335e9.1
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 06:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746796640; x=1747401440; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNv3jLWaEgFEiziR7ZiOEPolrwSTO3G84RgE2yq1bP8=;
        b=Vj4PhzJ3ZJu2lnXK3jj2xuoRrY9OBbd72lYJi2i96mhaC7RJEt8Hmtb22+5pWDFcEx
         uzAoLFwuSgSSvKo4UXyhMhflKVCAuueuCAjBCRLVWhZvKGN6x+w5WgxnHUwYn1M6rTqV
         /ZSlLbF3DpQkYdHMd7+KFEnCobFz6Fj1D5Gl4QR313IC70ijuuy2QtMPoC+VpMWwHxSk
         Y3FPvO/eAxx9byr04C5ujEvv2SQds6EbN3KzeFtCkML2Tfi4CdEg6YkpCgG49VdLuIMr
         6LJGLxoR0FqnzAn9nX0K0TUDOe5YE34wVFPXeaaaFfiWWta9VCbv3/NKiwZTsH7fFTkI
         mthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746796640; x=1747401440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FNv3jLWaEgFEiziR7ZiOEPolrwSTO3G84RgE2yq1bP8=;
        b=r4daBs/Qcl16YfYkRumlVjHvMn4RRkJ7BIlMQQjHhPz8gHBiXfi+fid4JL9+TjkvlX
         cUtuCkgA8qPf1ed69pVknfhe7mif8C7yWzIXgHy/SKwRY3pdS+mjOqGSYaK0ik78MVE2
         Zv9lAikvtLrcAatp1guq00QVJP8sBBs/ac/kgpKDyESsPYkYAhEQspXAKhwyNvSTFc+u
         g2urP01jrAP7RsKtPjKUK5UfoX9MilUtOUfAviqjJ1k9HnKXuwioXPNk9E27GBOPHkJG
         rLaKkiyRZUf+cHTXmB6jnm6XQ1jUTmnLw3e3/hMLeQSyvnZjsnSmPAP5vCSP64x+N8JW
         hC3w==
X-Forwarded-Encrypted: i=1; AJvYcCVhD07WLvbkQGj/20pAJKIAELXCdKzU+HRUueUqDTOAtFJ5JU+Vi9cZ8pgj9AJvKXieYGbjZu4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSPx/sqmY5UI0iP15aIe4pcrAT8lQyfmuHNjV08H+32VNyzQDo
	w3qnnxdCgGZ+LB2oWoNlRD06CQOKAFEvsPHG4ejoIizNCZvtVQDf9RLW4V9t+0/nXTpixpfqcaZ
	dw+eWYRE5cVzu2+b6rg==
X-Google-Smtp-Source: AGHT+IFxD8fEjsE10nAGPXys8Wxu2K9BjiTRt3MeppsY7tB2Qo62VCHRwBX9+c9T0wwl3IksH2RkxteKkipKa6gd
X-Received: from wmbdr13.prod.google.com ([2002:a05:600c:608d:b0:441:b607:4ec0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:609a:b0:442:c98e:79ab with SMTP id 5b1f17b1804b1-442d6d37991mr30527015e9.9.1746796640453;
 Fri, 09 May 2025 06:17:20 -0700 (PDT)
Date: Fri,  9 May 2025 14:17:01 +0100
In-Reply-To: <20250509131706.2336138-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250509131706.2336138-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509131706.2336138-6-vdonnefort@google.com>
Subject: [PATCH v4 05/10] KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for np-guest. Add a
nr_pages argument to the __pkvm_host_wrprotect_guest hypercall. This
range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512
on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 19671edbe18f..64d4f3bf6269 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -43,8 +43,8 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
-int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
+int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5c03bd1db873..fa7e2421d359 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -310,6 +310,7 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -320,7 +321,7 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_wrprotect_guest(gfn, hyp_vm);
+	ret = __pkvm_host_wrprotect_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) = ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ae9a91a21a61..887848408e1b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1064,7 +1064,7 @@ int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 	return ret;
 }
 
-static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
+static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa, u64 size)
 {
 	u64 phys;
 	int ret;
@@ -1075,7 +1075,7 @@ static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa, PAGE_SIZE);
+	ret = __check_host_shared_guest(vm, &phys, ipa, size);
 
 	guest_unlock_component(vm);
 	host_unlock_component();
@@ -1095,7 +1095,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 	if (prot & ~KVM_PGTABLE_PROT_RWX)
 		return -EINVAL;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
 	guest_unlock_component(vm);
@@ -1103,17 +1103,21 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 	return ret;
 }
 
-int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 {
-	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 size, ipa = hyp_pfn_to_phys(gfn);
 	int ret;
 
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa);
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
+	assert_host_shared_guest(vm, ipa, size);
 	guest_lock_component(vm);
-	ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, PAGE_SIZE);
+	ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, size);
 	guest_unlock_component(vm);
 
 	return ret;
@@ -1127,7 +1131,7 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
 	guest_unlock_component(vm);
@@ -1143,7 +1147,7 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
 	guest_unlock_component(vm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index f77c5157a8d7..daab4a00790a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -390,7 +390,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, 1);
 		if (WARN_ON(ret))
 			break;
 	}
-- 
2.49.0.1015.ga840276032-goog

