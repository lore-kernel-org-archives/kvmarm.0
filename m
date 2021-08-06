Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD2FC432BE
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:31:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B19E611CC
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B19E611CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA584B0D1;
	Fri,  6 Aug 2021 07:31:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MOLjHrGfnxrv; Fri,  6 Aug 2021 07:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E7074B0EE;
	Fri,  6 Aug 2021 07:31:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F22494B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:31:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z69aDzGN2Qod for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 07:31:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA7544B0E4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:31:26 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A267F6108D;
 Fri,  6 Aug 2021 11:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628249485;
 bh=lP9P2emkoqaG3Y9UVECzCsJ31BDk9yKNVY61WSeDVew=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tnPeXiR8JiANNo5Q4fgmDmdMnadmuScbwPZoLOkAdnsNgfrCOYbo3kSZiEdn/1/RP
 Zr/+dp9rLGmNpbIjztJVIgDmSnZ2u4Bp5jDE8OpiQQt8I7em7FCctXinBWZxjVDqJ/
 L6hmZYMH6XW6Suflz1eKmiQ5fy6PeiLIVrw45f8hQwFGrKKlkUETRkMBM26PFJNDp8
 5jihYIvbLSyD1MwxZvLJOvsqwy3ZjntM1X5Xa6C5k8/O+D3AuQiwfLlZdWIZk3Ig2k
 gdknbFOZ0B/QtOzwAz/Qi8hVETlplIOXVmmDZ8r5zO6o7rw5eFjVRnq/pYHOoP1RuS
 vyhsVyLfq1bkg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] of: restricted dma: Don't fail device probe on rmem init
 failure
Date: Fri,  6 Aug 2021 12:31:05 +0100
Message-Id: <20210806113109.2475-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806113109.2475-1-will@kernel.org>
References: <20210806113109.2475-1-will@kernel.org>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kernel-team@android.com,
 Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
 Rob Herring <robh+dt@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Claire Chang <tientzu@chromium.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Jade Alglave <jade.alglave@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

If CONFIG_DMA_RESTRICTED_POOL=n then probing a device with a reference
to a "restricted-dma-pool" will fail with a reasonably cryptic error:

  | pci-host-generic: probe of 10000.pci failed with error -22

Print a more helpful message in this case and try to continue probing
the device as we do if the kernel doesn't have the restricted DMA patches
applied or either CONFIG_OF_ADDRESS or CONFIG_HAS_DMA =n.

Cc: Claire Chang <tientzu@chromium.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 drivers/of/address.c    | 8 ++++----
 drivers/of/device.c     | 2 +-
 drivers/of/of_private.h | 8 +++-----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 973257434398..f6bf4b423c2a 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -997,7 +997,7 @@ int of_dma_get_range(struct device_node *np, const struct bus_dma_region **map)
 	return ret;
 }
 
-int of_dma_set_restricted_buffer(struct device *dev, struct device_node *np)
+void of_dma_set_restricted_buffer(struct device *dev, struct device_node *np)
 {
 	struct device_node *node, *of_node = dev->of_node;
 	int count, i;
@@ -1022,11 +1022,11 @@ int of_dma_set_restricted_buffer(struct device *dev, struct device_node *np)
 		 */
 		if (of_device_is_compatible(node, "restricted-dma-pool") &&
 		    of_device_is_available(node))
-			return of_reserved_mem_device_init_by_idx(dev, of_node,
-								  i);
+			break;
 	}
 
-	return 0;
+	if (i != count && of_reserved_mem_device_init_by_idx(dev, of_node, i))
+		dev_warn(dev, "failed to initialise \"restricted-dma-pool\" memory node\n");
 }
 #endif /* CONFIG_HAS_DMA */
 
diff --git a/drivers/of/device.c b/drivers/of/device.c
index 2defdca418ec..258a2b099410 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -166,7 +166,7 @@ int of_dma_configure_id(struct device *dev, struct device_node *np,
 	arch_setup_dma_ops(dev, dma_start, size, iommu, coherent);
 
 	if (!iommu)
-		return of_dma_set_restricted_buffer(dev, np);
+		of_dma_set_restricted_buffer(dev, np);
 
 	return 0;
 }
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index f557bd22b0cf..bc883f69496b 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -163,18 +163,16 @@ struct bus_dma_region;
 #if defined(CONFIG_OF_ADDRESS) && defined(CONFIG_HAS_DMA)
 int of_dma_get_range(struct device_node *np,
 		const struct bus_dma_region **map);
-int of_dma_set_restricted_buffer(struct device *dev, struct device_node *np);
+void of_dma_set_restricted_buffer(struct device *dev, struct device_node *np);
 #else
 static inline int of_dma_get_range(struct device_node *np,
 		const struct bus_dma_region **map)
 {
 	return -ENODEV;
 }
-static inline int of_dma_set_restricted_buffer(struct device *dev,
-					       struct device_node *np)
+static inline void of_dma_set_restricted_buffer(struct device *dev,
+						struct device_node *np)
 {
-	/* Do nothing, successfully. */
-	return 0;
 }
 #endif
 
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
