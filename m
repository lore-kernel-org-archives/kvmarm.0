Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652435;
	b=dAloymia+/Nquzz1EAgRil4bjqXTfKzMpPx+gyB0KoCd89zOvaIy0yPscOIYpxoV8J1H
	 EXqInfGaHVVRJDC3eo9cVyZnzvivu01J9n2f59hRz9VatD5XPUqe7y+o2gm0YW7SRJAzd
	 X9zbYtY104eTbLXE6ELG91UT4V71hQC/0lwtvvsAiOEyPcv8z12VR6TSKxvZKb2KS6xup
	 OoLzQCucOkpbXv98avUHwvPhX5PozPmYoqIa6kPCsp03WXbnhQyHW2e4tW2lgXUVwC0Gw
	 0x7olqWP3CpeLDfkC+UzM0lhfyi7YWBaAMhalUe08M8ZO6e9v6VCqrk8EgeelDKU93g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652435;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=P2ey6Onrpj0y2/IBiqoDV7wz5s2e6pa1EP6Aux57bqo=;
	b=DipSBSK1dtci6WIZIG3aAPcK+orRgAPAuN9G/UuD4dnvhg/G0eBUt+4pTOnRyVumY5Fx
	 LefNBYL0GvrQ3XldJkDdJ0uR74P2CqsVBpZVwJm0FI1ZApwElTm5ppXthVWZiMdLqNzmX
	 GO7q/d+5psVhD0gM1eP/F2LiAzP711jSvSlmkC936550y9hvq/2xl+D3cF2ezaTddBdd2
	 lk3j29LCb7X8pBdYVmodJAXK0oVfwnOBVdgZMrVV1qxpjK1yGpXaDbmUYJussolc+vEMR
	 iNZHDb5uUeytYMBs/5iThiuh1oL7LUx95OdbWympwT8pQ2rLJZZYNuGaj6//DbN9w5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="c/zhZdzt";
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AB9606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8AB9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=c/zhZdzt
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a35e1d2dddso32295845e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652433; x=1794257233; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2ey6Onrpj0y2/IBiqoDV7wz5s2e6pa1EP6Aux57bqo=;
        b=c/zhZdztC55+FAk3OQzkX1GD+eX0lqbvAH+4yMG8MB2tmSTi7tLhnEz9ePpuSBKZSj
         4PnIgXUdXIy+fJvyueCHcZAh2Z63b4qNHC7zWVZyQruMw4bKiABq3v9xQmdczAPSgi7v
         dMTwX4FeuFuOi7fhSjpuJ6jXh/ydhizTFrpRKtSTYPfdv+jq4xl8+PqoCgRLNuvNvkME
         xx6hu3RE/vSD6bhU5g6MZ3blGoeIZ+L/0JsHJgY9KiOeArD7KQjoA7znLxMrnJGMoU4E
         nkVLjjo5bBv6noLcVIvty9hgVeGvT5cxrj05FMvxCk557gORQKRtURJsmdgG9y9wCl/J
         qrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652433; x=1794257233;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P2ey6Onrpj0y2/IBiqoDV7wz5s2e6pa1EP6Aux57bqo=;
        b=bLvwsIIfATfLJ06fkZWNbCZtM+nWMdrRg+Fl+4p8jgFh4LrWKgriSRg7ZigcvlyRwl
         iQkva0a3/ZTsNsAKYArDpVgZAkhI4eWdJflRP3Q9UgiOmVm5+XR5DB5Es0Yc9tW9rBWy
         +L4FhL8fpZmoEa/jsVOWujwYA1GrPIfqQ5UOBv9CFeLx8IQn6au8P52iLY0J/76RCdcD
         sY0rzSKPVW5aciK/FRUWxVZjPe17OsB4oUU/Y0FpmRNZDlzy5lmKHbztTZToS0zcz4Y5
         Z1Lv2K5orYTcjoSi7hE4OchIi8UBVN95j1/OoNaaxsqc70vep0iWjZ/37x4h7VH58cs9
         ygsA==
X-Forwarded-Encrypted: i=1; AKwUvBxZOTzqjMmv8JxEviLvRkN4mbU+RaTQpErQzrYC1Nu+4sRlxlhB/veF+x0G7OZuBvfnJ2yKtSY=@lists.linux.dev
X-Gm-Message-State: AFq9FYJVQsickbNrL1ZNDkl1+8CYs2VrUmmdsg325Bm90sdFozEGfNDK
	L1axw7zn6c2+jzTdEYJ6QgszJjd9esel3WSAxOBJZf76R6hQTH++zvyooTl8tb2lWtK/KSMnvhr
	eV5UNu464XJ5KWGk3Tt0SBg==
X-Received: from wmsk28-n2.prod.google.com ([2002:a05:600d:849c:20b0:4a1:811f:6de2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8706:b0:4a1:e0d5:293e with SMTP id 5b1f17b1804b1-4ac1765d3ddmr278044675e9.21.1793652432957;
 Mon, 02 Nov 2026 12:47:12 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:16 +0000
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
Message-ID: <20261102204628.401871-12-vdonnefort@google.com>
Subject: [PATCH v3 11/23] KVM: arm64: Add a range to __pkvm_guest_share_host()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
add a nr_pages argument to the __pkvm_guest_share_host() hypercall. This
range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512
on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 24 ++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  2 +-
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b05b0bcc3f2d..6741c9ecb879 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -32,7 +32,7 @@ enum pkvm_component_id {
 
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages);
-int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
+int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d5dcfbb59b7c..9183406ae04b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1034,31 +1034,37 @@ int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
-int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
+static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *size);
+
+int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
-	u64 phys, ipa = hyp_pfn_to_phys(gfn);
+	u64 size, phys, ipa = hyp_pfn_to_phys(gfn);
 	kvm_pte_t pte;
 	int ret;
 
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
 	host_lock_component();
 	guest_lock_component(vm);
 
-	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &phys);
 	if (ret)
 		goto unlock;
 
 	ret = -EPERM;
 	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) != PKVM_PAGE_OWNED)
 		goto unlock;
-	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE))
+	if (__host_check_page_state_range(phys, size, PKVM_NOPAGE))
 		goto unlock;
 
 	ret = 0;
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
 				       &vcpu->vcpu.arch.stage2_mc, 0));
-	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
+	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED));
 unlock:
 	guest_unlock_component(vm);
 	host_unlock_component();
@@ -1941,8 +1947,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_PAGE_SHARED_BORROWED;
 	selftest_state.guest[0] = PKVM_PAGE_SHARED_OWNED;
-	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn);
-	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn);
+	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
@@ -1972,7 +1978,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn, 1);
 	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn);
 
 	selftest_state.host = PKVM_NOPAGE;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 2a73e63e8f81..66d7493a6549 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1178,7 +1178,7 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 		goto out_guest;
 
 	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
-	switch (__pkvm_guest_share_host(hyp_vcpu, hyp_phys_to_pfn(ipa))) {
+	switch (__pkvm_guest_share_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1)) {
 	case 0:
 		ret[0] = SMCCC_RET_SUCCESS;
 		goto out_guest;
-- 
2.56.0.385.gac671c819a-goog

