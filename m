Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426B629B4
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:25 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id r2so17218291wrv.7
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRBo9744342o7YaPm6Zs1GUxiZStyoHs3LqNTLW5yzA=;
        b=qFbMHP2Embel72ZqaIvf16FStDCJ4QZES5VFhISvO9W7nO81lyzTIKtMEhlU+zhtfD
         Acyxvaz0SfXYVyEX1+37LcggDUAafoAFXwTtDqPHL5nZ2wh1Mppnv11qvBJZTtzYW0Pe
         jyms0ZKcjsOUamzYuHhEiVJKI04tGO9st0XWIi2oTqwQAryEVi5hMFEzJKg5bxlRfP0U
         HbGZtK0RHzXwBLW7x3UNUH3aturY6rgTBWmakPrDUCqVDwLtrVGPm8p7wm1hwsviIWG0
         9Ze5mCYfXpWEOKzkjnLhraDN1+/0W+YDOBgn0ChgyLu8rZivL/pv4YNu0OtWnyTHoX6F
         Ipog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRBo9744342o7YaPm6Zs1GUxiZStyoHs3LqNTLW5yzA=;
        b=V2BQqpFnjgUGizky89hegBBuA0OoBcvNxMAeVsekCGfiAWbg29xMtwpuyDraEt6AUc
         Z5IUnl0YW/pFrppbaO28+uRIJ5/EuG/7H6duFvg20pjFV+wRUx3wyUyhR1KQQ3mAyqUz
         89gKpGCBrglSN3fa7Hk012nxF8xpkRMh1dFtG0qOUOsxmVh1lbnTzE0zFBnT6KByW+7F
         QOAyxKiyv2lfaqQOS5GgEuDUPsxm6SqKF+VJZRcJidDapaZOn9nOk+5HlFQhliY8x822
         nbM36wKSn887zjfyQNMBTXCiShEZOkvyM1JshLyNOGNrbEMD4yGrfLyRiNlo6+kxRX4I
         2Evg==
X-Gm-Message-State: AO0yUKVkL26Ki/Q6WE9NGkF0CL4vDrsjldIa9nty0cw+KGvZOyjPd+nr
	F3RYh0rkxHBY1zX3Ijq5qoyTNg==
X-Google-Smtp-Source: AK7set/uKV9+XcgUaZrw1N/7IRQ/kWwCi0MQTZn1q2xxii3BO/acDAW9vQEsB2O7/k5h/L/O9TtlEw==
X-Received: by 2002:adf:f7c9:0:b0:2bf:bfc1:f622 with SMTP id a9-20020adff7c9000000b002bfbfc1f622mr2225381wrq.64.1675256363577;
        Wed, 01 Feb 2023 04:59:23 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:23 -0800 (PST)
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
Subject: [RFC PATCH 06/45] iommu/io-pgtable-arm: Extend __arm_lpae_free_pgtable() to only free child tables
Date: Wed,  1 Feb 2023 12:52:50 +0000
Message-Id: <20230201125328.2186498-7-jean-philippe@linaro.org>
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

The hypervisor side of io-pgtable-arm needs to free the top-level page
table separately from the other tables (which are page-sized and will
use a page queue).

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/linux/io-pgtable-arm.h        |  2 +-
 drivers/iommu/io-pgtable-arm-common.c | 11 +++++++----
 drivers/iommu/io-pgtable-arm.c        |  2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/io-pgtable-arm.h b/include/linux/io-pgtable-arm.h
index 5199bd9851b6..2b3e69386d08 100644
--- a/include/linux/io-pgtable-arm.h
+++ b/include/linux/io-pgtable-arm.h
@@ -166,7 +166,7 @@ static inline bool iopte_leaf(arm_lpae_iopte pte, int lvl,
 
 /* Generic functions */
 void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
-			     arm_lpae_iopte *ptep);
+			     arm_lpae_iopte *ptep, bool only_children);
 
 int arm_lpae_init_pgtable(struct io_pgtable_cfg *cfg,
 			  struct arm_lpae_io_pgtable *data);
diff --git a/drivers/iommu/io-pgtable-arm-common.c b/drivers/iommu/io-pgtable-arm-common.c
index 359086cace34..009c35d4095f 100644
--- a/drivers/iommu/io-pgtable-arm-common.c
+++ b/drivers/iommu/io-pgtable-arm-common.c
@@ -299,7 +299,7 @@ int arm_lpae_map_pages(struct io_pgtable *iop, unsigned long iova,
 }
 
 void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
-			     arm_lpae_iopte *ptep)
+			     arm_lpae_iopte *ptep, bool only_children)
 {
 	arm_lpae_iopte *start, *end;
 	unsigned long table_size;
@@ -323,10 +323,12 @@ void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
 		if (!pte || iopte_leaf(pte, lvl, data->iop.cfg.fmt))
 			continue;
 
-		__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
+		__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data),
+					false);
 	}
 
-	__arm_lpae_free_pages(start, table_size, &data->iop.cfg);
+	if (!only_children)
+		__arm_lpae_free_pages(start, table_size, &data->iop.cfg);
 }
 
 static size_t arm_lpae_split_blk_unmap(struct io_pgtable *iop,
@@ -428,7 +430,8 @@ static size_t __arm_lpae_unmap(struct io_pgtable *iop,
 				/* Also flush any partial walks */
 				io_pgtable_tlb_flush_walk(cfg, iop, iova + i * size, size,
 							  ARM_LPAE_GRANULE(data));
-				__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
+				__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data),
+							false);
 			} else if (!iommu_iotlb_gather_queued(gather)) {
 				io_pgtable_tlb_add_page(cfg, iop, gather,
 							iova + i * size, size);
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index bee8980c89eb..b7920637126c 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -84,7 +84,7 @@ static void arm_lpae_free_pgtable(struct io_pgtable *iop)
 {
 	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
 
-	__arm_lpae_free_pgtable(data, data->start_level, iop->pgd);
+	__arm_lpae_free_pgtable(data, data->start_level, iop->pgd, false);
 	kfree(data);
 }
 
-- 
2.39.0

