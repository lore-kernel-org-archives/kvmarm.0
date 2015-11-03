From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 8/8] vfio: platform: reset: calxedaxgmac: fix ioaddr leak
Date: Tue,  3 Nov 2015 18:12:19 +0000
Message-ID: <1446574339-1843-9-git-send-email-eric.auger@linaro.org>
References: <1446574339-1843-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C8A5498AB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 13:09:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jEc9IGh59RIg for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 13:09:27 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95ABF4970D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 13:09:26 -0500 (EST)
Received: by wmff134 with SMTP id f134so22049235wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Nov 2015 10:12:37 -0800 (PST)
In-Reply-To: <1446574339-1843-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In the current code the vfio_platform_region is copied on the stack.
As a consequence the ioaddr address is not iounmapped in the vfio
platform driver (vfio_platform_regions_cleanup). The patch uses the
pointer to the region instead.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 640f5d8..e3d3d94 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -59,20 +59,20 @@ static inline void xgmac_mac_disable(void __iomem *ioaddr)
 
 int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
 {
-	struct vfio_platform_region reg = vdev->regions[0];
+	struct vfio_platform_region *reg = &vdev->regions[0];
 
-	if (!reg.ioaddr) {
-		reg.ioaddr =
-			ioremap_nocache(reg.addr, reg.size);
-		if (!reg.ioaddr)
+	if (!reg->ioaddr) {
+		reg->ioaddr =
+			ioremap_nocache(reg->addr, reg->size);
+		if (!reg->ioaddr)
 			return -ENOMEM;
 	}
 
 	/* disable IRQ */
-	writel(0, reg.ioaddr + XGMAC_DMA_INTR_ENA);
+	writel(0, reg->ioaddr + XGMAC_DMA_INTR_ENA);
 
 	/* Disable the MAC core */
-	xgmac_mac_disable(reg.ioaddr);
+	xgmac_mac_disable(reg->ioaddr);
 
 	return 0;
 }
-- 
1.9.1
