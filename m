Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF88230D410
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570128; cv=none; b=KN09vtlk+n9VLfmwPZOjEVjbreDz7ghwKRzXAkWUqlRROaIItibxpyqVj+io4h9cc3VHOlrwg9s7lS6OJTS01LC/w3TC9JqN+Ij+AoXGjrn9Si3A3CThtie4CcKhxjm4ntWoxGrCKTb9MvzQ4LjJMOUiRtkVF7+nEtlut5O2zAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570128; c=relaxed/simple;
	bh=dOfcMlMsmg2UKKNtkkdw5TKbCVnwLv5gqCoX+3UYZz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QcVWmAKYgIiQrAnamWdsKo6cfZNRg+HrhY1h9dMnFl3gIhR2LhaNlviS1cxBjwdG45o2rlzLecN7G+aN4FGZa01d46J2823yOj13+nWvW9mkaHGuzmelFTxFRzDv6hwSrPdKCJKQYXvcIa3AsbxuTy73oy1wpiYKB2nB7olANvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M9c+OCpf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M9c+OCpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XXy3/4+5nDx8WNm/khC7tnzijI1+lKrtPR4ajVEj/24=;
	b=M9c+OCpfUYHbtG8/lgA62QWSWWGqCD+oyXVY7rHCZOYbSTznI94r22be8Z9pN4vnwES+vX
	kTC6osvC8GuGn9ovA7E0AfL4ksTIV+Vn7RR/EzJeF9sR6g5BNPY4j5xf3HPj8KwM8Zq3hE
	efAj/Ls7Fj0wiRLC5qHnyNpQZaMM8Vk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-S8RLpIpOORSbC9g1EoBoCg-1; Wed,
 16 Sep 2026 10:48:42 -0400
X-MC-Unique: S8RLpIpOORSbC9g1EoBoCg-1
X-Mimecast-MFC-AGG-ID: S8RLpIpOORSbC9g1EoBoCg_1789570120
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 485DC1955DC8;
	Wed, 16 Sep 2026 14:48:40 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9E80619560AB;
	Wed, 16 Sep 2026 14:48:35 +0000 (UTC)
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
Subject: [PATCH v9 13/26] target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
Date: Wed, 16 Sep 2026 16:45:36 +0200
Message-ID: <20260916144721.751810-14-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: UvA-ELXbqjh3jdDJWtVDSnXNn_ionkRVFRdIadVwduI_1789570120
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This helper decode the ID reg writable mask, matches it against
ID reg fields defined in target/arm/cpu-idregs.h.inc and
for each writable named field, generates a uint64 property.

REVIDR_EL1 and AIDR_EL1 are writable but they do not expose any
field. They will be handled separately.

The setter and getter are not yet implemented

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
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
 target/arm/kvm_arm.h    | 10 +++++
 target/arm/kvm.c        | 93 +++++++++++++++++++++++++++++++++++++++++
 target/arm/trace-events |  4 ++
 3 files changed, 107 insertions(+)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index e7c40fb003..2b3474cc36 100644
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
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 958b25e550..341542279d 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -327,6 +327,99 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
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
+/*
+ * decode_idreg_writemap: Generate props for writable fields
+ *
+ * @obj: CPU object
+ * @reg: description of the sysreg
+ */
+static int
+decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
+{
+    uint64_t map = reg->writable_mask;
+    int i = ctz64(map);
+    int nb_sysreg_props = 0;
+
+    while (map) {
+        ARM64SysRegField *field = get_field(i, reg);
+        int lower, upper;
+        char *prop_name;
+        uint64_t field_mask;
+
+        if (!field) {
+            warn_report("%s bit %d of %s is writable but no named field "
+                        "in target/arm/cpu-idregs.h.inc",
+                        __func__, i, reg->name);
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
+        field_mask = MAKE_64BIT_MASK(lower, field->length);
+        map = map & ~field_mask;
+        i = ctz64(map);
+    }
+    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
+    return 0;
+}
+
+/* analyze the writable mask and generate properties for writable fields */
+void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
+{
+    Object *obj = OBJECT(cpu);
+
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *sysregdesc = &regs[i];
+
+        if (sysregdesc->writable_mask) {
+            /*
+             * special case REVIDR_EL1 and AIDR_EL1 which are writable but
+             * do not expose named fields. They will need to be handled
+             * separately
+             */
+            if (strcmp(sysregdesc->name, "REVIDR_EL1") &&
+                strcmp(sysregdesc->name, "AIDR_EL1")) {
+                decode_idreg_writemap(obj, sysregdesc);
+            }
+        }
+    }
+}
+
 static void
 kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
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

