From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 6/7] vfio: platform: use list of registered reset function
Date: Fri, 23 Oct 2015 14:37:14 +0200
Message-ID: <1445603835-14506-7-git-send-email-eric.auger@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F8841978
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nisC36BTp-H7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 08:34:51 -0400 (EDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50CE94156D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:51 -0400 (EDT)
Received: by wicfv8 with SMTP id fv8so30057935wic.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 05:37:31 -0700 (PDT)
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

Remove the static lookup table and use the dynamic list of registered
reset functions instead. Also load the reset module through its alias.
The reset struct module pointer is stored in vfio_platform_device.

We also remove the useless struct device pointer parameter in
vfio_platform_get_reset.

This patch fixes the issue related to the usage of __symbol_get, which
besides from being moot, prevented compilation with CONFIG_MODULES
disabled.

Also usage of MODULE_ALIAS makes possible to add a new reset module
without needing to update the framework. This was suggested by Arnd.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>

---

v2 -> v3:
- remove clear of vfio_platform_device reset_module and reset
  in vfio_platform_put_reset
- single unlock in vfio_platform_lookup_reset
- use driver_lock instead of reset_lock

v1 -> v2:
- use reset_lock in vfio_platform_lookup_reset
- remove vfio_platform_reset_combo declaration
- remove struct device *dev parameter in vfio_platform_get_reset
- set reset_module and reset to NULL in put function
---
 drivers/vfio/platform/vfio_platform_common.c  | 52 +++++++++++++++------------
 drivers/vfio/platform/vfio_platform_private.h |  7 +---
 2 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 50a388b..de3fb33 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -30,37 +30,43 @@
 static LIST_HEAD(reset_list);
 static DEFINE_MUTEX(driver_lock);
 
-static const struct vfio_platform_reset_combo reset_lookup_table[] = {
-	{
-		.compat = "calxeda,hb-xgmac",
-		.reset_function_name = "vfio_platform_calxedaxgmac_reset",
-		.module_name = "vfio-platform-calxedaxgmac",
-	},
-};
-
-static void vfio_platform_get_reset(struct vfio_platform_device *vdev,
-				    struct device *dev)
+static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
+					struct module **module)
 {
-	int (*reset)(struct vfio_platform_device *);
-	int i;
+	struct vfio_platform_reset_node *iter;
+	vfio_platform_reset_fn_t reset_fn = NULL;
 
-	for (i = 0 ; i < ARRAY_SIZE(reset_lookup_table); i++) {
-		if (!strcmp(reset_lookup_table[i].compat, vdev->compat)) {
-			request_module(reset_lookup_table[i].module_name);
-			reset = __symbol_get(
-				reset_lookup_table[i].reset_function_name);
-			if (reset) {
-				vdev->reset = reset;
-				return;
-			}
+	mutex_lock(&driver_lock);
+	list_for_each_entry(iter, &reset_list, link) {
+		if (!strcmp(iter->compat, compat) &&
+			try_module_get(iter->owner)) {
+			*module = iter->owner;
+			reset_fn = iter->reset;
+			break;
 		}
 	}
+	mutex_unlock(&driver_lock);
+	return reset_fn;
+}
+
+static void vfio_platform_get_reset(struct vfio_platform_device *vdev)
+{
+	char modname[256];
+
+	vdev->reset = vfio_platform_lookup_reset(vdev->compat,
+						&vdev->reset_module);
+	if (!vdev->reset) {
+		snprintf(modname, 256, "vfio-reset:%s", vdev->compat);
+		request_module(modname);
+		vdev->reset = vfio_platform_lookup_reset(vdev->compat,
+							 &vdev->reset_module);
+	}
 }
 
 static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
 {
 	if (vdev->reset)
-		symbol_put_addr(vdev->reset);
+		module_put(vdev->reset_module);
 }
 
 static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
@@ -557,7 +563,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return ret;
 	}
 
-	vfio_platform_get_reset(vdev, dev);
+	vfio_platform_get_reset(vdev);
 
 	mutex_init(&vdev->igate);
 
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index f8072d8..e505c15 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -58,6 +58,7 @@ struct vfio_platform_device {
 	struct mutex			igate;
 	struct module			*parent_module;
 	const char			*compat;
+	struct module			*reset_module;
 
 	/*
 	 * These fields should be filled by the bus specific binder
@@ -81,12 +82,6 @@ struct vfio_platform_reset_node {
 	vfio_platform_reset_fn_t reset;
 };
 
-struct vfio_platform_reset_combo {
-	const char *compat;
-	const char *reset_function_name;
-	const char *module_name;
-};
-
 extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 				      struct device *dev);
 extern struct vfio_platform_device *vfio_platform_remove_common
-- 
1.9.1
