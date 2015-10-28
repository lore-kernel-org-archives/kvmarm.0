From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5 4/7] vfio: platform: reset: calxedaxgmac: add reset function registration
Date: Wed, 28 Oct 2015 13:02:35 +0000
Message-ID: <1446037358-2079-5-git-send-email-eric.auger@linaro.org>
References: <1446037358-2079-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446037358-2079-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds the reset function registration/unregistration.
This is handled through the module_vfio_reset_handler macro. This
latter also defines a MODULE_ALIAS which simplifies the load from
vfio-platform.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

---

v3 -> v4:
- I restored the EXPORT_SYMBOL which will be removed when switching the
  lookup method
- Add Arnd R-b.

v2 -> v3:
- do not include vfio_platform_reset_private.h anymore (removed)
- remove pr_info
- rework commit message

v1 -> v2:
- uses the module_vfio_reset_handler macro
- add pr_info on vfio reset
- do not export vfio_platform_calxedaxgmac_reset symbol anymore
---
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 619dc7d..80718f2 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -30,8 +30,6 @@
 #define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
 #define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
 
-#define CALXEDAXGMAC_COMPAT "calxeda,hb-xgmac"
-
 /* XGMAC Register definitions */
 #define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
 
@@ -80,6 +78,8 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_platform_calxedaxgmac_reset);
 
+module_vfio_reset_handler("calxeda,hb-xgmac", vfio_platform_calxedaxgmac_reset);
+
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
1.9.1
