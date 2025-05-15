Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB05211A0D
	for <kvmarm@lists.linux.dev>; Thu, 15 May 2025 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747323648; cv=none; b=aKdB6sqXJBI/dIxnvFltP4hDipoUgELNYwbvKZejNirP5NCCBLi5Vrvjl2OCgXYpUhO7VhEbqvwB6A4Q8kKfCEcFQcvpKMQhixJ5ApB3jf8jZZsuAObJyspA9JOrFoNVDM8bxBHF/P4dsmu7Aow4AMuZ5OrRSOg2ZGDQuyMdJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747323648; c=relaxed/simple;
	bh=XT7gqj0/rx2NZYyAA9lfcQi1ea+ON6zXHqVK2GW5LxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=HLUL12dMiLbCIsD6rIWez6B/R8J5LnUxrs9hfkzRfY/RFgYUIu+vLdW6XphIOy+q9+LM6qaEA/3pAW8mshd+v7FctCJJ5STnM0bZebPv7akUV0/5fW4UjRWBgSvB0OAcBWGaeS0C1ExCHy+Rk6FGS566oz2Te51bdmtET/t9bkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EumaUCBs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EumaUCBs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747323645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jLMY4B95tMDEcn1I0ekfG1qBiea3kBtciNE621l7+xs=;
	b=EumaUCBscmRh8rL9rGp5MVBr6zhAcHIIlH0D5c02RXjwxskOdjpCOCgNn9j2A3TbaM4Aef
	aWhsGqCI+pHrqR3aescMezhaXG6FmxFDcXDJlAUBzTR2h9Qm0EJ0vwpiQRxK86476oPWjf
	DDnVl6Lq/p0tccb15aJMl2VQZE730cM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-XVnQagRBP1mFUPZ4hpfiog-1; Thu,
 15 May 2025 11:40:42 -0400
X-MC-Unique: XVnQagRBP1mFUPZ4hpfiog-1
X-Mimecast-MFC-AGG-ID: XVnQagRBP1mFUPZ4hpfiog_1747323640
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 389311955DB0;
	Thu, 15 May 2025 15:40:40 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.45.225.145])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B14D81956066;
	Thu, 15 May 2025 15:40:33 +0000 (UTC)
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
Subject: [PATCH v7 11/14] arm/cpu: Store id_mmfr0-5 into the idregs array
Date: Thu, 15 May 2025 17:39:04 +0200
Message-ID: <20250515153907.151174-12-cohuck@redhat.com>
In-Reply-To: <20250515153907.151174-1-cohuck@redhat.com>
References: <20250515153907.151174-1-cohuck@redhat.com>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/intc/armv7m_nvic.c     |  8 ++--
 target/arm/cpu-features.h | 18 ++++----
 target/arm/cpu.h          |  6 ---
 target/arm/cpu64.c        | 16 +++----
 target/arm/helper.c       | 12 ++---
 target/arm/kvm.c          | 18 +++-----
 target/arm/tcg/cpu-v7m.c  | 48 ++++++++++----------
 target/arm/tcg/cpu32.c    | 94 +++++++++++++++++++--------------------
 target/arm/tcg/cpu64.c    | 76 +++++++++++++++----------------
 9 files changed, 140 insertions(+), 156 deletions(-)

diff --git a/hw/intc/armv7m_nvic.c b/hw/intc/armv7m_nvic.c
index 2566dd634318..6d85720f1b46 100644
--- a/hw/intc/armv7m_nvic.c
+++ b/hw/intc/armv7m_nvic.c
@@ -1284,22 +1284,22 @@ static uint32_t nvic_readl(NVICState *s, uint32_t offset, MemTxAttrs attrs)
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
         }
-        return cpu->isar.id_mmfr0;
+        return GET_IDREG(isar, ID_MMFR0);
     case 0xd54: /* MMFR1.  */
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
         }
-        return cpu->isar.id_mmfr1;
+        return GET_IDREG(isar, ID_MMFR1);
     case 0xd58: /* MMFR2.  */
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
         }
-        return cpu->isar.id_mmfr2;
+        return GET_IDREG(isar, ID_MMFR2);
     case 0xd5c: /* MMFR3.  */
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
         }
-        return cpu->isar.id_mmfr3;
+        return GET_IDREG(isar, ID_MMFR3);
     case 0xd60: /* ISAR0.  */
         if (!arm_feature(&cpu->env, ARM_FEATURE_M_MAIN)) {
             goto bad_offset;
diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
index cad34f0ad403..db3c99e42964 100644
--- a/target/arm/cpu-features.h
+++ b/target/arm/cpu-features.h
@@ -283,17 +283,17 @@ static inline bool isar_feature_aa32_vminmaxnm(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa32_pxn(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr0, ID_MMFR0, VMSA) >= 4;
+    return FIELD_EX32_IDREG(id, ID_MMFR0, VMSA) >= 4;
 }
 
 static inline bool isar_feature_aa32_pan(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr3, ID_MMFR3, PAN) != 0;
+    return FIELD_EX32_IDREG(id, ID_MMFR3, PAN) != 0;
 }
 
 static inline bool isar_feature_aa32_ats1e1(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr3, ID_MMFR3, PAN) >= 2;
+    return FIELD_EX32_IDREG(id, ID_MMFR3, PAN) >= 2;
 }
 
 static inline bool isar_feature_aa32_pmuv3p1(const ARMISARegisters *id)
@@ -319,32 +319,32 @@ static inline bool isar_feature_aa32_pmuv3p5(const ARMISARegisters *id)
 
 static inline bool isar_feature_aa32_hpd(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr4, ID_MMFR4, HPDS) != 0;
+    return FIELD_EX32_IDREG(id, ID_MMFR4, HPDS) != 0;
 }
 
 static inline bool isar_feature_aa32_ac2(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr4, ID_MMFR4, AC2) != 0;
+    return FIELD_EX32_IDREG(id, ID_MMFR4, AC2) != 0;
 }
 
 static inline bool isar_feature_aa32_ccidx(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr4, ID_MMFR4, CCIDX) != 0;
+    return FIELD_EX32_IDREG(id, ID_MMFR4, CCIDX) != 0;
 }
 
 static inline bool isar_feature_aa32_tts2uxn(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr4, ID_MMFR4, XNX) != 0;
+    return FIELD_EX32_IDREG(id, ID_MMFR4, XNX) != 0;
 }
 
 static inline bool isar_feature_aa32_half_evt(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr4, ID_MMFR4, EVT) >= 1;
+    return FIELD_EX32_IDREG(id, ID_MMFR4, EVT) >= 1;
 }
 
 static inline bool isar_feature_aa32_evt(const ARMISARegisters *id)
 {
-    return FIELD_EX32(id->id_mmfr4, ID_MMFR4, EVT) >= 2;
+    return FIELD_EX32_IDREG(id, ID_MMFR4, EVT) >= 2;
 }
 
 static inline bool isar_feature_aa32_dit(const ARMISARegisters *id)
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index fcc10b23080e..465de32febeb 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1050,12 +1050,6 @@ struct ArchCPU {
      * field by reading the value from the KVM vCPU.
      */
     struct ARMISARegisters {
-        uint32_t id_mmfr0;
-        uint32_t id_mmfr1;
-        uint32_t id_mmfr2;
-        uint32_t id_mmfr3;
-        uint32_t id_mmfr4;
-        uint32_t id_mmfr5;
         uint32_t mvfr0;
         uint32_t mvfr1;
         uint32_t mvfr2;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index fb425dac4802..2891ce7b6bf2 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -656,10 +656,10 @@ static void aarch64_a57_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x10101105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02102211;
+    SET_IDREG(isar, ID_MMFR0, 0x10101105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02102211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
@@ -718,10 +718,10 @@ static void aarch64_a53_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x10101105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02102211;
+    SET_IDREG(isar, ID_MMFR0, 0x10101105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02102211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
diff --git a/target/arm/helper.c b/target/arm/helper.c
index b3ce41173174..d86d23e72224 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -7812,22 +7812,22 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 1, .opc2 = 4,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa32_tid3,
-              .resetvalue = cpu->isar.id_mmfr0 },
+              .resetvalue = GET_IDREG(isar, ID_MMFR0)},
             { .name = "ID_MMFR1", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 1, .opc2 = 5,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa32_tid3,
-              .resetvalue = cpu->isar.id_mmfr1 },
+              .resetvalue = GET_IDREG(isar, ID_MMFR1)},
             { .name = "ID_MMFR2", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 1, .opc2 = 6,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa32_tid3,
-              .resetvalue = cpu->isar.id_mmfr2 },
+              .resetvalue = GET_IDREG(isar, ID_MMFR2)},
             { .name = "ID_MMFR3", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 1, .opc2 = 7,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa32_tid3,
-              .resetvalue = cpu->isar.id_mmfr3 },
+              .resetvalue = GET_IDREG(isar, ID_MMFR3)},
             { .name = "ID_ISAR0", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 2, .opc2 = 0,
               .access = PL1_R, .type = ARM_CP_CONST,
@@ -7862,7 +7862,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 2, .opc2 = 6,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa32_tid3,
-              .resetvalue = cpu->isar.id_mmfr4 },
+              .resetvalue = GET_IDREG(isar, ID_MMFR4)},
             { .name = "ID_ISAR6", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 2, .opc2 = 7,
               .access = PL1_R, .type = ARM_CP_CONST,
@@ -8142,7 +8142,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 6,
               .access = PL1_R, .type = ARM_CP_CONST,
               .accessfn = access_aa64_tid3,
-              .resetvalue = cpu->isar.id_mmfr5 },
+              .resetvalue = GET_IDREG(isar, ID_MMFR5)},
             { .name = "RES_0_C0_C3_7", .state = ARM_CP_STATE_BOTH,
               .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 3, .opc2 = 7,
               .access = PL1_R, .type = ARM_CP_CONST,
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 619e5c935e2d..6c665334658b 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -335,14 +335,10 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg(fd, ahcf, ID_PFR0_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_PFR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_DFR0_EL1_IDX);
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr0,
-                              ARM64_SYS_REG(3, 0, 0, 1, 4));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr1,
-                              ARM64_SYS_REG(3, 0, 0, 1, 5));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr2,
-                              ARM64_SYS_REG(3, 0, 0, 1, 6));
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr3,
-                              ARM64_SYS_REG(3, 0, 0, 1, 7));
+        err |= get_host_cpu_reg(fd, ahcf, ID_MMFR0_EL1_IDX);
+        err |= get_host_cpu_reg(fd, ahcf, ID_MMFR1_EL1_IDX);
+        err |= get_host_cpu_reg(fd, ahcf, ID_MMFR2_EL1_IDX);
+        err |= get_host_cpu_reg(fd, ahcf, ID_MMFR3_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_ISAR0_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_ISAR1_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_ISAR2_EL1_IDX);
@@ -350,8 +346,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         err |= get_host_cpu_reg(fd, ahcf, ID_ISAR4_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_ISAR5_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_ISAR6_EL1_IDX);
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr4,
-                              ARM64_SYS_REG(3, 0, 0, 2, 6));
+        err |= get_host_cpu_reg(fd, ahcf, ID_MMFR4_EL1_IDX);
 
         err |= read_sys_reg32(fdarray[2], &ahcf->isar.mvfr0,
                               ARM64_SYS_REG(3, 0, 0, 3, 0));
@@ -361,8 +356,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
                               ARM64_SYS_REG(3, 0, 0, 3, 2));
         err |= get_host_cpu_reg(fd, ahcf, ID_PFR2_EL1_IDX);
         err |= get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
-        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr5,
-                              ARM64_SYS_REG(3, 0, 0, 3, 6));
+        err |= get_host_cpu_reg(fd, ahcf, ID_MMFR5_EL1_IDX);
 
         /*
          * DBGDIDR is a bit complicated because the kernel doesn't
diff --git a/target/arm/tcg/cpu-v7m.c b/target/arm/tcg/cpu-v7m.c
index 37a9e5154ad9..b35865d85bc2 100644
--- a/target/arm/tcg/cpu-v7m.c
+++ b/target/arm/tcg/cpu-v7m.c
@@ -63,10 +63,10 @@ static void cortex_m0_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00000200);
     SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00000030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x00000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
+    SET_IDREG(isar, ID_MMFR0, 0x00000030);
+    SET_IDREG(isar, ID_MMFR1, 0x00000000);
+    SET_IDREG(isar, ID_MMFR2, 0x00000000);
+    SET_IDREG(isar, ID_MMFR3, 0x00000000);
     SET_IDREG(isar, ID_ISAR0, 0x01141110);
     SET_IDREG(isar, ID_ISAR1, 0x02111000);
     SET_IDREG(isar, ID_ISAR2, 0x21112231);
@@ -89,10 +89,10 @@ static void cortex_m3_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00000200);
     SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00000030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x00000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
+    SET_IDREG(isar, ID_MMFR0, 0x00000030);
+    SET_IDREG(isar, ID_MMFR1, 0x00000000);
+    SET_IDREG(isar, ID_MMFR2, 0x00000000);
+    SET_IDREG(isar, ID_MMFR3, 0x00000000);
     SET_IDREG(isar, ID_ISAR0, 0x01141110);
     SET_IDREG(isar, ID_ISAR1, 0x02111000);
     SET_IDREG(isar, ID_ISAR2, 0x21112231);
@@ -120,10 +120,10 @@ static void cortex_m4_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00000200);
     SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00000030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x00000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
+    SET_IDREG(isar, ID_MMFR0, 0x00000030);
+    SET_IDREG(isar, ID_MMFR1, 0x00000000);
+    SET_IDREG(isar, ID_MMFR2, 0x00000000);
+    SET_IDREG(isar, ID_MMFR3, 0x00000000);
     SET_IDREG(isar, ID_ISAR0, 0x01141110);
     SET_IDREG(isar, ID_ISAR1, 0x02111000);
     SET_IDREG(isar, ID_ISAR2, 0x21112231);
@@ -151,10 +151,10 @@ static void cortex_m7_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00000200);
     SET_IDREG(isar, ID_DFR0, 0x00100000);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00100030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x01000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
+    SET_IDREG(isar, ID_MMFR0, 0x00100030);
+    SET_IDREG(isar, ID_MMFR1, 0x00000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01000000);
+    SET_IDREG(isar, ID_MMFR3, 0x00000000);
     SET_IDREG(isar, ID_ISAR0, 0x01101110);
     SET_IDREG(isar, ID_ISAR1, 0x02112000);
     SET_IDREG(isar, ID_ISAR2, 0x20232231);
@@ -184,10 +184,10 @@ static void cortex_m33_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00000210);
     SET_IDREG(isar, ID_DFR0, 0x00200000);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00101F40;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x01000000;
-    cpu->isar.id_mmfr3 = 0x00000000;
+    SET_IDREG(isar, ID_MMFR0, 0x00101F40);
+    SET_IDREG(isar, ID_MMFR1, 0x00000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01000000);
+    SET_IDREG(isar, ID_MMFR3, 0x00000000);
     SET_IDREG(isar, ID_ISAR0, 0x01101110);
     SET_IDREG(isar, ID_ISAR1, 0x02212000);
     SET_IDREG(isar, ID_ISAR2, 0x20232232);
@@ -222,10 +222,10 @@ static void cortex_m55_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00000230);
     SET_IDREG(isar, ID_DFR0, 0x10200000);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00111040;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x01000000;
-    cpu->isar.id_mmfr3 = 0x00000011;
+    SET_IDREG(isar, ID_MMFR0, 0x00111040);
+    SET_IDREG(isar, ID_MMFR1, 0x00000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01000000);
+    SET_IDREG(isar, ID_MMFR3, 0x00000011);
     SET_IDREG(isar, ID_ISAR0, 0x01103110);
     SET_IDREG(isar, ID_ISAR1, 0x02212000);
     SET_IDREG(isar, ID_ISAR2, 0x20232232);
diff --git a/target/arm/tcg/cpu32.c b/target/arm/tcg/cpu32.c
index bec69fe52e47..942b636aa5bd 100644
--- a/target/arm/tcg/cpu32.c
+++ b/target/arm/tcg/cpu32.c
@@ -55,21 +55,17 @@ void aa32_max_features(ARMCPU *cpu)
     t = FIELD_DP32(t, MVFR2, FPMISC, 4);          /* FP MaxNum */
     cpu->isar.mvfr2 = t;
 
-    t = cpu->isar.id_mmfr3;
-    t = FIELD_DP32(t, ID_MMFR3, PAN, 2);          /* FEAT_PAN2 */
-    cpu->isar.id_mmfr3 = t;
+    FIELD_DP32_IDREG(isar, ID_MMFR3, PAN, 2);          /* FEAT_PAN2 */
 
-    t = cpu->isar.id_mmfr4;
+    t = GET_IDREG(isar, ID_MMFR4);
     t = FIELD_DP32(t, ID_MMFR4, HPDS, 2);         /* FEAT_HPDS2 */
     t = FIELD_DP32(t, ID_MMFR4, AC2, 1);          /* ACTLR2, HACTLR2 */
     t = FIELD_DP32(t, ID_MMFR4, CNP, 1);          /* FEAT_TTCNP */
     t = FIELD_DP32(t, ID_MMFR4, XNX, 1);          /* FEAT_XNX */
     t = FIELD_DP32(t, ID_MMFR4, EVT, 2);          /* FEAT_EVT */
-    cpu->isar.id_mmfr4 = t;
+    SET_IDREG(isar, ID_MMFR4, t);
 
-    t = cpu->isar.id_mmfr5;
-    t = FIELD_DP32(t, ID_MMFR5, ETS, 2);          /* FEAT_ETS2 */
-    cpu->isar.id_mmfr5 = t;
+    FIELD_DP32_IDREG(isar, ID_MMFR5, ETS, 2);          /* FEAT_ETS2 */
 
     t = GET_IDREG(isar, ID_PFR0);
     t = FIELD_DP32(t, ID_PFR0, CSV2, 2);          /* FEAT_CSV2 */
@@ -230,9 +226,9 @@ static void arm1136_r2_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x1);
     SET_IDREG(isar, ID_DFR0, 0x2);
     cpu->id_afr0 = 0x3;
-    cpu->isar.id_mmfr0 = 0x01130003;
-    cpu->isar.id_mmfr1 = 0x10030302;
-    cpu->isar.id_mmfr2 = 0x01222110;
+    SET_IDREG(isar, ID_MMFR0, 0x01130003);
+    SET_IDREG(isar, ID_MMFR1, 0x10030302);
+    SET_IDREG(isar, ID_MMFR2, 0x01222110);
     SET_IDREG(isar, ID_ISAR0, 0x00140011);
     SET_IDREG(isar, ID_ISAR1, 0x12002111);
     SET_IDREG(isar, ID_ISAR2, 0x11231111);
@@ -262,9 +258,9 @@ static void arm1136_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x1);
     SET_IDREG(isar, ID_DFR0, 0x2);
     cpu->id_afr0 = 0x3;
-    cpu->isar.id_mmfr0 = 0x01130003;
-    cpu->isar.id_mmfr1 = 0x10030302;
-    cpu->isar.id_mmfr2 = 0x01222110;
+    SET_IDREG(isar, ID_MMFR0, 0x01130003);
+    SET_IDREG(isar, ID_MMFR1, 0x10030302);
+    SET_IDREG(isar, ID_MMFR2, 0x01222110);
     SET_IDREG(isar, ID_ISAR0, 0x00140011);
     SET_IDREG(isar, ID_ISAR1, 0x12002111);
     SET_IDREG(isar, ID_ISAR2, 0x11231111);
@@ -295,9 +291,9 @@ static void arm1176_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x11);
     SET_IDREG(isar, ID_DFR0, 0x33);
     cpu->id_afr0 = 0;
-    cpu->isar.id_mmfr0 = 0x01130003;
-    cpu->isar.id_mmfr1 = 0x10030302;
-    cpu->isar.id_mmfr2 = 0x01222100;
+    SET_IDREG(isar, ID_MMFR0, 0x01130003);
+    SET_IDREG(isar, ID_MMFR1, 0x10030302);
+    SET_IDREG(isar, ID_MMFR2, 0x01222100);
     SET_IDREG(isar, ID_ISAR0, 0x0140011);
     SET_IDREG(isar, ID_ISAR1, 0x12002111);
     SET_IDREG(isar, ID_ISAR2, 0x11231121);
@@ -325,9 +321,9 @@ static void arm11mpcore_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x1);
     SET_IDREG(isar, ID_DFR0, 0);
     cpu->id_afr0 = 0x2;
-    cpu->isar.id_mmfr0 = 0x01100103;
-    cpu->isar.id_mmfr1 = 0x10020302;
-    cpu->isar.id_mmfr2 = 0x01222000;
+    SET_IDREG(isar, ID_MMFR0, 0x01100103);
+    SET_IDREG(isar, ID_MMFR1, 0x10020302);
+    SET_IDREG(isar, ID_MMFR2, 0x01222000);
     SET_IDREG(isar, ID_ISAR0, 0x00100011);
     SET_IDREG(isar, ID_ISAR1, 0x12002111);
     SET_IDREG(isar, ID_ISAR2, 0x11221011);
@@ -365,10 +361,10 @@ static void cortex_a8_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x11);
     SET_IDREG(isar, ID_DFR0, 0x400);
     cpu->id_afr0 = 0;
-    cpu->isar.id_mmfr0 = 0x31100003;
-    cpu->isar.id_mmfr1 = 0x20000000;
-    cpu->isar.id_mmfr2 = 0x01202000;
-    cpu->isar.id_mmfr3 = 0x11;
+    SET_IDREG(isar, ID_MMFR0, 0x31100003);
+    SET_IDREG(isar, ID_MMFR1, 0x20000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01202000);
+    SET_IDREG(isar, ID_MMFR3, 0x11);
     SET_IDREG(isar, ID_ISAR0, 0x00101111);
     SET_IDREG(isar, ID_ISAR1, 0x12112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232031);
@@ -441,10 +437,10 @@ static void cortex_a9_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x11);
     SET_IDREG(isar, ID_DFR0, 0x000);
     cpu->id_afr0 = 0;
-    cpu->isar.id_mmfr0 = 0x00100103;
-    cpu->isar.id_mmfr1 = 0x20000000;
-    cpu->isar.id_mmfr2 = 0x01230000;
-    cpu->isar.id_mmfr3 = 0x00002111;
+    SET_IDREG(isar, ID_MMFR0, 0x00100103);
+    SET_IDREG(isar, ID_MMFR1, 0x20000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01230000);
+    SET_IDREG(isar, ID_MMFR3, 0x00002111);
     SET_IDREG(isar, ID_ISAR0, 0x00101111);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232041);
@@ -507,10 +503,10 @@ static void cortex_a7_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_DFR0, 0x02010555);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x10101105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01240000;
-    cpu->isar.id_mmfr3 = 0x02102211;
+    SET_IDREG(isar, ID_MMFR0, 0x10101105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01240000);
+    SET_IDREG(isar, ID_MMFR3, 0x02102211);
     /*
      * a7_mpcore_r0p5_trm, page 4-4 gives 0x01101110; but
      * table 4-41 gives 0x02101110, which includes the arm div insns.
@@ -559,10 +555,10 @@ static void cortex_a15_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_DFR0, 0x02010555);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x20000000;
-    cpu->isar.id_mmfr2 = 0x01240000;
-    cpu->isar.id_mmfr3 = 0x02102211;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x20000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01240000);
+    SET_IDREG(isar, ID_MMFR3, 0x02102211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232041);
@@ -603,10 +599,10 @@ static void cortex_r5_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x001);
     SET_IDREG(isar, ID_DFR0, 0x010400);
     cpu->id_afr0 = 0x0;
-    cpu->isar.id_mmfr0 = 0x0210030;
-    cpu->isar.id_mmfr1 = 0x00000000;
-    cpu->isar.id_mmfr2 = 0x01200000;
-    cpu->isar.id_mmfr3 = 0x0211;
+    SET_IDREG(isar, ID_MMFR0, 0x0210030);
+    SET_IDREG(isar, ID_MMFR1, 0x00000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01200000);
+    SET_IDREG(isar, ID_MMFR3, 0x0211);
     SET_IDREG(isar, ID_ISAR0, 0x02101111);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232141);
@@ -750,11 +746,11 @@ static void cortex_r52_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x10111001);
     SET_IDREG(isar, ID_DFR0, 0x03010006);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x00211040;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01200000;
-    cpu->isar.id_mmfr3 = 0xf0102211;
-    cpu->isar.id_mmfr4 = 0x00000010;
+    SET_IDREG(isar, ID_MMFR0, 0x00211040);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01200000);
+    SET_IDREG(isar, ID_MMFR3, 0xf0102211);
+    SET_IDREG(isar, ID_MMFR4, 0x00000010);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232142);
@@ -982,10 +978,10 @@ static void arm_max_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x10101105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02102211;
+    SET_IDREG(isar, ID_MMFR0, 0x10101105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02102211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
index 1c96336b9178..918d7cc71da8 100644
--- a/target/arm/tcg/cpu64.c
+++ b/target/arm/tcg/cpu64.c
@@ -53,10 +53,10 @@ static void aarch64_a35_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0;
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02102211;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02102211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
@@ -236,11 +236,11 @@ static void aarch64_a55_initfn(Object *obj)
     SET_IDREG(isar, ID_ISAR4, 0x00011142);
     SET_IDREG(isar, ID_ISAR5, 0x01011121);
     SET_IDREG(isar, ID_ISAR6, 0x00000010);
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02122211;
-    cpu->isar.id_mmfr4 = 0x00021110;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02122211);
+    SET_IDREG(isar, ID_MMFR4, 0x00021110);
     SET_IDREG(isar, ID_PFR0, 0x10010131);
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_PFR2, 0x00000011);
@@ -299,10 +299,10 @@ static void aarch64_a72_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00011011);
     SET_IDREG(isar, ID_DFR0, 0x03010066);
     cpu->id_afr0 = 0x00000000;
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02102211;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02102211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
@@ -369,11 +369,11 @@ static void aarch64_a76_initfn(Object *obj)
     SET_IDREG(isar, ID_ISAR4, 0x00010142);
     SET_IDREG(isar, ID_ISAR5, 0x01011121);
     SET_IDREG(isar, ID_ISAR6, 0x00000010);
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02122211;
-    cpu->isar.id_mmfr4 = 0x00021110;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02122211);
+    SET_IDREG(isar, ID_MMFR4, 0x00021110);
     SET_IDREG(isar, ID_PFR0, 0x10010131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
@@ -617,11 +617,11 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
     SET_IDREG(isar, ID_ISAR4, 0x00010142);
     SET_IDREG(isar, ID_ISAR5, 0x01011121);
     SET_IDREG(isar, ID_ISAR6, 0x00000010);
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02122211;
-    cpu->isar.id_mmfr4 = 0x00021110;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02122211);
+    SET_IDREG(isar, ID_MMFR4, 0x00021110);
     SET_IDREG(isar, ID_PFR0, 0x10010131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
@@ -696,11 +696,11 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
     SET_IDREG(isar, ID_ISAR4, 0x00010142);
     SET_IDREG(isar, ID_ISAR5, 0x11011121);
     SET_IDREG(isar, ID_ISAR6, 0x01100111);
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02122211;
-    cpu->isar.id_mmfr4 = 0x01021110;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02122211);
+    SET_IDREG(isar, ID_MMFR4, 0x01021110);
     SET_IDREG(isar, ID_PFR0, 0x21110131);
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_PFR2, 0x00000011);
@@ -906,17 +906,17 @@ static void aarch64_a710_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_DFR0, 0x16011099);
     cpu->id_afr0       = 0;
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02122211;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02122211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
     SET_IDREG(isar, ID_ISAR3, 0x01112131);
     SET_IDREG(isar, ID_ISAR4, 0x00010142);
     SET_IDREG(isar, ID_ISAR5, 0x11011121); /* with Crypto */
-    cpu->isar.id_mmfr4 = 0x21021110;
+    SET_IDREG(isar, ID_MMFR4, 0x21021110);
     SET_IDREG(isar, ID_ISAR6, 0x01111111);
     cpu->isar.mvfr0    = 0x10110222;
     cpu->isar.mvfr1    = 0x13211111;
@@ -1008,17 +1008,17 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
     SET_IDREG(isar, ID_PFR1, 0x00010000); /* GIC filled in later */
     SET_IDREG(isar, ID_DFR0, 0x16011099);
     cpu->id_afr0       = 0;
-    cpu->isar.id_mmfr0 = 0x10201105;
-    cpu->isar.id_mmfr1 = 0x40000000;
-    cpu->isar.id_mmfr2 = 0x01260000;
-    cpu->isar.id_mmfr3 = 0x02122211;
+    SET_IDREG(isar, ID_MMFR0, 0x10201105);
+    SET_IDREG(isar, ID_MMFR1, 0x40000000);
+    SET_IDREG(isar, ID_MMFR2, 0x01260000);
+    SET_IDREG(isar, ID_MMFR3, 0x02122211);
     SET_IDREG(isar, ID_ISAR0, 0x02101110);
     SET_IDREG(isar, ID_ISAR1, 0x13112111);
     SET_IDREG(isar, ID_ISAR2, 0x21232042);
     SET_IDREG(isar, ID_ISAR3, 0x01112131);
     SET_IDREG(isar, ID_ISAR4, 0x00010142);
     SET_IDREG(isar, ID_ISAR5, 0x11011121); /* with Crypto */
-    cpu->isar.id_mmfr4 = 0x01021110;
+    SET_IDREG(isar, ID_MMFR4, 0x01021110);
     SET_IDREG(isar, ID_ISAR6, 0x01111111);
     cpu->isar.mvfr0    = 0x10110222;
     cpu->isar.mvfr1    = 0x13211111;
-- 
2.49.0

