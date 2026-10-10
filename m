Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62893749E3
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639512; cv=none; b=u+77qR1dgJEGbq1E01OjfiJAZWrbn8ryAYL1Am90Qkpb6a0Grck2X1/psIShd+S+O5HnIijo2ca9qEw6EPf6YbIsjkzTbAchCzmIrgPxtvnz3VCYWh/prvU5g6r0OFdiKgi0lFQnOjRKeYhVjEvT5ikn+EjCT84UsU2/amv3arc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639512; c=relaxed/simple;
	bh=naGiBTc37z/BNoHW+V6J6s1nghzYz8NzWMwikQOpjR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Bz4ScRuRdOsyZyCJFYtmsAkxa5VYv0P1ARX8mTjKAlKVqG4fwpy7vAFHYPLLW1SRmpbMWMwHEtoScJSr+40/3YfKcLMfI6+PgmxZRkmpFP0zvyk8ivivtH2Qxfxig+HHcQR0vKZ+RkJf0LU/IHtWV9azXJ9KeTH7fg8T0jeBaUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SwFFs4Gd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SwFFs4Gd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JIONCANj+MKk7AafgcfEQAY6C/fPP7uZSDIuv7Ano6A=;
	b=SwFFs4Gd8G7mgkhIc/7e1uCAkWEv0JX5rYfGXOi8EDcGE+iAJomLvzE5ftkCzmH9hWThM8
	nZugiuUCgUyoQcODJtU1K/62AjaR7Zkf4PVzGzAA4HHpgjv6h2cSwUJWo55zWH971j+Bd6
	ygq09kGOdhR1zfFMojYHFqK6cdOw9rM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-t-MKfQVdMCGq7EYO8RpJwg-1; Sat,
 10 Oct 2026 13:38:28 +0000
X-MC-Unique: t-MKfQVdMCGq7EYO8RpJwg-1
X-Mimecast-MFC-AGG-ID: t-MKfQVdMCGq7EYO8RpJwg_1791639506
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D0411956044;
	Sat, 10 Oct 2026 13:38:26 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4422230000E5;
	Sat, 10 Oct 2026 13:38:21 +0000 (UTC)
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
Subject: [PATCH v10 10/26] target/arm/kvm: Retrieve writable ID reg map
Date: Sat, 10 Oct 2026 15:36:14 +0200
Message-ID: <20261010133725.642498-11-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: ZS-khqUuXTSYnRKDFY72__ov_VFD5_JbnxdcFUvLsns_1791639506
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Add a helper to retrieve the writable id reg bitmask.

then retrieve the writable_mask array and dispatch it in the writable_map
field of arm64_id_regs[] elements.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v9 -> v10:
- removed if (idx < 0 || idx > ARRAY_SIZE(arm64_id_regs)) check
- commit description cleanup

v7 -> v8
- added kvm_enabled()

v5 -> v6
- use arm64_id_regs[].writable_map
- squashed 2 commits (helper + user)
- removed stub
---
 target/arm/kvm.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 9d68801c26..2e68130611 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -28,6 +28,7 @@
 #include "kvm_arm.h"
 #include "cpu.h"
 #include "cpu-sysregs.h"
+#include "cpu-idregs.h"
 #include "trace.h"
 #include "internals.h"
 #include "hw/pci/pci.h"
@@ -51,6 +52,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
 static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
 static bool cap_has_inject_ext_dabt;
+static bool writable_map_dispatched;
 
 /**
  * ARMHostCPUFeatures: information about the host CPU (identified
@@ -312,6 +314,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
 }
 
+static int kvm_feature_idx_to_idregs_idx(int kidx)
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
 static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
@@ -523,9 +540,47 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     ahcf->features = features;
 }
 
+static int kvm_arm_get_writable_id_regs(uint64_t *idregmap)
+{
+    int cap_writable_id_regs;
+    struct reg_mask_range range = {
+        .range = KVM_ARM_FEATURE_ID_RANGE,
+        .reserved = {0},
+        .addr = (uint64_t)idregmap,
+    };
+
+    cap_writable_id_regs =
+        kvm_check_extension(kvm_state, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
+
+    if (!cap_writable_id_regs ||
+        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
+        return -ENOSYS;
+    }
+
+    return kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+}
+
 void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
 {
     CPUARMState *env = &cpu->env;
+    uint64_t *writable_map;
+
+    writable_map = g_new(uint64_t, KVM_ARM_FEATURE_ID_RANGE_SIZE);
+
+    if (kvm_enabled() && !writable_map_dispatched &&
+        !kvm_arm_get_writable_id_regs(writable_map)) {
+        for (int i = 0; i < KVM_ARM_FEATURE_ID_RANGE_SIZE; i++) {
+            uint64_t mask = writable_map[i];
+
+            if (mask) {
+                int idx = kvm_feature_idx_to_idregs_idx(i);
+
+                arm64_id_regs[idx].writable_mask = mask;
+            }
+        }
+        writable_map_dispatched = true;
+    }
+    g_free(writable_map);
 
     if (!arm_host_cpu_features.dtb_compatible) {
         kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
-- 
2.53.0

