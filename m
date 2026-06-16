Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C011C31E83A
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616481; cv=none; b=OENshS5Do3PBQDocsB3wP7Iv5h23dpir9LhFSSoTh4pTqB/PpMnWwrqmG9iVELhv3TsWoXu7EZZJ7l/mKT+lU2aelxLJ9ihkUUIBZwkgZt5QPG0zVeBWhri9dHQJ/CJ3HvRZlEEebRcg5y+vOH4fm1Z0RqCwPO2OYI8vmRI7PBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616481; c=relaxed/simple;
	bh=sVehwUZuzqHuVgejI00C+gQc06YebFia86dKwBT3sMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Yk/Jv/tA1S7rX/lD5U1dEKuLR2iMmL90gFhG4+RxJ2bkcOs6D9jXdfEqPKdMcwGeyRmFuzsnMvWWd6G1TuZV1gf61YlcMg8WElf7FJl4aDJiu8AcWfdwvoBIUQZTLBDRWJCzMnlGcwYf4EgDA5CYlP/EZ4ijJmK3MTzyb5OEM84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y/e61t3h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y/e61t3h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781616478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWaLRfbYppUr53JAOOxq+GVzOZ/4SyEwIu1SgSdirsY=;
	b=Y/e61t3hZ2NUdKpGp680UZH4ll57urAApca7afqf7otgx7dUwGMzIoFBbjMjfI8YzECKD5
	bm0vPDq6MgS1CqLcjT3gyuzwNUwnGzhFmrO2SfH70fm6Y6QaxcgK1Ds7zvF1IrnAtif1Qk
	eI2i5bjFKvb/VHS514b8o5f4sZhEO18=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-VTTFumi0NguQ0GwZwXKeXw-1; Tue,
 16 Jun 2026 09:27:53 -0400
X-MC-Unique: VTTFumi0NguQ0GwZwXKeXw-1
X-Mimecast-MFC-AGG-ID: VTTFumi0NguQ0GwZwXKeXw_1781616471
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 455C518009E0;
	Tue, 16 Jun 2026 13:27:51 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E74E3000203;
	Tue, 16 Jun 2026 13:27:44 +0000 (UTC)
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
Subject: [RFC PATCH v6 11/17] arm/kvm: Initialize all writable ID registers from host
Date: Tue, 16 Jun 2026 15:16:58 +0200
Message-ID: <20260616132625.1732031-12-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-1-eric.auger@redhat.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: I1wKCDRpx3ZB-c-RMYD1BqcuyhuIiOkalu1NwgLw5O8_1781616471
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We want to allow overwriting writable fields of some ID registers.
However currently some of them are never touched, neither read nor
w. Examples are CLIDR_EL1, CTR_EL0, REVIDR_EL1, MIDR_EL1.

We want to initialize them from the host value, allow overwrite
and write back for kvm afterwards. This patch implements the
initialization.

Introduce a new get_host_cpu_idregs() helper that gets the host
values for all writable ID regs and store them in isar.idregs[].

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v5 -> v6
- do not check writable_map anymore
---
 target/arm/kvm.c        | 98 +++++++++++++++++++++++++++++++++++++++--
 target/arm/trace-events |  2 +
 2 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 6f91407d41..71a214f228 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -43,6 +43,7 @@
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
 #include "migration/blocker.h"
+#include "cpu-idregs.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(DEVICE_CTRL),
@@ -290,7 +291,44 @@ static int kvm_feature_idx_to_idregs_idx(int kidx)
     return get_sysreg_idx(sysreg);
 }
 
-static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
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
+        ARMSysRegs sysreg = id_register_sysreg[i];
+        uint64_t *reg;
+        int ret;
+
+        if (!sysregdesc->writable_mask) {
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
+static void
+kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -376,6 +414,16 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
+        /* Make sure all writable ID reg values are initialized */
+        err |= get_host_cpu_idregs(cpu, fd, ahcf);
+
+        /*
+         * temporarily override the CLIDR_EL1 value since some host values
+         * trigger "Unified type is not implemented at level n" error in
+         * fdt_add_cpu_nodes()
+         */
+        SET_IDREG(&ahcf->isar, CLIDR, 0x0);
+
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR2_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64SMFR0_EL1_IDX);
@@ -546,7 +594,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     g_free(writable_map);
 
     if (!arm_host_cpu_features.dtb_compatible) {
-        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+        kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features);
     }
 
     cpu->kvm_target = arm_host_cpu_features.target;
@@ -1161,6 +1209,34 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+/*
+ * Copy writable ID regs from isar.idregs[] to cpreg_list
+ * in case their value differs from the original init cpreg value
+ */
+static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
+        ARMSysRegs sysreg = id_register_sysreg[i];
+        uint64_t previous, new;
+        uint64_t *cpreg;
+
+        if (!sysregdesc->writable_mask) {
+            continue;
+        }
+
+        cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
+        previous = *cpreg;
+        new = cpu->isar.idregs[i];
+
+        if (previous != new) {
+            *cpreg = new;
+            trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
+                                                        previous, new);
+         }
+    }
+}
+
 void kvm_arm_reset_vcpu(ARMCPU *cpu)
 {
     int ret;
@@ -2113,7 +2189,23 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
 
-    return kvm_arm_init_cpreg_list(cpu);
+    ret = kvm_arm_init_cpreg_list(cpu);
+    if (ret) {
+        return ret;
+    }
+    /* overwrite writable ID regs with their updated property values */
+    kvm_arm_writable_idregs_to_cpreg_list(cpu);
+    ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
+    if (!ret) {
+        return -1;
+    }
+    /*
+     * modified values may have changed the visibility of some regs,
+     * reinitialize the cpreg_list accordingly
+     */
+     ret = kvm_arm_init_cpreg_list(cpu);
+
+    return ret;
 }
 
 int kvm_arch_destroy_vcpu(CPUState *cs)
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 8502fb3265..c25d2a1191 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -13,6 +13,8 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
+get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
+kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

