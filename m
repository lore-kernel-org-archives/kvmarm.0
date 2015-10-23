From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 4/7] vfio: platform: reset: calxedaxgmac: add reset
 function registration
Date: Fri, 23 Oct 2015 14:37:12 +0200
Message-ID: <1445603835-14506-5-git-send-email-eric.auger@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD1941252
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eUMNS2tngPmt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 08:34:49 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8874441349
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:47 -0400 (EDT)
Received: by wijp11 with SMTP id p11so75495947wij.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 05:37:27 -0700 (PDT)
In-Reply-To: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
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
This is handled through the module_vfio_reset_handler macro. This
latter also defines a MODULE_ALIAS which simplifies the load from
vfio-platform.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v2 -> v3:
- do not include vfio_platform_reset_private.h anymore (removed)
- remove pr_info
- rework commit message

v1 -> v2:
- uses the module_vfio_reset_handler macro
- add pr_info on vfio reset
- do not export vfio_platform_calxedaxgmac_reset symbol anymore
---
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 619dc7d..640f5d8 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -30,8 +30,6 @@
 #define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
 #define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
 
-#define CALXEDAXGMAC_COMPAT "calxeda,hb-xgmac"
-
 /* XGMAC Register definitions */
 #define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
 
@@ -78,7 +76,8 @@ int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vfio_platform_calxedaxgmac_reset);
+
+module_vfio_reset_handler("calxeda,hb-xgmac", vfio_platform_calxedaxgmac_reset);
 
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
-- 
1.9.1
