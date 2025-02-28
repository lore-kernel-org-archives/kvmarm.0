Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2A625F792
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740738357; cv=none; b=HGGkKWQwWX3Q5P7obIhJjLdTqU2zJNTbPghfjjCYpzzaT++OAI/gKzwPGnqkTtN+qwjc4FZrR6/QGNuG+ogIzO8MH6g5wz/idHw7slj+5RTSw97LOtrxcPEW4M6a74fFd7+qFSR6MoE25PBUpaceJ9dbEUjrucnLP9OaAC9IuKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740738357; c=relaxed/simple;
	bh=KYdo1+rj2avzQ2fdLRDheaWLEoeWhVviPVR/ZB7+cYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g4QwqMr7AYv8Ds/jlQVl7adqQgEqOrd5S/v5SeSy1p8XlLBSnvFJ2zc4aZc++y9263Gf+HGxP+wsZalx+WLVi0A4WjG+oa1e93yZR3lz66Q9e/179ciCH22n+YuYZ55jHyn6ChHfZ98881B2/z3GT1XegLrL5J0XGuOTgY8Ogl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aILPTQ3Y; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aILPTQ3Y"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ba50406fbso11646855e9.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 02:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740738353; x=1741343153; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+mthpUBcuFXcir4pSjUd/6TiIbqiuZjMcArsC605TwA=;
        b=aILPTQ3YnRF7nM7L5ogZ0XQzFDDDqdlmgkBs5bWAmtPSeqM4zwfATmtaBP7E4vaOZ4
         HiXBcxcIapPTuw5tVu555f8xdGdiN3FVWgGWFfsdHqxhSq2JxxmqzIp2J/JiDCHBf3uK
         dWfJRAz2XCIOJPWxUXMDEz5bf1HAOm+701qhw0WFmgt7MIGtJ9cI18zx85VXsIbForeS
         9i7hiYdqPTO+qohGLi2uuYWiCibzlLIs+wpz3nZjQNS8DqIU1R1QXGe5xmWayEQtESN9
         TYQw24PtrOYHlxgX9qx7btu6q4jV8ANwjUGpEVFzvXiYPdHTmnoyy/bHo1TpkJBsjB5p
         7J3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740738353; x=1741343153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mthpUBcuFXcir4pSjUd/6TiIbqiuZjMcArsC605TwA=;
        b=phYn/U2cCt5xnrB/K5CEUj8MIqaH2fGJ0CRpYVlCNgFgC5NL2piiMeooMZdM150G3b
         w0lTuP6KhBGMm63W96tO0uyx9R1bRfiPj4DEWpyLE7V4R1j18D3Elh90MGgJgRMgQZGb
         F73rJ4sZuqlmED7ILi5MsAuX+4NfLitjE+p/wbONySJUAvMQIoXKe0f5H7jSS+JQeFCV
         lJqhQ7i6mYSAnKGHJumhY+C/P28pRhx85AVclHjCXzvp38WBmDArtpc0UiucMPAzEsjy
         FYXH4L+ObhpEl9GashUV5r3CjaxDM6H4jCKugrwzc3C7Y7RDGHaO2mEzV6oyyC7Gvbfu
         /jJA==
X-Forwarded-Encrypted: i=1; AJvYcCU6J5Jvu7BjHPYE4e70ucXOowJaGDJe09baHLeZJT21QhxEk6PAIw9RieQSMgq1tTuBjYwwgHA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm0aDAZd0Qn7xNuqKJrNaOcSLGBrin+ddM5XXkDp6Mc9GwuySG
	0W3plBYddQZRwyDWQ80+yQ/diEfJdHeAoTNv9st2oEZKa83x2KKG+IxalMRzSEuTCOqPXGLCnnE
	FD7lhq0E6ei9j7CxmRQ==
X-Google-Smtp-Source: AGHT+IHtP/oHqzhg0ASQAq95RZF5lYANl+I3P8Vxk+cLo0Dh2BmKOXowoVEPz/OhfN0g9+f+h5G4M/hs2XzAvpfv
X-Received: from wmsp28.prod.google.com ([2002:a05:600c:1d9c:b0:439:47d8:90a7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d0f:b0:43b:a397:345f with SMTP id 5b1f17b1804b1-43baa2c14e7mr14416685e9.11.1740738353821;
 Fri, 28 Feb 2025 02:25:53 -0800 (PST)
Date: Fri, 28 Feb 2025 10:25:20 +0000
In-Reply-To: <20250228102530.1229089-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250228102530.1229089-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228102530.1229089-5-vdonnefort@google.com>
Subject: [PATCH 3/9] KVM: arm64: Add a range to __pkvm_host_unshare_guest()
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
index 1abbab5e2ff8..343569e4bdeb 100644
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
index e71601746935..7f22d104c1f1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -274,6 +274,7 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -284,7 +285,7 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_unshare_guest(gfn, hyp_vm);
+	ret = __pkvm_host_unshare_guest(gfn, nr_pages, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2e49bd6e4ae8..ad45f5eaa1fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -984,13 +984,12 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 	return ret;
 }
 
-static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa)
+static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa, u64 size)
 {
-	enum pkvm_page_state state;
 	struct hyp_page *page;
 	kvm_pte_t pte;
-	u64 phys;
 	s8 level;
+	u64 phys;
 	int ret;
 
 	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
@@ -998,51 +997,52 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 		return ret;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
-	if (level != KVM_PGTABLE_LAST_LEVEL)
+	if (kvm_granule_size(level) != size)
 		return -E2BIG;
 
-	state = guest_get_page_state(pte, ipa);
-	if (state != PKVM_PAGE_SHARED_BORROWED)
-		return -EPERM;
+	ret = __guest_check_page_state_range(vm, ipa, size, PKVM_PAGE_SHARED_BORROWED);
+	if (ret)
+		return ret;
 
 	phys = kvm_pte_to_phys(pte);
-	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
+	ret = check_range_allowed_memory(phys, phys + size);
 	if (WARN_ON(ret))
 		return ret;
 
-	page = hyp_phys_to_page(phys);
-	if (page->host_state != PKVM_PAGE_SHARED_OWNED)
-		return -EPERM;
-	if (WARN_ON(!page->host_share_guest_count))
-		return -EINVAL;
+	for_each_hyp_page(phys, size, page) {
+		if (page->host_state != PKVM_PAGE_SHARED_OWNED)
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
+	__host_update_share_guest_count(phys, size, false);
 
 unlock:
 	guest_unlock_component(vm);
@@ -1062,7 +1062,7 @@ static void assert_host_shared_guest(struct pkvm_hyp_vm *vm, u64 ipa)
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __check_host_shared_guest(vm, &phys, ipa);
+	ret = __check_host_shared_guest(vm, &phys, ipa, PAGE_SIZE);
 
 	guest_unlock_component(vm);
 	host_unlock_component();
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 00fd9a524bf7..b65fcf245fc9 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -385,7 +385,7 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn, 1);
 		if (WARN_ON(ret))
 			break;
 		rb_erase(&mapping->node, &pgt->pkvm_mappings);
-- 
2.48.1.711.g2feabab25a-goog

