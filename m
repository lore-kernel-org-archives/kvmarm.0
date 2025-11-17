Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81DB33CE80
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405326; cv=none; b=ZodNcI9YPg8R0DMVMo+NJrp2gbEbF/353vOkWWi1wMu3LhEulGj+d3MO2WxtWT6sV9O6PqluLLQBzNw6sLEix/ILYgeSMIduJ4C37PZuOyYTSxWgEfNiz3lyW0aBv9X1vYCpnkiqfVUISOzoSsuW+C+xvs3LSy9WeAY+ddtvxZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405326; c=relaxed/simple;
	bh=iLqOj/XaV65ljxTgcZoZCOXuA7GIKuDSXUnmXUF7ZCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dE08QsXvIzwHBYNAdoIa8HTvXMCgnUN4FAJafGNiwtKA2PvLImT5Pbg2p8S1GC60aqssrmx2xdg5itk44mf+w+nwcvUA+bFiv2gcP7lFKPPwRnnymLdpGjutc3VzxzsFNscR28bod/D5VZAiWjS2u5BakGxKcajiFZUcVEiAIBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H54cau7e; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H54cau7e"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b570776a3so2228297f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405322; x=1764010122; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HZRHy3svuNchmJFYToVRnx2mDpnN1m/iPQ4+pK/3fxU=;
        b=H54cau7eEDJBz/9FPqeV9aA1OUNRB5DwxVjUkeQxP8Uwt3VXmxuwo9wEKFyvpe5trQ
         yrV0i/y6HPbOpu/iI6rjGxPxX/qFb61Qktn3NZ9t19Yipf+pKZZT4T+yxcMDm1WbwdYT
         GQKKaUtlXre++IC+RIAGqaAtRASLoIVwHgiHNQzdjFfzsuzyroj7isdbaGgTrcDDCxL3
         tMex6wvYaxQ+4QT0AIRxVWpqSQ6B+vPtU+TZYoorVT1ys/UHrAVNDYwVgVdC+faiEhBp
         /iuSmenD87qDmLctMirZejwZgnl8R2dT3ACnUp98OXqe2xOrSQiGDEetYpBm+1RpDHH8
         YZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405322; x=1764010122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HZRHy3svuNchmJFYToVRnx2mDpnN1m/iPQ4+pK/3fxU=;
        b=JQApG9EssEAoR969hexAFTF9Am2EiO51THoNO+5tbEe6s4bUw+HUthGY6j2V7fCR3d
         Ns9lH4IyIpaczNTy/v3OWbgKAkJjhFWMGw699/hQILTmMOeSXW2W0iqjSMUapEi8RvlS
         ijklz1Zr4/ecZQFcCtpnJNqcCnvBYlJ3cJU9yWXnf1ziHR96K/sS1YOS8wWEeKAKTE0A
         sRgKCewbsGNHFoVat3C/mIoQUb8Ewzk28FJddeUHTLbRbBW79LL0pyd966UU2kZs9xn/
         9ip5klUzS2ztEy8l+DQS9Hh8Kw7VA9aOzI5duy8mtZES52pNimE4LTy/uJBkmHr2lCJX
         FMtg==
X-Forwarded-Encrypted: i=1; AJvYcCWF+fkBYYlq5t1he3xh0Ktx8AtxyGrlwgRNc0SHWLpL0SlFo3YfQ2mf833kT14id61xHubIyvU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8SLO8nNkjd5Oku+Z3EkTl1vIm/bq3bNtiMGHB9iu8qshqdlD3
	ddSwU62m5lwTe2r/GMf4I7pyl+5548Su1PJ/6IWon6WUNpvGmt48AZJTaozDXm4rYodX6AllpjG
	AoeUVYoF8GsgXeg==
X-Google-Smtp-Source: AGHT+IEzcJDMw53+AVSQNytxPGimAg5Et4Wx8256qZ8eJwNoP5G/5wvwA6REx65+VnhZk9Fj+izitvg/zOxMdw==
X-Received: from wrpz8.prod.google.com ([2002:adf:f748:0:b0:42b:32f2:9092])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2509:b0:3fb:aca3:d5d9 with SMTP id ffacd0b85a97d-42b5933916bmr12787870f8f.1.1763405321905;
 Mon, 17 Nov 2025 10:48:41 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:03 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-17-smostafa@google.com>
Subject: [PATCH v5 16/27] iommu/arm-smmu-v3-kvm: Take over SMMUs
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Donate the array with SMMU description to the hypervisor as it
can't be changed by the host after de-privileges.

Also, donate the SMMU resources to the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 81 ++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index fa8b71152560..b56feae81dda 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -7,15 +7,94 @@
 #include <asm/kvm_hyp.h>
 
 #include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
 
 #include "arm_smmu_v3.h"
 
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
+#define for_each_smmu(smmu) \
+	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
+	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
+	     (smmu)++)
+
+/* Transfer ownership of memory */
+static int smmu_take_pages(u64 phys, size_t size)
+{
+	WARN_ON(!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size));
+	return __pkvm_host_donate_hyp(phys >> PAGE_SHIFT, size >> PAGE_SHIFT);
+}
+
+static void smmu_reclaim_pages(u64 phys, size_t size)
+{
+	WARN_ON(!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size));
+	WARN_ON(__pkvm_hyp_donate_host(phys >> PAGE_SHIFT, size >> PAGE_SHIFT));
+}
+
+/* Put the device in a state that can be probed by the host driver. */
+static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int i;
+	size_t nr_pages = smmu->mmio_size >> PAGE_SHIFT;
+
+	for (i = 0 ; i < nr_pages ; ++i) {
+		u64 pfn = (smmu->mmio_addr >> PAGE_SHIFT) + i;
+
+		WARN_ON(__pkvm_hyp_donate_host_mmio(pfn));
+	}
+}
+
+static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int i;
+	size_t nr_pages;
+
+	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
+		return -EINVAL;
+
+	nr_pages = smmu->mmio_size >> PAGE_SHIFT;
+	for (i = 0 ; i < nr_pages ; ++i) {
+		u64 pfn = (smmu->mmio_addr >> PAGE_SHIFT) + i;
+
+		/*
+		 * This should never happen, so it's fine to be strict to avoid
+		 * complicated error handling.
+		 */
+		WARN_ON(__pkvm_host_donate_hyp_mmio(pfn));
+	}
+	smmu->base = hyp_phys_to_virt(smmu->mmio_addr);
+
+	return 0;
+}
+
 static int smmu_init(void)
 {
-	return -ENOSYS;
+	int ret;
+	struct hyp_arm_smmu_v3_device *smmu;
+	size_t smmu_arr_size = PAGE_ALIGN(sizeof(*kvm_hyp_arm_smmu_v3_smmus) *
+					  kvm_hyp_arm_smmu_v3_count);
+
+	kvm_hyp_arm_smmu_v3_smmus = kern_hyp_va(kvm_hyp_arm_smmu_v3_smmus);
+	ret = smmu_take_pages(hyp_virt_to_phys(kvm_hyp_arm_smmu_v3_smmus),
+			      smmu_arr_size);
+	if (ret)
+		return ret;
+
+	for_each_smmu(smmu) {
+		ret = smmu_init_device(smmu);
+		if (ret)
+			goto out_reclaim_smmu;
+	}
+
+	return 0;
+
+out_reclaim_smmu:
+	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
+		smmu_deinit_device(--smmu);
+	smmu_reclaim_pages(hyp_virt_to_phys(kvm_hyp_arm_smmu_v3_smmus),
+			   smmu_arr_size);
+	return ret;
 }
 
 static void smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
-- 
2.52.0.rc1.455.g30608eb744-goog

