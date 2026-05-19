Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591A4348C68
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197440; cv=none; b=SdsAM0nm5zjf2MwaCGsXayUxBbZ5mkYt4WN7nVhlUkrIuJLoAXAVIKWIj859BP0obw5X67U46jX8yom6aaX/GwIol654vFiC+snlDks7Vkae5dyeJ9KIsU/zml9+/3Te7SX6RdhzmD4ky8cVZpqjS/0cpNFeYJ16W3VXlGn+b+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197440; c=relaxed/simple;
	bh=4lx7ockVnJW2cw10AaoTJSMuE0lJGs4vtxMlox/Hio8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Sht8ne2o/8asp6C4ur0Rz9F/IFaHysA+ko8OPS3ZBzKPJiYyH33n21pRNVxlKOpQW7q7ssE+DYVfz5jaQLhJ4r6jq2SrsLCfTCATcSYRraDDrdYHvybMwJ/zityog1VA8lhVRCriYnHMApI6atStxuiGF9bwG8bTZOMDOncv4r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQNWKo1y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQNWKo1y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8DMCPN/WdBIKu5QiyxjCLPAVxgVe9vHmRLSH8oesEs=;
	b=WQNWKo1ywA+zkCkvNAxrBIGEJ8REcCODgMXijmZHPqdFJduXnLtloyBFRviIzNxaN4sVXf
	CZSdA1NjvNM2mO2DoQDmHz0oaTaZIAqWyvufzZiMJqV0bCGHZ661aK0siatHwvMel556rw
	MhgIGxOhbSbeNG5tU16yIhXCzmQekbs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-9-b52CZDXXNAqkb3cCqCQaSA-1; Tue,
 19 May 2026 09:30:32 -0400
X-MC-Unique: b52CZDXXNAqkb3cCqCQaSA-1
X-Mimecast-MFC-AGG-ID: b52CZDXXNAqkb3cCqCQaSA_1779197429
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16C931956096;
	Tue, 19 May 2026 13:30:29 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5FF4E1800286;
	Tue, 19 May 2026 13:30:23 +0000 (UTC)
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
Subject: [PATCH v5 11/18] arm/kvm: Initialize all writable ID registers from host
Date: Tue, 19 May 2026 15:27:25 +0200
Message-ID: <20260519132905.145643-12-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ZDo7VUjDRsDkVjo8h8kVoZnb8fgkzX64RqdWy0Vp-bs_1779197429
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
---
 target/arm/kvm.c        | 72 +++++++++++++++++++++++++++++++++++++++--
 target/arm/trace-events |  1 +
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 4adfd20050..92219ee62e 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -42,6 +42,7 @@
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
 #include "migration/blocker.h"
+#include "cpu-idregs.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(DEVICE_CTRL),
@@ -273,7 +274,62 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
 }
 
-static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
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
+        ARMSysRegs sysreg = id_register_sysreg[i];
+        uint64_t writable_mask =
+             cpu->writable_map[idregs_idx_to_kvm_feature_idx(i)];
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
+static void
+kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -359,6 +415,18 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
+        /* Make sure all writable ID reg values are initialized */
+        if (cpu->writable_map) {
+            err |= get_host_cpu_idregs(cpu, fd, ahcf);
+        }
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
@@ -485,7 +553,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     CPUARMState *env = &cpu->env;
 
     if (!arm_host_cpu_features.dtb_compatible) {
-        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+        kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features);
     }
 
     cpu->kvm_target = arm_host_cpu_features.target;
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

