Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2896242A8B
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026799; cv=none; b=WZ0Nvwzo26i9DZoSI0M/AOZzTSTK5wzlv6SdM2dQJbKU+Laj5xmw5TCTtf55/U9111EbnspzHImI4/hAB5xqJV6leZGUW3Geue2DcJZtxml6bWlf7D4h6ljmU8J+bP5LB8QIMozbiwewpB2ZxJhRxT/75vN076tvNzLTI5+6Q8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026799; c=relaxed/simple;
	bh=roqaVNS4k1507yPlF6ISRHLKuQfgC3toJn6r6QoUTyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ggCzvomU/qu9kC6nou8JrC04xFfSuF6T61EAotQ2QedbY04QnAY2Sd5W/VBsbbveXzB7tluxSjBKnlxLxnNn0h6rLUXfPZHRBqMsNe6oCCxCKXIzABtw3Ekk5/yD/u/nWhpJkQmEW1JgYFB+PmzWljutOgFTSl69tCA02MEl6uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HpqBBYmZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HpqBBYmZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434e9e1b4d7so5509395e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026796; x=1734631596; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nir/8Fu9wro0KzAUocadSL8VHwLHRc3vCT5pzOEHxAw=;
        b=HpqBBYmZHXhcpCEhp5QleT7JaqUrx3Xq0whXC1U+Z751i/OuYHXnHDw2gfynl8Kwzo
         a1Iu3lq7mmsK2gjGNfoYIWR0PJLkCrKZJliEv7FIVup6f1UggOjCXc2/9NDRkwBHDWoc
         dJPJ796c3/Z7olodRSiSiCrhfObXVm6Y7DODRWEM6HWMAUS6+GMvXQijtiiCg+DJRd0e
         uNyA2vEGpnW1R1qGRPSi7GT2UYbYJiuUI9i8lPDtgJZCJaPWFZTxtEePwGgvV5SG0/9A
         vkF5nBrve/2m4ttoe8LRUyjikRwtzHLMZtwZg+iHucLsFPlstJ2a7W/m3MxVwNQKDk8G
         ZCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026796; x=1734631596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nir/8Fu9wro0KzAUocadSL8VHwLHRc3vCT5pzOEHxAw=;
        b=eMHxYNHK/iUJ6cLRun3k6pc/j4JmineHwbdkt75n313gbXk1Qlk2MIpmEKIolQjBZW
         tizn+rXPfqrgLD1vUDxgFAvCk2m1ZlXupgYpnKJwNMljOpbRYS2SUTcpRdON1uqv1qTm
         fmhYp3QgnVliEK99fDIhM375nMiJNVyVJNEWJY0FvX66OG2kPKu9eaQD8eyH4R363D99
         f3yobgf7BZuMRM3hvzccf9r4v5J7EZzy3c+aUt2T+s0qKU6yq+IHDdJM3cqsciQvxPiZ
         0pxd7LuQlFvmFtC/feKbEYXelAKnerx9WiCe4jJqGKHNhUJxgtpGrM4h6ajT5s66/LeA
         uBUg==
X-Forwarded-Encrypted: i=1; AJvYcCU7pZ8sq0WA3u/fcBaCaM4cJkf4Pyh8cHx1abgeaT1RDByHhGgWtgf74PAt6hX2n3jl9JuH4xY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfMMqfcYFPJoQQxVjkiX06kPvxpMLdeCRLDtJTV7warjgYogNB
	+Txe/fYsbxD9FNFIxhXcpx7wHN6YgRIGxVYaJRYbLee4BmEM6ZTv5RvhTq0ShPHGfxMBKyZOrAb
	63RbxxCtUqA==
X-Google-Smtp-Source: AGHT+IHRdZKXYWudkhhkQrQvejC9zCICHCvy3HiUQiQs1K09RQKbLBrbkNDh+wOO04CX03Sxp7dykFRKXpwfSw==
X-Received: from wmgg15.prod.google.com ([2002:a05:600d:f:b0:434:feb1:add1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d20:b0:434:a529:3b87 with SMTP id 5b1f17b1804b1-4361c36f5ccmr81464315e9.10.1734026796519;
 Thu, 12 Dec 2024 10:06:36 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:18 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-55-smostafa@google.com>
Subject: [RFC PATCH v2 54/58] iommu/arm-smmu-v3-kvm: Enable runtime PM
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

Enable runtime PM for the KVM SMMUv3 driver. The PM link to DMA masters
dictates when the SMMU should be powered on.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index deeed994a131..e987c273ff3c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -11,6 +11,7 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 
 #include <kvm/arm_smmu_v3.h>
 
@@ -127,6 +128,12 @@ static struct iommu_device *kvm_arm_smmu_probe_device(struct device *dev)
 	master->ssid_bits = min(smmu->ssid_bits, master->ssid_bits);
 	xa_init(&master->domains);
 	dev_iommu_priv_set(dev, master);
+	if (!device_link_add(dev, smmu->dev,
+			     DL_FLAG_PM_RUNTIME |
+			     DL_FLAG_AUTOREMOVE_SUPPLIER)) {
+		kfree(master);
+		return ERR_PTR(-ENOLINK);
+	}
 
 	return &smmu->iommu;
 }
@@ -818,6 +825,14 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	hyp_smmu->iommu.power_domain = host_smmu->power_domain;
 	kvm_arm_smmu_cur++;
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	/*
+	 * Take a reference to keep the SMMU powered on while the hypervisor
+	 * initializes it.
+	 */
+	pm_runtime_resume_and_get(dev);
+
 	return arm_smmu_register_iommu(smmu, &kvm_arm_smmu_ops, ioaddr);
 }
 
@@ -826,6 +841,8 @@ static void kvm_arm_smmu_remove(struct platform_device *pdev)
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
 
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 	/*
 	 * There was an error during hypervisor setup. The hyp driver may
 	 * have already enabled the device, so disable it.
@@ -834,6 +851,30 @@ static void kvm_arm_smmu_remove(struct platform_device *pdev)
 	arm_smmu_update_gbpa(smmu, host_smmu->boot_gbpa, GBPA_ABORT);
 }
 
+static int kvm_arm_smmu_suspend(struct device *dev)
+{
+	struct arm_smmu_device *smmu = dev_get_drvdata(dev);
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+	if (host_smmu->power_domain.type == KVM_POWER_DOMAIN_HOST_HVC)
+		return kvm_call_hyp_nvhe(__pkvm_host_hvc_pd, host_smmu->id, 0);
+	return 0;
+}
+
+static int kvm_arm_smmu_resume(struct device *dev)
+{
+	struct arm_smmu_device *smmu = dev_get_drvdata(dev);
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+	if (host_smmu->power_domain.type == KVM_POWER_DOMAIN_HOST_HVC)
+		return kvm_call_hyp_nvhe(__pkvm_host_hvc_pd, host_smmu->id, 1);
+	return 0;
+}
+
+static const struct dev_pm_ops kvm_arm_smmu_pm_ops = {
+	SET_RUNTIME_PM_OPS(kvm_arm_smmu_suspend, kvm_arm_smmu_resume, NULL)
+};
+
 static const struct of_device_id arm_smmu_of_match[] = {
 	{ .compatible = "arm,smmu-v3", },
 	{ },
@@ -843,6 +884,7 @@ static struct platform_driver kvm_arm_smmu_driver = {
 	.driver = {
 		.name = "kvm-arm-smmu-v3",
 		.of_match_table = arm_smmu_of_match,
+		.pm = &kvm_arm_smmu_pm_ops,
 	},
 	.remove = kvm_arm_smmu_remove,
 };
@@ -877,6 +919,12 @@ static void kvm_arm_smmu_array_free(void)
 	free_pages((unsigned long)kvm_arm_smmu_array, order);
 }
 
+static int smmu_put_device(struct device *dev, void *data)
+{
+	pm_runtime_put(dev);
+	return 0;
+}
+
 static int kvm_arm_smmu_v3_init_drv(void)
 {
 	int ret;
@@ -905,6 +953,7 @@ static int kvm_arm_smmu_v3_init_drv(void)
 	 */
 	kvm_hyp_arm_smmu_v3_smmus = kvm_arm_smmu_array;
 	kvm_hyp_arm_smmu_v3_count = kvm_arm_smmu_count;
+
 	return 0;
 
 err_free:
@@ -931,4 +980,21 @@ static int kvm_arm_smmu_v3_register(void)
 					kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))));
 };
 
+/*
+ * KVM init hypervisor at device_sync init call,
+ * so we drop the PM references of the SMMU taken at probe
+ * at the late initcall where it's guaranteed the hypervisor
+ * has initialized the SMMUs.
+ */
+static int kvm_arm_smmu_v3_post_init(void)
+{
+	if (!kvm_arm_smmu_count)
+		return 0;
+
+	WARN_ON(driver_for_each_device(&kvm_arm_smmu_driver.driver, NULL,
+				       NULL, smmu_put_device));
+	return 0;
+}
+
 core_initcall(kvm_arm_smmu_v3_register);
+late_initcall(kvm_arm_smmu_v3_post_init);
-- 
2.47.0.338.g60cca15819-goog

