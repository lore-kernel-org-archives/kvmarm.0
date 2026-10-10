Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A4717DFFA
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639531; cv=none; b=gc+KBnRxtw0bYtEtORwLIdlMkEtt8bqvhD9EH4uiE79jyvnP1dVgGp3h9o0LWbh83u5pgl0qodVq0DGoXRdFzv/C/Eeuwh+r0KN5h1W2ARnkhPPbIavSMMpnhb34Z23s9cusglcSIt/ggNsF18keRCsa1gJ64nOVDIrutcqNXPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639531; c=relaxed/simple;
	bh=CQ8B8Bl+HPwF1AN+4jM/AX2/sWnlDraMYFS/4eM94W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=BELZhPXIdU+hn7Exymw6OeSotc+0XWOvlgmks8iSghzTUqLRBsSKxiCINMZBRtQ3UmM523kS7svJ+5Cl1Ft9fh4gxrhjTOyZXoSQbbGNQrXyWOUyxBSq5Gw5iKkUIprNAh8t11UKLcHgmmUQf9m3xyWUwBiZIHVIVrmKEILChWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IL2h7rAg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IL2h7rAg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fgklMGCKXzzfl+Y/I7jaLT7gfuLtYlF+j5mQXWNrTY=;
	b=IL2h7rAgsQKvC5fh4T/3+1eJSMBE2HlxMn0wxU6KUBNYgS9LCYZ65ejeHdAbBaP249XsEc
	7eSOjhVjciLuy9f6lVHxupqCVeolSOCzaiY4U9+gJmG87g6m2EtNedxVXg7HXH0yuSQsN6
	YRFl7+/oCoxYoR3/F5oF3kgKoVOan34=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-rTx9SFtgPb2e8k1qIShEPQ-1; Sat,
 10 Oct 2026 13:38:47 +0000
X-MC-Unique: rTx9SFtgPb2e8k1qIShEPQ-1
X-Mimecast-MFC-AGG-ID: rTx9SFtgPb2e8k1qIShEPQ_1791639525
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BE3F19560B8;
	Sat, 10 Oct 2026 13:38:45 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D6BB730000E5;
	Sat, 10 Oct 2026 13:38:40 +0000 (UTC)
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
Subject: [PATCH v10 14/26] target/arm/kvm: Implement SYSREG property setter and getter
Date: Sat, 10 Oct 2026 15:36:18 +0200
Message-ID: <20261010133725.642498-15-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: i-dAC2jhTjEJ3z2u6TQEC6X9LMpdv7J5RJA277VnGog_1791639525
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When the setter is called, the final vcpu is not created yet.

Applying the override on vcpu.isar initialized with the max scratch
vcpu would not be correct because the final vcpu may have some features
turned off (for instance virtualization) while the scratch vcpu
features all available ones. So we need to postpone the actual
override until the final vcpu has been initialized.

Set values are recorded in a hash table and will be applied to the
guest in a subsequent patch. At this point the only checks that can
be done on the input value are checking against field length and
arch enum value if any.

With regards to the getter, if the sysreg prop was set, we return the
set value, otherwise, we return the value in cpu->isar.idregs[].

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Khushit Shah <khushit.shah@nutanix.com>

---

v9 -> v10:
- renamed MAKE_IDREG_KEY into IDREG_FIELD_KEY
- rebase on new implementation in cpu64.c
---
 target/arm/cpu.h   |  2 ++
 target/arm/cpu.c   |  5 ++--
 target/arm/cpu64.c | 65 ++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 639be0713e..bef100c02c 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -968,6 +968,8 @@ struct ArchCPU {
     uint64_t *cpreg_vmstate_values;
     int32_t cpreg_vmstate_array_len;
 
+    GHashTable *sysreg_props;
+
     DynamicGDBFeatureInfo dyn_sysreg_feature;
     DynamicGDBFeatureInfo dyn_svereg_feature;
     DynamicGDBFeatureInfo dyn_smereg_feature;
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index bee74c0f94..d2755d77ca 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1238,8 +1238,8 @@ static void arm_cpu_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
 
-    cpu->cp_regs = g_hash_table_new_full(g_direct_hash, g_direct_equal,
-                                         NULL, g_free);
+    cpu->cp_regs = g_hash_table_new(g_direct_hash, g_direct_equal);
+    cpu->sysreg_props = g_hash_table_new(g_direct_hash, g_direct_equal);
 
     QLIST_INIT(&cpu->pre_el_change_hooks);
     QLIST_INIT(&cpu->el_change_hooks);
@@ -1739,6 +1739,7 @@ static void arm_cpu_finalizefn(Object *obj)
     ARMCPRegMigTolerance *t, *n;
 
     g_hash_table_destroy(cpu->cp_regs);
+    g_hash_table_destroy(cpu->sysreg_props);
 
     QLIST_FOREACH_SAFE(hook, &cpu->pre_el_change_hooks, node, next) {
         QLIST_REMOVE(hook, node);
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index b1738c9be3..9662608675 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -801,18 +801,79 @@ static void kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
                                      UINT64_MAX, 0, ToleranceOnlySrcTestValue);
 }
 
+#define IDREG_FIELD_KEY(reg_idx, field_shift) \
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
+    if (length < 64 && value > ((1ULL << length) - 1)) {
+        error_setg(errp,
+                   "idreg %s set value (0x%" PRIx64 ") exceeds length of "
+                   "field (%d)!", name, value, length);
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
+                   "idreg %s set value (0x%" PRIx64 ") does not match any "
+                   "arch valid enum value", name, value);
+        return;
+    }
+
+valid:
+
+    key = IDREG_FIELD_KEY(index, lower);
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
+    uint64_t key = IDREG_FIELD_KEY(index, lower);
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
 
 /**
-- 
2.53.0

