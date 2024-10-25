Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630C31DDA1C
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 10:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729851750; cv=none; b=mh5z3ayiq+QdkWcUvrx8Hk+v4cKezrzJz3Wuvc9U+8xd/+rt3Hs9Qxd1VEBSQW8pogsR5yQffQP0OB7XrQjZ+lMjXR4zBYmJZ/gTX9qBKpSM0KvYKr8ac0bBpPqHjEXUayyZqcGrpnMGPHMlqTOGZs9fcZOupAgGZH1VmRiPB2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729851750; c=relaxed/simple;
	bh=blBevQAJkyNNff7dTbmuetbEKUMU6NwGW9CN9U+rIUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/oj9pOAwxCov5ExTW93ggCw20V0au+jddCHvDNnH+fD0ZH4nOnYm1ENA6hRs1oTHDj04AAsJS0XLHiZFsuG67PQMsyhQFY7/XvkmSkYsKyabax7XQerRHVJ4bl2XAeDRBz/SD1f9PrbgU64D/FD9NXvQJfFjQ0BqIniSpEGMik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TI49sS2U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TI49sS2U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729851747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8niAlscBVwwCSjLpFwC9rmVeWlBw2tXPGjOWbhlMyKg=;
	b=TI49sS2Un2nV1oZddUYomNOJ+UbVqpaWb7ixjHnp2SJJNz4X9RhutGQevxT49XkoZU8ZUn
	GfpP+iZ8AzzQRMnPEjAsPcf9SG5qYF8BIz8AQJFLGr5387s34EG8DAeQ7Utkoxx5o7lCAp
	iP/34Aid/86TnYwYBCQ+m5Iz9NGeIWY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-Jkhqw0YEO4OKyY_7Jxd8YA-1; Fri,
 25 Oct 2024 06:22:24 -0400
X-MC-Unique: Jkhqw0YEO4OKyY_7Jxd8YA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E7B519560BD;
	Fri, 25 Oct 2024 10:22:22 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF9C7196BB7D;
	Fri, 25 Oct 2024 10:22:16 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	cohuck@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com
Subject: [RFC 20/21] arm-qmp-cmds: introspection for custom model
Date: Fri, 25 Oct 2024 12:17:39 +0200
Message-ID: <20241025101959.601048-21-eric.auger@redhat.com>
In-Reply-To: <20241025101959.601048-1-eric.auger@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Cornelia Huck <cohuck@redhat.com>

Implement the capability to query available options for the
custom model.

At the moment it only returns SYSREG_* options and values.
Excerpt:
(QEMU) query-cpu-model-expansion type=full model={"name":"custom"}
{"return": {"model": {"name": "custom", "props":
{"SYSREG_ID_AA64PFR0_EL1_EL3": 1224979098931106066,
"SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
../..

So this allows the upper stack to detect available writable ID
regs and the "host passthrough model" values.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

TODO: Add the moment there is no way to test changing a given
ID reg field value. ie:

(QEMU) query-cpu-model-expansion type=full model={"name":"custom", "prop":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
---
 target/arm/arm-qmp-cmds.c | 56 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 3cc8cc738b..4a3f0e6ac6 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -21,6 +21,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "hw/boards.h"
 #include "kvm_arm.h"
 #include "qapi/error.h"
@@ -98,6 +99,47 @@ static const char *cpu_model_advertised_features[] = {
     NULL
 };
 
+static CpuModelExpansionInfo *
+arm_query_custom_cpu_model_expansion(Object *obj, CpuModelExpansionType type,
+                                     CpuModelInfo *model,
+                                     Error **errp)
+{
+    /* returns id register map */
+    CpuModelExpansionInfo *expansion_info;
+    ObjectProperty *prop;
+    ObjectPropertyIterator iter;
+    QDict *qdict_out;
+
+    expansion_info = g_new0(CpuModelExpansionInfo, 1);
+    expansion_info->model = g_malloc0(sizeof(*expansion_info->model));
+    expansion_info->model->name = g_strdup(model->name);
+
+    qdict_out = qdict_new();
+
+    object_property_iter_init(&iter, obj);
+
+    while ((prop = object_property_iter_next(&iter))) {
+        QObject *value;
+
+        if (!g_str_has_prefix(prop->name, "SYSREG_")) {
+            continue;
+        }
+        value = object_property_get_qobject(obj, prop->name, &error_abort);
+        qdict_put_obj(qdict_out, prop->name, value);
+    }
+
+    if (!qdict_size(qdict_out)) {
+        qobject_unref(qdict_out);
+    } else {
+        expansion_info->model->props = QOBJECT(qdict_out);
+    }
+
+    object_unref(obj);
+
+
+    return expansion_info;
+}
+
 CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
                                                      CpuModelInfo *model,
                                                      Error **errp)
@@ -130,7 +172,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
     if (kvm_enabled()) {
         bool supported = false;
 
-        if (!strcmp(model->name, "host") || !strcmp(model->name, "max")) {
+        if (!strcmp(model->name, "host") || !strcmp(model->name, "max") ||
+            !strcmp(model->name, "custom")) {
             /* These are kvmarm's recommended cpu types */
             supported = true;
         } else if (current_machine->cpu_type) {
@@ -152,6 +195,17 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
 
     obj = object_new(object_class_get_name(oc));
 
+    /* The "custom" model is handled differently. */
+    if (!strcmp(model->name, "custom")) {
+        expansion_info = arm_query_custom_cpu_model_expansion(obj, type, model,
+                                                              errp);
+        if (*errp) {
+            object_unref(obj);
+            return NULL;
+        }
+        return expansion_info;
+    }
+
     if (model->props) {
         Visitor *visitor;
         Error *err = NULL;
-- 
2.41.0

