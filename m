From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 2/4] vfio: platform: reset: calxedaxgmac: add reset function
 registration
Date: Sun, 18 Oct 2015 18:00:13 +0200
Message-ID: <1445184015-24414-3-git-send-email-eric.auger@linaro.org>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7B0412A6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j2JhXDFbeJV3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 11:58:17 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F32A41280
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:17 -0400 (EDT)
Received: by wijp11 with SMTP id p11so68458083wij.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 09:00:44 -0700 (PDT)
In-Reply-To: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
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

This patch adds the reset function registration/unregistration.
Also a MODULE_ALIAS is added.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 .../platform/reset/vfio_platform_calxedaxgmac.c    | 40 ++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 619dc7d..4f76b17 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -29,8 +29,7 @@
 #define DRIVER_VERSION  "0.1"
 #define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
 #define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
-
-#define CALXEDAXGMAC_COMPAT "calxeda,hb-xgmac"
+#define COMPAT		"calxeda,hb-xgmac"
 
 /* XGMAC Register definitions */
 #define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
@@ -80,6 +79,43 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_platform_calxedaxgmac_reset);
 
+static int __init vfio_platform_calxedaxgmac_init(void)
+{
+	int (*register_reset)(struct module *, char*,
+				vfio_platform_reset_fn_t);
+	int ret;
+
+	register_reset = symbol_get(vfio_platform_register_reset);
+	if (!register_reset)
+		return -EINVAL;
+
+	ret = register_reset(THIS_MODULE, COMPAT,
+	vfio_platform_calxedaxgmac_reset);
+
+	symbol_put(vfio_platform_register_reset);
+
+	return ret;
+}
+
+static void __exit vfio_platform_calxedaxgmac_exit(void)
+{
+	int (*unregister_reset)(char *);
+	int ret;
+
+	unregister_reset = symbol_get(vfio_platform_unregister_reset);
+	if (!unregister_reset)
+		return;
+
+	ret = unregister_reset(COMPAT);
+
+	symbol_put(vfio_platform_unregister_reset);
+}
+
+module_init(vfio_platform_calxedaxgmac_init);
+module_exit(vfio_platform_calxedaxgmac_exit);
+
+MODULE_ALIAS("vfio-reset:"  COMPAT);
+
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.9.1
