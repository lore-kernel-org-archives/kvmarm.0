Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1029357D17
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639473; cv=none; b=l6BEqoTsAOwI+rqkfXZzkoo3Ypmhis2ennz+Mifeo3pq2waf2kKFgXHyp21McEb0nzkSP0IIXfyU+HTh+1qW8KRQg6GDow/K0HM7bbK2UvkcLtuY9XrHSugiqCfciplwIvJmAlL9fNuXpugQUdaOSclvho4YlQU6nPIQIWZnG1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639473; c=relaxed/simple;
	bh=dBNSTrIeYO9ZAyTTZliMn/gLX9EQv3s+F7A/XpNsJhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=cCFKr5msjGylx6Jt7nu7jJLWGeQprDAfLBq5s3gXE2XhlhD6IZ/UjBXNuk6wSu+a+SIXe3sS3ltLI5a8BtBZI+iS3WSxtJeW3jHN/hiNoF9mdJaxSgJJuWTyd6VXRh3VDAPTL/O/KQDiJwbrQQdoAiC7DMQuyluE88gUbQmtuVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqUu/BZF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqUu/BZF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a91L6QEmpLwmcB+Y2iHHOG28lubjs5oHQAR7wAJRz4Q=;
	b=dqUu/BZFa6iDQz+6Fs/SRVAIJXN2uI0U9s0JueVB4tH+ixNzhXONN2ZCR0z5iwJXDA+mpP
	i+c8KqAzTTPFmKIypNowdLDk0LC9kbH6G3d04yI7J5U+xbOrGn9qOGd5phVfKxVFOy6RFx
	W3xpcd12kQq/s/4T1CjoZ9093nlkPLo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-fF6osFzfNeaNMZaOsOLPMA-1; Sat,
 10 Oct 2026 13:37:47 +0000
X-MC-Unique: fF6osFzfNeaNMZaOsOLPMA-1
X-Mimecast-MFC-AGG-ID: fF6osFzfNeaNMZaOsOLPMA_1791639465
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E39851944B0E;
	Sat, 10 Oct 2026 13:37:44 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BB58F30000E5;
	Sat, 10 Oct 2026 13:37:39 +0000 (UTC)
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
Subject: [PATCH v10 02/26] target/arm: Move MIDR into isar.idregs[] storage
Date: Sat, 10 Oct 2026 15:36:06 +0200
Message-ID: <20261010133725.642498-3-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: cGFrl75OkTLas8tgmFWPJRiZ8zHfDawdVxRG34lUARs_1791639465
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Move MIDR into the isar.idregs[] array as other ID registers.
This will allow to overwrite it as others.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu.h             |  1 -
 target/arm/cpu-sysregs.h.inc |  1 +
 hw/intc/armv7m_nvic.c        |  2 +-
 target/arm/cpu-max.c         |  2 +-
 target/arm/cpu.c             |  2 +-
 target/arm/cpu64.c           |  2 +-
 target/arm/helper.c          | 13 +++++++------
 target/arm/hvf/hvf.c         |  4 ++--
 target/arm/tcg/cpu-v7m.c     | 14 +++++++-------
 target/arm/tcg/cpu32.c       | 33 +++++++++++++++++----------------
 target/arm/tcg/cpu64.c       | 22 +++++++++++-----------
 target/arm/whpx/whpx-all.c   |  4 ++--
 12 files changed, 51 insertions(+), 49 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index b2af36a8c3..dcdd4eb18e 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1123,7 +1123,6 @@ struct ArchCPU {
         uint64_t reset_pmcr_el0;
         uint64_t idregs[NUM_ID_IDX];
     } isar;
-    uint64_t midr;
     uint32_t reset_fpsid;
     uint64_t ctr;
     uint32_t reset_sctlr;
diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index 580d88d1f4..709dc8fc97 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -41,6 +41,7 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
 DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
 DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
 DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
+DEF(MIDR_EL1, 3, 0, 0, 0, 0)
 DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
 DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
 DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
diff --git a/hw/intc/armv7m_nvic.c b/hw/intc/armv7m_nvic.c
index 1f56fff046..1f7209f6b6 100644
--- a/hw/intc/armv7m_nvic.c
+++ b/hw/intc/armv7m_nvic.c
@@ -1053,7 +1053,7 @@ static uint32_t nvic_readl(NVICState *s, uint32_t offset, MemTxAttrs attrs)
         }
         return GET_IDREG(isar, REVIDR);
     case 0xd00: /* CPUID Base.  */
-        return cpu->midr;
+        return GET_IDREG(isar, MIDR);
     case 0xd04: /* Interrupt Control State (ICSR) */
         /* VECTACTIVE */
         val = cpu->env.v7m.exception;
diff --git a/target/arm/cpu-max.c b/target/arm/cpu-max.c
index b4e57a167d..c47db5251d 100644
--- a/target/arm/cpu-max.c
+++ b/target/arm/cpu-max.c
@@ -36,7 +36,7 @@ void aarch64_aa32_a57_init(ARMCPU *cpu, bool aarch64_enabled)
     if (kvm_enabled()) {
         cpu->kvm_target = QEMU_KVM_ARM_TARGET_CORTEX_A57;
     }
-    cpu->midr = 0x411fd070;
+    SET_IDREG(isar, MIDR, 0x411fd070);
     SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x41034070;
     cpu->isar.mvfr0 = 0x10110222;
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 10ac6c9831..2f545482bc 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2501,7 +2501,7 @@ static ObjectClass *arm_cpu_class_by_name(const char *cpu_model)
 }
 
 static const Property arm_cpu_properties[] = {
-    DEFINE_PROP_UINT64("midr", ARMCPU, midr, 0),
+    DEFINE_PROP_UINT64("midr", ARMCPU, isar.idregs[MIDR_EL1_IDX], 0),
     DEFINE_PROP_UINT64("mp-affinity", ARMCPU,
                         mp_affinity, ARM64_AFFINITY_INVALID),
     DEFINE_PROP_INT32("node-id", ARMCPU, node_id, CPU_UNSET_NUMA_NODE_ID),
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 80c9c9e5b3..64103df0a7 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -716,7 +716,7 @@ static void aarch64_a53_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     cpu->kvm_target = QEMU_KVM_ARM_TARGET_CORTEX_A53;
-    cpu->midr = 0x410fd034;
+    SET_IDREG(isar, MIDR, 0x410fd034);
     SET_IDREG(isar, REVIDR, 0x00000100);
     cpu->reset_fpsid = 0x41034070;
     cpu->isar.mvfr0 = 0x10110222;
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 41c0d0df12..dfd71f1b51 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7153,12 +7153,12 @@ void register_cp_regs_for_features(ARMCPU *cpu)
             { .name = "VPIDR", .state = ARM_CP_STATE_AA32,
               .cp = 15, .opc1 = 4, .crn = 0, .crm = 0, .opc2 = 0,
               .access = PL2_RW, .accessfn = access_el3_aa32ns,
-              .resetvalue = cpu->midr,
+              .resetvalue = GET_IDREG(&cpu->isar, MIDR),
               .type = ARM_CP_ALIAS | ARM_CP_EL3_NO_EL2_C_NZ,
               .fieldoffset = offsetoflow32(CPUARMState, cp15.vpidr_el2) },
             { .name = "VPIDR_EL2", .state = ARM_CP_STATE_AA64,
               .opc0 = 3, .opc1 = 4, .crn = 0, .crm = 0, .opc2 = 0,
-              .access = PL2_RW, .resetvalue = cpu->midr,
+              .access = PL2_RW, .resetvalue = GET_IDREG(&cpu->isar, MIDR),
               .type = ARM_CP_EL3_NO_EL2_C_NZ,
               .nv2_redirect_offset = 0x88,
               .fieldoffset = offsetof(CPUARMState, cp15.vpidr_el2) },
@@ -7377,7 +7377,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
              */
             { .name = "MIDR",
               .cp = 15, .crn = 0, .crm = 0, .opc1 = 0, .opc2 = CP_ANY,
-              .access = PL1_R, .resetvalue = cpu->midr,
+              .access = PL1_R, .resetvalue = GET_IDREG(&cpu->isar, MIDR),
               .writefn = arm_cp_write_ignore, .raw_writefn = raw_write,
               .readfn = midr_read,
               .fieldoffset = offsetof(CPUARMState, cp15.c0_cpuid),
@@ -7402,14 +7402,15 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         ARMCPRegInfo id_v8_midr_cp_reginfo[] = {
             { .name = "MIDR_EL1", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 0, .opc2 = 0,
-              .access = PL1_R, .type = ARM_CP_NO_RAW, .resetvalue = cpu->midr,
+              .access = PL1_R, .type = ARM_CP_NO_RAW,
+              .resetvalue = GET_IDREG(&cpu->isar, MIDR),
               .fgt = FGT_MIDR_EL1,
               .fieldoffset = offsetof(CPUARMState, cp15.c0_cpuid),
               .readfn = midr_read },
             /* crn = 0 op1 = 0 crm = 0 op2 = 7 : AArch32 aliases of MIDR */
             { .name = "MIDR", .type = ARM_CP_ALIAS | ARM_CP_CONST,
               .cp = 15, .crn = 0, .crm = 0, .opc1 = 0, .opc2 = 7,
-              .access = PL1_R, .resetvalue = cpu->midr },
+              .access = PL1_R, .resetvalue = GET_IDREG(&cpu->isar, MIDR) },
             { .name = "REVIDR_EL1", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 0, .opc2 = 6,
               .access = PL1_R,
@@ -7420,7 +7421,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         ARMCPRegInfo id_v8_midr_alias_cp_reginfo = {
             .name = "MIDR", .type = ARM_CP_ALIAS | ARM_CP_CONST | ARM_CP_NO_GDB,
             .cp = 15, .crn = 0, .crm = 0, .opc1 = 0, .opc2 = 4,
-            .access = PL1_R, .resetvalue = cpu->midr
+            .access = PL1_R, .resetvalue = GET_IDREG(&cpu->isar, MIDR)
         };
         ARMCPRegInfo id_cp_reginfo[] = {
             /* These are common to v8 and pre-v8 */
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index b00a7e1a84..f9f3d22014 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1295,7 +1295,7 @@ void hvf_arm_set_cpu_features_from_host(ARMCPU *cpu)
     cpu->dtb_compatible = arm_host_cpu_features.dtb_compatible;
     cpu->isar = arm_host_cpu_features.isar;
     cpu->env.features = arm_host_cpu_features.features;
-    cpu->midr = arm_host_cpu_features.midr;
+    SET_IDREG(&cpu->isar, MIDR, arm_host_cpu_features.midr);
     cpu->reset_sctlr = arm_host_cpu_features.reset_sctlr;
     cpu->sme_vq.supported = arm_host_cpu_features.sme_vq_supported;
 }
@@ -1472,7 +1472,7 @@ int hvf_arch_init_vcpu(CPUState *cpu)
 
     /* Set CP_NO_RAW system registers on init */
     ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_MIDR_EL1,
-                              arm_cpu->midr);
+                              GET_IDREG(&arm_cpu->isar, MIDR));
     assert_hvf_ok(ret);
 
     ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_MPIDR_EL1,
diff --git a/target/arm/tcg/cpu-v7m.c b/target/arm/tcg/cpu-v7m.c
index e7c61d3c31..20d40f176d 100644
--- a/target/arm/tcg/cpu-v7m.c
+++ b/target/arm/tcg/cpu-v7m.c
@@ -49,7 +49,7 @@ static void cortex_m0_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_V6);
     set_feature(&cpu->env, ARM_FEATURE_M);
 
-    cpu->midr = 0x410cc200;
+    SET_IDREG(isar, MIDR, 0x410cc200);
 
     /*
      * These ID register values are not guest visible, because
@@ -83,7 +83,7 @@ static void cortex_m3_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_V7);
     set_feature(&cpu->env, ARM_FEATURE_M);
     set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
-    cpu->midr = 0x410fc231;
+    SET_IDREG(isar, MIDR, 0x410fc231);
     cpu->pmsav7_dregion = 8;
     SET_IDREG(isar, ID_PFR0, 0x00000030);
     SET_IDREG(isar, ID_PFR1, 0x00000200);
@@ -111,7 +111,7 @@ static void cortex_m4_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M);
     set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
     set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x410fc240; /* r0p0 */
+    SET_IDREG(isar, MIDR, 0x410fc240); /* r0p0 */
     cpu->pmsav7_dregion = 8;
     cpu->isar.mvfr0 = 0x10110021;
     cpu->isar.mvfr1 = 0x11000011;
@@ -142,7 +142,7 @@ static void cortex_m7_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M);
     set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
     set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x411fc272; /* r1p2 */
+    SET_IDREG(isar, MIDR, 0x411fc272); /* r1p2 */
     cpu->pmsav7_dregion = 8;
     cpu->isar.mvfr0 = 0x10110221;
     cpu->isar.mvfr1 = 0x12000011;
@@ -174,7 +174,7 @@ static void cortex_m33_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
     set_feature(&cpu->env, ARM_FEATURE_M_SECURITY);
     set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x410fd213; /* r0p3 */
+    SET_IDREG(isar, MIDR, 0x410fd213); /* r0p3 */
     cpu->pmsav7_dregion = 16;
     cpu->sau_sregion = 8;
     cpu->isar.mvfr0 = 0x10110021;
@@ -210,7 +210,7 @@ static void cortex_m55_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
     set_feature(&cpu->env, ARM_FEATURE_M_SECURITY);
     set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x410fd221; /* r0p1 */
+    SET_IDREG(isar, MIDR, 0x410fd221); /* r0p1 */
     SET_IDREG(isar, REVIDR, 0);
     cpu->pmsav7_dregion = 16;
     cpu->sau_sregion = 8;
@@ -248,7 +248,7 @@ static void cortex_m85_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_M_MAIN);
     set_feature(&cpu->env, ARM_FEATURE_M_SECURITY);
     set_feature(&cpu->env, ARM_FEATURE_THUMB_DSP);
-    cpu->midr = 0x411fd231; /* r1p1 */
+    SET_IDREG(isar, MIDR, 0x411fd231); /* r1p1 */
     SET_IDREG(isar, REVIDR, 0);
     cpu->pmsav7_dregion = 16;
     cpu->sau_sregion = 8;
diff --git a/target/arm/tcg/cpu32.c b/target/arm/tcg/cpu32.c
index c02b737fc0..faeeeff4ea 100644
--- a/target/arm/tcg/cpu32.c
+++ b/target/arm/tcg/cpu32.c
@@ -27,7 +27,8 @@ static void arm926_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_V5);
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
     set_feature(&cpu->env, ARM_FEATURE_CACHE_TEST_CLEAN);
-    cpu->midr = 0x41069265;
+    SET_IDREG(&cpu->isar, MIDR, 0x41069265);
+
     cpu->reset_fpsid = 0x41011090;
     cpu->ctr = 0x1dd20d2;
     cpu->reset_sctlr = 0x00050078;
@@ -54,7 +55,7 @@ static void arm946_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_V5);
     set_feature(&cpu->env, ARM_FEATURE_PMSA);
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x41059461;
+    SET_IDREG(&cpu->isar, MIDR, 0x41059461);
     cpu->ctr = 0x0f004006;
     cpu->reset_sctlr = 0x00000078;
 }
@@ -68,7 +69,7 @@ static void arm1026_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_AUXCR);
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
     set_feature(&cpu->env, ARM_FEATURE_CACHE_TEST_CLEAN);
-    cpu->midr = 0x4106a262;
+    SET_IDREG(&cpu->isar, MIDR, 0x4106a262);
     cpu->reset_fpsid = 0x410110a0;
     cpu->ctr = 0x1dd20d2;
     cpu->reset_sctlr = 0x00050078;
@@ -117,7 +118,7 @@ static void arm1136_r2_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
     set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
     set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
-    cpu->midr = 0x4107b362;
+    SET_IDREG(isar, MIDR, 0x4107b362);
     cpu->reset_fpsid = 0x410120b4;
     cpu->isar.mvfr0 = 0x11111111;
     cpu->isar.mvfr1 = 0x00000000;
@@ -149,7 +150,7 @@ static void arm1136_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
     set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
     set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
-    cpu->midr = 0x4117b363;
+    SET_IDREG(isar, MIDR, 0x4117b363);
     cpu->reset_fpsid = 0x410120b4;
     cpu->isar.mvfr0 = 0x11111111;
     cpu->isar.mvfr1 = 0x00000000;
@@ -182,7 +183,7 @@ static void arm1176_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_CACHE_DIRTY_REG);
     set_feature(&cpu->env, ARM_FEATURE_CACHE_BLOCK_OPS);
     set_feature(&cpu->env, ARM_FEATURE_EL3);
-    cpu->midr = 0x410fb767;
+    SET_IDREG(isar, MIDR, 0x410fb767);
     cpu->reset_fpsid = 0x410120b5;
     cpu->isar.mvfr0 = 0x11111111;
     cpu->isar.mvfr1 = 0x00000000;
@@ -213,7 +214,7 @@ static void arm11mpcore_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_VAPA);
     set_feature(&cpu->env, ARM_FEATURE_MPIDR);
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x410fb022;
+    SET_IDREG(isar, MIDR, 0x410fb022);
     cpu->reset_fpsid = 0x410120b4;
     cpu->isar.mvfr0 = 0x11111111;
     cpu->isar.mvfr1 = 0x00000000;
@@ -257,7 +258,7 @@ static void cortex_a8_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
-    cpu->midr = 0x410fc080;
+    SET_IDREG(isar, MIDR, 0x410fc080);
     cpu->reset_fpsid = 0x410330c0;
     cpu->isar.mvfr0 = 0x11110222;
     cpu->isar.mvfr1 = 0x00011111;
@@ -335,7 +336,7 @@ static void cortex_a9_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_V7MP);
     set_feature(&cpu->env, ARM_FEATURE_CBAR);
     set_feature(&cpu->env, ARM_FEATURE_D32DIS);
-    cpu->midr = 0x410fc090;
+    SET_IDREG(isar, MIDR, 0x410fc090);
     cpu->reset_fpsid = 0x41033090;
     cpu->isar.mvfr0 = 0x11110222;
     cpu->isar.mvfr1 = 0x01111111;
@@ -403,7 +404,7 @@ static void cortex_a7_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     set_feature(&cpu->env, ARM_FEATURE_D32DIS);
-    cpu->midr = 0x410fc075;
+    SET_IDREG(isar, MIDR, 0x410fc075);
     cpu->reset_fpsid = 0x41023075;
     cpu->isar.mvfr0 = 0x10110222;
     cpu->isar.mvfr1 = 0x11111111;
@@ -455,7 +456,7 @@ static void cortex_a15_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
     /* r4p0 cpu, not requiring expensive tlb flush errata */
-    cpu->midr = 0x414fc0f0;
+    SET_IDREG(isar, MIDR, 0x414fc0f0);
     SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x410430f0;
     cpu->isar.mvfr0 = 0x10110222;
@@ -505,7 +506,7 @@ static void cortex_r5_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_V7MP);
     set_feature(&cpu->env, ARM_FEATURE_PMSA);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
-    cpu->midr = 0x411fc153; /* r1p3 */
+    SET_IDREG(isar, MIDR, 0x411fc153); /* r1p3 */
     SET_IDREG(isar, ID_PFR0, 0x0131);
     SET_IDREG(isar, ID_PFR1, 0x001);
     SET_IDREG(isar, ID_DFR0, 0x010400);
@@ -646,7 +647,7 @@ static void cortex_r52_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_BACKCOMPAT_CNTFRQ);
     set_feature(&cpu->env, ARM_FEATURE_CBAR_RO);
     set_feature(&cpu->env, ARM_FEATURE_AUXCR);
-    cpu->midr = 0x411fd133; /* r1p3 */
+    SET_IDREG(isar, MIDR, 0x411fd133); /* r1p3 */
     SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x41034023;
     cpu->isar.mvfr0 = 0x10110222;
@@ -694,7 +695,7 @@ static void ti925t_initfn(Object *obj)
     ARMCPU *cpu = ARM_CPU(obj);
     set_feature(&cpu->env, ARM_FEATURE_V4T);
     set_feature(&cpu->env, ARM_FEATURE_OMAPCP);
-    cpu->midr = ARM_CPUID_TI925T;
+    SET_IDREG(&cpu->isar, MIDR, ARM_CPUID_TI925T);
     cpu->ctr = 0x5109149;
     cpu->reset_sctlr = 0x00000070;
 }
@@ -706,7 +707,7 @@ static void sa1100_initfn(Object *obj)
     cpu->dtb_compatible = "intel,sa1100";
     set_feature(&cpu->env, ARM_FEATURE_STRONGARM);
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x4401A11B;
+    SET_IDREG(&cpu->isar, MIDR, 0x4401A11B);
     cpu->reset_sctlr = 0x00000070;
 }
 
@@ -715,7 +716,7 @@ static void sa1110_initfn(Object *obj)
     ARMCPU *cpu = ARM_CPU(obj);
     set_feature(&cpu->env, ARM_FEATURE_STRONGARM);
     set_feature(&cpu->env, ARM_FEATURE_DUMMY_C15_REGS);
-    cpu->midr = 0x6901B119;
+    SET_IDREG(&cpu->isar, MIDR, 0x6901B119);
     cpu->reset_sctlr = 0x00000070;
 }
 
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index ac1dace1e4..d73d792ad9 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -47,7 +47,7 @@ static void aarch64_a35_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_PMU);
 
     /* From B2.2 AArch64 identification registers. */
-    cpu->midr = 0x411fd040;
+    SET_IDREG(isar, MIDR, 0x411fd040);
     SET_IDREG(isar, REVIDR, 0);
     cpu->ctr = 0x84448004;
     SET_IDREG(isar, ID_PFR0, 0x00000131);
@@ -247,7 +247,7 @@ static void aarch64_a55_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR0, 0x10010131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_PFR2, 0x00000011);
-    cpu->midr = 0x412FD050;          /* r2p0 */
+    SET_IDREG(isar, MIDR, 0x412FD050); /* r2p0 */
     SET_IDREG(isar, REVIDR, 0);
 
     /* From B2.23 CCSIDR_EL1 */
@@ -291,7 +291,7 @@ static void aarch64_a72_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL2);
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
-    cpu->midr = 0x410fd083;
+    SET_IDREG(isar, MIDR, 0x410fd083);
     SET_IDREG(isar, REVIDR, 0);
     cpu->reset_fpsid = 0x41034080;
     cpu->isar.mvfr0 = 0x10110222;
@@ -382,7 +382,7 @@ static void aarch64_a76_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR0, 0x10010131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
-    cpu->midr = 0x414fd0b1;          /* r4p1 */
+    SET_IDREG(isar, MIDR, 0x414fd0b1); /* r4p1 */
     SET_IDREG(isar, REVIDR, 0);
 
     /* From B2.18 CCSIDR_EL1 */
@@ -455,7 +455,7 @@ static void aarch64_a78ae_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR0, 0x10010131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
-    cpu->midr = 0x410fd423;          /* r0p3 */
+    SET_IDREG(isar, MIDR, 0x410fd423); /* r0p3 */
     SET_IDREG(isar, REVIDR, 0);
 
     /* From 3.2.33 CCSIDR_EL1 */
@@ -500,7 +500,7 @@ static void aarch64_a64fx_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_EL2);
     set_feature(&cpu->env, ARM_FEATURE_EL3);
     set_feature(&cpu->env, ARM_FEATURE_PMU);
-    cpu->midr = 0x461f0010;
+    SET_IDREG(isar, MIDR, 0x461f0010);
     SET_IDREG(isar, REVIDR, 0);
     cpu->ctr = 0x86668006;
     cpu->reset_sctlr = 0x30000180;
@@ -706,7 +706,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR0, 0x10010131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
-    cpu->midr = 0x414fd0c1;          /* r4p1 */
+    SET_IDREG(isar, MIDR, 0x414fd0c1); /* r4p1 */
     SET_IDREG(isar, REVIDR, 0);
 
     /* From B2.23 CCSIDR_EL1 */
@@ -786,7 +786,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
-    cpu->midr = 0x411FD402;          /* r1p2 */
+    SET_IDREG(isar, MIDR, 0x411FD402); /* r1p2 */
     SET_IDREG(isar, REVIDR, 0);
 
     /*
@@ -983,7 +983,7 @@ static void aarch64_a710_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_PMU);
 
     /* Ordered by Section B.4: AArch64 registers */
-    cpu->midr          = 0x412FD471; /* r2p1 */
+    SET_IDREG(isar, MIDR, 0x412FD471); /* r2p1 */
     SET_IDREG(isar, REVIDR, 0);
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
@@ -1086,7 +1086,7 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     set_feature(&cpu->env, ARM_FEATURE_PMU);
 
     /* Ordered by Section B.5: AArch64 ID registers */
-    cpu->midr          = 0x410FD493; /* r0p3 */
+    SET_IDREG(isar, MIDR, 0x410FD493); /* r0p3 */
     SET_IDREG(isar, REVIDR, 0);
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
@@ -1214,7 +1214,7 @@ void aarch64_max_v8_tcg_initfn(Object *obj)
     t = FIELD_DP64(t, MIDR_EL1, PARTNUM, 'Q');
     t = FIELD_DP64(t, MIDR_EL1, VARIANT, 0);
     t = FIELD_DP64(t, MIDR_EL1, REVISION, 0);
-    cpu->midr = t;
+    SET_IDREG(isar, MIDR, t);
 
     /*
      * We're going to set FEAT_S2FWB, which mandates that CLIDR_EL1.{LoUU,LoUIS}
diff --git a/target/arm/whpx/whpx-all.c b/target/arm/whpx/whpx-all.c
index 46f0b9524e..18009d6c8d 100644
--- a/target/arm/whpx/whpx-all.c
+++ b/target/arm/whpx/whpx-all.c
@@ -775,7 +775,7 @@ void whpx_arm_set_cpu_features_from_host(ARMCPU *cpu)
     cpu->dtb_compatible = arm_host_cpu_features.dtb_compatible;
     cpu->isar = arm_host_cpu_features.isar;
     cpu->env.features = arm_host_cpu_features.features;
-    cpu->midr = arm_host_cpu_features.midr;
+    SET_IDREG(&cpu->isar, MIDR, arm_host_cpu_features.midr);
     cpu->reset_sctlr = arm_host_cpu_features.reset_sctlr;
 }
 
@@ -836,7 +836,7 @@ int whpx_init_vcpu(CPUState *cpu)
     assert(write_cpustate_to_list(arm_cpu, false));
 
     /* Set CP_NO_RAW system registers on init */
-    val.Reg64 = arm_cpu->midr;
+    val.Reg64 = GET_IDREG(&arm_cpu->isar, MIDR);
     whpx_set_reg(cpu, WHvArm64RegisterMidrEl1,
                               val);
 
-- 
2.53.0

