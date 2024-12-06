Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0A546426
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 11:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484201; cv=none; b=UlMXzgegnFkAWUvF83dsI19K73HquNZBQOxNm96tK9k+J0xV9EeUE56oguIui5se4uq9sIb7Du/c0R6LODG5Cd6zhFcNkEpHzzl9IqjhPB49iQIQ0osCaj/L6lyQfHQ5DigByVbpuDUtBj7X6PmJJ5TrOzuTtbT5SvWBgqAMQ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484201; c=relaxed/simple;
	bh=G+EQngHLdyAcVe/Htx8y28cri1yUkxaJhCZFS4DiJZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jPP208FH+jNBM0IThtAGkdJvLpZ3w+L2qGduydUkrLCZrsKy2i1pjOvFhP5brHwQS5mBYfwyKZitz1WjVTt4HtoZmXGaFVeWKEzN3HSsdyT0spQ3IN8B46ToCwzgY1cGu0o4Bl7cBbXB6TWrUJI5HRopvyTTcxVdmT4rVAI2Rgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QXAd+WJG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QXAd+WJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733484196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HE2ZBBth996rO3DXqP8f1CI6duvyL2WwhM1Kq6BMwEE=;
	b=QXAd+WJGOU0BDino5SC7jFr67cZsQBwP7cmZ+RjcFEMszAHwKjn+oo23iGgDH2ns/vNJnu
	wbwc/JRPZL5Egeoaq34l3+THQNjmWUEn1iF88aSNn4PLZi4FBpiA9LJ6nP8K529XOd172p
	lVfjA2osiFkuGIBY3tL/XpqZgLbMOw0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-L8bvgfb-Pcam11qtEKs_PQ-1; Fri,
 06 Dec 2024 06:23:13 -0500
X-MC-Unique: L8bvgfb-Pcam11qtEKs_PQ-1
X-Mimecast-MFC-AGG-ID: L8bvgfb-Pcam11qtEKs_PQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 749FD19560A2;
	Fri,  6 Dec 2024 11:23:03 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C902419560A2;
	Fri,  6 Dec 2024 11:22:57 +0000 (UTC)
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
Subject: [PATCH RFCv2 06/20] arm/cpu: Store aa64mmfr0-3 into the idregs array
Date: Fri,  6 Dec 2024 12:21:59 +0100
Message-ID: <20241206112213.88394-7-cohuck@redhat.com>
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
 target/arm/cpu-features.h | 72 +++++++++++++++++++--------------------
 target/arm/cpu.h          |  7 ++--
 target/arm/cpu64.c        |  8 ++---
 target/arm/helper.c       |  8 ++---
 target/arm/kvm.c          | 12 +++----
 target/arm/ptw.c          |  6 ++--
 target/arm/tcg/cpu64.c    | 64 +++++++++++++++++-----------------
 7 files changed, 85 insertions(+), 92 deletions(-)

diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index 406452ef9fba..531f38da6569 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -700,187 +700,187 @@ static inline bool isar_feature_aa64_nmi(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa64_tgran4_lpa2(const ARMISARegisters *id)
 {
-    return FIELD_SEX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN4) >= 1;
+    return FIELD_SEX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN4) >= 1;
 }
 
 static inline bool isar_feature_aa64_tgran4_2_lpa2(const ARMISARegisters *id)
 {
-    unsigned t = FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN4_2);
+    unsigned t = FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN4_2);
     return t >= 3 || (t == 0 && isar_feature_aa64_tgran4_lpa2(id));
 }
 
 static inline bool isar_feature_aa64_tgran16_lpa2(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN16) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN16) >= 2;
 }
 
 static inline bool isar_feature_aa64_tgran16_2_lpa2(const ARMISARegisters *id)
 {
-    unsigned t = FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN16_2);
+    unsigned t = FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN16_2);
     return t >= 3 || (t == 0 && isar_feature_aa64_tgran16_lpa2(id));
 }
 
 static inline bool isar_feature_aa64_tgran4(const ARMISARegisters *id)
 {
-    return FIELD_SEX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN4) >= 0;
+    return FIELD_SEX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN4) >= 0;
 }
 
 static inline bool isar_feature_aa64_tgran16(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN16) >= 1;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN16) >= 1;
 }
 
 static inline bool isar_feature_aa64_tgran64(const ARMISARegisters *id)
 {
-    return FIELD_SEX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN64) >= 0;
+    return FIELD_SEX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN64) >= 0;
 }
 
 static inline bool isar_feature_aa64_tgran4_2(const ARMISARegisters *id)
 {
-    unsigned t = FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN4_2);
+    unsigned t = FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN4_2);
     return t >= 2 || (t == 0 && isar_feature_aa64_tgran4(id));
 }
 
 static inline bool isar_feature_aa64_tgran16_2(const ARMISARegisters *id)
 {
-    unsigned t = FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN16_2);
+    unsigned t = FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN16_2);
     return t >= 2 || (t == 0 && isar_feature_aa64_tgran16(id));
 }
 
 static inline bool isar_feature_aa64_tgran64_2(const ARMISARegisters *id)
 {
-    unsigned t = FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, TGRAN64_2);
+    unsigned t = FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, TGRAN64_2);
     return t >= 2 || (t == 0 && isar_feature_aa64_tgran64(id));
 }
 
 static inline bool isar_feature_aa64_fgt(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, FGT) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, FGT) != 0;
 }
 
 static inline bool isar_feature_aa64_ecv_traps(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, ECV) > 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, ECV) > 0;
 }
 
 static inline bool isar_feature_aa64_ecv(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr0, ID_AA64MMFR0, ECV) > 1;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR0, ECV) > 1;
 }
 
 static inline bool isar_feature_aa64_vh(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, VH) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, VH) != 0;
 }
 
 static inline bool isar_feature_aa64_lor(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, LO) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, LO) != 0;
 }
 
 static inline bool isar_feature_aa64_pan(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, PAN) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, PAN) != 0;
 }
 
 static inline bool isar_feature_aa64_ats1e1(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, PAN) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, PAN) >= 2;
 }
 
 static inline bool isar_feature_aa64_pan3(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, PAN) >= 3;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, PAN) >= 3;
 }
 
 static inline bool isar_feature_aa64_hcx(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, HCX) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, HCX) != 0;
 }
 
 static inline bool isar_feature_aa64_tidcp1(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, TIDCP1) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, TIDCP1) != 0;
 }
 
 static inline bool isar_feature_aa64_cmow(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, CMOW) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, CMOW) != 0;
 }
 
 static inline bool isar_feature_aa64_hafs(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, HAFDBS) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, HAFDBS) != 0;
 }
 
 static inline bool isar_feature_aa64_hdbs(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, HAFDBS) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, HAFDBS) >= 2;
 }
 
 static inline bool isar_feature_aa64_tts2uxn(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr1, ID_AA64MMFR1, XNX) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR1, XNX) != 0;
 }
 
 static inline bool isar_feature_aa64_uao(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, UAO) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, UAO) != 0;
 }
 
 static inline bool isar_feature_aa64_st(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, ST) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, ST) != 0;
 }
 
 static inline bool isar_feature_aa64_lse2(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, AT) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, AT) != 0;
 }
 
 static inline bool isar_feature_aa64_fwb(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, FWB) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, FWB) != 0;
 }
 
 static inline bool isar_feature_aa64_ids(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, IDS) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, IDS) != 0;
 }
 
 static inline bool isar_feature_aa64_half_evt(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, EVT) >= 1;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, EVT) >= 1;
 }
 
 static inline bool isar_feature_aa64_evt(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, EVT) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, EVT) >= 2;
 }
 
 static inline bool isar_feature_aa64_ccidx(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, CCIDX) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, CCIDX) != 0;
 }
 
 static inline bool isar_feature_aa64_lva(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, VARANGE) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, VARANGE) != 0;
 }
 
 static inline bool isar_feature_aa64_e0pd(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, E0PD) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, E0PD) != 0;
 }
 
 static inline bool isar_feature_aa64_nv(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, NV) != 0;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, NV) != 0;
 }
 
 static inline bool isar_feature_aa64_nv2(const ARMISARegisters *id)
 {
-    return FIELD_EX64(id->id_aa64mmfr2, ID_AA64MMFR2, NV) >= 2;
+    return FIELD_EX64_IDREG(&id->idregs, ID_AA64MMFR2, NV) >= 2;
 }
 
 static inline bool isar_feature_aa64_pmuv3p1(const ARMISARegisters *id)
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 8c841988c5ad..f36139ba79db 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -881,6 +881,9 @@ _set_idreg(MAP, SYS_ ## REG ## _EL1, regval);                 \
 #define FIELD_EX64_IDREG(MAP, REG, FIELD)                     \
 FIELD_EX64(_get_idreg(MAP, SYS_ ## REG ## _EL1), REG, FIELD)  \
 
+#define FIELD_SEX64_IDREG(MAP, REG, FIELD)                     \
+FIELD_SEX64(_get_idreg(MAP, SYS_ ## REG ## _EL1), REG, FIELD)  \
+
 #define FIELD_EX32_IDREG(MAP, REG, FIELD)                     \
 FIELD_EX32(_get_idreg(MAP, SYS_ ## REG ## _EL1), REG, FIELD)  \
 
@@ -1094,10 +1097,6 @@ struct ArchCPU {
         uint32_t dbgdidr;
         uint32_t dbgdevid;
         uint32_t dbgdevid1;
-        uint64_t id_aa64mmfr0;
-        uint64_t id_aa64mmfr1;
-        uint64_t id_aa64mmfr2;
-        uint64_t id_aa64mmfr3;
         uint64_t id_aa64dfr0;
         uint64_t id_aa64dfr1;
         uint64_t id_aa64smfr0;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 48b4a08a4a7b..fb1c50ee9007 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -583,12 +583,12 @@ void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp)
         return;
     }
 
-    t = cpu->isar.id_aa64mmfr0;
+    t = GET_IDREG(&cpu->isar.idregs, ID_AA64MMFR0);
     t = FIELD_DP64(t, ID_AA64MMFR0, TGRAN16, 2);   /* 16k pages w/ LPA2 */
     t = FIELD_DP64(t, ID_AA64MMFR0, TGRAN4, 1);    /*  4k pages w/ LPA2 */
     t = FIELD_DP64(t, ID_AA64MMFR0, TGRAN16_2, 3); /* 16k stage2 w/ LPA2 */
     t = FIELD_DP64(t, ID_AA64MMFR0, TGRAN4_2, 3);  /*  4k stage2 w/ LPA2 */
-    cpu->isar.id_aa64mmfr0 = t;
+    SET_IDREG(&cpu->isar.idregs, ID_AA64MMFR0, t);
 }
 
 static void aarch64_a57_initfn(Object *obj)
@@ -633,7 +633,7 @@ static void aarch64_a57_initfn(Object *obj)
     SET_IDREG(idregs, ID_AA64PFR0, 0x00002222);
     cpu->isar.id_aa64dfr0 = 0x10305106;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
-    cpu->isar.id_aa64mmfr0 = 0x00001124;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x00001124);
     cpu->isar.dbgdidr = 0x3516d000;
     cpu->isar.dbgdevid = 0x01110f13;
     cpu->isar.dbgdevid1 = 0x2;
@@ -695,7 +695,7 @@ static void aarch64_a53_initfn(Object *obj)
     SET_IDREG(idregs, ID_AA64PFR0, 0x00002222);
     cpu->isar.id_aa64dfr0 = 0x10305106;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
-    cpu->isar.id_aa64mmfr0 = 0x00001122; /* 40 bit physical addr */
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x00001122); /* 40 bit physical addr */
     cpu->isar.dbgdidr = 0x3516d000;
     cpu->isar.dbgdevid = 0x00110f13;
     cpu->isar.dbgdevid1 = 0x1;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index be9cc22a3ffc..1ee415c276a8 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -9013,22 +9013,22 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 7, .opc2 = 0,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64mmfr0 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64MMFR0)},
             { .name = "ID_AA64MMFR1_EL1", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 7, .opc2 = 1,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64mmfr1 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64MMFR1) },
             { .name = "ID_AA64MMFR2_EL1", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 7, .opc2 = 2,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64mmfr2 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64MMFR2) },
             { .name = "ID_AA64MMFR3_EL1", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 7, .opc2 = 3,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_aa64mmfr3 },
+              .resetvalue = GET_IDREG(idregs, ID_AA64MMFR3) },
             { .name = "ID_AA64MMFR4_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 7, .opc2 = 4,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index a7d0aac63ae9..c073758ad6c3 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -353,14 +353,10 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64ISAR0_EL1);
         err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64ISAR1_EL1);
         err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64ISAR2_EL1);
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64mmfr0,
-                              ARM64_SYS_REG(3, 0, 0, 7, 0));
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64mmfr1,
-                              ARM64_SYS_REG(3, 0, 0, 7, 1));
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64mmfr2,
-                              ARM64_SYS_REG(3, 0, 0, 7, 2));
-        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64mmfr3,
-                              ARM64_SYS_REG(3, 0, 0, 7, 3));
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64MMFR0_EL1);
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64MMFR1_EL1);
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64MMFR2_EL1);
+        err |= get_host_cpu_reg64(fd, ahcf, SYS_ID_AA64MMFR3_EL1);
 
         /*
          * Note that if AArch32 support is not present in the host,
diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 64bb6878a48a..f5d294cfb75c 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -123,7 +123,7 @@ unsigned int arm_pamax(ARMCPU *cpu)
 {
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         unsigned int parange =
-            FIELD_EX64(cpu->isar.id_aa64mmfr0, ID_AA64MMFR0, PARANGE);
+            FIELD_EX64_IDREG(&cpu->isar.idregs, ID_AA64MMFR0, PARANGE);
 
         /*
          * id_aa64mmfr0 is a read-only register so values outside of the
@@ -333,7 +333,7 @@ static bool granule_protection_check(CPUARMState *env, uint64_t paddress,
      * physical address size is invalid.
      */
     pps = FIELD_EX64(gpccr, GPCCR, PPS);
-    if (pps > FIELD_EX64(cpu->isar.id_aa64mmfr0, ID_AA64MMFR0, PARANGE)) {
+    if (pps > FIELD_EX64_IDREG(&cpu->isar.idregs, ID_AA64MMFR0, PARANGE)) {
         goto fault_walk;
     }
     pps = pamax_map[pps];
@@ -1735,7 +1735,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
          * ID_AA64MMFR0 is a read-only register so values outside of the
          * supported mappings can be considered an implementation error.
          */
-        ps = FIELD_EX64(cpu->isar.id_aa64mmfr0, ID_AA64MMFR0, PARANGE);
+        ps = FIELD_EX64_IDREG(&cpu->isar.idregs, ID_AA64MMFR0, PARANGE);
         ps = MIN(ps, param.ps);
         assert(ps < ARRAY_SIZE(pamax_map));
         outputsize = pamax_map[ps];
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 827ac0200211..53ee612b8657 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -69,8 +69,8 @@ static void aarch64_a35_initfn(Object *obj)
     cpu->isar.id_aa64dfr1 = 0;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
     SET_IDREG(idregs, ID_AA64ISAR1, 0);
-    cpu->isar.id_aa64mmfr0 = 0x00101122;
-    cpu->isar.id_aa64mmfr1 = 0;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x00101122);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0);
     cpu->clidr = 0x0a200023;
     cpu->dcz_blocksize = 4;
 
@@ -222,9 +222,9 @@ static void aarch64_a55_initfn(Object *obj)
     cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x0000100010211120ull);
     SET_IDREG(idregs, ID_AA64ISAR1, 0x0000000000100001ull);
-    cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
-    cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
-    cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x0000000000101122ull);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0x0000000010212122ull);
+    SET_IDREG(idregs, ID_AA64MMFR2, 0x0000000000001011ull);
     SET_IDREG(idregs, ID_AA64PFR0, 0x0000000010112222ull);
     SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000010ull);
     cpu->id_afr0       = 0x00000000;
@@ -312,7 +312,7 @@ static void aarch64_a72_initfn(Object *obj)
     SET_IDREG(idregs, ID_AA64PFR0, 0x00002222);
     cpu->isar.id_aa64dfr0 = 0x10305106;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x00011120);
-    cpu->isar.id_aa64mmfr0 = 0x00001124;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x00001124);
     cpu->isar.dbgdidr = 0x3516d000;
     cpu->isar.dbgdevid = 0x01110f13;
     cpu->isar.dbgdevid1 = 0x2;
@@ -355,9 +355,9 @@ static void aarch64_a76_initfn(Object *obj)
     cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x0000100010211120ull);
     SET_IDREG(idregs, ID_AA64ISAR1, 0x0000000000100001ull);
-    cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
-    cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
-    cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x0000000000101122ull);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0x0000000010212122ull);
+    SET_IDREG(idregs, ID_AA64MMFR2, 0x0000000000001011ull);
     SET_IDREG(idregs, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
     SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000010ull);
     cpu->id_afr0       = 0x00000000;
@@ -430,9 +430,9 @@ static void aarch64_a64fx_initfn(Object *obj)
     cpu->isar.id_aa64dfr1 = 0x0000000000000000;
     cpu->id_aa64afr0 = 0x0000000000000000;
     cpu->id_aa64afr1 = 0x0000000000000000;
-    cpu->isar.id_aa64mmfr0 = 0x0000000000001122;
-    cpu->isar.id_aa64mmfr1 = 0x0000000011212100;
-    cpu->isar.id_aa64mmfr2 = 0x0000000000001011;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x0000000000001122);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0x0000000011212100);
+    SET_IDREG(idregs, ID_AA64MMFR2, 0x0000000000001011);
     SET_IDREG(idregs, ID_AA64ISAR0, 0x0000000010211120);
     SET_IDREG(idregs, ID_AA64ISAR1, 0x0000000000010001);
     SET_IDREG(idregs, ID_AA64ZFR0, 0x0000000000000000);
@@ -603,9 +603,9 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     cpu->isar.id_aa64dfr0  = 0x0000000110305408ull;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x0000100010211120ull);
     SET_IDREG(idregs, ID_AA64ISAR1, 0x0000000000100001ull);
-    cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
-    cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
-    cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x0000000000101125ull);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0x0000000010212122ull);
+    SET_IDREG(idregs, ID_AA64MMFR2, 0x0000000000001011ull);
     SET_IDREG(idregs, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
     SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000020ull);
     cpu->id_afr0       = 0x00000000;
@@ -682,9 +682,9 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     cpu->isar.id_aa64dfr1 = 0x00000000;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x1011111110212120ull); /* with FEAT_RNG */
     SET_IDREG(idregs, ID_AA64ISAR1, 0x0011000001211032ull);
-    cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
-    cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
-    cpu->isar.id_aa64mmfr2 = 0x0220011102101011ull;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x0000000000101125ull);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0x0000000010212122ull),
+    SET_IDREG(idregs, ID_AA64MMFR2, 0x0220011102101011ull),
     SET_IDREG(idregs, ID_AA64PFR0, 0x1101110120111112ull); /* GIC filled in later */
     SET_IDREG(idregs, ID_AA64PFR1, 0x0000000000000020ull);
     cpu->id_afr0       = 0x00000000;
@@ -931,9 +931,9 @@ static void aarch64_a710_initfn(Object *obj)
     cpu->id_aa64afr1       = 0;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x0221111110212120ull); /* with Crypto */
     SET_IDREG(idregs, ID_AA64ISAR1, 0x0010111101211052ull);
-    cpu->isar.id_aa64mmfr0 = 0x0000022200101122ull;
-    cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
-    cpu->isar.id_aa64mmfr2 = 0x1221011110101011ull;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x0000022200101122ull);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0x0000000010212122ull);
+    SET_IDREG(idregs, ID_AA64MMFR2, 0x1221011110101011ull);
     cpu->clidr             = 0x0000001482000023ull;
     cpu->gm_blocksize      = 4;
     cpu->ctr               = 0x000000049444c004ull;
@@ -1033,9 +1033,9 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     cpu->id_aa64afr1       = 0;
     SET_IDREG(idregs, ID_AA64ISAR0, 0x1221111110212120ull); /* with Crypto and FEAT_RNG */
     SET_IDREG(idregs, ID_AA64ISAR1, 0x0011111101211052ull);
-    cpu->isar.id_aa64mmfr0 = 0x0000022200101125ull;
-    cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
-    cpu->isar.id_aa64mmfr2 = 0x1221011112101011ull;
+    SET_IDREG(idregs, ID_AA64MMFR0, 0x0000022200101125ull);
+    SET_IDREG(idregs, ID_AA64MMFR1, 0x0000000010212122ull);
+    SET_IDREG(idregs, ID_AA64MMFR2, 0x1221011112101011ull);
     cpu->clidr             = 0x0000001482000023ull;
     cpu->gm_blocksize      = 4;
     cpu->ctr               = 0x00000004b444c004ull;
@@ -1204,7 +1204,7 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64PFR1, NMI, 1);       /* FEAT_NMI */
     SET_IDREG(idregs, ID_AA64PFR1, t);
 
-    t = cpu->isar.id_aa64mmfr0;
+    t = GET_IDREG(idregs, ID_AA64MMFR0);
     t = FIELD_DP64(t, ID_AA64MMFR0, PARANGE, 6); /* FEAT_LPA: 52 bits */
     t = FIELD_DP64(t, ID_AA64MMFR0, TGRAN16, 1);   /* 16k pages supported */
     t = FIELD_DP64(t, ID_AA64MMFR0, TGRAN16_2, 2); /* 16k stage2 supported */
@@ -1212,9 +1212,9 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64MMFR0, TGRAN4_2, 2);  /*  4k stage2 supported */
     t = FIELD_DP64(t, ID_AA64MMFR0, FGT, 1);       /* FEAT_FGT */
     t = FIELD_DP64(t, ID_AA64MMFR0, ECV, 2);       /* FEAT_ECV */
-    cpu->isar.id_aa64mmfr0 = t;
+    SET_IDREG(idregs, ID_AA64MMFR0, t);
 
-    t = cpu->isar.id_aa64mmfr1;
+    t = GET_IDREG(idregs, ID_AA64MMFR1);
     t = FIELD_DP64(t, ID_AA64MMFR1, HAFDBS, 2);   /* FEAT_HAFDBS */
     t = FIELD_DP64(t, ID_AA64MMFR1, VMIDBITS, 2); /* FEAT_VMID16 */
     t = FIELD_DP64(t, ID_AA64MMFR1, VH, 1);       /* FEAT_VHE */
@@ -1226,9 +1226,9 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64MMFR1, HCX, 1);      /* FEAT_HCX */
     t = FIELD_DP64(t, ID_AA64MMFR1, TIDCP1, 1);   /* FEAT_TIDCP1 */
     t = FIELD_DP64(t, ID_AA64MMFR1, CMOW, 1);     /* FEAT_CMOW */
-    cpu->isar.id_aa64mmfr1 = t;
+    SET_IDREG(idregs, ID_AA64MMFR1, t);
 
-    t = cpu->isar.id_aa64mmfr2;
+    t = GET_IDREG(idregs, ID_AA64MMFR2);
     t = FIELD_DP64(t, ID_AA64MMFR2, CNP, 1);      /* FEAT_TTCNP */
     t = FIELD_DP64(t, ID_AA64MMFR2, UAO, 1);      /* FEAT_UAO */
     t = FIELD_DP64(t, ID_AA64MMFR2, IESB, 1);     /* FEAT_IESB */
@@ -1242,11 +1242,9 @@ void aarch64_max_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, ID_AA64MMFR2, BBM, 2);      /* FEAT_BBM at level 2 */
     t = FIELD_DP64(t, ID_AA64MMFR2, EVT, 2);      /* FEAT_EVT */
     t = FIELD_DP64(t, ID_AA64MMFR2, E0PD, 1);     /* FEAT_E0PD */
-    cpu->isar.id_aa64mmfr2 = t;
+    SET_IDREG(idregs, ID_AA64MMFR2, t);
 
-    t = cpu->isar.id_aa64mmfr3;
-    t = FIELD_DP64(t, ID_AA64MMFR3, SPEC_FPACC, 1); /* FEAT_FPACC_SPEC */
-    cpu->isar.id_aa64mmfr3 = t;
+    FIELD_DP64_IDREG(idregs, ID_AA64MMFR3, SPEC_FPACC, 1); /* FEAT_FPACC_SPEC */
 
     t = GET_IDREG(idregs, ID_AA64ZFR0);
     t = FIELD_DP64(t, ID_AA64ZFR0, SVEVER, 1);
-- 
2.47.0

