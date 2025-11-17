Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81C2340D81
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405336; cv=none; b=oukyw15/tt8OIBXZu/OgPDgXwhfmXAZ0kYvtmn9GDOtUExHjW8D/mrdg87eI1rMBLD7BjxtaJ7l+J/WxYLSFWMkD4d4/NYOi8xBJ6fg1FEepgwqZJLigvRfyOPcqYGZmTj6yvOOYiiXzhwZObZBm7ixNHmlYQFV2D3oMWJjAk7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405336; c=relaxed/simple;
	bh=OIllo30ZkV3wRlt33j6CE/EE04FNRPaHVxJuJzubPrY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iUlV5pWSs6ZgVGRWzPfjSpxZUXGyEed+3raL+iM9LA4u4W/hEMy3xs6kkgsik6DAkOirw7w/ZpbTVUoRRawNeYF7tMXh9k3E7PjDNWGdMdwQyG7yd0C03w/4fG3X7Z3VZPW/O7zQrOIghRATkMLuSZad2opErR2km+8SFd/r7TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPeCMVC5; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPeCMVC5"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cce847c4so1989271f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405331; x=1764010131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2e8AJ/3qpxCOMqh4v7dKF/r5F0keF6BFA14sDMtgseA=;
        b=PPeCMVC5Plsjx2yyR1PULhOqImnsvTux3PBTRr3Vi/NrOMx199BppyB0tZvYsdAJ7R
         4gRskpEj+nLKr6hF6+pM7l2WK36KSYGDPr5q88s4nOaSegE2YPW3o2yY5g/utffCoWv+
         HG4xUFWYLuUPrgxhHi/mwXz/5sElgJQ/vTj2tOLgTkXNQTeOCkhrceNUdwAR+tIH9su0
         MIsDj85geBT0nbjmUbQRzEd2ZleBxgyyzWNQrSCD6jcJynq4rUbf2AmxXvtrj+mg497D
         GjULcGg8kqEljQK0fUIzwW3+JkVkJ6U6n71+Tj0hgBR1e6GTgwmQicihIOwiFE6BPTfC
         WCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405331; x=1764010131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2e8AJ/3qpxCOMqh4v7dKF/r5F0keF6BFA14sDMtgseA=;
        b=iRvGmtiefJwKakQxWpiqr35djeUvHkJqYj/qAgNJK8NXW8MkchyV+k1jz9/eR3/jgh
         pQr5WubXtSV08vd6LewHcuUkqCUR2W7sFiWsDMEVbK57k+5BQMKbxBKC3PSbc6dUFaGO
         deQxUkwe/eMlw171UTyG1sktJZEgbXjK1MK+vfknTf5xQfVA6tPWClc1VAbPamxBJpp7
         VxQycksCb9iG0nT/A39oDTgXwpQuROX7HnbdLv4XlgXHm/DvykdvV7BnoqUdGbTSG5lE
         6aFj471OWanN7B/VBcC5o6bzo5MXqlC6avVESBLxTIzGH/TW11Pa5b3945UAqFcjZAhV
         Rbcw==
X-Forwarded-Encrypted: i=1; AJvYcCXTsiGYxWwB9vuEKcg9QhtwlKO/hFnfsrsl94DRf96JeKFgyN8saIM5/fRRO3b9BCSqvHbmxxM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1ZfMd2cPgwuXARp3BuwSHj3PUYRIYrxP/5YKPzoxaeWd+aHy1
	FzdKqunwDHCm1j9hon6e1uIx4BGwLlyjLhIHxz4+MpE7zQturdmcCaUCC5y326DTUAK/Jyu66H/
	rIsFeelzvEe/U6Q==
X-Google-Smtp-Source: AGHT+IFYxGMytoDZZlTDHtwywr4/Pi+/xR6UqlI0u6DlCyyeGT+QjWCV1nogGfL6thKzA2YoXGlkE2OMke9X7g==
X-Received: from wrqa7.prod.google.com ([2002:adf:f7c7:0:b0:42b:33e5:eba1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:240d:b0:3ea:80ec:8552 with SMTP id ffacd0b85a97d-42b59387fbfmr14696008f8f.57.1763405331039;
 Mon, 17 Nov 2025 10:48:51 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:12 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-26-smostafa@google.com>
Subject: [PATCH v5 25/27] iommu/arm-smmu-v3-kvm: Support io-pgtable
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add hooks needed to support io-pgtable-arm, mostly about
memory allocation.

Also add a function to allocate s2 64 bit page table.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |  4 +-
 .../arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c | 68 +++++++++++++++++++
 drivers/iommu/io-pgtable-arm.c                |  2 +-
 drivers/iommu/io-pgtable-arm.h                | 11 +++
 4 files changed, 83 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 197685817546..99c2ce941146 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -35,7 +35,9 @@ hyp-obj-y += $(lib-objs)
 HYP_SMMU_V3_DRV_PATH = ../../../../../drivers/iommu/arm/arm-smmu-v3
 
 hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += $(HYP_SMMU_V3_DRV_PATH)/pkvm/arm-smmu-v3.o \
-	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o
+	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o \
+	$(HYP_SMMU_V3_DRV_PATH)/pkvm/io-pgtable-arm-hyp.o \
+	$(HYP_SMMU_V3_DRV_PATH)/../../io-pgtable-arm.o
 
 ##
 ## Build rules for compiling nVHE hyp code
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c
new file mode 100644
index 000000000000..fc2006dc0b82
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Arm Ltd.
+ */
+#include <nvhe/iommu.h>
+
+#include <linux/io-pgtable.h>
+#include "../../../io-pgtable-arm.h"
+
+struct io_pgtable_ops *kvm_alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
+						struct io_pgtable_cfg *cfg,
+						void *cookie)
+{
+	struct io_pgtable *iop;
+
+	if (fmt != ARM_64_LPAE_S2)
+		return NULL;
+
+	iop = arm_64_lpae_alloc_pgtable_s2(cfg, cookie);
+	if (!iop)
+		return NULL;
+
+	iop->fmt	= fmt;
+	iop->cookie	= cookie;
+	iop->cfg	= *cfg;
+
+	return &iop->ops;
+}
+
+void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
+			     struct io_pgtable_cfg *cfg, void *cookie)
+{
+	void *addr;
+
+	addr = kvm_iommu_donate_pages(get_order(size));
+
+	if (addr && !cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(addr, size);
+
+	return addr;
+}
+
+void __arm_lpae_free_pages(void *addr, size_t size, struct io_pgtable_cfg *cfg,
+			   void *cookie)
+{
+	if (!cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(addr, size);
+
+	kvm_iommu_reclaim_pages(addr);
+}
+
+void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
+			 struct io_pgtable_cfg *cfg)
+{
+	if (!cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(ptep, sizeof(*ptep) * num_entries);
+}
+
+/* At the moment this is only used once, so rounding up to a page is not really a problem. */
+void *__arm_lpae_alloc_data(size_t size, gfp_t gfp)
+{
+	return kvm_iommu_donate_pages(get_order(size));
+}
+
+void __arm_lpae_free_data(void *p)
+{
+	return kvm_iommu_reclaim_pages(p);
+}
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 377c15bc8350..dbb1a58a5ce6 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -980,7 +980,7 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 	return NULL;
 }
 
-static struct io_pgtable *
+struct io_pgtable *
 arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 {
 	u64 sl;
diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
index 62d127dae1c2..742a6ed9ae3c 100644
--- a/drivers/iommu/io-pgtable-arm.h
+++ b/drivers/iommu/io-pgtable-arm.h
@@ -41,9 +41,20 @@ void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 			     void *cookie);
 void *__arm_lpae_alloc_data(size_t size, gfp_t gfp);
 void __arm_lpae_free_data(void *p);
+struct io_pgtable *
+arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie);
 #ifndef __KVM_NVHE_HYPERVISOR__
 #define __arm_lpae_virt_to_phys	__pa
 #define __arm_lpae_phys_to_virt	__va
+#else
+#include <nvhe/memory.h>
+#define __arm_lpae_virt_to_phys	hyp_virt_to_phys
+#define __arm_lpae_phys_to_virt	hyp_phys_to_virt
+#undef WARN_ONCE
+#define WARN_ONCE(condition, format...)	WARN_ON(1)
+struct io_pgtable_ops *kvm_alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
+						struct io_pgtable_cfg *cfg,
+						void *cookie);
 #endif /* !__KVM_NVHE_HYPERVISOR__ */
 
 #endif /* IO_PGTABLE_ARM_H_ */
-- 
2.52.0.rc1.455.g30608eb744-goog

