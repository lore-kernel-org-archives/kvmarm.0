Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473663043C8
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616499; cv=none; b=PiyHRBAd6XLtp2hK64Zvad2wzmM0NDpzRt6LHf8vRzJTw23WV9J4OPs1D6ayNFlBle8l5avTlDogXWNrQH24R+QPzAPPE6c6Fdis+RNLAEFP/0Jkzg+aSiKKGdFcfa2ShKPvKcsG7eigfIA+S2z4+Ou8jNDeGPJBNuNBvbjySoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616499; c=relaxed/simple;
	bh=zh/2Cm8kkXHbLI3NcrcsceJMeLUOqK4A8bm+bNmOq98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=C8fUC2ZKF7Obyj+JUAy43TnU/lG8CoHWH4hC8hKYLdzEOewUoJshpeTvLK4x6EZUwtASYjaj5X/kAWY/rw8dFFVEKjBmhjdSQHBfOB3gXf5/5BFNtqjsmcnOPMF8t2sM8ipbKYdGIbAl2Uz+Y6N2ez5y43opWUDQ7VRigBnLON4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QxDNOxjl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QxDNOxjl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781616497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+A/vxmsYMKabhk+ehh5QLIxfuqjhwoqhOGg2BRC+lg=;
	b=QxDNOxjlVX5yIgQbVb3ucMo64JmcqNdvoThKnCyNGBqeympx2D2+mlmovfp51GdGR6i093
	/slMT6eOiDQ19HdyliFUAyUzKJMJUj/SBIzoB4HUykbjr+2s9vrTwekoUQQmCX7dgeHtUI
	KtxYOOH26rH2yDbpyzHi+zdeG5SCew4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-E4Wf4MNxOuiusikl6tK3Kg-1; Tue,
 16 Jun 2026 09:28:13 -0400
X-MC-Unique: E4Wf4MNxOuiusikl6tK3Kg-1
X-Mimecast-MFC-AGG-ID: E4Wf4MNxOuiusikl6tK3Kg_1781616491
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C770A1805A17;
	Tue, 16 Jun 2026 13:28:11 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8C5E43000203;
	Tue, 16 Jun 2026 13:28:05 +0000 (UTC)
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
Subject: [RFC PATCH v6 14/17] arm-qmp-cmds: introspection for ID register props
Date: Tue, 16 Jun 2026 15:17:01 +0200
Message-ID: <20260616132625.1732031-15-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-1-eric.auger@redhat.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Q4XajTLEwIndbB-BGLGyrvuaZB0k5FSsppRsqPEeajw_1781616491
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Implement the capability to query available ID register values by
adding SYSREG_* options and values to the cpu model expansion for the
host model, if available.

Excerpt:
(QEMU) query-cpu-model-expansion type=full model={"name":"host"}
{"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
"SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
"SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
"SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
../..

So this allows the upper stack to detect available writable ID
regs and the "host passthrough model" values.

It also allows to test some ID reg field values:
(QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
{"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}

(QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
{"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v5 -> v6:
- add the write capability
---
 target/arm/arm-qmp-cmds.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 83ec95c290..edcfc82a25 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -21,6 +21,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "qemu/target-info.h"
 #include "hw/core/boards.h"
 #include "kvm_arm.h"
@@ -84,6 +85,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
                                                      Error **errp)
 {
     CpuModelExpansionInfo *expansion_info;
+    ObjectPropertyIterator iter;
+    ObjectProperty *idregprop;
     const QDict *qdict_in;
     QDict *qdict_out;
     ObjectClass *oc;
@@ -145,6 +148,20 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         }
 
         qdict_in = qobject_to(QDict, model->props);
+
+        object_property_iter_init(&iter, obj);
+
+        while ((idregprop = object_property_iter_next(&iter))) {
+            if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
+                continue;
+            }
+            if (qdict_get(qdict_in, idregprop->name)) {
+                if (!object_property_set(obj, idregprop->name, visitor, &err)) {
+                    break;
+                }
+            }
+        }
+
         i = 0;
         while ((name = cpu_model_advertised_features[i++]) != NULL) {
             if (qdict_get(qdict_in, name)) {
@@ -190,6 +207,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         }
     }
 
+    object_property_iter_init(&iter, obj);
+
+    while ((idregprop = object_property_iter_next(&iter))) {
+        QObject *value;
+
+        if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
+            continue;
+        }
+        value = object_property_get_qobject(obj, idregprop->name, &error_abort);
+        qdict_put_obj(qdict_out, idregprop->name, value);
+    }
+
     if (!qdict_size(qdict_out)) {
         qobject_unref(qdict_out);
     } else {
-- 
2.53.0

