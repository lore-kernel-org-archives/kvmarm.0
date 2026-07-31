Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24E03E6394
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508560; cv=none; b=pyr8PReRuWW738IBERsmWmJtCA/HolcRlELdfWulN7ZzRBNk593XIYycrZ/RbFhmOR4k5UUcNnTlcgpCZ4HdlJ7wIhiTRfysSI0WzxX9GpkAc0PhF7nlWk03b1yWMAzEI60jCWlI+/B7/VrGB1Z54spLCNbGqPdMB/Zs60on4yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508560; c=relaxed/simple;
	bh=XW1auDDIcjx8Ny46UOkDqUuOnf0h31eQn1gdPSZCZoo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I1irS8FpAhF5Ao3xUHxzhaYr38E+lzUWN3NPeAOOCqyGHjObhtCnGyemuTMi14JjRUfK97iuVkiLf47LNZN6ojrdaAlU2F1Lk01Uy4+QC4Y3/apphSxpPjIunYL1uq3hFAaU2EGOO4GqL4xBT8X3ZT5ULsa64gWyuu/I577qIV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S0MMaI7J; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S0MMaI7J"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c16711b9473so96594266b.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508557; x=1786113357; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lKi6HMFpVp4U2L12wskEYdbDPkWmxhJhyzLsERSTZtQ=;
        b=S0MMaI7JVF67S64XsgJnij8CFmYd/bNIivrXENTh+M+6aZSR07gQfd9YDUpaXHQREh
         iZyYkzBwMOi6WN5zZxVqTOMRU6exXduL1vSaPP5IEY9TGN/ykII/SYyLvd+ukjJR9go7
         Q2Zw0059MATORcoUKprvZUH18mPOuleoZByh6GoBmNy3Zs/DJtiUMhjHzYkC2hBHr9Jy
         5t/8KlvecVCtdXqldzPyGOhuVkSnjrcwynMPG6LTBEGurf7YSHEgMaM7WhCQKkyhvJV9
         hMD+kLMIx871dbQmuU4OYXFvpVS1IXswP8a6uP+WVgcE4mG+uPbKNF4bATYPibCL3/a1
         NP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508557; x=1786113357;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lKi6HMFpVp4U2L12wskEYdbDPkWmxhJhyzLsERSTZtQ=;
        b=bRwriB3TkmJss+ImwSU5lGKUu/HkIcb9XhDil+vaVijtAKSd+ThSWN3eylot5heAWB
         az6NNx1kZBtygR6v8kXpDv52vTeDEAXplDaQcQMrF657hxEuX+ONspI872neLfyYw76p
         YIk/kGGQWtoP+XGdhm3wpSbjeHFmLv1LpUoETBViacpMqeYJWMUwwvaw8QWqsKfajHsi
         ZTM3kUol0M/0q8Y8g7Aw3xw4MVSJEImcQvPpV0Azbeyc7tZBo13iv4koWQH2nnhTpFBI
         vbE18ZtCQKHKjGwWSHw5pUB3GojlwJxQKbAqD/GH9UrT+WdzF3s516NNFFBSiXV1hdmM
         5LMQ==
X-Forwarded-Encrypted: i=1; AHgh+RqMfP1+2XM8TIhpqD1AxMAvaA5p2neVITTcsK4uDOOk1PFmHYiesfKbvc1Ux9o8Op6X0EC21O4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSHvKzM3hvbKXknqJpigo32/szkKYWxM+ymkfYIlzmnYmlIn7Q
	UHdpVTiD3T0XqO+cut0nYv+zM0PqoDFEJw0GVfNB6SjEuAXMNRVYTaw3MePwoYZlvtt15033GXU
	PGveCMQztBvtqlefegW1JNQ==
X-Received: from wmte19.prod.google.com ([2002:a05:600c:8b33:b0:495:59dd:24f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:8993:b0:c1f:5315:7334 with SMTP id a640c23a62f3a-c1fd2581a6bmr132672366b.48.1785508556775;
 Fri, 31 Jul 2026 07:35:56 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:26 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-3-vdonnefort@google.com>
Subject: [PATCH v4 02/17] KVM: arm64: Add pkvm_remove_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the counterpart to pkvm_create_mappings(), allowing previously
mapped ranges to be removed. This will be useful for the upcoming pKVM
heap allocator to manage its private mappings.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 85f1e3c711d9..00cadd13ee5d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -25,6 +25,7 @@ int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
+void pkvm_remove_mappings(void *from, void *to);
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 755630c0d15e..9ab7f613fa36 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -164,6 +164,24 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
+/**
+ * pkvm_remove_mappings - Remove mappings from the hypervisor page-table
+ * @from:	The starting virtual address of the range to remove
+ * @to:		The ending virtual address of the range to remove
+ */
+void pkvm_remove_mappings(void *from, void *to)
+{
+	u64 size;
+
+	WARN_ON(from > to);
+	to = PTR_ALIGN(to, PAGE_SIZE);
+	from = PTR_ALIGN_DOWN(from, PAGE_SIZE);
+	size = (u64)to - (u64)from;
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) != size);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.55.0.508.g3f0d502094-goog

