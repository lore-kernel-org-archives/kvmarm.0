Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62DB2E2298
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640347; cv=none; b=soDKdpDe4VaeYmi9s5WhSk/WsT9u3WXX3mxVjqjWCszDAo89Ll3qDTZZOyAOuebFsk6FwYZjs6zCdsOQiCgHZ6BXRGxHYvs4tqCpsw7PHEDinRT0LR8vUibV4zZLnpwxojvosu3FAJE33igg4weoSTZz6H/BV7ZY/tJfrGThdW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640347; c=relaxed/simple;
	bh=1DQlyjp3Ypyw67ZtM4RckxS+tfIALxj62mzUclwfeTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dMYYK+l8z+UaG3SQILD6Kha3Ct9cbaM3320q2Z8GpyvT0w2Q5BfdAqBaAtZel/IRPP1ix5Ws2yV+lLnew/6aC7/mVGNIgx6a+01n7wJ/0ZpL5pmN8D4qI8fXv9X5kk08AIq0oUZyzmVDFuvJTcdM1HDNNaMQqorsNh+qEJj+2vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sb0fo88D; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sb0fo88D"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b9e418a883so2173219f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640344; x=1756245144; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ioxZ9+DNy86koGENgFZw7NoVqbAVt0aWywoB+DgYjJQ=;
        b=Sb0fo88DrZDlfqBulUmrcMniVtHbmvVVzSTqXxWMh6jj7KmAkxAlxJjv+L05/r8+oH
         2sDD+SNZynVjqAlqmeA7xYEm6hQGisbXLkAlOPe4fynraRtkpEgW8qiWSAgcLZC4nHV9
         ZNBtNGwuobFF6w2Y95odLDW+zaV/FeD38VTJjaA761wYed9xOatLowNni8ykorRiFFge
         rnOAfIG1FcGt0EClujYSKjpySd1w0QRsxdOWl+LYk7yUokDSlTgxFNBMVi0J9vWdstpj
         nYJLK0rY3o6QV4v77o4PqiHi3jTgekUl755j1H0mWSEdqbJ2xZrTgba84bNr+hwFa5V8
         ab4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640344; x=1756245144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ioxZ9+DNy86koGENgFZw7NoVqbAVt0aWywoB+DgYjJQ=;
        b=ua6WIBKnNru5tcQHgsu6CHWi4WvxfwgOyF6ZRt3YzIlQzRCAnbFaIV8CDfswlAQhqB
         QeHdyuKJALnhSlVwEhjrCfwLzdayRiTyxL4Zl4MI/aYsrE9RFCdox8dV5/3SK7UJ40Jo
         9uyKUyj/2BBIpWRaAUUa0NNPjEC1PxSnLqdIJg8Q6PRuWhFvmckCAr9ZeqDWaYHBm8Ur
         HXYrO+ftNF4lV/FMQ3QTxWholS3EbhHnQ7I2996Kxni3fKAsCEr7HYtzIrM9rC4F9j5d
         5I4jDu/pzEGbavNSnqSKYOy0Q9SsfUOgLwA4fb/h8XzWYbXrmrGi7zUb1yaC3505yfhU
         Sy5g==
X-Forwarded-Encrypted: i=1; AJvYcCUGRVXmRx4QppO1QeGJXSQ6CTGMH7QAgIPjlpH/iGqwNDxC9HoOspz5KUSjj7GzGxTBLWisbEY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgdkhiwB5Z3WDrmjbq2lQSER+MCAwQuXfaELWkNm8+tuUvZYus
	1aKu9VLRlxRaMh+v+9PJcBHJct29OAAfwFWisek6IfWRXp5+vpn5Y9RUf3eM5uroVzoeSFn1LR3
	Pv5utTgai9wEtMA==
X-Google-Smtp-Source: AGHT+IEHXpWg/f+rEUO60O9qrX4vZsfY84WtfBBV4+NcwjtcLonZ2Ky7JZEiBzijF5XkyOmNGYqUgyc+J4F+Sw==
X-Received: from wmbfa5.prod.google.com ([2002:a05:600c:5185:b0:45a:2855:e836])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:438a:b0:3b7:b3f2:f8c3 with SMTP id ffacd0b85a97d-3c32ecce5bfmr288271f8f.57.1755640344145;
 Tue, 19 Aug 2025 14:52:24 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:29 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-2-smostafa@google.com>
Subject: [PATCH v4 01/28] KVM: arm64: Add a new function to donate memory with prot
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Soon, IOMMU drivers running in the hypervisor might interact with
non-coherent devices, so it needs a mechanism to map memory as
non cacheable.
Add ___pkvm_host_donate_hyp() which accepts a new argument for prot,
so the driver can add KVM_PGTABLE_PROT_NORMAL_NC.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 5f9d56754e39..52d7ee91e18c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,7 @@ int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8957734d6183..861e448183fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -769,13 +769,15 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 	return ret;
 }
 
-int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
+int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 size = PAGE_SIZE * nr_pages;
 	void *virt = __hyp_va(phys);
 	int ret;
 
+	WARN_ON(prot & KVM_PGTABLE_PROT_X);
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -787,7 +789,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
-	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
+	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, prot));
 	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HYP));
 
 unlock:
@@ -797,6 +799,11 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
+int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
+{
+	return ___pkvm_host_donate_hyp(pfn, nr_pages, PAGE_HYP);
+}
+
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-- 
2.51.0.rc1.167.g924127e9c0-goog

