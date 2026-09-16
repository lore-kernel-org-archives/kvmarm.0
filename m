Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37F0372056
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570123; cv=none; b=KNGOttBziS+US7ufw+S8BoQPW0Acn1nYFlu8wqSnXtI/LDTGilsRRnmvJ4LjRMgulzfTLxzW/gp/FZ4p317IhsXLskm5xXsskqlmSIru5grazFd/J7d9oblzJ1m/9MUHeVL3wrMhFhTKyJ3JK1Di9+2J1qNof2TxEtJK9vZXTik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570123; c=relaxed/simple;
	bh=UuBFW6HII9SzJ095nBLSUhz3AEhdWncBX6cTI4lsMqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=SCkQyEqv/2Pz2BEOz2M72hn8Xf+G9RF0CbFp8LXE3Sw42R4M70ng6TuBhIETnmVq+5qzIXbhWgkWbAtqPuR+76DITiiY82OBqvI23rp9EUnjfgOcsquDFp/8aL9KszKmQWmGqUZGbSj6M3ve2BxLa5OfyS28FpMZG64BEehTkSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6mNfavz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6mNfavz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ylh65uksM6s0BIsXywmqk/EXVHl0RfoLcmi93Q7NDRA=;
	b=f6mNfavzdHB0GbAreuMzto1je1VAUlldnFLukBDZYxibcU4mXhCGbdwWpgC5DW9d549BM4
	sd5xiK7NEXfCSp6Bb9xkshUJXa2//oAZMhLK/dnvY67I1v/JMhHc+MuHgxZhFbzHPDL3gw
	rUEabGKENDlrO+wHfN5mD4xgR0f6n+g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-mR0P1x32ODGusYOEJYnvJw-1; Wed,
 16 Sep 2026 10:48:37 -0400
X-MC-Unique: mR0P1x32ODGusYOEJYnvJw-1
X-Mimecast-MFC-AGG-ID: mR0P1x32ODGusYOEJYnvJw_1789570115
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54DD2184B386;
	Wed, 16 Sep 2026 14:48:35 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2F3419560AB;
	Wed, 16 Sep 2026 14:48:30 +0000 (UTC)
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
Subject: [PATCH v9 12/26] arm/kvm: Initialize isar.idregs[] with all writable host ID regs
Date: Wed, 16 Sep 2026 16:45:35 +0200
Message-ID: <20260916144721.751810-13-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: YVKxROaIQny1E7SUkl-qdQ9C-MIuWu4JbERMHQk7Ip4_1789570115
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
final choice made by the suer.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---
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
 target/arm/kvm.c        | 43 ++++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |  2 ++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c6eac41991..958b25e550 100644
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
@@ -376,6 +414,9 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
+        /* Make sure all writable ID reg values are initialized */
+        err |= get_host_cpu_idregs(fd, ahcf);
+
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR2_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64SMFR0_EL1_IDX);
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

