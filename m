From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 2/6] vfio: platform: reset: add
 vfio_platform_reset_private.h
Date: Thu, 22 Oct 2015 11:41:58 +0200
Message-ID: <1445506922-6005-3-git-send-email-eric.auger@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3570A412D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 05:39:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ffw3+7kbsk9K for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 05:39:35 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3668D412E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 05:39:35 -0400 (EDT)
Received: by wicfx6 with SMTP id fx6so127280387wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 02:42:12 -0700 (PDT)
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

This header is to be included in all vfio reset modules. It
defines the module_vfio_reset_handler macro whose role is
- to define a module alias
- implement module init/exit function which respectively registers
  and unregisters the reset function.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2: creation
- this defines the module_vfio_reset_handler macro as suggested by Arnd

Although Arnd suggested me to remove the vfio_platform_register_reset
symbol_get (since the module manager can handle the case where the
vfio-platform driver is not loaded), I prefered to keep it while
introducing the macro. The rationale is, when using symbol_get/put
we are able to release the hold from the reset module on vfio-platform
as soon as the registration is complete and I think this makes sense.
---
 drivers/vfio/platform/reset/Makefile               |  2 +-
 .../platform/reset/vfio_platform_reset_private.h   | 66 ++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_reset_private.h

diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
index 2a486af..154a7d5 100644
--- a/drivers/vfio/platform/reset/Makefile
+++ b/drivers/vfio/platform/reset/Makefile
@@ -1,5 +1,5 @@
 vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
 
-ccflags-y += -Idrivers/vfio/platform
+ccflags-y += -Idrivers/vfio/platform -Idrivers/vfio/platform/reset
 
 obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
diff --git a/drivers/vfio/platform/reset/vfio_platform_reset_private.h b/drivers/vfio/platform/reset/vfio_platform_reset_private.h
new file mode 100644
index 0000000..f212a61
--- /dev/null
+++ b/drivers/vfio/platform/reset/vfio_platform_reset_private.h
@@ -0,0 +1,66 @@
+/*
+ * Interface used by VFIO platform reset modules to register/unregister
+ * their reset function
+ *
+ * Copyright (c) 2015 Linaro Ltd.
+ *              www.linaro.org
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef VFIO_PLATFORM_RESET_PRIVATE_H
+#define VFIO_PLATFORM_RESET_PRIVATE_H
+
+#include <linux/module.h>
+#include "vfio_platform_private.h"
+
+static int reset_module_register(struct module *module,
+				    const char *compat,
+				    vfio_platform_reset_fn_t reset)
+{
+	int (*register_reset)(struct module *, const char*,
+				vfio_platform_reset_fn_t);
+	int ret;
+
+	register_reset = symbol_get(vfio_platform_register_reset);
+	if (!register_reset)
+		return -EINVAL;
+	ret = register_reset(module, compat, reset);
+	symbol_put(vfio_platform_register_reset);
+	return ret;
+}
+
+static void reset_module_unregister(const char *compat)
+{
+	int (*unregister_reset)(const char *);
+
+	unregister_reset = symbol_get(vfio_platform_unregister_reset);
+	if (!unregister_reset)
+		return;
+
+	unregister_reset(compat);
+
+	symbol_put(vfio_platform_unregister_reset);
+}
+
+#define module_vfio_reset_handler(compat, reset)			\
+MODULE_ALIAS("vfio-reset:" compat);					\
+static int __init reset ## _module_init(void)				\
+{									\
+	return reset_module_register(THIS_MODULE, compat, &reset);	\
+};									\
+static void __exit reset ## _module_exit(void)				\
+{                                                                       \
+	reset_module_unregister(compat);				\
+};									\
+module_init(reset ## _module_init);					\
+module_exit(reset ## _module_exit)
+
+#endif /* VFIO_PLATFORM_RESET_PRIVATE_H */
-- 
1.9.1
