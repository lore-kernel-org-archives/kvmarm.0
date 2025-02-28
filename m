Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B047261586
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740738367; cv=none; b=LaZHvFYqZOGiabXLQk4xNvoK2zbG4V9mSZ2twQA9whEvZFH10tQ+ZW5cWPvIN8zI702Aq9O97unu+nYkZsiE8mR4e5JAE/qqzLoB00LZjo3onltBw0BcGDhhBkVt/QUi4+emsh2NT0zg7iaO3TiJovx7156iTDjGRBYQfv8uWiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740738367; c=relaxed/simple;
	bh=c1CjUHd1LkuAdVuDk2RFGH/LeKa2cYSLQB9PFu9Lo1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IGNhOo0RGThqMhkTXoaP9G8yrNOTWRBoCF3IwZm9RKLVhNk1NRoXFTLR6eu859U4LK2ZyKfUmODcUb+U3cyj4/roOX62oMh4ECZAaaLduhK5hPawxK0eRIaA6xpF3G98zHBOyVOYhZWWSx5fiGFxsM6uFwF1AfH5opoo5VTW478=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ViQ+fZLB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ViQ+fZLB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43941ad86d4so10246105e9.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 02:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740738364; x=1741343164; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FJ8YKtq6hiI77A4ivZTnaB9Ne+xlMbNHdkfYD+3eEfk=;
        b=ViQ+fZLB4FkAbBS+modZjLpuo7F82+1SWC/uD2/xMn/Xaystx3Z2ovam2rV0Z8vd8P
         XNQ6SZZ8oKUNPA195JTgiSq9aABPuXIzNPEhsREhutJ9Locf9G/xaBchFZrRhxecCZTt
         dAz0jzbU3UyJvcPh8T+SYYlmxW4LkSsWoFmX55MuahCDd2LyHnG+/LQxcKBWRq+nQ6o7
         UV8+Ky8fTzv0eG65Su0Ut5S8cBONHabLpgRkBtO69so47cU/7rBI3+Nv5c4SZ9YhwVAF
         eNIHgpIQxZRAATB5NKb4oujWJkzM9Gzw7WXOKfgIGPCVh3vQoKwGUXX/Xz4g9Lqte/iW
         XrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740738364; x=1741343164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FJ8YKtq6hiI77A4ivZTnaB9Ne+xlMbNHdkfYD+3eEfk=;
        b=UKb7QrNnfW4/weocJKpjwi63kb9Qs/Chs0vGHe9CnDCyqcQMMuTpnJen196LT11mDX
         nSK5UQzCyaPVsa3mkxoG+hYPb6O4rqI2E+xuwLu94dia9ck2oLV4yvZhHv+4ilP8rp45
         r791fcCPyD2LBcVU/+rYme6ZxhddPLdki2m69umHLJlZrPzkF37ZVX597fa8XrHD81eR
         WJwLCJOSfBrmXQ/KYpETVO8QC5+sIHR+myOMsxDg62sdDKtWeHQ4LjAWzPvQ/dMFcvWJ
         j01kNOdWC49qYpC99xrQu7E82/wM0Kqazthfa66bIKlyfXFBeDe/159XheThJkVOFQu3
         d8mg==
X-Forwarded-Encrypted: i=1; AJvYcCV3xcUH5qIYyURBJhDgyLATrsz31RXpvy/uiszqlZplSLwXPYdwJZAurHFK3ysICtM9es3/jHk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdPzhuzsYG1p0jSlMbhR/bE6rAbXIGsYVp0Z4drnUUhpLN+EGb
	dzOnjg9eM08M9AL5FYZVA2LIx9k757gnwE0A8BBScoBL2t45F9NVx24jiZ2nPjE1fkzUpKXkOu9
	CAmIo6CItNDg8RT395Q==
X-Google-Smtp-Source: AGHT+IF7RliymnqyVqI2LxMXafp0QAO3saYMD0WdzwsnhK9hIXHApQBnwQLte7rc3DZHMIaauPQxquwj982tRnHP
X-Received: from wmbfm22.prod.google.com ([2002:a05:600c:c16:b0:439:5636:735f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5123:b0:439:9274:81d0 with SMTP id 5b1f17b1804b1-43ba66da2a9mr17359265e9.1.1740738364175;
 Fri, 28 Feb 2025 02:26:04 -0800 (PST)
Date: Fri, 28 Feb 2025 10:25:25 +0000
In-Reply-To: <20250228102530.1229089-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250228102530.1229089-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228102530.1229089-10-vdonnefort@google.com>
Subject: [PATCH 5/9] KVM: arm64: Add range to __pkvm_host_test_clear_young_guest()
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

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ad6131033114..0c88c92fc3a2 100644
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
index c273b9c46e11..25944d3f8203 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1110,17 +1110,21 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
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
index 3ea92bb79e8c..2eb1cc30124e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -434,7 +434,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   mkold);
+					   1, mkold);
 
 	return young;
 }
-- 
2.48.1.711.g2feabab25a-goog

