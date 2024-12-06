Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FC41FCFEA
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 11:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484263; cv=none; b=I2Q7AXgifKkZN+dv908AggkKdpFDXK/CH054U47nez4y3VxmqpGhmtnjc0mfE88+rzBFWIJHQILra2rt7ti2ErvupYVLRVjXs3VB0fKOVesR8dvOiDP54WAFNGF5RkFVx4QNBvmD4jtv5eToimBBMUSseYmaKynS4dLkymoK3Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484263; c=relaxed/simple;
	bh=B+JKn1BUAWQCBnIzyl6dgQ9PEV5j6wdIP42L4lqzRsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=sOYt/0IcsHNFIs5f6rrp6TkXh77aT59z1mvFsbKBB5elGYVe12FiknQULknNIVnE1IX4bZBXrab9jcOVZiApDe+FHTqQNn59ZTgbVg3FgUzA38n2Kda8RdNV+cFS33cYxuK0/9ckee0KB1MSgKPvnjAn+ipRipw0UNieB6chHuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0QgBgtH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0QgBgtH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733484260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AS3dhdTtX8nlhECXlD2WH8GMfczxIljzgWd6E4YGRlU=;
	b=A0QgBgtHHnL7RaDHSpN+bqKsPKYaqh76VhcvB8PSSrpTtcWXu+lZqh+aq3f43NbYjUpyEy
	Smq1tmEhljUVktK2RUoMtGm/V8GGumYJqBiTbeB6PMDY13lRtyxnK1QNxpCUrZdLmKnjXD
	fNi4MfuoKg7XYbI08O6slJv+mWuR6wQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-DvuFZHtZPDepWhL3oQg9xA-1; Fri,
 06 Dec 2024 06:24:17 -0500
X-MC-Unique: DvuFZHtZPDepWhL3oQg9xA-1
X-Mimecast-MFC-AGG-ID: DvuFZHtZPDepWhL3oQg9xA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B2971956046;
	Fri,  6 Dec 2024 11:24:15 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9FC0919560AD;
	Fri,  6 Dec 2024 11:24:09 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
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
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFCv2 18/20] arm/cpu: more customization for the kvm host cpu model
Date: Fri,  6 Dec 2024 12:22:11 +0100
Message-ID: <20241206112213.88394-19-cohuck@redhat.com>
In-Reply-To: <20241206112213.88394-1-cohuck@redhat.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Eric Auger <eric.auger@redhat.com>

If the interface for writable ID registers is available, expose uint64
SYSREG properties for writable ID reg fields exposed by the host
kernel. Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
being those used  in linux arch/arm64/tools/sysreg. This done by
matching the writable fields retrieved from the host kernel against the
generated description of sysregs.

An example of invocation is:
-cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
which sets DP field of ID_AA64ISAR0_EL1 to 0.

[CH: add properties to the host model instead of introducing a new
"custom" model]
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

Interaction with the existing cpu properties is still a bit unclear --
at the moment, the different configurations can overwrite each other.
---
 target/arm/cpu.c        |  12 ++++
 target/arm/cpu64.c      | 150 +++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |   6 ++
 3 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index fee822eaf416..c20550cccbd2 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1999,6 +1999,18 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         return;
     }
 
+    /*
+     * If we failed to retrieve the set of writable ID registers for the "host"
+     * CPU model, report it here. No error if the interface for discovering
+     * writable ID registers is not available.
+     * In case we did get the set of writable ID registers, set the features to
+     * the configured values here and perform some sanity checks.
+     */
+    if (cpu->writable_id_regs == WRITABLE_ID_REGS_FAILED) {
+        error_setg(errp, "Failed to discover writable id registers");
+        return;
+    }
+
     if (!cpu->gt_cntfrq_hz) {
         /*
          * 0 means "the board didn't set a value, use the default". (We also
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index e23df993e00e..7c75779d1eb1 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -20,6 +20,7 @@
 
 #include "qemu/osdep.h"
 #include "qapi/error.h"
+#include "qemu/error-report.h"
 #include "cpu.h"
 #include "cpregs.h"
 #include "qemu/module.h"
@@ -36,6 +37,7 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 #include "cpu-custom.h"
+#include "trace.h"
 
 void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
 {
@@ -713,15 +715,161 @@ static void aarch64_a53_initfn(Object *obj)
     define_cortex_a72_a57_a53_cp_reginfo(cpu);
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
+#endif
+
 static void aarch64_host_initfn(Object *obj)
 {
 #if defined(CONFIG_KVM)
     ARMCPU *cpu = ARM_CPU(obj);
-    kvm_arm_set_cpu_features_from_host(cpu, false);
+    bool expose_id_regs = true;
+    int ret;
+
+    cpu->writable_map = g_malloc(sizeof(IdRegMap));
+
+    /* discover via KVM_ARM_GET_REG_WRITABLE_MASKS */
+    ret = kvm_arm_get_writable_id_regs(cpu, cpu->writable_map);
+    if (ret == -ENOSYS) {
+        /* legacy: continue without writable id regs */
+        expose_id_regs = false;
+    } else if (ret) {
+        /* function will have marked an error */
+        return;
+    }
+
+    kvm_arm_set_cpu_features_from_host(cpu, expose_id_regs);
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         aarch64_add_sve_properties(obj);
         aarch64_add_pauth_properties(obj);
     }
+    if (expose_id_regs) {
+        /* generate SYSREG properties according to writable masks */
+        expose_idreg_properties(obj, cpu->writable_map, arm64_id_regs);
+    }
+
 #elif defined(CONFIG_HVF)
     ARMCPU *cpu = ARM_CPU(obj);
     hvf_arm_set_cpu_features_from_host(cpu, false);
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 668acf94ab60..1b4bd5ab1498 100644
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
2.47.0

