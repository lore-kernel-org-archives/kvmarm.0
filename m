Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED32C154C05
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 11:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738926248; cv=none; b=is6HSs3YBkBujWcgz8l6U/mh72Ff2RqNDRMCt28TfRHou5V1R1jM+Aym7PTf3WRgKW59RVM68K7WbF8dBeLhBqbqR43kESybtj3CnRJaCLZHPqniVFKb+9Ob5Ji67iHj+pcfYZBLYnR69KtlY664Q+e5+rYOzUKn26EgIsqxQwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738926248; c=relaxed/simple;
	bh=Rncl/AO4mbKn+fmQ63L26bREqK47SieEpU+jdJybCNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=mzrKB2eAWNPR+0oMZE1ociZIfRGQndgdnd6/IFeCJzUAk1eFNsTBgWd94BjShZtuSCddkcnAE3IVMK1u5atjB1jp2TVBkGa1Ds0VOBVaR7Rk41gozQZRBDx858A3H6CNd4Gt1CXJK5sDU+WwGnl/t11Zqt8b07R214qcPKlhIF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SXYbzwnS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SXYbzwnS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738926244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FnU/J9rZ6MiGZqkrYmzcHfdXrKK6uXizzUNcsvtrI3Q=;
	b=SXYbzwnSDlHU2CKAnYiV+yjePTTGny3Feh2YZaLl2ZfxGOGeaMfSQXyLpl41zlXVenLZ/6
	P49cSOpmRG1kI1Z8DBteA9UfszHSaMesYSWXLZ7iUnE0xIS0RroawNig4yR5wmOyIOnnGx
	P8zrxXg50w4CUyY6U66wKCUhAMou4m0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-zWHQkSIrMM2Aa418gW3yhw-1; Fri,
 07 Feb 2025 06:04:00 -0500
X-MC-Unique: zWHQkSIrMM2Aa418gW3yhw-1
X-Mimecast-MFC-AGG-ID: zWHQkSIrMM2Aa418gW3yhw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98A541955D4F;
	Fri,  7 Feb 2025 11:03:58 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.130])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CA03519560A3;
	Fri,  7 Feb 2025 11:03:43 +0000 (UTC)
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
Subject: [PATCH 03/15] arm/cpu: Store aa64isar0 into the idregs arrays
Date: Fri,  7 Feb 2025 12:02:36 +0100
Message-ID: <20250207110248.1580465-4-cohuck@redhat.com>
In-Reply-To: <20250207110248.1580465-1-cohuck@redhat.com>
References: <20250207110248.1580465-1-cohuck@redhat.com>
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

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-features.h | 57 ++++++++++++++++++++-------------------
 target/arm/cpu.c          | 14 ++++------
 target/arm/cpu.h          |  2 --
 target/arm/cpu64.c        |  8 +++---
 target/arm/helper.c       |  6 +++--
 target/arm/kvm.c          |  8 +++---
 target/arm/tcg/cpu64.c    | 44 ++++++++++++++++++------------
 7 files changed, 74 insertions(+), 65 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 30302d6c5b41..9638c9428db3 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -22,6 +22,7 @@
 
 #include "hw/registerfields.h"
 #include "qemu/host-utils.h"
+#include "cpu-sysregs.h"
 
 /*
  * Naming convention for isar_feature functions:
@@ -376,92 +377,92 @@ static inline bool isar_feature_aa32_doublelock(const ARMISARegisters *id)
  */
 static inline bool isar_feature_aa64_aes(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, AES) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, AES) != 0;
 }
 
 static inline bool isar_feature_aa64_pmull(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, AES) > 1;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, AES) > 1;
 }
 
 static inline bool isar_feature_aa64_sha1(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, SHA1) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, SHA1) != 0;
 }
 
 static inline bool isar_feature_aa64_sha256(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, SHA2) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, SHA2) != 0;
 }
 
 static inline bool isar_feature_aa64_sha512(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, SHA2) > 1;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, SHA2) > 1;
 }
 
 static inline bool isar_feature_aa64_crc32(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, CRC32) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, CRC32) != 0;
 }
 
 static inline bool isar_feature_aa64_atomics(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, ATOMIC) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, ATOMIC) != 0;
 }
 
 static inline bool isar_feature_aa64_rdm(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, RDM) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, RDM) != 0;
 }
 
 static inline bool isar_feature_aa64_sha3(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, SHA3) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, SHA3) != 0;
 }
 
 static inline bool isar_feature_aa64_sm3(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, SM3) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, SM3) != 0;
 }
 
 static inline bool isar_feature_aa64_sm4(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, SM4) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, SM4) != 0;
 }
 
 static inline bool isar_feature_aa64_dp(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, DP) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, DP) != 0;
 }
 
 static inline bool isar_feature_aa64_fhm(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, FHM) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, FHM) != 0;
 }
 
 static inline bool isar_feature_aa64_condm_4(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, TS) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, TS) != 0;
 }
 
 static inline bool isar_feature_aa64_condm_5(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, TS) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, TS) >= 2;
 }
 
 static inline bool isar_feature_aa64_rndr(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, RNDR) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, RNDR) != 0;
 }
 
 static inline bool isar_feature_aa64_tlbirange(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, TLB) == 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, TLB) == 2;
 }
 
 static inline bool isar_feature_aa64_tlbios(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64isar0, ID_AA64ISAR0, TLB) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ISAR0, TLB) != 0;
 }
 
 static inline bool isar_feature_aa64_jscvt(const ARMISARegisters *id)
@@ -917,52 +918,52 @@ static inline bool isar_feature_aa64_doublelock(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa64_sve2(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, SVEVER) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, SVEVER) != 0;
 }
 
 static inline bool isar_feature_aa64_sve2_aes(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, AES) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, AES) != 0;
 }
 
 static inline bool isar_feature_aa64_sve2_pmull128(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, AES) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, AES) >= 2;
 }
 
 static inline bool isar_feature_aa64_sve2_bitperm(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, BITPERM) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, BITPERM) != 0;
 }
 
 static inline bool isar_feature_aa64_sve_bf16(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, BFLOAT16) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, BFLOAT16) != 0;
 }
 
 static inline bool isar_feature_aa64_sve2_sha3(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, SHA3) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, SHA3) != 0;
 }
 
 static inline bool isar_feature_aa64_sve2_sm4(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, SM4) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, SM4) != 0;
 }
 
 static inline bool isar_feature_aa64_sve_i8mm(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, I8MM) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, I8MM) != 0;
 }
 
 static inline bool isar_feature_aa64_sve_f32mm(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, F32MM) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, F32MM) != 0;
 }
 
 static inline bool isar_feature_aa64_sve_f64mm(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64zfr0, ID_AA64ZFR0, F64MM) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64ZFR0, F64MM) != 0;
 }
 
 static inline bool isar_feature_aa64_sme_f64f64(const ARMISARegisters *id)
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 7a83b9ee34f7..861b7f893c0c 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1989,6 +1989,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
     ARMCPU *cpu = ARM_CPU(dev);
+    uint64_t *idregs = cpu->isar.idregs;
     ARMCPUClass *acc = ARM_CPU_GET_CLASS(dev);
     CPUARMState *env = &cpu->env;
     Error *local_err = NULL;
@@ -2190,7 +2191,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
 
         unset_feature(env, ARM_FEATURE_NEON);
 
-        t = cpu->isar.id_aa64isar0;
+        t = GET_IDREG(idregs, ID_AA64ISAR0);
         t = FIELD_DP64(t, ID_AA64ISAR0, AES, 0);
         t = FIELD_DP64(t, ID_AA64ISAR0, SHA1, 0);
         t = FIELD_DP64(t, ID_AA64ISAR0, SHA2, 0);
@@ -2198,7 +2199,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         t = FIELD_DP64(t, ID_AA64ISAR0, SM3, 0);
         t = FIELD_DP64(t, ID_AA64ISAR0, SM4, 0);
         t = FIELD_DP64(t, ID_AA64ISAR0, DP, 0);
-        cpu->isar.id_aa64isar0 = t;
+        SET_IDREG(idregs, ID_AA64ISAR0, t);
 
         t = cpu->isar.id_aa64isar1;
         t = FIELD_DP64(t, ID_AA64ISAR1, FCMA, 0);
@@ -2240,16 +2241,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 
     if (!cpu->has_neon && !cpu->has_vfp) {
-        uint64_t t;
         uint32_t u;
 
-        t = cpu->isar.id_aa64isar0;
-        t = FIELD_DP64(t, ID_AA64ISAR0, FHM, 0);
-        cpu->isar.id_aa64isar0 = t;
+        FIELD_DP64_IDREG(idregs, ID_AA64ISAR0, FHM, 0);
 
-        t = cpu->isar.id_aa64isar1;
-        t = FIELD_DP64(t, ID_AA64ISAR1, FRINTTS, 0);
-        cpu->isar.id_aa64isar1 = t;
+        FIELD_DP64_IDREG(idregs, ID_AA64ISAR1, FRINTTS, 0);
 
         u = cpu->isar.mvfr0;
         u = FIELD_DP32(u, MVFR0, SIMDREG, 0);
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 4bbce34e268d..cbc1804dbd32 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1067,7 +1067,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64isar0;
         uint64_t id_aa64isar1;
         uint64_t id_aa64isar2;
         uint64_t id_aa64pfr0;
@@ -1078,7 +1077,6 @@ struct ArchCPU {
         uint64_t id_aa64mmfr3;
         uint64_t id_aa64dfr0;
         uint64_t id_aa64dfr1;
-        uint64_t id_aa64zfr0;
         uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
         uint64_t idregs[NUM_ID_IDX];
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 9ae78253cb34..f582a8ae6cd1 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -114,7 +114,7 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
              * SVE is disabled and so are all vector lengths.  Good.
              * Disable all SVE extensions as well.
              */
-            cpu->isar.id_aa64zfr0 = 0;
+            SET_IDREG(&cpu->isar.idregs, ID_AA64ZFR0, 0);
             return;
         }
 
@@ -617,6 +617,7 @@ void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp)
 static void aarch64_a57_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,cortex-a57";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -654,7 +655,7 @@ static void aarch64_a57_initfn(Object *obj)
     cpu->isar.id_isar6 = 0;
     cpu->isar.id_aa64pfr0 = 0x00002222;
     cpu->isar.id_aa64dfr0 = 0x10305106;
-    cpu->isar.id_aa64isar0 = 0x00011120;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     cpu->isar.id_aa64mmfr0 = 0x00001124;
     cpu->isar.dbgdidr = 0x3516d000;
     cpu->isar.dbgdevid = 0x01110f13;
@@ -678,6 +679,7 @@ static void aarch64_a57_initfn(Object *obj)
 static void aarch64_a53_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,cortex-a53";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -715,7 +717,7 @@ static void aarch64_a53_initfn(Object *obj)
     cpu->isar.id_isar6 = 0;
     cpu->isar.id_aa64pfr0 = 0x00002222;
     cpu->isar.id_aa64dfr0 = 0x10305106;
-    cpu->isar.id_aa64isar0 = 0x00011120;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     cpu->isar.id_aa64mmfr0 = 0x00001122; /* 40 bit physical addr */
     cpu->isar.dbgdidr = 0x3516d000;
     cpu->isar.dbgdevid = 0x00110f13;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 40bdfc851a58..42800b62ceb4 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7529,6 +7529,8 @@ void register_cp_regs_for_features(ARMCPU *cpu)
 {
     /* Register all the coprocessor registers based on feature bits */
     CPUARMState *env = &cpu->env;
+    uint64_t *idregs = cpu->isar.idregs;
+
     if (arm_feature(env, ARM_FEATURE_M)) {
         /* M profile has no coprocessor registers */
         return;
@@ -7718,7 +7720,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 4,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64zfr0 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64ZFR0)},
             { .name = "ID_AA64SMFR0_EL1", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 5,
               .access = PL1_R, .type = ARM_CP_CONST,
@@ -7778,7 +7780,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 6, .opc2 = 0,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64isar0 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64ISAR0)},
             { .name = "ID_AA64ISAR1_EL1", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 6, .opc2 = 1,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 3b8bb5661f2b..c0cb81ea953c 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -26,6 +26,7 @@
 #include "system/kvm_int.h"
 #include "kvm_arm.h"
 #include "cpu.h"
+#include "cpu-sysregs.h"
 #include "trace.h"
 #include "internals.h"
 #include "hw/pci/pci.h"
@@ -336,6 +337,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 
     ahcf->target = init.target;
     ahcf->dtb_compatible = "arm,arm-v8";
+    int fd = fdarray[2];
 
     err = read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64pfr0,
                          ARM64_SYS_REG(3, 0, 0, 4, 0));
@@ -367,8 +369,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
                               ARM64_SYS_REG(3, 0, 0, 5, 0));
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr1,
                               ARM64_SYS_REG(3, 0, 0, 5, 1));
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar0,
-                              ARM64_SYS_REG(3, 0, 0, 6, 0));
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64ISAR0_EL1);
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar1,
                               ARM64_SYS_REG(3, 0, 0, 6, 1));
         err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar2,
@@ -477,8 +478,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
              * enabled SVE support, which resulted in an error rather than RAZ.
              * So only read the register if we set KVM_ARM_VCPU_SVE above.
              */
-            err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64zfr0,
-                                  ARM64_SYS_REG(3, 0, 0, 4, 4));
+            err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64ZFR0_EL1);
         }
     }
 
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 93573ceeb1a8..6eea7ca2fff6 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -32,6 +32,7 @@
 static void aarch64_a35_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,cortex-a35";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -66,7 +67,7 @@ static void aarch64_a35_initfn(Object *obj)
     cpu->isar.id_aa64pfr1 = 0;
     cpu->isar.id_aa64dfr0 = 0x10305106;
     cpu->isar.id_aa64dfr1 = 0;
-    cpu->isar.id_aa64isar0 = 0x00011120;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     cpu->isar.id_aa64isar1 = 0;
     cpu->isar.id_aa64mmfr0 = 0x00101122;
     cpu->isar.id_aa64mmfr1 = 0;
@@ -204,6 +205,7 @@ static const Property arm_cpu_lpa2_property =
 static void aarch64_a55_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,cortex-a55";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -221,7 +223,7 @@ static void aarch64_a55_initfn(Object *obj)
     cpu->ctr = 0x84448004; /* L1Ip = VIPT */
     cpu->dcz_blocksize = 4; /* 64 bytes */
     cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
-    cpu->isar.id_aa64isar0 = 0x0000100010211120ull;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x0000100010211120ull);
     cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
     cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
@@ -276,6 +278,7 @@ static void aarch64_a55_initfn(Object *obj)
 static void aarch64_a72_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,cortex-a72";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -311,7 +314,7 @@ static void aarch64_a72_initfn(Object *obj)
     cpu->isar.id_isar5 = 0x00011121;
     cpu->isar.id_aa64pfr0 = 0x00002222;
     cpu->isar.id_aa64dfr0 = 0x10305106;
-    cpu->isar.id_aa64isar0 = 0x00011120;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     cpu->isar.id_aa64mmfr0 = 0x00001124;
     cpu->isar.dbgdidr = 0x3516d000;
     cpu->isar.dbgdevid = 0x01110f13;
@@ -335,6 +338,7 @@ static void aarch64_a72_initfn(Object *obj)
 static void aarch64_a76_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,cortex-a76";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -352,7 +356,7 @@ static void aarch64_a76_initfn(Object *obj)
     cpu->ctr = 0x8444C004;
     cpu->dcz_blocksize = 4;
     cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
-    cpu->isar.id_aa64isar0 = 0x0000100010211120ull;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x0000100010211120ull);
     cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
     cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
@@ -408,6 +412,7 @@ static void aarch64_a76_initfn(Object *obj)
 static void aarch64_a64fx_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,a64fx";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -431,9 +436,9 @@ static void aarch64_a64fx_initfn(Object *obj)
     cpu->isar.id_aa64mmfr0 = 0x0000000000001122;
     cpu->isar.id_aa64mmfr1 = 0x0000000011212100;
     cpu->isar.id_aa64mmfr2 = 0x0000000000001011;
-    cpu->isar.id_aa64isar0 = 0x0000000010211120;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x0000000010211120);
     cpu->isar.id_aa64isar1 = 0x0000000000010001;
-    cpu->isar.id_aa64zfr0 = 0x0000000000000000;
+    SET_IDREG(idregs, ID_AA64ZFR0, 0x0000000000000000);
     cpu->clidr = 0x0000000080000023;
     /* 64KB L1 dcache */
     cpu->ccsidr[0] = make_ccsidr(CCSIDR_FORMAT_LEGACY, 4, 256, 64 * KiB, 7);
@@ -581,6 +586,7 @@ static void define_neoverse_v1_cp_reginfo(ARMCPU *cpu)
 static void aarch64_neoverse_n1_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,neoverse-n1";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -598,7 +604,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     cpu->ctr = 0x8444c004;
     cpu->dcz_blocksize = 4;
     cpu->isar.id_aa64dfr0  = 0x0000000110305408ull;
-    cpu->isar.id_aa64isar0 = 0x0000100010211120ull;
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x0000100010211120ull);
     cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
     cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
@@ -656,6 +662,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
 static void aarch64_neoverse_v1_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,neoverse-v1";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -676,7 +683,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     cpu->id_aa64afr1 = 0x00000000;
     cpu->isar.id_aa64dfr0  = 0x000001f210305519ull;
     cpu->isar.id_aa64dfr1 = 0x00000000;
-    cpu->isar.id_aa64isar0 = 0x1011111110212120ull; /* with FEAT_RNG */
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x1011111110212120ull); /* with FEAT_RNG */
     cpu->isar.id_aa64isar1 = 0x0011100001211032ull;
     cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
@@ -735,7 +742,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     cpu->isar.mvfr2 = 0x00000043;
 
     /* From 3.7.5 ID_AA64ZFR0_EL1 */
-    cpu->isar.id_aa64zfr0 = 0x0000100000100000;
+    SET_IDREG(idregs, ID_AA64ZFR0, 0x0000100000100000);
     cpu->sve_vq.supported = (1 << 0)  /* 128bit */
                             | (1 << 1);  /* 256bit */
 
@@ -882,6 +889,7 @@ static const ARMCPRegInfo cortex_a710_cp_reginfo[] = {
 static void aarch64_a710_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,cortex-a710";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -919,12 +927,12 @@ static void aarch64_a710_initfn(Object *obj)
     cpu->isar.id_pfr2  = 0x00000011;
     cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
     cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
-    cpu->isar.id_aa64zfr0  = 0x0000110100110021ull; /* with Crypto */
+    SET_IDREG(idregs, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
     cpu->isar.id_aa64dfr0  = 0x000011f010305619ull;
     cpu->isar.id_aa64dfr1  = 0;
     cpu->id_aa64afr0       = 0;
     cpu->id_aa64afr1       = 0;
-    cpu->isar.id_aa64isar0 = 0x0221111110212120ull; /* with Crypto */
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x0221111110212120ull); /* with Crypto */
     cpu->isar.id_aa64isar1 = 0x0010111101211052ull;
     cpu->isar.id_aa64mmfr0 = 0x0000022200101122ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
@@ -983,6 +991,7 @@ static const ARMCPRegInfo neoverse_n2_cp_reginfo[] = {
 static void aarch64_neoverse_n2_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
 
     cpu->dtb_compatible = "arm,neoverse-n2";
     set_feature(&cpu->env, ARM_FEATURE_V8);
@@ -1020,12 +1029,12 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     cpu->isar.id_pfr2  = 0x00000011;
     cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
     cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
-    cpu->isar.id_aa64zfr0  = 0x0000110100110021ull; /* with Crypto */
+    SET_IDREG(idregs, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
     cpu->isar.id_aa64dfr0  = 0x000011f210305619ull;
     cpu->isar.id_aa64dfr1  = 0;
     cpu->id_aa64afr0       = 0;
     cpu->id_aa64afr1       = 0;
-    cpu->isar.id_aa64isar0 = 0x1221111110212120ull; /* with Crypto and FEAT_RNG */
+    SET_IDREG(idregs, ID_AA64ISAR0, 0x1221111110212120ull); /* with Crypto and FEAT_RNG */
     cpu->isar.id_aa64isar1 = 0x0011111101211052ull;
     cpu->isar.id_aa64mmfr0 = 0x0000022200101125ull;
     cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
@@ -1083,6 +1092,7 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
 void aarch64_max_tcg_initfn(Object *obj)
 {
     ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t *idregs = cpu->isar.idregs;
     uint64_t t;
     uint32_t u;
 
@@ -1133,7 +1143,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, CTR_EL0, DIC, 1);
     cpu->ctr = t;
 
-    t = cpu->isar.id_aa64isar0;
+    t = GET_IDREG(idregs, ID_AA64ISAR0);
     t = FIELD_DP64(t, ID_AA64ISAR0, AES, 2);      /* FEAT_PMULL */
     t = FIELD_DP64(t, ID_AA64ISAR0, SHA1, 1);     /* FEAT_SHA1 */
     t = FIELD_DP64(t, ID_AA64ISAR0, SHA2, 2);     /* FEAT_SHA512 */
@@ -1148,7 +1158,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64ISAR0, TS, 2);       /* FEAT_FlagM2 */
     t = FIELD_DP64(t, ID_AA64ISAR0, TLB, 2);      /* FEAT_TLBIRANGE */
     t = FIELD_DP64(t, ID_AA64ISAR0, RNDR, 1);     /* FEAT_RNG */
-    cpu->isar.id_aa64isar0 = t;
+    SET_IDREG(idregs, ID_AA64ISAR0, t);
 
     t = cpu->isar.id_aa64isar1;
     t = FIELD_DP64(t, ID_AA64ISAR1, DPB, 2);      /* FEAT_DPB2 */
@@ -1242,7 +1252,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64MMFR3, SPEC_FPACC, 1); /* FEAT_FPACC_SPEC */
     cpu->isar.id_aa64mmfr3 = t;
 
-    t = cpu->isar.id_aa64zfr0;
+    t = GET_IDREG(idregs, ID_AA64ZFR0);
     t = FIELD_DP64(t, ID_AA64ZFR0, SVEVER, 1);
     t = FIELD_DP64(t, ID_AA64ZFR0, AES, 2);       /* FEAT_SVE_PMULL128 */
     t = FIELD_DP64(t, ID_AA64ZFR0, BITPERM, 1);   /* FEAT_SVE_BitPerm */
@@ -1252,7 +1262,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64ZFR0, I8MM, 1);      /* FEAT_I8MM */
     t = FIELD_DP64(t, ID_AA64ZFR0, F32MM, 1);     /* FEAT_F32MM */
     t = FIELD_DP64(t, ID_AA64ZFR0, F64MM, 1);     /* FEAT_F64MM */
-    cpu->isar.id_aa64zfr0 = t;
+    SET_IDREG(idregs, ID_AA64ZFR0, t);
 
     t = cpu->isar.id_aa64dfr0;
     t = FIELD_DP64(t, ID_AA64DFR0, DEBUGVER, 10); /* FEAT_Debugv8p8 */
-- 
2.48.1

