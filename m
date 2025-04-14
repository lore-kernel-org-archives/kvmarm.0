Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A2E1B3929
	for <kvmarm@lists.linux.dev>; Mon, 14 Apr 2025 16:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744648861; cv=none; b=LpxlQELe+9vPX5c9yS1KD4Ken5GeOVtORq8GQaA7CeHdkUYQDtH7dqG+DvYMEsWeIfl6O8bBWpu9NKVvENizjlhi7VVRSRQHj1DioJXHOYTWkN1iyzS7SURmdc9BscBysYvVs/JduQ7h000K/hTHCssYaenE19skm7eFBDJQjj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744648861; c=relaxed/simple;
	bh=+iABiCQJsy8pVcEiva5CX39JSjbdpfeCrAj9evDDypQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=aIwSKLG3Egm/IpyWxafSTDO4fEV+fsyg3bl3c9bvQZfr6TW7iv8li/HSlw5a3j95DLmFFY+LTd9hb9WrH1iwBZJxo4Y9M9m2fHT/dN/mIGEfBXTwGHDOUKJmfgPS+rGZ0W++HRvH0XenYWRS4in5lbtnLYq10hVpbE/+PzCflc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYHlLrM/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYHlLrM/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744648858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/cm0715fZCJ1Z/wDTOFk0hsjOspQTrfFjfUTkh4U41I=;
	b=UYHlLrM/m19lp2x6tzIm9HXmulP1O2gTyseG2FmsOXOS0o4yTcK/DzPW6fbKiAoRWkUXgD
	pLPTgf7SdVPjWCTuS8ZFagrXWoU/GDJvkuXxyOcl6wJFfVnNnNNPUSKyqDHAGB9GEw4rts
	gXcoPeeEEAEH8kStU2JGNx2OX3fJK6U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-rydyobF0My2CeO6h_6QyHg-1; Mon,
 14 Apr 2025 12:40:54 -0400
X-MC-Unique: rydyobF0My2CeO6h_6QyHg-1
X-Mimecast-MFC-AGG-ID: rydyobF0My2CeO6h_6QyHg_1744648853
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5EF3180AF4E;
	Mon, 14 Apr 2025 16:40:52 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.14])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 20EDE180AF7C;
	Mon, 14 Apr 2025 16:40:36 +0000 (UTC)
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
Cc: agraf@csgraf.de,
	shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID registers
Date: Mon, 14 Apr 2025 18:38:45 +0200
Message-ID: <20250414163849.321857-7-cohuck@redhat.com>
In-Reply-To: <20250414163849.321857-1-cohuck@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
 target/arm/cpu-sysregs.h |  2 ++
 target/arm/cpu.h         |  3 ++
 target/arm/cpu64.c       |  2 +-
 target/arm/kvm.c         | 78 ++++++++++++++++++++++++++++++++++++++--
 target/arm/kvm_arm.h     |  9 +++--
 target/arm/trace-events  |  1 +
 6 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
index e89a1105904c..367fab51f19e 100644
--- a/target/arm/cpu-sysregs.h
+++ b/target/arm/cpu-sysregs.h
@@ -41,6 +41,8 @@ int get_sysreg_idx(ARMSysRegs sysreg);
 
 #ifdef CONFIG_KVM
 uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg);
+int kvm_idx_to_idregs_idx(int kidx);
+int idregs_idx_to_kvm_idx(ARMIDRegisterIdx idx);
 #endif
 
 #endif /* ARM_CPU_SYSREGS_H */
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 775a8aebc5d3..8717c5e7695b 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1088,6 +1088,9 @@ struct ArchCPU {
      */
     ARMIdRegsState writable_id_regs;
 
+    /* ID reg writable bitmask (KVM only) */
+    IdRegMap *writable_map;
+
     /* QOM property to indicate we should use the back-compat CNTFRQ default */
     bool backcompat_cntfrq;
 
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 839442745ea4..60a709502697 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -757,7 +757,7 @@ static void aarch64_host_initfn(Object *obj)
 {
 #if defined(CONFIG_KVM)
     ARMCPU *cpu = ARM_CPU(obj);
-    kvm_arm_set_cpu_features_from_host(cpu);
+    kvm_arm_set_cpu_features_from_host(cpu, false);
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         aarch64_add_sve_properties(obj);
         aarch64_add_pauth_properties(obj);
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 6e3cd06e9bc5..b07d5f16db50 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -41,6 +41,7 @@
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
 #include "migration/blocker.h"
+#include "cpu-custom.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(DEVICE_CTRL),
@@ -270,7 +271,73 @@ static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf, ARMIDRegisterIdx i
     return ret;
 }
 
-static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+int kvm_idx_to_idregs_idx(int kidx)
+{
+    int op1, crm, op2;
+    ARMSysRegs sysreg;
+
+    op1 = kidx / 64;
+    if (op1 == 2) {
+        op1 = 3;
+    }
+    crm = (kidx % 64) / 8;
+    op2 = kidx % 8;
+    sysreg = ENCODE_ID_REG(3, op1, 0, crm, op2);
+    return get_sysreg_idx(sysreg);
+}
+
+int idregs_idx_to_kvm_idx(ARMIDRegisterIdx idx)
+{
+    ARMSysRegs sysreg = id_register_sysreg[idx];
+
+    return KVM_ARM_FEATURE_ID_RANGE_IDX((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >> CP_REG_ARM64_SYSREG_OP1_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >> CP_REG_ARM64_SYSREG_CRN_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >> CP_REG_ARM64_SYSREG_CRM_SHIFT,
+                                        (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >> CP_REG_ARM64_SYSREG_OP2_SHIFT);
+}
+
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
+        uint64_t writable_mask = cpu->writable_map->regs[idregs_idx_to_kvm_idx(i)];
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
+                              bool exhaustive)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -398,6 +465,11 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_MMFR5_EL1_IDX);
 
+        /* Make sure writable ID reg values are read */
+        if (exhaustive) {
+            err |= get_host_cpu_idregs(cpu, fd, ahcf);
+        }
+
         /*
          * DBGDIDR is a bit complicated because the kernel doesn't
          * provide an accessor for it in 64-bit mode, which is what this
@@ -467,13 +539,13 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
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
index 8d1f20ca8d89..90ba4f7d8987 100644
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
index 4438dce7becc..17e52c0705f2 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,3 +13,4 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
-- 
2.49.0

