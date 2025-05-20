Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD17F2673B5
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731190; cv=none; b=G+HoiW+znOiVXBDRUBbbDS6vTyOVh28QSlMStjSND6+V3E1jdd6l8AhNRQmWhmBQ2wbmICAbBSS8Qbm8WbGCPOdU6MncIePdHooJxCDcXTW7uSBZZa9T5qQMS4NmA8AXVqwJC5OkUmYQCETcsleaZ87LrviM/HvrrOW9CkviQiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731190; c=relaxed/simple;
	bh=VTZws/rr3NWkVDECjiFo3Socp4fltMh839a6raPpmE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kqQ73k+w2ZKl4AsKwmyrOggZEyqOd35fzhUzqDPigOVMEpucL+bgFul/Ai1LbKOEIzCDOXgA6ztm4NXk4lSOMdy238ZqUYtQ9gCWQepdOPPeLAzF6wkB3HznJ+mX4CB8W/5h1AcgClahtzxGeq+Q/kDI90YZYlAt+dDrmhoGeC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v4yMufhS; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v4yMufhS"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-442f4a3851fso46571755e9.1
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731187; x=1748335987; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0qnoZeCyJg3ALVmFHMjFJfi4uCu0wBz7RX/Yio9mY38=;
        b=v4yMufhS8eSllcKvyBqeMH3Gy5acZsyQnwz5VcSurv+be5HowUImnRN8HW/34XiLnr
         IjxlWkOvXrYRC8lHhbKX/WpbyZMfcL7s6SVhc1qODtr6DU9qYNggQ+2OROps0Ox1g9ug
         qX1xnlN+nRyydSCLTaQJarIoDOLBdGg7DtiffuaD26yX/7AaYu+vZjluo1E8nKhkM285
         wJFLvqXvEs2oEizZDfRJKk7ybqh2oV1ewo3DzOkvmE4zij5Eo6QqK9HeWuhZMqsBfW4p
         Ad6c2r4re/MoCRHZxf7o++H4Qqa4ZAy5qCr9PR/ksmF7NMQh6fCTFBCmUl1JPhcboz6S
         ZVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731187; x=1748335987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0qnoZeCyJg3ALVmFHMjFJfi4uCu0wBz7RX/Yio9mY38=;
        b=NzKh8k7AfCTZ+W246rHoGhHgC98WxKB+IJblWt06vpObe0k3/1HREcDiDfkrY1ldh2
         dnkcZfkZXJjs/Fbqcs7BmaFwgvWRM1dQZLeQ4DbfigjeCajI2nEN4U7ztsfmMOKyMS3Y
         JyS657Nxlq6yhW5a9fk0fTUoj/y8v7INS+1ZRXiqSZT3FhVZAhSL5qxDnR3gcded2Cnp
         Jpb2lKSNdBDN1FOeYvaNMnRp6keIK5VF6EPvnZfhg/3zdzdNJHKYyRF9hc4TbAPJVw8e
         2RabkGtDAKZysaHuNi4CxkzhdLgTQElkvRT9IodfvbPxmmELzHSO0ygBpz5DMae7k6Qm
         4+pw==
X-Forwarded-Encrypted: i=1; AJvYcCWsYJKQ03mj7HdzUO/n2RQwKqOnZdKC2OMJKVWhIXno7VgftKaeyBCBk53lwNdoa/IeVoJvCjg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTYQVghzhr3baDLm+BL51P+nEEbMjtuIYYJauNnv8CGmaAinEw
	UvgMYWTazSqKlolrB0CFxKw79h/h9HK1bivJM0/dwOCyvviFYLaHBS/kdI1SrEIqVraYjtNBjvi
	nvxqL63UoTR3uUJBL757mEQ==
X-Google-Smtp-Source: AGHT+IEpcnPZ2ofMn+yji7Z+XgSt5iwLOb91LYysxKgZe0xq+lvgP12pvdNLF1SqkBuLey6BH72CI9pPRzVZ9+5E
X-Received: from wmbbe8.prod.google.com ([2002:a05:600c:1e88:b0:43b:bf16:d6be])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d8c:b0:442:e109:3032 with SMTP id 5b1f17b1804b1-445917d2a0amr66079815e9.24.1747731187551;
 Tue, 20 May 2025 01:53:07 -0700 (PDT)
Date: Tue, 20 May 2025 09:51:55 +0100
In-Reply-To: <20250520085201.3059786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520085201.3059786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-5-vdonnefort@google.com>
Subject: [PATCH v5 04/10] KVM: arm64: Add a range to __pkvm_host_unshare_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for np-guest. Add a
nr_pages argument to the __pkvm_host_unshare_guest hypercall. This range
supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512 on a
4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 47aa7b01114f..19671edbe18f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -41,7 +41,7 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
-int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
 int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 4d3d215955c3..5c03bd1db873 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -270,6 +270,7 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -280,7 +281,7 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_unshare_guest(gfn, hyp_vm);
+	ret = __pkvm_host_unshare_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8e0847aa090d..884e2316aa48 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -980,10 +980,9 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 	return ret;
 }
 
-static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa)
+static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa, u64 size)
 {
 	enum pkvm_page_state state;
-	struct hyp_page *page;
 	kvm_pte_t pte;
 	u64 phys;
 	s8 level;
@@ -994,7 +993,7 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 		return ret;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
-	if (level != KVM_PGTABLE_LAST_LEVEL)
+	if (kvm_granule_size(level) != size)
 		return -E2BIG;
 
 	state = guest_get_page_state(pte, ipa);
@@ -1002,43 +1001,49 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 		return -EPERM;
 
 	phys = kvm_pte_to_phys(pte);
-	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
+	ret = check_range_allowed_memory(phys, phys + size);
 	if (WARN_ON(ret))
 		return ret;
 
-	page = hyp_phys_to_page(phys);
-	if (get_host_state(page) != PKVM_PAGE_SHARED_OWNED)
-		return -EPERM;
-	if (WARN_ON(!page->host_share_guest_count))
-		return -EINVAL;
+	for_each_hyp_page(page, phys, size) {
+		if (get_host_state(page) != PKVM_PAGE_SHARED_OWNED)
+			return -EPERM;
+		if (WARN_ON(!page->host_share_guest_count))
+			return -EINVAL;
+	}
 
 	*__phys = phys;
 
 	return 0;
 }
 
-int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 {
 	u64 ipa = hyp_pfn_to_phys(gfn);
-	struct hyp_page *page;
-	u64 phys;
+	u64 size, phys;
 	int ret;
 
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa);
+	ret = __check_host_shared_guest(vm, &phys, ipa, size);
 	if (ret)
 		goto unlock;
 
-	ret = kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
+	ret = kvm_pgtable_stage2_unmap(&vm->pgt, ipa, size);
 	if (ret)
 		goto unlock;
 
-	page = hyp_phys_to_page(phys);
-	page->host_share_guest_count--;
-	if (!page->host_share_guest_count)
-		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED));
+	for_each_hyp_page(page, phys, size) {
+		/* __check_host_shared_guest() protects against underflow */
+		page->host_share_guest_count--;
+		if (!page->host_share_guest_count)
+			set_host_state(page, PKVM_PAGE_OWNED);
+	}
 
 unlock:
 	guest_unlock_component(vm);
@@ -1058,7 +1063,7 @@ static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa);
+	ret = __check_host_shared_guest(vm, &phys, ipa, PAGE_SIZE);
 
 	guest_unlock_component(vm);
 	host_unlock_component();
@@ -1245,7 +1250,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
@@ -1253,7 +1258,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
@@ -1264,7 +1269,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
 
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
@@ -1276,7 +1281,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
 
 	hyp_unpin_shared_mem(virt, virt + size);
 	assert_page_state();
@@ -1295,7 +1300,7 @@ void pkvm_ownership_selftest(void *base)
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, vm);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
@@ -1319,11 +1324,11 @@ void pkvm_ownership_selftest(void *base)
 	WARN_ON(hyp_virt_to_page(virt)->host_share_guest_count != 2);
 
 	selftest_state.guest[0] = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn, vm);
+	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn, 1, vm);
 
 	selftest_state.guest[1] = PKVM_NOPAGE;
 	selftest_state.host = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn + 1, vm);
+	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn + 1, 1, vm);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.hyp = PKVM_PAGE_OWNED;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 0285e2cd2e7f..f77c5157a8d7 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -371,7 +371,7 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn, 1);
 		if (WARN_ON(ret))
 			break;
 		rb_erase(&mapping->node, &pgt->pkvm_mappings);
-- 
2.49.0.1143.g0be31eac6b-goog

