Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC25C235881
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026730; cv=none; b=DWTekuC+AmsHwfVFCDZTn62EHjaYLeiidRBtWgm87VuPyhlJ8x8oaZbHzA2zeHJEwFmNYshUtnjfno+UW/Oxa43t7FToBPBY9m2DmgzaF4Y/nlaEjK1nfI7Xjv9EeD17KiFvVyfNLutAO9fIO5nXlZ8QhILnYVf2rpWK8b+KNvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026730; c=relaxed/simple;
	bh=93WTzLCk66oie5FDAwVxQF18Hew2J+sHUmJc+JJamG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JlLulBVroYe9IWxuJ3AWCejycd9hObKwKN/crzg3hweXrOBl4cvTdm5cLJ3f3saO17C9I6nTYuRfG4EkKGbyIw9hNzhKdKLj5O2sKVBYMYyw4vCdlWVOMFSNG9VEeFsJqfKySzJ7jk9iO3ty9fVRviVdkwKzPQGK4NF+3W/64hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CapBG8IR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CapBG8IR"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43623bf2a83so8396425e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026727; x=1734631527; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/Ra//4VkvS4Qrc/csXRRquQ5N0sclWFpXtLU13M1U0=;
        b=CapBG8IRq3xKui2GjqENo4buBIAdAkyS6kPeOMa5GGPqngqCTBQTuOzlmzk9xu6XS+
         Q6OdM2toBhpDN0u6OrxCEzLT2zlglfZp9A2kcPOkUx4GWJehlNZeF35BReAPKUgCZ7fH
         z0yQJJtYcKTo5oI3W77dMxIl6xMgaim1se2OUeUL24l5RNUuEGce/STOhQX4YvzQmE0t
         7WlFonepGhZxNox3tfkXWhSp3XnfvjJujrCA0N3HKxBiR8kXOcJ1iY7KLJZhLkAJD7EU
         j5lzGeePjKUNX/3REmgVJKMjSZXUil6rdL9nkXEZzRw32yHIEO8fDEgvOntaED3/ILBa
         QCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026727; x=1734631527;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/Ra//4VkvS4Qrc/csXRRquQ5N0sclWFpXtLU13M1U0=;
        b=D+WuFREiprm+BbZZXyzwvRz1sJQkn6ov6s3qWJeaKR5laUhp6Ghlys7d9KnH4gd5vI
         bNkf7I+b0+daIsPqxXzXr/teeqbeNs7+m/QfLE3NNZ1fCNtmefMpRM4u9QMJui2pTr0a
         BbuJvxAh2xyv1/765AupW7ilDwFgv7B6ESarZGFGh1ieNj+q7FKhsDoznQMT9C3S67Vb
         9bWNyeJGkQlW1r5OFoKr9UAcQvj89MZqDqSMBIvE+O1uNnXnEmvD1XaWB17rkiaEzm7l
         3E5K5+o8+OtiEE1W0bDstwm/J7UA6VtNm79+tVEIbEBDZsALVZF7ez7nHgc0bgqjdNqg
         sb4A==
X-Forwarded-Encrypted: i=1; AJvYcCXqU0VAxNGcYPHPbFke6D4Tv/FtbA/N4w8KO6MZ2Euj9RA6EuHhFSGV9U0A6WOdgdGSekpUiMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoXv4qkNeSq8GumPvLzOzrCkTREFTusHOxkeIJjlM/71xmbYa3
	jDHhe94FBSDpCdlMGR0GQ1MsWlARmOdLaeT/nh0hKvWmSZI+wT256eBo3YH1SrajVotnjGsuvLS
	wBZlV9DWG1w==
X-Google-Smtp-Source: AGHT+IFrLa5teCkiJUmugRTGmiVyWcF7Bk2iiIesqhTlDV4Jk+wP67mU9JHmnXeWzq6SoD15OWfRPDjTEIR09g==
X-Received: from wmik26.prod.google.com ([2002:a7b:c41a:0:b0:434:f801:bf67])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4446:b0:434:fa73:a907 with SMTP id 5b1f17b1804b1-4361c3723acmr67363395e9.13.1734026727341;
 Thu, 12 Dec 2024 10:05:27 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:45 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-22-smostafa@google.com>
Subject: [RFC PATCH v2 21/58] KVM: arm64: pkvm: Add __pkvm_host_add_remove_page()
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Add a small helper to remove and add back a page from the host stage-2.
This will be used to temporarily unmap a piece of shared sram (device
memory) from the host while we handle a SCMI request, preventing the
host from modifying the request after it is verified.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index d75e64e59596..c8f49b335093 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -94,6 +94,7 @@ int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
 				    u64 ipa, u64 *ppa);
 int __pkvm_host_use_dma(u64 phys_addr, size_t size);
 int __pkvm_host_unuse_dma(u64 phys_addr, size_t size);
+int __pkvm_host_add_remove_page(u64 pfn, bool remove);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 0840af20c366..a428ad9ca871 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -2521,3 +2521,20 @@ int host_stage2_get_leaf(phys_addr_t phys, kvm_pte_t *ptep, s8 *level)
 
 	return ret;
 }
+
+/*
+ * Temporarily unmap a page from the host stage-2, if @remove is true, or put it
+ * back. After restoring the ownership to host, the page will be lazy-mapped.
+ */
+int __pkvm_host_add_remove_page(u64 pfn, bool remove)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u8 owner = remove ? PKVM_ID_HYP : PKVM_ID_HOST;
+
+	host_lock_component();
+	ret = host_stage2_set_owner_locked(host_addr, PAGE_SIZE, owner);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.0.338.g60cca15819-goog

