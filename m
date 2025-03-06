Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45AE20B1F9
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 11:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741258863; cv=none; b=HglDxnzY9aUTSi/Vg8FG4dZQFlO4egAK1MRj3otQiuek2zlrohkg+kPPj6fIcpg30uKiGd8wdy9JWEtI0gmRZilQ5MKhu7VRqCK4JIuH1S8Jyi/qgQfLI+xtR3xgiWubdcsuD1NVfMe5KTltXxNONU3i9pQ3Q4kWAKItupFl5oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741258863; c=relaxed/simple;
	bh=8CXJzd3bdWnUUiUgEqvdbCvJOrcXmt4cgq1d60RfuSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TbD0/6aR1VFw0J7G27ojiy9htwu3ebo8u4GykFlRT3zQBLY4L+6L6ORqV/mrWmxw+rBK8IZry1ECM6TsZ4qho2ACkSJuBPksOAyQMFVg+1Q7l296iSJVopopIo1zz8vAZbOVE/mvJ+pN93qNQm/mq7/kKmY+2reiR9RMlPRji4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=czsecFRj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="czsecFRj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43947a0919aso5077785e9.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 03:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741258860; x=1741863660; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qXik8AjbYyPYjDFsjvp2RmgmvxUrFId1oBHnRgszILo=;
        b=czsecFRjTV7TtqmCNPoPYDRsvGruxQpaNWHDA09dkCzv9jq4cY4zjdG2d0UlsBTs13
         4HbGyuZAGrf7PQFyG1EuvllxezZzoxXvhkm6l1wx27hU9nc2xX6FPQcpsuYEe6EMoRw2
         rF2sXcww6ddNTCT9LC6xOLBxclZSgOi6IYHm4p/lY0N1RSM/uDp/pkH/bCsPpOPhLj6Z
         5FHMBs4APAJvZAsHjdG6QY52PrIwa7uc5c/XhveyyDi9YFfzVxZ56ubuepPdqhx4LbR9
         jJZKrePXTycM+yTxv/wSrtmSe1t1KrllDtgfyuBoXRf+e1Fp1apbMgfUqBmprV/lrdTu
         jyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741258860; x=1741863660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qXik8AjbYyPYjDFsjvp2RmgmvxUrFId1oBHnRgszILo=;
        b=Hv3DZYTE2wJJCcoLsOnfXbXllZakk5g6pJWGxDUybiPy8nhVDM3f+hRYR75iIw/xHo
         ZqHXqLMtvBUQfOHOQTEK2Jg18HWodb65jNGe880SSsz1FFyGhY1ltmN/LoJPcNn7GCSv
         EoUnbmGVVQOrjZFGfnnyZNfr+db7dcNLSP3Pb7YQRBHWr38NZodaBKYA5RKPYorXBvDi
         J2jPxL1kJz+L+1ABHP5egy3CGyl27GYLI3l/V+cwulJyBsIkBpRxqx71g54Me6Bg43qV
         7+9XSQhT6x3uZUg07yneluO7VAykvW0JVaEg8nGLzNOvr+McZfSVy4N48ZiKY5dYMSPA
         nKQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXo0iYOlInuFUFB/hd6dvBSgNNyPWaPfxyG4q5wUEBh6sRoMPmZCaCbSyYuU25DeGaNzY39ZUE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXN6ces+HT0MlHCxOx8eCw6ESIdUo46GmobznGF0MMmn+lFvCT
	SAq4x3exktWQesxr/mgMDyNSUKK79YSQDxU1lRzGAMThhlHSbfq1QISNW99LLJmg/DEsYU2sz34
	tmb8dT444yFuQyPuGAQ==
X-Google-Smtp-Source: AGHT+IG1zpmCoE47NgJOQQ1JcAF2Bl3oBRwYgO4WaRdecPq4Be2Q4d+PX+LTxNRaXoONJrSQGsIXYlKSmDSqbhOe
X-Received: from wmbfp6.prod.google.com ([2002:a05:600c:6986:b0:43b:cf2d:8027])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:198f:b0:439:9ee1:86bf with SMTP id 5b1f17b1804b1-43bd294309bmr67065855e9.7.1741258860152;
 Thu, 06 Mar 2025 03:01:00 -0800 (PST)
Date: Thu,  6 Mar 2025 11:00:36 +0000
In-Reply-To: <20250306110038.3733649-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250306110038.3733649-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250306110038.3733649-8-vdonnefort@google.com>
Subject: [PATCH v2 7/9] KVM: arm64: Add a range to pkvm_mappings
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

