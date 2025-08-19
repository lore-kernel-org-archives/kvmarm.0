Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B61131DDB0
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640364; cv=none; b=RlcsXWfewI49rR+stOHyHuBzGzHNDojuVtMpjf70JuG4AkidEFl7w///pEa6YFUe+bteKX3LRVhdtje30r5PIjzrR1QVpb0MjbNUGGPbTm4XzNRHslgA12rkU2usmwQjQfcsqSnJmQ8/hyruMg5/qzGudsQ6o0dvL5ehCp2hJAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640364; c=relaxed/simple;
	bh=3hKxHuU/XBxBW6Fz378wf7Rbaz+dVXKNYo3PuthQO9w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YpcSdCHWV3Q63/j0Wz45RZoibylDWG42psw/aNaDmbLQ/+lRf6kX7FwSA7/1594V/wL15923MkPQ73pggtkyjMSRocIPWTjlUUf9ScDTYnremXXx4s2t/YfsVMP0JOHEeJPBlrY8CjnqJukm8zd8FFanIFF7+j5gwmdQPE+ZMLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JpKQtY09; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JpKQtY09"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3bb2fb3a489so2712234f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640360; x=1756245160; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=No5rZzETEpiSYrnAp/3rx5tnKsAcr1mN2J0hRF7T4gc=;
        b=JpKQtY090P/c9Y9Y5moEiQaT5taLdS0aZEnbZh2oYRYuOeNFFVt3BUcTr+oh2CpL+k
         VE3sQD1Z5keqlpngVFlh+xGye7ggOa4j7j6/Ph2DpmfTGGd5ZUzL4SKzJF1WwBHLYEDb
         TLpC/kFn3+W7wTV+gCPpxFoXng1mmHxvmAJGTB/agKK1ych6nXXPDQQvnW9Rdh2p4kvI
         /0sKaHD38X+lcsPxdQjGERgxvNV7mgV4a/oG2wGQO2UGu0G/Bm9oigsvu9PwKUXa4doy
         Y4XsMsuRoLtaJf868kGY8HzYgJBm6RL7Nlv24wq/eMKb4qL5vm09QHSVwqUT058RoVdy
         O77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640360; x=1756245160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=No5rZzETEpiSYrnAp/3rx5tnKsAcr1mN2J0hRF7T4gc=;
        b=FcOg8LZ4VTClip8ZNfEz1T5hCm10fEp8HFvLWdMrjpmlV5dsNvtJcynJp0IZWCeDyN
         OQE3eoihynZ8E4OYlSCvVKdMbnk00IWZGqlLtB02n6kQNiDYSxS+2+q0zUsHQOY2llS1
         GbCzX3R7e9noMUpwt7ELY2fvBVW88z4f0KBtHlOJ43SAsEPZwIlVSJsivs5M/FtdN/t6
         tAFVtElVZ69zZaxvTz6NORfCTjv+uCXYO3P96aenUAYMNEllySGrw9GJCvXN24qc4Ey9
         9YzXR/BtAZOOs+bxibeE4iazuNbl5fmDcQ3K2lUlL4ups7ndf3dpVy9aX2BwR+CoE/dd
         F/kg==
X-Forwarded-Encrypted: i=1; AJvYcCWfUdHbZVqFmOaGk74ZWTvHlTtmJynvMILZJMxTHhaJChF3PfsTCv3fvyx4nbbC60kC3WcQ2dU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBsYNuE9hYclVrDNQeVD2wWLMv5AwEdlA0Iw5UjxCuFduK/Iwu
	AtKl0nU9An1uoJO4TcOmWviIdJstr5LBVkp1ZpN/FxiWRGMIrtN8umqtkD8Qy6QzlHzFizm7Vd1
	UxG57sWaAWMv6Dg==
X-Google-Smtp-Source: AGHT+IFejZ2I69Eqlg88g8PwiPvQhSLUEBHZrSmUeIH84olhnRxAOXDRbUsOIXtbc95r4ewB/WJLIdwuVFgT6Q==
X-Received: from wmbdw4.prod.google.com ([2002:a05:600c:6384:b0:459:dcf5:1b54])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:22c5:b0:3b8:f863:672c with SMTP id ffacd0b85a97d-3c32e13359bmr316604f8f.33.1755640360470;
 Tue, 19 Aug 2025 14:52:40 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:45 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-18-smostafa@google.com>
Subject: [PATCH v4 17/28] iommu/arm-smmu-v3-kvm: Take over SMMUs
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
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
2.51.0.rc1.167.g924127e9c0-goog

