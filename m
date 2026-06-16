Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581943043C8
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616470; cv=none; b=X0OJKb8VISmiAsAwFE/h8vjTmdp8AcVXqjTpaJnz6gpccP+nmidWub8i4HC6uvx3xzgGjsqVGCaH26IWZ6HXoOdLEeVVRU5h/czso+V5dXIWNDQ7CuopCElpadOVWHXTEghJg4wGl2ig2fj0rs3n0ukTTmA1fBoXHgUkZ3/8qm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616470; c=relaxed/simple;
	bh=0DZI3pk/DRjYxp4hmRa4cXqV3BLsDtdEkZrMZXChWqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=eT7nk7F+bkdXvRN0PKhlOZngTojPdt65v5w3K+yZLHzJ5+o7sNNZeXJPSKICCVem1JcQdzfioWlvTpE3XmG50hOn6/hSONRxuBhVBNtWotW/VaQtW9mpFbJNdkehbludS3aO9fvcIdLOck2IrD6EO1ks5AQiFyV0+KSpVIprPaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aT0cVbvE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aT0cVbvE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781616468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qySDmpGubd1jDBl8VeG5Y8I9gHIq9QwIiLHxNZ7iLZI=;
	b=aT0cVbvEAFDNJeWnyrLpxK0refEBqkaF2v4/KMmOI6jotvlkK2LfygcBWmCcHlLDQD8N7Q
	jqVdEOKx7akBeRoC+HALc1NTmY0Ro7oi4A3npwT4AM1I15tSBTNYljO0qvyICXCKpllWQ4
	dpWtUFHJjyhodJws833aQb5ek5ae6x8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-466-C5W2-Wa8NoS7vpCoZazcbQ-1; Tue,
 16 Jun 2026 09:27:46 -0400
X-MC-Unique: C5W2-Wa8NoS7vpCoZazcbQ-1
X-Mimecast-MFC-AGG-ID: C5W2-Wa8NoS7vpCoZazcbQ_1781616464
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B85E3195607E;
	Tue, 16 Jun 2026 13:27:44 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC2353008B3B;
	Tue, 16 Jun 2026 13:27:38 +0000 (UTC)
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
Subject: [RFC PATCH v6 10/17] target/arm/kvm: Retrieve writable ID reg map
Date: Tue, 16 Jun 2026 15:16:57 +0200
Message-ID: <20260616132625.1732031-11-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-1-eric.auger@redhat.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: bzVqTLilG0i-fdbcvvllGgss8iKa7HW9QVjP9N_1cP8_1781616464
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Add an helper to retrieve the writable id reg bitmask.

then retrieve the writable_map array and dispatch it in the writable_map
fields of arm64_id_regs[] elements.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v5 -> v6
- use arm64_id_regs[].writable_map
- squashed 2 commits (helper + user)
- removed stub
---
 target/arm/kvm.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index a54ef51ec2..6f91407d41 100644
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
@@ -273,6 +275,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
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
@@ -480,9 +497,53 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
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
+    if (kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range)) {
+        return -errno;
+    }
+    return 0;
+}
+
 void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
 {
     CPUARMState *env = &cpu->env;
+    uint64_t *writable_map;
+
+    writable_map = g_new(uint64_t, KVM_ARM_FEATURE_ID_RANGE_SIZE);
+
+    if (!writable_map_dispatched &&
+        !kvm_arm_get_writable_id_regs(writable_map)) {
+        for (int i = 0; i < KVM_ARM_FEATURE_ID_RANGE_SIZE; i++) {
+            uint64_t mask = writable_map[i];
+
+            if (mask) {
+                int idx = kvm_feature_idx_to_idregs_idx(i);
+
+                if (idx < 0 || idx > ARRAY_SIZE(arm64_id_regs)) {
+                    continue;
+                }
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

