From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 3/7] vfio: platform: introduce module_vfio_reset_handler
 macro
Date: Fri, 23 Oct 2015 17:47:21 +0200
Message-ID: <1445615245-31124-4-git-send-email-eric.auger@linaro.org>
References: <1445615245-31124-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6AF41349
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 11:44:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0by3LK0Q-9Qe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 11:44:57 -0400 (EDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D037741457
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 11:44:56 -0400 (EDT)
Received: by wijp11 with SMTP id p11so83412331wij.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:47:37 -0700 (PDT)
In-Reply-To: <1445615245-31124-1-git-send-email-eric.auger@linaro.org>
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

The module_vfio_reset_handler macro
- define a module alias
- implement module init/exit function which respectively registers
  and unregisters the reset function.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v4:
- pass reset to vfio_platform_unregister_reset

v2 -> v3:
- use vfio_platform_register_reset macro

v1 -> v2:
- remove vfio_platform_reset_private.h and move back the macro to
  vfio_platform_private.h header: removed reset_module_register &
  unregister (symbol_get)
- defines the module_vfio_reset_handler macro as suggested by Arnd
  (formerly in vfio_platform_reset_private.h)
---
 drivers/vfio/platform/vfio_platform_private.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index c563940..fd262be 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -110,4 +110,18 @@ static struct vfio_platform_reset_node __reset ## _node = {	\
 };								\
 __vfio_platform_register_reset(&__reset ## _node)
 
+#define module_vfio_reset_handler(compat, reset)		\
+MODULE_ALIAS("vfio-reset:" compat);				\
+static int __init reset ## _module_init(void)			\
+{								\
+	vfio_platform_register_reset(compat, reset);		\
+	return 0;						\
+};								\
+static void __exit reset ## _module_exit(void)			\
+{								\
+	vfio_platform_unregister_reset(compat, reset);		\
+};								\
+module_init(reset ## _module_init);				\
+module_exit(reset ## _module_exit)
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
1.9.1
