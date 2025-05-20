Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF912673B5
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731193; cv=none; b=Rb3TWNnid5DFbRbOGmL0ssah7KZMB9EYmW4E8ziOnIhDJFGNBCO+iZ2iqdWHNBCDiClxOt41FijSkcAqfyIITLBMQGF2j/p/c0Slq8bPZ0xtcFDweXOlm5pCwe/DFtqLodq+g0NgiFd5raFqnhDFgrR8eIHSUWJRpd+tzIFHSSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731193; c=relaxed/simple;
	bh=MzWQxr2iFwwyue/2v5SvXZNmjJYvK9Wh0QbtpsrDtC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GUZaHXOx/kH9UjmLCI3f4qVGkj4N/Gc3nkzfWWV0Ks3IfqO2NZISOfhqpwNMZFJJUq7qGKsNftom21dEZxT6lsmLEQ3LDKuMGlxfOrhYF2Cl54iIcMkD1ud01/iHPsUljCbD0rU4CqTAg1VmhzV+hOaVDIDGI7Tt+PUTuO3prYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qISbdS4D; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qISbdS4D"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so35416505e9.1
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731189; x=1748335989; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OegFB2xZXjNRTpgqJuU8fAt2lqPaGMfs1sk3PznjF78=;
        b=qISbdS4DA03PEYKsx9IGfNb/beMsAuYPBvYaBz7vWxSJe4pzII9u5ty/46y+XJgiWn
         VqEFLa8+XAxVfSTDf+g87WolgcsXZGbvK699k5AkJVP0Ej+VmEtWlK+eF0ITbxnpL8qT
         1mGXQMxD3ghRCZ4SsHRzmNPVzUBF6lvioUew0ZcNjd/LvR+0EGHOD1cB+8wDkQLyQt4i
         Vxr0ijZrAe0fYssyzg2gaBaukla7XfHRpua3twG0etICscC4FLLuAj8eWvUZdwXw3lUl
         l9K0LjaiDjBeGGhb9xqYPybys8y1c70nICIHEeQx/mHOu/qZ65kn8WCa0oG95DlcwlOb
         au1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731189; x=1748335989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OegFB2xZXjNRTpgqJuU8fAt2lqPaGMfs1sk3PznjF78=;
        b=sWsVv3hTHoQdihqBrSaBQK5acTVrgkhOazpZGQpAg4Vsr3rqe3sWmMoMpHpk8pfOx9
         ayWxXNSetkbChfwmAGjD2U8cjggWPOmNYkgVHwUygh7vq3mwwWyCx+wfIKm1MCG5xWcQ
         71n73w+HMl4mmxE9ipD1v765QvaBokSsvR0oTIJZwkhYys9NpP6vZX/6y73fIGWtg0e+
         q7zGH9qbRSBwhjGXMJrjlBnJvi5JWcrVhSRCMUhByGQl3iUQsm22zS73KGTxoAxg+y+j
         IzAfDycqXPSFlaClTwF5r7uXitoWaiT7mXMTX+VHEuI0AQxOu9YJFbrM/W7IdMS4CQA7
         7cdg==
X-Forwarded-Encrypted: i=1; AJvYcCXeKlUIuiMOwigYd53ahiqYnjS47hrCJM+uJUCL1OCd3i5AC9MRe508bbKdLwhu2m+oApZw7dE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbGS1Al66XgrKqMSrCSdLPCYkq11NuKu6NrR3Yh3mL0VmCVsiF
	r7d5MYO6XnCIp+/guDO0Ih3R/kcxbs8t7MefNT3k+sD9+HZH/m9pLBGuKwrWSdO8LNQETBAvMED
	Elrw5pl9KlVTOvQ8glYcnGQ==
X-Google-Smtp-Source: AGHT+IGQHeSBunGL47W5QD9E9xMgLZTOeuSsbb54RHxgkrHxgCbNat3eBa4S5Z5uYiT9jJa6EmhQXbPkxTpqYWjr
X-Received: from wmbfm26.prod.google.com ([2002:a05:600c:c1a:b0:442:f8e9:a2ac])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f42:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-442fd60cb7bmr141176955e9.5.1747731189303;
 Tue, 20 May 2025 01:53:09 -0700 (PDT)
Date: Tue, 20 May 2025 09:51:56 +0100
In-Reply-To: <20250520085201.3059786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520085201.3059786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-6-vdonnefort@google.com>
Subject: [PATCH v5 05/10] KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
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
index 884e2316aa48..a6c45202aa85 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1052,7 +1052,7 @@ int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 	return ret;
 }
 
-static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
+static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa, u64 size)
 {
 	u64 phys;
 	int ret;
@@ -1063,7 +1063,7 @@ static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa, PAGE_SIZE);
+	ret = __check_host_shared_guest(vm, &phys, ipa, size);
 
 	guest_unlock_component(vm);
 	host_unlock_component();
@@ -1083,7 +1083,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 	if (prot & ~KVM_PGTABLE_PROT_RWX)
 		return -EINVAL;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
 	guest_unlock_component(vm);
@@ -1091,17 +1091,21 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
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
@@ -1115,7 +1119,7 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
 	guest_unlock_component(vm);
@@ -1131,7 +1135,7 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
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
2.49.0.1143.g0be31eac6b-goog

