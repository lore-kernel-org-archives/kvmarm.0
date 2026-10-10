Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC6A1E5B9A
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639466; cv=none; b=mxm7R5UALfSNwc6i6TUFfublKoGCPGCN0MD+7Oae4mv9wHtSvkvjLFGesTst1ExJ6U7ZtGKP/i6vQ4wAczea42Ka4nlKv81czkNSXKiO21SMRLN7GqheflB6OCfQrulq3vqlFaAKXIKeptM6vZ/7Q6fepEI94gyirzyK8d0iKiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639466; c=relaxed/simple;
	bh=eEWeJZYQhC34beH7c2t3BLjiAG/eOpWf9zJ/ZLehDnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hEl6PHeekX0I0ahZREWHwdoqmkFcuSdOk/aOrFv0cbOUni+eW22txnnVA8wB18P5QHECcehyJ1DTaIAjMNWan0H96BC2A2ZcVLwAA9U4LO4ZIzDMfPKU1lMHfiLMEdlCgFc9Y+kn+QyKOmekmMxZPZWRjRqN16XbQXs0Af2rbng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FqW6xlsk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FqW6xlsk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cv1mnVaaa2py2bLoOqax63rfmn2rgM5Tmv6Vdfg/Z40=;
	b=FqW6xlskSZXzgyDE7xYvcm2ul5LS1SgLoamHfd7mByY5Lx/JnZSHA7Yffk4OJHSAb0qZvK
	4JiDfcqr7X3cN/RZ5RFWiFZtohmoH1WKgFbiZCemSnmxcQfwV0han31lV54ed4D52lKOhh
	zOjJa4ZohG3kILOMESFsjWcLcISZBxM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-AyibHwLoMQ63QlWei9-4Tw-1; Sat,
 10 Oct 2026 13:37:42 +0000
X-MC-Unique: AyibHwLoMQ63QlWei9-4Tw-1
X-Mimecast-MFC-AGG-ID: AyibHwLoMQ63QlWei9-4Tw_1791639460
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75EAF1944B01;
	Sat, 10 Oct 2026 13:37:39 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E2D630001BB;
	Sat, 10 Oct 2026 13:37:33 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v10 01/26] target/arm: Move REVIDR into isar.idregs[] storage
Date: Sat, 10 Oct 2026 15:36:05 +0200
Message-ID: <20261010133725.642498-2-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: MOOrRytyXmatvdSnz20_FnAGfhpCgukc26Vl4EgZM3M_1791639460
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Move REVIDR into the isar.idregs[] array as other ID registers.
This will allow to overwrite it as others.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu.h             |  1 -
 target/arm/cpu-sysregs.h.inc |  1 +
 hw/intc/armv7m_nvic.c        |  2 +-
 target/arm/cpu-max.c         |  2 +-
 target/arm/cpu64.c           |  2 +-
 target/arm/helper.c          |  2 +-
 target/arm/tcg/cpu-v7m.c     |  4 ++--
 target/arm/tcg/cpu32.c       |  4 ++--
 target/arm/tcg/cpu64.c       | 20 ++++++++++----------
 9 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 06ebed4a8f..b2af36a8c3 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1124,7 +1124,6 @@ struct ArchCPU {
         uint64_t idregs[NUM_ID_IDX];
     } isar;
     uint64_t midr;
-    uint32_t revidr;
     uint32_t reset_fpsid;
     uint64_t ctr;
     uint32_t reset_sctlr;
diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index b5c7970971..580d88d1f4 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -44,3 +44,4 @@ DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
 DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
 DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
 DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
+DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
diff --git a/hw/intc/armv7m_nvic.c b/hw/intc/armv7m_nvic.c
index 6bc392b0e3..1f56fff046 100644
--- a/hw/intc/armv7m_nvic.c
+++ b/hw/intc/armv7m_nvic.c
@@ -1051,7 +1051,7 @@ static uint32_t nvic_readl(NVICState *s, uint32_t offset, MemTxAttrs attrs)
         if (!arm_feature(&cpu->env, ARM_FEATURE_V8_1M)) {
             goto bad_offset;
         }
-        return cpu->revidr;
+        return GET_IDREG(isar, REVIDR);
     case 0xd00: /* CPUID Base.  */
         return cpu->midr;
     case 0xd04: /* Interrupt Control State (ICSR) */
diff --git a/target/arm/cpu-max.c b/target/arm/cpu-max.c
index 2ed1cfef9b..b4e57a167d 100644
--- a/target/arm/cpu-max.c
+++ b/target/arm/cpu-max.c
@@ -37,7 +37,7 @@ void aarch64_aa32_a57_init(ARMCPU *cpu, bool aarch64_enabled)
         cpu->kvm_target = QEMU_KVM_ARM_TARGET_CORTEX_A57;
     }
     cpu->midr = 0x411fd070;
-    cpu->revidr = 0x00000000;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x41034070;
     cpu->isar.mvfr0 = 0x10110222;
     cpu->isar.mvfr1 = 0x12111111;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index dcd0d698b3..80c9c9e5b3 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -717,7 +717,7 @@ static void aarch64_a53_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     cpu->kvm_target = QEMU_KVM_ARM_TARGET_CORTEX_A53;
     cpu->midr = 0x410fd034;
-    cpu->revidr = 0x00000100;
+    SET_IDREG(isar, REVIDR, 0x00000100);
     cpu->reset_fpsid = 0x41034070;
     cpu->isar.mvfr0 = 0x10110222;
     cpu->isar.mvfr1 = 0x12111111;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index ff0b766b73..41c0d0df12 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7415,7 +7415,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .access = PL1_R,
               .accessfn = access_tid1,
               .fgt = FGT_REVIDR_EL1,
-              .type = ARM_CP_CONST, .resetvalue = cpu->revidr },
+              .type = ARM_CP_CONST, .resetvalue = GET_IDREG(&cpu->isar, REVIDR) },
         };
         ARMCPRegInfo id_v8_midr_alias_cp_reginfo = {
             .name = "MIDR", .type = ARM_CP_ALIAS | ARM_CP_CONST | ARM_CP_NO_GDB,
diff --git a/target/arm/tcg/cpu-v7m.c b/target/arm/tcg/cpu-v7m.c
index 48b31d5eac..e7c61d3c31 100644
--- a/target/arm/tcg/cpu-v7m.c
+++ b/target/arm/tcg/cpu-v7m.c
@@ -211,7 +211,7 @@ static void cortex_m55_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M_SECURITY);
     set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
     cpu->midr = 0x410fd221; /* r0p1 */
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->pmsav7_dregion = 16;
     cpu->sau_sregion = 8;
     /* These are the MVFR* values for the FPU + full MVE configuration */
@@ -249,7 +249,7 @@ static void cortex_m85_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M_SECURITY);
     set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
     cpu->midr = 0x411fd231; /* r1p1 */
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->pmsav7_dregion = 16;
     cpu->sau_sregion = 8;
     /* These are the MVFR* values for the FPU + full MVE configuration */
diff --git a/target/arm/tcg/cpu32.c b/target/arm/tcg/cpu32.c
index f95051458d..c02b737fc0 100644
--- a/target/arm/tcg/cpu32.c
+++ b/target/arm/tcg/cpu32.c
@@ -456,7 +456,7 @@ static void cortex_a15_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     /* r4p0 cpu, not requiring expensive tlb flush errata */
     cpu->midr = 0x414fc0f0;
-    cpu->revidr = 0x0;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x410430f0;
     cpu->isar.mvfr0 = 0x10110222;
     cpu->isar.mvfr1 = 0x11111111;
@@ -647,7 +647,7 @@ static void cortex_r52_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_CBAR_RO);
     set_feature(&cpu->env, ARM_FEATURE_AUXCR);
     cpu->midr = 0x411fd133; /* r1p3 */
-    cpu->revidr = 0x00000000;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x41034023;
     cpu->isar.mvfr0 = 0x10110222;
     cpu->isar.mvfr1 = 0x12111111;
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 59692dddcf..ac1dace1e4 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -48,7 +48,7 @@ static void aarch64_a35_initfn(Object *obj)
 
     /* From B2.2 AArch64 identification registers. */
     cpu->midr = 0x411fd040;
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->ctr = 0x84448004;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
@@ -248,7 +248,7 @@ static void aarch64_a55_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x412FD050;          /* r2p0 */
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
 
     /* From B2.23 CCSIDR_EL1 */
     /* 32KB L1 dcache */
@@ -292,7 +292,7 @@ static void aarch64_a72_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     cpu->midr = 0x410fd083;
-    cpu->revidr = 0x00000000;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x41034080;
     cpu->isar.mvfr0 = 0x10110222;
     cpu->isar.mvfr1 = 0x12111111;
@@ -383,7 +383,7 @@ static void aarch64_a76_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x414fd0b1;          /* r4p1 */
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
 
     /* From B2.18 CCSIDR_EL1 */
     /* 64KB L1 dcache */
@@ -456,7 +456,7 @@ static void aarch64_a78ae_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x410fd423;          /* r0p3 */
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
 
     /* From 3.2.33 CCSIDR_EL1 */
     /* 64KB L1 dcache */
@@ -501,7 +501,7 @@ static void aarch64_a64fx_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     cpu->midr = 0x461f0010;
-    cpu->revidr = 0x00000000;
+    SET_IDREG(isar, REVIDR, 0);
     cpu->ctr = 0x86668006;
     cpu->reset_sctlr = 0x30000180;
     SET_IDREG(isar, ID_AA64PFR0, 0x0000000101111111); /* No RAS Extensions */
@@ -707,7 +707,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x414fd0c1;          /* r4p1 */
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
 
     /* From B2.23 CCSIDR_EL1 */
     /* 64KB L1 dcache */
@@ -787,7 +787,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
     cpu->midr = 0x411FD402;          /* r1p2 */
-    cpu->revidr = 0;
+    SET_IDREG(isar, REVIDR, 0);
 
     /*
      * The Neoverse-V1 r1p2 TRM lists 32-bit format CCSIDR_EL1 values,
@@ -984,7 +984,7 @@ static void aarch64_a710_initfn(Object *obj)
 
     /* Ordered by Section B.4: AArch64 registers */
     cpu->midr          = 0x412FD471; /* r2p1 */
-    cpu->revidr        = 0;
+    SET_IDREG(isar, REVIDR, 0);
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_DFR0, 0x16011099);
@@ -1087,7 +1087,7 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
 
     /* Ordered by Section B.5: AArch64 ID registers */
     cpu->midr          = 0x410FD493; /* r0p3 */
-    cpu->revidr        = 0;
+    SET_IDREG(isar, REVIDR, 0);
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_DFR0, 0x16011099);
-- 
2.53.0

