Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1288497
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:55 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id q10so17234018wrm.4
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QwuD9TuGNSCLvPM2blxffUhnZ2RtJhExgcIPoLd+QM=;
        b=UOhwrweWo/dydtFfuzgOipklc5rQNm46Jqg9SLNN7DWbSNa217VcZcYEtfDbWKZ+ro
         pTpyujtdOm5j39A7vRbwrc8tS/GrxqLOzHnnEUY7yEGvujURXprc4qYFtTNAo9N1kcm4
         uYS9th+lV2uBPj3HZEnl/Z6KRtqw0Hwdb748wqe6A1px9tdg7Ot6+y9BVFUlqYq3XpXm
         BuSX32azdekNqG+ojYiLZsVLQhK0RuRQk6FIokSXLujaG/wGGCMS6oWZ0ogTCbS7YIma
         qoW223lpxoJMh5dJHTtTCurAbnQ1ZZTT96CtKot03dCMBiSYzhTq3qML2YsGbb6CPITP
         vhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QwuD9TuGNSCLvPM2blxffUhnZ2RtJhExgcIPoLd+QM=;
        b=qQPGq+qzNcKmBsW4l04w8Qr+yP15bR58vOrtb3yNzcj4JefHC733lrpu1fSVkvqlq1
         M9ZltGhb1Eb5QR07WyQGTaAQdBfK6nJ5oeJNxl0WM7URRQJrGg+9/xoiS8qGN0hmRhy4
         JHWlhHfEzFB7ezCncj/xS8DU6SztIWXyw6ftPnQTDMv9teCaLzVUUHA+J8zo0o2jUhUy
         MaNOe21U6zU38fOjBfuP1PCopjLb9QCHO5cgrRuTO7uQnMFVREBGy11l9B7b/7NNuLE3
         rfX7q2g/4HthvRjjKEn4ZLIvqxX8sOd5TXLLhphQE7D8omuZQSSlUtcMz7bFfWpDXS4F
         iFIA==
X-Gm-Message-State: AO0yUKV5XCaNmBZ3EMqFDZSanFKWsy3gHMR+Z25H3YrdAkJPX6/RqHvG
	oEgq7/KvD0Gd4sLIVlDxrmheFA==
X-Google-Smtp-Source: AK7set9bqN341dPHhfT97aUYzzSZBGnfTu3JIZgicnUoniM+wDk0UFc0vzIdu1RIl/3gjqCIATPA8g==
X-Received: by 2002:a05:6000:10c3:b0:2bf:b2c2:e122 with SMTP id b3-20020a05600010c300b002bfb2c2e122mr2349373wrx.29.1675256394953;
        Wed, 01 Feb 2023 04:59:54 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:54 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 45/45] iommu/arm-smmu-v3-kvm: Enable runtime PM
Date: Wed,  1 Feb 2023 12:53:29 +0000
Message-Id: <20230201125328.2186498-46-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable runtime PM for the KVM SMMUv3 driver. The PM link to DMA masters
dictates when the SMMU should be powered on.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 198e41d808b0..cd865049f89a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -8,6 +8,7 @@
 #include <linux/local_lock.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
 
 #include <kvm/arm_smmu_v3.h>
 
@@ -18,6 +19,7 @@ struct host_arm_smmu_device {
 	pkvm_handle_t			id;
 	u32				boot_gbpa;
 	unsigned int			pgd_order;
+	atomic_t			initialized;
 };
 
 #define smmu_to_host(_smmu) \
@@ -134,8 +136,10 @@ static struct iommu_ops kvm_arm_smmu_ops;
 
 static struct iommu_device *kvm_arm_smmu_probe_device(struct device *dev)
 {
+	int ret;
 	struct arm_smmu_device *smmu;
 	struct kvm_arm_smmu_master *master;
+	struct host_arm_smmu_device *host_smmu;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 
 	if (!fwspec || fwspec->ops != &kvm_arm_smmu_ops)
@@ -156,7 +160,28 @@ static struct iommu_device *kvm_arm_smmu_probe_device(struct device *dev)
 	master->smmu = smmu;
 	dev_iommu_priv_set(dev, master);
 
+	if (!device_link_add(dev, smmu->dev,
+			     DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE |
+			     DL_FLAG_AUTOREMOVE_SUPPLIER)) {
+		ret = -ENOLINK;
+		goto err_free;
+	}
+
+	/*
+	 * If the SMMU has just been initialized by the hypervisor, release the
+	 * extra PM reference taken by kvm_arm_smmu_probe().  Not sure yet how
+	 * to improve this. Maybe have KVM call us back when it finished
+	 * initializing?
+	 */
+	host_smmu = smmu_to_host(smmu);
+	if (atomic_add_unless(&host_smmu->initialized, 1, 1))
+		pm_runtime_put_noidle(smmu->dev);
+
 	return &smmu->iommu;
+
+err_free:
+	kfree(master);
+	return ERR_PTR(ret);
 }
 
 static void kvm_arm_smmu_release_device(struct device *dev)
@@ -685,6 +710,30 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 
 	kvm_arm_smmu_cur++;
 
+	/*
+	 * The state of endpoints dictates when the SMMU is powered off. To turn
+	 * the SMMU on and off, a genpd driver uses SCMI over the SMC transport,
+	 * or some other platform-specific SMC. Those power requests are caught
+	 * by the hypervisor, so that the hyp driver doesn't touch the hardware
+	 * state while it is off.
+	 *
+	 * We are making a big assumption here, that TLBs and caches are invalid
+	 * on power on, and therefore we don't need to wake the SMMU when
+	 * modifying page tables, stream tables and context tables. If this
+	 * assumption does not hold on some systems, then we'll need to grab RPM
+	 * reference in map(), attach(), etc, so the hyp driver can send
+	 * invalidations.
+	 */
+	hyp_smmu->caches_clean_on_power_on = true;
+
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	/*
+	 * Take a reference to keep the SMMU powered on while the hypervisor
+	 * initializes it.
+	 */
+	pm_runtime_resume_and_get(dev);
+
 	return 0;
 }
 
@@ -697,6 +746,11 @@ static int kvm_arm_smmu_remove(struct platform_device *pdev)
 	 * There was an error during hypervisor setup. The hyp driver may
 	 * have already enabled the device, so disable it.
 	 */
+
+	if (!atomic_read(&host_smmu->initialized))
+		pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 	arm_smmu_unregister_iommu(smmu);
 	arm_smmu_device_disable(smmu);
 	arm_smmu_update_gbpa(smmu, host_smmu->boot_gbpa, GBPA_ABORT);
-- 
2.39.0

