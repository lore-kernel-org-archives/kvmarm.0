Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738B220AF62
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 11:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741258857; cv=none; b=C9XUz/wfWq1P250TxP6jnGqDS4Ao2B1AWfyA4RI1eTGC9E9ZfC3TAdsD7zLReDa4xoacfpViIz3kjcFyra+En+K5A7hFR01O1QG0PfFN3lXsztRLt7HKpF3nRgVhy8ayOuEnY6xpcgBw//uoFdxxeZ1zBhSvGVklsJMFwSysoQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741258857; c=relaxed/simple;
	bh=I0XY+A2V0Q5w7oHyDeXZMWplb/dvx/ssTKzTKtfDPnk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xg8sJxVDU46fS/dyaflJXv9+yQYDhzry/u9rxkg2nVG5atO7BQ0uiHNqNunT2EfgslMppDDQXuSQ56NpKVjE0zKYNClD/tMkwa56UjQsVZkFFboyrsU6wEGRXuCmdyTyhxzXQV4DSBGfu0tNkx+s8rQUi6lpExtUrSz0L7yQ48c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zBxc3lNK; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zBxc3lNK"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ab5baf62cso3551795e9.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 03:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741258854; x=1741863654; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7SUHezARLgNy4M/thAGHMxOGZWlACt+jxmQ+nWznSE4=;
        b=zBxc3lNKzJrKUAYlZfecUNpg3+yN8EY2axsQKrPDgwDOWXAzAAMqW2OSMgzKv6Tzyf
         atqWqr2WoUGdLJ6rojA86ccrV/iPn08+atxsgd7Qk6gEF95W0XNFYCcLc5EnmylKROzs
         dQeUdcfVgO6tSaEJ2nS39DFkZRC3wEf6jdFSsD1aqNxCXO+hgt8pbvxnfq6M0AviroXS
         KQ87AQPVvBlUpwSr4dS+AB15WThRWwGEjHYdC1TD7ufbDCYvMQ0eClhIEPCiR0ukmkvj
         51bKUg460/tN9zeXPYzzu0wrCrtz5GGLi5DbkK/hqjey12onnS+tv91QkhoA7BF1cZIr
         EBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741258854; x=1741863654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7SUHezARLgNy4M/thAGHMxOGZWlACt+jxmQ+nWznSE4=;
        b=bJDCkBXk+qfv6V0asY/SdRzKf9/hcX/3msjEaIIoZeJDPLx7KLlsE14eeNyiWLLnJO
         gFGPLikXmcUyOJFOmQcJGFg6hWWFFbSX7Owg21qhDJ0TX7y1WDQB3E7Mc9LHdiXPRLYE
         4mSIfoVCicvcyKpsXipm9RPqXAE1jCZfNyU3XCyqf8+sHOSyEcraJu07gfKu9CEeAPNB
         g31l42+JD+w8cTig3M2TMGBxfKNl1HfLnUqLdCgnlyb075xj/ZB5K3uw/jxcQ2n8HyPo
         SjFKQ0+MoLHpjvDKiOw0LM3yc0zJ0xymfGBhmLHSQ0CQa8vBqNCVWcUjlh0gz9OdTz2X
         dylA==
X-Forwarded-Encrypted: i=1; AJvYcCXvVTdkThsyeVhyTIT6LeUokO07EcqBQsaGS0tf87B5lBuOQ4R/MwyCA50UXHEDQh7g68i8TJ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YztBNL23h9vueMiR0ch2o+ND1ikte1yITE7fatM8qHbxVPOApDh
	yvJza92fFKmEvWuUT8q7Bv+zOM2OsNmh001lkfeKPD/uij10duytjJ/s3s/CGO5WSYTkCBk67a3
	M9V4aYwqpiybn9yTKRw==
X-Google-Smtp-Source: AGHT+IF6cBYpJoNeFh9z8abT4JT8Lu/iLr3ILSFRx27w0PV32EPVnLrrgtC4Mtm0Y1G3MzlzdEBEE6shWor6mMCw
X-Received: from wmqb9.prod.google.com ([2002:a05:600c:4e09:b0:43b:d42e:35b9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fd0:b0:439:6118:c188 with SMTP id 5b1f17b1804b1-43bd2adab55mr51000745e9.19.1741258853873;
 Thu, 06 Mar 2025 03:00:53 -0800 (PST)
Date: Thu,  6 Mar 2025 11:00:33 +0000
In-Reply-To: <20250306110038.3733649-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250306110038.3733649-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250306110038.3733649-5-vdonnefort@google.com>
Subject: [PATCH v2 4/9] KVM: arm64: Add a range to __pkvm_host_wrprotect_guest()
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
index 343569e4bdeb..ad6131033114 100644
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
index 7f22d104c1f1..e13771a67827 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -314,6 +314,7 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -324,7 +325,7 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_wrprotect_guest(gfn, hyp_vm);
+	ret = __pkvm_host_wrprotect_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) = ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7b9b112e3ebf..e113ece1b759 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1065,7 +1065,7 @@ int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 	return ret;
 }
 
-static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
+static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa, u64 size)
 {
 	u64 phys;
 	int ret;
@@ -1076,7 +1076,7 @@ static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa, PAGE_SIZE);
+	ret = __check_host_shared_guest(vm, &phys, ipa, size);
 
 	guest_unlock_component(vm);
 	host_unlock_component();
@@ -1096,7 +1096,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
 	if (prot & ~KVM_PGTABLE_PROT_RWX)
 		return -EINVAL;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
 	guest_unlock_component(vm);
@@ -1104,17 +1104,21 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
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
@@ -1128,7 +1132,7 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
 	guest_unlock_component(vm);
@@ -1144,7 +1148,7 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa);
+	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
 	guest_lock_component(vm);
 	kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
 	guest_unlock_component(vm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b65fcf245fc9..3ea92bb79e8c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -404,7 +404,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, 1);
 		if (WARN_ON(ret))
 			break;
 	}
-- 
2.48.1.711.g2feabab25a-goog

