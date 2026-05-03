Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048F51A5B90
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793819; cv=none; b=CxaQ/3dE5qzZSDZI2w4zoEqGrj+7vlOB7vlXtmlUii0S8r9mwecWVJDnrjucB1N0KChsi9ThqFQYRmM5d9yBW46Zr57cpn5AJ0OWt5qAAsFGIFqbgD5SlpQW2ze6gttMlkCWTJyASHuh+tYAvrrKJTNSzvj+quoORbhW+wOwyVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793819; c=relaxed/simple;
	bh=cqMMbo69xVY19iRIPdJZyWtso8jhi81/3AD2Aka5ql0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UGO/aQ7TY5UR5A9h/Dj6dvky4ALJvHQ3KVXYSoA891UEdQ0nBq8IfbvtpT0G3VZPF/8Qrx0QuVMOe282d9iKsOrEOxsHPXCJSlyRYls7rjLnvOsEWhufyIAt0P/fdodRsJ+04KGCcX0NQFxvLaHCvxNk7a1aYVQMpSA74krwXgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JW5UyFJK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JW5UyFJK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ww7xxuY6m4aLvO5gFffSVqL+WmEUwMUCi1aQsJoWLbo=;
	b=JW5UyFJKb5MX/6TEGW0BmUP4FI15GnQxhoDydzGHtNr1R4j0PPI+9J+Y+aVBXQmmoQIooF
	EjwUIbXIwOCbA74orFUezz+HFwQO49Oaeeo0Egfb45jkXNnlaDeOlqHh9uhgekrNPigwA7
	bqwt7gMOOobxnNW5/RLGruQZHCCK5pA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-ZoeRi9uCMOyfKA2bc3VMCA-1; Sun,
 03 May 2026 03:36:52 -0400
X-MC-Unique: ZoeRi9uCMOyfKA2bc3VMCA-1
X-Mimecast-MFC-AGG-ID: ZoeRi9uCMOyfKA2bc3VMCA_1777793810
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB5A91956089;
	Sun,  3 May 2026 07:36:50 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6D73A1800480;
	Sun,  3 May 2026 07:36:45 +0000 (UTC)
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
Subject: [PATCH v4 10/17] arm/kvm: Allow reading all the writable ID registers
Date: Sun,  3 May 2026 09:33:30 +0200
Message-ID: <20260503073541.790215-11-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: R7GTkTgLy_ROtKvNvi8LnhWMmN9GW8Xf0TZUeGFDeoI_1777793810
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

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
 target/arm/cpu.h        |  3 ++
 target/arm/cpu64.c      |  2 +-
 target/arm/kvm-stub.c   |  3 +-
 target/arm/kvm.c        | 77 +++++++++++++++++++++++++++++++++++++++--
 target/arm/kvm_arm.h    |  6 +++-
 target/arm/trace-events |  1 +
 6 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 0ac0fd13cf..87fb0047eb 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1087,6 +1087,9 @@ struct ArchCPU {
      */
     ARMIdRegsState writable_id_regs_status;
 
+    /* ID reg writable bitmask (KVM only) */
+    IdRegMap *writable_map;
+
     /* QOM property to indicate we should use the back-compat CNTFRQ default */
     bool backcompat_cntfrq;
 
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index b940842d9e..1b3d3fb245 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -862,7 +862,7 @@ static void aarch64_host_initfn(Object *obj)
 
 #if defined(CONFIG_KVM)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
-    kvm_arm_set_cpu_features_from_host(cpu);
+    kvm_arm_set_cpu_features_from_host(cpu, false);
     aarch64_add_sve_properties(obj);
 #elif defined(CONFIG_HVF)
     hvf_arm_set_cpu_features_from_host(cpu);
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 88cbe8d85c..94478c5690 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -45,7 +45,8 @@ bool kvm_arm_el2_supported(void)
 /*
  * These functions should never actually be called without KVM support.
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
+                                        bool get_all_writable_id_regs)
 {
     g_assert_not_reached();
 }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f06a60804d..1a9b91bf8a 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -42,6 +42,7 @@
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
 #include "migration/blocker.h"
+#include "cpu-idregs.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(DEVICE_CTRL),
@@ -274,7 +275,63 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
 }
 
-static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+static int idregs_idx_to_kvm_feature_idx(ARMIDRegisterIdx idx)
+{
+    ARMSysRegs sysreg = id_register_sysreg[idx];
+
+    return KVM_ARM_FEATURE_ID_RANGE_IDX((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK)
+                                            >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK)
+                                            >> CP_REG_ARM64_SYSREG_OP1_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK)
+                                            >> CP_REG_ARM64_SYSREG_CRN_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK)
+                                            >> CP_REG_ARM64_SYSREG_CRM_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK)
+                                            >> CP_REG_ARM64_SYSREG_OP2_SHIFT);
+}
+
+/*
+ * get_host_cpu_idregs: Read all the writable ID reg host values
+ *
+ * Need to be called once the writable mask has been populated
+ * Note we may want to read all the known id regs but some of them are not
+ * writable and return an error, hence the choice of reading only those which
+ * are writable. Those are also readable!
+ */
+static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
+{
+    int err = 0;
+    int i;
+
+    for (i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
+        ARMSysRegs sysreg = sysregdesc->sysreg;
+        uint64_t writable_mask =
+             cpu->writable_map->regs[idregs_idx_to_kvm_feature_idx(i)];
+        uint64_t *reg;
+        int ret;
+
+        if (!writable_mask) {
+            continue;
+        }
+
+        reg = &ahcf->isar.idregs[i];
+        ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
+        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
+        if (ret) {
+            error_report("%s error reading value of host %s register (%m)",
+                         __func__, sysregdesc->name);
+
+            err = ret;
+        }
+    }
+    return err;
+}
+
+static bool
+kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf,
+                              bool get_all_writable_id_regs)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -401,6 +458,18 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_MMFR5_EL1_IDX);
 
+        /* Make sure writable ID reg values are read */
+        if (get_all_writable_id_regs) {
+            err |= get_host_cpu_idregs(cpu, fd, ahcf);
+        }
+
+        /*
+         * temporarily override the CLIDR_EL1 value since host value does
+         * not seem to be supported. Getting "Unified type is not implemented
+         * at level n" error in fdt_add_cpu_nodes()
+         */
+        SET_IDREG(&ahcf->isar, CLIDR, 0x0);
+
         /*
          * DBGDIDR is a bit complicated because the kernel doesn't
          * provide an accessor for it in 64-bit mode, which is what this
@@ -477,13 +546,15 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     return true;
 }
 
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
+                                        bool get_all_writable_id_regs)
 {
     CPUARMState *env = &cpu->env;
 
     if (!arm_host_cpu_features.dtb_compatible) {
         if (!kvm_enabled() ||
-            !kvm_arm_get_host_cpu_features(&arm_host_cpu_features)) {
+            !kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features,
+                                           get_all_writable_id_regs)) {
             /* We can't report this error yet, so flag that we need to
              * in arm_cpu_realizefn().
              */
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index b22a56fc17..91a7d5cc4b 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -127,11 +127,15 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
 /**
  * kvm_arm_set_cpu_features_from_host:
  * @cpu: ARMCPU to set the features for
+ * @get_all_writable_id_regs: if true, get the contents of all writable ID
+ *                            registers as well
  *
  * Set up the ARMCPU struct fields up to match the information probed
  * from the host CPU.
+ *
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
+                                        bool get_all_writable_id_regs);
 
 /**
  * kvm_arm_add_vcpu_properties:
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8502fb3265..8c7faf57c7 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,6 +13,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

