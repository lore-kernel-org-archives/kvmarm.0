Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA8719E97C
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192916; cv=none; b=mpIkHJyyC8gZ6mF53c80FDisiVXjLRN+1O8Tkp+sY5DS1BNUZb05Y2KJ4KKqjogfhCvnber5mnwmrvZsaMayfXOtRtsOcXD1Sv896BD55e4+GqICQabAgjm4LpJiNPP59qK1n6+cp7JR0mupY8mL6M1dHEr3UkmckdDcZ5hRQyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192916; c=relaxed/simple;
	bh=wr+YQoGnrHutW7ooigc20MZG+knmZIYFgVyA+OQkkWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=IxSlTeZ4i7iMYeVmLV7E8c6JucaorKQK7eGAIC/9GzTj0NGTXup/MboAmKBbLAQ043RjM574pvTe13t55IJm5HWMupxtg1ayTdCwdA8iJ4pyMnvQ84vWR4JX4DNda9qaY8RTGaJLPfImB0R6dHKg0r82Le70exXUf+XB8pL8Bfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TP1MP/+a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TP1MP/+a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741192913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+Ox+dpxYJ0X9xh4eVoSlGLEsn+VzyikTFywIo+Wwfg=;
	b=TP1MP/+acxJ2E1VzxD2H+qfu9kkgx1TUTlWF7vALeoO41ts3caF0ymdkDQzU12vtCnhiti
	vQUpdzNtsi46onlxF0D1F1//Ok1m50Fz+1DwPcgdb4F88K0LYAfKcIedRfoQ88jaLzC9wA
	iNPvUGIswBrmSymQzCDutavIPcROMEE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-374-XCchgUCNNeOEGXJHSRDkUQ-1; Wed,
 05 Mar 2025 11:41:46 -0500
X-MC-Unique: XCchgUCNNeOEGXJHSRDkUQ-1
X-Mimecast-MFC-AGG-ID: XCchgUCNNeOEGXJHSRDkUQ_1741192903
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01810195609E;
	Wed,  5 Mar 2025 16:41:43 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.9])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1BC2E1955DDE;
	Wed,  5 Mar 2025 16:41:27 +0000 (UTC)
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
Subject: [PATCH v2 11/14] arm/cpu: Store id_dfr0/1 into the idregs array
Date: Wed,  5 Mar 2025 17:38:16 +0100
Message-ID: <20250305163819.2477553-12-cohuck@redhat.com>
In-Reply-To: <20250305163819.2477553-1-cohuck@redhat.com>
References: <20250305163819.2477553-1-cohuck@redhat.com>
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

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/intc/armv7m_nvic.c     |  2 +-
 target/arm/cpu-features.h | 16 ++++++++--------
 target/arm/cpu.c          | 13 +++++--------
 target/arm/cpu.h          |  2 --
 target/arm/cpu64.c        |  4 ++--
 target/arm/helper.c       |  4 ++--
 target/arm/kvm.c          |  6 ++----
 target/arm/tcg/cpu-v7m.c  | 12 ++++++------
 target/arm/tcg/cpu32.c    | 30 ++++++++++++++----------------
 target/arm/tcg/cpu64.c    | 16 ++++++++--------
 10 files changed, 48 insertions(+), 57 deletions(-)

diff --git a/hw/intc/armv7m_nvic.c b/hw/intc/armv7m_nvic.c
index 95a5b80bccd4..2e6ae4e9ab05 100644
--- a/hw/intc/armv7m_nvic.c
+++ b/hw/intc/armv7m_nvic.c
@@ -1274,7 +1274,7 @@ static uint32_t nvic_readl(NVICState *s, uint32_t offset, MemTxAttrs attrs)
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
         }
-        return cpu->isar.id_dfr0;
+        return GET_IDREG(isar, ID_DFR0);
     case 0xd4c: /* AFR0.  */
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 156130085067..cad34f0ad403 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -299,22 +299,22 @@ static inline bool isar_feature_aa32_ats1e1(const ARMISARegisters *id)
 static inline bool isar_feature_aa32_pmuv3p1(const ARMISARegisters *id)
 {
     /* 0xf means "non-standard IMPDEF PMU" */
-    return FIELD_EX32(id->id_dfr0, ID_DFR0, PERFMON) >= 4 &&
-        FIELD_EX32(id->id_dfr0, ID_DFR0, PERFMON) != 0xf;
+    return FIELD_EX32_IDREG(id, ID_DFR0, PERFMON) >= 4 &&
+        FIELD_EX32_IDREG(id, ID_DFR0, PERFMON) != 0xf;
 }
 
 static inline bool isar_feature_aa32_pmuv3p4(const ARMISARegisters *id)
 {
     /* 0xf means "non-standard IMPDEF PMU" */
-    return FIELD_EX32(id->id_dfr0, ID_DFR0, PERFMON) >= 5 &&
-        FIELD_EX32(id->id_dfr0, ID_DFR0, PERFMON) != 0xf;
+    return FIELD_EX32_IDREG(id, ID_DFR0, PERFMON) >= 5 &&
+        FIELD_EX32_IDREG(id, ID_DFR0, PERFMON) != 0xf;
 }
 
 static inline bool isar_feature_aa32_pmuv3p5(const ARMISARegisters *id)
 {
     /* 0xf means "non-standard IMPDEF PMU" */
-    return FIELD_EX32(id->id_dfr0, ID_DFR0, PERFMON) >= 6 &&
-        FIELD_EX32(id->id_dfr0, ID_DFR0, PERFMON) != 0xf;
+    return FIELD_EX32_IDREG(id, ID_DFR0, PERFMON) >= 6 &&
+        FIELD_EX32_IDREG(id, ID_DFR0, PERFMON) != 0xf;
 }
 
 static inline bool isar_feature_aa32_hpd(const ARMISARegisters *id)
@@ -359,12 +359,12 @@ static inline bool isar_feature_aa32_ssbs(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa32_debugv7p1(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_dfr0, ID_DFR0, COPDBG) >= 5;
+    return FIELD_EX32_IDREG(id, ID_DFR0, COPDBG) >= 5;
 }
 
 static inline bool isar_feature_aa32_debugv8p2(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_dfr0, ID_DFR0, COPDBG) >= 8;
+    return FIELD_EX32_IDREG(id, ID_DFR0, COPDBG) >= 8;
 }
 
 static inline bool isar_feature_aa32_doublelock(const ARMISARegisters *id)
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 0212fc45e079..6af3532019f3 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2323,7 +2323,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          * feature registers as well.
          */
         FIELD_DP32_IDREG(isar, ID_PFR1, SECURITY, 0);
-        cpu->isar.id_dfr0 = FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, COPSDBG, 0);
+        FIELD_DP32_IDREG(isar, ID_DFR0, COPSDBG, 0);
         FIELD_DP64_IDREG(isar, ID_AA64PFR0, EL3, 0);
 
         /* Disable the realm management extension, which requires EL3. */
@@ -2351,7 +2351,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
 #endif
     } else {
         FIELD_DP64_IDREG(isar, ID_AA64DFR0, PMUVER, 0);
-        cpu->isar.id_dfr0 = FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, PERFMON, 0);
+        FIELD_DP32_IDREG(isar, ID_DFR0, PERFMON, 0);
         cpu->pmceid0 = 0;
         cpu->pmceid1 = 0;
     }
@@ -2414,15 +2414,12 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         FIELD_DP64_IDREG(isar, ID_AA64DFR0, TRACEBUFFER, 0);
         /* FEAT_TRF (Self-hosted Trace Extension) */
         FIELD_DP64_IDREG(isar, ID_AA64DFR0, TRACEFILT, 0);
-        cpu->isar.id_dfr0 =
-            FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, TRACEFILT, 0);
+        FIELD_DP32_IDREG(isar, ID_DFR0, TRACEFILT, 0);
         /* Trace Macrocell system register access */
         FIELD_DP64_IDREG(isar, ID_AA64DFR0, TRACEVER, 0);
-        cpu->isar.id_dfr0 =
-            FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, COPTRC, 0);
+        FIELD_DP32_IDREG(isar, ID_DFR0, COPTRC, 0);
         /* Memory mapped trace */
-        cpu->isar.id_dfr0 =
-            FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, MMAPTRC, 0);
+        FIELD_DP32_IDREG(isar, ID_DFR0, MMAPTRC, 0);
         /* FEAT_AMU (Activity Monitors Extension) */
         FIELD_DP64_IDREG(isar, ID_AA64PFR0, AMU, 0);
         FIELD_DP32_IDREG(isar, ID_PFR0, AMU, 0);
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 32be4e482db4..61b8912a1ddf 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1082,8 +1082,6 @@ struct ArchCPU {
         uint32_t mvfr0;
         uint32_t mvfr1;
         uint32_t mvfr2;
-        uint32_t id_dfr0;
-        uint32_t id_dfr1;
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 0b31f7b046a5..bb07eb01d487 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -632,7 +632,7 @@ static void aarch64_a57_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50838;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
-    cpu->isar.id_dfr0 = 0x03010066;
+    SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
     cpu->isar.id_mmfr1 = 0x40000000;
@@ -694,7 +694,7 @@ static void aarch64_a53_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50838;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
-    cpu->isar.id_dfr0 = 0x03010066;
+    SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
     cpu->isar.id_mmfr1 = 0x40000000;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 07f30992df0f..1665c50a3b3c 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7577,7 +7577,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 1, .opc2 = 2,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa32_tid3,
-              .resetvalue = cpu->isar.id_dfr0 },
+              .resetvalue = GET_IDREG(isar, ID_DFR0)},
             { .name = "ID_AFR0", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 1, .opc2 = 3,
               .access = PL1_R, .type = ARM_CP_CONST,
@@ -7912,7 +7912,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 5,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_dfr1 },
+              .resetvalue = GET_IDREG(isar, ID_DFR1)},
             { .name = "ID_MMFR5", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 6,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c397692d56a5..8fd8a97fa4f6 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -363,8 +363,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
          */
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR0_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_dfr0,
-                              ARM64_SYS_REG(3, 0, 0, 1, 2));
+        err |= get_host_cpu_reg(fd, ahcf, ID_DFR0_EL1_IDX);
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr0,
                               ARM64_SYS_REG(3, 0, 0, 1, 4));
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr1,
@@ -390,8 +389,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr2,
                               ARM64_SYS_REG(3, 0, 0, 3, 2));
         err |= get_host_cpu_reg(fd, ahcf, ID_PFR2_EL1_IDX);
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_dfr1,
-                              ARM64_SYS_REG(3, 0, 0, 3, 5));
+        err |= get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr5,
                               ARM64_SYS_REG(3, 0, 0, 3, 6));
 
diff --git a/target/arm/tcg/cpu-v7m.c b/target/arm/tcg/cpu-v7m.c
index e6177b86d352..08134df72bf7 100644
--- a/target/arm/tcg/cpu-v7m.c
+++ b/target/arm/tcg/cpu-v7m.c
@@ -62,7 +62,7 @@ static void cortex_m0_initfn(Object *obj)
      */
     SET_IDREG(isar, ID_PFR0, 0x00000030);
     SET_IDREG(isar, ID_PFR1, 0x00000200);
-    cpu->isar.id_dfr0 = 0x00100000;
+    SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00000030;
     cpu->isar.id_mmfr1 = 0x00000000;
@@ -88,7 +88,7 @@ static void cortex_m3_initfn(Object *obj)
     cpu->pmsav7_dregion = 8;
     SET_IDREG(isar, ID_PFR0, 0x00000030);
     SET_IDREG(isar, ID_PFR1, 0x00000200);
-    cpu->isar.id_dfr0 = 0x00100000;
+    SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00000030;
     cpu->isar.id_mmfr1 = 0x00000000;
@@ -119,7 +119,7 @@ static void cortex_m4_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000000;
     SET_IDREG(isar, ID_PFR0, 0x00000030);
     SET_IDREG(isar, ID_PFR1, 0x00000200);
-    cpu->isar.id_dfr0 = 0x00100000;
+    SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00000030;
     cpu->isar.id_mmfr1 = 0x00000000;
@@ -150,7 +150,7 @@ static void cortex_m7_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000040;
     SET_IDREG(isar, ID_PFR0, 0x00000030);
     SET_IDREG(isar, ID_PFR1, 0x00000200);
-    cpu->isar.id_dfr0 = 0x00100000;
+    SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00100030;
     cpu->isar.id_mmfr1 = 0x00000000;
@@ -183,7 +183,7 @@ static void cortex_m33_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000040;
     SET_IDREG(isar, ID_PFR0, 0x00000030);
     SET_IDREG(isar, ID_PFR1, 0x00000210);
-    cpu->isar.id_dfr0 = 0x00200000;
+    SET_IDREG(isar, ID_DFR0, 0x00200000);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00101F40;
     cpu->isar.id_mmfr1 = 0x00000000;
@@ -221,7 +221,7 @@ static void cortex_m55_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000040;
     SET_IDREG(isar, ID_PFR0, 0x20000030);
     SET_IDREG(isar, ID_PFR1, 0x00000230);
-    cpu->isar.id_dfr0 = 0x10200000;
+    SET_IDREG(isar, ID_DFR0, 0x10200000);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00111040;
     cpu->isar.id_mmfr1 = 0x00000000;
diff --git a/target/arm/tcg/cpu32.c b/target/arm/tcg/cpu32.c
index c4dbce75ef2a..a10b59f23550 100644
--- a/target/arm/tcg/cpu32.c
+++ b/target/arm/tcg/cpu32.c
@@ -82,11 +82,11 @@ void aa32_max_features(ARMCPU *cpu)
     t = FIELD_DP32(t, ID_PFR2, SSBS, 1);          /* FEAT_SSBS */
     SET_IDREG(isar, ID_PFR2, t);
 
-    t = cpu->isar.id_dfr0;
+    t = GET_IDREG(isar, ID_DFR0);
     t = FIELD_DP32(t, ID_DFR0, COPDBG, 10);       /* FEAT_Debugv8p8 */
     t = FIELD_DP32(t, ID_DFR0, COPSDBG, 10);      /* FEAT_Debugv8p8 */
     t = FIELD_DP32(t, ID_DFR0, PERFMON, 6);       /* FEAT_PMUv3p5 */
-    cpu->isar.id_dfr0 = t;
+    SET_IDREG(isar, ID_DFR0, t);
 
     /* Debug ID registers. */
 
@@ -116,9 +116,7 @@ void aa32_max_features(ARMCPU *cpu)
     t = FIELD_DP32(t, DBGDEVID1, PCSROFFSET, 2);
     cpu->isar.dbgdevid1 = t;
 
-    t = cpu->isar.id_dfr1;
-    t = FIELD_DP32(t, ID_DFR1, HPMN0, 1);         /* FEAT_HPMN0 */
-    cpu->isar.id_dfr1 = t;
+    FIELD_DP32_IDREG(isar, ID_DFR1, HPMN0, 1);         /* FEAT_HPMN0 */
 }
 
 /* CPU models. These are not needed for the AArch64 linux-user build. */
@@ -230,7 +228,7 @@ static void arm1136_r2_initfn(Object *obj)
     cpu->reset_sctlr = 0x00050078;
     SET_IDREG(isar, ID_PFR0, 0x111);
     SET_IDREG(isar, ID_PFR1, 0x1);
-    cpu->isar.id_dfr0 = 0x2;
+    SET_IDREG(isar, ID_DFR0, 0x2);
     cpu->id_afr0 = 0x3;
     cpu->isar.id_mmfr0 = 0x01130003;
     cpu->isar.id_mmfr1 = 0x10030302;
@@ -262,7 +260,7 @@ static void arm1136_initfn(Object *obj)
     cpu->reset_sctlr = 0x00050078;
     SET_IDREG(isar, ID_PFR0, 0x111);
     SET_IDREG(isar, ID_PFR1, 0x1);
-    cpu->isar.id_dfr0 = 0x2;
+    SET_IDREG(isar, ID_DFR0, 0x2);
     cpu->id_afr0 = 0x3;
     cpu->isar.id_mmfr0 = 0x01130003;
     cpu->isar.id_mmfr1 = 0x10030302;
@@ -295,7 +293,7 @@ static void arm1176_initfn(Object *obj)
     cpu->reset_sctlr = 0x00050078;
     SET_IDREG(isar, ID_PFR0, 0x111);
     SET_IDREG(isar, ID_PFR1, 0x11);
-    cpu->isar.id_dfr0 = 0x33;
+    SET_IDREG(isar, ID_DFR0, 0x33);
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x01130003;
     cpu->isar.id_mmfr1 = 0x10030302;
@@ -325,7 +323,7 @@ static void arm11mpcore_initfn(Object *obj)
     cpu->ctr = 0x1d192992; /* 32K icache 32K dcache */
     SET_IDREG(isar, ID_PFR0, 0x111);
     SET_IDREG(isar, ID_PFR1, 0x1);
-    cpu->isar.id_dfr0 = 0;
+    SET_IDREG(isar, ID_DFR0, 0);
     cpu->id_afr0 = 0x2;
     cpu->isar.id_mmfr0 = 0x01100103;
     cpu->isar.id_mmfr1 = 0x10020302;
@@ -365,7 +363,7 @@ static void cortex_a8_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50078;
     SET_IDREG(isar, ID_PFR0, 0x1031);
     SET_IDREG(isar, ID_PFR1, 0x11);
-    cpu->isar.id_dfr0 = 0x400;
+    SET_IDREG(isar, ID_DFR0, 0x400);
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x31100003;
     cpu->isar.id_mmfr1 = 0x20000000;
@@ -441,7 +439,7 @@ static void cortex_a9_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50078;
     SET_IDREG(isar, ID_PFR0, 0x1031);
     SET_IDREG(isar, ID_PFR1, 0x11);
-    cpu->isar.id_dfr0 = 0x000;
+    SET_IDREG(isar, ID_DFR0, 0x000);
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x00100103;
     cpu->isar.id_mmfr1 = 0x20000000;
@@ -507,7 +505,7 @@ static void cortex_a7_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50078;
     SET_IDREG(isar, ID_PFR0, 0x00001131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
-    cpu->isar.id_dfr0 = 0x02010555;
+    SET_IDREG(isar, ID_DFR0, 0x02010555);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
     cpu->isar.id_mmfr1 = 0x40000000;
@@ -559,7 +557,7 @@ static void cortex_a15_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50078;
     SET_IDREG(isar, ID_PFR0, 0x00001131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
-    cpu->isar.id_dfr0 = 0x02010555;
+    SET_IDREG(isar, ID_DFR0, 0x02010555);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10201105;
     cpu->isar.id_mmfr1 = 0x20000000;
@@ -603,7 +601,7 @@ static void cortex_r5_initfn(Object *obj)
     cpu->midr = 0x411fc153; /* r1p3 */
     SET_IDREG(isar, ID_PFR0, 0x0131);
     SET_IDREG(isar, ID_PFR1, 0x001);
-    cpu->isar.id_dfr0 = 0x010400;
+    SET_IDREG(isar, ID_DFR0, 0x010400);
     cpu->id_afr0 = 0x0;
     cpu->isar.id_mmfr0 = 0x0210030;
     cpu->isar.id_mmfr1 = 0x00000000;
@@ -750,7 +748,7 @@ static void cortex_r52_initfn(Object *obj)
     cpu->reset_sctlr = 0x30c50838;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
     SET_IDREG(isar, ID_PFR1, 0x10111001);
-    cpu->isar.id_dfr0 = 0x03010006;
+    SET_IDREG(isar, ID_DFR0, 0x03010006);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x00211040;
     cpu->isar.id_mmfr1 = 0x40000000;
@@ -982,7 +980,7 @@ static void arm_max_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50838;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
-    cpu->isar.id_dfr0 = 0x03010066;
+    SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10101105;
     cpu->isar.id_mmfr1 = 0x40000000;
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index cfaf01fbf9bc..738826a7bf97 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -51,7 +51,7 @@ static void aarch64_a35_initfn(Object *obj)
     cpu->ctr = 0x84448004;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
-    cpu->isar.id_dfr0 = 0x03010066;
+    SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0;
     cpu->isar.id_mmfr0 = 0x10201105;
     cpu->isar.id_mmfr1 = 0x40000000;
@@ -228,7 +228,7 @@ static void aarch64_a55_initfn(Object *obj)
     SET_IDREG(isar, ID_AA64PFR0, 0x0000000010112222ull);
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000010ull);
     cpu->id_afr0       = 0x00000000;
-    cpu->isar.id_dfr0  = 0x04010088;
+    SET_IDREG(isar, ID_DFR0, 0x04010088);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
@@ -297,7 +297,7 @@ static void aarch64_a72_initfn(Object *obj)
     cpu->reset_sctlr = 0x00c50838;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
-    cpu->isar.id_dfr0 = 0x03010066;
+    SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
     cpu->isar.id_mmfr0 = 0x10201105;
     cpu->isar.id_mmfr1 = 0x40000000;
@@ -361,7 +361,7 @@ static void aarch64_a76_initfn(Object *obj)
     SET_IDREG(isar, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000010ull);
     cpu->id_afr0       = 0x00000000;
-    cpu->isar.id_dfr0  = 0x04010088;
+    SET_IDREG(isar, ID_DFR0, 0x04010088);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
@@ -609,7 +609,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     SET_IDREG(isar, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000020ull);
     cpu->id_afr0       = 0x00000000;
-    cpu->isar.id_dfr0  = 0x04010088;
+    SET_IDREG(isar, ID_DFR0, 0x04010088);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
@@ -688,7 +688,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     SET_IDREG(isar, ID_AA64PFR0, 0x1101110120111112ull); /* GIC filled in later */
     SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000020ull);
     cpu->id_afr0       = 0x00000000;
-    cpu->isar.id_dfr0  = 0x15011099;
+    SET_IDREG(isar, ID_DFR0, 0x15011099);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
@@ -904,7 +904,7 @@ static void aarch64_a710_initfn(Object *obj)
     cpu->revidr        = 0;
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
-    cpu->isar.id_dfr0  = 0x16011099;
+    SET_IDREG(isar, ID_DFR0, 0x16011099);
     cpu->id_afr0       = 0;
     cpu->isar.id_mmfr0 = 0x10201105;
     cpu->isar.id_mmfr1 = 0x40000000;
@@ -1007,7 +1007,7 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     cpu->revidr        = 0;
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
-    cpu->isar.id_dfr0  = 0x16011099;
+    SET_IDREG(isar, ID_DFR0, 0x16011099);
     cpu->id_afr0       = 0;
     cpu->isar.id_mmfr0 = 0x10201105;
     cpu->isar.id_mmfr1 = 0x40000000;
-- 
2.48.1

