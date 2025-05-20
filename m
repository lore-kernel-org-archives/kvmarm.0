Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA6E267B13
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731194; cv=none; b=je3O6K01nrgXwKEoUVDtMgl7KYRNfkdEkZ+ATHy0Fr8n062WO0cyasouHLWI7m6+fIs8pl4FE4kuIRf4ZAOWW07yTmv/AJ1YPboQEbmJzfiJjjFntysa2TsefihZUTWv7QZFiw8VWDCke/rOb0IYh7i02kih6Bc61fIUl7WXQAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731194; c=relaxed/simple;
	bh=Zf1tm63k5slx8xvKAWQSF/+vFTcVGSo/FoXjgAb4LcM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NMyEJ1QnZNb6A8ybUKuWPQXr973L+B6PJYA8koRgf66lHFc5yqiksawXiK3cYNSDxfBu1sOYYQMpgGGgHjeXQlThYHxzDpMjnrSdg4Fa+nNt8Xk5NjF5uZJnGMK/WEZnu9Xr3Hcj1SDx9hDf5EfBlwj//PNO2vI57nelxEjyivI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1P2rB3XJ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1P2rB3XJ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so37844635e9.2
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731191; x=1748335991; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U1sUrkER67WLT4JN0Ut8NvS0zcoI4PCXbQaK2Om0Kxk=;
        b=1P2rB3XJMomsCVofu30g4IvYAZRMdJ+6Uve5DbScQDXYEe82KKVKZ5knvWydT/ZVu6
         pN+0fPm2HHK83cnkvrC/v0aN7ahJBk7jhAUrjxC9XDhtb1kWgQ4XuowLbhHpOuukoqlO
         QNgRE+wKvB6JOHDDOHUx1rUjHMiHUYk6LZy7Lv3T9NImYMOIYqdnWFO126A5KrUf+SR2
         8gtNybAAxwhw65+oKx4uuSBQ6wsvqVjM4c/IWsQxxL2480VOWwgonq4IdkAptSso5rGA
         Y9R3YH4JElLJeCtStJyGQLyWrOfIidBVamRdFQbzXIj2VcMngv19d2GF+Sy8t4m+4hsQ
         nbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731191; x=1748335991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U1sUrkER67WLT4JN0Ut8NvS0zcoI4PCXbQaK2Om0Kxk=;
        b=rAjSpaqmlJn9Lkg5vJnnqQNz/wLnbMPIKw8u+8ogWVWJ/YJn4D04E/ij+5aMvGRoS5
         i0AXyRdvuAsEDBGNctib653KkvYzjLxAJYIuWn0CVVlZkuJ0wSSRlnRD/44YCX6MTfDi
         5QbMd6TzxdNhEnYFMsON4OHNzFg1DxsuOLv2eH1r7DvJC8kI4MUls7cC9j+Q0Joj1qU5
         VDOxHMJs9lmR53+aitw7bp9KhDm7XKh2vr6EupZaQVOV7N4uyzxYvtD+xV/62CYazfMY
         gs/bjLufGWP67LL9ENUweXlqsNZVYTUgAGR0qe1BX5shetWRz1/TZLJAnUAWqcazQsoD
         o8MA==
X-Forwarded-Encrypted: i=1; AJvYcCVBl8g26Yw++M41W8wqmQ0H7qdNwKnwDsvorDQx9cxrWG4uHZpVKNeswavCg3CwxQ5V7doUU+I=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmKG0PCEWdVJNHUOEFvz56Supg2tZU/yjWCJsRiYn6yuS0IoNo
	FV69Zdi2aeU6YUefLy7nIO0qLxfIv+rXB6K+l7fGTfJYqzotIrODI2IujfTPns+ivG86M74U4OV
	FuHa2He4oAMiMmDS3yR5YZQ==
X-Google-Smtp-Source: AGHT+IENthKzsKHv/HWcWQeB37Nikyn/qGeaUXDh4XyhJ9RJ8A2GBmHwwF7MrDhhpwbzghTBNva0zDUScLc85koj
X-Received: from wmbej13.prod.google.com ([2002:a05:600c:3e8d:b0:440:673c:ce2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5008:b0:43c:ef55:f1e8 with SMTP id 5b1f17b1804b1-442fd622ce5mr160161355e9.13.1747731191322;
 Tue, 20 May 2025 01:53:11 -0700 (PDT)
Date: Tue, 20 May 2025 09:51:57 +0100
In-Reply-To: <20250520085201.3059786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520085201.3059786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-7-vdonnefort@google.com>
Subject: [PATCH v5 06/10] KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
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
index a6c45202aa85..5a7a38c5d67c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1111,17 +1111,21 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
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
2.49.0.1143.g0be31eac6b-goog

