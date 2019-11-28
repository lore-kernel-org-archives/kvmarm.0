Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107F0C43141
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 16:17:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7A4A217D7
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 16:17:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7A4A217D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C1264AEB3;
	Thu, 28 Nov 2019 11:17:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X5pPjKbaN4eB; Thu, 28 Nov 2019 11:17:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65F524AE8D;
	Thu, 28 Nov 2019 11:17:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC6A4ACB7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 11:17:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e5+kJ6ZSfEEo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 11:17:36 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 446794A8E0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 11:17:36 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iaMU2-0002vd-SP; Thu, 28 Nov 2019 17:17:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: qemu-devel@nongnu.org
Subject: [PATCH 1/3] target/arm: Honor HCR_EL2.TID2 trapping requirements
Date: Thu, 28 Nov 2019 16:17:16 +0000
Message-Id: <20191128161718.24361-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128161718.24361-1-maz@kernel.org>
References: <20191128161718.24361-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu,
 peter.maydell@linaro.org, richard.henderson@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: richard.henderson@linaro.org, kvmarm@lists.cs.columbia.edu
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

HCR_EL2.TID2 mandates that access from EL1 to CTR_EL0, CCSIDR_EL1,
CCSIDR2_EL1, CLIDR_EL1, CSSELR_EL1 are trapped to EL2, and QEMU
completely ignores it, making impossible for hypervisors to
virtualize the cache hierarchy.

Do the right thing by trapping to EL2 if HCR_EL2.TID2 is set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 target/arm/helper.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 0bf8f53d4b..0b6887b100 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -1910,6 +1910,17 @@ static void scr_write(CPUARMState *env, const ARMCPRegInfo *ri, uint64_t value)
     raw_write(env, ri, value);
 }
 
+static CPAccessResult access_aa64_tid2(CPUARMState *env,
+                                       const ARMCPRegInfo *ri,
+                                       bool isread)
+{
+    if (arm_current_el(env) == 1 && (arm_hcr_el2_eff(env) & HCR_TID2)) {
+        return CP_ACCESS_TRAP_EL2;
+    }
+
+    return CP_ACCESS_OK;
+}
+
 static uint64_t ccsidr_read(CPUARMState *env, const ARMCPRegInfo *ri)
 {
     ARMCPU *cpu = env_archcpu(env);
@@ -2110,10 +2121,14 @@ static const ARMCPRegInfo v7_cp_reginfo[] = {
       .writefn = pmintenclr_write },
     { .name = "CCSIDR", .state = ARM_CP_STATE_BOTH,
       .opc0 = 3, .crn = 0, .crm = 0, .opc1 = 1, .opc2 = 0,
-      .access = PL1_R, .readfn = ccsidr_read, .type = ARM_CP_NO_RAW },
+      .access = PL1_R,
+      .accessfn = access_aa64_tid2,
+      .readfn = ccsidr_read, .type = ARM_CP_NO_RAW },
     { .name = "CSSELR", .state = ARM_CP_STATE_BOTH,
       .opc0 = 3, .crn = 0, .crm = 0, .opc1 = 2, .opc2 = 0,
-      .access = PL1_RW, .writefn = csselr_write, .resetvalue = 0,
+      .access = PL1_RW,
+      .accessfn = access_aa64_tid2,
+      .writefn = csselr_write, .resetvalue = 0,
       .bank_fieldoffsets = { offsetof(CPUARMState, cp15.csselr_s),
                              offsetof(CPUARMState, cp15.csselr_ns) } },
     /* Auxiliary ID register: this actually has an IMPDEF value but for now
@@ -5204,6 +5219,11 @@ static CPAccessResult ctr_el0_access(CPUARMState *env, const ARMCPRegInfo *ri,
     if (arm_current_el(env) == 0 && !(env->cp15.sctlr_el[1] & SCTLR_UCT)) {
         return CP_ACCESS_TRAP;
     }
+
+    if (arm_hcr_el2_eff(env) & HCR_TID2) {
+        return CP_ACCESS_TRAP_EL2;
+    }
+
     return CP_ACCESS_OK;
 }
 
@@ -6184,7 +6204,9 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         ARMCPRegInfo clidr = {
             .name = "CLIDR", .state = ARM_CP_STATE_BOTH,
             .opc0 = 3, .crn = 0, .crm = 0, .opc1 = 1, .opc2 = 1,
-            .access = PL1_R, .type = ARM_CP_CONST, .resetvalue = cpu->clidr
+            .access = PL1_R, .type = ARM_CP_CONST,
+            .accessfn = access_aa64_tid2,
+            .resetvalue = cpu->clidr
         };
         define_one_arm_cp_reg(cpu, &clidr);
         define_arm_cp_regs(cpu, v7_cp_reginfo);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
