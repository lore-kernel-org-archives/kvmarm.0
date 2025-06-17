Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19732DF3C9
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174849; cv=none; b=hxixCqHruvJkBffj1gpsLv7XeRA7KjCHTpmR/kJZIenRkbR6JvDi1q1RJEw7zBpCDFkZVzYK4TJraHQo+mCxnPxOtSrLi+FkW4Gi4zu/g01hRQv4Xx9kqa59mSss4Z5nMuKSSrEmUVvCkkoIgYTTHMsJfVcfpSzTKaEuJbZYzws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174849; c=relaxed/simple;
	bh=NufaGpblImw0NZrOUrq2VoJXdp//z85dk7jmU4K5GeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=AbN5D+FFLSeGFX/REX3Bn52mXaC74L5CHfOVlStefQt0s+p//O03yvczt8c9vvUNc3Oc99ji5YOSYEljzPuoJutivDbrrODwip6uhmX/A8QfTHFtzHL29rAuvSBJkuPivrHnuIOY7TtPw6BnXcKzk1gvNVKe48QpKHMV+Ye9sfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D6zTFDSo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6zTFDSo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750174845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ILgJoUZK/bauqdrReYIF9I6KwX5MDjJdzelgQt85oyc=;
	b=D6zTFDSocUiEkZlPsMI7DO61Fd6O77mCfIOdDW5z6Kw2bTJ4UZt1Y+/+JUzPRfDL1oSNO9
	QyN0m+cmfN2uNDmh4ktsiMXSp6rTLSp4Iz1xtTiauU+MaPhJhr+lzJBVgJurIpN7XWCQoz
	/ke79B/DTGMT5RLd6pNbaK23c216e0Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-a0H_LNtWPie6ZbsLHezPag-1; Tue,
 17 Jun 2025 11:40:43 -0400
X-MC-Unique: a0H_LNtWPie6ZbsLHezPag-1
X-Mimecast-MFC-AGG-ID: a0H_LNtWPie6ZbsLHezPag_1750174841
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D4A7195608E;
	Tue, 17 Jun 2025 15:40:41 +0000 (UTC)
Received: from gondolin.str.redhat.com (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B991180045B;
	Tue, 17 Jun 2025 15:40:34 +0000 (UTC)
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
Subject: [PATCH v8 09/14] arm/cpu: Store id_pfr0/1/2 into the idregs array
Date: Tue, 17 Jun 2025 17:39:26 +0200
Message-ID: <20250617153931.1330449-10-cohuck@redhat.com>
In-Reply-To: <20250617153931.1330449-1-cohuck@redhat.com>
References: <20250617153931.1330449-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/intc/armv7m_nvic.c     |  5 ++--
 target/arm/cpu-features.h | 10 ++++----
 target/arm/cpu.c          |  8 +++---
 target/arm/cpu.h          |  3 ---
 target/arm/cpu64.c        |  8 +++---
 target/arm/helper.c       |  8 +++---
 target/arm/kvm.c          |  9 +++----
 target/arm/tcg/cpu-v7m.c  | 24 +++++++++---------
 target/arm/tcg/cpu32.c    | 52 +++++++++++++++++++--------------------
 target/arm/tcg/cpu64.c    | 44 ++++++++++++++++-----------------
 10 files changed, 82 insertions(+), 89 deletions(-)

diff --git a/hw/intc/armv7m_nvic.c b/hw/intc/armv7m_nvic.c
index fdb7f58e3678..330205fa342d 100644
--- a/hw/intc/armv7m_nvic.c
+++ b/hw/intc/armv7m_nvic.c
@@ -988,6 +988,7 @@ static void nvic_nmi_trigger(void *opaque, int n, int level)
 static uint32_t nvic_readl(NVICState *s, uint32_t offset, MemTxAttrs attrs)
 {
     ARMCPU *cpu = s->cpu;
+    ARMISARegisters *isar = &cpu->isar;
     uint32_t val;
 
     switch (offset) {
@@ -1263,12 +1264,12 @@ static uint32_t nvic_readl(NVICState *s, uint32_t offset, MemTxAttrs attrs)
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
         }
-        return cpu->isar.id_pfr0;
+        return GET_IDREG(isar, ID_PFR0);
     case 0xd44: /* PFR1.  */
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
         }
-        return cpu->isar.id_pfr1;
+        return GET_IDREG(isar, ID_PFR1);
     case 0xd48: /* DFR0.  */
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 75a2cc407793..a34378577f08 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -137,12 +137,12 @@ static inline bool isar_feature_aa32_i8mm(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa32_ras(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_pfr0, ID_PFR0, RAS) != 0;
+    return FIELD_EX32_IDREG(id, ID_PFR0, RAS) != 0;
 }
 
 static inline bool isar_feature_aa32_mprofile(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_pfr1, ID_PFR1, MPROGMOD) != 0;
+    return FIELD_EX32_IDREG(id, ID_PFR1, MPROGMOD) != 0;
 }
 
 static inline bool isar_feature_aa32_m_sec_state(const ARMISARegisters *id)
@@ -151,7 +151,7 @@ static inline bool isar_feature_aa32_m_sec_state(const ARMISARegisters *id)
      * Return true if M-profile state handling insns
      * (VSCCLRM, CLRM, FPCTX access insns) are implemented
      */
-    return FIELD_EX32(id->id_pfr1, ID_PFR1, SECURITY) >= 3;
+    return FIELD_EX32_IDREG(id, ID_PFR1, SECURITY) >= 3;
 }
 
 static inline bool isar_feature_aa32_fp16_arith(const ARMISARegisters *id)
@@ -350,12 +350,12 @@ static inline bool isar_feature_aa32_evt(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa32_dit(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_pfr0, ID_PFR0, DIT) != 0;
+    return FIELD_EX32_IDREG(id, ID_PFR0, DIT) != 0;
 }
 
 static inline bool isar_feature_aa32_ssbs(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_pfr2, ID_PFR2, SSBS) != 0;
+    return FIELD_EX32_IDREG(id, ID_PFR2, SSBS) != 0;
 }
 
 static inline bool isar_feature_aa32_debugv7p1(const ARMISARegisters *id)
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index cf811e47d996..62c06c7269c9 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2317,7 +2317,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          * Disable the security extension feature bits in the processor
          * feature registers as well.
          */
-        cpu->isar.id_pfr1 = FIELD_DP32(cpu->isar.id_pfr1, ID_PFR1, SECURITY, 0);
+        FIELD_DP32_IDREG(isar, ID_PFR1, SECURITY, 0);
         cpu->isar.id_dfr0 = FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, COPSDBG, 0);
         FIELD_DP64_IDREG(isar, ID_AA64PFR0, EL3, 0);
 
@@ -2357,8 +2357,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          * registers if we don't have EL2.
          */
         FIELD_DP64_IDREG(isar, ID_AA64PFR0, EL2, 0);
-        cpu->isar.id_pfr1 = FIELD_DP32(cpu->isar.id_pfr1,
-                                       ID_PFR1, VIRTUALIZATION, 0);
+        FIELD_DP32_IDREG(isar, ID_PFR1, VIRTUALIZATION, 0);
     }
 
     if (cpu_isar_feature(aa64_mte, cpu)) {
@@ -2421,8 +2420,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
             FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, MMAPTRC, 0);
         /* FEAT_AMU (Activity Monitors Extension) */
         FIELD_DP64_IDREG(isar, ID_AA64PFR0, AMU, 0);
-        cpu->isar.id_pfr0 =
-            FIELD_DP32(cpu->isar.id_pfr0, ID_PFR0, AMU, 0);
+        FIELD_DP32_IDREG(isar, ID_PFR0, AMU, 0);
         /* FEAT_MPAM (Memory Partitioning and Monitoring Extension) */
         FIELD_DP64_IDREG(isar, ID_AA64PFR0, MPAM, 0);
     }
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 353c18e67993..30401926e115 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1056,9 +1056,6 @@ struct ArchCPU {
         uint32_t id_mmfr3;
         uint32_t id_mmfr4;
         uint32_t id_mmfr5;
-        uint32_t id_pfr0;
-        uint32_t id_pfr1;
-        uint32_t id_pfr2;
         uint32_t mvfr0;
         uint32_t mvfr1;
         uint32_t mvfr2;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 6be62c0711b2..5b628aa7ebf4 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -652,8 +652,8 @@ static void aarch64_a57_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000043;
     cpu->ctr = 0x8444c004;
     cpu->reset_sctlr = 0x00c50838;
-    cpu->isar.id_pfr0 = 0x00000131;
-    cpu->isar.id_pfr1 = 0x00011011;
+    SET_IDREG(isar, ID_PFR0, 0x00000131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
     cpu->isar.id_dfr0 = 0x03010066;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
@@ -714,8 +714,8 @@ static void aarch64_a53_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000043;
     cpu->ctr = 0x84448004; /* L1Ip = VIPT */
     cpu->reset_sctlr = 0x00c50838;
-    cpu->isar.id_pfr0 = 0x00000131;
-    cpu->isar.id_pfr1 = 0x00011011;
+    SET_IDREG(isar, ID_PFR0, 0x00000131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
     cpu->isar.id_dfr0 = 0x03010066;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 669b7a84284a..e9eb345ab23a 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6932,7 +6932,7 @@ static void define_pmu_regs(ARMCPU *cpu)
 static uint64_t id_pfr1_read(CPUARMState *env, const ARMCPRegInfo *ri)
 {
     ARMCPU *cpu = env_archcpu(env);
-    uint64_t pfr1 = cpu->isar.id_pfr1;
+    uint64_t pfr1 = GET_IDREG(&cpu->isar, ID_PFR1);
 
     if (env->gicv3state) {
         pfr1 |= 1 << 28;
@@ -7777,7 +7777,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 1, .opc2 = 0,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa32_tid3,
-              .resetvalue = cpu->isar.id_pfr0 },
+              .resetvalue = GET_IDREG(isar, ID_PFR0)},
             /*
              * ID_PFR1 is not a plain ARM_CP_CONST because we don't know
              * the value of the GIC field until after we define these regs.
@@ -7788,7 +7788,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .accessfn = access_aa32_tid3,
 #ifdef CONFIG_USER_ONLY
               .type = ARM_CP_CONST,
-              .resetvalue = cpu->isar.id_pfr1,
+              .resetvalue = GET_IDREG(isar, ID_PFR1),
 #else
               .type = ARM_CP_NO_RAW,
               .accessfn = access_aa32_tid3,
@@ -8130,7 +8130,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 4,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_pfr2 },
+              .resetvalue = GET_IDREG(isar, ID_PFR2)},
             { .name = "ID_DFR1", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 5,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index eef9481737b5..d945e652b3ee 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -332,10 +332,8 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
          * than skipping the reads and leaving 0, as we must avoid
          * considering the values in every case.
          */
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr0,
-                              ARM64_SYS_REG(3, 0, 0, 1, 0));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr1,
-                              ARM64_SYS_REG(3, 0, 0, 1, 1));
+        err |= get_host_cpu_reg(fd, ahcf, ID_PFR0_EL1_IDX);
+        err |= get_host_cpu_reg(fd, ahcf, ID_PFR1_EL1_IDX);
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_dfr0,
                               ARM64_SYS_REG(3, 0, 0, 1, 2));
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr0,
@@ -362,8 +360,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
                               ARM64_SYS_REG(3, 0, 0, 3, 1));
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr2,
                               ARM64_SYS_REG(3, 0, 0, 3, 2));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr2,
-                              ARM64_SYS_REG(3, 0, 0, 3, 4));
+        err |= get_host_cpu_reg(fd, ahcf, ID_PFR2_EL1_IDX);
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_dfr1,
                               ARM64_SYS_REG(3, 0, 0, 3, 5));
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr5,
diff --git a/target/arm/tcg/cpu-v7m.c b/target/arm/tcg/cpu-v7m.c
index 198c9f3e98c3..4a2c3bd01a36 100644
--- a/target/arm/tcg/cpu-v7m.c
+++ b/target/arm/tcg/cpu-v7m.c
@@ -59,8 +59,8 @@ static void cortex_m0_initfn(Object *obj)
      * by looking at ID register fields. We use the same values as
      * for the M3.
      */
-    cpu->isar.id_pfr0 = 0x00000030;
-    cpu->isar.id_pfr1 = 0x00000200;
+    SET_IDREG(isar, ID_PFR0, 0x00000030);
+    SET_IDREG(isar, ID_PFR1, 0x00000200);
     cpu->isar.id_dfr0 = 0x00100000;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00000030;
@@ -85,8 +85,8 @@ static void cortex_m3_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
     cpu->midr = 0x410fc231;
     cpu->pmsav7_dregion = 8;
-    cpu->isar.id_pfr0 = 0x00000030;
-    cpu->isar.id_pfr1 = 0x00000200;
+    SET_IDREG(isar, ID_PFR0, 0x00000030);
+    SET_IDREG(isar, ID_PFR1, 0x00000200);
     cpu->isar.id_dfr0 = 0x00100000;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00000030;
@@ -116,8 +116,8 @@ static void cortex_m4_initfn(Object *obj)
     cpu->isar.mvfr0 = 0x10110021;
     cpu->isar.mvfr1 = 0x11000011;
     cpu->isar.mvfr2 = 0x00000000;
-    cpu->isar.id_pfr0 = 0x00000030;
-    cpu->isar.id_pfr1 = 0x00000200;
+    SET_IDREG(isar, ID_PFR0, 0x00000030);
+    SET_IDREG(isar, ID_PFR1, 0x00000200);
     cpu->isar.id_dfr0 = 0x00100000;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00000030;
@@ -147,8 +147,8 @@ static void cortex_m7_initfn(Object *obj)
     cpu->isar.mvfr0 = 0x10110221;
     cpu->isar.mvfr1 = 0x12000011;
     cpu->isar.mvfr2 = 0x00000040;
-    cpu->isar.id_pfr0 = 0x00000030;
-    cpu->isar.id_pfr1 = 0x00000200;
+    SET_IDREG(isar, ID_PFR0, 0x00000030);
+    SET_IDREG(isar, ID_PFR1, 0x00000200);
     cpu->isar.id_dfr0 = 0x00100000;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00100030;
@@ -180,8 +180,8 @@ static void cortex_m33_initfn(Object *obj)
     cpu->isar.mvfr0 = 0x10110021;
     cpu->isar.mvfr1 = 0x11000011;
     cpu->isar.mvfr2 = 0x00000040;
-    cpu->isar.id_pfr0 = 0x00000030;
-    cpu->isar.id_pfr1 = 0x00000210;
+    SET_IDREG(isar, ID_PFR0, 0x00000030);
+    SET_IDREG(isar, ID_PFR1, 0x00000210);
     cpu->isar.id_dfr0 = 0x00200000;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00101F40;
@@ -218,8 +218,8 @@ static void cortex_m55_initfn(Object *obj)
     cpu->isar.mvfr0 = 0x10110221;
     cpu->isar.mvfr1 = 0x12100211;
     cpu->isar.mvfr2 = 0x00000040;
-    cpu->isar.id_pfr0 = 0x20000030;
-    cpu->isar.id_pfr1 = 0x00000230;
+    SET_IDREG(isar, ID_PFR0, 0x20000030);
+    SET_IDREG(isar, ID_PFR1, 0x00000230);
     cpu->isar.id_dfr0 = 0x10200000;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00111040;
diff --git a/target/arm/tcg/cpu32.c b/target/arm/tcg/cpu32.c
index 937a72b12c9b..56374db2692f 100644
--- a/target/arm/tcg/cpu32.c
+++ b/target/arm/tcg/cpu32.c
@@ -71,16 +71,16 @@ void aa32_max_features(ARMCPU *cpu)
     t = FIELD_DP32(t, ID_MMFR5, ETS, 2);          /* FEAT_ETS2 */
     cpu->isar.id_mmfr5 = t;
 
-    t = cpu->isar.id_pfr0;
+    t = GET_IDREG(isar, ID_PFR0);
     t = FIELD_DP32(t, ID_PFR0, CSV2, 2);          /* FEAT_CSV2 */
     t = FIELD_DP32(t, ID_PFR0, DIT, 1);           /* FEAT_DIT */
     t = FIELD_DP32(t, ID_PFR0, RAS, 1);           /* FEAT_RAS */
-    cpu->isar.id_pfr0 = t;
+    SET_IDREG(isar, ID_PFR0, t);
 
-    t = cpu->isar.id_pfr2;
+    t = GET_IDREG(isar, ID_PFR2);
     t = FIELD_DP32(t, ID_PFR2, CSV3, 1);          /* FEAT_CSV3 */
     t = FIELD_DP32(t, ID_PFR2, SSBS, 1);          /* FEAT_SSBS */
-    cpu->isar.id_pfr2 = t;
+    SET_IDREG(isar, ID_PFR2, t);
 
     t = cpu->isar.id_dfr0;
     t = FIELD_DP32(t, ID_DFR0, COPDBG, 10);       /* FEAT_Debugv8p8 */
@@ -228,8 +228,8 @@ static void arm1136_r2_initfn(Object *obj)
     cpu->isar.mvfr1 = 0x00000000;
     cpu->ctr = 0x1dd20d2;
     cpu->reset_sctlr = 0x00050078;
-    cpu->isar.id_pfr0 = 0x111;
-    cpu->isar.id_pfr1 = 0x1;
+    SET_IDREG(isar, ID_PFR0, 0x111);
+    SET_IDREG(isar, ID_PFR1, 0x1);
     cpu->isar.id_dfr0 = 0x2;
     cpu->id_afr0 = 0x3;
     cpu->isar.id_mmfr0 = 0x01130003;
@@ -260,8 +260,8 @@ static void arm1136_initfn(Object *obj)
     cpu->isar.mvfr1 = 0x00000000;
     cpu->ctr = 0x1dd20d2;
     cpu->reset_sctlr = 0x00050078;
-    cpu->isar.id_pfr0 = 0x111;
-    cpu->isar.id_pfr1 = 0x1;
+    SET_IDREG(isar, ID_PFR0, 0x111);
+    SET_IDREG(isar, ID_PFR1, 0x1);
     cpu->isar.id_dfr0 = 0x2;
     cpu->id_afr0 = 0x3;
     cpu->isar.id_mmfr0 = 0x01130003;
@@ -293,8 +293,8 @@ static void arm1176_initfn(Object *obj)
     cpu->isar.mvfr1 = 0x00000000;
     cpu->ctr = 0x1dd20d2;
     cpu->reset_sctlr = 0x00050078;
-    cpu->isar.id_pfr0 = 0x111;
-    cpu->isar.id_pfr1 = 0x11;
+    SET_IDREG(isar, ID_PFR0, 0x111);
+    SET_IDREG(isar, ID_PFR1, 0x11);
     cpu->isar.id_dfr0 = 0x33;
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x01130003;
@@ -323,8 +323,8 @@ static void arm11mpcore_initfn(Object *obj)
     cpu->isar.mvfr0 = 0x11111111;
     cpu->isar.mvfr1 = 0x00000000;
     cpu->ctr = 0x1d192992; /* 32K icache 32K dcache */
-    cpu->isar.id_pfr0 = 0x111;
-    cpu->isar.id_pfr1 = 0x1;
+    SET_IDREG(isar, ID_PFR0, 0x111);
+    SET_IDREG(isar, ID_PFR1, 0x1);
     cpu->isar.id_dfr0 = 0;
     cpu->id_afr0 = 0x2;
     cpu->isar.id_mmfr0 = 0x01100103;
@@ -363,8 +363,8 @@ static void cortex_a8_initfn(Object *obj)
     cpu->isar.mvfr1 = 0x00011111;
     cpu->ctr = 0x82048004;
     cpu->reset_sctlr = 0x00c50078;
-    cpu->isar.id_pfr0 = 0x1031;
-    cpu->isar.id_pfr1 = 0x11;
+    SET_IDREG(isar, ID_PFR0, 0x1031);
+    SET_IDREG(isar, ID_PFR1, 0x11);
     cpu->isar.id_dfr0 = 0x400;
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x31100003;
@@ -439,8 +439,8 @@ static void cortex_a9_initfn(Object *obj)
     cpu->isar.mvfr1 = 0x01111111;
     cpu->ctr = 0x80038003;
     cpu->reset_sctlr = 0x00c50078;
-    cpu->isar.id_pfr0 = 0x1031;
-    cpu->isar.id_pfr1 = 0x11;
+    SET_IDREG(isar, ID_PFR0, 0x1031);
+    SET_IDREG(isar, ID_PFR1, 0x11);
     cpu->isar.id_dfr0 = 0x000;
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x00100103;
@@ -505,8 +505,8 @@ static void cortex_a7_initfn(Object *obj)
     cpu->isar.mvfr1 = 0x11111111;
     cpu->ctr = 0x84448003;
     cpu->reset_sctlr = 0x00c50078;
-    cpu->isar.id_pfr0 = 0x00001131;
-    cpu->isar.id_pfr1 = 0x00011011;
+    SET_IDREG(isar, ID_PFR0, 0x00001131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
     cpu->isar.id_dfr0 = 0x02010555;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
@@ -557,8 +557,8 @@ static void cortex_a15_initfn(Object *obj)
     cpu->isar.mvfr1 = 0x11111111;
     cpu->ctr = 0x8444c004;
     cpu->reset_sctlr = 0x00c50078;
-    cpu->isar.id_pfr0 = 0x00001131;
-    cpu->isar.id_pfr1 = 0x00011011;
+    SET_IDREG(isar, ID_PFR0, 0x00001131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
     cpu->isar.id_dfr0 = 0x02010555;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10201105;
@@ -601,8 +601,8 @@ static void cortex_r5_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_PMSA);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     cpu->midr = 0x411fc153; /* r1p3 */
-    cpu->isar.id_pfr0 = 0x0131;
-    cpu->isar.id_pfr1 = 0x001;
+    SET_IDREG(isar, ID_PFR0, 0x0131);
+    SET_IDREG(isar, ID_PFR1, 0x001);
     cpu->isar.id_dfr0 = 0x010400;
     cpu->id_afr0 = 0x0;
     cpu->isar.id_mmfr0 = 0x0210030;
@@ -748,8 +748,8 @@ static void cortex_r52_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000043;
     cpu->ctr = 0x8144c004;
     cpu->reset_sctlr = 0x30c50838;
-    cpu->isar.id_pfr0 = 0x00000131;
-    cpu->isar.id_pfr1 = 0x10111001;
+    SET_IDREG(isar, ID_PFR0, 0x00000131);
+    SET_IDREG(isar, ID_PFR1, 0x10111001);
     cpu->isar.id_dfr0 = 0x03010006;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00211040;
@@ -980,8 +980,8 @@ static void arm_max_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000043;
     cpu->ctr = 0x8444c004;
     cpu->reset_sctlr = 0x00c50838;
-    cpu->isar.id_pfr0 = 0x00000131;
-    cpu->isar.id_pfr1 = 0x00011011;
+    SET_IDREG(isar, ID_PFR0, 0x00000131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
     cpu->isar.id_dfr0 = 0x03010066;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index dd4dc8ada564..c3f90e9d1357 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -49,8 +49,8 @@ static void aarch64_a35_initfn(Object *obj)
     cpu->midr = 0x411fd040;
     cpu->revidr = 0;
     cpu->ctr = 0x84448004;
-    cpu->isar.id_pfr0 = 0x00000131;
-    cpu->isar.id_pfr1 = 0x00011011;
+    SET_IDREG(isar, ID_PFR0, 0x00000131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
     cpu->isar.id_dfr0 = 0x03010066;
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x10201105;
@@ -241,9 +241,9 @@ static void aarch64_a55_initfn(Object *obj)
     cpu->isar.id_mmfr2 = 0x01260000;
     cpu->isar.id_mmfr3 = 0x02122211;
     cpu->isar.id_mmfr4 = 0x00021110;
-    cpu->isar.id_pfr0  = 0x10010131;
-    cpu->isar.id_pfr1  = 0x00011011;
-    cpu->isar.id_pfr2  = 0x00000011;
+    SET_IDREG(isar, ID_PFR0, 0x10010131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
+    SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x412FD050;          /* r2p0 */
     cpu->revidr = 0;
 
@@ -295,8 +295,8 @@ static void aarch64_a72_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000043;
     cpu->ctr = 0x8444c004;
     cpu->reset_sctlr = 0x00c50838;
-    cpu->isar.id_pfr0 = 0x00000131;
-    cpu->isar.id_pfr1 = 0x00011011;
+    SET_IDREG(isar, ID_PFR0, 0x00000131);
+    SET_IDREG(isar, ID_PFR1, 0x00011011);
     cpu->isar.id_dfr0 = 0x03010066;
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10201105;
@@ -374,9 +374,9 @@ static void aarch64_a76_initfn(Object *obj)
     cpu->isar.id_mmfr2 = 0x01260000;
     cpu->isar.id_mmfr3 = 0x02122211;
     cpu->isar.id_mmfr4 = 0x00021110;
-    cpu->isar.id_pfr0  = 0x10010131;
-    cpu->isar.id_pfr1  = 0x00010000; /* GIC filled in later */
-    cpu->isar.id_pfr2  = 0x00000011;
+    SET_IDREG(isar, ID_PFR0, 0x10010131);
+    SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
+    SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x414fd0b1;          /* r4p1 */
     cpu->revidr = 0;
 
@@ -622,9 +622,9 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     cpu->isar.id_mmfr2 = 0x01260000;
     cpu->isar.id_mmfr3 = 0x02122211;
     cpu->isar.id_mmfr4 = 0x00021110;
-    cpu->isar.id_pfr0  = 0x10010131;
-    cpu->isar.id_pfr1  = 0x00010000; /* GIC filled in later */
-    cpu->isar.id_pfr2  = 0x00000011;
+    SET_IDREG(isar, ID_PFR0, 0x10010131);
+    SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
+    SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x414fd0c1;          /* r4p1 */
     cpu->revidr = 0;
 
@@ -701,9 +701,9 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     cpu->isar.id_mmfr2 = 0x01260000;
     cpu->isar.id_mmfr3 = 0x02122211;
     cpu->isar.id_mmfr4 = 0x01021110;
-    cpu->isar.id_pfr0  = 0x21110131;
-    cpu->isar.id_pfr1  = 0x00010000; /* GIC filled in later */
-    cpu->isar.id_pfr2  = 0x00000011;
+    SET_IDREG(isar, ID_PFR0, 0x21110131);
+    SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
+    SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x411FD402;          /* r1p2 */
     cpu->revidr = 0;
 
@@ -902,8 +902,8 @@ static void aarch64_a710_initfn(Object *obj)
     /* Ordered by Section B.4: AArch64 registers */
     cpu->midr          = 0x412FD471; /* r2p1 */
     cpu->revidr        = 0;
-    cpu->isar.id_pfr0  = 0x21110131;
-    cpu->isar.id_pfr1  = 0x00010000; /* GIC filled in later */
+    SET_IDREG(isar, ID_PFR0, 0x21110131);
+    SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     cpu->isar.id_dfr0  = 0x16011099;
     cpu->id_afr0       = 0;
     cpu->isar.id_mmfr0 = 0x10201105;
@@ -921,7 +921,7 @@ static void aarch64_a710_initfn(Object *obj)
     cpu->isar.mvfr0    = 0x10110222;
     cpu->isar.mvfr1    = 0x13211111;
     cpu->isar.mvfr2    = 0x00000043;
-    cpu->isar.id_pfr2  = 0x00000011;
+    SET_IDREG(isar, ID_PFR2, 0x00000011);
     SET_IDREG(isar, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000221ull);
     SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
@@ -1004,8 +1004,8 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     /* Ordered by Section B.5: AArch64 ID registers */
     cpu->midr          = 0x410FD493; /* r0p3 */
     cpu->revidr        = 0;
-    cpu->isar.id_pfr0  = 0x21110131;
-    cpu->isar.id_pfr1  = 0x00010000; /* GIC filled in later */
+    SET_IDREG(isar, ID_PFR0, 0x21110131);
+    SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     cpu->isar.id_dfr0  = 0x16011099;
     cpu->id_afr0       = 0;
     cpu->isar.id_mmfr0 = 0x10201105;
@@ -1023,7 +1023,7 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     cpu->isar.mvfr0    = 0x10110222;
     cpu->isar.mvfr1    = 0x13211111;
     cpu->isar.mvfr2    = 0x00000043;
-    cpu->isar.id_pfr2  = 0x00000011;
+    SET_IDREG(isar, ID_PFR2, 0x00000011);
     SET_IDREG(isar, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000221ull);
     SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
-- 
2.49.0

