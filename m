Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4333A875A
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793853; cv=none; b=vAvuYzjsRhnnzAeMypccBUuB57xUBJu0OKvbrFesjrnmcTCM71RBTJl1bRHPv+IiD/ho55yEl/e1m/dmAg62HFwwKpo3BqKZ0hDbYr3lFx2P3MSJi+pVVeFVnYZJbU6VUYXJN9tzdy+ffILTbtjZE6vvgUaC/8g4v32Pc3S5dX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793853; c=relaxed/simple;
	bh=mQ3RERfSargoI8u5+xiGk5B5UTtgEPku8aqw3drKrBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=p03FpBa3ySFqFR5j59OhOryBL4xqYIKzlJ3fRFeI181x3asNr8MzeP9Jvyxlr0rCSahPze7OiEeV0pgFqBikk43QkRY9Y3B/wKCDzruDUW5HOuRSsAtOap/fm2+6j8uunN/8TU69SF4qDB8HKAGxtY9JtIT7kXAYaCz5wcJfBzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PdRyK5ty; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdRyK5ty"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=62oLUEjH9LSAL/SkXO11p8fSs2k2Esjx+HksDcmaSDQ=;
	b=PdRyK5tytCQTOKR1H7O0ggAf4uLoQP9bfQgvmQAjSaIaoifBVG5w9YYcpplNgt7nSbfrFH
	6mtOFDidF5UwVoMlP70GxfF6AvmYOIHE1z665biyXFfE81HiSU/s/NSTVPd9HNEb9y5vl3
	y+hGrB1tTW8VjBCCrHl15E2BvIUPXLw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-vmK00ZWrP5KUcksXaGW_rg-1; Sun,
 03 May 2026 03:37:26 -0400
X-MC-Unique: vmK00ZWrP5KUcksXaGW_rg-1
X-Mimecast-MFC-AGG-ID: vmK00ZWrP5KUcksXaGW_rg_1777793844
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 919B9195608A;
	Sun,  3 May 2026 07:37:24 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AED771800480;
	Sun,  3 May 2026 07:37:19 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	cohuck@redhat.com,
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
Subject: [PATCH v4 16/17] arm-qmp-cmds: introspection for ID register props
Date: Sun,  3 May 2026 09:33:36 +0200
Message-ID: <20260503073541.790215-17-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: uX35D_Wpd3TF0khZ_4RHPJvNQJchFPlfWwsJ_ZUlqSk_1777793844
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
index 83ec95c290..ea8c541a00 100644
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
+    if (ARM_CPU(obj)->writable_id_regs_status == WRITABLE_ID_REGS_AVAIL) {
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

