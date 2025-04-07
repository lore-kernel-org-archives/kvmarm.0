Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE922A7EC
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 08:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014463; cv=none; b=WG1/y/xJPmZBrN64w7dWXPysn+9idogJrCIQxLzfobZbA6wonpo1HhfqlTWdOGlujqFxy3yPvFX/0ObW/wtWMPwe++SL5kJ+QYFTMZgushTox1wzQ2gAqO/yU4w7Q+M04AHA70Md8ljSp0a91YBZK+g5WuDX0rFx/HfMyQL3Y8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014463; c=relaxed/simple;
	bh=xHvQY7fIwC1uiESQGah/s2aUhdT75s8bSAd/I+kPn68=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RTGODYMTU/1iK2mGhB5erkS4DNUBkLl+AUhbvA5M9HaQ7alKVv33gAV2Cxv7e5GB/kOe2g+JSARNIuHbf4LNVYGzZngj6o7cmMkUx0+tZBWJ1lQFigaZssNB3Vr3HrSjcqNq5gRHJcPvMAQD/D79pkeHlJEhZXwxf/W3Js/yBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gVecgX7I; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gVecgX7I"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d5ca7c86aso27131555e9.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 01:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744014460; x=1744619260; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PlP5tMdol9JVYvP3tzbTEpu6iNcDZijUZqqFs+uoGXU=;
        b=gVecgX7I9ufig8F1Qsw3Yc+5g+z9JdZfJ4P+LTRSH9SWkQtZ9KWWusn9hsVedPDNKf
         cTOeq+Fi4Yr22pbN0DletHcgZT1HnzhqkXY15ol4Sk4gIbk/O/AM270N5Ns4yF5w8MUL
         jdrgQCOxS051S1hK5zfGGnzWYQCrFWdglmtJq9Jaoc8rrjtTMtR1bm8JasVbhCCahT4i
         RDqslAlR11TWWM7M+5PPYBv06QuraCjRGYmM4MHoK0JtuEyHHnZi2J/7lb5BPqZQGHlo
         l4GlLnGd1G2ll+U6wL7ZP87EyWzNVNIg3xWde6xDRIqUYvzPgt7oGxxz/GYbW0c2XeiO
         nU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014460; x=1744619260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlP5tMdol9JVYvP3tzbTEpu6iNcDZijUZqqFs+uoGXU=;
        b=YCYuPVQI7bd6gxfjCs5I9yaSz325Ftjnww/rywg8MWNDkkj/E3ZADsuyve5RUS6Smr
         M9EIS7FUXF+E/L2Qw881Pw3g4k45faFSEFAqhIOUXgxFBr8Qz1ZIHCu/5fWr+/vDsXeQ
         6KeBcVX9XHpks64wqkwDaj+RgpflSGHXwlxJCx65O/0tonRkOT+c7u/aKSan/6WtLmfx
         ND3quPUNgxJfZ2Ner1ZybwCgz2c0U4sReIHU/AgsOlohm33I1CB6N2UgdQxA1iQFRD18
         J79m0SoCz4DQK71/H1JXkCBEPDnwRH8SWCflaabErIs4cPJ5/M9GJe3dmQNVROpaycXq
         7BJg==
X-Forwarded-Encrypted: i=1; AJvYcCWrk388rHSKEH6rCwFtEU8huq59Z33nOIg4tbO1TxDMB5RNJEGyqKdiuG3VO85ipOqH43yzTOE=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywjzh4n9NwLMifa4603A8W01K5W5Ht73JDtGIfwpAGi0tRxWrAA
	wK/R5ynU/ixjv2SbLd7tviBNFg3q52h45sUIZLpjp/W4Hn5bUKSCTeZ61EbO+sw9RsTYvr0DkX9
	AmXhbtnzBFPg1G7mVQQ==
X-Google-Smtp-Source: AGHT+IF1riN2k2nWQ8sgip2B+3pFFoE6XJaoBxY3J2Xr5NYz4pbZRp/K7q/190A9Us4CNkYkJWM9DqTRoGRoo0Cj
X-Received: from wmcq28.prod.google.com ([2002:a05:600c:c11c:b0:43b:c336:7b29])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4443:b0:43c:fa24:8721 with SMTP id 5b1f17b1804b1-43ecf8d1b10mr116267015e9.17.1744014460436;
 Mon, 07 Apr 2025 01:27:40 -0700 (PDT)
Date: Mon,  7 Apr 2025 09:27:02 +0100
In-Reply-To: <20250407082706.1239603-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250407082706.1239603-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250407082706.1239603-6-vdonnefort@google.com>
Subject: [PATCH v3 5/9] KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for np-guest. Add a
nr_pages argument to the __pkvm_host_test_clear_young_guest hypercall.
This range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is
512 on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 3393a8ecf243..4404afb7ea2e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -43,8 +43,8 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
-int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e13771a67827..a6353aacc36c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -335,7 +335,8 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(bool, mkold, host_ctxt, 3);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
+	DECLARE_REG(bool, mkold, host_ctxt, 4);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -346,7 +347,7 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
+	ret = __pkvm_host_test_clear_young_guest(gfn, nr_pages, mkold, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) = ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 9929fd7e729b..ad14b79a32e2 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1112,17 +1112,21 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 	return ret;
 }
 
-int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm)
+int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm)
 {
-	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 size, ipa = hyp_pfn_to_phys(gfn);
 	int ret;
 
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
+	assert_host_shared_guest(vm, ipa, size);
 	guest_lock_component(vm);
-	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
+	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, size, mkold);
 	guest_unlock_component(vm);
 
 	return ret;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 1483136df01f..419902faaf69 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -437,7 +437,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   mkold);
+					   1, mkold);
 
 	return young;
 }
-- 
2.49.0.504.g3bcea36a83-goog

