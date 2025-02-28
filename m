Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9401B263C93
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740738372; cv=none; b=M/1ZvJS5dxX8gJy6h66qdp3Mk8tW27oDxl84Uz2CUHdRThhNVdggpSE8+rnKFUgy6Yww2whNJS8fEWVWdHFNbmmN9qT+0q1cfAfhYd4NIfx5nWSRZ+lSjQvIR1k1Lpd9I/xTUbtE1TD+dcrA+MZosjNNXTyxk3laI5k+TB/jlgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740738372; c=relaxed/simple;
	bh=8CXJzd3bdWnUUiUgEqvdbCvJOrcXmt4cgq1d60RfuSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xem1j+rQkX23GthFQYQoj9nTvZtpWWALLlPT+ZJAM0aDoBhXpgJQLj8IfxscoXIoeXMG44ntUCPyM/Kmwm6YxR2p+48Rs+nwrAvnrxuLT5r+76VVxAG07LxCtCLL9t6vMYKIVNfsMSIrlZEIAZGaJjkVeui4CqDTUERFXX05iOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aXYfO9sZ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aXYfO9sZ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4399a5afc72so10235005e9.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 02:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740738368; x=1741343168; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qXik8AjbYyPYjDFsjvp2RmgmvxUrFId1oBHnRgszILo=;
        b=aXYfO9sZEFM8Sl5nojqSBBxaSN68Dl57MGBTvrE7Ynxm82XDEUtsvCRlKu9MYwrqmV
         6/G6n4Icqjcw/tUk60mXoWs/WGj4Zwhnmz5n1OE5gaMydVCn1mk/U2ZU8T6SiZ7KwaR3
         GMNR3+MqYBdf7r6xRCMcd4T1+2rmkcoP3eMHTS2qMD0QOt1uun2oyDzfzCSoeLHYOswY
         JrdRik2bLFgxQgyDKapD+lWd4hxkBsv6pCsPFqEh0oXn/CKOhNj0cE7zhiqlMgSxH/pQ
         JajPaeQ9uWBff32NMbcZxt5X0FEVdAmIOnSSlDldFQ4Ucf9rTm7xKGfr2ZMuYW/e4K4Y
         T40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740738368; x=1741343168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qXik8AjbYyPYjDFsjvp2RmgmvxUrFId1oBHnRgszILo=;
        b=QYEbEnO+tNh1lSVSqbSW2EYGZAGNn8nH3zS9QJbhaZJXWkAqKH4RCGh5WIvBMgAgdQ
         /5u/mDoZuHGmGXM2VbjxYXCy9rB773QWICq6WQofTW6rnL6dAQossIYDLOl2al9YplBn
         jL50/K+9vUQWODrZnYu1uHhexVP+rSP1dlYKsEjGv8gE3RG+pE+fhAqjTNvL0NX1dP+r
         VElzhq8yTrKIW3jHvjFQKFzeikAYiwlhCsXjY/hMkyrJeAESXoBxHhYYzbC/hRzCVXNj
         nLWwwyP6A4G9QmqrFnPj1AbgJEQETqZuw9DxY5TtGjfauXbtNWmptBADPWJXQq3v4Qnt
         /QOA==
X-Forwarded-Encrypted: i=1; AJvYcCVq8Y3FPjuCUzj84YREF1pcmjxwifQtP225kg14FIDc7GMnbFpGMHXu8rn8qLSDnRAFiI7FBc0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+JcocJihcnWx7UvivvX+Qzdm3vuuYqEzCfbRi9hAz3johaBb1
	tIijqkY5HTm98JqJ6FNmfORQZf7egjXyccPjiitimHlN7iYGVWd1Ky6zMyVpCpUMTrwLj+WimYX
	vq/9s4TcEFmorGp5jow==
X-Google-Smtp-Source: AGHT+IH/ZodnD1gyWS5hoJvXm/WVgeMEtL4EusvAc9MyOb9eH7X6R8XviTaOHXTcXiUhD+8ewQSvRRjN0xDhTCV2
X-Received: from wmbfm26.prod.google.com ([2002:a05:600c:c1a:b0:439:848f:2fc7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c25:b0:439:5a37:8157 with SMTP id 5b1f17b1804b1-43ba6774a03mr24052865e9.30.1740738368068;
 Fri, 28 Feb 2025 02:26:08 -0800 (PST)
Date: Fri, 28 Feb 2025 10:25:27 +0000
In-Reply-To: <20250228102530.1229089-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250228102530.1229089-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228102530.1229089-12-vdonnefort@google.com>
Subject: [PATCH 7/9] KVM: arm64: Add a range to pkvm_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

In preparation for supporting stage-2 huge mappings for np-guest, add a
nr_pages member for pkvm_mappings to allow EL1 to track the size of the
stage-2 mapping.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index f0d52efb858e..0e944a754b96 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -166,6 +166,7 @@ struct pkvm_mapping {
 	struct rb_node node;
 	u64 gfn;
 	u64 pfn;
+	u64 nr_pages;
 	u64 __subtree_last;	/* Internal member for interval tree */
 };
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index da637c565ac9..9c9833f27fe3 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -278,7 +278,7 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
 
 static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
 {
-	return (m->gfn + 1) * PAGE_SIZE - 1;
+	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
 }
 
 INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
@@ -315,7 +315,8 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 		return 0;
 
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			return ret;
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -345,16 +346,32 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, 1, prot);
-	if (ret) {
-		/* Is the gfn already mapped due to a racing vCPU? */
-		if (ret == -EPERM)
+
+	/*
+	 * Calling stage2_map() on top of existing mappings is either happening because of a race
+	 * with another vCPU, or because we're changing between page and block mappings. As per
+	 * user_mem_abort(), same-size permission faults are handled in the relax_perms() path.
+	 */
+	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, addr + size - 1);
+	if (mapping) {
+		if (size == (mapping->nr_pages * PAGE_SIZE))
 			return -EAGAIN;
+
+		/* Remove _any_ pkvm_mapping overlapping with the range, bigger or smaller. */
+		ret = __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+		if (ret)
+			return ret;
+		mapping = NULL;
 	}
 
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, size / PAGE_SIZE, prot);
+	if (WARN_ON(ret))
+		return ret;
+
 	swap(mapping, cache->mapping);
 	mapping->gfn = gfn;
 	mapping->pfn = pfn;
+	mapping->nr_pages = size / PAGE_SIZE;
 	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
 
 	return ret;
@@ -376,7 +393,8 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			break;
 	}
@@ -391,7 +409,8 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
-		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn), PAGE_SIZE);
+		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
+					  PAGE_SIZE * mapping->nr_pages);
 
 	return 0;
 }
@@ -406,7 +425,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   1, mkold);
+					   mapping->nr_pages, mkold);
 
 	return young;
 }
-- 
2.48.1.711.g2feabab25a-goog

