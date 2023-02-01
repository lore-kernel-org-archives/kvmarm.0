Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242E52F50
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:28 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id k16so12615595wms.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLOTGdIX5XzH+Jwl3kF9DSu2jc0/WXz1kG1OARrYJNM=;
        b=Q3d2qtJCq3BIVZGKfu+1IbjBWHzFBo5/Xb5HFUtbvMJiuz3cAPjEqCHt3UwOffYZxE
         TMFUSJOltSsIXD8YBlXzzMeEB3fEpiE9zUaiuEEPBVru2iH+3SS3201GANWWtgrCmLfp
         yp/r96OfA0uSfjIy1uIBj8EViI4HE3mP0t4qaiaKs8CSwJRo9psQTTID6YbKjjmjvw5I
         ecCHZjebTzN1f6avWcf8CrPIb6hGrng7Q4dsF98hbcyuENPsy9HlSYBL62deV6Pt96s+
         aDVggipAu4GpMD4mgFQZmn9cMcZnEDM6Akk5nC8sqLdcDYZCpkG4NS3wVlZ2x/Lpsq6r
         WDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLOTGdIX5XzH+Jwl3kF9DSu2jc0/WXz1kG1OARrYJNM=;
        b=ns8lJyHSK5hpOnrr5iMDfJ5dVC6HOPcQ7gMfko5kKns5DT06547zAc/RG1LRbTAIAr
         PZu6UbvDwn47Bco31gtzTzGqyxGbmKX69aUlrkAX3wE6VYhI9nzOrafXT1pNeUJOXtAA
         +IYSnabWl+Z4kO2xNH3DXF66C6nIL7X64PLUKVkUpcSLQE4w1pSvgg+8C1yhcjrgF342
         Hh2IMMTfig311fagvx6oJE4lcYCYz8UQe9ywCEseOgCB9c74W8Prz/tmS529MYVo6Eyp
         50aImc0t3T/hcAtmv7yw4kI1UCgANSD/A+qTcRMkyI6G6hrIO+q5/t1savkyKNyWVqpK
         Aohg==
X-Gm-Message-State: AO0yUKX5vZ/M2LiLPvL+NdCpWNWV8oHFmTHeUbz9RpK9a0uJLYZzm0Ni
	A/847unC22MRu310gmczvSpq9Q==
X-Google-Smtp-Source: AK7set/rYkvZAy6++0J4vjVN94POb8/wXVqA/8/v2lPmHrVQwzFxOEu9D5CiFkQiJcSsOv/7hSdgVQ==
X-Received: by 2002:a05:600c:1989:b0:3db:2d7e:1204 with SMTP id t9-20020a05600c198900b003db2d7e1204mr2027422wmq.27.1675256366507;
        Wed, 01 Feb 2023 04:59:26 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:26 -0800 (PST)
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
Subject: [RFC PATCH 09/45] KVM: arm64: pkvm: Add pkvm_create_hyp_device_mapping()
Date: Wed,  1 Feb 2023 12:52:53 +0000
Message-Id: <20230201125328.2186498-10-jean-philippe@linaro.org>
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

Add a function to map a MMIO region in the hypervisor and remove it from
the host. Hypervisor device drivers use this to reserve their regions
during setup.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/setup.c      | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index d5ec972b5c1e..84db840f2057 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -27,5 +27,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
+int pkvm_create_hyp_device_mapping(u64 base, u64 size, void __iomem *haddr);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 629e74c46b35..de7d60c3c20b 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -259,6 +259,23 @@ static int fix_host_ownership(void)
 	return 0;
 }
 
+/* Map the MMIO region into the hypervisor and remove it from host */
+int pkvm_create_hyp_device_mapping(u64 base, u64 size, void __iomem *haddr)
+{
+	int ret;
+
+	ret = __pkvm_create_private_mapping(base, size, PAGE_HYP_DEVICE, haddr);
+	if (ret)
+		return ret;
+
+	/* lock not needed during setup */
+	ret = host_stage2_set_owner_locked(base, size, PKVM_ID_HYP);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
 static int fix_hyp_pgtable_refcnt(void)
 {
 	struct kvm_pgtable_walker walker = {
-- 
2.39.0

