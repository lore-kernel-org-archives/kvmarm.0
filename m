Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937471;
	b=fWgjcTOOXFYPBLx8n6fwKJPkwW81eN5MEd573s+c4hwmOo/ZXFRxYEhhWzMjcgsl+eIm
	 RTMlq+oa3sVyf7nkitKa4vJzEouzE/kl9Ffo6HEM59mZK4Wn0AvoW75w5yfMdFQZdsLq7
	 +LYYCbhJFbKRxS+uLO8mcEgWwPlBY6U3I3DG01H9+jN7e2Hc+0mUzlJEg0cKP5atvJ2mL
	 o5lMCEmXBmBwAKQV0f9GWvCKzwZzmBPg0HjImo4RFH2IggpUqPvOUGoJna5mXs9fBtVSq
	 57CN6zc780AF7SmjgTOYrPPGPDOGHAhvoz/keo46RDtxGL59oqTi+y2StPWJtt/w5jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937471;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=qdRKQpbsRP9zrrkZiZbgzrcMMF3Np0SEAzl5LV93atc=;
	b=F/bRrlXYwL4VM3qjBkjMRmi1G85WPN+qNiVGcLN9sYTw5dDP/VwXaNSpbLmOC4XPUXGw
	 Zow4Pqz8n9qlfL95+g7AKBY7pGGFQx+Guy2l6i/47AVDen/mXz3XLMyt+8LioY2gDZs3v
	 Fochd8QGuRjVhKn5jrpy+gYmDOe3FUAm4dx7owvvRALVXfppHX6a2kljbt3ipTLAg6QPV
	 +TdHOyIAwmULtZMkfx1cb8Kdgpri6ZuQS6GPQ4CdOtm8g1eQycO7x/Mcl97ejzQtH8Hg5
	 Uq6KspMOUCNRGYpcOZt3BiDlyaOuYvqWsjtC+PYno96WcgsqnBNUdw4Xj42/z5IRN7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PBcbDp5G;
	arc=none smtp.remote-ip=209.85.208.71
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB991606A331
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB991606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PBcbDp5G
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b586b0a795so86901a12.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937469; x=1795542269; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qdRKQpbsRP9zrrkZiZbgzrcMMF3Np0SEAzl5LV93atc=;
        b=PBcbDp5GUHhXQSlrTtZ1gnC6fVNH373uM4KMw34bA7QY0cl/9FqY5MJXxDgLNPOPl4
         tXGCdkk2faIxLo8lTBD3MdMTCUy47JGwxBIDWPdJn7VFrhAR/kD8cfdo8T40B117+mp6
         ZOpK8V/urvPTXwE1fPlo5sv23xGtSYs480pEs8SB8qXbg1hXr851L4r6OYCBwQhwKvYu
         oT8+RlhJjBV8V0kui0SHFSr+fa7h2IBAOMe9SFcFbjiPvCUu56Q9dTnq8zyjmNybEy+9
         jcZ9YBhBwqnQMEl4E184wQaAuc12fOlJ3xRwRPNzoj2iRcqgZkaM5kKBlT8Sg9Z3WT2M
         iWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937469; x=1795542269;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qdRKQpbsRP9zrrkZiZbgzrcMMF3Np0SEAzl5LV93atc=;
        b=ndorqiz08P6hS+Mkh0UYUTnO41OBy8kviYQECkrpQVaCr7QmEhIU5cDKe9tqTNWUIn
         cuEtBO6MwpDgWvqAgs1Mt2wR/dw/yjd08DA0wf6uCWzskdHdCIETKEZEdM0aeQVP/UC3
         joaLVE9bUASDefy1v75/y9cAM6k+2vSe3sVA1lH2qfX8BTb6v0s6PpTPgQV014HKaU92
         MDq4D6pUmmBd5xZ/x3PyUqTSSm2F8ntfJIiGh6pIOI2hM8OhvCqdto1VJYVtaOZyPmgu
         0aEKaFSWKjy/t9ayedrt8w1k0SMv3QNkWbvnwdrsWJHqyyb1hIrHKUuqtX5VzGRj0qs8
         6jTQ==
X-Forwarded-Encrypted: i=1; AL+hErHvkHZWhsuho3td/SsqPHiaRfyFFAPxDfZZEpMt0TNTsOXoujsxbVqyxN9H4Oqu6SzuJICS2+Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z8wg0nO/uKZSNfpnAx7t9DL9bp/8eMqCmCRQFxNQ9q66be3qefK
	2+P1WukNdBLrtozeKzBen7dqEAEjbM9F6kGlplGdN1LZO6YsQ70b+hxL01MhwPENTeZSfsdGKkZ
	Ni4a3eoJtUL8HtNeP9gx/Tw==
X-Received: from edv17.prod.google.com ([2002:a05:6402:15d1:b0:6b4:20bc:f6a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:11cf:b0:6b4:201f:17b6 with SMTP id 4fb4d7f45d1cf-6b887ca11a1mr27948a12.6.1794937468560;
 Tue, 17 Nov 2026 09:44:28 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:50 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-12-vdonnefort@google.com>
Subject: [PATCH v4 11/23] KVM: arm64: Add a range to __pkvm_guest_share_host()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
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
2.56.1.708.g77570a6a1d-goog

