From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 4/6] vfio: platform: add compat in vfio_platform_device
Date: Thu, 22 Oct 2015 11:42:00 +0200
Message-ID: <1445506922-6005-5-git-send-email-eric.auger@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86330412ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 05:39:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id klTbiKol10CD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 05:39:38 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC65241300
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 05:39:37 -0400 (EDT)
Received: by wicfv8 with SMTP id fv8so111598733wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 02:42:15 -0700 (PDT)
In-Reply-To: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
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

Let's retrieve the compatibility string on probe and store it
in the vfio_platform_device struct

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_common.c  | 15 ++++++++-------
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 52a4c7b..e7d615f 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -45,16 +45,11 @@ static const struct vfio_platform_reset_combo reset_lookup_table[] = {
 static void vfio_platform_get_reset(struct vfio_platform_device *vdev,
 				    struct device *dev)
 {
-	const char *compat;
 	int (*reset)(struct vfio_platform_device *);
-	int ret, i;
-
-	ret = device_property_read_string(dev, "compatible", &compat);
-	if (ret)
-		return;
+	int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(reset_lookup_table); i++) {
-		if (!strcmp(reset_lookup_table[i].compat, compat)) {
+		if (!strcmp(reset_lookup_table[i].compat, vdev->compat)) {
 			request_module(reset_lookup_table[i].module_name);
 			reset = __symbol_get(
 				reset_lookup_table[i].reset_function_name);
@@ -545,6 +540,12 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 	struct iommu_group *group;
 	int ret;
 
+	ret = device_property_read_string(dev, "compatible", &vdev->compat);
+	if (ret) {
+		pr_err("VFIO: cannot retrieve compat for %s\n", vdev->name);
+		return -EINVAL;
+	}
+
 	if (!vdev)
 		return -EINVAL;
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 1fb1410..620ee40 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -56,6 +56,7 @@ struct vfio_platform_device {
 	u32				num_irqs;
 	int				refcnt;
 	struct mutex			igate;
+	const char			*compat;
 
 	/*
 	 * These fields should be filled by the bus specific binder
-- 
1.9.1
