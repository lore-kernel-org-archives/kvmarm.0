Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DA01CC8AB
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729851639; cv=none; b=HNnqPrGh05ih0hE9GZ7K8EzUQryWuc068voKWwsXLrA3Ts0BApuV0f7PKXf5vLSLKrrubehjXlPVwUMIK1Y6fuxJBx9H7XaTRBdO+jkgIZ1mE6yFyG3AP9uWVNpy2H+peBayFvRPeRVNCshiyJMqpO8SnKuffN1HeNQREEZzvrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729851639; c=relaxed/simple;
	bh=46vcyKfHHkIw/PLaBAHxmH+kht9ij+m+lkKn7FH0b/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U00x4eNste5ca1FpIYsFkprnK9IKGH+oakrzlO4mp/Cl4tfgv8i0AGr7bkpBS9qqmVmYkCzG2qFtySbJRlmq8YdR7wMZ/9OpPl4SDN7SJn1ihX3xsRXwMjgSFqHbPFrldu5v5r0W4THUyGlSoUhnph+QFt1miz0F8RWWkFOJ4N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7sllnuS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7sllnuS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729851636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ky3ThRkvDhjr0upkbEECwN+3U+A5A3WcAWKqNWydsmA=;
	b=E7sllnuSQRT0QLBtramQTNWVpIZI/RuWETPRoOnDU4krBpxtpPdLxpjRX+mYhl9t9mPiU6
	7j/JUGoPnergxuc1voWneD7xYIt1Dx7xBqV4fmsVQDjnXSoSLyZ6Acgx2RByBFmk7fMAk9
	Ed4Z1sRUV0mzRD376mXofTHwvz/itEM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-ZohcQP7aM26-5wtACeHH9g-1; Fri,
 25 Oct 2024 06:20:33 -0400
X-MC-Unique: ZohcQP7aM26-5wtACeHH9g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 260281956083;
	Fri, 25 Oct 2024 10:20:31 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C8165196BB7E;
	Fri, 25 Oct 2024 10:20:24 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	cohuck@redhat.com,
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
	pbonzini@redhat.com
Subject: [RFC 02/21] arm/cpu: Add sysreg definitions in cpu-sysegs.h
Date: Fri, 25 Oct 2024 12:17:21 +0200
Message-ID: <20241025101959.601048-3-eric.auger@redhat.com>
In-Reply-To: <20241025101959.601048-1-eric.auger@redhat.com>
References: <20241025101959.601048-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This new header contains macros that define aarch64 regiters.
In a subsequent patche, this will be replaced by a more exhaustive
version that will be generated from linux arch/arm64/tools/sysreg
file. Those macros are sufficient to migrate the storage of those
ID regs from named fields in isar struct to an array cell.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/cpu-sysregs.h | 42 +++++++++++++++++++++++++++++++
 target/arm/cpu.h         | 54 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)
 create mode 100644 target/arm/cpu-sysregs.h

diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
new file mode 100644
index 0000000000..f4b63a3af7
--- /dev/null
+++ b/target/arm/cpu-sysregs.h
@@ -0,0 +1,42 @@
+#ifndef ARM_CPU_SYSREGS_H
+#define ARM_CPU_SYSREGS_H
+
+/* to be generated */
+
+#define SYS_ID_AA64PFR0_EL1                             sys_reg(3, 0, 0, 4, 0)
+#define SYS_ID_AA64PFR1_EL1                             sys_reg(3, 0, 0, 4, 1)
+#define SYS_ID_AA64SMFR0_EL1                            sys_reg(3, 0, 0, 4, 5)
+#define SYS_ID_AA64DFR0_EL1                             sys_reg(3, 0, 0, 5, 0)
+#define SYS_ID_AA64DFR1_EL1                             sys_reg(3, 0, 0, 5, 1)
+#define SYS_ID_AA64ISAR0_EL1                            sys_reg(3, 0, 0, 6, 0)
+#define SYS_ID_AA64ISAR1_EL1                            sys_reg(3, 0, 0, 6, 1)
+#define SYS_ID_AA64ISAR2_EL1                            sys_reg(3, 0, 0, 6, 2)
+#define SYS_ID_AA64MMFR0_EL1                            sys_reg(3, 0, 0, 7, 0)
+#define SYS_ID_AA64MMFR1_EL1                            sys_reg(3, 0, 0, 7, 1)
+#define SYS_ID_AA64MMFR2_EL1                            sys_reg(3, 0, 0, 7, 2)
+#define SYS_ID_AA64MMFR3_EL1                            sys_reg(3, 0, 0, 7, 3)
+
+#define SYS_ID_PFR0_EL1                                 sys_reg(3, 0, 0, 1, 0)
+#define SYS_ID_PFR1_EL1                                 sys_reg(3, 0, 0, 1, 1)
+#define SYS_ID_DFR0_EL1                                 sys_reg(3, 0, 0, 1, 2)
+#define SYS_ID_MMFR0_EL1                                sys_reg(3, 0, 0, 1, 4)
+#define SYS_ID_MMFR1_EL1                                sys_reg(3, 0, 0, 1, 5)
+#define SYS_ID_MMFR2_EL1                                sys_reg(3, 0, 0, 1, 6)
+#define SYS_ID_MMFR3_EL1                                sys_reg(3, 0, 0, 1, 7)
+#define SYS_ID_ISAR0_EL1                                sys_reg(3, 0, 0, 2, 0)
+#define SYS_ID_ISAR1_EL1                                sys_reg(3, 0, 0, 2, 1)
+#define SYS_ID_ISAR2_EL1                                sys_reg(3, 0, 0, 2, 2)
+#define SYS_ID_ISAR3_EL1                                sys_reg(3, 0, 0, 2, 3)
+#define SYS_ID_ISAR4_EL1                                sys_reg(3, 0, 0, 2, 4)
+#define SYS_ID_ISAR5_EL1                                sys_reg(3, 0, 0, 2, 5)
+#define SYS_ID_MMFR4_EL1                                sys_reg(3, 0, 0, 2, 6)
+#define SYS_ID_ISAR6_EL1                                sys_reg(3, 0, 0, 2, 7)
+#define SYS_MVFR0_EL1                                   sys_reg(3, 0, 0, 3, 0)
+#define SYS_MVFR1_EL1                                   sys_reg(3, 0, 0, 3, 1)
+#define SYS_MVFR2_EL1                                   sys_reg(3, 0, 0, 3, 2)
+#define SYS_ID_PFR2_EL1                                 sys_reg(3, 0, 0, 3, 4)
+#define SYS_ID_DFR1_EL1                                 sys_reg(3, 0, 0, 3, 5)
+#define SYS_ID_MMFR5_EL1                                sys_reg(3, 0, 0, 3, 6)
+#define SYS_ID_AA64ZFR0_EL1                             sys_reg(3, 0, 0, 4, 4)
+
+#endif
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 1493b35d99..0491a482f0 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -144,6 +144,14 @@ typedef struct ARMGenericTimer {
     uint64_t ctl; /* Timer Control register */
 } ARMGenericTimer;
 
+typedef struct ARMSysReg {
+    int op0;
+    int op1;
+    int crn;
+    int crm;
+    int op2;
+} ARMSysReg;
+
 /* Define a maximum sized vector register.
  * For 32-bit, this is a 128-bit NEON/AdvSIMD register.
  * For 64-bit, this is a 2048-bit SVE register.
@@ -834,6 +842,51 @@ typedef struct IdRegMap {
     uint64_t regs[NR_ID_REGS];
 } IdRegMap;
 
+#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)               \
+        ({                                                              \
+                __u64 __op1 = (op1) & 3;                                \
+                __op1 -= (__op1 == 3);                                  \
+                (__op1 << 6 | ((crm) & 7) << 3 | (op2));                \
+        })
+
+static inline uint64_t _get_idreg(const IdRegMap *map, ARMSysReg sr)
+{
+    int index = ARM_FEATURE_ID_RANGE_IDX(sr.op0, sr.op1, sr.crn, sr.crm, sr.op2);
+
+    return map->regs[index];
+}
+
+static inline void _set_idreg(IdRegMap *map, ARMSysReg sr, uint64_t value)
+{
+    int index = ARM_FEATURE_ID_RANGE_IDX(sr.op0, sr.op1, sr.crn, sr.crm, sr.op2);
+
+    map->regs[index] = value;
+}
+
+/* REG is ID_XXX */
+#define FIELD_DP64_IDREG(MAP, REG, FIELD, VALUE)              \
+{                                                             \
+uint64_t regval = _get_idreg(MAP, SYS_ ## REG ## _EL1);       \
+regval = FIELD_DP64(regval, REG, FIELD, VALUE);               \
+_set_idreg(MAP, SYS_ ## REG ## _EL1, regval);                 \
+}
+
+#define FIELD_EX64_IDREG(MAP, REG, FIELD)                     \
+FIELD_EX64(_get_idreg(MAP, SYS_ ## REG ## _EL1), REG, FIELD)  \
+
+#define SET_IDREG(MAP, REG, VALUE)                            \
+_set_idreg(MAP, SYS_ ## REG ## _EL1, VALUE)
+
+#define GET_IDREG(MAP, REG)                                   \
+_get_idreg(MAP, SYS_ ## REG ## _EL1)
+
+static inline ARMSysReg sys_reg(int op0, int op1, int crn, int crm, int op2)
+{
+        ARMSysReg sr = {op0, op1, crn, crm, op2};
+
+        return sr;
+}
+
 /**
  * ARMCPU:
  * @env: #CPUARMState
@@ -1043,6 +1096,7 @@ struct ArchCPU {
         uint64_t id_aa64zfr0;
         uint64_t id_aa64smfr0;
         uint64_t reset_pmcr_el0;
+        IdRegMap idregs;
     } isar;
     uint64_t midr;
     uint32_t revidr;
-- 
2.41.0

