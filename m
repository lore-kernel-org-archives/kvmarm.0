Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B64E328243
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570107; cv=none; b=MyxoviEpZ+N6Cbx/YO4aG1PvTY/7u0c/J91TXcNAWJuP3izA2xC/uz9vpgtcJ2CgAQvs0Ei9AtVyndLh4IOjlL5BeEUe7JLmw85UeIRF2AMqgxskdraxAfWk2xachuCZHoxcxAq2MvTOlN1JVNN1cC4xnhh273LHCMdjw0F3XXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570107; c=relaxed/simple;
	bh=WFBOv1DY2POSeFR8VOPysTeGwbbVOC4g3TiFmsQCxDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=WNkGKpE483mlZZ/jbiT4ujcfKTVzPMFh9z5Eopl/99EdS4o+GotG6n3kN73X6Rq/99u3gn6mlwC8XTlc8p6cC18c/PgfIr7QAlbQBWsfAHTmXSvyh6uFB/DUUO4iHQPfLF1VdyCHl4W0fgagREAAUNrRd3Ketzg45E7Qs3rt+b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdGmfEza; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdGmfEza"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PzafFAHJ+JuQ419Pd2AgzOQK4IKnevrH99FqNJV+tzQ=;
	b=gdGmfEza8vhlm/pj5ccYbWgvKVzyhl5qPnoLUy/xGI19JIq8IWGpKxxQMRcitUsFFP0DQB
	+cvRqMU+4ICa+hq51gSugXja7od57AaIz851lJUKZFKlnkiXmZuWVsKAeXobluzPvriSHf
	GArKG3VHbUrtgbGTd3nRuJpPEkmxOhk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-GuMFuuQDMsWhU9Qn_8wBsw-1; Wed,
 16 Sep 2026 10:48:21 -0400
X-MC-Unique: GuMFuuQDMsWhU9Qn_8wBsw-1
X-Mimecast-MFC-AGG-ID: GuMFuuQDMsWhU9Qn_8wBsw_1789570099
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAF6D1843AFF;
	Wed, 16 Sep 2026 14:48:19 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C344B19560AB;
	Wed, 16 Sep 2026 14:48:14 +0000 (UTC)
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
Subject: [PATCH v9 09/26] target/arm/cpu_idregs: generate tables for Arm64 ID registers and fields
Date: Wed, 16 Sep 2026 16:45:32 +0200
Message-ID: <20260916144721.751810-10-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ct6lKgX_-qDASvFsWrec4MtvSvw6YWfyObgA-LloWzU_1789570099
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Shaju Abraham <shaju.abraham@nutanix.com>

Include cpu-idregs.h.inc multiple times with different definitions for the
X-macros. This will generate tables for all Arm64 ID registers and their
fields. Additionally, initialize the tables with all architecturally defined
values. These tables will be consumed by the property layer in future
patches.

Note:
This triggers a minot checkpatch error but I prefer to keep the coma in
the macro.
ERROR: Macros with complex values should be enclosed in parenthesis
+#define IDREG_FIELD_ARCH_VAL(v) (v),

Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v7 -> v8
Adaptation after removal of struct ArmIdRegArchVal

v5 -> v6
- restored support of enum values
---
 target/arm/cpu-idregs.c | 96 +++++++++++++++++++++++++++++++++++++++++
 target/arm/meson.build  |  1 +
 2 files changed, 97 insertions(+)
 create mode 100644 target/arm/cpu-idregs.c

diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
new file mode 100644
index 0000000000..199d593153
--- /dev/null
+++ b/target/arm/cpu-idregs.c
@@ -0,0 +1,96 @@
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
+ * Generate an array of architecturely defined values for each field
+ * associated with enum values
+ */
+
+#define IDREG_START(reg)
+#define IDREG_END(reg)
+#define IDREG_FIELD(reg, field, shift, length)
+#define IDREG_FIELD_START(reg, field, shift, length) \
+    static const uint64_t reg##_##field##_arch_vals[] = {
+#define IDREG_FIELD_ARCH_VAL(v) (v),
+#define IDREG_FIELD_END(reg, field) \
+    };
+
+#include "cpu-idregs.h.inc"
+
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL
+
+/* generate an array of per-register ArmIdRegField[] descriptors */
+
+#define IDREG_START(reg) \
+    static ARM64SysRegField reg##_fields[] = {
+
+#define IDREG_END(reg) \
+    };
+
+#define IDREG_FIELD_START(reg, field, _shift, _length)  \
+    {                                                                 \
+        .name = #field, \
+        .index = reg##_IDX, \
+        .shift = (_shift),                                            \
+        .length = (_length),                                          \
+        .arch_vals = (uint64_t *)reg##_##field##_arch_vals,    \
+        .arch_vals_count = ARRAY_SIZE(reg##_##field##_arch_vals),     \
+    },
+
+#define IDREG_FIELD(reg, field, _shift, _length) \
+    { \
+        .name = #field, \
+        .index = reg##_IDX, \
+        .shift = (_shift), \
+        .length = (_length), \
+    },
+
+#define IDREG_FIELD_ARCH_VAL(v)
+
+#define IDREG_FIELD_END(reg, field)
+
+#include "cpu-idregs.h.inc"
+
+#undef IDREG_START
+#undef IDREG_END
+#undef IDREG_FIELD
+#undef IDREG_FIELD_START
+#undef IDREG_FIELD_END
+#undef IDREG_FIELD_ARCH_VAL
+
+/* generate an array of top level ID registers */
+
+#define IDREG_END(reg)
+#define IDREG_FIELD(reg, field, shift, length)
+#define IDREG_FIELD_START(reg, field, shift, length)
+#define IDREG_FIELD_ARCH_VAL(v)
+#define IDREG_FIELD_END(reg, field)
+
+#define IDREG_START(reg) \
+    [reg##_IDX] = { \
+        .name = #reg, \
+        .index = reg##_IDX, \
+        .fields = reg##_fields, \
+        .fields_count = ARRAY_SIZE(reg##_fields), \
+    },
+
+ARM64SysReg arm64_id_regs[NUM_ID_IDX] = {
+#include "cpu-idregs.h.inc"
+};
+
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

