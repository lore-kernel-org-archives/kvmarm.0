Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59037377575
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639559; cv=none; b=P1xAS3xP59PP3PNIc1E2yr1AX8Og9QsW8vZofbj2WPmUqb1ZugCoI+kFDlGbfYKBmDv8em8Hxh/hrepyhNDNxz7Hefj3shmDWiRoVVKQo8H+j5M4Mu3lBatl755GOY+QCoW3CcPZO5qcgsTS/Y1yvVRN0LEaQ21XeYjXfnZnEYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639559; c=relaxed/simple;
	bh=KTYbsvZwX5TIUT8ohhNqAU+s6pS3esmtXBs1j9SV4pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QBNGhE5TGqh4mzRB3cOHV3NDfSs5gxcPkDHMz7djZai1eQV6Wda6Em2PfdNT+X9B0dKpyo25pZeTONDxJex8+e32DMqX6f6hutfFHbmOAJ50J0qZMFeYmhUr5p2TUnD3sEgJjgksW1hkxear8mmM9F36Mj4eShTP0v0hKlHEVuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AERoS+3J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AERoS+3J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dbX7/6NbWU/+92lr0pryibg29b53j8+3gzhn4Kx0DXg=;
	b=AERoS+3Jo6SvvR7z706qmgzyoEv+8Ko6hkIz9lxL4hQg7bCeIganuy6z7AYlp08ZSWxnAn
	O5WtO3JnOiJznwGxZVZwc7OOCvbTEeDZYDin6IPR36huB+ObXW7PlEDhxhUhK/KA6S4awS
	5+mz+ghri89Tx83V1amKkyKBVvp2CIo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-fYQX9bN1O0qu-vdOe2UkIA-1; Sat,
 10 Oct 2026 13:39:07 +0000
X-MC-Unique: fYQX9bN1O0qu-vdOe2UkIA-1
X-Mimecast-MFC-AGG-ID: fYQX9bN1O0qu-vdOe2UkIA_1791639545
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5CCD195D032;
	Sat, 10 Oct 2026 13:39:05 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE70F30000E5;
	Sat, 10 Oct 2026 13:39:00 +0000 (UTC)
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
Subject: [PATCH v10 18/26] target/arm/cpu64: Introduce arm_cpu_apply_sysreg_props
Date: Sat, 10 Oct 2026 15:36:22 +0200
Message-ID: <20261010133725.642498-19-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Erq6y5sYY5jiV3tbkfbA28ko-yyLt1FN-1lRQyEmo1g_1791639545
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This helper walks through all stored SYSREG field values and
apply them on the vcpu. It uses an accelerator specific callback
to apply the field value on the vcpu. If the value is successfully
applied, the cpu->isar.idregs[] value is updated accordingly.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu-idregs.h | 18 +++++++++++++
 target/arm/cpu64.c      | 57 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
index e0399e251b..56c2324359 100644
--- a/target/arm/cpu-idregs.h
+++ b/target/arm/cpu-idregs.h
@@ -38,4 +38,22 @@ typedef struct ARM64SysReg {
  */
 extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
 
+/* accelerator specific callback used to apply a new field value on a vcpu */
+typedef int (*ARMSysregPropApplyFn)(ARMCPU *cpu, ARM64SysRegField *field,
+                                    uint64_t newfv, Error **errp);
+
+/**
+ * arm_cpu_apply_sysreg_props:
+ *
+ * Apply all SYSREG prop values
+ * @cpu:  vcpu on which the values are applied
+ * @accel_apply_fn: acceleration specific callback used to override
+ *                  a single field value
+ * @errp: error handle
+ *
+ * return 0 on sucess or negative value with errp set on failure
+ */
+int arm_cpu_apply_sysreg_props(ARMCPU *cpu, ARMSysregPropApplyFn accel_apply_fn,
+                               Error **errp);
+
 #endif
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 9662608675..26baee102c 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -803,6 +803,63 @@ static void kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
 
 #define IDREG_FIELD_KEY(reg_idx, field_shift) \
     (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
+#define IDREG_FIELD_KEY_TO_REG_IDX(key) \
+    ((uint32_t)(((uint64_t)(key)) >> 8))
+#define IDREG_FIELD_KEY_TO_SHIFT(key) \
+    ((uint8_t)(((uint64_t)(key)) & 0xFF))
+
+static ARM64SysRegField *arm_sysreg_get_field(ARM64SysReg *reg, int bit)
+{
+    for (int f = 0; f < reg->fields_count; f++) {
+        ARM64SysRegField *field = &reg->fields[f];
+        int upper = field->shift + field->length - 1;
+
+        if (bit >= field->shift && bit <= upper) {
+            return field;
+        }
+    }
+    return NULL;
+}
+
+/**
+ * arm_cpu_apply_sysreg_props:
+ *
+ * Iterate over all SYSREG_* property overrides, and apply them on the vcpu
+ * using the accelerataor specific @accel_apply_fn callback.
+ */
+int arm_cpu_apply_sysreg_props(ARMCPU *cpu, ARMSysregPropApplyFn accel_apply_fn,
+                               Error **errp)
+{
+    gpointer key_ptr, value_ptr;
+    GHashTableIter iter;
+
+    g_hash_table_iter_init(&iter, cpu->sysreg_props);
+
+    while (g_hash_table_iter_next(&iter, &key_ptr, &value_ptr)) {
+        uint64_t key = (uint64_t)key_ptr;
+        uint64_t newfv = (uint64_t)value_ptr;
+        uint32_t reg_idx = IDREG_FIELD_KEY_TO_REG_IDX(key);
+        uint8_t lower = IDREG_FIELD_KEY_TO_SHIFT(key);
+        ARM64SysReg *reg = &arm64_id_regs[reg_idx];
+        ARM64SysRegField *field = arm_sysreg_get_field(reg, lower);
+        int ret;
+
+        if (!field) {
+            error_setg(errp, "SYSREG property key 0x%" PRIx64
+                       " does not match any field of %s", key, reg->name);
+            return -EINVAL;
+        }
+
+        ret = accel_apply_fn(cpu, field, newfv, errp);
+        if (ret) {
+            return ret;
+        }
+        cpu->isar.idregs[field->index] =
+            deposit64(cpu->isar.idregs[field->index],
+                      field->shift, field->length, newfv);
+    }
+    return 0;
+}
 
 static void set_sysreg_prop(Object *obj, Visitor *v,
                             const char *name, void *opaque,
-- 
2.53.0

