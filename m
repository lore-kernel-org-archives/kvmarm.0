Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C25E285CAE
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197451; cv=none; b=WtWssrniMOFLFqwUBc0zTxwiolbSx7pYm3gu0nHnIfpK7HPCMLufsrshbcJRod3C6NNBxOHEkyHErrqPxvmEVKVa0KnL+YkdOMw+zcDpPq2lu3LuhwuA3KkAJPIPrLqdS5E8z+pQtF4O252+F+2jseShH1nkkRATRD13lQY3x68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197451; c=relaxed/simple;
	bh=qGFZEMZuAr9R2hE+lUCDrXk8Os4ikUXAdfYLVc/tUb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hj5UylUbOimjJz01mBlFP4hGL8dL2GxL+k5zmIIHLU9Icj4+bKyyY+P+D6/H7LLhj9dzByc1rCpuVNfMfxOPgf1mI8rUf/S9Ujk0PTxy0VK8c5OyHB0WI8uYTvJ5itA2AEGBzgP0T8d06VHqT0juJRw3QgPNf90YWbUgabG72lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AQaEZgaC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQaEZgaC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SY/z/63+m4hMzLeyKBNakc3vBE3ErHiwR/jYVe53dHc=;
	b=AQaEZgaCImMMPfOgli70RXvlBk/lu8suZ1Rn0B3RJlFh8qtVTSEHANuhU3fzKsF0ALwIeN
	m1QbDZGFMtJZMQ6+km1zB+L4OhWp/UzgTsrcAlZEOidVbYaS4L80h2N+dh2nHRrOO0/9WG
	/4MbcHbSs3CwmqsHjzT1Yr7JkEL1VZQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-nFl3KB4TP8CzSOd9g2v6ww-1; Tue,
 19 May 2026 09:30:47 -0400
X-MC-Unique: nFl3KB4TP8CzSOd9g2v6ww-1
X-Mimecast-MFC-AGG-ID: nFl3KB4TP8CzSOd9g2v6ww_1779197441
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C886718002F1;
	Tue, 19 May 2026 13:30:41 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 203971800352;
	Tue, 19 May 2026 13:30:35 +0000 (UTC)
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
Subject: [PATCH v5 13/18] target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
Date: Tue, 19 May 2026 15:27:27 +0200
Message-ID: <20260519132905.145643-14-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: FuHg6pxbkPz-CNA4NwsEHMUQRFZ3rzbVJpIoOoa4gaU_1779197441
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This helper decode the ID reg writable mask, matches it against
ID reg fields defined in target/arm/cpu-idregs.h.inc and
for each writable named field, generates a uint64 property.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5:
- free prop_name
- check cpu->writable_map as a preamble in kvm_arm_expose_idreg_properties
---
 target/arm/kvm.c        | 135 ++++++++++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h    |  10 +++
 target/arm/trace-events |   4 ++
 3 files changed, 149 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 30c5175c68..960052e67e 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -343,6 +343,141 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
     return err;
 }
 
+static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
+{
+    for (int f = 0; f < reg->fields_count; f++) {
+        struct ARM64SysRegField *field = &reg->fields[f];
+        int upper = field->shift + field->length - 1;
+
+        if (i >= field->shift && i <= upper) {
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
+    int lower = field->shift;
+    int length = field->length;
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
+    int lower = field->shift;
+    int length = field->length;
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
+        char *prop_name;
+        uint64_t mask;
+
+        if (!field) {
+            warn_report("%s bit %d of %s is writable but no named field "
+                        "in target/arm/cpu-idregs.h.inc",
+                        __func__, i, reg->name);
+            warn_report("%s is target/arm/cpu-idregs.h.inc?", __func__);
+            map =  map & ~BIT_ULL(i);
+            i = ctz64(map);
+            continue;
+        }
+        lower = field->shift;
+        upper = field->shift + field->length - 1;
+        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
+        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
+        object_property_add(obj, prop_name, "uint64",
+                            get_sysreg_prop, set_sysreg_prop, NULL, field);
+        g_free(prop_name);
+        nb_sysreg_props++;
+
+        mask = MAKE_64BIT_MASK(lower, field->length);
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
+    Object *obj = OBJECT(cpu);
+
+    if (!cpu->writable_map) {
+        return;
+    }
+
+    for (i = 0; i < KVM_ARM_FEATURE_ID_RANGE_SIZE; i++) {
+        uint64_t mask = cpu->writable_map[i];
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
 static void
 kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
 {
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index c1c2e7ec37..8446a9cbf0 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -142,6 +142,16 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
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

