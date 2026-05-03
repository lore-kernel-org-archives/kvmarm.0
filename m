Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108781A5B90
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793806; cv=none; b=cIuNmB08bL9fxxRbCtORq6qhnoKZDI1obhzOCLWLF4AdUAaOWPGdK3ztX6N2M9VqS26TI7bM601ZbaQ0gLsxJT71sWkiGQX1LQupz0nXsMgEhvqx/0fnhIyNHsrO3sC9c/Eb6UVDbp6vrHRGZDy65bKjnd1N9K3/YWt5mQJpv8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793806; c=relaxed/simple;
	bh=fGb3uAgIU71fsrPxvMq+L8to+4cIgH/sFGkk+AX8tYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mmm5HKg7Waa7afe9so2weGlNro6VQT7lXh8ZwqgisvD+Bb0qsaOFIA1RL+qQZBvhJ+g4yIf70eqw7RXRjkeY/5ib9RDcOkC9yRczt2L9aym22khkMRLmqSMbV0TQzvbwv3clpUoIC0GCuGy9HcbFGGFqDGWnumEWPfmB67aCzNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TjIzqVem; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TjIzqVem"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77NAFC9fvHH4KulMWuGgQJVhBzZTjO4Ty/rdASI/oC4=;
	b=TjIzqVemcfmsVamdBOpas/2QRp1RlqayetyV1gmLX0+L3p4qZKhtxiEffrj+gNlsT1qd5g
	wJJy9NNeKmaTV4DaU0nhwUHfq00X3upgRmMhMoDjL4cLmNXUYTrSfYYV6tvIrbIGUBIN1c
	+ivq/AGSWHKEETwFvZ493R3vJAhXN+E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-379-WAZhjYBdNre3ZkAMx--iMw-1; Sun,
 03 May 2026 03:36:40 -0400
X-MC-Unique: WAZhjYBdNre3ZkAMx--iMw-1
X-Mimecast-MFC-AGG-ID: WAZhjYBdNre3ZkAMx--iMw_1777793799
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 370FE195608B;
	Sun,  3 May 2026 07:36:39 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 552051800480;
	Sun,  3 May 2026 07:36:34 +0000 (UTC)
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
Subject: [PATCH v4 08/17] target/arm/kvm: Introduce kvm_get_writable_id_regs
Date: Sun,  3 May 2026 09:33:28 +0200
Message-ID: <20260503073541.790215-9-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: S8vMwqsZOHDyQh0ne7pF4v_g13Ix7ZV4dYiHM4k712A_1777793799
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Add an helper to retrieve the writable id reg bitmask. The
status of the query is stored in the CPU struct so that an
an error, if any, can be reported on vcpu realize().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu.h     | 26 ++++++++++++++++++++++++++
 target/arm/kvm.c     | 32 ++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h |  3 +++
 3 files changed, 61 insertions(+)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index be14a47c35..2aa22360d2 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -866,6 +866,26 @@ typedef struct {
     uint32_t map, init, supported;
 } ARMVQMap;
 
+typedef enum ARMIdRegsState {
+    WRITABLE_ID_REGS_UNKNOWN,
+    WRITABLE_ID_REGS_NOT_DISCOVERABLE,
+    WRITABLE_ID_REGS_FAILED,
+    WRITABLE_ID_REGS_AVAIL,
+} ARMIdRegsState;
+
+/*
+ * The following structures are for the purpose of mapping the output of
+ * KVM_ARM_GET_REG_WRITABLE_MASKS that also may cover id registers we do
+ * not support in QEMU
+ * ID registers in op0==3, op1=={0,1,3}, crn=0, crm=={0-7}, op2=={0-7},
+ * as used by the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl call.
+ */
+#define NR_ID_REG_MASKS (3 * 8 * 8)
+
+typedef struct IdRegMap {
+    uint64_t regs[NR_ID_REG_MASKS]; /* writable masks for registers */
+} IdRegMap;
+
 /* REG is ID_XXX */
 #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
     ({                                                                  \
@@ -1054,6 +1074,12 @@ struct ArchCPU {
      */
     bool host_cpu_probe_failed;
 
+    /*
+     * state of writable id regs query used to report an error, if any,
+     * on vcpu model realize
+     */
+    ARMIdRegsState writable_id_regs_status;
+
     /* QOM property to indicate we should use the back-compat CNTFRQ default */
     bool backcompat_cntfrq;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index d4a68874b8..f06a60804d 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -51,6 +51,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
 static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
 static bool cap_has_inject_ext_dabt;
+static int cap_writable_id_regs;
 
 /**
  * ARMHostCPUFeatures: information about the host CPU (identified
@@ -499,6 +500,37 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     env->features = arm_host_cpu_features.features;
 }
 
+int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
+{
+    struct reg_mask_range range = {
+        .range = 0, /* up to now only a single range is supported */
+        .addr = (uint64_t)idregmap,
+    };
+    int ret;
+
+    if (!kvm_enabled()) {
+        cpu->writable_id_regs_status = WRITABLE_ID_REGS_NOT_DISCOVERABLE;
+        return -ENOSYS;
+    }
+
+    cap_writable_id_regs =
+        kvm_check_extension(kvm_state, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
+
+    if (!cap_writable_id_regs ||
+        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
+        cpu->writable_id_regs_status = WRITABLE_ID_REGS_NOT_DISCOVERABLE;
+        return -ENOSYS;
+    }
+
+    ret = kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+    if (ret) {
+        cpu->writable_id_regs_status = WRITABLE_ID_REGS_FAILED;
+        return ret;
+     }
+    cpu->writable_id_regs_status = WRITABLE_ID_REGS_AVAIL;
+    return ret;
+}
+
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
 {
     return !ARM_CPU(obj)->kvm_adjvtime;
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index e7c40fb003..b22a56fc17 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -240,4 +240,7 @@ void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
  */
 char *kvm_print_register_name(uint64_t regidx);
 
+typedef struct IdRegMap IdRegMap;
+int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap);
+
 #endif
-- 
2.53.0

