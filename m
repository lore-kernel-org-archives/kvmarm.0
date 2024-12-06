Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1F4192B8F
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 11:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484185; cv=none; b=jjzhBZg6c6K06GcVEvFFct8pNQ4ewG+GMcn5UPUnSc98dTwUVuvwZcbKunnjeMSrNzrlazN2ATyYN2N5dezd1GVJowl8jNtsdIgqlbN59hbWrRoR3SudvXLsZMSmNzV7Csh1K8Q1JLv5sHRoxH8tV152BWMR2YaeS5C5pLLAJrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484185; c=relaxed/simple;
	bh=8rtZ9qNg3B3sRxpuyLdeYPO+3ECJmTz0Q/jhPaaGQXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=HUuDZUMm/iXy8DouQFjyeiEUvyupOw6IE0sJ+oUaVjLDVtytvlllhOuSJV8c4bAeXoJKGNjL3S0DpYySPRh4wUi+pVMF7AOllFauaEnr3o03tIBu/W//iA+upQSWzC1VtjOpb3ulXlgyFOJ2eSDQtoQ1iZd7rZl+nG77CX0Smbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K6AyMLX4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K6AyMLX4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733484182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mz11dZSU8mrTAeVrJaqKvlG46gvObwsj2mjB/J0iqXM=;
	b=K6AyMLX4dy1VgXpayI0lw9v7bt66PETvfhcKsuKvLoswL+5BIYxhk8dYsRPkEwcQt74Nwq
	NoT8GbbjrBkqJioDJpTGG5kTxrdGcyY282oNrRD4aS1yzUiMNSnsi/yF+usG82lAeKI4eL
	ccdKZrBuDbc8cLJ/uoLYYSTjoXNDuI4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-8CC7wBt0P4qNVEM0wdICtw-1; Fri,
 06 Dec 2024 06:22:59 -0500
X-MC-Unique: 8CC7wBt0P4qNVEM0wdICtw-1
X-Mimecast-MFC-AGG-ID: 8CC7wBt0P4qNVEM0wdICtw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60395195609F;
	Fri,  6 Dec 2024 11:22:57 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C0BB319560A2;
	Fri,  6 Dec 2024 11:22:51 +0000 (UTC)
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
	jdenemar@redhat.com
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFCv2 05/20] arm/cpu: Store aa64drf0/1 into the idregs array
Date: Fri,  6 Dec 2024 12:21:58 +0100
Message-ID: <20241206112213.88394-6-cohuck@redhat.com>
In-Reply-To: <20241206112213.88394-1-cohuck@redhat.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Eric Auger <eric.auger@redhat.com>

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-features.h | 40 ++++++++++++++++-----------------
 target/arm/cpu.c          | 29 ++++++++----------------
 target/arm/cpu.h          |  5 +++--
 target/arm/cpu64.c        | 14 ++++--------
 target/arm/helper.c       |  6 ++---
 target/arm/kvm.c          | 24 +++++++++-----------
 target/arm/tcg/cpu64.c    | 47 ++++++++++++++++++---------------------
 7 files changed, 71 insertions(+), 94 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 357be7d0c3b3..406452ef9fba 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -596,68 +596,68 @@ static inline bool isar_feature_aa64_mops(const ARMISARegisters *id)
 static inline bool isar_feature_aa64_fp_simd(const ARMISARegisters *id)
 {
     /* We always set the AdvSIMD and FP fields identically.  */
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, FP) != 0xf;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, FP) != 0xf;
 }
 
 static inline bool isar_feature_aa64_fp16(const ARMISARegisters *id)
 {
     /* We always set the AdvSIMD and FP fields identically wrt FP16.  */
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, FP) == 1;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, FP) == 1;
 }
 
 static inline bool isar_feature_aa64_aa32(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, EL0) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, EL0) >= 2;
 }
 
 static inline bool isar_feature_aa64_aa32_el1(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, EL1) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, EL1) >= 2;
 }
 
 static inline bool isar_feature_aa64_aa32_el2(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, EL2) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, EL2) >= 2;
 }
 
 static inline bool isar_feature_aa64_ras(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, RAS) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, RAS) != 0;
 }
 
 static inline bool isar_feature_aa64_doublefault(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, RAS) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, RAS) >= 2;
 }
 
 static inline bool isar_feature_aa64_sve(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, SVE) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, SVE) != 0;
 }
 
 static inline bool isar_feature_aa64_sel2(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, SEL2) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, SEL2) != 0;
 }
 
 static inline bool isar_feature_aa64_rme(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, RME) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, RME) != 0;
 }
 
 static inline bool isar_feature_aa64_dit(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, DIT) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, DIT) != 0;
 }
 
 static inline bool isar_feature_aa64_scxtnum(const ARMISARegisters *id)
 {
-    int key = FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, CSV2);
+    int key = FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR0, CSV2);
     if (key >= 2) {
         return true;      /* FEAT_CSV2_2 */
     }
     if (key == 1) {
-        key = FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, CSV2_FRAC);
+        key = FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, CSV2_FRAC);
         return key >= 2;  /* FEAT_CSV2_1p2 */
     }
     return false;
@@ -665,37 +665,37 @@ static inline bool isar_feature_aa64_scxtnum(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa64_ssbs(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, SSBS) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, SSBS) != 0;
 }
 
 static inline bool isar_feature_aa64_bti(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, BT) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, BT) != 0;
 }
 
 static inline bool isar_feature_aa64_mte_insn_reg(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, MTE) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, MTE) != 0;
 }
 
 static inline bool isar_feature_aa64_mte(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, MTE) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, MTE) >= 2;
 }
 
 static inline bool isar_feature_aa64_mte3(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, MTE) >= 3;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, MTE) >= 3;
 }
 
 static inline bool isar_feature_aa64_sme(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, SME) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, SME) != 0;
 }
 
 static inline bool isar_feature_aa64_nmi(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, NMI) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64PFR1, NMI) != 0;
 }
 
 static inline bool isar_feature_aa64_tgran4_lpa2(const ARMISARegisters *id)
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index de13b50cae58..bcbb8b8733aa 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2130,14 +2130,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 
     if (!cpu->has_vfp) {
-        uint64_t t;
         uint32_t u;
 
         FIELD_DP64_IDREG(idregs, ID_AA64ISAR1, JSCVT, 0);
 
-        t = cpu->isar.id_aa64pfr0;
-        t = FIELD_DP64(t, ID_AA64PFR0, FP, 0xf);
-        cpu->isar.id_aa64pfr0 = t;
+        FIELD_DP64_IDREG(idregs, ID_AA64PFR0, FP, 0xf);
 
         u = cpu->isar.id_isar6;
         u = FIELD_DP32(u, ID_ISAR6, JSCVT, 0);
@@ -2192,9 +2189,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         t = FIELD_DP64(t, ID_AA64ISAR1, I8MM, 0);
         SET_IDREG(idregs, ID_AA64ISAR1, t);
 
-        t = cpu->isar.id_aa64pfr0;
-        t = FIELD_DP64(t, ID_AA64PFR0, ADVSIMD, 0xf);
-        cpu->isar.id_aa64pfr0 = t;
+        FIELD_DP64_IDREG(idregs, ID_AA64PFR0, ADVSIMD, 0xf);
 
         u = cpu->isar.id_isar5;
         u = FIELD_DP32(u, ID_ISAR5, AES, 0);
@@ -2336,12 +2331,10 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          */
         cpu->isar.id_pfr1 = FIELD_DP32(cpu->isar.id_pfr1, ID_PFR1, SECURITY, 0);
         cpu->isar.id_dfr0 = FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, COPSDBG, 0);
-        cpu->isar.id_aa64pfr0 = FIELD_DP64(cpu->isar.id_aa64pfr0,
-                                           ID_AA64PFR0, EL3, 0);
+        FIELD_DP64_IDREG(idregs, ID_AA64PFR0, EL3, 0);
 
         /* Disable the realm management extension, which requires EL3. */
-        cpu->isar.id_aa64pfr0 = FIELD_DP64(cpu->isar.id_aa64pfr0,
-                                           ID_AA64PFR0, RME, 0);
+        FIELD_DP64_IDREG(idregs, ID_AA64PFR0, RME, 0);
     }
 
     if (!cpu->has_el2) {
@@ -2376,8 +2369,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          * Disable the hypervisor feature bits in the processor feature
          * registers if we don't have EL2.
          */
-        cpu->isar.id_aa64pfr0 = FIELD_DP64(cpu->isar.id_aa64pfr0,
-                                           ID_AA64PFR0, EL2, 0);
+        FIELD_DP64_IDREG(idregs, ID_AA64PFR0, EL2, 0);
         cpu->isar.id_pfr1 = FIELD_DP32(cpu->isar.id_pfr1,
                                        ID_PFR1, VIRTUALIZATION, 0);
     }
@@ -2398,8 +2390,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          * This matches Cortex-A710 BROADCASTMTE input being LOW.
          */
         if (tcg_enabled() && cpu->tag_memory == NULL) {
-            cpu->isar.id_aa64pfr1 =
-                FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 1);
+            FIELD_DP64_IDREG(idregs, ID_AA64PFR1, MTE, 1);
         }
 
         /*
@@ -2407,7 +2398,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
          * enabled on the guest (i.e mte=off), clear guest's MTE bits."
          */
         if (kvm_enabled() && !cpu->kvm_mte) {
-                FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
+                FIELD_DP64_IDREG(idregs, ID_AA64PFR1, MTE, 0);
         }
 #endif
     }
@@ -2446,13 +2437,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         cpu->isar.id_dfr0 =
             FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, MMAPTRC, 0);
         /* FEAT_AMU (Activity Monitors Extension) */
-        cpu->isar.id_aa64pfr0 =
-            FIELD_DP64(cpu->isar.id_aa64pfr0, ID_AA64PFR0, AMU, 0);
+        FIELD_DP64_IDREG(idregs, ID_AA64PFR0, AMU, 0);
         cpu->isar.id_pfr0 =
             FIELD_DP32(cpu->isar.id_pfr0, ID_PFR0, AMU, 0);
         /* FEAT_MPAM (Memory Partitioning and Monitoring Extension) */
-        cpu->isar.id_aa64pfr0 =
-            FIELD_DP64(cpu->isar.id_aa64pfr0, ID_AA64PFR0, MPAM, 0);
+        FIELD_DP64_IDREG(idregs, ID_AA64PFR0, MPAM, 0);
     }
 
     /* MPU can be configured out of a PMSA CPU either by setting has-mpu
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index c671b5058a96..8c841988c5ad 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -881,6 +881,9 @@ _set_idreg(MAP, SYS_ ## REG ## _EL1, regval);                 \
 #define FIELD_EX64_IDREG(MAP, REG, FIELD)                     \
 FIELD_EX64(_get_idreg(MAP, SYS_ ## REG ## _EL1), REG, FIELD)  \
 
+#define FIELD_EX32_IDREG(MAP, REG, FIELD)                     \
+FIELD_EX32(_get_idreg(MAP, SYS_ ## REG ## _EL1), REG, FIELD)  \
+
 #define SET_IDREG(MAP, REG, VALUE)                            \
 _set_idreg(MAP, SYS_ ## REG ## _EL1, VALUE)
 
@@ -1091,8 +1094,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64pfr0;
-        uint64_t id_aa64pfr1;
         uint64_t id_aa64mmfr0;
         uint64_t id_aa64mmfr1;
         uint64_t id_aa64mmfr2;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index c5f2ce6f5f8f..48b4a08a4a7b 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -288,16 +288,13 @@ static bool cpu_arm_get_sve(Object *obj, Error **errp)
 static void cpu_arm_set_sve(Object *obj, bool value, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t t;
 
     if (value && kvm_enabled() && !kvm_arm_sve_supported()) {
         error_setg(errp, "'sve' feature not supported by KVM on this host");
         return;
     }
 
-    t = cpu->isar.id_aa64pfr0;
-    t = FIELD_DP64(t, ID_AA64PFR0, SVE, value);
-    cpu->isar.id_aa64pfr0 = t;
+    FIELD_DP64_IDREG(&cpu->isar.idregs, ID_AA64PFR0, SVE, value);
 }
 
 void arm_cpu_sme_finalize(ARMCPU *cpu, Error **errp)
@@ -348,11 +345,8 @@ static bool cpu_arm_get_sme(Object *obj, Error **errp)
 static void cpu_arm_set_sme(Object *obj, bool value, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t t;
 
-    t = cpu->isar.id_aa64pfr1;
-    t = FIELD_DP64(t, ID_AA64PFR1, SME, value);
-    cpu->isar.id_aa64pfr1 = t;
+    FIELD_DP64_IDREG(&cpu->isar.idregs, ID_AA64PFR1, SME, value);
 }
 
 static bool cpu_arm_get_sme_fa64(Object *obj, Error **errp)
@@ -636,7 +630,7 @@ static void aarch64_a57_initfn(Object *obj)
     cpu->isar.id_isar4 = 0x00011142;
     cpu->isar.id_isar5 = 0x00011121;
     cpu->isar.id_isar6 = 0;
-    cpu->isar.id_aa64pfr0 = 0x00002222;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x00002222);
     cpu->isar.id_aa64dfr0 = 0x10305106;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     cpu->isar.id_aa64mmfr0 = 0x00001124;
@@ -698,7 +692,7 @@ static void aarch64_a53_initfn(Object *obj)
     cpu->isar.id_isar4 = 0x00011142;
     cpu->isar.id_isar5 = 0x00011121;
     cpu->isar.id_isar6 = 0;
-    cpu->isar.id_aa64pfr0 = 0x00002222;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x00002222);
     cpu->isar.id_aa64dfr0 = 0x10305106;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     cpu->isar.id_aa64mmfr0 = 0x00001122; /* 40 bit physical addr */
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 09d635f8bf24..be9cc22a3ffc 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7706,7 +7706,7 @@ static uint64_t id_pfr1_read(CPUARMState *env, const ARMCPRegInfo *ri)
 static uint64_t id_aa64pfr0_read(CPUARMState *env, const ARMCPRegInfo *ri)
 {
     ARMCPU *cpu = env_archcpu(env);
-    uint64_t pfr0 = cpu->isar.id_aa64pfr0;
+    uint64_t pfr0 = GET_IDREG(&cpu->isar.idregs, ID_AA64PFR0);
 
     if (env->gicv3state) {
         pfr0 |= 1 << 24;
@@ -8886,7 +8886,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .access = PL1_R,
 #ifdef CONFIG_USER_ONLY
               .type = ARM_CP_CONST,
-              .resetvalue = cpu->isar.id_aa64pfr0
+              .resetvalue = GET_IDREG(idregs, ID_AA64PFR0)
 #else
               .type = ARM_CP_NO_RAW,
               .accessfn = access_aa64_tid3,
@@ -8898,7 +8898,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 1,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64pfr1},
+              .resetvalue = GET_IDREG(idregs, ID_AA64PFR1)},
             { .name = "ID_AA64PFR2_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 2,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 35161659b040..a7d0aac63ae9 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -322,8 +322,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     ahcf->dtb_compatible = "arm,arm-v8";
     int fd = fdarray[2];
 
-    err = read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64pfr0,
-                         ARM64_SYS_REG(3, 0, 0, 4, 0));
+    err = get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64PFR0_EL1);
     if (unlikely(err < 0)) {
         /*
          * Before v4.15, the kernel only exposed a limited number of system
@@ -341,11 +340,10 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
          * ??? Either of these sounds like too much effort just
          *     to work around running a modern host kernel.
          */
-        ahcf->isar.id_aa64pfr0 = 0x00000011; /* EL1&0, AArch64 only */
+        SET_IDREG(&ahcf->isar.idregs, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
         err = 0;
     } else {
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64pfr1,
-                              ARM64_SYS_REG(3, 0, 0, 4, 1));
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64PFR1_EL1);
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64smfr0,
                               ARM64_SYS_REG(3, 0, 0, 4, 5));
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr0,
@@ -371,10 +369,8 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
          * than skipping the reads and leaving 0, as we must avoid
          * considering the values in every case.
          */
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr0,
-                              ARM64_SYS_REG(3, 0, 0, 1, 0));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr1,
-                              ARM64_SYS_REG(3, 0, 0, 1, 1));
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64PFR0_EL1);
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64PFR1_EL1);
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_dfr0,
                               ARM64_SYS_REG(3, 0, 0, 1, 2));
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr0,
@@ -425,14 +421,14 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
          * arch/arm64/kvm/sys_regs.c:trap_dbgidr() does.
          * We only do this if the CPU supports AArch32 at EL1.
          */
-        if (FIELD_EX32(ahcf->isar.id_aa64pfr0, ID_AA64PFR0, EL1) >= 2) {
-            int wrps = FIELD_EX64(ahcf->isar.id_aa64dfr0, ID_AA64DFR0, WRPS);
-            int brps = FIELD_EX64(ahcf->isar.id_aa64dfr0, ID_AA64DFR0, BRPS);
+        if (FIELD_EX32_IDREG(&ahcf->isar.idregs, ID_AA64PFR0, EL1) >= 2) {
+            int wrps = FIELD_EX64_IDREG(&ahcf->isar.idregs, ID_AA64DFR0, WRPS);
+            int brps = FIELD_EX64_IDREG(&ahcf->isar.idregs, ID_AA64DFR0, BRPS);
             int ctx_cmps =
-                FIELD_EX64(ahcf->isar.id_aa64dfr0, ID_AA64DFR0, CTX_CMPS);
+                FIELD_EX64_IDREG(&ahcf->isar.idregs, ID_AA64DFR0, CTX_CMPS);
             int version = 6; /* ARMv8 debug architecture */
             bool has_el3 =
-                !!FIELD_EX32(ahcf->isar.id_aa64pfr0, ID_AA64PFR0, EL3);
+                !!FIELD_EX32_IDREG(&ahcf->isar.idregs, ID_AA64PFR0, EL3);
             uint32_t dbgdidr = 0;
 
             dbgdidr = FIELD_DP32(dbgdidr, DBGDIDR, WRPS, wrps);
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 8e48ddc06f16..827ac0200211 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -63,8 +63,8 @@ static void aarch64_a35_initfn(Object *obj)
     cpu->isar.id_isar3 = 0x01112131;
     cpu->isar.id_isar4 = 0x00011142;
     cpu->isar.id_isar5 = 0x00011121;
-    cpu->isar.id_aa64pfr0 = 0x00002222;
-    cpu->isar.id_aa64pfr1 = 0;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x00002222);
+    SET_IDREG(idregs, ID_AA64PFR1, 0);
     cpu->isar.id_aa64dfr0 = 0x10305106;
     cpu->isar.id_aa64dfr1 = 0;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
@@ -158,11 +158,8 @@ static bool cpu_arm_get_rme(Object *obj, Error **errp)
 static void cpu_arm_set_rme(Object *obj, bool value, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t t;
 
-    t = cpu->isar.id_aa64pfr0;
-    t = FIELD_DP64(t, ID_AA64PFR0, RME, value);
-    cpu->isar.id_aa64pfr0 = t;
+    FIELD_DP64_IDREG(&cpu->isar.idregs, ID_AA64PFR0, RME, value);
 }
 
 static void cpu_max_set_l0gptsz(Object *obj, Visitor *v, const char *name,
@@ -228,8 +225,8 @@ static void aarch64_a55_initfn(Object *obj)
     cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
-    cpu->isar.id_aa64pfr0  = 0x0000000010112222ull;
-    cpu->isar.id_aa64pfr1  = 0x0000000000000010ull;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x0000000010112222ull);
+    SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000010ull);
     cpu->id_afr0       = 0x00000000;
     cpu->isar.id_dfr0  = 0x04010088;
     cpu->isar.id_isar0 = 0x02101110;
@@ -312,7 +309,7 @@ static void aarch64_a72_initfn(Object *obj)
     cpu->isar.id_isar3 = 0x01112131;
     cpu->isar.id_isar4 = 0x00011142;
     cpu->isar.id_isar5 = 0x00011121;
-    cpu->isar.id_aa64pfr0 = 0x00002222;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x00002222);
     cpu->isar.id_aa64dfr0 = 0x10305106;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     cpu->isar.id_aa64mmfr0 = 0x00001124;
@@ -361,8 +358,8 @@ static void aarch64_a76_initfn(Object *obj)
     cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
-    cpu->isar.id_aa64pfr0  = 0x1100000010111112ull; /* GIC filled in later */
-    cpu->isar.id_aa64pfr1  = 0x0000000000000010ull;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
+    SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000010ull);
     cpu->id_afr0       = 0x00000000;
     cpu->isar.id_dfr0  = 0x04010088;
     cpu->isar.id_isar0 = 0x02101110;
@@ -427,8 +424,8 @@ static void aarch64_a64fx_initfn(Object *obj)
     cpu->revidr = 0x00000000;
     cpu->ctr = 0x86668006;
     cpu->reset_sctlr = 0x30000180;
-    cpu->isar.id_aa64pfr0 =   0x0000000101111111; /* No RAS Extensions */
-    cpu->isar.id_aa64pfr1 = 0x0000000000000000;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x0000000101111111); /* No RAS Extensions */
+    SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000000);
     cpu->isar.id_aa64dfr0 = 0x0000000010305408;
     cpu->isar.id_aa64dfr1 = 0x0000000000000000;
     cpu->id_aa64afr0 = 0x0000000000000000;
@@ -609,8 +606,8 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
-    cpu->isar.id_aa64pfr0  = 0x1100000010111112ull; /* GIC filled in later */
-    cpu->isar.id_aa64pfr1  = 0x0000000000000020ull;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
+    SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000020ull);
     cpu->id_afr0       = 0x00000000;
     cpu->isar.id_dfr0  = 0x04010088;
     cpu->isar.id_isar0 = 0x02101110;
@@ -688,8 +685,8 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
     cpu->isar.id_aa64mmfr2 = 0x0220011102101011ull;
-    cpu->isar.id_aa64pfr0  = 0x1101110120111112ull; /* GIC filled in later */
-    cpu->isar.id_aa64pfr1  = 0x0000000000000020ull;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x1101110120111112ull); /* GIC filled in later */
+    SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000020ull);
     cpu->id_afr0       = 0x00000000;
     cpu->isar.id_dfr0  = 0x15011099;
     cpu->isar.id_isar0 = 0x02101110;
@@ -925,8 +922,8 @@ static void aarch64_a710_initfn(Object *obj)
     cpu->isar.mvfr1    = 0x13211111;
     cpu->isar.mvfr2    = 0x00000043;
     cpu->isar.id_pfr2  = 0x00000011;
-    cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
-    cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
+    SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000221ull);
     SET_IDREG(idregs, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
     cpu->isar.id_aa64dfr0  = 0x000011f010305619ull;
     cpu->isar.id_aa64dfr1  = 0;
@@ -1027,8 +1024,8 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     cpu->isar.mvfr1    = 0x13211111;
     cpu->isar.mvfr2    = 0x00000043;
     cpu->isar.id_pfr2  = 0x00000011;
-    cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
-    cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
+    SET_IDREG(idregs, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
+    SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000221ull);
     SET_IDREG(idregs, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
     cpu->isar.id_aa64dfr0  = 0x000011f210305619ull;
     cpu->isar.id_aa64dfr1  = 0;
@@ -1181,7 +1178,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64ISAR2, WFXT, 2);     /* FEAT_WFxT */
     SET_IDREG(idregs, ID_AA64ISAR2, t);
 
-    t = cpu->isar.id_aa64pfr0;
+    t = GET_IDREG(idregs, ID_AA64PFR0);
     t = FIELD_DP64(t, ID_AA64PFR0, FP, 1);        /* FEAT_FP16 */
     t = FIELD_DP64(t, ID_AA64PFR0, ADVSIMD, 1);   /* FEAT_FP16 */
     t = FIELD_DP64(t, ID_AA64PFR0, RAS, 2);       /* FEAT_RASv1p1 + FEAT_DoubleFault */
@@ -1190,9 +1187,9 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64PFR0, DIT, 1);       /* FEAT_DIT */
     t = FIELD_DP64(t, ID_AA64PFR0, CSV2, 3);      /* FEAT_CSV2_3 */
     t = FIELD_DP64(t, ID_AA64PFR0, CSV3, 1);      /* FEAT_CSV3 */
-    cpu->isar.id_aa64pfr0 = t;
+    SET_IDREG(idregs, ID_AA64PFR0, t);
 
-    t = cpu->isar.id_aa64pfr1;
+    t = GET_IDREG(idregs, ID_AA64PFR1);
     t = FIELD_DP64(t, ID_AA64PFR1, BT, 1);        /* FEAT_BTI */
     t = FIELD_DP64(t, ID_AA64PFR1, SSBS, 2);      /* FEAT_SSBS2 */
     /*
@@ -1205,7 +1202,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64PFR1, SME, 1);       /* FEAT_SME */
     t = FIELD_DP64(t, ID_AA64PFR1, CSV2_FRAC, 0); /* FEAT_CSV2_3 */
     t = FIELD_DP64(t, ID_AA64PFR1, NMI, 1);       /* FEAT_NMI */
-    cpu->isar.id_aa64pfr1 = t;
+    SET_IDREG(idregs, ID_AA64PFR1, t);
 
     t = cpu->isar.id_aa64mmfr0;
     t = FIELD_DP64(t, ID_AA64MMFR0, PARANGE, 6); /* FEAT_LPA: 52 bits */
-- 
2.47.0

