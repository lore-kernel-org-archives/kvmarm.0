Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049BD3054EA
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640361; cv=none; b=o0rRNp0tAvaPWh8BysqJXGP18BQ6pUemoGZFB/ShIkEsxPCRn+ev13qNpnmP5Z0mSNVpDNWK8DA9kzNutSUhnAnhyEDukCe0gOEMMJ/gIdlCY2VYsoVumaze+p7Q5anX5aPzMyPFqPT0vFw47h44nXezxolI6XXITOIHis2C1Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640361; c=relaxed/simple;
	bh=cMrRujJwddEPtHhK0JXsWsznkc7gKRpUZGwRSJ6bEwY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UU+IuTW5s+aiisOGyQ4eWUlA2BnX6pp+hg9GlRhLnhVkyKyPUSd10k/tMlKdPCi8u8Ui99L0phnhnDltyWItlQfwhN29o2mGvOw+AR+Dv8NoNMa1WCTfx23s/6B1aisYUmoTIVxGM0rOHsp5D56J2I8UXOvZZIU6qgvpqK5/k7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EdWvMxBG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EdWvMxBG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1ba17bbcso25762975e9.0
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640358; x=1756245158; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YNj1S5Tjh+MTuuSgivTU6GhE64woFcS5FBFIpdALKxk=;
        b=EdWvMxBGdDljyInpx+TD6MNQhyFr7JMgh4z7V8Nke1y+V95dB4+OTLFIrY5VWltBZO
         Xs7JBgBAgC8E6+Gcya4E2RN1PegAI9Dze9lvycGcSGghiVVESHMgVTVUlOXKxIKomNpr
         VIg6VLub13I0jM7i9LcvTfyGbwuKxSsJC1a4cSO5sJR1GoQMWrPvu23PvyE//UIkW6D6
         0H/nxyBJRz61ZprJ1+t29iuHVC6v6vlk3bW3xwWFYVb479s4GoRB3TK4XNo+y+pgbj6Z
         zJ6jPDpfLMZAlIDb24TT+g3tPY2KUYP8cpML9FENC49D52eykhY8+rm0UIvgMyRIeCm6
         jJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640358; x=1756245158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YNj1S5Tjh+MTuuSgivTU6GhE64woFcS5FBFIpdALKxk=;
        b=TNn5j1uWKGvE4X5aMNwX3jDoZvBnEuBXTgQG0ro0WRY5ZGjXFLZ57gOeAuTP6Pk92D
         ylzWTdjOrMfD0jechmTG5s+CI7owOMEyNCwkg8jGGcjfJ38+0f/d6EQNCjsbhXXIknTQ
         dcjz/LEavMLLWSDRnxSJTlqyseGJa83IfHNu/VpuvtcERg0fJ06Z4oGgDpGfhfDBVPcE
         x2UKuWOMjyKrhXx+4Q8rKzjctHsUpfcMlKwRD1BRAPkkZa4iJRvsREcbD7+vGf0lQ/08
         T2ncOhq4jeZweD46mK8FRfkq2ENe3yhehf9zsLdIW1KVmycsrnX315QN5DlYvU80p22O
         hehg==
X-Forwarded-Encrypted: i=1; AJvYcCXognOa+IVlXS7uc7NX3zCmR5scW9O/9QmcINKoqMyYQEUIkNpxaGmxrCUYyXdjtDnKu9ISvD8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQiXN+jQyLHDH2urB1O9gox51j8eLlvX9tvbaUEj6QwsiWVftN
	NirJSo9P4Ldr598023e8A0ZS9MuwRxFE7+JDG+urDoUGxU3O1JTpxv2Q9knvUGs9aGMq3tgnUF+
	GhpcNZXkD9TBNsg==
X-Google-Smtp-Source: AGHT+IHhXE5eFe6Mvs1Uc4cVRo8SUsVH79pNU31b0EWqV1qHu+8OuogNqLM1q4nApTxhxyHGYIGINP4HjbEypA==
X-Received: from wmsd13.prod.google.com ([2002:a05:600c:3acd:b0:459:10dd:2e55])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b4b:b0:456:161c:3d6f with SMTP id 5b1f17b1804b1-45b479b8ed5mr2712295e9.11.1755640358514;
 Tue, 19 Aug 2025 14:52:38 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:43 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-16-smostafa@google.com>
Subject: [PATCH v4 15/28] iommu/arm-smmu-v3: Load the driver later in KVM mode
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

While in KVM mode, the driver must be loaded after the hypervisor
initializes.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 25 ++++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 10ca07c6dbe9..a04730b5fe41 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4576,12 +4576,6 @@ static const struct of_device_id arm_smmu_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, arm_smmu_of_match);
 
-static void arm_smmu_driver_unregister(struct platform_driver *drv)
-{
-	arm_smmu_sva_notifier_synchronize();
-	platform_driver_unregister(drv);
-}
-
 static struct platform_driver arm_smmu_driver = {
 	.driver	= {
 		.name			= "arm-smmu-v3",
@@ -4592,8 +4586,27 @@ static struct platform_driver arm_smmu_driver = {
 	.remove = arm_smmu_device_remove,
 	.shutdown = arm_smmu_device_shutdown,
 };
+
+#ifndef CONFIG_ARM_SMMU_V3_PKVM
+static void arm_smmu_driver_unregister(struct platform_driver *drv)
+{
+	arm_smmu_sva_notifier_synchronize();
+	platform_driver_unregister(drv);
+}
+
 module_driver(arm_smmu_driver, platform_driver_register,
 	      arm_smmu_driver_unregister);
+#else
+/*
+ * Must be done after the hypervisor initializes at module_init()
+ * No need for unregister as this is a built in driver.
+ */
+static int arm_smmu_driver_register(void)
+{
+	return platform_driver_register(&arm_smmu_driver);
+}
+device_initcall_sync(arm_smmu_driver_register);
+#endif /* !CONFIG_ARM_SMMU_V3_PKVM */
 
 MODULE_DESCRIPTION("IOMMU API for ARM architected SMMUv3 implementations");
 MODULE_AUTHOR("Will Deacon <will@kernel.org>");
-- 
2.51.0.rc1.167.g924127e9c0-goog

