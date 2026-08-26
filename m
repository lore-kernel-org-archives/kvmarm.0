Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E8D348883
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737219; cv=none; b=qeQyO3plmaVBvFt4pzJ6IcTfyVpVmJ/fqYbLN7xU9dJDzAr3aagi036MyqQaUfWNJJ+uHRzQ4H93mfLnBawwr6UwqN71/9kkNne0GpLN1zB484L21xvj7EPttebwcbwuksYHyq7gXKFYRbukrq6dq9412YIOfDcYpfpPWky/6HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737219; c=relaxed/simple;
	bh=R57318t6NrSevFToot7SgyJlzklryqeJNGa00qlesLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=EcHabYyfZSFNsUJauR5SQCZTLNN7kHJGWBy0n+xNF1bBubqZaS5q1wYv6gH6aFARiBaGShxv1s+EvF9CHfFST4xPc71K0Jgd86kegE/m3KPE6n0rDI7EJmoROCuLJYQjJ6F+5GI0boB3dbcM52ZS1xrhmIX6ggGYnEcV08OPskQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BgeQKtXw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BgeQKtXw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a6iZu6rf5S/9O7j6BIxkBTfH3lHbl8hWJ/3LTvlTmQs=;
	b=BgeQKtXwsnWok3JMmERv/QOW0T4JMYSvGBoQp2c9DkKMJ8WBAXR21t72cHMHJn3uYh1a2e
	24/49OpH8FPZNJ0DXtc0azjkza+igIXpnM0B2OhD2ZuKkV6GgKjFV05MBDig81zmWTaOXm
	RjxJUsckF4U0IcL4kKV/6WpquFpRDZ0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-2-9uPRfy80NEqVJnmcp7WuyA-1; Wed,
 26 Aug 2026 05:40:11 -0400
X-MC-Unique: 9uPRfy80NEqVJnmcp7WuyA-1
X-Mimecast-MFC-AGG-ID: 9uPRfy80NEqVJnmcp7WuyA_1787737208
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9693D197765F;
	Wed, 26 Aug 2026 09:40:08 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9A9021955F05;
	Wed, 26 Aug 2026 09:40:02 +0000 (UTC)
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
Subject: [RFC PATCH v8 20/20] arm-qmp-cmds: introspection for ID register props
Date: Wed, 26 Aug 2026 11:36:25 +0200
Message-ID: <20260826093747.1670077-21-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: yLjcwTLSTKh-P7iorm0BTVDOWVFD4WwYzb6SzDIBxzA_1787737208
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Implement the capability to query available ID register values by
adding SYSREG_* options and values to the cpu model expansion for the
host model, if available.

Here are some qmp-shell examples:

(QEMU) query-cpu-model-expansion type=full model={"name":"host"}
{"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
"SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
"SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
"SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
../..

This allows the upper stack to detect available writable ID regs and
the "host passthrough model" values.

It also allows to test some ID reg field values:
(QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
{"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}

(QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
{"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}

The following checks are performed:
- the value does not exceed the field size
- if the field is associated to enum values, the set value must be one
  of those enum values
- the value is applied against a scratch vcpu making sure the setting is
  not rejected for this host

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v7 -> v8:
- do not check if the prop exists (this is checked elsewhere with a
  different error message)
- clarify that examples given in the commit msg are based on qmp-shell

v5 -> v6:
- add the write capability
---
 target/arm/arm-qmp-cmds.c | 73 +++++++++++++++++++++++++++++++++++++++
 target/arm/kvm-stub.c     |  5 +++
 2 files changed, 78 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 83ec95c290..5fbdca3253 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -21,6 +21,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "qemu/target-info.h"
 #include "hw/core/boards.h"
 #include "kvm_arm.h"
@@ -30,7 +31,10 @@
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-commands-misc-arm.h"
 #include "qobject/qdict.h"
+#include "qobject/qnum.h"
 #include "qom/qom-qobject.h"
+#include <linux/kvm.h>
+#include "system/kvm.h"
 #include "cpu.h"
 
 static GICCapability *gic_cap_new(int version)
@@ -84,11 +88,14 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
                                                      Error **errp)
 {
     CpuModelExpansionInfo *expansion_info;
+    ObjectPropertyIterator iter;
     const QDict *qdict_in;
+    ObjectProperty *idregprop;
     QDict *qdict_out;
     ObjectClass *oc;
     Object *obj;
     const char *name;
+    int fdarray[3];
     int i;
 
     if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
@@ -133,6 +140,17 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
 
     obj = object_new(object_class_get_name(oc));
 
+    if (kvm_enabled()) {
+        uint32_t init_features0, target;
+        bool success;
+
+        success = kvm_arm_create_scratch_max_host_vcpu(fdarray, &init_features0,
+                                                       &target, errp);
+        if (!success) {
+            return NULL;
+        }
+    }
+
     if (model->props) {
         Visitor *visitor;
         Error *err = NULL;
@@ -145,6 +163,45 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         }
 
         qdict_in = qobject_to(QDict, model->props);
+
+        for (const QDictEntry *entry = qdict_first(qdict_in);
+                 entry != NULL; entry = qdict_next(qdict_in, entry)) {
+            const char *key = qdict_entry_key(entry);
+            QObject *val_obj = qdict_entry_value(entry);
+            ObjectProperty *prop;
+            Visitor *v;
+            bool success;
+            uint64_t val;
+
+            prop = object_property_find(obj, key);
+
+            if (!g_str_has_prefix(key, "SYSREG_")) {
+                continue;
+            }
+
+            /* consume the prop to avoid unexpected parameter */
+            if (!visit_type_uint64(visitor, key, &val, errp)) {
+                return NULL;
+            }
+
+            v = qobject_input_visitor_new(val_obj);
+
+            if (!object_property_set(obj, key, v, errp)) {
+                visit_free(v);
+                return NULL;
+            }
+
+            if (kvm_enabled()) {
+                success = kvm_idreg_write_scratch_vcpu(fdarray[2], v, key,
+                                                       prop->opaque, errp);
+                if (!success) {
+                    visit_free(v);
+                    return NULL;
+                }
+            }
+            visit_free(v);
+        }
+
         i = 0;
         while ((name = cpu_model_advertised_features[i++]) != NULL) {
             if (qdict_get(qdict_in, name)) {
@@ -160,6 +217,10 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         if (!err) {
             arm_cpu_finalize_features(ARM_CPU(obj), &err);
         }
+
+        if (kvm_enabled()) {
+            kvm_arm_destroy_scratch_host_vcpu(fdarray);
+        }
         visit_end_struct(visitor, NULL);
         visit_free(visitor);
         if (err) {
@@ -190,6 +251,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
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
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 0d6c841a24..eae2e1ec2c 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -132,3 +132,8 @@ bool kvm_arm_create_scratch_max_host_vcpu(int *fdarray,
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_destroy_scratch_host_vcpu(int *fdarray)
+{
+    g_assert_not_reached();
+}
-- 
2.53.0

