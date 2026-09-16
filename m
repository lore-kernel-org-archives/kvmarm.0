Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B33A248880
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570135; cv=none; b=jQjJ5c8w+GYYmAjJYzjZ8FZ1iDSJi2NBN2R8+AvSDsj1s2bGzvg/WB1PRYN6ACJSKtL4KStO+5Mtk04Alxq6fc0TJR+KMlgmloeWZdb3t3cNYS0qz9hkv8XcPWEdmImjpzfIo64vFfpce9nuGns8OcuGxqTcqF23UjqNrtNyKvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570135; c=relaxed/simple;
	bh=L+Q4CBubIf4JEywhQtgxS0JiyTr8xD2R3K6Acchf0rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VbopBetYREVQrDtW62SNPLZnFz/90b73qJioQHmVh1VVdUOKq/R3NiUpu9SEk6yOM8QdrZdiYlm7DWxiStsRjccfKYK9mID1L2VlmFejw73VifyBweX1jMi3qV8Lg5urvV4JkcS5w2fzMtRkAvVcMdg8xqo+A18PVDi/j02GO1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wv2EieB4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wv2EieB4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jM95nmouJtf6ZLy1kR42fC99c9Xk1R+7+8fMZCtX3ao=;
	b=Wv2EieB4f4q5IRv7OHKyBTP8aA3I8OHNHiEwJx3W8cwnEx+91GOGVWr0YiV5k+QJ1SQiuk
	/8YI26kfBGM4WFyzeJS5jYv66VYcgUPx3E+lISwDM1kdfq8KV7QEmUdMmsq4XUMfUqMW/o
	mDXZ8amDVoWK2SFcCM3gTcPz3FmKi7o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-jxgTD__OMdq3_2lnAW-DOg-1; Wed,
 16 Sep 2026 10:48:48 -0400
X-MC-Unique: jxgTD__OMdq3_2lnAW-DOg-1
X-Mimecast-MFC-AGG-ID: jxgTD__OMdq3_2lnAW-DOg_1789570125
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BACC3180217F;
	Wed, 16 Sep 2026 14:48:45 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A52AD19560AB;
	Wed, 16 Sep 2026 14:48:40 +0000 (UTC)
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
Subject: [PATCH v9 14/26] target/arm/kvm: Implement SYSREG property setter and getter
Date: Wed, 16 Sep 2026 16:45:37 +0200
Message-ID: <20260916144721.751810-15-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Mk0FhUdQK_2D5QyQQ-EGnAGl1Kody_inQauc7B6Pysc_1789570125
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When the setter is called, the final vcpu is not created yet.
Applying the override on vcpu.isar initialized with the max scratch
vcpu would not be correct because the final vcpu may have some features
turned off (for instance virtualization) while the scratch vcpu
features it. So we need to postpone the actual override until the
final vcpu has been initialized.

In terms of input value validation what can be done now is checking
against field length and arch enum value if any.

If this succeeds, the field value is added in the hash table to be
written later on once the final vcpu has been created

With regards to the getter, if the sysreg prop was set, we return the
set value, otherwise, we return the value in cpu->isar.idregs[].

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu.h |  2 ++
 target/arm/cpu.c |  5 ++--
 target/arm/kvm.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index e3f931dba2..9bbd42dd2b 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -952,6 +952,8 @@ struct ArchCPU {
     uint64_t *cpreg_vmstate_values;
     int32_t cpreg_vmstate_array_len;
 
+    GHashTable *sysreg_props;
+
     DynamicGDBFeatureInfo dyn_sysreg_feature;
     DynamicGDBFeatureInfo dyn_svereg_feature;
     DynamicGDBFeatureInfo dyn_smereg_feature;
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 77aa78f00e..917f709cb4 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1236,8 +1236,8 @@ static void arm_cpu_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
 
-    cpu->cp_regs = g_hash_table_new_full(g_direct_hash, g_direct_equal,
-                                         NULL, g_free);
+    cpu->cp_regs = g_hash_table_new(g_direct_hash, g_direct_equal);
+    cpu->sysreg_props = g_hash_table_new(g_direct_hash, g_direct_equal);
 
     QLIST_INIT(&cpu->pre_el_change_hooks);
     QLIST_INIT(&cpu->el_change_hooks);
@@ -1725,6 +1725,7 @@ static void arm_cpu_finalizefn(Object *obj)
     ARMCPRegMigTolerance *t, *n;
 
     g_hash_table_destroy(cpu->cp_regs);
+    g_hash_table_destroy(cpu->sysreg_props);
 
     QLIST_FOREACH_SAFE(hook, &cpu->pre_el_change_hooks, node, next) {
         QLIST_REMOVE(hook, node);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 341542279d..cdc3779321 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -340,18 +340,79 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
     return NULL;
 }
 
+#define MAKE_IDREG_KEY(reg_idx, field_shift) \
+    (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
+
 static void set_sysreg_prop(Object *obj, Visitor *v,
                             const char *name, void *opaque,
                             Error **errp)
 {
-    error_setg(errp, "%s setter not yet implemented", name);
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    int index = field->index;
+    int lower = field->shift;
+    int length = field->length;
+    uint64_t key, value;
+
+    if (!visit_type_uint64(v, name, &value, errp)) {
+        return;
+    }
+
+    if (length < 64 && value > ((1 << length) - 1)) {
+        error_setg(errp,
+                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
+                   name, value, length);
+        return;
+    }
+
+    if (field->arch_vals) {
+        /* this field has some enum values */
+        for (int i = 0; i < field->arch_vals_count; i++) {
+            if (value == field->arch_vals[i]) {
+                goto valid;
+            }
+        }
+        error_setg(errp,
+                   "idreg %s set value (0x%lx) does not match any "
+                   "arch valid enum value", name, value);
+        return;
+    }
+
+valid:
+
+    key = MAKE_IDREG_KEY(index, lower);
+    g_hash_table_insert(cpu->sysreg_props, GUINT_TO_POINTER(key),
+                       GUINT_TO_POINTER(value));
 }
 
 static void get_sysreg_prop(Object *obj, Visitor *v,
                             const char *name, void *opaque,
                             Error **errp)
 {
-    error_setg(errp, "%s getter not yet implemented", name);
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    int index = field->index;
+    int lower = field->shift;
+    int length = field->length;
+    gpointer value_ptr;
+    uint64_t value;
+    uint64_t key = MAKE_IDREG_KEY(index, lower);
+    gboolean exists;
+
+    exists = g_hash_table_lookup_extended(cpu->sysreg_props,
+                                          GUINT_TO_POINTER(key), NULL,
+                                          &value_ptr);
+    if (exists) {
+        value = GPOINTER_TO_UINT(value_ptr);
+    } else {
+        uint64_t mask = MAKE_64BIT_MASK(lower, length);
+        uint64_t *idregs = cpu->isar.idregs;
+
+        value = (idregs[index] & mask) >> lower;
+    }
+
+    visit_type_uint64(v, name, &value, errp);
+    trace_get_sysreg_prop(name, value);
 }
 
 /*
-- 
2.53.0

