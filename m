Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE2623EC08
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026787; cv=none; b=UtyvF4OSG3bgpjtidBcdHGD6zl8E+I5ntrQSDGBKY7siRN/fbMhCq4Ja8QDSjw8xnenKhTcdNP7++FkYnAMC7zBYO1UXmHIkoSG8e+heThPP4YSXc4p4t+Za6TlFDfwI5WwabGybNdcbCVKLTtUY0LLP2LViP5A2/Qayu+ellTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026787; c=relaxed/simple;
	bh=WjYK8lBkcDppUYpM6qoHQwGVDmyvnn/wecx/pxdNpY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rNqbjwbzBdJkL0mbOJBSw8cK30aFu1qc3WD/Vvbde+EtVUVnPVGxKVFCgasEsU/hM1Tp8e1IRrpUHjUesQyouNuMgZb4ayjIkWFx37M19Ov6/d91UZtJn60BNU6PskSIZ0e8wpYiW/eySBxQVUM7ylM7+ad9PJs1/A2MBobEPiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JCjCuSTi; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JCjCuSTi"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43623bf2a83so8403995e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026784; x=1734631584; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o4ydbokuahZg3cDVv89OzbKDX3WmaOYi25/RZtMZGlA=;
        b=JCjCuSTituLBf6lk3JHMeeYE2pymGcmAOZQHd6nyetvKa5Y9e/+r5dLsalYh2/H8+N
         0XS8DQ4o60YKEnpqY0SYU94Q5sfP5/nDUq9mu6fTJiooXLaJ6NyyvV0YgMr4/88/eJYL
         lnZl/wUAfCqBle4djdrgbZa2oQm7qBVoKz0KvdjmI5tKPsaxeS8NowRBO6PWTGZBbhCD
         E3dfJiU0z5Shhi+VnFGHHREuZ953CNJhuTIeIErtj2cunUGlcC9GjylW/YEYLsfotnek
         amM4tw+lrWNLzCusd0qRue8+/2+uwAeBgjWv0nhu4nA4Y5AlrWBHxObvklbw2K8PLLJz
         3c/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026784; x=1734631584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4ydbokuahZg3cDVv89OzbKDX3WmaOYi25/RZtMZGlA=;
        b=fSYR6lfwrdcEazeGjl1K9LxBh/e0AGgdzH/NOcXbsRHET/cJVqKa2uTRgttjVRA6r/
         wjm4zvhJ9FxTowQHX/C2fPjg7UDnj+ULRLiPNDge8ZaO6qt+Yrut08ZDo5hxhaTV4rVy
         Kl9oNnbusdF19FJj4suvmp2lv7CIKpH7fapTiN4uH+UlPqDE4InYvG+s5BH26skZDMu9
         VzripihvV7r5CE8DB//s2FSGlwV7HdNvpnxGCrXpkG+TmcJF3LWkSXRJ5/Zay1bNkVH4
         RJ8zh8EyOHlnwHoOIZfKfn6u3fJFR4yfQCzVE0CwT1wJi139rlBkddhTNiSFq9Qi7fXi
         lU4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxgvXzCidXMkmPYOvOqRKAKfvM1/yE2qZFwyEBQPk7ia3Ql2BOJWjs1VQOfElVuGClSb/C5aM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzi1VAvKR7C6Cylst6tlyHk+aed5f+5Vw0c2C4/p7lKzh8Vy/T+
	pJxbLsDZoHDDnTwTKAD34Am+Ge23Ea4tMO6Wo732gx67Z+Qh4g1JO4vkjrn4t9EGjU8ouU6ZQKi
	Vy4+0wEIseQ==
X-Google-Smtp-Source: AGHT+IFIxg+lr22IOTf3dy5thifj/3GcNWa+J/d4+646pOPogroeM/O6SnmhU5jaKgRShKweTmltoDzKqk0iIg==
X-Received: from wmph6.prod.google.com ([2002:a05:600c:4986:b0:434:e96f:86b0])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35c9:b0:431:58cd:b259 with SMTP id 5b1f17b1804b1-4361c42e361mr77955515e9.31.1734026784111;
 Thu, 12 Dec 2024 10:06:24 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:12 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-49-smostafa@google.com>
Subject: [RFC PATCH v2 48/58] iommu/arm-smmu-v3-kvm: Add function to topup
 IOMMU allocator
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

The hypervisor returns requests for memory allocation in HVCs
encoded in the return registers.

Add a function that checks those returns and topup the IOMMU
alloctor in response to requests, and a macro that calls
this function around calling an HVC.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index e4a5bdc830bc..dab2d59b5a88 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <asm/kvm_pkvm.h>
 #include <asm/kvm_mmu.h>
 
 #include <linux/of_platform.h>
@@ -28,6 +29,45 @@ static size_t				kvm_arm_smmu_cur;
 static size_t				kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
 
+static int kvm_arm_smmu_topup_memcache(struct arm_smccc_res *res, gfp_t gfp)
+{
+	struct kvm_hyp_req req;
+
+	hyp_reqs_smccc_decode(res, &req);
+
+	if ((res->a1 == -ENOMEM) && (req.type != KVM_HYP_REQ_TYPE_MEM)) {
+		/*
+		 * There is no way for drivers to populate hyp_alloc requests,
+		 * so -ENOMEM + no request indicates that.
+		 */
+		return __pkvm_topup_hyp_alloc(1);
+	} else if (req.type != KVM_HYP_REQ_TYPE_MEM) {
+		return -EBADE;
+	}
+
+	if (req.mem.dest == REQ_MEM_DEST_HYP_IOMMU) {
+		return __pkvm_topup_hyp_alloc_mgt_gfp(HYP_ALLOC_MGT_IOMMU_ID,
+						      req.mem.nr_pages,
+						      req.mem.sz_alloc,
+						      gfp);
+	} else if (req.mem.dest == REQ_MEM_DEST_HYP_ALLOC) {
+		/* Fill hyp alloc*/
+		return __pkvm_topup_hyp_alloc(req.mem.nr_pages);
+	}
+
+	pr_err("Bogus mem request");
+	return -EBADE;
+}
+
+#define kvm_call_hyp_nvhe_mc(...)					\
+({									\
+	struct arm_smccc_res __res;					\
+	do {								\
+		__res = kvm_call_hyp_nvhe_smccc(__VA_ARGS__);		\
+	} while (__res.a1 && !kvm_arm_smmu_topup_memcache(&__res, GFP_KERNEL));\
+	__res.a1;							\
+})
+
 static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
 {
 	unsigned int required_features =
-- 
2.47.0.338.g60cca15819-goog

