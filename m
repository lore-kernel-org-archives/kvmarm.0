Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6385B346AD3
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793829; cv=none; b=grM3AlEzPIWIsVOGWV4LqG5yQJsVgfGoWbentHPKXqBUpqk2NFjiioCmZIFzr63I3y1ndjm41tGoftnjsi5XBpzcfUvZRu5VUijZSRqIOQ06Xx/1yzwVGJxWHzTqwiU1pOCbrnIuP80GbghAPwYBHgmDmEPrlCpdbsoCoi/txVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793829; c=relaxed/simple;
	bh=eaDzWVxxZxWVRRbDjH4CGxOrlolRXvezn7z4QEDLCkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DXXFD4QS22L0eDlaLJaRTY4lU/HiHI7TvCfHFRE2+Ugu00QXnMhdx2aSRE+B2ohYOlfOim5z3Lg4r61pcw333JPRSk4KHDpv59oOqZqKTYK3Qd+hHOm/ViAyWiV1G+jrYkqS7KlA5XZtpl0jKJuAObS1jsjYwVs1N/2BKSJqFIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fUm4NnP5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fUm4NnP5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMByKqJonEq0IJZY6i3tIkyiCV0a7+Hy3a32bJd22VU=;
	b=fUm4NnP5yNrZkN2MdYfET7nJ/tV02l5GQ/VQzN87Ihx7lYAlb2G5ppbPqahmeYN02q1bDf
	O3eBGlbjS0e7pL/Dj0/PSqbekUGY9J+KhFtQ8UAroYwTc1NBlmp5I4nIgzhmnZLGV3/qJC
	fJEU+0dJ/QmiYrkAAJww4NaFqlZesVI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-SSroAWKOPKqMQhBsll6Qhg-1; Sun,
 03 May 2026 03:37:03 -0400
X-MC-Unique: SSroAWKOPKqMQhBsll6Qhg-1
X-Mimecast-MFC-AGG-ID: SSroAWKOPKqMQhBsll6Qhg_1777793822
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0982E18002D9;
	Sun,  3 May 2026 07:37:02 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91C031800345;
	Sun,  3 May 2026 07:36:56 +0000 (UTC)
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
Subject: [PATCH v4 12/17] target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
Date: Sun,  3 May 2026 09:33:32 +0200
Message-ID: <20260503073541.790215-13-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: DCmV2Qs41VAo0RhvBHprrDQnf2Sf1yDMUOh86EqR5aE_1777793822
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This helper decode the ID reg writable mask, matches it against
ID reg fields defined in target/arm/cpu-sysreg-properties.c and
for each writable named field, generates a uint64 property.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c        | 134 ++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h    |  10 +++
 target/arm/trace-events |   4 ++
 3 files changed, 148 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ca9a7d9439..d9bf1ec039 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -344,6 +344,140 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
     return err;
 }
 
+static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
+{
+    GList *l;
+
+    for (l = reg->fields; l; l = l->next) {
+        ARM64SysRegField *field = (ARM64SysRegField *)l->data;
+
+        if (i >= field->lower && i <= field->upper) {
+            return field;
+        }
+    }
+    return NULL;
+}
+
+static void set_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
+    uint64_t old, value, mask;
+    int lower = field->lower;
+    int upper = field->upper;
+    int length = upper - lower + 1;
+    int index = field->index;
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
+    mask = MAKE_64BIT_MASK(lower, length);
+    value = value << lower;
+    old = idregs[index];
+    idregs[index] = old & ~mask;
+    idregs[index] |= value;
+    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
+}
+
+static void get_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
+    uint64_t value, mask;
+    int lower = field->lower;
+    int upper = field->upper;
+    int length = upper - lower + 1;
+    int index = field->index;
+
+    mask = MAKE_64BIT_MASK(lower, length);
+    value = (idregs[index] & mask) >> lower;
+    visit_type_uint64(v, name, &value, errp);
+    trace_get_sysreg_prop(name, value);
+}
+
+/*
+ * decode_idreg_writemap: Generate props for writable fields
+ *
+ * @obj: CPU object
+ * @index: index of the sysreg
+ * @map: writable map for the sysreg
+ * @reg: description of the sysreg
+ */
+static int
+decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg *reg)
+{
+    int i = ctz64(map);
+    int nb_sysreg_props = 0;
+
+    while (map) {
+        ARM64SysRegField *field = get_field(i, reg);
+        int lower, upper;
+        uint64_t mask;
+        char *prop_name;
+
+        if (!field) {
+            warn_report("%s bit %d of %s is writable but no named field "
+                        "in target/arm/cpu-sysreg-properties.c",
+                        __func__, i, reg->name);
+            warn_report("%s is target/arm/cpu-sysreg-properties.c up to date?", __func__);
+            map =  map & ~BIT_ULL(i);
+            i = ctz64(map);
+            continue;
+        }
+        lower = field->lower;
+        upper = field->upper;
+        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
+        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
+        object_property_add(obj, prop_name, "uint64",
+                            get_sysreg_prop, set_sysreg_prop, NULL, field);
+        nb_sysreg_props++;
+
+        mask = MAKE_64BIT_MASK(lower, upper - lower + 1);
+        map = map & ~mask;
+        i = ctz64(map);
+    }
+    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
+    return 0;
+}
+
+/* analyze the writable mask and generate properties for writable fields */
+void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
+{
+    int i, idx;
+    IdRegMap *map = cpu->writable_map;
+    Object *obj = OBJECT(cpu);
+
+    for (i = 0; i < NR_ID_REG_MASKS; i++) {
+        uint64_t mask = map->regs[i];
+
+        if (mask) {
+            /* reg @i has some writable fields, decode them */
+            idx = kvm_feature_idx_to_idregs_idx(i);
+            if (idx < 0) {
+                /* no matching reg? */
+                warn_report("%s: reg %d writable, but not in list of idregs?",
+                            __func__, i);
+            } else {
+                decode_idreg_writemap(obj, i, mask, &regs[idx]);
+            }
+        }
+    }
+}
+
 static bool
 kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf,
                               bool get_all_writable_id_regs)
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 91a7d5cc4b..a3034f264b 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -146,6 +146,16 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
  */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
 
+typedef struct ARM64SysReg ARM64SysReg;
+/**
+ * kvm_arm_expose_idreg_properties:
+ * @cpu: The CPU object to generate the properties for
+ * @reg: registers from the host
+ *
+ * analyze the writable mask and generate properties for writable fields
+ */
+void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs);
+
 /**
  * kvm_arm_steal_time_finalize:
  * @cpu: ARMCPU for which to finalize kvm-steal-time
diff --git a/target/arm/trace-events b/target/arm/trace-events
index c25d2a1191..d72ad6b671 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,6 +15,10 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
 kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
+decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
+get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
+set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
+nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

