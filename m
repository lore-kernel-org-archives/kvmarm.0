Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A533322ACE7
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014467; cv=none; b=IwUqQe+A6FClPKo72XNd+sS12O05ARFwBDPF5d3dkePDmQTXP6c5VHsyw+msCw5VAP5JKLECVMViqyT22moeMzQzdMjuh84I+YeLA79wIZW5nCyIgWwLGQ3JRxuehDZ0X2w589639Wm7b1MY+CKm3IwWn+Aq++s8M3r2d9Q+4Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014467; c=relaxed/simple;
	bh=rRDWSNiDbUJlfZy9PmaLhkSM7WHLSK39I68boJ6Ez1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o4+BH6QiVgqjpx8ETSTEf78bHbhqHEGY7/spAEx28KeoKlHM+m2wBNVHFx+dwSNPAE6fva2rL+p5nGzItHV2xLQj8hs5ByhB+UZKtAX4EfP9c3EUccuWqE9d6TWQYsE+G7CEf3PAOCD2FALKhIjVRbGI7R80Y9awwS27+HV6u0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MlF/jyaT; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MlF/jyaT"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d733063cdso33715405e9.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 01:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744014464; x=1744619264; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkIkgXtzJydgYT4Aq3qFZ4/IxfJ3oybUqKkE6SsWBu8=;
        b=MlF/jyaTYqhE7zW0tfDCeo8+6XoP6PaknYp7uy+LHmZhqBoqc6eGr+9FIC0YF7iYMa
         KnHOZjXaInWcZ5aGwvVMsctasGWaI6fXfV008oHyBlbwWl9W/ubpB3sPc51aaEcCwDtU
         QvqVDiN7wU15oVGsYUtlVqN1t2qe5ZSB6UyzJooKiY2kXpV1WGYYNXKrMk+pwvSjBzpK
         IBZKu6xMHXgmxJJbozT85WwZVhQ+xLtxBToxNY128huWGr5VCUq6ANMlrbwZdnDlivuy
         7mm6s7Sas8ectOJ+5sDq3D0UQpwx6WrL7mOIJeQthoHomI/QUYrt0iIjwN0WjcX5+P1y
         QZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014464; x=1744619264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AkIkgXtzJydgYT4Aq3qFZ4/IxfJ3oybUqKkE6SsWBu8=;
        b=pcNqtNhveCqn/A1djhdsMXFA0yoDqm5D+D2SmZr5uMNpNXEuitkLeoByEZX1WuZsKi
         IA1QK0q4QbL8X158dr55smQ23Vg1Cns1IMC0v5Psc0ZdQ4v8pm0i+Ft75kcETrN+vvuv
         LoeyoyA4uL3YsNwWPGrux+CuYoLutbsdFtY4ieIvZWwIMGQsQqI2Z7+bdCGHhjpZgfj5
         Wy0uotcyrb1OEkContpPig5MX/jQS6i54ACy/3zUJaZBBhpfEkzZS1mDXFbEp+OO7h3t
         Qpomf54lfns1WOfzUhI4IEWTzfjeMT9YuaL6T4C35bYsCPU1IxgE3Na4o/C4C0+esLng
         MKxg==
X-Forwarded-Encrypted: i=1; AJvYcCVZFeWghey3gWAa7eeXogq0FSUJSVvhOm09p8x8xibX+Qmj0f9eYGrF1z3irSE3W7zA3cdtfTg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmrsThrx4Ov/FnoxoiZrXMszVCkjXJXxpGrYrczchSiyoiJMGu
	LXHFaFdqZJtfsSbRBpjOlDbh5fqj6+c5AbI6yuWwi8DbtoEykep6J3IkYyL2Us6QUuqsHaRKxUJ
	+ffEsflp8q22H/Fm6GQ==
X-Google-Smtp-Source: AGHT+IHHzlQ1gVc6d7i809HTCyxXwQG1q36o9QITFKS+Njq3l4/ScwwfjO7m2fkiwa4OY68/Yp4JeYb+QP2ZKtM9
X-Received: from wmcq28.prod.google.com ([2002:a05:600c:c11c:b0:43b:c336:7b29])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:354c:b0:43d:745a:5a50 with SMTP id 5b1f17b1804b1-43ee0694b57mr58544285e9.19.1744014464185;
 Mon, 07 Apr 2025 01:27:44 -0700 (PDT)
Date: Mon,  7 Apr 2025 09:27:04 +0100
In-Reply-To: <20250407082706.1239603-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250407082706.1239603-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250407082706.1239603-8-vdonnefort@google.com>
Subject: [PATCH v3 7/9] KVM: arm64: Add a range to pkvm_mappings
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
index 5276e64f814e..135df9914cca 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -167,6 +167,7 @@ struct pkvm_mapping {
 	struct rb_node node;
 	u64 gfn;
 	u64 pfn;
+	u64 nr_pages;
 	u64 __subtree_last;	/* Internal member for interval tree */
 };
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 08fbe79dd1e4..97ce9ca68143 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -281,7 +281,7 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
 
 static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
 {
-	return (m->gfn + 1) * PAGE_SIZE - 1;
+	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
 }
 
 INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
@@ -318,7 +318,8 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 		return 0;
 
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			return ret;
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -348,16 +349,32 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
@@ -379,7 +396,8 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			break;
 	}
@@ -394,7 +412,8 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
-		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn), PAGE_SIZE);
+		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
+					  PAGE_SIZE * mapping->nr_pages);
 
 	return 0;
 }
@@ -409,7 +428,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   1, mkold);
+					   mapping->nr_pages, mkold);
 
 	return young;
 }
-- 
2.49.0.504.g3bcea36a83-goog

