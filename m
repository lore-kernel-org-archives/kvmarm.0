Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1204F34BA42
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570191; cv=none; b=fwBMgYZWEh2rHNlGugqBkYxNnaJ9momUpKQPGW3RmsDAdloP2EIvy14Hp2mFEsGS5JegW+AVYVBOYdgMUJ56H6MtiICnrsYQt1ie878DIjniDi2i4bt9pVloScUZMKrFJHPBm5UF9Y+f74c3yuKylQvD9jHtdvSPP0MFSqcLSso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570191; c=relaxed/simple;
	bh=HRcWesycBRIrtYA2FNPz6+DS3L5FWoaqyd5dU9cgsUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=E0PY7R9hlYzXdqt327w7SMusRIYZsMJxxkO0IH8xJuvy4zXmsjMJdZLkHuYf6Po/EK5vmahU9MU1sio63cE+Kdm4timsExx3C0mVHDwSMBEsD3bLoO4/MPspJEEkfShBf2jsOOzQshWWh23eHnj8gq9uPS0Tp5wh4vGHfM8Ebx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qb9PmLIy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qb9PmLIy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4S3N0U439U9iYEarGUCeZ1+05b8GOYj9R0ajwwoi0Mc=;
	b=Qb9PmLIyT0l2r9pb7GAl84PwsfrmDid5a5iqCfzW8CSFRXdEo/9jXObuNRZP7JMTtKUNeY
	hIp7xJve9sewUJse4riRo+dTkWx7r6lJRjKD9Wd9Q6dmMMVcNp+X8Dd/Dqka7HgbYMOjPZ
	Ej68gpELWiUXSTrQ63UMFJiavjhGy/w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-D3QXHwrGNbGaFhurNwJDdg-1; Wed,
 16 Sep 2026 10:49:45 -0400
X-MC-Unique: D3QXHwrGNbGaFhurNwJDdg-1
X-Mimecast-MFC-AGG-ID: D3QXHwrGNbGaFhurNwJDdg_1789570183
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65E60195E920;
	Wed, 16 Sep 2026 14:49:43 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC19319560AB;
	Wed, 16 Sep 2026 14:49:38 +0000 (UTC)
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
Subject: [PATCH v9 25/26] arm-qmp-cmds: introspection for ID register props
Date: Wed, 16 Sep 2026 16:45:48 +0200
Message-ID: <20260916144721.751810-26-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: BteKg2a6aynGjs_LwK7W13jsGUTfvAB5yYguWpqZsRc_1789570183
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Enhance the current host model query-cpu-model-expansion with the
capability to return SYSREG_* options and also test possible
values.

If no SYSREG prop is set, query-cpu-model-expansion returns the
default host values for all SYSREG properties. They are extracted
from a scratch vcpu featuring all the KVM advertised capabilities.

Here is a qmp-shell example:

(QEMU) query-cpu-model-expansion type=full model={"name":"host"}
{"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
"SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
"SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
"SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
../..

It becomes also possible to test new SYSREG property values.

With Full expansion of the host model, the SYSREG props are tested
against a scratch vcpu. With static expansion, no check is performed
against KVM but only against qemu code (the value does not exceed the
field size and if the field is associated to enum values, the set
value belongs to the list of arch enum values.

Examples
(QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
{"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}

(QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
{"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!"}}

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v8 -> v9:
- fix the leak reported by Khushit
- implement static mode for host

v7 -> v8:
- do not check if the prop exists (this is checked elsewhere with a
  different error message)
- clarify that examples given in the commit msg are based on qmp-shell

v5 -> v6:
- add the write capability
---
 target/arm/arm-qmp-cmds.c | 107 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 104 insertions(+), 3 deletions(-)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 83ec95c290..b52ca67f83 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -21,6 +21,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "qemu/target-info.h"
 #include "hw/core/boards.h"
 #include "kvm_arm.h"
@@ -30,6 +31,7 @@
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-commands-misc-arm.h"
 #include "qobject/qdict.h"
+#include "qobject/qnum.h"
 #include "qom/qom-qobject.h"
 #include "cpu.h"
 
@@ -83,15 +85,20 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
                                                      CpuModelInfo *model,
                                                      Error **errp)
 {
+    bool use_scratch_vcpu = kvm_enabled() && type == CPU_MODEL_EXPANSION_TYPE_FULL;
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
 
-    if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
+    /* we support static expansion for host model only */
+    if (type != CPU_MODEL_EXPANSION_TYPE_FULL && strcmp(model->name, "host")) {
         error_setg(errp, "The requested expansion type is not supported");
         return NULL;
     }
@@ -136,6 +143,7 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
     if (model->props) {
         Visitor *visitor;
         Error *err = NULL;
+        int fd = -1;
 
         visitor = qobject_input_visitor_new(model->props);
         if (!visit_start_struct(visitor, "model.props", NULL, 0, errp)) {
@@ -146,6 +154,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
 
         qdict_in = qobject_to(QDict, model->props);
         i = 0;
+
+        /* Test legacy composite option settings */
         while ((name = cpu_model_advertised_features[i++]) != NULL) {
             if (qdict_get(qdict_in, name)) {
                 if (!object_property_set(obj, name, visitor, &err)) {
@@ -154,11 +164,85 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
             }
         }
 
+        if (!err) {
+            arm_cpu_finalize_features(ARM_CPU(obj), &err);
+        }
+
+        /**
+         * Test SYSREG option settings
+         * In full mode, build a scratch vcpu that reflects composite legacy
+         * options
+         */
+        if (use_scratch_vcpu) {
+            Error *local_err = NULL;
+            bool has_virt = object_property_get_bool(OBJECT(current_machine),
+                                                     "virtualization",
+                                                     &local_err);
+
+           if (local_err) {
+                error_free(local_err); /* the machine property does not exist */
+            } else {
+                if (!has_virt && object_property_find(obj, "has_el2")) {
+                    object_property_set_bool(obj, "has_el2", false, NULL);
+                }
+            }
+            fd = kvm_arm_create_init_scratch_vcpu(ARM_CPU(obj), errp);
+            if (fd < 0) {
+                return NULL;
+            }
+        }
+
+        qdict_in = qobject_to(QDict, model->props);
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
+                goto bail_out;
+            }
+
+            v = qobject_input_visitor_new(val_obj);
+
+            if (!object_property_set(obj, key, v, errp)) {
+                goto bail_out;
+            }
+
+            if (use_scratch_vcpu) {
+                ARM64SysRegField *field = (ARM64SysRegField *)prop->opaque;
+                uint64_t newfv;
+
+                if (!visit_type_uint64(v, name, &newfv, errp)) {
+                    visit_free(v);
+                    goto bail_out;
+                }
+                success = kvm_idreg_write_scratch_vcpu(ARM_CPU(obj), fd,
+                                                       field, newfv, errp);
+                if (!success) {
+                    visit_free(v);
+                    goto bail_out;
+                }
+            }
+            visit_free(v);
+        }
+
         if (!err) {
             visit_check_struct(visitor, &err);
         }
-        if (!err) {
-            arm_cpu_finalize_features(ARM_CPU(obj), &err);
+
+        if (use_scratch_vcpu) {
+            kvm_arm_destroy_scratch_host_vcpu(fdarray);
         }
         visit_end_struct(visitor, NULL);
         visit_free(visitor);
@@ -190,6 +274,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
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
@@ -199,6 +295,11 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
     object_unref(obj);
 
     return expansion_info;
+bail_out:
+    if (use_scratch_vcpu) {
+        kvm_arm_destroy_scratch_host_vcpu(fdarray);
+    }
+    return NULL;
 }
 
 static void arm_cpu_add_definition(gpointer data, gpointer user_data)
-- 
2.53.0

