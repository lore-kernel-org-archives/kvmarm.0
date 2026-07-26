Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1092E3FE
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785080142; cv=none; b=SEHIhsZT6IHS0sk7HAxbNI/c4OT4eOQ+6NTTpdvg+3AK4RcWhGTZAxdYCo4rSxKnmwZ5Erf3oLNEQFd9mlFYr9S0pWlICsSjwxUa38nihvlTCH7lMa20kaL5mcOGSWnAtY8S2shu7NMMuIKliKIS+/uJqhagTB1ae9bsh8kVdhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785080142; c=relaxed/simple;
	bh=SCXK8b6lkEPyBmerD2JYNbl9fN7n8+NCkgzAO5N55rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hb0L42eqcPf5YWJgmAbOxevUimUp09R1wjt/zx0ixEGu6xOHULxsjAHSPnol5dXpmTOu5W15gBElIRS+uHdi64gMWZgg3aRhm/XXSSM/KwBAOB3odl7Xwb0lkNTZuZ8+LwD1wZVhiDlMu2nqsi9XZkVbeoGR8XkZ9+XGPh/p3yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UR3s+SBT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UR3s+SBT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785080139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79eEWr7h105UKSTdAp9opu785TSxRcomqCfmPZNgqg0=;
	b=UR3s+SBTlFAfsx6QVspwuuymcC5RfBbCyh39ZDIPKwYvoSHvtAhQ1RXArG70WiGl/UYjdr
	hmQlKvu9dgKKZegG/kxKw2s2ffHbVoKSg4v0aJVcWtMqNBONfbf9/DnRBWWYTiwLV9yOl9
	T0N/gn6h4fiWyfTyQdq7VKaE/OwgbyQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-MrQKXpiNMw2e1TN2IE5_Ow-1; Sun,
 26 Jul 2026 11:35:37 -0400
X-MC-Unique: MrQKXpiNMw2e1TN2IE5_Ow-1
X-Mimecast-MFC-AGG-ID: MrQKXpiNMw2e1TN2IE5_Ow_1785080135
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A00DC1955F22;
	Sun, 26 Jul 2026 15:35:35 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.32.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 027CD180044F;
	Sun, 26 Jul 2026 15:35:26 +0000 (UTC)
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
Subject: [RFC PATCH v7 18/18] arm-qmp-cmds: introspection for ID register props
Date: Sun, 26 Jul 2026 17:29:56 +0200
Message-ID: <20260726153221.24773-19-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-1-eric.auger@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: jpn5xrC4_6D9Bfl6NilSdJFT3-l-mxojUhmSII9b3MM_1785080135
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

v5 -> v6:
- add the write capability
---
 target/arm/arm-qmp-cmds.c | 98 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 83ec95c290..41fefadcea 100644
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
@@ -133,6 +140,38 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
 
     obj = object_new(object_class_get_name(oc));
 
+    if (kvm_enabled()) {
+        bool pmuv3_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
+        bool sve_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
+        struct kvm_vcpu_init init = { .target = -1, };
+        bool el2_supported = kvm_arm_el2_supported();
+        bool pauth_supported;
+        int ret;
+
+        pauth_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+                          kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC);
+
+        if (sve_supported) {
+            init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
+        }
+        if (el2_supported) {
+            init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
+        }
+        if (pauth_supported) {
+            init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+                             1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+        }
+        if (pmuv3_supported) {
+            init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
+        }
+
+        ret = kvm_arm_create_scratch_host_vcpu(fdarray, &init);
+        if (!ret) {
+            error_setg(errp, "failing creating a scratch vcpu");
+            return NULL;
+        }
+    }
+
     if (model->props) {
         Visitor *visitor;
         Error *err = NULL;
@@ -145,6 +184,49 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
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
+            if (!prop) {
+                error_setg(errp, "%s does not exist!", key);
+                return NULL;
+            }
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
+            if (!object_property_set(obj, key, v, &err)) {
+                error_propagate(errp, err);
+                visit_free(v);
+                return NULL;
+            }
+
+            success = kvm_idreg_write_scratch_vcpu(fdarray[2], v, key,
+                                                   prop->opaque, &err);
+            if (!success) {
+                error_propagate(errp, err);
+                visit_free(v);
+                return NULL;
+            }
+            visit_free(v);
+        }
+
         i = 0;
         while ((name = cpu_model_advertised_features[i++]) != NULL) {
             if (qdict_get(qdict_in, name)) {
@@ -160,6 +242,10 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
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
@@ -190,6 +276,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
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

