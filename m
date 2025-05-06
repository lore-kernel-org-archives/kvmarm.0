Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E4A18C034
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 08:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746521620; cv=none; b=AozXGfXBjPCJQpA+ISt3tjEkO1M1s2Jyvw+06LhRYGj1kxu1DbxZRXV/qF1Ih0Ypd+nvfF4S10wIs+TaCxKzwtGFzuND/vTbWWygP6/RuxFzoz9S4FstyGCYc0y/q5RySz5BbDRug9Es2GNmiDYpP5d9z13fDPTomhAARnkw85o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746521620; c=relaxed/simple;
	bh=Sj4sjfcHVcNW+1HomZ0kQVwCnnK827l26GDS9Fl+OS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=mp/GUB8gmveUOvOFKzclMeOhaJBKnmx9jUj/YFoHW8PMUPSHlGfBWRIOgO4PRarbtPNPewzm0lI7HyTbqfFPQSQPTW4USZUB3UU19K/2TyS9c5NEYgL1j5aMcPPCrL4egJ1/Kcl/B/2dg5XPOJNCBv9i+c3tgE3LH/sm0eWHc2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fGUeGe2D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fGUeGe2D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746521617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LMQ9dVUXhVwe9Le/uXjVBex6qaRF+GZi2jeOpnW6gNM=;
	b=fGUeGe2D4CMhIyiknHf95DVVPxFxrytL66gQ72jygMJFtbcCGfyvzfwVTlqaN1j1ypU+Rx
	7Dd2jlPM2FVmi+KDf0pEJvx9bbQVOYU9xb7iHEmXWorAAz28/ntq1fKawVg3wM6lSre5Fq
	Z0u4fr1iB22hBBf42gL/AYLj48vrDWE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-356-9e4TUfwQP_e23jZAyMOUHg-1; Tue,
 06 May 2025 04:53:33 -0400
X-MC-Unique: 9e4TUfwQP_e23jZAyMOUHg-1
X-Mimecast-MFC-AGG-ID: 9e4TUfwQP_e23jZAyMOUHg_1746521611
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34EB81955D6E;
	Tue,  6 May 2025 08:53:31 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-216.str.redhat.com [10.33.192.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A09621956094;
	Tue,  6 May 2025 08:53:25 +0000 (UTC)
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
Subject: [PATCH v6 06/14] arm/cpu: Store aa64dfr0/1 into the idregs array
Date: Tue,  6 May 2025 10:52:26 +0200
Message-ID: <20250506085234.855779-7-cohuck@redhat.com>
In-Reply-To: <20250506085234.855779-1-cohuck@redhat.com>
References: <20250506085234.855779-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-features.h | 16 ++++++++--------
 target/arm/cpu.c          | 15 +++++----------
 target/arm/cpu.h          |  2 --
 target/arm/cpu64.c        |  4 ++--
 target/arm/helper.c       |  4 ++--
 target/arm/hvf/hvf.c      |  4 ++--
 target/arm/internals.h    |  6 +++---
 target/arm/kvm.c          | 12 +++++-------
 target/arm/tcg/cpu64.c    | 32 ++++++++++++++++----------------
 9 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 36c35f6a434a..7f6331ca437d 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -900,30 +900,30 @@ static inline bool isar_feature_aa64_nv2(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa64_pmuv3p1(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64dfr0, ID_AA64DFR0, PMUVER) >= 4 &&
-        FIELD_EX64(id->id_aa64dfr0, ID_AA64DFR0, PMUVER) != 0xf;
+    return FIELD_EX64_IDREG(id, ID_AA64DFR0, PMUVER) >= 4 &&
+        FIELD_EX64_IDREG(id, ID_AA64DFR0, PMUVER) != 0xf;
 }
 
 static inline bool isar_feature_aa64_pmuv3p4(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64dfr0, ID_AA64DFR0, PMUVER) >= 5 &&
-        FIELD_EX64(id->id_aa64dfr0, ID_AA64DFR0, PMUVER) != 0xf;
+    return FIELD_EX64_IDREG(id, ID_AA64DFR0, PMUVER) >= 5 &&
+        FIELD_EX64_IDREG(id, ID_AA64DFR0, PMUVER) != 0xf;
 }
 
 static inline bool isar_feature_aa64_pmuv3p5(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64dfr0, ID_AA64DFR0, PMUVER) >= 6 &&
-        FIELD_EX64(id->id_aa64dfr0, ID_AA64DFR0, PMUVER) != 0xf;
+    return FIELD_EX64_IDREG(id, ID_AA64DFR0, PMUVER) >= 6 &&
+        FIELD_EX64_IDREG(id, ID_AA64DFR0, PMUVER) != 0xf;
 }
 
 static inline bool isar_feature_aa64_debugv8p2(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64dfr0, ID_AA64DFR0, DEBUGVER) >= 8;
+    return FIELD_EX64_IDREG(id, ID_AA64DFR0, DEBUGVER) >= 8;
 }
 
 static inline bool isar_feature_aa64_doublelock(const ARMISARegisters *id)
 {
-    return FIELD_SEX64(id->id_aa64dfr0, ID_AA64DFR0, DOUBLELOCK) >= 0;
+    return FIELD_SEX64_IDREG(id, ID_AA64DFR0, DOUBLELOCK) >= 0;
 }
 
 static inline bool isar_feature_aa64_sve2(const ARMISARegisters *id)
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 3313a47eab2a..2622f8748199 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2355,8 +2355,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
                 cpu);
 #endif
     } else {
-        cpu->isar.id_aa64dfr0 =
-            FIELD_DP64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, PMUVER, 0);
+        FIELD_DP64_IDREG(isar, ID_AA64DFR0, PMUVER, 0);
         cpu->isar.id_dfr0 = FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, PERFMON, 0);
         cpu->pmceid0 = 0;
         cpu->pmceid1 = 0;
@@ -2416,19 +2415,15 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          * try to access the non-existent system registers for them.
          */
         /* FEAT_SPE (Statistical Profiling Extension) */
-        cpu->isar.id_aa64dfr0 =
-            FIELD_DP64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, PMSVER, 0);
+        FIELD_DP64_IDREG(isar, ID_AA64DFR0, PMSVER, 0);
         /* FEAT_TRBE (Trace Buffer Extension) */
-        cpu->isar.id_aa64dfr0 =
-            FIELD_DP64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, TRACEBUFFER, 0);
+        FIELD_DP64_IDREG(isar, ID_AA64DFR0, TRACEBUFFER, 0);
         /* FEAT_TRF (Self-hosted Trace Extension) */
-        cpu->isar.id_aa64dfr0 =
-            FIELD_DP64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, TRACEFILT, 0);
+        FIELD_DP64_IDREG(isar, ID_AA64DFR0, TRACEFILT, 0);
         cpu->isar.id_dfr0 =
             FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, TRACEFILT, 0);
         /* Trace Macrocell system register access */
-        cpu->isar.id_aa64dfr0 =
-            FIELD_DP64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, TRACEVER, 0);
+        FIELD_DP64_IDREG(isar, ID_AA64DFR0, TRACEVER, 0);
         cpu->isar.id_dfr0 =
             FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, COPTRC, 0);
         /* Memory mapped trace */
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 6f7b9d6f20f9..dc57a2e4ef19 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1077,8 +1077,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64dfr0;
-        uint64_t id_aa64dfr1;
         uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
         uint64_t idregs[NUM_ID_IDX];
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 3258e5b639ed..45981dfcfbb3 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -671,7 +671,7 @@ static void aarch64_a57_initfn(Object *obj)
     cpu->isar.id_isar5 = 0x00011121;
     cpu->isar.id_isar6 = 0;
     SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
-    cpu->isar.id_aa64dfr0 = 0x10305106;
+    SET_IDREG(isar, ID_AA64DFR0, 0x10305106);
     SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
     SET_IDREG(isar, ID_AA64MMFR0, 0x00001124);
     cpu->isar.dbgdidr = 0x3516d000;
@@ -733,7 +733,7 @@ static void aarch64_a53_initfn(Object *obj)
     cpu->isar.id_isar5 = 0x00011121;
     cpu->isar.id_isar6 = 0;
     SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
-    cpu->isar.id_aa64dfr0 = 0x10305106;
+    SET_IDREG(isar, ID_AA64DFR0, 0x10305106);
     SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
     SET_IDREG(isar, ID_AA64MMFR0, 0x00001122); /* 40 bit physical addr */
     cpu->isar.dbgdidr = 0x3516d000;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 703b4fc3e300..173fdb47a3d3 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7965,12 +7965,12 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 5, .opc2 = 0,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64dfr0 },
+              .resetvalue = GET_IDREG(isar, ID_AA64DFR0) },
             { .name = "ID_AA64DFR1_EL1", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 5, .opc2 = 1,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64dfr1 },
+              .resetvalue = GET_IDREG(isar, ID_AA64DFR1) },
             { .name = "ID_AA64DFR2_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 5, .opc2 = 2,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index d6cf69ca5b2c..1a8bcc03d5aa 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -868,8 +868,8 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     } regs[] = {
         { HV_SYS_REG_ID_AA64PFR0_EL1, &host_isar.idregs[ID_AA64PFR0_EL1_IDX] },
         { HV_SYS_REG_ID_AA64PFR1_EL1, &host_isar.idregs[ID_AA64PFR1_EL1_IDX] },
-        { HV_SYS_REG_ID_AA64DFR0_EL1, &host_isar.id_aa64dfr0 },
-        { HV_SYS_REG_ID_AA64DFR1_EL1, &host_isar.id_aa64dfr1 },
+        { HV_SYS_REG_ID_AA64DFR0_EL1, &host_isar.idregs[ID_AA64DFR0_EL1_IDX] },
+        { HV_SYS_REG_ID_AA64DFR1_EL1, &host_isar.idregs[ID_AA64DFR1_EL1_IDX] },
         { HV_SYS_REG_ID_AA64ISAR0_EL1, &host_isar.idregs[ID_AA64ISAR0_EL1_IDX] },
         { HV_SYS_REG_ID_AA64ISAR1_EL1, &host_isar.idregs[ID_AA64ISAR1_EL1_IDX] },
         /* Add ID_AA64ISAR2_EL1 here when HVF supports it */
diff --git a/target/arm/internals.h b/target/arm/internals.h
index 4d3d84ffebd9..f8ceec7906d5 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -1174,7 +1174,7 @@ static inline bool regime_using_lpae_format(CPUARMState *env, ARMMMUIdx mmu_idx)
 static inline int arm_num_brps(ARMCPU *cpu)
 {
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
-        return FIELD_EX64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, BRPS) + 1;
+        return FIELD_EX64_IDREG(&cpu->isar, ID_AA64DFR0, BRPS) + 1;
     } else {
         return FIELD_EX32(cpu->isar.dbgdidr, DBGDIDR, BRPS) + 1;
     }
@@ -1188,7 +1188,7 @@ static inline int arm_num_brps(ARMCPU *cpu)
 static inline int arm_num_wrps(ARMCPU *cpu)
 {
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
-        return FIELD_EX64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, WRPS) + 1;
+        return FIELD_EX64_IDREG(&cpu->isar, ID_AA64DFR0, WRPS) + 1;
     } else {
         return FIELD_EX32(cpu->isar.dbgdidr, DBGDIDR, WRPS) + 1;
     }
@@ -1202,7 +1202,7 @@ static inline int arm_num_wrps(ARMCPU *cpu)
 static inline int arm_num_ctx_cmps(ARMCPU *cpu)
 {
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
-        return FIELD_EX64(cpu->isar.id_aa64dfr0, ID_AA64DFR0, CTX_CMPS) + 1;
+        return FIELD_EX64_IDREG(&cpu->isar, ID_AA64DFR0, CTX_CMPS) + 1;
     } else {
         return FIELD_EX32(cpu->isar.dbgdidr, DBGDIDR, CTX_CMPS) + 1;
     }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 4e80c3df3844..44cc02fb76a2 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -355,10 +355,8 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64smfr0,
                               ARM64_SYS_REG(3, 0, 0, 4, 5));
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr0,
-                              ARM64_SYS_REG(3, 0, 0, 5, 0));
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr1,
-                              ARM64_SYS_REG(3, 0, 0, 5, 1));
+        err |= get_host_cpu_reg(fd, ahcf, ID_AA64DFR0_EL1_IDX);
+        err |= get_host_cpu_reg(fd, ahcf, ID_AA64DFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR0_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR2_EL1_IDX);
@@ -429,10 +427,10 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
          * We only do this if the CPU supports AArch32 at EL1.
          */
         if (FIELD_EX32_IDREG(&ahcf->isar, ID_AA64PFR0, EL1) >= 2) {
-            int wrps = FIELD_EX64(&ahcf->isar.id_aa64dfr0, ID_AA64DFR0, WRPS);
-            int brps = FIELD_EX64(&ahcf->isar.id_aa64dfr0, ID_AA64DFR0, BRPS);
+            int wrps = FIELD_EX64_IDREG(&ahcf->isar, ID_AA64DFR0, WRPS);
+            int brps = FIELD_EX64_IDREG(&ahcf->isar, ID_AA64DFR0, BRPS);
             int ctx_cmps =
-                FIELD_EX64(&ahcf->isar.id_aa64dfr0, ID_AA64DFR0, CTX_CMPS);
+                FIELD_EX64_IDREG(&ahcf->isar, ID_AA64DFR0, CTX_CMPS);
             int version = 6; /* ARMv8 debug architecture */
             bool has_el3 =
                 !!FIELD_EX32_IDREG(&ahcf->isar, ID_AA64PFR0, EL3);
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 439c29e69546..ddb82a03e37c 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -65,8 +65,8 @@ static void aarch64_a35_initfn(Object *obj)
     cpu->isar.id_isar5 = 0x00011121;
     SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
     SET_IDREG(isar, ID_AA64PFR1, 0);
-    cpu->isar.id_aa64dfr0 = 0x10305106;
-    cpu->isar.id_aa64dfr1 = 0;
+    SET_IDREG(isar, ID_AA64DFR0, 0x10305106);
+    SET_IDREG(isar, ID_AA64DFR1, 0);
     SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
     SET_IDREG(isar, ID_AA64ISAR1, 0);
     SET_IDREG(isar, ID_AA64MMFR0, 0x00101122);
@@ -219,7 +219,7 @@ static void aarch64_a55_initfn(Object *obj)
     cpu->clidr = 0x82000023;
     cpu->ctr = 0x84448004; /* L1Ip = VIPT */
     cpu->dcz_blocksize = 4; /* 64 bytes */
-    cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
+    SET_IDREG(isar, ID_AA64DFR0, 0x0000000010305408ull);
     SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
     SET_IDREG(isar, ID_AA64ISAR1, 0x0000000000100001ull);
     SET_IDREG(isar, ID_AA64MMFR0, 0x0000000000101122ull);
@@ -310,7 +310,7 @@ static void aarch64_a72_initfn(Object *obj)
     cpu->isar.id_isar4 = 0x00011142;
     cpu->isar.id_isar5 = 0x00011121;
     SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
-    cpu->isar.id_aa64dfr0 = 0x10305106;
+    SET_IDREG(isar, ID_AA64DFR0, 0x10305106);
     SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
     SET_IDREG(isar, ID_AA64MMFR0, 0x00001124);
     cpu->isar.dbgdidr = 0x3516d000;
@@ -352,7 +352,7 @@ static void aarch64_a76_initfn(Object *obj)
     cpu->clidr = 0x82000023;
     cpu->ctr = 0x8444C004;
     cpu->dcz_blocksize = 4;
-    cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
+    SET_IDREG(isar, ID_AA64DFR0, 0x0000000010305408ull),
     SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
     SET_IDREG(isar, ID_AA64ISAR1, 0x0000000000100001ull);
     SET_IDREG(isar, ID_AA64MMFR0, 0x0000000000101122ull);
@@ -426,8 +426,8 @@ static void aarch64_a64fx_initfn(Object *obj)
     cpu->reset_sctlr = 0x30000180;
     SET_IDREG(isar, ID_AA64PFR0, 0x0000000101111111); /* No RAS Extensions */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000000);
-    cpu->isar.id_aa64dfr0 = 0x0000000010305408;
-    cpu->isar.id_aa64dfr1 = 0x0000000000000000;
+    SET_IDREG(isar, ID_AA64DFR0, 0x0000000010305408),
+    SET_IDREG(isar, ID_AA64DFR1, 0x0000000000000000),
     cpu->id_aa64afr0 = 0x0000000000000000;
     cpu->id_aa64afr1 = 0x0000000000000000;
     SET_IDREG(isar, ID_AA64MMFR0, 0x0000000000001122);
@@ -600,7 +600,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     cpu->clidr = 0x82000023;
     cpu->ctr = 0x8444c004;
     cpu->dcz_blocksize = 4;
-    cpu->isar.id_aa64dfr0  = 0x0000000110305408ull;
+    SET_IDREG(isar, ID_AA64DFR0, 0x0000000110305408ull);
     SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
     SET_IDREG(isar, ID_AA64ISAR1, 0x0000000000100001ull);
     SET_IDREG(isar, ID_AA64MMFR0, 0x0000000000101125ull);
@@ -678,8 +678,8 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     cpu->dcz_blocksize = 4;
     cpu->id_aa64afr0 = 0x00000000;
     cpu->id_aa64afr1 = 0x00000000;
-    cpu->isar.id_aa64dfr0  = 0x000001f210305519ull;
-    cpu->isar.id_aa64dfr1 = 0x00000000;
+    SET_IDREG(isar, ID_AA64DFR0, 0x000001f210305519ull),
+    SET_IDREG(isar, ID_AA64DFR1, 0x00000000),
     SET_IDREG(isar, ID_AA64ISAR0, 0x1011111110212120ull); /* with FEAT_RNG */
     SET_IDREG(isar, ID_AA64ISAR1, 0x0011000001211032ull);
     SET_IDREG(isar, ID_AA64MMFR0, 0x0000000000101125ull);
@@ -925,8 +925,8 @@ static void aarch64_a710_initfn(Object *obj)
     SET_IDREG(isar, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000221ull);
     SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
-    cpu->isar.id_aa64dfr0  = 0x000011f010305619ull;
-    cpu->isar.id_aa64dfr1  = 0;
+    SET_IDREG(isar, ID_AA64DFR0, 0x000011f010305619ull);
+    SET_IDREG(isar, ID_AA64DFR1, 0);
     cpu->id_aa64afr0       = 0;
     cpu->id_aa64afr1       = 0;
     SET_IDREG(isar, ID_AA64ISAR0, 0x0221111110212120ull); /* with Crypto */
@@ -1027,8 +1027,8 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     SET_IDREG(isar, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000221ull);
     SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
-    cpu->isar.id_aa64dfr0  = 0x000011f210305619ull;
-    cpu->isar.id_aa64dfr1  = 0;
+    SET_IDREG(isar, ID_AA64DFR0, 0x000011f210305619ull);
+    SET_IDREG(isar, ID_AA64DFR1, 0);
     cpu->id_aa64afr0       = 0;
     cpu->id_aa64afr1       = 0;
     SET_IDREG(isar, ID_AA64ISAR0, 0x1221111110212120ull); /* with Crypto and FEAT_RNG */
@@ -1261,11 +1261,11 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64ZFR0, F64MM, 1);     /* FEAT_F64MM */
     SET_IDREG(isar, ID_AA64ZFR0, t);
 
-    t = cpu->isar.id_aa64dfr0;
+    t = GET_IDREG(isar, ID_AA64DFR0);
     t = FIELD_DP64(t, ID_AA64DFR0, DEBUGVER, 10); /* FEAT_Debugv8p8 */
     t = FIELD_DP64(t, ID_AA64DFR0, PMUVER, 6);    /* FEAT_PMUv3p5 */
     t = FIELD_DP64(t, ID_AA64DFR0, HPMN0, 1);     /* FEAT_HPMN0 */
-    cpu->isar.id_aa64dfr0 = t;
+    SET_IDREG(isar, ID_AA64DFR0, t);
 
     t = cpu->isar.id_aa64smfr0;
     t = FIELD_DP64(t, ID_AA64SMFR0, F32F32, 1);   /* FEAT_SME */
-- 
2.49.0

