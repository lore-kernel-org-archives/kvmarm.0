Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9B2371D02
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751865; cv=none; b=UXj9+rc7c31iOCKBuoDt7Ir79nvd+ebPUnyL9FcgNjdr9WWSPFTwNtyL76O8Wu1IKAecBCukRh329PyxPW6g14CU09Kw61y9JrTtcC8XKahjn9B3srHlh8iPKsAQ6+ItSJbk2Fn6cOlSETdKXWdK6JrBaVOrWnTdQafPPibjnzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751865; c=relaxed/simple;
	bh=UYsePiY0dg83jmWi1CLU91gnnjrx5TXwED/n9U831Mo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=duUSVxa5Nu06JgVYC54gtAJKni295pXqHPBc2FoALybZOZESMFGbqgvpWEeJ2vDYVwrDucXiA+2Fss/ppF9JmVCX7ZUKjIz/cCUjBiZUUgzzGKKtAc0WLtDMTXRDl1ZjLjl4dP8r2KlcBv85HiC9T5+82Q8DT/ADqOzV0/7gaPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dlP5J8wE; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dlP5J8wE"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so11873105e9.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751862; x=1786356662; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=02G/m5/oY2Ky/DKzLj8+eTPZcwCeqfZqEPHs81ZB7ss=;
        b=dlP5J8wEgW7c65qP7gI7Ux5ke7AlbkpiMp7oXppMvqeVsLN/qexdLtGrGbp5jy6zAE
         xgXcIRjBOdy4Orrw6tJGzrsnfD8ZP2e4aTzhELyCukYjP+OVpVdSfJd/GGZp0JcoyYvI
         W/JUxQaBUhHB1mJaJ9cQ9ftgUm9ir1zgf7fSYspbKUSmhlyqWZVCaMIyDp7YbQN964qA
         FlZC1qOgNKPT8mjE56nPsLMoKUJ0thWKTt8MTH6VMk34hXb8pQrGw5aYy0VHdIkemGLO
         vXjqXU5O1iJqAEl0LzCtpjKuenO11suaUjAAuhW+aXQ2KsAezsovrRmWme44e7dbX+9x
         spiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751862; x=1786356662;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=02G/m5/oY2Ky/DKzLj8+eTPZcwCeqfZqEPHs81ZB7ss=;
        b=T8R7fSYi+3zpX6t9B8ZqvJm9ZQZBTuBxy5Wqw5Fo+zbfV6zX25wQTOCCC1aT2FF+VA
         aQZkx2OHM9DOOMmpG0Ioc6rkMmP4HsTGvLWyIdRWj6owXPnRVSpaH89ta/sVJk+f9Hnw
         jvL/dwcUPARjoE82jdXgjzswFeTVC4x76egLrT/J4J1NbrDDkl7DofaviNsf3bbyVNNX
         YwjPWDz5pPzM6E8vfIoT2I/UoXnBq6sjUvLYoo5TIqV+gh0NFx1DhcV1m8slq8Nru0Ly
         YU4iBVNHGqqkWxeKw8XoumsPb4Yz4+sj4MZoiPvlAbA7lIxwzWIl4Gov12p4zF18kUG8
         usJA==
X-Forwarded-Encrypted: i=1; AHgh+RqBoI3fYCioJn2QHrRWhoFCFOuAgugulS8M3s5nUSjrqhajmuVIiIHtgDt7k/Lbxw1saWX0d2o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZ38PfQhc2P//nNQjyOn+KU7vceiedviLqkrb8Y7MywCx0cSPE
	7VELxLLDcypzjcOq4JHti+xAOrsm0/jcl2owjjLBdJSebXlmyWnv1Fh+Qqo4zK22uPxgAXHETav
	ciMxfbS8fOXsQA8SCm2AkGw==
X-Received: from wmlv11.prod.google.com ([2002:a05:600c:214b:b0:495:4926:42d6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b99:b0:498:519:e660 with SMTP id 5b1f17b1804b1-4980c66d8b0mr215323955e9.4.1785751862128;
 Mon, 03 Aug 2026 03:11:02 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:51 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-8-vdonnefort@google.com>
Subject: [PATCH 07/20] KVM: arm64: Add a range to __pkvm_host_donate_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs, add a
nr_pages argument to the __pkvm_host_donate_guest() hypercall. This
range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512
on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 1f70162fa625..c13f258fffb7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -39,7 +39,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
-int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu);
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
 int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c922288a77e6..c7a8c2eea157 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -268,6 +268,7 @@ static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
@@ -279,7 +280,7 @@ static void handle___pkvm_host_donate_guest(struct kvm_cpu_context *host_ctxt)
 	if (ret)
 		goto out;
 
-	ret = __pkvm_host_donate_guest(pfn, gfn, hyp_vcpu);
+	ret = __pkvm_host_donate_guest(pfn, gfn, nr_pages, hyp_vcpu);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 3118941a11a7..9ea448895c15 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1422,22 +1422,30 @@ static int __guest_check_pgtable_memcache(struct pkvm_hyp_vcpu *vcpu)
 	return 0;
 }
 
-int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 size;
 	u64 meta;
 	int ret;
 
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
+	ret = __guest_check_transition_size(phys, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = __host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED);
+	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
 	if (ret)
 		goto unlock;
 
-	ret = __guest_check_page_state_range(vm, ipa, PAGE_SIZE, PKVM_NOPAGE);
+	ret = __guest_check_page_state_range(vm, ipa, size, PKVM_NOPAGE);
 	if (ret)
 		goto unlock;
 
@@ -1446,9 +1454,9 @@ int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 		goto unlock;
 
 	meta = host_stage2_encode_gfn_meta(vm, gfn);
-	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
+	WARN_ON(host_stage2_set_owner_metadata_locked(phys, size,
 						      PKVM_ID_GUEST, meta));
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
 
@@ -1790,7 +1798,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
@@ -1810,7 +1818,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
@@ -1823,7 +1831,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 
 	hyp_unpin_shared_mem(virt, virt + size);
 	assert_page_state();
@@ -1843,7 +1851,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
@@ -1860,7 +1868,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.guest[1] = PKVM_PAGE_SHARED_BORROWED;
@@ -1876,9 +1884,9 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[0] = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
+	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
@@ -1891,8 +1899,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	selftest_state.guest[0] = PKVM_PAGE_SHARED_OWNED;
 	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn);
 	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
@@ -1905,8 +1913,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	selftest_state.guest[0] = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn);
 	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
 	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
@@ -1918,19 +1926,19 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.guest[0] = PKVM_POISON;
 	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn);
 	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[1] = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn + 1, vcpu);
+	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.guest[1] = PKVM_NOPAGE;
 	assert_transition_res(0,	__pkvm_host_reclaim_page_guest, gfn + 1, vm);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 
 	selftest_state.host = PKVM_NOPAGE;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 047f941fcbb9..58d8474b563e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -465,7 +465,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			return ret ? -EFAULT : -EAGAIN;
 		}
 
-		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, 1);
 	} else {
 		if (WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE))
 			return -EINVAL;
-- 
2.55.0.508.g3f0d502094-goog

