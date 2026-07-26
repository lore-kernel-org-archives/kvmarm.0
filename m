Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9220F26C3BD
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785080083; cv=none; b=TFT+CcbW/5lS05bCQeM4K1FNgaRgR/DyrSWCjOlpf5MlkLH4j9/KwvvbNr0XbPqTCWmFk3ZE0RLPXHCZlfQsLp+6Y6jQJjhmo8BeZIUqtPnQz/cLBStQ9uWJp4RCeG7+jd1V37S1b2DQV6Byf/hU7YpEdp+3WynHMFQX6/YFPJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785080083; c=relaxed/simple;
	bh=/P8lfQiVwcktZL0WhLMYYyer/DdQZCPTxz7MyIaM5G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=F9yMSrATOHAA+2hLR4OAcffIJJurdOLc4ZW8o0APQQ4Vo3671U+XtekzEXYf9Dzjx2VK+4x3A5i4xOrC5c72JrmRPvYNHwr28/HH8zuh5i718j43TnrETiYaXnIAIzNH/jD/1zoXifoYmIERaRJqw1nxV+cbqkTo+fBHLsW1wjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cbcDMIZg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cbcDMIZg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785080080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQHLeVMn7NrSzcX11wqfgCH1LPJI923k+J+9n3UK0dE=;
	b=cbcDMIZgVPoQdwFpXX5ItemtF063CvEdQ8isxT1pu8w/PuwhE0pjGwnMtC2nQ80+vs1mDU
	LMO56frZrd5RpX6FdaBw73M5u8oCNq3XjU+/+haBLGKxFzyvhitDKD14r/i0u8zv6hiQss
	aecCpu6PuiyPWpu6f7tuNEoEORQcUV8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-q77xvTpnOhikINefXlHZGw-1; Sun,
 26 Jul 2026 11:34:38 -0400
X-MC-Unique: q77xvTpnOhikINefXlHZGw-1
X-Mimecast-MFC-AGG-ID: q77xvTpnOhikINefXlHZGw_1785080076
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FD40195604D;
	Sun, 26 Jul 2026 15:34:36 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.32.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 515771800613;
	Sun, 26 Jul 2026 15:34:27 +0000 (UTC)
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
Subject: [RFC PATCH v7 11/18] arm/kvm: Initialize all writable ID registers from host
Date: Sun, 26 Jul 2026 17:29:49 +0200
Message-ID: <20260726153221.24773-12-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-1-eric.auger@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: UCTHExs4p3Pj9lUHnNPQoFk3xZmWDYWxA2n51q_THcE_1785080076
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

v6 -> v7
- remove vcpu from prototypes (Khushit)

v5 -> v6
- do not check writable_map anymore
---
 target/arm/kvm.c        | 96 ++++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |  2 +
 2 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index d270f9870e..4f9b0a559d 100644
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
+static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
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
+kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -376,6 +414,16 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
+        /* Make sure all writable ID reg values are initialized */
+        err |= get_host_cpu_idregs(fd, ahcf);
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
@@ -2115,7 +2191,23 @@ int kvm_arch_init_vcpu(CPUState *cs)
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

