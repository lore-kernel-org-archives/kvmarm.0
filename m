Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652437;
	b=wwcE/RHJj/RFtCzIGdOPJdrMv7GGLX67XO1RZlXNTqmN31ZGpdHZIt6NK1lbRybRRfH8
	 ucvmkb+EIckwdyZJOyZZ6tqZg3hz75tSsXbpsKSxge3JilBR2trc4vPYlPdNz9WUEr+go
	 WGNKD6S0ki/Jt+E54ReqOTzpmfvwqrAIHKxaMhOJto3WJKwouwNUeXYHW9RQS4XTrisl4
	 j2d69dhzRIy2GqMMYf1f7IjVTTcL3ySlMI1wZKYHCVVxyxyWefRPNFvaynB6udtKm9zp2
	 2x++lndqhOObPjD6Bz0Q8YtMvvxk/IQenmHrEIfMWPAN6iBGhFr/rK8Mp2lArohExbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652437;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=e6Dn35ZTrHhUrWwyLjwezkHEWmgek2c8fRcIdn4hvLg=;
	b=sMN05MLMKlx8Tdh9gHg8jepZlt2AVDLPHNcWvLIMnjgxR8ostoPl1IHuohaPST+6Ffc+
	 CpT7kui6RfMP5DgfapkxannCXSSUKP6mWPtT0ZVzJ7iDxmyLSEzv/lLsvFz2yNPf4Np1z
	 DKRT8GkAR4QwqTGAvNGayzSFvieV+zYb7ZqW6FX8Dc3N6kIlv5GPs0JNPwzT8+nHz9ife
	 wt6fsRAOsJO69yYB7WKdIpPs0WemK7z0IPjCOz2KzsNphG11SFlyqGEGRaCmMvAJJgbsx
	 KncwGS4iND+7+Ji/RmhzmsQ4hJyKQFJLYsNazMSaWLxtCcz0lCyS4UIra/umNsWPeyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EUG2svi0;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AF606A32D
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE7AF606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EUG2svi0
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b0a199b20so2818276f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652435; x=1794257235; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e6Dn35ZTrHhUrWwyLjwezkHEWmgek2c8fRcIdn4hvLg=;
        b=EUG2svi08eaSn0jJEKyL6yVvKo9Dx5fs/JeHULVrVlm2KtQ90lPUZiZG3JAS4+0LYw
         dnMBB5ZfpDgxkOXg/bWhk/MtPwWRFU8txVYT7E4Rq33pZG8/tPz9cZRT0T220YS+EbY/
         wWtPAjmwv0/gjvekQ8z6ekHpck9GkJpzicU2Ukb/z1IBj/ZPORAeuJqzR0TGFDQLxFNo
         mTU0LS+5+dFKr0YUqIliCOMBmaa/f4r1hTP5hw5Z3DnDzU2c+saaVBO9IiAozlBAPpp0
         edtIqzvzxq/0bk9VwbpiksaCRtGyDrWoX9IFszZ1dQbj4wWEzf40H/ZgxkDo2h9if0hk
         dDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652435; x=1794257235;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e6Dn35ZTrHhUrWwyLjwezkHEWmgek2c8fRcIdn4hvLg=;
        b=2UP/zI0kCOpwF4Xvb/wPLEUJBVUv2cHRiWLkek5m2LW+3K59LqiwcIm8RfgoszoAXx
         v+/ICbEsvx01UZCgjTYVTg2zWFhwytV2bqVjz3rftIaPXipXlfotb93YbgfzU3W7YX4E
         iEh2H2EVvgH99v31fnfbLtwRP6TGGU+YMuVgWtCAjCBafBPcaI3ekikQcQuQerYGdTvY
         V+doDh+RT5rVV5dxK7Mi66uwPWBzljgSPuJfvvOtzcgefOiNsnMyrsNdDF+PGfVSoemF
         4bdg/I4sZHzrWSe/zJmrgfNveFwl2UPf+tlgu+40WYzjzuEo7I/k8/uoiSL+C8mT8ixS
         IP9Q==
X-Forwarded-Encrypted: i=1; AKwUvBw3gN6oKo9Bpg2EUH7iNU9x/+6cy5DRFaIKzgOlrK2la7Mgp3Znl6dvtuU4ZFmuKPBWj9Hj7Ew=@lists.linux.dev
X-Gm-Message-State: APuU4Z8Vg0I9WQ8h/qdLvRoF3MnoyX09jzE+wuilGIZSo+iGWeaH+5dt
	dqlKOnGs3zR8r2NsOdvOeSi0T8WBA3P+7nzfd409OsAIWf/iPiNNhdjzc//KUllozZSpjNbsL4/
	ic1sBth/DMjYis4WlaFPclA==
X-Received: from wrrd17.prod.google.com ([2002:adf:fd91:0:b0:488:8b9b:19f9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5388:0:b0:48e:666d:c96d with SMTP id ffacd0b85a97d-48e6e50c8d4mr18081477f8f.51.1793652435099;
 Mon, 02 Nov 2026 12:47:15 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:18 +0000
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
Message-ID: <20261102204628.401871-14-vdonnefort@google.com>
Subject: [PATCH v3 13/23] KVM: arm64: Handle huge mappings in __pkvm_host_force_reclaim_page_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for protected VMs,
allow __pkvm_host_force_reclaim_page_guest() to work with PMD_SIZE
mappings.  As this HVC is called from a non-preemptible context, it is
not possible to rely on the host pkvm_mappings tree to get the mapping
size. Instead, use the actual host stage-2 mapping size and compare it
with the guest stage-2.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 33 +++++++++++++++++----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 030bfc1155f8..68ed886e294e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1340,7 +1340,7 @@ static void hyp_poison_range(phys_addr_t phys, u64 size)
 	__apply_guest_page(__hyp_va(phys), size, __hyp_poison_page);
 }
 
-static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
+static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_hyp_vm **vm,
 				      u64 *gfn)
 {
 	enum pkvm_page_state state;
@@ -1368,34 +1368,43 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
 	if (ret)
 		return ret;
 
-	if (WARN_ON(level != KVM_PGTABLE_LAST_LEVEL))
-		return -EINVAL;
+	/* We only support either PAGE_SIZE or PMD_SIZE */
+	if (level < KVM_PGTABLE_LAST_LEVEL - 1)
+		return -E2BIG;
 
-	return host_stage2_decode_gfn_meta(pte, vm, gfn);
+	ret = host_stage2_decode_gfn_meta(pte, vm, gfn);
+	if (ret)
+		return ret;
+
+	*size = kvm_granule_size(level);
+
+	return 0;
 }
 
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 {
+	u64 gfn, ipa, pa, size;
 	struct pkvm_hyp_vm *vm;
-	u64 gfn, ipa, pa;
 	kvm_pte_t pte;
 	int ret;
 
-	phys &= PAGE_MASK;
-
 	hyp_spin_lock(&vm_table_lock);
 	host_lock_component();
 
-	ret = host_stage2_get_guest_info(phys, &vm, &gfn);
+	ret = host_stage2_get_guest_info(phys, &size, &vm, &gfn);
 	if (ret)
 		goto unlock_host;
 
 	ipa = hyp_pfn_to_phys(gfn);
+
 	guest_lock_component(vm);
-	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &pa);
+	ret = get_valid_guest_pte(vm, ipa, size, &pte, &pa);
 	if (ret)
 		goto unlock_guest;
 
+	phys = ALIGN_DOWN(phys, size);
+	pa = ALIGN_DOWN(pa, size);
+
 	WARN_ON(pa != phys);
 	if (guest_get_page_state(pte, ipa) != PKVM_PAGE_OWNED) {
 		ret = -EPERM;
@@ -1403,14 +1412,14 @@ int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
 	}
 
 	/* We really shouldn't be allocating, so don't pass a memcache */
-	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, PAGE_SIZE, NULL,
+	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, size, NULL,
 					  KVM_GUEST_INVALID_PTE_TYPE_POISONED,
 					  0);
 	if (ret)
 		goto unlock_guest;
 
-	hyp_poison_range(phys, PAGE_SIZE);
-	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
+	hyp_poison_range(phys, size);
+	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
 unlock_guest:
 	guest_unlock_component(vm);
 unlock_host:
-- 
2.56.0.385.gac671c819a-goog

