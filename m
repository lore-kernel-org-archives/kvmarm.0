Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07961E0DA0
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 10:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729851741; cv=none; b=bkmJGX+GJVnNxRySGuFlhhiPSRTnf2G1P9T9JEAQ0GS8ufd1z3RfhmFKQx28KEkXGfIIbCHq3/QmCHq/bcUvoJwnLBDIp1zHNvZlxFxVrg/mfDInyjPCFIqWGVQ1pCQTHAb3pzVx+wTo8VwM7LTuS92P4AKqnm8m5HmeIBRrwaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729851741; c=relaxed/simple;
	bh=PxX4SAmw0yoEhCPuDK4kiQjfMw34mnme08EcYERDQdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUVHsITDMMRjO5MaDcjbGcqoM4vJHz57SlkeFB9IkdrpXeS1mv55OAAoPGe4IiN7bbDwsmP3JN+q6QmldBLxNjGZ+LZPT5C7NTaWjEe0zFakx8vH1iMN5KSyoGWvDHTcbpawKUn/qZxNND0eMnqI3czEDsaRB5bl2UomEGscZ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPgm6rNJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPgm6rNJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729851735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsJaZx9DYO0XWaGPB626qkTx5iT5IO+MbfgP/BEsPAA=;
	b=PPgm6rNJ9TkHpwMemlIIjXPrA+oAqg7ehMy4VIuul2KLX445OH6uN3UFagK49+au0daWZt
	jeBgmOZZUX12Nn17ekV+LooUI60KbzbMsk6GVTorofSTW9Mo/ZZxvTF8oguNZ43L/21ClB
	Cqu74fZeKpu9BAjZolmgbe/B+U5Jo+o=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-uU8rs_HhMHOPDQJsPfQRpQ-1; Fri,
 25 Oct 2024 06:22:12 -0400
X-MC-Unique: uU8rs_HhMHOPDQJsPfQRpQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B13419560AD;
	Fri, 25 Oct 2024 10:22:10 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 94B9E196BB7D;
	Fri, 25 Oct 2024 10:22:04 +0000 (UTC)
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
Subject: [RFC 18/21] arm/cpu: Introduce a customizable kvm host cpu model
Date: Fri, 25 Oct 2024 12:17:37 +0200
Message-ID: <20241025101959.601048-19-eric.auger@redhat.com>
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

This new cpu model takes by default the host cpu values.
However it exposes uint64 SYSREG properties for writable ID reg
fields exposed by the host kernel. Properties are named
SYSREG_<REG>_<FIELD> with REG and FIELD being those used
in linux arch/arm64/tools/sysreg. This done by matching the
writable fields retrieved from the host kernel against the
generated description of sysregs.

An example of invocation is:
-cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
which sets DP field of ID_AA64ISAR0_EL1 to 0.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

At the moment, the custom model does not support legacy options
of the host cpu model. We need to understand what we do with those
latter (SVE, ...). This means that related KVM ioctl are
not called yet.
---
 target/arm/cpu.c        |  15 ++++
 target/arm/cpu64.c      | 153 ++++++++++++++++++++++++++++++++++++++++
 target/arm/trace-events |   6 ++
 3 files changed, 174 insertions(+)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 454d546feb..e5ac3c3e75 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1990,6 +1990,21 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
+    /*
+     * If we failed to retrieve the set of writable ID registers for a "custom"
+     * CPU model, report it here.
+     * In case we did get the set of writable ID registers, set the features to
+     * the configured values here and perform some sanity checks.
+     */
+    if (cpu->writable_id_regs == WRITABLE_ID_REGS_NOT_DISCOVERABLE) {
+        error_setg(errp, "Host kernel does not support discovering "
+                         "writable id registers");
+        return;
+    } else if (cpu->writable_id_regs == WRITABLE_ID_REGS_FAILED) {
+        error_setg(errp, "Failed to discover writable id registers");
+        return;
+    }
+
     if (!cpu->gt_cntfrq_hz) {
         /*
          * 0 means "the board didn't set a value, use the default". (We also
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 86b0797d4b..f10cc4ef8f 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -20,6 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "cpu.h"
 #include "cpregs.h"
 #include "qemu/module.h"
@@ -35,6 +36,8 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 #include "cpu-custom.h"
+#include "cpu-sysregs.h"
+#include "trace.h"
 
 void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
 {
@@ -742,6 +745,153 @@ static void aarch64_max_initfn(Object *obj)
     }
 }
 
+#ifdef CONFIG_KVM
+
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
+    IdRegMap *idregs = &cpu->isar.idregs;
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
+    old = idregs->regs[index];
+    idregs->regs[index] = old & ~mask;
+    idregs->regs[index] |= value;
+    trace_set_sysreg_prop(name, old, mask, value, idregs->regs[index]);
+}
+
+static void get_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    ARMCPU *cpu = ARM_CPU(obj);
+    IdRegMap *idregs = &cpu->isar.idregs;
+    int index = field->index;
+
+    error_report("%s %s", __func__, name);
+    visit_type_uint64(v, name, &idregs->regs[index], errp);
+    trace_get_sysreg_prop(name, idregs->regs[index]);
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
+            /* the field cannot be matched to any know id named field */
+            warn_report("%s bit %d of %s is writable but cannot be matched",
+                        __func__, i, reg->name);
+            warn_report("%s is cpu-sysreg-properties.c up to date?", __func__);
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
+static int expose_idreg_properties(Object *obj, IdRegMap *map,
+                                   ARM64SysReg *regs)
+{
+    int i;
+
+    for (i = 0; i < NR_ID_REGS; i++) {
+        uint64_t mask = map->regs[i];
+
+        if (mask) {
+            /* reg @i has some writable fields, decode them */
+            decode_idreg_writemap(obj, i, mask, &regs[i]);
+        }
+    }
+    return 0;
+}
+
+static void aarch64_customcpu_initfn(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    int ret;
+
+    cpu->writable_map = g_malloc(sizeof(IdRegMap));
+
+    /* discover via KVM_ARM_GET_REG_WRITABLE_MASKS */
+    ret = kvm_arm_get_writable_id_regs(cpu, cpu->writable_map);
+    if (ret) {
+        /* function will have marked an error */
+        return;
+    }
+
+    /* populate from the host (exhaustive) , validate during realize */
+    kvm_arm_set_cpu_features_from_host(cpu, true);
+
+    /* generate SYSREG properties according to writable masks */
+    expose_idreg_properties(obj, cpu->writable_map, arm64_id_regs);
+}
+
+#endif
+
 static const ARMCPUInfo aarch64_cpus[] = {
     { .name = "cortex-a57",         .initfn = aarch64_a57_initfn },
     { .name = "cortex-a53",         .initfn = aarch64_a53_initfn },
@@ -749,6 +899,9 @@ static const ARMCPUInfo aarch64_cpus[] = {
 #if defined(CONFIG_KVM) || defined(CONFIG_HVF)
     { .name = "host",               .initfn = aarch64_host_initfn },
 #endif
+#ifdef CONFIG_KVM
+    { .name = "custom",             .initfn = aarch64_customcpu_initfn },
+#endif
 };
 
 static bool aarch64_cpu_get_aarch64(Object *obj, Error **errp)
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 668acf94ab..1b4bd5ab14 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,3 +15,9 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu gost value for %s is 0x%"PRIx64
 kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
+
+# cpu64.c
+decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
+get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
+set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
+nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
-- 
2.41.0

