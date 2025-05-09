Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224D4291874
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746796645; cv=none; b=nqU7KRilVrJI3PJRiA7TbSKe8A6StyjgT5fHEa9moCTfOoANOtJ6GsMoobVVo1d3nWqh2DXTCWicqtciKs/2X0ifUZCp3GmdW/Y4jZxuQs2a/iKsiImbp9dcW9zpY0iowEgJ/oNG0STXsKkiHM4xRG0HR7351BVi0Qy4r1XAq0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746796645; c=relaxed/simple;
	bh=0dN7xNkWVVcK8u32o4MK+QgSiql5mKiL3ICUdzvqXsc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OoKTl/NJVpfKYrAelsG+qaUbONmbAnUrhysWxjx+OgO5nRemW3tt/y6ltL94FFk0k3f9yMOHLM6CM/bGi8cg2YD6Phlf5vIt1NSL0hdKY45YHITieKiLqX4JfQWyYRs/aSuNzzHMZ5NZlt7EO8RFEvB75SNyCbp3Xihj0DbvszQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bzL+uObu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bzL+uObu"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-440a4e2bad7so13480395e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 06:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746796642; x=1747401442; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sJXlEdEAMlkb2qBBm9toZJ5sXPbHKi+X7VZ3IC/AQeA=;
        b=bzL+uObuyFsgRa2jNrUhm1/2PWt/S7aa8Fr7bfStqlbFqBAxHgLwMJJb6ea/R5E9HI
         osiqlRMfZKLjFpXw+QmKvWOLBIuTVF+oE/FMq75v2NAfWI0noPOyOSJyAHDiN+nU7B5F
         Be3Bm3yD1p3afwtz32v/hXayrmo642YjDSwaADDFAQHif+pivqCTGaHeOZFQ3zYr1xBW
         6h76+Jeu3634WfJaxs65yGoHAn8cfBhGTj6V4+EAFU8ipnDsbQPZgf9FSBfwaqJzE/GV
         Fj8BRHk2648Ruf0vl47ylQyGMocU80X1LpckRnFlmtnozgozoiCq8kSI2qoGaCDJ3eQi
         KXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746796642; x=1747401442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sJXlEdEAMlkb2qBBm9toZJ5sXPbHKi+X7VZ3IC/AQeA=;
        b=YB2O11cOOw40J5UPm192RnDX16ciH0CYrpdzJGqOQ8P6V9RncpPxW+A5bzoT4kRwWT
         pjUFiUaBIb07+ItJjWFD/F+qv+7arP3OBHRGdkdgzxdsjGk+lpGQqjP7pTU/PbHKfCfo
         j2jVLIciXEHwrE21pVgI4NEDeUZy0dmaWuZR7ZkajRR6aSlKBKxiUfyb5zY309ZZdguG
         wSI4viEWbVCqxEh5hAPJqftyZu5CnIO0DybnV6W5jzNGKeyx2MZ/pGKI/P4wdXSsI2tF
         cyYfmZe95ram6coOF+cmNoiQ8yQM1GDXOJzi9GUgdjf2B4VdT+1rRShbcNWecDnvH7Gm
         6MtA==
X-Forwarded-Encrypted: i=1; AJvYcCW8gHdpu4DZOGb6xUiBWg9v3p3NK36DsCNbeGow6KHKA96lVxCF1j/xFyHkn02CHl/TObUHJF0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxxYa33BePECBerNgkJYNCCIn1HPduXYV6cUrGcVzTJDARBXOa
	z/sSWTcgwZjvNXRio9E5dva90n84/9gloF5qFq2fV19vYSAr9C/04BfBDSelKxLwqVQysFCxsfK
	Qb/gfxPF9kNeEbsfgXw==
X-Google-Smtp-Source: AGHT+IGHjgfBBQziUExP1MPI5PB38ZTGtxeEqo5dEeOPRz5XOW0PWp3aLbHOfSRkKDKmFhtCkoq6HHA3Mb4iDMfv
X-Received: from wmbdr16.prod.google.com ([2002:a05:600c:6090:b0:43d:4ba5:b5d6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8716:b0:441:b3eb:570c with SMTP id 5b1f17b1804b1-442d6d9c266mr30919685e9.6.1746796642493;
 Fri, 09 May 2025 06:17:22 -0700 (PDT)
Date: Fri,  9 May 2025 14:17:02 +0100
In-Reply-To: <20250509131706.2336138-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250509131706.2336138-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509131706.2336138-7-vdonnefort@google.com>
Subject: [PATCH v4 06/10] KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
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
index 64d4f3bf6269..5f9d56754e39 100644
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
index fa7e2421d359..8e8848de4d47 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -331,7 +331,8 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(bool, mkold, host_ctxt, 3);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
+	DECLARE_REG(bool, mkold, host_ctxt, 4);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -342,7 +343,7 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
+	ret = __pkvm_host_test_clear_young_guest(gfn, nr_pages, mkold, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) = ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 887848408e1b..78fb9cea2034 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1123,17 +1123,21 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
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
index daab4a00790a..057874bbe3e1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -420,7 +420,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   mkold);
+					   1, mkold);
 
 	return young;
 }
-- 
2.49.0.1015.ga840276032-goog

