Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3317526C3BD
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785080073; cv=none; b=WZecu/xpTeOwS3SX7+CTb67hpdymEV4CQoYGJLVIg0tI4Z6Dw6mAIRoEVOPSoI1yTchM54+P3DnaAv1EYI5mR58P9w3XBBeKSLdNlRueFboMNFUhHr7p/33T7jz3tPpL1jARSltSHGXExDKJFgCPDeiEz+M3WPvSGgiAkVMoUOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785080073; c=relaxed/simple;
	bh=N+LzBVKV1bVXuzLYBuSEDokqhnTySttiisWvhYLVMDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Cv4KCyrjjFv92YlDhJ02XBeFCnCZ+1TLNo4AdkaaQR0y/5FZa9YDtZ88FUfQ/89f68SJs3yEwgJ25PyaygGbyi+iKvpS0p11w9rQ0wzd0TcwrsSgppTr56hb/1GuVGk68UPiffOi6kiyIkIt2xcD70gtZjid3rn6e89GZmriJ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUAPZZKq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUAPZZKq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785080071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMtayxS3HoI/U18jirl1z/zCFg4c0op5NxlN9HZkjXo=;
	b=JUAPZZKqSm2rcv7aDmLav82/ErpQrrB5i1F73gw4zA+2sQs0o6P/PlorLqMrWWYq+RReTv
	1FzWK4Tz4mzG2Q29DHkzgd8OFk1RWGn9PkZj5PRRGZ08TUIvv4TpNUFZERoyBh5ozi5ynO
	X807s7WrpysQwiWEBdGjaRXIOyIWkI8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-qXvyhtP_PXC2gwPCMzBkGA-1; Sun,
 26 Jul 2026 11:34:29 -0400
X-MC-Unique: qXvyhtP_PXC2gwPCMzBkGA-1
X-Mimecast-MFC-AGG-ID: qXvyhtP_PXC2gwPCMzBkGA_1785080067
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FE001956070;
	Sun, 26 Jul 2026 15:34:27 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.32.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 420801800611;
	Sun, 26 Jul 2026 15:34:19 +0000 (UTC)
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
Subject: [RFC PATCH v7 10/18] target/arm/kvm: Retrieve writable ID reg map
Date: Sun, 26 Jul 2026 17:29:48 +0200
Message-ID: <20260726153221.24773-11-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-1-eric.auger@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: FR2_mHHMbk6Hsf6HVNKSV3bidTJfgw-p0q6-WhOC9dU_1785080067
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
index d40a6a9859..d270f9870e 100644
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

