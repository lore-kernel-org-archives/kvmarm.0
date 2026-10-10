Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C823749E3
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639527; cv=none; b=cV6VfLCnOgSl11IWC0RL1ie1FgG8ABoACjTe65BPK5xfcfylumw//KTxEHa4QtXAcvSjb+VxFumA87OU/0TXUsNgA1/Ap+MblZ9a86/3+B5Uo5CYIEaYQ7mVP6MTtkAHH9cU02+H7jVEhoZaj2poxBUMzyu/HYi93E+Idi/9G58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639527; c=relaxed/simple;
	bh=5OOBn13OGbN6mlhWRyXg3lMXal8TP7/52jDr8Xtp2iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L12QmOODiZXgBddFNLozMOCzfv7XZKu28zoafzx8eroLv99Xfp8CUfWQsqbAt+6ylt/jrnBqBNB65Q/RwVPtq6aI2EK5ByLVTs77l1BOGdto1oLFR1o9Sx+w5qSTFOCGalvKell7fWuBnVYMNkBvPZP4bkFxdVv6qBB0qHLkKYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L+KTcLpX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L+KTcLpX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hsy8Wb76UKgAIrb0kzSti5SOHbp3tE79r/MLWon3/vk=;
	b=L+KTcLpXRd/nwNV+jYi75WOrgYKtbweBUivoOVegoDdayZDurmUegYa2IXOvcwYa4wgSyw
	H5PSvmRXPYMzduRyjWtusu9HdJaYoqBcSjSxbvU4PHb5f3UdaU6QC+57/KEk+7WCRgPj/6
	eeZerA2sAQLza+PpbF1LtENyWairofw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-PTvbiei3Nfir4CnuhCL_GA-1; Sat,
 10 Oct 2026 13:38:42 +0000
X-MC-Unique: PTvbiei3Nfir4CnuhCL_GA-1
X-Mimecast-MFC-AGG-ID: PTvbiei3Nfir4CnuhCL_GA_1791639520
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D7431800650;
	Sat, 10 Oct 2026 13:38:40 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1646930000E5;
	Sat, 10 Oct 2026 13:38:35 +0000 (UTC)
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
Subject: [PATCH v10 13/26] target/arm/cpu64: Add properties for writable IDReg fields
Date: Sat, 10 Oct 2026 15:36:17 +0200
Message-ID: <20261010133725.642498-14-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: QJsVcNmdlbTRrL5wp_xlSEczC9dp16jhLgAfnQuKqlg_1791639520
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For KVM vcpu models, we add properties for all writable
ID reg fields. This relies on the idreg writable mask retrieved
from KVM, which is matched aginst the register description
found in target/arm/cpu-idregs.h.inc.

The code is prepared to extend this capability to all ID
register fields independently on their writability. This will
be needed for named vcpu models which may want to relax some
values to the host supported one.

REVIDR_EL1 and AIDR_EL1 are writable but they do not expose any
field. So they will need to be handled separately.

The setter and getter are not yet implemented and currently
return an error.

Note in the future, other acceleration types may benefit from
those properties.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v9 -> v10
- instead of parsing the writable mask, scroll through the fields
  but still do some sanity checks. Add the writable param
- move the code to cpu64.c Do not pass any ARM64SysReg handle
  anymore. Rename the functions

v7 -> v8
- scratch the '!' in the error_setg
- addapt to the removal of struct ArmIdRegArchVal

v5 -> v6
- for enum values, check against value value when setting the prop
- do not check writable_map flag anymore

v4 -> v5:
- free prop_name
- check cpu->writable_map as a preamble in kvm_arm_expose_idreg_properties
---
 target/arm/cpu64.c      | 113 ++++++++++++++++++++++++++++++++++++++++
 target/arm/trace-events |   6 +++
 2 files changed, 119 insertions(+)

diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 64103df0a7..b1738c9be3 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -37,6 +37,8 @@
 #include "hw/core/qdev-properties.h"
 #include "internals.h"
 #include "cpu-features.h"
+#include "cpu-idregs.h"
+#include "trace.h"
 
 /* convert between <register>_IDX and SYS_<register> */
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
@@ -798,6 +800,116 @@ static void kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
     arm_register_cpreg_mig_tolerance(cpu, KVM_REG_ARM_FW_FEAT_BMAP_REG(3),
                                      UINT64_MAX, 0, ToleranceOnlySrcTestValue);
 }
+
+static void set_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    error_setg(errp, "%s setter not yet implemented", name);
+}
+
+static void get_sysreg_prop(Object *obj, Visitor *v,
+                            const char *name, void *opaque,
+                            Error **errp)
+{
+    error_setg(errp, "%s getter not yet implemented", name);
+}
+
+/**
+ * aarch64_add_idreg_properties: Add SYSREG_<REG>_<FIELD> properties
+ * for named fields of an ID register
+ *
+ * @obj: CPU object
+ * @reg: Description of the sysreg
+ * @writable_only: if set, add a property only for writable fields,
+ * otherwise, add properties unconditionnally
+ *
+ * Independently on @writable_only, always check the consistency between
+ * writable_mask and register fields description: if a field is writable
+ * make sure all its bits are writable. Also make sure only named fields
+ * are writable.
+ */
+static int
+aarch64_add_one_idreg_properties(Object *obj, ARM64SysReg *reg,
+                                 bool writable_only)
+{
+    uint64_t map = reg->writable_mask;
+    int nb_sysreg_props = 0;
+
+    for (int i = 0; i < reg->fields_count; i++) {
+        ARM64SysRegField *field = &reg->fields[i];
+        int lower = field->shift;
+        int length = field->length;
+        int upper = lower + length - 1;
+        uint64_t field_writable_mask = extract64(map, lower, length);
+        uint64_t field_mask = MAKE_64BIT_MASK(lower, length);
+        char *prop_name;
+
+        /* skip reserved fields, but still account them in writable_mask */
+        if (g_str_equal(field->name, "RES0") ||
+            g_str_equal(field->name, "RES1") ||
+            g_str_equal(field->name, "RAZ")) {
+            map &= ~field_mask;
+            continue;
+        }
+
+        if (field_writable_mask &&
+            field_writable_mask != MAKE_64BIT_MASK(0, length)) {
+            /* only a part of the field is writable, this should never happen */
+            error_report("field %s is not fully writable! (0x%"PRIx64")",
+                         field->name, field_writable_mask);
+        }
+        map = map & ~field_mask;
+
+        if (writable_only && !field_writable_mask) {
+            continue;
+        }
+
+        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
+        object_property_add(obj, prop_name, "uint64",
+                            get_sysreg_prop, set_sysreg_prop, NULL, field);
+        trace_add_idreg_property(prop_name, lower, upper, field_writable_mask);
+        g_free(prop_name);
+        nb_sysreg_props++;
+    }
+    if (map) {
+        error_report("%s has writable bits which do not match "
+                     "any named field! (0x%" PRIx64")", reg->name, map);
+    }
+    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
+    return 0;
+}
+
+
+/**
+ * aarch64_add_idreg_properties:
+ *
+ * Add SYSREG_<REG>_<FIELD> properties for every IDReg fields
+ *
+ * @cpu: cpu the properties are attached to
+ * @writable_only:  if set, properties are added only if the field is
+ * writable. Otherwise, added unconditionnally
+ */
+static void aarch64_add_idreg_properties(Object *obj, bool writable_only)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
+
+        if (writable_only && !sysregdesc->writable_mask) {
+            continue;
+        }
+        /*
+         * special case REVIDR_EL1 and AIDR_EL1 which are writable but
+         * do not expose named fields. They will need to be handled
+         * separately
+         */
+        if (!strcmp(sysregdesc->name, "REVIDR_EL1") ||
+            !strcmp(sysregdesc->name, "AIDR_EL1")) {
+            continue;
+        }
+        aarch64_add_one_idreg_properties(obj, sysregdesc, true);
+    }
+}
 #endif
 
 void aarch64_host_initfn(Object *obj)
@@ -815,6 +927,7 @@ void aarch64_host_initfn(Object *obj)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
     kvm_arm_set_cpu_features_from_host(cpu);
     aarch64_add_sve_properties(obj);
+    aarch64_add_idreg_properties(obj, true);
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
 #elif defined(CONFIG_WHPX)
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8c7faf57c7..ddc79eb666 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -19,6 +19,12 @@ get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value f
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
 arm_emulate_firmware_reset(uint64_t mp_aff, unsigned target_el) "cpu %" PRIu64 " @EL%u"
 
+# cpu64.c
+add_idreg_property(const char* name, int lower, int upper, bool writable) "%s [%d:%d] writable=%d"
+get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
+set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
+nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
+
 # arm-powerctl.c
 arm_powerctl_set_cpu_on(uint64_t mp_aff, unsigned target_el, const char *mode, uint64_t entry, uint64_t context_id) "cpu %" PRIu64 " (EL %u, %s) @ 0x%" PRIx64 " with R0 = 0x%" PRIx64
 arm_powerctl_set_cpu_on_and_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

