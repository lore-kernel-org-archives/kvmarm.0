Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AB720B815
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 11:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741258865; cv=none; b=Mj2GQYomebHIqLvXMxUQhAzfuP8JvNjgnYuLtbi+RUJEy2LgxomOCtjnFFrm27SKp3HYS2bRGwBGzQmF0C5ftB8susuAQ89h7NVrXltAvuJ4vvoywaY1N0+8/NlwgDX08c8rPOlSFJ+qz/sQ3qk3alIhdBjL6/trmMaThH5OJHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741258865; c=relaxed/simple;
	bh=VvUXJIr2kKN2xNaqZOPY7Q821Sz9jg0B9W+Kg6n6k7M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I/VgWnSYUGrtHcI8WcIPbnRFYbAWQYvAeGvxeOQIHkaxq1lU//w6cDEFYmAmQfWmsAS/mt19HaYt1jhrniLzRQamiqR6B4To74ofj8fuhWoUlWF9fCEZG1G90AJVsrDHxSraDsgb1IdMMwbZHq15GhnlaE+DqNfjpvh088WfZdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=otspcjMq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="otspcjMq"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4393e89e910so2294825e9.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 03:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741258862; x=1741863662; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=azWhDzZbtoxtjhQWlpXB32XSGr+Msg3K3f2k/5PFntI=;
        b=otspcjMquvm7TTmWs37sVWxch3902w/amVf3ZmSTgtjKTZHam8J8XIef7QeJIHm3B1
         7yl9uQ+l4g2Voqm2UfnF8JKvxguErIEImCH2GHZEC5X/8jC8eg+ogIDGUsIxxf1558Z1
         Yu1TN5wdNwRp1tuhmtfV7yD2lBkQ5Q2g1pOD6u8npSWsCmC0ZQeCNZRNP7gyyUYBJcpD
         iggQU+8gDsUbNMACiIVS20p2db62oVpvrW3Knq0bRnluYnV6sftrcDMp/9m2JRvo4twq
         8sO2cnwHpsCcQGw6W53I4zSiNJYbSWbKQm13SH11TAjzDbbVQVCeJg0TazAlhEIb9DIT
         VPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741258862; x=1741863662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azWhDzZbtoxtjhQWlpXB32XSGr+Msg3K3f2k/5PFntI=;
        b=JN1W92mRdEevIm/t+CCEDrs5+465Ga5K1OYJZd79uwcdeeS9xqAdeHLdZQ0i2FNZhn
         hIhctYetgE4cXP8vW9slBTZ/+/4h3mJSauS1FMHcD9QewImBg/rXokPojvG6JXY5iV/I
         ol4TB8act2Z7RQhysFrJLEluwkwcisx77bYoJ/tzkFjBuroax4RKLP59Uk+2oAD9+qh1
         3+KqnuGF6mTvTu99NYUz1nqS0a9+b5XzIbcVKx4Xg+YSZBXxi0gZZj6lJatTytgXoCd+
         9RplF43btIlKBVTc8hh9EjYHtQEAdTk2aLv7e2Z1iKAxnfQLotGH5/iKabWQUbV39yM3
         RSEg==
X-Forwarded-Encrypted: i=1; AJvYcCWihaXbXTC6TImIRR1DAJHxvuULPiDuTmM8RbdEgXS6cpbAfr9L7D/2gl3p9cUorgwRkLv4e8g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoOtAp3DoHWqSs2jFW/U2R1hBARno67wQ+YRL/AJQYw51H5ImI
	A7YKllhbT/p5NGgW7iww6pN+0TpvDE9W8HnfahK2arBefDd52hHMysDyGDoBzx2+KMafJqeSlK2
	SduNo1WRytrs/4Ohdgw==
X-Google-Smtp-Source: AGHT+IHaLhB8g0ea9IzCe71YUfuaamK20WvX24Cg501MmU1HL29IV3XbEohWkl/ds2ZX3TqbOYoDRDMXlJjEcXa3
X-Received: from wmbeb18.prod.google.com ([2002:a05:600c:6792:b0:43b:c205:3a80])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4450:b0:439:98ca:e390 with SMTP id 5b1f17b1804b1-43bd2af45eamr50778475e9.27.1741258862389;
 Thu, 06 Mar 2025 03:01:02 -0800 (PST)
Date: Thu,  6 Mar 2025 11:00:37 +0000
In-Reply-To: <20250306110038.3733649-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250306110038.3733649-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250306110038.3733649-9-vdonnefort@google.com>
Subject: [PATCH v2 8/9] KVM: arm64: Stage-2 huge mappings for np-guests
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Now np-guests hypercalls with range are supported, we can let the
hypervisor to install block mappings whenever the Stage-1 allows it,
that is when backed by either Hugetlbfs or THPs. The size of those block
mappings is limited to PMD_SIZE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 61bf26a911e6..b7a995a1d70b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -167,7 +167,7 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 static bool guest_stage2_force_pte_cb(u64 addr, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
-	return true;
+	return false;
 }
 
 static void *guest_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..3143f3b52c93 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1525,7 +1525,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active || is_protected_kvm_enabled()) {
+	if (logging_active) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1535,7 +1535,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+		if (is_protected_kvm_enabled() ||
+		    fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 9c9833f27fe3..b40bcdb1814d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -342,7 +342,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 pfn = phys >> PAGE_SHIFT;
 	int ret;
 
-	if (size != PAGE_SIZE)
+	if (size != PAGE_SIZE && size != PMD_SIZE)
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-- 
2.48.1.711.g2feabab25a-goog

