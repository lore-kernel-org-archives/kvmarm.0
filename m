Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E02211A0D
	for <kvmarm@lists.linux.dev>; Thu, 15 May 2025 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747323593; cv=none; b=kwbUBPcGe3Yd2Kn/QwxtgMfGtU7+d/sZ7SO1yJSUZmPqBbPyr+6qvNaWEBr/g7p5j0cyL0FjtaarsJS1h8Mc+LxTx84DQ5RBqGmVEWWhKeoGIqRjf0Wy8IkbhAJGs0elzfnl9OGqxFOqz5AQy7aO/y2bAJuZ/myd1rLbhFO6W+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747323593; c=relaxed/simple;
	bh=wmwgWWmtKi1ewfN30qGJc24Zd2WFLvrkxfeBpXI8JTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=qYZ8Tgh/WC+5z4rh8kC1gIfMb/aP4/D6gtAjgE9m6+JM1wa0NOISgV7a3Jrxs1OwxraT9PPPB3p02E1SLEXNpaXH5sMX2wXiCAlCoRsXXxwtAgqnFleheRACvZt3j1/DfR4c9B2g4KWP1IRLQXzBmMfoAiHviyOgANvtS62eLsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XsjbUMZ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XsjbUMZ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747323589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dCvOte01jBdR3U6brSj2KqXv+1N4aEGmoe6q0LUd2w=;
	b=XsjbUMZ4kCDdVvFY2YKSVuqdI04X6rQ8sAX6ewtlAXUOyr1rzzDy9ddQ7KHS++toMHOdXT
	VwTglmuE31gtLO+8wUQU5kwtFdWnbZ07yy92CbGmOIJ0QElrUAN8tZkP50k6HtgmqqzoCg
	XcjirnsvjZhyihEjxVGq1UETG9FVzco=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-y-jtZUgGOj2-97Y-Snfy2Q-1; Thu,
 15 May 2025 11:39:46 -0400
X-MC-Unique: y-jtZUgGOj2-97Y-Snfy2Q-1
X-Mimecast-MFC-AGG-ID: y-jtZUgGOj2-97Y-Snfy2Q_1747323583
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A511D1800374;
	Thu, 15 May 2025 15:39:43 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.45.225.145])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7EB971955F21;
	Thu, 15 May 2025 15:39:37 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com,
	agraf@csgraf.de
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v7 03/14] arm/cpu: Store aa64isar1/2 into the idregs array
Date: Thu, 15 May 2025 17:38:56 +0200
Message-ID: <20250515153907.151174-4-cohuck@redhat.com>
In-Reply-To: <20250515153907.151174-1-cohuck@redhat.com>
References: <20250515153907.151174-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-features.h | 44 +++++++++++++++++++--------------------
 target/arm/cpu.c          | 13 ++++--------
 target/arm/cpu.h          |  2 --
 target/arm/cpu64.c        |  9 ++++----
 target/arm/helper.c       |  4 ++--
 target/arm/hvf/hvf.c      |  2 +-
 target/arm/kvm.c          |  6 ++----
 target/arm/tcg/cpu64.c    | 24 ++++++++++-----------
 8 files changed, 48 insertions(+), 56 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 779bcd1abb36..37946d759375 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -467,17 +467,17 @@ static inline bool isar_feature_aa64_tlbios(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa64_jscvt(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, JSCVT) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, JSCVT) != 0;
 }
 
 static inline bool isar_feature_aa64_fcma(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, FCMA) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, FCMA) != 0;
 }
 
 static inline bool isar_feature_aa64_xs(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, XS) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, XS) != 0;
 }
 
 /*
@@ -501,9 +501,9 @@ isar_feature_pauth_feature(const ARMISARegisters *id)
      * Architecturally, only one of {APA,API,APA3} may be active (non-zero)
      * and the other two must be zero.  Thus we may avoid conditionals.
      */
-    return (FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, APA) |
-            FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, API) |
-            FIELD_EX64(id->id_aa64isar2, ID_AA64ISAR2, APA3));
+    return (FIELD_EX64_IDREG(id, ID_AA64ISAR1, APA) |
+            FIELD_EX64_IDREG(id, ID_AA64ISAR1, API) |
+            FIELD_EX64_IDREG(id, ID_AA64ISAR2, APA3));
 }
 
 static inline bool isar_feature_aa64_pauth(const ARMISARegisters *id)
@@ -521,7 +521,7 @@ static inline bool isar_feature_aa64_pauth_qarma5(const ARMISARegisters *id)
      * Return true if pauth is enabled with the architected QARMA5 algorithm.
      * QEMU will always enable or disable both APA and GPA.
      */
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, APA) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, APA) != 0;
 }
 
 static inline bool isar_feature_aa64_pauth_qarma3(const ARMISARegisters *id)
@@ -530,77 +530,77 @@ static inline bool isar_feature_aa64_pauth_qarma3(const ARMISARegisters *id)
      * Return true if pauth is enabled with the architected QARMA3 algorithm.
      * QEMU will always enable or disable both APA3 and GPA3.
      */
-    return FIELD_EX64(id->id_aa64isar2, ID_AA64ISAR2, APA3) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR2, APA3) != 0;
 }
 
 static inline bool isar_feature_aa64_sb(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, SB) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, SB) != 0;
 }
 
 static inline bool isar_feature_aa64_predinv(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, SPECRES) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, SPECRES) != 0;
 }
 
 static inline bool isar_feature_aa64_frint(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, FRINTTS) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, FRINTTS) != 0;
 }
 
 static inline bool isar_feature_aa64_dcpop(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, DPB) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, DPB) != 0;
 }
 
 static inline bool isar_feature_aa64_dcpodp(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, DPB) >= 2;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, DPB) >= 2;
 }
 
 static inline bool isar_feature_aa64_bf16(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, BF16) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, BF16) != 0;
 }
 
 static inline bool isar_feature_aa64_ebf16(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, BF16) > 1;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, BF16) > 1;
 }
 
 static inline bool isar_feature_aa64_rcpc_8_3(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, LRCPC) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, LRCPC) != 0;
 }
 
 static inline bool isar_feature_aa64_rcpc_8_4(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, LRCPC) >= 2;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, LRCPC) >= 2;
 }
 
 static inline bool isar_feature_aa64_i8mm(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar1, ID_AA64ISAR1, I8MM) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR1, I8MM) != 0;
 }
 
 static inline bool isar_feature_aa64_wfxt(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar2, ID_AA64ISAR2, WFXT) >= 2;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR2, WFXT) >= 2;
 }
 
 static inline bool isar_feature_aa64_hbc(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar2, ID_AA64ISAR2, BC) != 0;
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR2, BC) != 0;
 }
 
 static inline bool isar_feature_aa64_mops(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar2, ID_AA64ISAR2, MOPS);
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR2, MOPS);
 }
 
 static inline bool isar_feature_aa64_rpres(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar2, ID_AA64ISAR2, RPRES);
+    return FIELD_EX64_IDREG(id, ID_AA64ISAR2, RPRES);
 }
 
 static inline bool isar_feature_aa64_fp_simd(const ARMISARegisters *id)
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index a13688503c98..a93f39d80c8a 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2130,9 +2130,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         uint64_t t;
         uint32_t u;
 
-        t = cpu->isar.id_aa64isar1;
-        t = FIELD_DP64(t, ID_AA64ISAR1, JSCVT, 0);
-        cpu->isar.id_aa64isar1 = t;
+        FIELD_DP64_IDREG(isar, ID_AA64ISAR1, JSCVT, 0);
 
         t = cpu->isar.id_aa64pfr0;
         t = FIELD_DP64(t, ID_AA64PFR0, FP, 0xf);
@@ -2185,11 +2183,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         t = FIELD_DP64(t, ID_AA64ISAR0, DP, 0);
         SET_IDREG(isar, ID_AA64ISAR0, t);
 
-        t = cpu->isar.id_aa64isar1;
+        t = GET_IDREG(isar, ID_AA64ISAR1);
         t = FIELD_DP64(t, ID_AA64ISAR1, FCMA, 0);
         t = FIELD_DP64(t, ID_AA64ISAR1, BF16, 0);
         t = FIELD_DP64(t, ID_AA64ISAR1, I8MM, 0);
-        cpu->isar.id_aa64isar1 = t;
+        SET_IDREG(isar, ID_AA64ISAR1, t);
 
         t = cpu->isar.id_aa64pfr0;
         t = FIELD_DP64(t, ID_AA64PFR0, ADVSIMD, 0xf);
@@ -2225,14 +2223,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 
     if (!cpu->has_neon && !cpu->has_vfp) {
-        unit64_t t;
         uint32_t u;
 
         FIELD_DP64_IDREG(isar, ID_AA64ISAR0, FHM, 0);
 
-        t = cpu->isar.id_aa64isar1;
-        t = FIELD_DP64(t, ID_AA64ISAR1, FRINTTS, 0);
-        cpu->isar.id_aa64isar1 = t;
+        FIELD_DP64_IDREG(isar, ID_AA64ISAR1, FRINTTS, 0);
 
         u = cpu->isar.mvfr0;
         u = FIELD_DP32(u, MVFR0, SIMDREG, 0);
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 8b99eebb9ea3..211291a5b25d 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1074,8 +1074,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64isar1;
-        uint64_t id_aa64isar2;
         uint64_t id_aa64pfr0;
         uint64_t id_aa64pfr1;
         uint64_t id_aa64mmfr0;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 266f7434556c..7077c104dad1 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -502,6 +502,7 @@ void aarch64_add_sme_properties(Object *obj)
 void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
 {
     ARMPauthFeature features = cpu_isar_feature(pauth_feature, cpu);
+    ARMISARegisters *isar = &cpu->isar;
     uint64_t isar1, isar2;
 
     /*
@@ -512,13 +513,13 @@ void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
      *
      * Begin by disabling all fields.
      */
-    isar1 = cpu->isar.id_aa64isar1;
+    isar1 = GET_IDREG(isar, ID_AA64ISAR1);
     isar1 = FIELD_DP64(isar1, ID_AA64ISAR1, APA, 0);
     isar1 = FIELD_DP64(isar1, ID_AA64ISAR1, GPA, 0);
     isar1 = FIELD_DP64(isar1, ID_AA64ISAR1, API, 0);
     isar1 = FIELD_DP64(isar1, ID_AA64ISAR1, GPI, 0);
 
-    isar2 = cpu->isar.id_aa64isar2;
+    isar2 = GET_IDREG(isar, ID_AA64ISAR2);
     isar2 = FIELD_DP64(isar2, ID_AA64ISAR2, APA3, 0);
     isar2 = FIELD_DP64(isar2, ID_AA64ISAR2, GPA3, 0);
 
@@ -580,8 +581,8 @@ void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
         }
     }
 
-    cpu->isar.id_aa64isar1 = isar1;
-    cpu->isar.id_aa64isar2 = isar2;
+    SET_IDREG(isar, ID_AA64ISAR1, isar1);
+    SET_IDREG(isar, ID_AA64ISAR2, isar2);
 }
 
 static const Property arm_cpu_pauth_property =
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 46df3cb64df4..4f6f7cc621c7 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -8010,12 +8010,12 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 6, .opc2 = 1,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64isar1 },
+              .resetvalue = GET_IDREG(isar, ID_AA64ISAR1)},
             { .name = "ID_AA64ISAR2_EL1", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 6, .opc2 = 2,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64isar2 },
+              .resetvalue = GET_IDREG(isar, ID_AA64ISAR2)},
             { .name = "ID_AA64ISAR3_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 6, .opc2 = 3,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 5d25260c5c36..7554282410f1 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -868,7 +868,7 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         { HV_SYS_REG_ID_AA64DFR0_EL1, &host_isar.id_aa64dfr0 },
         { HV_SYS_REG_ID_AA64DFR1_EL1, &host_isar.id_aa64dfr1 },
         { HV_SYS_REG_ID_AA64ISAR0_EL1, &host_isar.idregs[ID_AA64ISAR0_EL1_IDX] },
-        { HV_SYS_REG_ID_AA64ISAR1_EL1, &host_isar.id_aa64isar1 },
+        { HV_SYS_REG_ID_AA64ISAR1_EL1, &host_isar.idregs[ID_AA64ISAR1_EL1_IDX] },
         /* Add ID_AA64ISAR2_EL1 here when HVF supports it */
         { HV_SYS_REG_ID_AA64MMFR0_EL1, &host_isar.id_aa64mmfr0 },
         { HV_SYS_REG_ID_AA64MMFR1_EL1, &host_isar.id_aa64mmfr1 },
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 219087052835..1f364a6260a9 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -323,10 +323,8 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr1,
                               ARM64_SYS_REG(3, 0, 0, 5, 1));
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR0_EL1_IDX);
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar1,
-                              ARM64_SYS_REG(3, 0, 0, 6, 1));
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar2,
-                              ARM64_SYS_REG(3, 0, 0, 6, 2));
+        err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR1_EL1_IDX);
+        err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR2_EL1_IDX);
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64mmfr0,
                               ARM64_SYS_REG(3, 0, 0, 7, 0));
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64mmfr1,
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index f31bb9ceaac9..f62e62595d8b 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -68,7 +68,7 @@ static void aarch64_a35_initfn(Object *obj)
     cpu->isar.id_aa64dfr0 = 0x10305106;
     cpu->isar.id_aa64dfr1 = 0;
     SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
-    cpu->isar.id_aa64isar1 = 0;
+    SET_IDREG(isar, ID_AA64ISAR1, 0);
     cpu->isar.id_aa64mmfr0 = 0x00101122;
     cpu->isar.id_aa64mmfr1 = 0;
     cpu->clidr = 0x0a200023;
@@ -224,7 +224,7 @@ static void aarch64_a55_initfn(Object *obj)
     cpu->dcz_blocksize = 4; /* 64 bytes */
     cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
     SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
-    cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
+    SET_IDREG(isar, ID_AA64ISAR1, 0x0000000000100001ull);
     cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
@@ -357,7 +357,7 @@ static void aarch64_a76_initfn(Object *obj)
     cpu->dcz_blocksize = 4;
     cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
     SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
-    cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
+    SET_IDREG(isar, ID_AA64ISAR1, 0x0000000000100001ull);
     cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
@@ -437,7 +437,7 @@ static void aarch64_a64fx_initfn(Object *obj)
     cpu->isar.id_aa64mmfr1 = 0x0000000011212100;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011;
     SET_IDREG(isar, ID_AA64ISAR0, 0x0000000010211120);
-    cpu->isar.id_aa64isar1 = 0x0000000000010001;
+    SET_IDREG(isar, ID_AA64ISAR1, 0x0000000000010001);
     SET_IDREG(isar, ID_AA64ZFR0, 0x0000000000000000);
     cpu->clidr = 0x0000000080000023;
     /* 64KB L1 dcache */
@@ -605,7 +605,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     cpu->dcz_blocksize = 4;
     cpu->isar.id_aa64dfr0  = 0x0000000110305408ull;
     SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
-    cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
+    SET_IDREG(isar, ID_AA64ISAR1, 0x0000000000100001ull);
     cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
@@ -684,7 +684,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     cpu->isar.id_aa64dfr0  = 0x000001f210305519ull;
     cpu->isar.id_aa64dfr1 = 0x00000000;
     SET_IDREG(isar, ID_AA64ISAR0, 0x1011111110212120ull); /* with FEAT_RNG */
-    cpu->isar.id_aa64isar1 = 0x0011100001211032ull;
+    SET_IDREG(isar, ID_AA64ISAR1, 0x0011000001211032ull);
     cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0220011102101011ull;
@@ -933,7 +933,7 @@ static void aarch64_a710_initfn(Object *obj)
     cpu->id_aa64afr0       = 0;
     cpu->id_aa64afr1       = 0;
     SET_IDREG(isar, ID_AA64ISAR0, 0x0221111110212120ull); /* with Crypto */
-    cpu->isar.id_aa64isar1 = 0x0010111101211052ull;
+    SET_IDREG(isar, ID_AA64ISAR1, 0x0010111101211052ull);
     cpu->isar.id_aa64mmfr0 = 0x0000022200101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x1221011110101011ull;
@@ -1035,7 +1035,7 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     cpu->id_aa64afr0       = 0;
     cpu->id_aa64afr1       = 0;
     SET_IDREG(isar, ID_AA64ISAR0, 0x1221111110212120ull); /* with Crypto and FEAT_RNG */
-    cpu->isar.id_aa64isar1 = 0x0011111101211052ull;
+    SET_IDREG(isar, ID_AA64ISAR1, 0x0011111101211052ull);
     cpu->isar.id_aa64mmfr0 = 0x0000022200101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x1221011112101011ull;
@@ -1160,7 +1160,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64ISAR0, RNDR, 1);     /* FEAT_RNG */
     SET_IDREG(isar, ID_AA64ISAR0, t);
 
-    t = cpu->isar.id_aa64isar1;
+    t = GET_IDREG(isar, ID_AA64ISAR1);
     t = FIELD_DP64(t, ID_AA64ISAR1, DPB, 2);      /* FEAT_DPB2 */
     t = FIELD_DP64(t, ID_AA64ISAR1, APA, PauthFeat_FPACCOMBINED);
     t = FIELD_DP64(t, ID_AA64ISAR1, API, 1);
@@ -1174,14 +1174,14 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64ISAR1, DGH, 1);      /* FEAT_DGH */
     t = FIELD_DP64(t, ID_AA64ISAR1, I8MM, 1);     /* FEAT_I8MM */
     t = FIELD_DP64(t, ID_AA64ISAR1, XS, 1);       /* FEAT_XS */
-    cpu->isar.id_aa64isar1 = t;
+    SET_IDREG(isar, ID_AA64ISAR1, t);
 
-    t = cpu->isar.id_aa64isar2;
+    t = GET_IDREG(isar, ID_AA64ISAR2);
     t = FIELD_DP64(t, ID_AA64ISAR2, RPRES, 1);    /* FEAT_RPRES */
     t = FIELD_DP64(t, ID_AA64ISAR2, MOPS, 1);     /* FEAT_MOPS */
     t = FIELD_DP64(t, ID_AA64ISAR2, BC, 1);       /* FEAT_HBC */
     t = FIELD_DP64(t, ID_AA64ISAR2, WFXT, 2);     /* FEAT_WFxT */
-    cpu->isar.id_aa64isar2 = t;
+    SET_IDREG(isar, ID_AA64ISAR2, t);
 
     t = cpu->isar.id_aa64pfr0;
     t = FIELD_DP64(t, ID_AA64PFR0, FP, 1);        /* FEAT_FP16 */
-- 
2.49.0

