Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A063451DC
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640365; cv=none; b=l0tBTtWsxGFq4HojC9KPXK2axS6MzXsnAMk1wLTxBITLjWs+xSDXmgT4nb3QJufBPkZM/J1hYN4ACMSIu9Vg9dfSY2281RGrJZSx94kGiRpU1yW3QtadY8mcwLmWfqoVntoH+WKHCvedD2w+NAD6Wk1m1GKUtjBvCzzE+pL6bS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640365; c=relaxed/simple;
	bh=cLjOanwFCYbBZ+DeQcNx28zYJugfOvEDf7zTDH1asV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lThF9TWJE8akN8mQHN1961EENrc1N1yM2Yxe5gmJpR1b46z08GVp3e0rr8WOCDlFkDq6DQTcFwiyT/g0Rks5BuDRPBv5H1ny826eq6erKe0oko45vl9m+Viy/ouI3ufXDqdqIRmB5mMoKr2Hz4aP1ULWmqq2ZucxNdJN1Lwct7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=guTcAyRQ; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="guTcAyRQ"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9e4146902so3279678f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640361; x=1756245161; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y1XMrJFUsZlHqUSwfaqqxufwXrUFJ8lXJIFDET8NUKg=;
        b=guTcAyRQxYYXG+F3bp0m98/Wv7zIQTr/BssO6lCE8Gd7l/Cit3IZIHdGxPW3k3F3QN
         19De7p8Lf7CM2jh8rWMwP0YkOY17NNV5hxKM7ahmowt2O3DWz3t/6vAJKieHtc3munR9
         gwxV/b5Pn+vgVtvk9u0dqkJ9qbiVa/nx7Qd7zXdZDNn9Ahml91IkhdwWgNUlKbJZZvb9
         mWD5JGcVHII41yAmp+Dz7GRjLX1borogICc+KpYHR9Er+p03tJ7iAuqxza23NwVi63WG
         jUezs+rhIQ3c8I/t8jCl4zFtoNoFkipAjGm4xMJu8bNvIXrAinuwvpnPEy0aMI2Y8oM4
         4zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640361; x=1756245161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1XMrJFUsZlHqUSwfaqqxufwXrUFJ8lXJIFDET8NUKg=;
        b=m9pk8K+Z7Y0/5GhqS7OoR9yLzM+h0T3ThjccLiakcRpc0v5Sf7WoDkoNGPnPhhXdBp
         O8TFu5JdxjFpe2MD69wEoaL7L9eK7A3qXo/kJ1v8YZAGwEI1KKgh1WwDGaJ1q8v4yhnx
         6rwol09jr73bys5VQYxjlZ+kb4N1iH+FgZtWghFsNLrtArAEpbJDQ1Oq48HejGc2NLyv
         r29ajEb83+HBfpS3vwQBIGHcNCMiahsW5oWVo9sNgMPW58vIxbcMtmTKkC+EBejE+mNj
         +N1l5HbbWh0gtO1VPwiaxRsN2INOmotRRHNaDpmN2O7Wr1EoB1yz00Y187r3UmKCFbG1
         ptYA==
X-Forwarded-Encrypted: i=1; AJvYcCV4FcP2lBHkqwdgAseuWfl1rgqCpxs961PgPTf35b119WdWc/rU4G5B6ofeCDgL/H/GRYBC0+s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0eo0+0mGJ1jo38TcyPLUp+pkKj3B6SJ2MYVp00AtccJs5VZMB
	eZVDH26VT3vlBIptI9hK9Lr3ARrNMZKoGROi1PtrE1ffNDRxasx6eX1OpEFisEkhy7ZVeN6qkZd
	X2oBmxlIL2/e2pw==
X-Google-Smtp-Source: AGHT+IGRK4bp6sesJCXzi77ty+REwj3D43YiESI0ZMsE4l0swwRaEoRodh4XIVE78li6aGNDnGWJRk469Etvfw==
X-Received: from wrqf13.prod.google.com ([2002:adf:f8cd:0:b0:3b7:8aed:a63d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2309:b0:3b7:54b3:c512 with SMTP id ffacd0b85a97d-3c32e7fe680mr338963f8f.58.1755640361697;
 Tue, 19 Aug 2025 14:52:41 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:46 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-19-smostafa@google.com>
Subject: [PATCH v4 18/28] iommu/arm-smmu-v3-kvm: Probe SMMU HW
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Probe SMMU features from the IDR register space, most of
the logic is common with the kernel.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 57 ++++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  8 +++
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8ffcc2e32474..f0e1feee8a49 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -48,6 +48,7 @@ struct arm_smmu_device;
 #define IDR0_S2P			(1 << 0)
 
 #define ARM_SMMU_IDR1			0x4
+#define IDR1_ECMDQ			(1 << 31)
 #define IDR1_TABLES_PRESET		(1 << 30)
 #define IDR1_QUEUES_PRESET		(1 << 29)
 #define IDR1_REL			(1 << 28)
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index b56feae81dda..e45b4e50b1e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -10,6 +10,7 @@
 #include <nvhe/mem_protect.h>
 
 #include "arm_smmu_v3.h"
+#include "../arm-smmu-v3.h"
 
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
@@ -45,9 +46,56 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 	}
 }
 
+/*
+ * Mini-probe and validation for the hypervisor.
+ */
+static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u32 reg;
+
+	/* IDR0 */
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
+	smmu->features = smmu_idr0_features(reg);
+
+	/*
+	 * Some MMU600 and MMU700 have errata that prevent them from using nesting,
+	 * not sure how can we identify those, so it's recommended not to enable this
+	 * drivers on such systems.
+	 * And preventing any of those will be too restrictive
+	 */
+	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
+	    !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))
+		return -ENXIO;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL | IDR1_ECMDQ))
+		return -EINVAL;
+
+	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
+	/* Follows the kernel logic */
+	if (smmu->sid_bits <= STRTAB_SPLIT)
+		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	smmu->features |= smmu_idr3_features(reg);
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
+	smmu->pgsize_bitmap = smmu_idr5_to_pgsize(reg);
+
+	smmu->oas = smmu_idr5_to_oas(reg);
+	if (smmu->oas == 52)
+		smmu->pgsize_bitmap |= 1ULL << 42;
+	else if (!smmu->oas)
+		smmu->oas = 48;
+
+	smmu->ias = 64;
+	smmu->ias = min(smmu->ias, smmu->oas);
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
-	int i;
+	int i, ret;
 	size_t nr_pages;
 
 	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
@@ -64,8 +112,13 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 		WARN_ON(__pkvm_host_donate_hyp_mmio(pfn));
 	}
 	smmu->base = hyp_phys_to_virt(smmu->mmio_addr);
-
+	ret = smmu_probe(smmu);
+	if (ret)
+		goto out_ret;
 	return 0;
+out_ret:
+	smmu_deinit_device(smmu);
+	return ret;
 }
 
 static int smmu_init(void)
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 744ee2b7f0b4..3550fa695539 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -12,12 +12,20 @@
  *
  * Other members are filled and used at runtime by the SMMU driver.
  * @base		Virtual address of SMMU registers
+ * @ias			IPA size
+ * @oas			PA size
+ * @pgsize_bitmap	Supported page sizes
+ * @sid_bits		Max number of SID bits supported
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
 	size_t			mmio_size;
 	void __iomem		*base;
 	u32			features;
+	unsigned long		ias;
+	unsigned long		oas;
+	unsigned long		pgsize_bitmap;
+	unsigned int		sid_bits;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.51.0.rc1.167.g924127e9c0-goog

