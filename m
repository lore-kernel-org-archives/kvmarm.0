Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70B348C5D
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197485; cv=none; b=Ug8RbdPiAIB55rcGoMyj50WBnEP+fdxj13o5AM2p/5vg95Z6chSZOlqE67RFduRb7vgfXPoq0WHURKb6wZYSYIxBYbC/oupdmlGu2ykJypWagN94t1T7qEMH/PjjyYtYeYdELeV7mxVLQLjJ8MQ6y4iBY91pSV+TkWywMgf5R0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197485; c=relaxed/simple;
	bh=x3sjYGCRsPLoJkHY7uPCRiBVawZQsCTcyiDTtVFMMDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ngn4IbINy+f/VJ9Mf/CIIWZIe3/yrpQVac7J0DQlHVCsfwKMSHYa69Y7LSjyI3Fgay/Q2oh+IUPlCN8ucbEVoBWveAstm3WbANCJKQ6b+pRBaOIA3g+xxn14aR/tgAf0oFOAkPfZ704jZG3NUFOeWjEXD3Vj1kY5tJniMLb4xDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ETeJZP8I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ETeJZP8I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6acmUpTOGl8Qa1VQO12x4/TymisweT8uTQoRmmue3lw=;
	b=ETeJZP8I9ARvxvIaARY+VkeXzOKhyBGjDtW2S3QOZhOhquRNhsoALKkzKm0yroO3idN3FG
	XhO+tzAZPzepOgnp97+NckJUfd1M3PxuqbTloGFIwa5T9ULJtfIg0WfUnnWF4UQmovZZtj
	i/m9QJvfGBU7Wa/pmizSYyVwAPvbOF8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-kvlK_T8SN-yZzCp6cYhjUg-1; Tue,
 19 May 2026 09:31:14 -0400
X-MC-Unique: kvlK_T8SN-yZzCp6cYhjUg-1
X-Mimecast-MFC-AGG-ID: kvlK_T8SN-yZzCp6cYhjUg_1779197467
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC51618005B6;
	Tue, 19 May 2026 13:31:06 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3F3661800352;
	Tue, 19 May 2026 13:31:01 +0000 (UTC)
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
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v5 17/18] arm-qmp-cmds: introspection for ID register props
Date: Tue, 19 May 2026 15:27:31 +0200
Message-ID: <20260519132905.145643-18-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: o6OQqoh0ecdWvK11yWv_bW_TqPpynfrr5NOlYxpexxw_1779197467
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Implement the capability to query available ID register values by
adding SYSREG_* options and values to the cpu model expansion for the
host model, if available.

Excerpt:
(QEMU) query-cpu-model-expansion type=full model={"name":"host"}
{"return": {"model": {"name": "host", "props":
{"SYSREG_ID_AA64PFR0_EL1_EL3": 1224979098931106066,
"SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
../..

So this allows the upper stack to detect available writable ID
regs and the "host passthrough model" values.

[CH: moved SYSREG_* values to host model]
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

TODO: Add the moment there is no way to test changing a given
ID reg field value. ie:

(QEMU) query-cpu-model-expansion type=full model={"name":"host", "prop":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
---
 target/arm/arm-qmp-cmds.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 83ec95c290..e6c717a872 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -21,6 +21,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "qemu/target-info.h"
 #include "hw/core/boards.h"
 #include "kvm_arm.h"
@@ -190,6 +191,24 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         }
     }
 
+    /* If writable ID regs are supported, add them as well */
+    if (ARM_CPU(obj)->writable_map) {
+        ObjectProperty *prop;
+        ObjectPropertyIterator iter;
+
+        object_property_iter_init(&iter, obj);
+
+        while ((prop = object_property_iter_next(&iter))) {
+            QObject *value;
+
+            if (!g_str_has_prefix(prop->name, "SYSREG_")) {
+                continue;
+            }
+            value = object_property_get_qobject(obj, prop->name, &error_abort);
+            qdict_put_obj(qdict_out, prop->name, value);
+        }
+    }
+
     if (!qdict_size(qdict_out)) {
         qobject_unref(qdict_out);
     } else {
-- 
2.53.0

