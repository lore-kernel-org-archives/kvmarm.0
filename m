Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5254C1FCF58
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 11:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484252; cv=none; b=K7iZYyTmR2UzKPvzrkl2uz5mjXL6BI6xu21BIdwbwtdxj59S6Pdhm+hKEuhumXR7mhXE0N5DnhaC5RRZbA7BJdK6IxC81mjoRIMrsjxfByO/WPzjquCN+X5V1cs6/ONVOLrPGJblYNXdjfThUidUaGHVOtFBazo0o9oJqHKcezI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484252; c=relaxed/simple;
	bh=JxpiYrg92Bjw+Y6dy/R+nhfm2ASB2MWbDp2e4YSVZc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=igRPqL0FYFCX1LveeQPiGbN3epCG70mzXTv1PavIuKKG9s/TiJLN6P1EdHAQBzk3MfttzeOhXCB+nZr7P5BKN+zCvjIMIKJIA6wYgaPd0u0WPgrBlcQSRBdUsDVdJno9L+y9I+gDhoH9H3qtNUHquZJ5PgKvKN6FSzUrv82M8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=efXV15eC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="efXV15eC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733484249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rrr75tMi6MUZHf8+tlCHv0SNjLxc/na9BJMnFfneCQs=;
	b=efXV15eCEUN7AWbab9UB8ihKVEDBsRToe5I0VPK0jV3SkBvuu1bQhyNXeXO+xHRJj/BCKD
	X9AU/qM4GoKFsvy83bLUWdr02KPocrTS64MaYB0paRtuhFQSdmVyutd5CQutZQzMk9vfkS
	Afkd82eOFaUo2/NjhJSGMgm851GKiuA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-ry4BAw7PNjKd8xZPWHv6iA-1; Fri,
 06 Dec 2024 06:24:05 -0500
X-MC-Unique: ry4BAw7PNjKd8xZPWHv6iA-1
X-Mimecast-MFC-AGG-ID: ry4BAw7PNjKd8xZPWHv6iA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 548591955EB3;
	Fri,  6 Dec 2024 11:24:03 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2122519560A2;
	Fri,  6 Dec 2024 11:23:57 +0000 (UTC)
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
Subject: [PATCH RFCv2 16/20] arm/kvm: Allow reading all the writable ID registers
Date: Fri,  6 Dec 2024 12:22:09 +0100
Message-ID: <20241206112213.88394-17-cohuck@redhat.com>
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

At the moment kvm_arm_get_host_cpu_features() reads a subset of the
ID regs. As we want to introduce properties for all writable ID reg
fields, we want more genericity and read more default host register
values.

Introduce a new get_host_cpu_idregs() helper and add a new exhaustive
boolean parameter to kvm_arm_get_host_cpu_features() and
kvm_arm_set_cpu_features_from_host() to select the right behavior.
The host cpu model will keep the legacy behavior unless the writable
id register interface is available.

A writable_map IdRegMap is introduced in the CPU object. A subsequent
patch will populate it.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu.h        |  3 +++
 target/arm/cpu64.c      |  4 ++--
 target/arm/kvm.c        | 53 ++++++++++++++++++++++++++++++++++++++---
 target/arm/kvm_arm.h    |  9 +++++--
 target/arm/trace-events |  1 +
 5 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index c803d191e84d..1ae482aac6a7 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1054,6 +1054,9 @@ struct ArchCPU {
      */
     ARMIdRegsState writable_id_regs;
 
+    /* ID reg writable bitmask (KVM only) */
+    IdRegMap *writable_map;
+
     /* QOM property to indicate we should use the back-compat CNTFRQ default */
     bool backcompat_cntfrq;
 
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 29558cda8186..e23df993e00e 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -717,14 +717,14 @@ static void aarch64_host_initfn(Object *obj)
 {
 #if defined(CONFIG_KVM)
     ARMCPU *cpu = ARM_CPU(obj);
-    kvm_arm_set_cpu_features_from_host(cpu);
+    kvm_arm_set_cpu_features_from_host(cpu, false);
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         aarch64_add_sve_properties(obj);
         aarch64_add_pauth_properties(obj);
     }
 #elif defined(CONFIG_HVF)
     ARMCPU *cpu = ARM_CPU(obj);
-    hvf_arm_set_cpu_features_from_host(cpu);
+    hvf_arm_set_cpu_features_from_host(cpu, false);
     aarch64_add_pauth_properties(obj);
 #else
     g_assert_not_reached();
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f11d512388b8..4bb8094e846f 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -41,6 +41,7 @@
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
 #include "migration/blocker.h"
+#include "cpu-custom.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(DEVICE_CTRL),
@@ -272,8 +273,49 @@ static int get_host_cpu_reg64(int fd, ARMHostCPUFeatures *ahcf, ARMSysReg sr)
     return ret;
 }
 
+/*
+ * get_host_cpu_idregs: Read all the writable ID reg host values
+ *
+ * Need to be called once the writable mask has been populated
+ * Note we may want to read all the known id regs but some of them are not
+ * writable and return an error, hence the choice of reading only those which
+ * are writable. Those are aslo readable!
+ */
+static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
+{
+    int err = 0;
+    int i;
+
+    for (i = 0; i < NR_ID_REGS; i++) {
+        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
+        ARMSysReg *sysreg = sysregdesc->sysreg;
+        uint64_t writable_mask = cpu->writable_map->regs[i];
+        uint64_t *reg;
+        int ret;
+
+        if (!sysreg || !writable_mask) {
+            continue;
+        }
+
+        reg = &ahcf->isar.idregs.regs[i];
+        ret = read_sys_reg64(fd, reg,
+                             ARM64_SYS_REG(sysreg->op0, sysreg->op1,
+                                           sysreg->crn, sysreg->crm,
+                                           sysreg->op2));
+        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
+        if (ret) {
+            error_report("%s error reading value of host %s register (%m)",
+                         __func__, sysregdesc->name);
 
-static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+            err = ret;
+        }
+    }
+    return err;
+}
+
+static bool
+kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf,
+                              bool exhaustive)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -401,6 +443,11 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg32(fd, ahcf, SYS_ID_DFR1_EL1);
         err |= get_host_cpu_reg32(fd, ahcf, SYS_ID_MMFR5_EL1);
 
+        /* Make sure writable ID reg values are read */
+        if (exhaustive) {
+            err |= get_host_cpu_idregs(cpu, fd, ahcf);
+        }
+
         /*
          * DBGDIDR is a bit complicated because the kernel doesn't
          * provide an accessor for it in 64-bit mode, which is what this
@@ -470,13 +517,13 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     return true;
 }
 
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool exhaustive)
 {
     CPUARMState *env = &cpu->env;
 
     if (!arm_host_cpu_features.dtb_compatible) {
         if (!kvm_enabled() ||
-            !kvm_arm_get_host_cpu_features(&arm_host_cpu_features)) {
+            !kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features, exhaustive)) {
             /* We can't report this error yet, so flag that we need to
              * in arm_cpu_realizefn().
              */
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 426816ad3a74..035eedf82ff1 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -141,8 +141,12 @@ uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu);
  *
  * Set up the ARMCPU struct fields up to match the information probed
  * from the host CPU.
+ *
+ * @cpu: cpu object
+ * @exhaustive: if true, all the feature ID regs are queried instead of
+ *              a subset
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool exhaustive);
 
 /**
  * kvm_arm_add_vcpu_properties:
@@ -257,7 +261,8 @@ static inline int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
 /*
  * These functions should never actually be called without KVM support.
  */
-static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
+                                                      bool exhaustive)
 {
     g_assert_not_reached();
 }
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 4438dce7becc..0df3bfafffcc 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,3 +13,4 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu gost value for %s is 0x%"PRIx64
-- 
2.47.0

