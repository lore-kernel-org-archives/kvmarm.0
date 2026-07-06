Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7A8233926
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360469; cv=none; b=IaodxcApFutg2+MVFghOCIYspqa2na2Mcg4eoxJJSP7SRe1xTcmtdJkafZI7jMrViuPWuBpfuKccVfAPWKCT/hbJqcVvqhIJ+MfEMWH5JpEqEo87nXx/49wi6kh9crLsMsudDjjtkrY1macdRLj67bKdALd8bvKcyGi99mw/tyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360469; c=relaxed/simple;
	bh=Suiwtf0sggSRJTZqCoIqwLmCssdPO6PNsZ12uInzyoA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pvNaPaUSUXamZ1ub0INnq4YKeAQi0eu/WBhBwkiufrkraKD9KCL5nTMnvpbWl2wKPT1MQ6s5J88zF/L1TMqTd+cO3aw0ZhQtQWu6FquBAefXsnEL1Xw/+6QJehXjOmraxuaoluzAdhNggTpZv7fu8oeYUn2kwZ5S5irhnnJ+YaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKW79fxI; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKW79fxI"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-472a798fc7cso1619762f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360466; x=1783965266; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jRpBPCfFRyioPG8rK+sBd/OfEwOTtyraMttaVaNP7UE=;
        b=sKW79fxIXmoQkZ4j0Agsdkl+KGE/qJoOeEEIxrbQ37bZEMtREronuCDpNbBIh4b/Gw
         0aL867GOeGpYwksg4nAegtZu+9ptHNA30zVtbaVAK+fL8qAHjOLurAh+IfsxASM29hu6
         sLzxUuUF6ISdmbqp3+mzTmGTh+0wkcWWMCG3poz6d8elq/UVjAT5hlXTdvNgjIek99QM
         o9sR85LLdIxVlqZwANCSsFeLNwdxZosROJwAYN/cbmGAgYNkJ9BMHsEwEJELkstqmavo
         0yUhqqAn1+9YXJikVqf+HNEYNL7p6g0LHd4TBlhxRo/jwywtc57YgDCM9u9nwFCLq7rr
         57Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360466; x=1783965266;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jRpBPCfFRyioPG8rK+sBd/OfEwOTtyraMttaVaNP7UE=;
        b=ZhkpPtbRdX5/59M5TAKtifOa2sfv3V1OkYxNq6vntfD/SCu3HT74rDmfi/lXeSihj1
         0vbOcn9behylhyND2moKDpWiOrjoKbKUdXvnCQ1Nl+8qkr/9+sDiY5+0zkS7UZAIw1hV
         8YxpnMEgLFWv3ysvY/V5yRY6sS0+Bdeov90OWjTbAqieJpEcu6lGuT2tEEoVmzSXJou2
         RyNXBb/2afrPYaBJtY+tDV2xHrcGC9g8t5C+8+xnBPKfyguKMXMWpwzKL9KmgQxr3Urh
         9TTHGJGInSndhIGDHjTwup3fjwA+L1vleokz/0yypdW3YTU1asfF51nVgAlwf3fjwJ+J
         5wXg==
X-Forwarded-Encrypted: i=1; AHgh+Rqb1uU8yGiIX4ttkR3H+armXqc3OTu+L13bfKHj6WkI8ccCa7TPZ8phBpLuJOUrGraBtn7Ablk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjBpvTB1xdPkeqWdl30yg2uw+GftVzTHEWTsuSDqlD+LqnFBNp
	hMSdx1G30KNlxrVW/gqBOgLIVDlqB4AyBDACn0VEsrqY7Ez+kJL55hweFgXV/LvD86vTy73xEf2
	O1YTdRv7396P0jNhPyGT1hg==
X-Received: from wrbdj18.prod.google.com ([2002:a05:6000:b12:b0:45e:f31a:842f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:25c2:b0:475:f0f0:9ec6 with SMTP id ffacd0b85a97d-47de6718117mr1506948f8f.49.1783360465417;
 Mon, 06 Jul 2026 10:54:25 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:00 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-4-vdonnefort@google.com>
Subject: [PATCH v2 03/18] KVM: arm64: Add __hyp_allocator_map for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for the pKVM heap allocator, introduce __hyp_allocator_map()
to map a single physical page to a given virtual address in the hypervisor
stage-1 page-table.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 725bb0fb941d..98a7774b541c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -32,5 +32,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
 phys_addr_t __pkvm_private_range_pa(void *va);
+int __hyp_allocator_map(void *va, phys_addr_t phys);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index ec59da1322a7..c1c01f81ac5f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -160,6 +160,11 @@ void pkvm_remove_mappings(void *from, void *to)
 	hyp_spin_unlock(&pkvm_pgd_lock);
 }
 
+int __hyp_allocator_map(void *va, phys_addr_t phys)
+{
+	return __pkvm_create_mappings((unsigned long)va, PAGE_SIZE, phys, PAGE_HYP);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

