From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 4/4] vfio: platform: use list of registered reset function
Date: Sun, 18 Oct 2015 18:00:15 +0200
Message-ID: <1445184015-24414-5-git-send-email-eric.auger@linaro.org>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E4E14130A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gl7SBIlRuFbF for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 11:58:20 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0EA24142D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:19 -0400 (EDT)
Received: by wikq8 with SMTP id q8so20936617wik.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 09:00:47 -0700 (PDT)
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

Remove the static lookup table and use the dynamic list of registered
reset functions instead. Also load the reset module through its alias.
The reset struct module pointer is stored in vfio_platform_device.

This patch fixes the issue related to the usage of __symbol_get, which
besides from being moot, prevented compilation with CONFIG_MODULES
disabled.

Also usage of MODULE_ALIAS makes possible to add a new reset module
without needing to update the framework. This was suggested by Arnd.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/vfio/platform/vfio_platform_common.c  | 46 +++++++++++++++------------
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 31a6a8c..f3b6299 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -27,37 +27,41 @@ struct list_head reset_list;
 LIST_HEAD(reset_list);
 static DEFINE_MUTEX(driver_lock);
 
-static const struct vfio_platform_reset_combo reset_lookup_table[] = {
-	{
-		.compat = "calxeda,hb-xgmac",
-		.reset_function_name = "vfio_platform_calxedaxgmac_reset",
-		.module_name = "vfio-platform-calxedaxgmac",
-	},
-};
+static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
+					struct module **module)
+{
+	struct vfio_platform_reset_node *iter;
+
+	list_for_each_entry(iter, &reset_list, link) {
+		if (!strcmp(iter->compat, compat) &&
+			try_module_get(iter->owner)) {
+			*module = iter->owner;
+			return iter->reset;
+		}
+	}
+
+	return NULL;
+}
 
 static void vfio_platform_get_reset(struct vfio_platform_device *vdev,
 				    struct device *dev)
 {
-	int (*reset)(struct vfio_platform_device *);
-	int i;
-
-	for (i = 0 ; i < ARRAY_SIZE(reset_lookup_table); i++) {
-		if (!strcmp(reset_lookup_table[i].compat, vdev->compat)) {
-			request_module(reset_lookup_table[i].module_name);
-			reset = __symbol_get(
-				reset_lookup_table[i].reset_function_name);
-			if (reset) {
-				vdev->reset = reset;
-				return;
-			}
-		}
+	char modname[256];
+
+	vdev->reset = vfio_platform_lookup_reset(vdev->compat,
+						&vdev->reset_module);
+	if (!vdev->reset) {
+		snprintf(modname, 256, "vfio-reset:%s", vdev->compat);
+		request_module(modname);
+		vdev->reset = vfio_platform_lookup_reset(vdev->compat,
+							 &vdev->reset_module);
 	}
 }
 
 static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
 {
 	if (vdev->reset)
-		symbol_put_addr(vdev->reset);
+		module_put(vdev->reset_module);
 }
 
 static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index b274646..2070dcc 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -57,6 +57,7 @@ struct vfio_platform_device {
 	int				refcnt;
 	struct mutex			igate;
 	const char			*compat;
+	struct module			*reset_module;
 
 	/*
 	 * These fields should be filled by the bus specific binder
-- 
1.9.1
