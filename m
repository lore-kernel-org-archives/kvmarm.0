Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28A5348883
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737211; cv=none; b=qwXYlSDVvJhuz5n6LgZR317v3BG9h/e2k7fPT7Yf1MM5OG9MoLfOrEaON7Sl6SKhDXm1X+O8ZXBwI+RYp+/WJ3axMZodPMHlSA6HGuObd1Blu7rd/HZtrnPG1THd0juz3OI6wtETH58/TP/7LG6aeuuLs8VB4TTEHQ0odNNnotc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737211; c=relaxed/simple;
	bh=92iAccBk8vi6bjzQaUNSrfUGH82OYPpL/g4FByOgJtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=JWJDq2kO3xc3A8MIZr8Sc0G0wwumPYdUK22yhwo9GDDtG9wpzZWqXxIz6jbSGe0Pc4qsCzAazLknnVKqd4cnpWLdSphetHFU2O0hi72BKEN8LYvs+bd2/9omNeASrXbIMx3NUR37ptB8Vq0ILFYtNkcIYeL4CCFlMf5hBM0uOEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rx9ZusC+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rx9ZusC+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thVhsqNL9iKV5PmyTzrsPdYxHj4EB7lOTqW8c/AzHWI=;
	b=Rx9ZusC+g12G4Xf8jmpo3insu56C/lohe3/lL5ZIZ1wEzGWZKIEVztfgzTjE+3ykuv3oLD
	o8YHNgGHpRyXHvsYQbsYr5GtZOok8cXTHVlluDcQYkfeuFBzabH5O/XMDttyHBpA26FTia
	blexBQ8I/Sb1pU54wgBjOf9PnhjklWg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-pkAGeq_1OcKHgt55gTy6VQ-1; Wed,
 26 Aug 2026 05:40:05 -0400
X-MC-Unique: pkAGeq_1OcKHgt55gTy6VQ-1
X-Mimecast-MFC-AGG-ID: pkAGeq_1OcKHgt55gTy6VQ_1787737202
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2010A1954227;
	Wed, 26 Aug 2026 09:40:02 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 556DC1955F05;
	Wed, 26 Aug 2026 09:39:56 +0000 (UTC)
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
Subject: [RFC PATCH v8 19/20] kvm: Introduce kvm_arm_create_scratch_max_host_vcpu
Date: Wed, 26 Aug 2026 11:36:24 +0200
Message-ID: <20260826093747.1670077-20-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: -NWQBPJFRdB8GSKoyroklLp_vQbE_eUXlpz0oasSaWo_1787737202
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This helper calls kvm_arm_create_scratch_host_vcpu() with preferred
target and kvm_vcpu_init.features[0] set with SVE, EL2, PMUv3 and PAUTH
if the associated feature caps are advertised by KVM.

The new helper gets used in kvm_arm_get_host_cpu_features for now.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm_arm.h  |  20 ++++++++
 target/arm/kvm-stub.c |   7 +++
 target/arm/kvm.c      | 108 +++++++++++++++++++++++-------------------
 3 files changed, 86 insertions(+), 49 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index d049334d6d..aafb3cd232 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -125,6 +125,26 @@ bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
  */
 void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
 
+/**
+ * kvm_arm_create_scratch_max_host_vcpu:
+ * @fdarray: filled in with kvmfd, vmfd, cpufd file descriptors in that order
+ * @init_features0: kvm_vcpu_init.features[0] feature flags used during
+ *                  the init
+ * @target: target eventually chosen
+ * @errp: Error handle
+ *
+ * calls kvm_arm_create_scratch_host_vcpu() with kvm_vcpu_init initialized
+ * with all max kvm capabilities supported by the platform among
+ * KVM_CAP_ARM_PMU_V3, KVM_CAP_ARM_SVE, KVM_CAP_ARM_PTRAUTH_ADDRESS,
+ * KVM_CAP_ARM_PTRAUTH_GENERIC, KVM_CAP_ARM_EL2
+ *
+ * Returns: true on success (and fdarray and init are filled in),
+ * false on failure (and fdarray and init are not valid).
+ */
+bool kvm_arm_create_scratch_max_host_vcpu(int *fdarray,
+                                          uint32_t *init_features0,
+                                          uint32_t *target, Error **errp);
+
 /**
  * kvm_arm_set_cpu_features_from_host:
  * @cpu: ARMCPU to set the features for
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 264938d2c5..0d6c841a24 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -125,3 +125,10 @@ bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
 {
     g_assert_not_reached();
 }
+
+bool kvm_arm_create_scratch_max_host_vcpu(int *fdarray,
+                                          uint32_t *init_features0,
+                                          uint32_t *target, Error **errp)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8a7f5982fb..e3a0dc07de 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -200,6 +200,46 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray)
     }
 }
 
+static bool kvm_arm_pauth_supported(void)
+{
+    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
+}
+
+bool kvm_arm_create_scratch_max_host_vcpu(int *fdarray,
+                                          uint32_t *init_features,
+                                          uint32_t *target, Error **errp)
+{
+    struct kvm_vcpu_init init = { .target = -1, };
+    bool ret;
+
+    if (!kvm_enabled()) {
+        return false;
+    }
+
+    if (kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE)) {
+        init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
+    }
+    if (kvm_arm_el2_supported()) {
+        init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
+    }
+    if (kvm_arm_pauth_supported()) {
+        init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+                         1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+    }
+    if (kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3)) {
+        init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
+    }
+
+    ret = kvm_arm_create_scratch_host_vcpu(fdarray, &init, errp);
+
+    if (ret) {
+        *init_features = init.features[0];
+        *target = init.target;
+    }
+    return ret;
+}
+
 static int read_sys_reg32(int fd, uint32_t *pret, uint64_t id)
 {
     uint64_t ret;
@@ -223,13 +263,6 @@ static int read_sys_reg64(int fd, uint64_t *pret, uint64_t id)
     return ioctl(fd, KVM_GET_ONE_REG, &idreg);
 }
 
-static bool kvm_arm_pauth_supported(void)
-{
-    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
-            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
-}
-
-
 static uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
 {
     return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
@@ -543,11 +576,11 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
      * and then query that CPU for the relevant ID registers.
      */
     int fdarray[3];
-    bool sve_supported;
-    bool el2_supported;
-    bool pmu_supported = false;
+    bool sve_supported, pmu_supported;
+    uint32_t init_features0 = 0;
     uint64_t features = 0;
     Error *local_err = NULL;
+    uint32_t target;
     int err;
 
     ahcf->target = QEMU_KVM_ARM_TARGET_NONE;
@@ -558,48 +591,25 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     }
 
     /*
-     * target = -1 informs kvm_arm_create_scratch_host_vcpu()
-     * to use the preferred target
+     * Instantiate a scratch vcpu of preferred target with the following
+     * features, if advertised by KVM:
+     * SVE (so that ID_AA64ZFR0 can be queried, otherwise RAS), PMUv3, EL2,
+     * PAUTH (to get the unsanitized field values for AA64ISAR1_EL1)
      */
-    struct kvm_vcpu_init init = { .target = -1, };
-
-    /*
-     * Ask for SVE if supported, so that we can query ID_AA64ZFR0,
-     * which is otherwise RAZ.
-     */
-    sve_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
-    if (sve_supported) {
-        init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
-    }
-
-    /*
-     * Ask for EL2 if supported.
-     */
-    el2_supported = kvm_arm_el2_supported();
-    if (el2_supported) {
-        init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
-    }
-
-    /*
-     * Ask for Pointer Authentication if supported, so that we get
-     * the unsanitized field values for AA64ISAR1_EL1.
-     */
-    if (kvm_arm_pauth_supported()) {
-        init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
-                             1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
-    }
-
-    if (kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3)) {
-        init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
-        pmu_supported = true;
-        features |= 1ULL << ARM_FEATURE_PMU;
-    }
-
-    if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init, &local_err)) {
+    if (!kvm_arm_create_scratch_max_host_vcpu(fdarray,
+                                              &init_features0, &target,
+                                              &local_err)) {
         error_report_err(local_err);
         return;
     }
 
+    pmu_supported = init_features0 & (1 << KVM_ARM_VCPU_PMU_V3);
+    sve_supported = init_features0 & (1 << KVM_ARM_VCPU_SVE);
+
+    if (pmu_supported) {
+        features |= 1ULL << ARM_FEATURE_PMU;
+    }
+
     int fd = fdarray[2];
 
     err = get_host_cpu_reg(fd, ahcf, ID_AA64PFR0_EL1_IDX);
@@ -746,11 +756,11 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     features |= 1ULL << ARM_FEATURE_AARCH64;
     features |= 1ULL << ARM_FEATURE_GENERIC_TIMER;
 
-    if (el2_supported) {
+    if (init_features0 & (1 << KVM_ARM_VCPU_HAS_EL2)) {
         features |= 1ULL << ARM_FEATURE_EL2;
     }
 
-    ahcf->target = init.target;
+    ahcf->target = target;
     ahcf->features = features;
 }
 
-- 
2.53.0

