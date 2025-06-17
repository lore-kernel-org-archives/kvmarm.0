Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648592DF3C9
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174834; cv=none; b=TotcdVm3Xfbm5sKXQXQ595duvi+wu6idDcF2O6wqCM19pWSntoppo1ql4yFktQT12eBQ6yOZEZFyxQfnWqT6FW85MGLC5Xx0k5+3SSZb4KHR/OmccuadP2DuiaPAHIgKt2vNcVhFpt6zbVpalPeCcK+nmRBCDZkhUbsum3ITtcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174834; c=relaxed/simple;
	bh=O+MRnEqwNpz0q8geHZbyCjj6wsicC3wK51d4MOEPeLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=M5EEkAQWRz3GF/CDNUZMDTwLB2pZvzEdFwgWQyGeb9ld2U0CaC7kIsOYoiu07urjIpUEVMkxME1kuW5YUOPeh5CTRbdZeomMb9+1WI5hlaiizJyMoWMbUSaNhyPjq73WOAmK5sFinzjiXUf9GER0+xvfbv6p05DbRpQmCWiMrQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gr1qXvE4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gr1qXvE4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750174831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xTD4VIeiVvYAk0yGQRr3unh/O18nIAWV5D1LTna5VBE=;
	b=gr1qXvE4c77ObO9U2W1efIIQymJPtYXRMQsKpJMoZBEubDExor7iiFZc1goAwYecrTwzIk
	OTZx7igSDB9eMJHOG70ykgvD4hlnjogEYV0KTWLhf2Aqn2wzXi/+VFLS2NXYm4HNAtc7E9
	s2YFJKuTl/rYTV6qwhKEtNUMhEK97oE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-HgImXl-rNcOmj1HVUCogHg-1; Tue,
 17 Jun 2025 11:40:30 -0400
X-MC-Unique: HgImXl-rNcOmj1HVUCogHg-1
X-Mimecast-MFC-AGG-ID: HgImXl-rNcOmj1HVUCogHg_1750174828
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CC44195608D;
	Tue, 17 Jun 2025 15:40:28 +0000 (UTC)
Received: from gondolin.str.redhat.com (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D95761800285;
	Tue, 17 Jun 2025 15:40:22 +0000 (UTC)
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
Subject: [PATCH v8 07/14] arm/cpu: Store aa64smfr0 into the idregs array
Date: Tue, 17 Jun 2025 17:39:24 +0200
Message-ID: <20250617153931.1330449-8-cohuck@redhat.com>
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
 target/arm/cpu-features.h | 6 +++---
 target/arm/cpu.h          | 1 -
 target/arm/cpu64.c        | 7 ++-----
 target/arm/helper.c       | 2 +-
 target/arm/kvm.c          | 3 +--
 target/arm/tcg/cpu64.c    | 4 ++--
 6 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 9517e8a74c83..051ed7b8847a 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -979,17 +979,17 @@ static inline bool isar_feature_aa64_sve_f64mm(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa64_sme_f64f64(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64smfr0, ID_AA64SMFR0, F64F64);
+    return FIELD_EX64_IDREG(id, ID_AA64SMFR0, F64F64);
 }
 
 static inline bool isar_feature_aa64_sme_i16i64(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64smfr0, ID_AA64SMFR0, I16I64) == 0xf;
+    return FIELD_EX64_IDREG(id, ID_AA64SMFR0, I16I64) == 0xf;
 }
 
 static inline bool isar_feature_aa64_sme_fa64(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64smfr0, ID_AA64SMFR0, FA64);
+    return FIELD_EX64_IDREG(id, ID_AA64SMFR0, FA64);
 }
 
 /*
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index c7935377c6f8..1083ae7623b1 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1074,7 +1074,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
         uint64_t idregs[NUM_ID_IDX];
     } isar;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index a215ba8b479c..0f938155d28e 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -328,7 +328,7 @@ void arm_cpu_sme_finalize(ARMCPU *cpu, Error **errp)
 
     if (vq_map == 0) {
         if (!cpu_isar_feature(aa64_sme, cpu)) {
-            cpu->isar.id_aa64smfr0 = 0;
+            SET_IDREG(&cpu->isar, ID_AA64SMFR0, 0);
             return;
         }
 
@@ -381,11 +381,8 @@ static bool cpu_arm_get_sme_fa64(Object *obj, Error **errp)
 static void cpu_arm_set_sme_fa64(Object *obj, bool value, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
-    uint64_t t;
 
-    t = cpu->isar.id_aa64smfr0;
-    t = FIELD_DP64(t, ID_AA64SMFR0, FA64, value);
-    cpu->isar.id_aa64smfr0 = t;
+    FIELD_DP64_IDREG(&cpu->isar, ID_AA64SMFR0, FA64, value);
 }
 
 #ifdef CONFIG_USER_ONLY
diff --git a/target/arm/helper.c b/target/arm/helper.c
index bdfc2ee9d5cc..6ca85ea0cb5a 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7948,7 +7948,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 5,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64smfr0 },
+              .resetvalue = GET_IDREG(isar, ID_AA64SMFR0)},
             { .name = "ID_AA64PFR6_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 6,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 479e5860e024..873685586147 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -314,8 +314,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err = 0;
     } else {
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64smfr0,
-                              ARM64_SYS_REG(3, 0, 0, 4, 5));
+        err |= get_host_cpu_reg(fd, ahcf, ID_AA64SMFR0_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64DFR0_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64DFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR0_EL1_IDX);
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 7e18d31a2535..80a99ab025da 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -1267,7 +1267,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64DFR0, HPMN0, 1);     /* FEAT_HPMN0 */
     SET_IDREG(isar, ID_AA64DFR0, t);
 
-    t = cpu->isar.id_aa64smfr0;
+    t = GET_IDREG(isar, ID_AA64SMFR0);
     t = FIELD_DP64(t, ID_AA64SMFR0, F32F32, 1);   /* FEAT_SME */
     t = FIELD_DP64(t, ID_AA64SMFR0, B16F32, 1);   /* FEAT_SME */
     t = FIELD_DP64(t, ID_AA64SMFR0, F16F32, 1);   /* FEAT_SME */
@@ -1275,7 +1275,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64SMFR0, F64F64, 1);   /* FEAT_SME_F64F64 */
     t = FIELD_DP64(t, ID_AA64SMFR0, I16I64, 0xf); /* FEAT_SME_I16I64 */
     t = FIELD_DP64(t, ID_AA64SMFR0, FA64, 1);     /* FEAT_SME_FA64 */
-    cpu->isar.id_aa64smfr0 = t;
+    SET_IDREG(isar, ID_AA64SMFR0, t);
 
     /* Replicate the same data to the 32-bit id registers.  */
     aa32_max_features(cpu);
-- 
2.49.0

