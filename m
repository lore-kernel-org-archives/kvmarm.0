Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28AC1A2645
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738926322; cv=none; b=jK955I4xVEMiE9WsE60bG/N3HrobP+ASrWMThk21QPsbHIp8aD5StYbOTZzcMiX/Ewm3Yt/0H24jXaAnhDn23bZBkKDIOPyg3D56aB4laYx8nlZBZvWIXqEbTZm6Ci2SC0bADS7DW49SKG3+G5N7ATZqJDl35mtauRvQ8jM4pFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738926322; c=relaxed/simple;
	bh=iPDFeUJpR0Am/4QQRiuu1UElO0TnQGyB88hEwhSuOFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jyhshYT+YUr7vf8MH4SEuUKC8KQxmR/MqfvcpXHfXqNqYEGCKvyNv0FL+bR4M063G3DuuT6c/4iL1TGI5QJqyRhNCWSpzR7uysZ8CAbtrol3vuDcM54pmSiLMlsXCLzeSaU0JSqKd+dWqHGW9axwl8BML/NIi3KTneRE4pebzpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d8Z3QWIz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d8Z3QWIz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738926319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=On7Wq1rsXR2UiY8APdez8UNenQwXxsh/UaXYkMQ1P+o=;
	b=d8Z3QWIzlZVEiRbSiBhVYz68sAgtTHSpCeJ2lDaLPmS8u2OU09P5ZzO/fCWxJU/4raijbw
	fKQha4ZJwWplh5J6p5oYXMduS6GPYNJr97smgzSqJas+hYp04hLxemD3m+bco2vH1OR6NE
	HSv8iEkWxhHoM61KvqEwo8vjaFRePUc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-3_zkfHanNp6AAoKco2z-Pg-1; Fri,
 07 Feb 2025 06:05:16 -0500
X-MC-Unique: 3_zkfHanNp6AAoKco2z-Pg-1
X-Mimecast-MFC-AGG-ID: 3_zkfHanNp6AAoKco2z-Pg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31284180087B;
	Fri,  7 Feb 2025 11:05:14 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.130])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AAAE319560AB;
	Fri,  7 Feb 2025 11:05:00 +0000 (UTC)
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
Subject: [PATCH 08/15] arm/cpu: Store aa64smfr0 into the idregs array
Date: Fri,  7 Feb 2025 12:02:41 +0100
Message-ID: <20250207110248.1580465-9-cohuck@redhat.com>
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
 target/arm/cpu-features.h | 6 +++---
 target/arm/cpu.h          | 1 -
 target/arm/cpu64.c        | 7 ++-----
 target/arm/helper.c       | 2 +-
 target/arm/kvm.c          | 3 +--
 target/arm/tcg/cpu64.c    | 4 ++--
 6 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 05de9e0d9932..6224c7ec6356 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -968,17 +968,17 @@ static inline bool isar_feature_aa64_sve_f64mm(const ARMISARegisters *id)
 
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
index 99b0c2a4b39d..82db0d429c91 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1067,7 +1067,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
         uint64_t idregs[NUM_ID_IDX];
     } isar;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 22286a1844a4..5c3ca3ba7af1 100644
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
index 437ba8a53934..7c2953a971b6 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7725,7 +7725,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 5,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64smfr0 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64SMFR0)},
             { .name = "ID_AA64PFR6_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 6,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7597c84ff2ce..b3092335a118 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -361,8 +361,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
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
index ce4cb449a381..38d189361e3e 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -1266,7 +1266,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64DFR0, HPMN0, 1);     /* FEAT_HPMN0 */
     SET_IDREG(idregs, ID_AA64DFR0, t);
 
-    t = cpu->isar.id_aa64smfr0;
+    t = GET_IDREG(idregs, ID_AA64SMFR0);
     t = FIELD_DP64(t, ID_AA64SMFR0, F32F32, 1);   /* FEAT_SME */
     t = FIELD_DP64(t, ID_AA64SMFR0, B16F32, 1);   /* FEAT_SME */
     t = FIELD_DP64(t, ID_AA64SMFR0, F16F32, 1);   /* FEAT_SME */
@@ -1274,7 +1274,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64SMFR0, F64F64, 1);   /* FEAT_SME_F64F64 */
     t = FIELD_DP64(t, ID_AA64SMFR0, I16I64, 0xf); /* FEAT_SME_I16I64 */
     t = FIELD_DP64(t, ID_AA64SMFR0, FA64, 1);     /* FEAT_SME_FA64 */
-    cpu->isar.id_aa64smfr0 = t;
+    SET_IDREG(idregs, ID_AA64SMFR0, t);
 
     /* Replicate the same data to the 32-bit id registers.  */
     aa32_max_features(cpu);
-- 
2.48.1

