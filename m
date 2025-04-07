Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46347228C99
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014458; cv=none; b=lVvqpke3VS2gn1anKOendzLoLiR8xoLOGHKnaN0UVnFNCvs3QqjvZe4GtfeYeRBKA/5xd9omhyjy2+YTuRYGoBlS4/cAeU+p2eX4PQyfXfdqVMhvuaI5PLq5T2gFV2DrPAxKmCilVmeu5PKRpvaxtHjZIFgTjIc1bSNL/yQVLl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014458; c=relaxed/simple;
	bh=z9y0JvWnvG1kJ8p0FisHSHc8Cv5tzDVY6Rw1WnudYvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F41G5v47Rj5uMYOff5ODdufLz18iLKXZMXf6cWLM8/s+F4ztYv7T//Noc8ZZxy/CCtVjo2yU5kco7SfKDXmO8Vbsa/+pfCLhRxUHrsdfIFqEE+s0CSQZK0ynYhuMhg87dxbnqc8fhvEp0TU0Mu45Wpd98PRkLDWuwsw/hlBsOuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1QeMTJcD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1QeMTJcD"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so27057165e9.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 01:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744014454; x=1744619254; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FdIqQbEGrH6LJCk5IMP3fGkEsrPpiEvGrmtBvupTZLs=;
        b=1QeMTJcDX8hh2k2hqGoG1JpVzB14i9WI/aewwEDOSNO9HDmYNxrWn1oxwL155KjeUB
         MVWlfg/ieIL9Z8kLbEKoSO/byx7XWcLegE5gEvoV2d0NRLhKAzreOvA1o6AvsLamq2oc
         u8r266cuQ2IeqZeHgJWkY42OjKNBgGApN61OMhoA+Pxft6qb3ivlU1hEvFaX7dwEl5wt
         SKuQJpWGnktyuhOiY2NbuHDTuPb6+zly6riJpOtSMEvWdrg3i3Xnm/QyUBc9s0SsrNiD
         i6/YjcnVY6itckQ8NRcryAcdywbmHNGtY4E99i7RMq+wAUxrLByTz5suxxC9XWnR+C64
         3PMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014454; x=1744619254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FdIqQbEGrH6LJCk5IMP3fGkEsrPpiEvGrmtBvupTZLs=;
        b=pdsTD/DEBO8ldndXPMf2dAwaS2nzL5oc0jQyA+t6cserDmAYREDSZeqtuk9xti4ZUd
         cBt1jZ1kw5NlssfopfMyoBQF3RSig9FpyQAoYAbnVBtaSZU/0Mo1mcBpiA1zmkSbIknT
         5pFzFOvrCk7D2k9IxGDXbW2wT4wtArH9a6eAkRAJ6Mu5DwW5TLvZ9pvS5UXrZajvDEU7
         UJVSbAj/IHRKeB78DxCpsGTMfj6Zwt/WttjH4RAD6v2r8dGUD1M75T7M7xiZ36yEH9a7
         BmyeMoAtdBmkF9fxK+iSk/GWRPFwsBEoLMsNLPIyP+PpVHpKZRybUPcIhcbD5va54gpl
         BP6w==
X-Forwarded-Encrypted: i=1; AJvYcCW3QfNF0xQbBkPBnwvDn2DvE+gQMaB6otoE8wYUlZobKfYxSfxXjaqvrOPMzQEJyAMqctfetD0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjfT9amFxsGZQSslVLCK2cyY1cAZPHnrODDbrLbQPSYEqJJ4I9
	DibpHw4FFmVQneF77+3s95S3glAw68mTDxDGUY7x0uZVFjVvCGDDZq3oGbbwSS4J43OBn1TgGGj
	gdT7lbxw2XZUYSTD//g==
X-Google-Smtp-Source: AGHT+IHsGgikQanBubWw9n3TBOvtvQ0/2An9oSz0STzP+avD7elmsw808grIhtyKdtPWcqWYMd99e7w8hY/KmQYG
X-Received: from wmcq3.prod.google.com ([2002:a05:600c:c103:b0:43d:41a2:b768])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e23:b0:43d:8ea:8d80 with SMTP id 5b1f17b1804b1-43ecf81b197mr105228475e9.5.1744014454734;
 Mon, 07 Apr 2025 01:27:34 -0700 (PDT)
Date: Mon,  7 Apr 2025 09:26:59 +0100
In-Reply-To: <20250407082706.1239603-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250407082706.1239603-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250407082706.1239603-3-vdonnefort@google.com>
Subject: [PATCH v3 2/9] KVM: arm64: Add a range to __pkvm_host_share_guest()
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
index ea0a704da9b8..96f673f42e8e 100644
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
index 2c37680d954c..e71601746935 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -249,7 +249,8 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
+	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
@@ -264,7 +265,7 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 	if (ret)
 		goto out;
 
-	ret = __pkvm_host_share_guest(pfn, gfn, hyp_vcpu, prot);
+	ret = __pkvm_host_share_guest(pfn, gfn, nr_pages, hyp_vcpu, prot);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 6a90e7687f1f..48bc0370515f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -60,6 +60,9 @@ static void hyp_unlock_component(void)
 	hyp_spin_unlock(&pkvm_pgd_lock);
 }
 
+#define for_each_hyp_page(start, size, page)	\
+	for (page = hyp_phys_to_page(start); page < hyp_phys_to_page((start) + (size)); page++)
+
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
@@ -507,10 +510,10 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
 
 static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
 {
-	phys_addr_t end = addr + size;
+	struct hyp_page *page;
 
-	for (; addr < end; addr += PAGE_SIZE)
-		hyp_phys_to_page(addr)->host_state = state;
+	for_each_hyp_page(addr, size, page)
+		page->host_state = state;
 }
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
@@ -625,16 +628,16 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
 static int __host_check_page_state_range(u64 addr, u64 size,
 					 enum pkvm_page_state state)
 {
-	u64 end = addr + size;
+	struct hyp_page *page;
 	int ret;
 
-	ret = check_range_allowed_memory(addr, end);
+	ret = check_range_allowed_memory(addr, addr + size);
 	if (ret)
 		return ret;
 
 	hyp_assert_lock_held(&host_mmu.lock);
-	for (; addr < end; addr += PAGE_SIZE) {
-		if (hyp_phys_to_page(addr)->host_state != state)
+	for_each_hyp_page(addr, size, page) {
+		if (page->host_state != state)
 			return -EPERM;
 	}
 
@@ -684,10 +687,9 @@ static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
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
@@ -894,49 +896,81 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
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
+	/* We solely support PMD_SIZE huge-pages */
+	if (nr_pages != (1 << (PMD_SHIFT - PAGE_SHIFT)))
+		return -EINVAL;
+
+	if (!IS_ALIGNED(phys | ipa, PMD_SIZE))
+		return -EINVAL;
+
+	*size = PMD_SIZE;
+	return 0;
+}
+
+int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 ipa = hyp_pfn_to_phys(gfn);
 	struct hyp_page *page;
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
-	switch (page->host_state) {
-	case PKVM_PAGE_OWNED:
-		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
-		break;
-	case PKVM_PAGE_SHARED_OWNED:
-		if (page->host_share_guest_count)
-			break;
-		/* Only host to np-guest multi-sharing is tolerated */
-		WARN_ON(1);
-		fallthrough;
-	default:
-		ret = -EPERM;
-		goto unlock;
+	for_each_hyp_page(phys, size, page) {
+		switch (page->host_state) {
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
+	}
+
+	for_each_hyp_page(phys, size, page) {
+		page->host_state = PKVM_PAGE_SHARED_OWNED;
+		page->host_share_guest_count++;
 	}
 
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
 				       pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
-	page->host_share_guest_count++;
 
 unlock:
 	guest_unlock_component(vm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 0f89157d31fd..cad25357858f 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -364,7 +364,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, prot);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, 1, prot);
 	if (ret) {
 		/* Is the gfn already mapped due to a racing vCPU? */
 		if (ret == -EPERM)
-- 
2.49.0.504.g3bcea36a83-goog

