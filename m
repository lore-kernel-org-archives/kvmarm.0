Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8B72957D0
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 13:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746796649; cv=none; b=uwbsLgJGVMnmisWeQWfvH/ZzKxqFg6soTQ2pSDx15sY+y+JLH0iEaC5cC3puqXo+0NXptf4YEzlnA1a+3N5EVAvH8zthh7RB/zjayGxs5D0usK0MRhRTN28QMcYTfoat1okRbsf16roXbb0J8jJRosTjFQp17ExKUbPvaDG/wv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746796649; c=relaxed/simple;
	bh=VmFLE0qPF+vVZAa1wgh69Vyijh9+uNZXV/gnUp4P62A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YTMeSvs1+0B47nJzYcvCmT3fuZXsjdpdNtBrMlRoEAc7Demb6nPwVxjZxg9IOAFLIwcaBQ52t1X2j/Ol6eHM8VMT3Q4dWMBYO8t33anhAyUw6b4Yf4YWHpr1svfz/VQPE27EniaxPRXJ021v6UsoO47RFB1hb/CrC6q9/GMDqt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YjTAkySk; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YjTAkySk"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-440a4e2bad7so13480635e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 06:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746796646; x=1747401446; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RNLpH3Q60kPaAsu8vhpy60m6RZim/8uyJRruoS33oJY=;
        b=YjTAkySk603paqgQ1W5YbBXOI2yMAikd34tQzHrxQSGfq5S4hos+OZb2TiD3uXkb5q
         5yLeqq8OFhFOq7kvsBi4qY9cmMKz//Q+PV//0OU4XMlCrWBW1nJ3Dw8x44jY8Q4dxtYm
         dx0QQX0a3B+g7k8e86pMwTjnAHevGqDWYZaSLsVdgf/cIk5A4CK9rV3T5MU8KBTKUWmr
         HVIbNZmcgiz2UNuHndahPEAK5hL53m3o4mBQZOJ1NhsQx8N76BCDoBgHzzndv4YWb4Vc
         nRkWL0Ncy7BpsyugD1BXv/NTgR4/W9okV+NpJUvCe5n8PGu+cDnDaXIA0kneU6ZCicTP
         +LRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746796646; x=1747401446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RNLpH3Q60kPaAsu8vhpy60m6RZim/8uyJRruoS33oJY=;
        b=spVuM3JCq/G7RQ4NvI2Q2Jd9XJzWdaW7IJ5DL8bHj6Df6gKOJOk27s7oBfQvIm2Hfi
         InpqK/mDshSq7EoNxPIGSoj94R4pAeagvulJtReMee1sGNEt8tAGH1KoPWMWsg0mc0GL
         vhyZ+n6BL/AR3Zk3GWKFh1+aTTfeD5UOvw01aWQ1QyPxloiKHO5dlyP7KtvMyfYjzyd/
         LuLpvKiO91VkSr/LuDq204Vo4/6pnkQpZx8PcVHUVqgwwzaGY4l81R5zcm4n55Kw0YTa
         27K+un2WYT90PCG2EqA5ADBu8he6oMO2zy7ACUjNul9MFQQGVfrkIZ7WoYOc6U/Kl59z
         uhsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTQCtcuo6QOqH0wDnZ34v6tuvof4LWonHw/rSPnzZVbhgLspsWMantK/0HuFLHGRdmkAByjlQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvB/IA/N2NqGClhlku+/8vLnvqoOVXOFFJO80eRzPZE7ANWdYZ
	cjrRXaTA1TsC3LC5XAnPyxuYqqcuxDbc5POYV3Qb/ArzU+Gwm/dy6hCAbOR0fE9elkABeHh6Wg0
	YpzqTtyUeV0RpO7hJNw==
X-Google-Smtp-Source: AGHT+IEzp3z+QA2RzhLt/eBNPn4r3BZgbOIVIrs7d4F5IcvdZaGGp2zyrkjpEIgHZCECiNxrwkCgmBm3JE7hKe7K
X-Received: from wmbdr11.prod.google.com ([2002:a05:600c:608b:b0:441:d228:3918])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5919:b0:441:d228:3a07 with SMTP id 5b1f17b1804b1-442d0325520mr59393395e9.13.1746796646289;
 Fri, 09 May 2025 06:17:26 -0700 (PDT)
Date: Fri,  9 May 2025 14:17:04 +0100
In-Reply-To: <20250509131706.2336138-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250509131706.2336138-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509131706.2336138-9-vdonnefort@google.com>
Subject: [PATCH v4 08/10] KVM: arm64: Add a range to pkvm_mappings
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
index da75d41c948c..ea58282f59bb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -173,6 +173,7 @@ struct pkvm_mapping {
 	struct rb_node node;
 	u64 gfn;
 	u64 pfn;
+	u64 nr_pages;
 	u64 __subtree_last;	/* Internal member for interval tree */
 };
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 6febddbec69e..0e30f16149d5 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -264,7 +264,7 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
 
 static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
 {
-	return (m->gfn + 1) * PAGE_SIZE - 1;
+	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
 }
 
 INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
@@ -301,7 +301,8 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 		return 0;
 
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			return ret;
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -331,16 +332,32 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
@@ -362,7 +379,8 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			break;
 	}
@@ -377,7 +395,8 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
-		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn), PAGE_SIZE);
+		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
+					  PAGE_SIZE * mapping->nr_pages);
 
 	return 0;
 }
@@ -392,7 +411,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   1, mkold);
+					   mapping->nr_pages, mkold);
 
 	return young;
 }
-- 
2.49.0.1015.ga840276032-goog

