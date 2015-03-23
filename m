From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 1/6] target-arm: Store SPSR_EL1 state in banked_spsr[1]
 (SPSR_svc)
Date: Mon, 23 Mar 2015 17:05:39 +0000
Message-ID: <1427130344-27986-2-git-send-email-alex.bennee@linaro.org>
References: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AFE3497B7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 12:58:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oSEoNvE+chlj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2015 12:58:29 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F3AB497B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 12:58:29 -0400 (EDT)
In-Reply-To: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Peter Maydell <peter.maydell@linaro.org>

The AArch64 SPSR_EL1 register is architecturally mandated to
be mapped to the AArch32 SPSR_svc register. This means its
state should live in QEMU's env->banked_spsr[1] field.
Correct the various places in the code that incorrectly
put it in banked_spsr[0].

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>

diff --git a/target-arm/helper-a64.c b/target-arm/helper-a64.c
index 7e0d038..861f6fa 100644
--- a/target-arm/helper-a64.c
+++ b/target-arm/helper-a64.c
@@ -523,7 +523,7 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
         aarch64_save_sp(env, arm_current_el(env));
         env->elr_el[new_el] = env->pc;
     } else {
-        env->banked_spsr[0] = cpsr_read(env);
+        env->banked_spsr[aarch64_banked_spsr_index(new_el)] = cpsr_read(env);
         if (!env->thumb) {
             env->cp15.esr_el[new_el] |= 1 << 25;
         }
diff --git a/target-arm/helper.c b/target-arm/helper.c
index 10886c5..d77c6de 100644
--- a/target-arm/helper.c
+++ b/target-arm/helper.c
@@ -2438,7 +2438,7 @@ static const ARMCPRegInfo v8_cp_reginfo[] = {
     { .name = "SPSR_EL1", .state = ARM_CP_STATE_AA64,
       .type = ARM_CP_ALIAS,
       .opc0 = 3, .opc1 = 0, .crn = 4, .crm = 0, .opc2 = 0,
-      .access = PL1_RW, .fieldoffset = offsetof(CPUARMState, banked_spsr[0]) },
+      .access = PL1_RW, .fieldoffset = offsetof(CPUARMState, banked_spsr[1]) },
     /* We rely on the access checks not allowing the guest to write to the
      * state field when SPSel indicates that it's being used as the stack
      * pointer.
diff --git a/target-arm/internals.h b/target-arm/internals.h
index bb171a7..2cc3017 100644
--- a/target-arm/internals.h
+++ b/target-arm/internals.h
@@ -82,11 +82,14 @@ static inline void arm_log_exception(int idx)
 
 /*
  * For AArch64, map a given EL to an index in the banked_spsr array.
+ * Note that this mapping and the AArch32 mapping defined in bank_number()
+ * must agree such that the AArch64<->AArch32 SPSRs have the architecturally
+ * mandated mapping between each other.
  */
 static inline unsigned int aarch64_banked_spsr_index(unsigned int el)
 {
     static const unsigned int map[4] = {
-        [1] = 0, /* EL1.  */
+        [1] = 1, /* EL1.  */
         [2] = 6, /* EL2.  */
         [3] = 7, /* EL3.  */
     };
-- 
2.3.2
