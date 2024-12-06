Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB5246426
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 11:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484203; cv=none; b=M9M65B7BICnDjkNHmZC9hDYQXfsA+6U1St1RDZFnP9iPAgVkJJzSuEC0Hr+eYeu/UvFTGEiFII3auePCDb1+6Q/G1RKJWk9IpgZvKU5PLoWGSaSm5wKUBrv2tbaPEBJwSSUDJL6WwSNF3JgdGVCLmKfSOMuRixZVLEDTBpKYWYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484203; c=relaxed/simple;
	bh=dqeZXph2wtZfnwe1CNqgvZd0n0NMtgN/LGuLPgwB6bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=SMKD/jS6bnQdhlXG6hSr3k+xw0vk3GamKRYewK30Xh6iVNk6LnhdplfAs3Z46vJFofiafZ0pHn0ggxR1AevDd2euelQGyOFT1g6Yk/DJvzfnqk5vFzLbaLiVt+17Iu7MGk89gD0rPx2+flG8HSNmTgntTt/K1T+UriQ8EHoxRWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GP48llCh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GP48llCh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733484200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MheAFTddXE8JD5xWgtBkobPDdr53sSOBEmqphU/lNfQ=;
	b=GP48llChLnC5LnrmVSOUPaCI6DxCWu1rWKjpKOaPL0koVEnbS0ITYRGlT95yMffGgdLvJj
	Vd8Rw+Ma9zIughlj3twg5uu7VJIPx9t7/uZDILNdKm6ikORppnkHuclP8kdXR+8NDMgqe9
	AJyMoUqzut2qxT7/3HSAwLBTDeXlBRI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-VAk5jlj-PPCG8dOUGpnRuQ-1; Fri,
 06 Dec 2024 06:23:17 -0500
X-MC-Unique: VAk5jlj-PPCG8dOUGpnRuQ-1
X-Mimecast-MFC-AGG-ID: VAk5jlj-PPCG8dOUGpnRuQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EDED19560A2;
	Fri,  6 Dec 2024 11:23:15 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E2BFB19560A2;
	Fri,  6 Dec 2024 11:23:09 +0000 (UTC)
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
Subject: [PATCH RFCv2 08/20] arm/cpu: Store aa64smfr0 into the idregs array
Date: Fri,  6 Dec 2024 12:22:01 +0100
Message-ID: <20241206112213.88394-9-cohuck@redhat.com>
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
 target/arm/cpu-features.h | 6 +++---
 target/arm/cpu.h          | 1 -
 target/arm/cpu64.c        | 7 ++-----
 target/arm/helper.c       | 2 +-
 target/arm/kvm.c          | 3 +--
 target/arm/tcg/cpu64.c    | 4 ++--
 6 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 5e3c83f0cc61..5b463aee373c 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -963,17 +963,17 @@ static inline bool isar_feature_aa64_sve_f64mm(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa64_sme_f64f64(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64smfr0, ID_AA64SMFR0, F64F64);
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64SMFR0, F64F64);
 }
 
 static inline bool isar_feature_aa64_sme_i16i64(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64smfr0, ID_AA64SMFR0, I16I64) == 0xf;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64SMFR0, I16I64) == 0xf;
 }
 
 static inline bool isar_feature_aa64_sme_fa64(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64smfr0, ID_AA64SMFR0, FA64);
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64SMFR0, FA64);
 }
 
 /*
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index f3d694b8e2c8..612035e7c9fc 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1097,7 +1097,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
         IdRegMap idregs;
     } isar;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 3a1c441fbf80..07240469b6f7 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -306,7 +306,7 @@ void arm_cpu_sme_finalize(ARMCPU *cpu, Error **errp)
 
     if (vq_map == 0) {
         if (!cpu_isar_feature(aa64_sme, cpu)) {
-            cpu->isar.id_aa64smfr0 = 0;
+            SET_IDREG(&cpu->isar.idregs, ID_AA64SMFR0, 0);
             return;
         }
 
@@ -359,11 +359,8 @@ static bool cpu_arm_get_sme_fa64(Object *obj, Error **errp)
 static void cpu_arm_set_sme_fa64(Object *obj, bool value, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t t;
 
-    t = cpu->isar.id_aa64smfr0;
-    t = FIELD_DP64(t, ID_AA64SMFR0, FA64, value);
-    cpu->isar.id_aa64smfr0 = t;
+    FIELD_DP64_IDREG(&cpu->isar.idregs, ID_AA64SMFR0, FA64, value);
 }
 
 #ifdef CONFIG_USER_ONLY
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 6626695b1adf..46d18a640cec 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -8918,7 +8918,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 5,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64smfr0 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64SMFR0)},
             { .name = "ID_AA64PFR6_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 6,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index bfe5347e1cc9..82b8c39732ed 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -344,8 +344,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err = 0;
     } else {
         err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64PFR1_EL1);
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64smfr0,
-                              ARM64_SYS_REG(3, 0, 0, 4, 5));
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64SMFR0_EL1);
         err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64DFR0_EL1);
         err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64DFR1_EL1);
         err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64ISAR0_EL1);
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 72209bd4dfc1..e228a545db2c 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -1265,7 +1265,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64DFR0, HPMN0, 1);     /* FEAT_HPMN0 */
     SET_IDREG(idregs, ID_AA64DFR0, t);
 
-    t = cpu->isar.id_aa64smfr0;
+    t = GET_IDREG(idregs, ID_AA64SMFR0);
     t = FIELD_DP64(t, ID_AA64SMFR0, F32F32, 1);   /* FEAT_SME */
     t = FIELD_DP64(t, ID_AA64SMFR0, B16F32, 1);   /* FEAT_SME */
     t = FIELD_DP64(t, ID_AA64SMFR0, F16F32, 1);   /* FEAT_SME */
@@ -1273,7 +1273,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64SMFR0, F64F64, 1);   /* FEAT_SME_F64F64 */
     t = FIELD_DP64(t, ID_AA64SMFR0, I16I64, 0xf); /* FEAT_SME_I16I64 */
     t = FIELD_DP64(t, ID_AA64SMFR0, FA64, 1);     /* FEAT_SME_FA64 */
-    cpu->isar.id_aa64smfr0 = t;
+    SET_IDREG(idregs, ID_AA64SMFR0, t);
 
     /* Replicate the same data to the 32-bit id registers.  */
     aa32_max_features(cpu);
-- 
2.47.0

