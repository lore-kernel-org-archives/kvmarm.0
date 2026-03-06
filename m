Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F173ACA4A
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805760; cv=none; b=WGn+Hs7J1T/RORaoi3Sgf5oNKF7CbDaCS2C0PBmFXGuBpOSg9YxXA2w34uBzQmOmWibdwRSJy4WYPbO+phZLz6GUaBWN7QPMI4Gx9ZglG92zGsW5Ra5g8gGgLLRrRYlgJQ1MlqKkAGcLXUot9vV4WVfuF0zJF3ghJ/z1+xwOtOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805760; c=relaxed/simple;
	bh=y8f3MvZGTGVu8W2ARcgIr5C30UatorQ81Y4tWSzmzcU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NeNgg5KdD+pgVNafNIU3JEW7VkNS1XeJt4VSM3qrPhqm6g9G7Xduui6LIPxSBrfYakIOCyILx3wiQGGjlYGDwXFxPaLS3iUuNsUUlvLN2IOPSluoB7KoVin8tiPjzFwhZ5N7FlJxQ214fZ3q1qPnLq8NqJrk1QjPYD7bafQZYvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yKCYacxv; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yKCYacxv"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-66184f62c28so1859115a12.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805755; x=1773410555; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gF/1dYRQW+uqbPLKzRe8y1L6gtybgCjS8ZQI7GMo3BA=;
        b=yKCYacxvVoT2ifwarSRCrzalemD4hs3SYiHsOrxTgsXxMU/68f5bSbCNL9k1Q7fk4E
         HJnYz0jtGAidUS4lAI02gKpeHARvdXKaboHGbPyszdYS9FFEF7nYQUUMXvELC2Vlisk8
         hJ6Aj/b2liFuDlh9DmCRP2qynxVk5YWq0bqApqmaFoTMYPuUoPshgKnSwe+gT71wy1um
         14jFOT1Y1Y71KrUbFf2pET1fqaiJmo/kGEmPp4eyljKzqwWRJ9VO4vzCvFd5/13FFhWp
         O5XLhk1Q7uoeno0ixmgCEsjWl8poK6fZQ5+9CrjqoQXybciteY+iOt8xdcpuYEQELIay
         65Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805755; x=1773410555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gF/1dYRQW+uqbPLKzRe8y1L6gtybgCjS8ZQI7GMo3BA=;
        b=XBeOue54ES2MDCC24ejx4AWyUCQFp3sgHHSRYmwqlBXiPvbQGGPGH4Rq1i6WXUcJpq
         t8GB6r2uygdeV5gZwGOYHZQUEvdS+oDi9OKbIPLMJSDRdw0jiVLh3cJriylaEE6dac2a
         QxE6EFw2bDgHqwQSn4hasTD/sjqG2SstMtP/cR4Pp0rOofRSTqFleU8KkZM59ONozE6M
         KTqf0iSKsAY5XrZOakCh0D0yqYCow7ELutxnv9MtU6apwKewA8WK+90IIZaJPWPX4QXE
         NfbpitHTl9ccV4pKCzNVorZqdRdGGmwBXmQD/ILPs+bREGDWePRA2AySr5rntHM+7Juu
         P4fg==
X-Forwarded-Encrypted: i=1; AJvYcCVu0sa+/TcZtQHLOhwFf7MaABsHAdOBXgOK+DMkTXTYM0sLzTX1wkqj3/y9q9zQEW/ZzyInkYU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM+p8/0ogTg7SLYLNwVh6aG4MCFF2E2aI3MGitakBkrNtwk/6g
	U5TTyurpVtNW6dk7eIKImZJcK+vK20WYuqUh8FLzoiBdgv2xdk2HvLBXqcd8nbMyBK4x/Ua5RfJ
	BVA==
X-Received: from edge19-n1.prod.google.com ([2002:a05:6402:a553:10b0:661:1c9f:b877])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3990:b0:659:3ff1:58fa
 with SMTP id 4fb4d7f45d1cf-6619d5205camr821175a12.29.1772805754847; Fri, 06
 Mar 2026 06:02:34 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:20 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-2-tabba@google.com>
Subject: [PATCH v1 01/13] KVM: arm64: Extract VMA size resolution in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

As part of an effort to refactor user_mem_abort() into smaller, more
focused helper functions, extract the logic responsible for determining
the VMA shift and page size into a new static helper,
kvm_s2_resolve_vma_size().

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 130 ++++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 17d64a1e11e5..f8064b2d3204 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1639,6 +1639,77 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	return ret != -EAGAIN ? ret : 0;
 }
 
+static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
+				     unsigned long hva,
+				     struct kvm_memory_slot *memslot,
+				     struct kvm_s2_trans *nested,
+				     bool *force_pte, phys_addr_t *ipa)
+{
+	short vma_shift;
+	long vma_pagesize;
+
+	if (*force_pte)
+		vma_shift = PAGE_SHIFT;
+	else
+		vma_shift = get_vma_page_shift(vma, hva);
+
+	switch (vma_shift) {
+#ifndef __PAGETABLE_PMD_FOLDED
+	case PUD_SHIFT:
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+			break;
+		fallthrough;
+#endif
+	case CONT_PMD_SHIFT:
+		vma_shift = PMD_SHIFT;
+		fallthrough;
+	case PMD_SHIFT:
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+			break;
+		fallthrough;
+	case CONT_PTE_SHIFT:
+		vma_shift = PAGE_SHIFT;
+		*force_pte = true;
+		fallthrough;
+	case PAGE_SHIFT:
+		break;
+	default:
+		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
+	}
+
+	vma_pagesize = 1UL << vma_shift;
+
+	if (nested) {
+		unsigned long max_map_size;
+
+		max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
+
+		*ipa = kvm_s2_trans_output(nested);
+
+		/*
+		 * If we're about to create a shadow stage 2 entry, then we
+		 * can only create a block mapping if the guest stage 2 page
+		 * table uses at least as big a mapping.
+		 */
+		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
+
+		/*
+		 * Be careful that if the mapping size falls between
+		 * two host sizes, take the smallest of the two.
+		 */
+		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
+			max_map_size = PMD_SIZE;
+		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
+			max_map_size = PAGE_SIZE;
+
+		*force_pte = (max_map_size == PAGE_SIZE);
+		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
+		vma_shift = __ffs(vma_pagesize);
+	}
+
+	return vma_shift;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1695,65 +1766,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (force_pte)
-		vma_shift = PAGE_SHIFT;
-	else
-		vma_shift = get_vma_page_shift(vma, hva);
-
-	switch (vma_shift) {
-#ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-			break;
-		fallthrough;
-#endif
-	case CONT_PMD_SHIFT:
-		vma_shift = PMD_SHIFT;
-		fallthrough;
-	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
-			break;
-		fallthrough;
-	case CONT_PTE_SHIFT:
-		vma_shift = PAGE_SHIFT;
-		force_pte = true;
-		fallthrough;
-	case PAGE_SHIFT:
-		break;
-	default:
-		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
-	}
-
+	vma_shift = kvm_s2_resolve_vma_size(vma, hva, memslot, nested,
+					    &force_pte, &ipa);
 	vma_pagesize = 1UL << vma_shift;
 
-	if (nested) {
-		unsigned long max_map_size;
-
-		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
-
-		ipa = kvm_s2_trans_output(nested);
-
-		/*
-		 * If we're about to create a shadow stage 2 entry, then we
-		 * can only create a block mapping if the guest stage 2 page
-		 * table uses at least as big a mapping.
-		 */
-		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
-
-		/*
-		 * Be careful that if the mapping size falls between
-		 * two host sizes, take the smallest of the two.
-		 */
-		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
-			max_map_size = PMD_SIZE;
-		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
-			max_map_size = PAGE_SIZE;
-
-		force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
-		vma_shift = __ffs(vma_pagesize);
-	}
-
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
 	 * mapping size to ensure we find the right PFN and lay down the
-- 
2.53.0.473.g4a7958ca14-goog

