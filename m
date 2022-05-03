Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31311C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 06:02:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0E324B274;
	Tue,  3 May 2022 02:02:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y1PCJV-FjANF; Tue,  3 May 2022 02:02:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B6C4B289;
	Tue,  3 May 2022 02:02:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F574B216
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HCfyay9DL-PF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 02:02:18 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 882994B1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:18 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 o16-20020a17090ab89000b001d84104fc2cso554852pjr.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 23:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5RbTqRjyv/JGe841RHBUI3rQBooiZTqU97QWl3obRNA=;
 b=LCqHjMuYeDAd9/HrWXhkaqhxAgmYnzAuMgkj2Skj7h2SVOy0DF41l5Iqb+PY2WRmwu
 m+n6uOOBJgZyUInQJ4py5riUdNHa0nn8xgeNtILhpUryktuSVRGJ5JWMGD3fUs3s05ZF
 eidKTP9Y6yPGJ/3T6Z7hu2xHyLNXkhtuLUSPxj3qBai+hso8oDsUW7GjZGRucZ2mA+zl
 7N0B8e8XsfgINQj1L+Kwnv1FD3StEbxqTdzlq0G6dBfip7l7PHECQLf9LW/DrmYoRdQT
 kNk0NZCEoYH0RIWykEz2ffT7JFt1rgKi6DcxoM+Zep2U9/NwzDbhS33cuSlaZDQO4zBa
 ccLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5RbTqRjyv/JGe841RHBUI3rQBooiZTqU97QWl3obRNA=;
 b=UOaT3SHufzB0mhTFvAMku/MCQDe4FqbN6kkrPiGwPZsYZmWufa0owproHSjeiqmBCh
 G3SJnkodfxs/7pI5E5QlA096Kpdzl2800axKlHgpPkigsheTBIO48vZCMFVO0LgSw0P2
 kynHCc3130Q3Qfl56qvrmYJoI2NN3t0tr5GbQ60OWJqMNDeE+FnOJ1frD5Y+IMxueutT
 UjzxbMy8lMD2vpzBhrwTg9k89UvlfmK2wBI9pzJLHyfxA9YaeznRm7iLh3ozX8nxRUOP
 NsUYLasvMtu9fMAQM1U6Y8A7To6zolPTs+i6wDgRqsb9HNW5OhMJmNXbWdZiOV7Gq5kb
 s+EA==
X-Gm-Message-State: AOAM533+W2NwWXP61UCfrkGEpqQv8HFnYbCd3A89QEvyEy8z0PMw9c+F
 6uS7MubM1mbMPzqFccw1cZVbCMB/NwKt7OSPMCgG2ih7KF9rFCL25DAt1URPht3b2YTz4EcETak
 YsqsgmBzint6QjSR0kzSCnimGomEoNcNrKivDy6LPib6b7Nm8M9k8hejkpJN4Y720cWjF9g==
X-Google-Smtp-Source: ABdhPJyl27YQ6XmJQ9Fqp+P9ujgfURU/vv3w3Cp1SKq9Raj855FY/fiPv+W655fr40c2jGqj3G2V5IfUTNU=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:1a01:b0:505:b3e5:b5fc with SMTP id
 g1-20020a056a001a0100b00505b3e5b5fcmr14320992pfv.53.1651557737935; Mon, 02
 May 2022 23:02:17 -0700 (PDT)
Date: Tue,  3 May 2022 06:02:04 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-7-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 6/7] KVM/arm64: Hide AArch32 PMU registers when not
 available
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Alexandru Elisei <alexandru.elisei@arm.com>

commit 11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when
not available") hid the AArch64 PMU registers from userspace and guest
when the PMU VCPU feature was not set. Do the same when the PMU
registers are accessed by an AArch32 guest. While we're at it, rename
the previously unused AA32_ZEROHIGH to AA32_DIRECT to match the behavior
of get_access_mask().

Now that KVM emulates ID_DFR0 and hides the PMU from the guest when the
feature is not set, it is safe to inject to inject an undefined exception
when the PMU is not present, as that corresponds to the architected
behaviour.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
[Oliver - Add AA32_DIRECT to match the zero value of the enum]
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 60 ++++++++++++++++++++-------------------
 arch/arm64/kvm/sys_regs.h |  2 +-
 2 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 586b292ca94f..f3235eafdadc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2014,20 +2014,22 @@ static const struct sys_reg_desc cp14_64_regs[] = {
 	{ Op1( 0), CRm( 2), .access = trap_raz_wi },
 };
 
+#define CP15_PMU_SYS_REG(_map, _Op1, _CRn, _CRm, _Op2)			\
+	AA32(_map),							\
+	Op1(_Op1), CRn(_CRn), CRm(_CRm), Op2(_Op2),			\
+	.visibility = pmu_visibility
+
 /* Macro to expand the PMEVCNTRn register */
 #define PMU_PMEVCNTR(n)							\
-	/* PMEVCNTRn */							\
-	{ Op1(0), CRn(0b1110),						\
-	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
-	  access_pmu_evcntr }
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 0b1110,				\
+	  (0b1000 | (((n) >> 3) & 0x3)), ((n) & 0x7)),			\
+	  .access = access_pmu_evcntr }
 
 /* Macro to expand the PMEVTYPERn register */
 #define PMU_PMEVTYPER(n)						\
-	/* PMEVTYPERn */						\
-	{ Op1(0), CRn(0b1110),						\
-	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
-	  access_pmu_evtyper }
-
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 0b1110,				\
+	  (0b1100 | (((n) >> 3) & 0x3)), ((n) & 0x7)),			\
+	  .access = access_pmu_evtyper }
 /*
  * Trapped cp15 registers. TTBR0/TTBR1 get a double encoding,
  * depending on the way they are accessed (as a 32bit or a 64bit
@@ -2067,25 +2069,25 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },
 
 	/* PMU */
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcnten },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcnten },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
-	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
-	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
-	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), access_pmuserenr },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
-	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 4), access_pmceid },
-	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 5), access_pmceid },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 0), .access = access_pmcr },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 1), .access = access_pmcnten },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 2), .access = access_pmcnten },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 3), .access = access_pmovs },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 4), .access = access_pmswinc },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 12, 5), .access = access_pmselr },
+	{ CP15_PMU_SYS_REG(LO,     0, 9, 12, 6), .access = access_pmceid },
+	{ CP15_PMU_SYS_REG(LO,     0, 9, 12, 7), .access = access_pmceid },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 13, 0), .access = access_pmu_evcntr },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 13, 1), .access = access_pmu_evtyper },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 13, 2), .access = access_pmu_evcntr },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 0), .access = access_pmuserenr },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 1), .access = access_pminten },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 2), .access = access_pminten },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 3), .access = access_pmovs },
+	{ CP15_PMU_SYS_REG(HI,     0, 9, 14, 4), .access = access_pmceid },
+	{ CP15_PMU_SYS_REG(HI,     0, 9, 14, 5), .access = access_pmceid },
 	/* PMMIR */
-	{ Op1( 0), CRn( 9), CRm(14), Op2( 6), trap_raz_wi },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 9, 14, 6), .access = trap_raz_wi },
 
 	/* PRRR/MAIR0 */
 	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
@@ -2170,7 +2172,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	PMU_PMEVTYPER(29),
 	PMU_PMEVTYPER(30),
 	/* PMCCFILTR */
-	{ Op1(0), CRn(14), CRm(15), Op2(7), access_pmu_evtyper },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 14, 15, 7), .access = access_pmu_evtyper },
 
 	{ Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
 	{ Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
@@ -2179,7 +2181,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 
 static const struct sys_reg_desc cp15_64_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR0_EL1 },
-	{ Op1( 0), CRn( 0), CRm( 9), Op2( 0), access_pmu_evcntr },
+	{ CP15_PMU_SYS_REG(DIRECT, 0, 0, 9, 0), .access = access_pmu_evcntr },
 	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI1R */
 	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
 	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 0d31a12b640c..aee8ea054f0d 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -47,7 +47,7 @@ struct sys_reg_desc {
 	const char *name;
 
 	enum {
-		AA32_ZEROHIGH,
+		AA32_DIRECT,
 		AA32_LO,
 		AA32_HI,
 	} aarch32_map;
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
