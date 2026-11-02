Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652436;
	b=fVv2wOIJo5zQjo+oZ6XZTBQrtNO2KK3Lnen2QDfL/TVEl2aIGf6VzwO5fkZ8WTZhVEqJ
	 6tM65bIXGflEcnnZGQaevp6mciXUXhvk3Ka0W0mR1XFaJP4eh2/EJCpVb+Trq0Haz2YbV
	 miF6kRn/xkFsKTnaClUaM87g73jZopL54gIwPSGL+XOJLxdz1PUjp84s3ddZkcdENC6UT
	 MtHHt2W6KV1e9ho7JvflR0StZbKd5robaUhCQ+dLZhtrsCtabruE2isvGugfvvJDRygu+
	 xP/j29RehaelxKjWGWkft/cGRVzEFdAEbb9zRF7dq0wKMEDv9vb9rSCunGGpQHNFX9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652436;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=lBfCfijGJlZHvIxga5/+PAUqlvQA0SUFi5KOslqzj1Y=;
	b=h7QgN1wqhrRJvX93FmdoCbPUyrnob8tOM/r2f0/wtKrWxQcvZtfWux3GZY2opVkTeqo6
	 unZWAUXXeJz37PgkZs7fQ+goX3IQCcEUM1oR6mtfr6xXC/JM+fVYWBQXK5Mjn18tR5ZgG
	 0Vl8OIRHeUByBKBKwjUrx5lu6W5UelAoUUlsZSW5OVQuo5DlW2NOwqlnY5yxeSl6fsRU7
	 bd6OM8wYnRasL8ip6kB6tcbpb9hsTvn3QDqgk63QkOWT7BPEMr5vpKGSnNPpisqvdqSja
	 AARRYFcPllb77QIfqk3nZyTNnirlI486KarSRXq8kD5oVi7/sWysDs6hM14nVmuYxyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q6wgBqhU;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C25606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3C25606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Q6wgBqhU
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a214a5f8a1so32620445e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652434; x=1794257234; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lBfCfijGJlZHvIxga5/+PAUqlvQA0SUFi5KOslqzj1Y=;
        b=Q6wgBqhUtdzOg7n3H8yfphnY4UvmGGJsU7y02MAywuH7hQ9Ex1Rrj6OBqP/S1gfCmY
         PX0tsPHGwjBwT00ac50vm/kUbki+twC0xh6nkoaK1Iwg/2DUtReWOV6s9YY/HV2ylQ5S
         6dQ0Qob78n7cVzrcq3MVniNMuTPstCwCWXDY32uAVnhu2whQUAT6E0nMIX9A5rzIijBT
         J9rEXD+M/1wX3RhDfLkHHEtev4RKo17Mh/neUwOJ9IJV7Kz6bP90uqs5b8WDvsIsb78m
         52FzXt4zHq0ldJ2WXxY/zCZHTXxLs4+03+UlZwDZFh1fDNoMzHTPDK3TGB0bvXVfKT7m
         wqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652434; x=1794257234;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lBfCfijGJlZHvIxga5/+PAUqlvQA0SUFi5KOslqzj1Y=;
        b=qoZBhPOpAqROsKhsZbSjrdj2uC+yUinWK0r/UjCpiPy02BYKDM0ydkPnw6VhK61xsB
         n14L4asW5ggw4M/tAl/OPaQmFIrP1fewfncpBSXSoEdGrDwWO/ypdk6QE5TkQ8hyyNhd
         nyV9C/hzMEa46jOZqOjvBw7wwlzReDawG7+J2W27/WJ+/fKRVwLKU3m797lYh/O2rVbd
         NckVSt98rm3GhG3QFIgeyxSJ9kasymQsHVuiu6GxuNTN1N+X5Xf8TvoCn0fLvgYh1oAp
         W8aUEuGOfu7uCKb1MqHjYRdMK4Iuk6PsnKT3mQk8Yk/XDfE4nNvFZauyNJha+AyimixY
         Umdw==
X-Forwarded-Encrypted: i=1; AKwUvBzYNfujt4bLE+18w5X5bzAbkK1wtQ61HM4slsb4XS9DuwBi0XUgBD/q5G+EBbn1uYbBv/WsWuk=@lists.linux.dev
X-Gm-Message-State: AFq9FYI6J7sMLl02bK+fXaZtwSJNE1s6tCppwsm7pyQzhs5UX6UZ3izT
	g+HcDCkCPdxF7mhd4FeLa/M+wCtgjBr/QMKKmmFm2Lye8nM1MF+I/juNICcEevdFH4bTLGP/4M7
	iGYmnKSecRWBzHsefijR5UA==
X-Received: from wmcn23.prod.google.com ([2002:a05:600c:c0d7:b0:4a1:dfb3:2e66])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6508:b0:4b0:bc65:b9b5 with SMTP id 5b1f17b1804b1-4b0bc65ba2bmr88926705e9.35.1793652434243;
 Mon, 02 Nov 2026 12:47:14 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:17 +0000
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
Message-ID: <20261102204628.401871-13-vdonnefort@google.com>
Subject: [PATCH v3 12/23] KVM: arm64: Add a range to __pkvm_guest_unshare_host()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
add a nr_pages argument to the __pkvm_guest_unshare_host() hypercall.
This range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is
512 on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 22 +++++++++++--------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  2 +-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 6741c9ecb879..3fb55899be6b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -33,7 +33,7 @@ enum pkvm_component_id {
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages);
-int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
+int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages);
 int __pkvm_host_unshare_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 9183406ae04b..030bfc1155f8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1072,31 +1072,35 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages)
 	return ret;
 }
 
-int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
+int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn, u64 nr_pages)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
-	u64 meta, phys, ipa = hyp_pfn_to_phys(gfn);
+	u64 size, meta, phys, ipa = hyp_pfn_to_phys(gfn);
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
 	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) != PKVM_PAGE_SHARED_OWNED)
 		goto unlock;
-	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED))
+	if (__host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED))
 		goto unlock;
 
 	ret = 0;
 	meta = host_stage2_encode_gfn_meta(vm, gfn);
-	WARN_ON(host_stage2_set_owner_metadata_locked(phys, PAGE_SIZE,
+	WARN_ON(host_stage2_set_owner_metadata_locked(phys, size,
 						      PKVM_ID_GUEST, meta));
-	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
+	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys,
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
 				       &vcpu->vcpu.arch.stage2_mc, 0));
 unlock:
@@ -1961,8 +1965,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[0] = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn);
-	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn);
+	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
@@ -1979,7 +1983,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
 	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn, 1);
-	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn, 1);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[1] = PKVM_PAGE_OWNED;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 66d7493a6549..d92f4da1c180 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1206,7 +1206,7 @@ static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
 		return;
 
 	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
-	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa)))
+	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1))
 		ret[0] = SMCCC_RET_SUCCESS;
 }
 
-- 
2.56.0.385.gac671c819a-goog

