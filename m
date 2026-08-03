Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AEF375AC6
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751868; cv=none; b=XZrxDkQpn5Qh6ybLVioZ/z5/K7VDXF+qbGbBRadIbnbUNP8MeSMoBpbhwX5aESMK5Ikj+B1xqUOiLBcxHVHnP0pVrq7c5tPGevvKdqOZJ5cn1AKaWbzX6VBwt6uM8S5kEw3c6HW5Uhud2YFes0kEoEvQG2vknvmG+e4U2DOJayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751868; c=relaxed/simple;
	bh=Czodt+RNuJ0lg8hIsrAA745OeZRvUlvG1wM43k5T/o4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KT3Z7UpVd6fJrX5nbnaCIVnKmlrUzklz8skXdMz2iIXfKPAtofzMgPD6/JryFWkiUbPh0X6zj42r7ImtA9iO6YwfyDOqOQr/yurU7ZvryqqCGlC7DPzpRlyCCLP7t2nq8EnmAA/QMNY51fskVZjAk2slvxfqKuk0Amcqk7LD1ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cc/Y5LGi; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cc/Y5LGi"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49545071724so20264505e9.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751865; x=1786356665; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQ2XbzOPil9qVoh17DDbsi8z090nZiLrDnaHmae0z4k=;
        b=Cc/Y5LGiBpHhCX/VBTU1pYbU4GbPHqxaMiRSN0ud/dh8w/RlLzrFrq3RaNDeuQXBVt
         Y6rUjsmqVK8IMqOJUApLHq2P4jUYqalW8t43gAEQK12QHx+t/5nfhfKL4NBwRYxB0sUs
         tRFGxGpH1HQ08+eH145hedyQaECb201dT8Ez/dk1egy7ZIouv1OL3z6QDskGFPt8wPK2
         CY/2DqsAphf1g20ubTwju4c7GfLpFGK5/BY7kE8Zlo+6E3+4lLiXm5hlgIBHLh5kvXgZ
         FXJrmyhcr1ev++0W7Ie17EelSlExCOLVMS4ewan4eiCRpc3bMWvqE0HA0oSlhaFL/il5
         rMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751865; x=1786356665;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQ2XbzOPil9qVoh17DDbsi8z090nZiLrDnaHmae0z4k=;
        b=TyFrJBcnTgfpnlEy56Nor88b/VEg0sCdgspquAsdHbg0kvzGfQOxD3r26On3dylity
         CjxA2w3VacHYoRImwg+ejYHPGUrSbwFGyvIwcj6CtwciFTV7WG20dwoy1RlDiZgM3bEa
         Dei73Q9QahpVm/a6AWWcQJlgoiCLER2/JnkO6oEvZLHwj7Vswy+fjQ2etthke4miMp99
         Q54snrF5uM56kQXezmwbgPCOVVBgkyLOJ2jjYMgb8i+WP/fXlqzntQF8bnwgwcAe3MGR
         4hTNhsV/s47ThFZRV8+7bBp2azG6MhxsWfQNOY7MTVSdG9R1wujYNcVD368NEZ3EjYfT
         hxXw==
X-Forwarded-Encrypted: i=1; AHgh+Rpef7hrseePGcjlZK1+Pq8EgAEgpAxt8dzyPw/R095mMy/HKus7MgeK/xb3bN4KKkvs3OlQ8Gk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+1hc0NpCRv8X0kn4Wc0lQcfs3cNAOrsbTPmSOXmynMzuIygfH
	Eb+wV1ZTK0icmyX6rUShTEczB8FwuaFAD/16UBbfTcuDYNftkuBdHK05AtPjEdYSKeUk5vrzJOY
	BOn4UMUlkRlTdmgKalpk5lQ==
X-Received: from wmog15.prod.google.com ([2002:a05:600c:310f:b0:493:bd80:da9b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46c6:b0:495:4a22:d684 with SMTP id 5b1f17b1804b1-4980c674700mr188242255e9.10.1785751864768;
 Mon, 03 Aug 2026 03:11:04 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:53 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-10-vdonnefort@google.com>
Subject: [PATCH 09/20] KVM: arm64: Add a range to __pkvm_guest_share_host()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs, add a
nr_pages argument to the __pkvm_guest_share_host() hypercall. This
range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is 512
on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 678bb55c694a..7fdfe3f22c5a 100644
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
index ce637f1a55b3..53c48cea5f0e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1004,31 +1004,37 @@ int __pkvm_host_share_hyp(u64 pfn, u64 nr_pages)
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
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
-	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
+	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED));
 unlock:
 	guest_unlock_component(vm);
 	host_unlock_component();
@@ -1917,8 +1923,8 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_PAGE_SHARED_BORROWED;
 	selftest_state.guest[0] = PKVM_PAGE_SHARED_OWNED;
-	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn);
-	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn);
+	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn, 1);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
@@ -1948,7 +1954,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn, 1);
 	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn);
 
 	selftest_state.host = PKVM_NOPAGE;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8f5d32cdb4eb..f8e2618c78e3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1091,7 +1091,7 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
 		goto out_guest;
 
 	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
-	switch (__pkvm_guest_share_host(hyp_vcpu, hyp_phys_to_pfn(ipa))) {
+	switch (__pkvm_guest_share_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1)) {
 	case 0:
 		ret[0] = SMCCC_RET_SUCCESS;
 		goto out_guest;
-- 
2.55.0.508.g3f0d502094-goog

