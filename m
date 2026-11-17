Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937473;
	b=L5aOXGvnFQ7rRwahMO0KZu6E0PqoX1QmD82I8wKWWvkrapVCdq8RIVxRV5d9r+BTtUSb
	 Kj0vQehMrYroeOu0JJZSQRBZ82DTFFGLIUVnMMOAchkYqtvF/5XNbHan6OsCJsOQQnAai
	 IZg2wiinYfnk08dDrLvXdAINuZv/3r1qoieaLFoZZIY8lK7THh21IKOzn6xJNr/+XMy7c
	 JtSemTyqZlxxma/4DgAWzX+LeWM06Fxzyt1T9GMWnq0SOa2wv0+udwIA2akscCyVwjPkY
	 AdiZydIAzWVhMdsALmOW3BeyrBjMR/X2sn+KKNKfCsVct86BEcsPoYLCIYIx4J88fmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937473;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=tmN/M/QekUfJnfG4ShuTgryuduS0vg7vD+ds6Vg/JrU=;
	b=2O/RKbb9gC41hgaiRoo6QRy1ekV9PxPWFsW8Sc3E0aPBHPOSChtAO29KqN19cpzwKwK0
	 erq5SUEMKNXaM6BPHUQPnbFvsglGwhTTX7cg9EtYISUcaNmKUAkLSkQJ7SN+WcdLf482f
	 vb4VoMyOIq6dRz01/aEtohx93RAowOqr5/GNtKKIVbubzRk7TytIaPCUjUhp5Dx8MOrvS
	 rlmamMGQJNeP8oc3j738+Ch6TWS34ZP7rnZsClt5XA1Qs2dkriS3E7WlC27qvHF5ABczP
	 SBA7zRWO0oAbQ5RTji5os2hUy3qrpGBDqxo6bFuSjI8nPS58qLxt9WXRmZT+sxlefJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LrYCOaKq;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFEF606A32F
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEFEF606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LrYCOaKq
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c50657eaef0so482153866b.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937471; x=1795542271; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tmN/M/QekUfJnfG4ShuTgryuduS0vg7vD+ds6Vg/JrU=;
        b=LrYCOaKqLSJqHe4sG83sK9Nu+C7VQBybdF8ixS1TGkkV/t64O3txRwP+rjhdYbveCk
         NH44JI3Yal1e/kyqMCVlgfr3qPSevfKlJnhcLByMAX0u8Ve8xPDSaNNNo5fUfMO3V015
         wqZdEqriQ69iDV1cSFSahNUU9tkCxdOJvXnc3YRclpVd0K1rti7nHDRXpo4hgXS7TYiY
         tCtDKik9dspf0NrOwTG8WMFUdan2/NxT+Hr7A/03g6Z4v6AAl+DAVvDuBF0Mc8t/63aZ
         d3bm7jSlJe8FOZyqQl165+XI7Ze1w6xSAMopfuAjrzzUq5uTVMpWY62PInOegyTjDv7H
         41/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937471; x=1795542271;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tmN/M/QekUfJnfG4ShuTgryuduS0vg7vD+ds6Vg/JrU=;
        b=BDL8NjkbIRvR5br3pDt2reWtlMVeEx0tX0v8sbp9R4/b3U4JjcET3EDoMpTki9juh2
         7dA3zAikKtXFY9opnPCLu354DSo7X6j512fcLVof2Gozr3i+JnPEvjSFkjrKa1DIFkSA
         3amSQdWmZb4NgejZUhQVFYIbwP9zbVO0MaVn8fVUa6uRBadFeAvRR6IPtuqv7C81Q1mz
         xZSR51UwJEGyAaGT1wGt/0JD8wBb/FafnDQOeC4I2AKk6PhliliKkXNn6301IH0TxlMh
         reNGsfP77pnprff8RgYVgjGDyPDPCRe/gVtc/a8wfBtnZjLZPNtbBJKzUxNosdC3xw3u
         xvAw==
X-Forwarded-Encrypted: i=1; AL+hErEPwJhVwp2jqXzdxvMF8F2b9khgl6VxDyYFo264UcYWvrNFurPG1Aiq8BWZ93zzbc0+sVpIlzw=@lists.linux.dev
X-Gm-Message-State: APuU4Z9f9F+T+NzU6qSPz3CmT61mIlnCoihbhfXudXH10rWOtpGRXNKS
	Mak1mgfVdUpaaF3XLgRvEGolx+sSVp0wPjw2+SdRElYAiOvQNxwEQxazXjkReY3qEfdUO3qOv2A
	z2xY0yooQRRnywbOY6C0+aw==
X-Received: from ejdr16.prod.google.com ([2002:a17:906:38d0:b0:c3f:75a:4837])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:99c4:b0:c37:8c7c:a840 with SMTP id a640c23a62f3a-c510e1ee112mr1487066b.18.1794937471141;
 Tue, 17 Nov 2026 09:44:31 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:52 +0000
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
Message-ID: <20261117174403.58762-14-vdonnefort@google.com>
Subject: [PATCH v4 13/23] KVM: arm64: Handle huge mappings in __pkvm_host_force_reclaim_page_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
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
2.56.1.708.g77570a6a1d-goog

