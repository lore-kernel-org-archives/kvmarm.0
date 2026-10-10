Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D3E370AFC
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639508; cv=none; b=OVyOwHd0cNjkpycOjWJUQYbJxiKLw2WHvPsuOhLw8v21gEobNIifc192nl3MIB+cUPFN1FGxDCtSXDV/OuSa8fPMovthCHvltM9YiYgeXY1yAjfw6udPun5zoDaF4Wm/R0BlTUcd2I7cseMEG4d5lyWU84tS0lq4JVImZG9pVew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639508; c=relaxed/simple;
	bh=OB0xxgJ2arKO0qxTJ9aj6Yi7xDzncq62lyZIJHWOfZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=T/q7QNzg+dKX+Wip1tiEpvsJQNi3iMV/AlDm4PCTDci/brx/msNwAn7g0d3+kIu6wZ8JIA2ZwFU6qs/DmsDmJnIg07sKyZMoSf+MGDK+hrHSsqfA7qsfmDpbxXds2LkC8eY1lFMPPBMcG7PHRLkVUSywUWYdD3/H39Ie1Hqi7co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U0Vx27Xu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U0Vx27Xu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILTUNRi9n3hKTKcl3Z/fNaw1glWurmvLUwAogbRUuz8=;
	b=U0Vx27XuGl6b7z1rJgVBRJyeABptxGAtvUmMSFILlawWte6tlveaQSIyQl5LxZMPY2u7fV
	eJZOmXDT85L9ICWu9FTLhb0D36dHauT7ND/b27SZYSJvxMnPru5xvf+RmdSKK566nf9p3a
	8XO2/CHffB4SrZAZPXJKOlrb6XEV0v8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-0mZ0OzNXPluz2j2HDN613Q-1; Sat,
 10 Oct 2026 13:38:22 +0000
X-MC-Unique: 0mZ0OzNXPluz2j2HDN613Q-1
X-Mimecast-MFC-AGG-ID: 0mZ0OzNXPluz2j2HDN613Q_1791639501
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE21819540FC;
	Sat, 10 Oct 2026 13:38:20 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 89C9230000E5;
	Sat, 10 Oct 2026 13:38:15 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v10 09/26] target/arm/cpu_idregs: Generate tables for Arm64 ID registers and fields
Date: Sat, 10 Oct 2026 15:36:13 +0200
Message-ID: <20261010133725.642498-10-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Gw1zQ8ajSU5LTS7LXsqGT0ziYqjZpfLq-eHUB9DP-9c_1791639501
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Shaju Abraham <shaju.abraham@nutanix.com>

Include cpu-idregs.h.inc multiple times with different definitions for the
X-macros. This will generate tables for all Arm64 ID registers and their
fields. Additionally, initialize the tables with all architecturally defined
values. These tables will be consumed by the property layer in future
patches.

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v9 -> v10
- fix tabs
- initialize writable_mask
- Use ValueRange instead of Value

v7 -> v8
Adaptation after removal of struct ArmIdRegArchVal

v5 -> v6
- restored support of enum values
---
 target/arm/cpu-idregs.c | 93 +++++++++++++++++++++++++++++++++++++++++
 target/arm/meson.build  |  1 +
 2 files changed, 94 insertions(+)
 create mode 100644 target/arm/cpu-idregs.c

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
new file mode 100644
index 0000000000..122ef9c82d
--- /dev/null
+++ b/target/arm/cpu-idregs.c
@@ -0,0 +1,93 @@
+/*
+ *   ARM ID register field table.
+ *
+ *   Builds the per-id-register field descriptor arrays and the global
+ *   arm_idregs[] table.
+ *
+ *  SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "qapi/error.h"
+#include "cpu.h"
+#include "cpu-idregs.h"
+
+/*
+ * Generate an array of architecturally defined value ranges for each field
+ * that has enum / ValueRange constraints.
+ */
+
+#define IDREG_ARCH_VALUE_RANGE(_lo, _hi) { .lo = (_lo), .hi = (_hi) }
+
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD(reg, field, shift, length)
+#define IDREG_FIELD_ENUM(reg, field, shift, length, ...) \
+    static const ARM64SysRegArchValueRange reg##_##field##_arch_value_ranges[] = { \
+        __VA_ARGS__                                                              \
+    };
+
+#include "cpu-idregs.h.inc"
+
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD
+#undef IDREG_FIELD_ENUM
+#undef IDREG_ARCH_VALUE_RANGE
+
+/* generate an array of per-register ArmIdRegField[] descriptors */
+
+#define IDREG_START(reg) \
+    static ARM64SysRegField reg##_fields[] = {
+
+#define IDREG_END(reg) \
+    };
+
+#define IDREG_ARCH_VALUE_RANGE(_lo, _hi)
+
+#define IDREG_FIELD_ENUM(reg, field, _shift, _length, ...)           \
+    {                                                                \
+        .name = #field,                                              \
+        .index = reg##_IDX,                                          \
+        .shift = (_shift),                                           \
+        .length = (_length),                                         \
+        .arch_value_ranges = reg##_##field##_arch_value_ranges,      \
+        .arch_value_ranges_count =                                   \
+            ARRAY_SIZE(reg##_##field##_arch_value_ranges),           \
+    },
+
+#define IDREG_FIELD(reg, field, _shift, _length)  \
+    {                                             \
+        .name = #field,                           \
+        .index = reg##_IDX,                       \
+        .shift = (_shift),                        \
+        .length = (_length),                      \
+    },
+
+#include "cpu-idregs.h.inc"
+
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD
+#undef IDREG_FIELD_ENUM
+#undef IDREG_ARCH_VALUE_RANGE
+
+/* generate an array of top level ID registers */
+
+#define IDREG_END(reg)
+#define IDREG_FIELD(reg, field, shift, length)
+#define IDREG_FIELD_ENUM(reg, field, shift, length, ...)
+#define IDREG_ARCH_VALUE_RANGE(_lo, _hi)
+
+#define IDREG_START(reg)                            \
+    [reg##_IDX] = {                                 \
+        .name = #reg,                               \
+        .index = reg##_IDX,                         \
+        .fields = reg##_fields,                     \
+        .fields_count = ARRAY_SIZE(reg##_fields),   \
+        .writable_mask = 0ULL,                      \
+    },
+
+ARM64SysReg arm64_id_regs[NUM_ID_IDX] = {
+#include "cpu-idregs.h.inc"
+};
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 0369f96b4c..384d90c530 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -30,6 +30,7 @@ arm_common_user_system_ss.add(when: 'TARGET_AARCH64', if_true: files(
 
 arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
+  'cpu-idregs.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-- 
2.53.0

