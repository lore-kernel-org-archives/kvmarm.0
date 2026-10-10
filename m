Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D1B353A8E
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639523; cv=none; b=bmFFTTxRxyAXX22Ij8gAy3MWJF2IAEjlG5klqGIo2VXXsPksVvmg9yTh6YDfjf3+DGJMLfhZy51/3ogzfug6EmUeJYgjxiZiU+ExwFboN+b9qmFkaroAZW4hXa0hrrLyqx6p08BrtoHWLR4DjuFVlmvWLtk8ifXUy3AggPqcczg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639523; c=relaxed/simple;
	bh=ShJn5RtI4HyqczqP4HhS21reBDk4KeV5+ca2rHq09zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lgOPTLrNn5KpOiaarM2iJ+gkpUWM9TIW00tSUhnxU/bm7Jzg2OpxY7nsgBydi68aDk+dFKuw7u+a0JYrmM238kuQh/RHvCNi4pRS0F4yWe487y034G72giMH9i/A5EcAcmMx+j9dUmYzyuH7lzvsyIMUPoS42oJi1xzFVxUd6Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czeGcrOP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czeGcrOP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=InNpy/fUH23ypsNkCh7xC1ndZPiRh9XsgEv/1J5P96c=;
	b=czeGcrOPFDqThyzZ9jmawYTNDaOvi5ayeXeeL0X3+DU0JDwQU4htc1kqe6Mgx6DnFwmE/G
	8mMgpyGhJMlsBiJWcBtKO9cIdk5ZXD4nBJK96HOH09NiWr10114yjimI3oKNePnfq3f5bE
	LIZBS1BAyz8np5PSPRdzuFgDTzbQeyc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-314-DUR5OHDDMySzgg9fJ2vOaw-1; Sat,
 10 Oct 2026 13:38:37 +0000
X-MC-Unique: DUR5OHDDMySzgg9fJ2vOaw-1
X-Mimecast-MFC-AGG-ID: DUR5OHDDMySzgg9fJ2vOaw_1791639515
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0D9A1809C9F;
	Sat, 10 Oct 2026 13:38:35 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4D61230000E5;
	Sat, 10 Oct 2026 13:38:31 +0000 (UTC)
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
Subject: [PATCH v10 12/26] arm/kvm: Initialize isar.idregs[] with all writable host ID regs
Date: Sat, 10 Oct 2026 15:36:16 +0200
Message-ID: <20261010133725.642498-13-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: bzvqdEgy6v848K637nOfuz8GRDvox_scNr5Av1bX2rY_1791639515
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

kvm_arm_get_host_cpu_features() already retrieves the values of some
host id registers to analyze the available vcpu features.

Eventually we want to be able to allow the user to change the value
of writable ID reg fields. So we need to store the initial value of all
writable ID regs into isar.idregs[].

Introduce a new get_host_cpu_idregs() helper that populates isar.idregs[]
and call it from kvm_arm_get_host_cpu_features.

This patch has no impact on cpreg values. isar.idregs[] is only
used as a temporary storage for register values to be updated in place
later.  Also it does not handle the writeback of isar.idregs[] into cpreg
value list after user update. This will be handled separately.

Note the host values are retrieved from the scratch vcpu initialized with
all the available capabilities exposed by KVM, independently on the
final vcpu features made by the user through the legacy composite
options such as sve, pauth, virtualization, ...

At the moment, the only caller sets writable to true. Named vcpu models
will use the writable=false mode. Note this will require some extra
handling for ID regs that cannot be read from KVM.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---
v9 -> v10:
- get rid of spurious kvm_arm_writable_idregs_to_cpreg_list trace point
- add a writable parameter to get_host_cpu_idregs
- some code cleanup

v8 -> v9:
- improve the commit msg. Only initialize in this patch and move the
  write back to cpreg value list in a different patch.
- Do not hack CLIDR here. The correct way to fix that temporarily is to
  do that in the machine instead.

v7 -> v8
- fix indent and added Khushit's R-b

v6 -> v7
- remove vcpu from prototypes (Khushit)

v5 -> v6
- do not check writable_map anymore
---
 target/arm/kvm.c        | 44 ++++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |  1 +
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 2e68130611..ac4f307276 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -43,6 +43,7 @@
 #include "hw/acpi/ghes.h"
 #include "target/arm/gtimer.h"
 #include "migration/blocker.h"
+#include "cpu-idregs.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(DEVICE_CTRL),
@@ -329,7 +330,45 @@ static int kvm_feature_idx_to_idregs_idx(int kidx)
     return get_sysreg_idx(sysreg);
 }
 
-static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+/*
+ * get_host_cpu_idregs: Read all the ID register values from KVM
+ * vcpu fd and populate @ahcf->isar.idregs[] with those values
+ *
+ * Need to be called once the writable mask has been populated
+ * if @writable is set
+ *
+ * @fd: vcpu fd
+ * @ahcf: ARMHostCPUFeatures whose @ahcf->isar.idregs[] will be
+ *        populated
+ * @writable: if set, only writable ID regs are read
+ */
+static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf, bool writable)
+{
+    for (int i = 0; i < NUM_ID_IDX; i++) {
+        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
+        ARMSysRegs sysreg = id_register_sysreg[i];
+        uint64_t *reg;
+        int ret;
+
+        if (writable && !sysregdesc->writable_mask) {
+            continue;
+        }
+
+        reg = &ahcf->isar.idregs[i];
+        ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
+        if (ret) {
+            error_report("%s error reading value of host %s register (%m)",
+                         __func__, sysregdesc->name);
+
+            return ret;
+        }
+        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
+    }
+    return 0;
+}
+
+static void
+kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -415,6 +454,9 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
+        /* Make sure all writable ID reg values are initialized */
+        err |= get_host_cpu_idregs(fd, ahcf, true);
+
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR2_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64SMFR0_EL1_IDX);
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

