Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652433;
	b=pQPYggGOum6QPPrRdKdd7ftj52nr2wGhOTkPqRwH/Q0TPduLCj4tBW/ILP8pUte+fjBI
	 sD7V7lhUmDzkZGa5QYMkKHdiw6pxyRpdkZ19EU77LAFq2S7z+JNV/dNo2hQ43zBRGo9Q2
	 Kca2Ct+2Y9b3vrZ5V2gXyzYGuTXQqQmeAGf4TJAflcOqFMr9LpMI7CXsty1El3Znj9jRs
	 ZXUpqfoFU7aOCC8hRPFVOOfk7iSopfLkAbusD0mrhGyZmlxPSDsZDE1977mU4llGbF76z
	 G2fhq/TIUGDnusIWqNHvhaQNe7H0n65MYJILoiscA7sbRqvM/jJTm2ocy/WmF5AGUSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=vlgGb3NCPXq2ZlUkr7hyLiq+gQOhP2pphbwlSrtaWes=;
	b=U+5JlOIgWvv47pDliK65F0O6Z+W4XgiARTGUJ+tWBYaqnAzGwrhPku7nW4bOQZHAE8RE
	 Rvaqz6pghEFRmqg+7EvgUCfp0Rhp2ZI99aGiid2xccxWphdfKYrlYhmi+99jy7S0e+Goe
	 lEopH56vsqLEBceDOpRQXt/bfzMw+HPzUfYryJy3G3ukPsLCqIepmsnuvwvKx5Ymxc4Ny
	 qp2cJUwEWy4pZLoTthXDqev3oTaab+UWyTR5111ccff6pws1+3XJsRN9E3/qheK/+wcft
	 9+ZVouFhuHVITPnpfhQ4YDHnGvN21wqyWCFp0Fvivn+zqWcbguKL2RHF2Hjf/Q/H6mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RlE3Y+KK;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FB7606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83FB7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RlE3Y+KK
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a17741243eso26252985e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652432; x=1794257232; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vlgGb3NCPXq2ZlUkr7hyLiq+gQOhP2pphbwlSrtaWes=;
        b=RlE3Y+KKGqJotSOTmLzS2SLjnBC4ku3YxjFBDRSQspf4i804tfa3eROBfDrP7JTaq/
         QvJR9WBPeOEz9U5+daG8HcWUZ9YKk31+tw0nxMD6R1/+SI3y6rCPGrzmOGS8RLaXadLJ
         Qt+wjhu0HVNxQQuFN3Z9fff2nDOmKdHSjGiwVWsJ//FG8BYYrU4Wo01WTemEKl3Xu8uI
         f2FGxaKYcCTif8eJzmqilJHrP+uGU5GllKX6yxCDzQuX9p95oXWFuNpX+RMbiDkfelpN
         FNAAOqq/ThOzKcGlYO1Cb7LM4N2GWuwuH5zcZ9wdpKTT2JGhZqLJ58igatJ2A8iR71A6
         DEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652432; x=1794257232;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vlgGb3NCPXq2ZlUkr7hyLiq+gQOhP2pphbwlSrtaWes=;
        b=R7Gty+1BqjvTdI6gPiFN863EdW0Eht5btXuVJKRXsdYglZMS5qO0c30jv+LfhRCVeM
         KPsldm+07WvpLqxKG/zkmYSQj4nuoPMH1PvOeN3tbI4IpXjJn/eoutFNWekA0jMwa2Pa
         c4h82Gp2hJrx6rXn7ilMPQo5LlAOLKx1s4Ja2FnMQ+RDYswHpVSnP4XMLahKwAbEB+Ec
         znZayw97/M8tk6Q+yACRhn+ZLk09EGzsvU7cG+89amL2paTZukrZ21TN6Vi7uzbz0OzD
         Cs+o7+JHrXAlhnXLm8dRH16zBA6a0/R2m5OVkiDvCk8Yfg5yhsE/xIuEVcqXcr8iWQMU
         UvvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwww49DOEgXQxwJCcC8Y/ao/Pbj/G/U+RDlQR+wO3gyloVbtJvPsRJs5WBROiWmmEW3axb6XEE=@lists.linux.dev
X-Gm-Message-State: AFq9FYIMsKHPfVKNEc1ClMQNWhZLm/ktzCn2BLiFiRSWZFNO1oJZTx+b
	l1CS+k+8ljca/WtXJXO4St5YqG9VK/bm77YogvFgLhy9PYh6zTzIOct56dOs8p1izP4osA+AdR1
	0yYW4IXKFLExzeRt4J7Gk3w==
X-Received: from wmbb24.prod.google.com ([2002:a05:600c:5898:b0:4a1:a7f8:c12f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a49:b0:4a1:dadf:9876 with SMTP id 5b1f17b1804b1-4ac180f1b83mr272692715e9.23.1793652431717;
 Mon, 02 Nov 2026 12:47:11 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:15 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-11-vdonnefort@google.com>
Subject: [PATCH v3 10/23] KVM: arm64: Add a range to __pkvm_host_reclaim_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
add a nr_pages argument to the __pkvm_host_reclaim_guest() hypercall.
This range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is
512 on a 4K-pages system).

Also, rename both the mem_protect function and the HVC to
__pkvm_host_reclaim_guest() as it can now operate on a range.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  2 +-
 arch/arm64/include/asm/kvm_hcall.h            |  4 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  8 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 58 +++++++++++--------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 +-
 arch/arm64/kvm/pkvm.c                         |  5 +-
 8 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ed7bd93aea1b..3efc63e1a823 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -116,7 +116,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_in_poison_fault,
 	__KVM_HOST_SMCCC_FUNC___pkvm_force_reclaim_guest_page,
-	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest_page,
+	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index c47ee2653110..201d58907109 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -244,8 +244,8 @@ DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vcpu,
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page,
 	phys_addr_t, phys)
-DECLARE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest_page,
-	pkvm_handle_t, handle, u64, gfn)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_start_teardown_vm,
 	pkvm_handle_t, handle)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b04cedaf4ec6..b05b0bcc3f2d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -42,7 +42,7 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu);
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
-int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
+int __pkvm_host_reclaim_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index aa5cf5568504..b79567a5fe44 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -111,7 +111,7 @@ void __pkvm_unreserve_vm(pkvm_handle_t handle);
 int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva);
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu);
 
-int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
+int __pkvm_reclaim_dying_guest(pkvm_handle_t handle, u64 gfn, u64 nr_pages);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 4f420718ca6a..2621a4ef7e1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1360,10 +1360,10 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page,
 	return __pkvm_host_force_reclaim_page_guest(phys);
 }
 
-DEFINE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest_page,
-	pkvm_handle_t, handle, u64, gfn)
+DEFINE_KVM_HOST_HCALL(int, __pkvm_reclaim_dying_guest,
+	pkvm_handle_t, handle, u64, gfn, u64, nr_pages)
 {
-	return __pkvm_reclaim_dying_guest_page(handle, gfn);
+	return __pkvm_reclaim_dying_guest(handle, gfn, nr_pages);
 }
 
 DEFINE_KVM_HOST_HCALL(int, __pkvm_start_teardown_vm,
@@ -1603,7 +1603,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_vcpu_in_poison_fault),
 	HANDLE_FUNC(__pkvm_force_reclaim_guest_page),
-	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
+	HANDLE_FUNC(__pkvm_reclaim_dying_guest),
 	HANDLE_FUNC(__pkvm_start_teardown_vm),
 	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index f2a9af6bda77..d5dcfbb59b7c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -921,7 +921,8 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
 	return check_page_state_range(&vm->pgt, addr, size, &d);
 }
 
-static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep, u64 *physp)
+static int __get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa,
+				 kvm_pte_t *ptep, u64 *physp, s8 *levelp)
 {
 	kvm_pte_t pte;
 	u64 phys;
@@ -935,20 +936,32 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
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
@@ -1031,7 +1044,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
+	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
 	if (ret)
 		goto unlock;
 
@@ -1063,7 +1076,7 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
+	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
 	if (ret)
 		goto unlock;
 
@@ -1369,7 +1382,7 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 
 	ipa = hyp_pfn_to_phys(gfn);
 	guest_lock_component(vm);
-	ret = get_valid_guest_pte(vm, ipa, &pte, &pa);
+	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &pa);
 	if (ret)
 		goto unlock_guest;
 
@@ -1397,35 +1410,40 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 	return ret;
 }
 
-int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+int __pkvm_host_reclaim_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
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
-		hyp_poison_range(phys, PAGE_SIZE);
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
@@ -1578,11 +1596,10 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	s8 level;
 	int ret;
 
-	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level, 0);
+	ret = __get_valid_guest_pte(vm, ipa, &pte, &phys, &level);
 	if (ret)
 		return ret;
-	if (!kvm_pte_valid(pte))
-		return -ENOENT;
+
 	if (size && kvm_granule_size(level) != size)
 		return -E2BIG;
 
@@ -1593,11 +1610,6 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
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
@@ -1969,7 +1981,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.guest[1] = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_reclaim_page_guest, gfn + 1, vm);
+	assert_transition_res(0,	__pkvm_host_reclaim_guest, gfn + 1, 1, vm);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ae34c09f1f39..2a73e63e8f81 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1042,7 +1042,7 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu)
 	return ret;
 }
 
-int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
+int __pkvm_reclaim_dying_guest(pkvm_handle_t handle, u64 gfn, u64 nr_pages)
 {
 	struct pkvm_hyp_vm *hyp_vm = get_pkvm_hyp_vm(handle);
 	int ret = -EINVAL;
@@ -1051,7 +1051,7 @@ int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
 		return ret;
 
 	if (hyp_vm->kvm.arch.pkvm.is_dying)
-		ret = __pkvm_host_reclaim_page_guest(gfn, hyp_vm);
+		ret = __pkvm_host_reclaim_guest(gfn, nr_pages, hyp_vm);
 
 	put_pkvm_hyp_vm(hyp_vm);
 	return ret;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d1acdca0254f..4c80e0960154 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -498,8 +498,9 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
 		struct page *page;
 
-		ret = kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest_page,
-					handle, mapping->gfn);
+		ret = kvm_call_hyp_nvhe(__pkvm_reclaim_dying_guest,
+					handle, mapping->gfn,
+					(u64)mapping->nr_pages);
 		if (WARN_ON(ret))
 			continue;
 
-- 
2.56.0.385.gac671c819a-goog

