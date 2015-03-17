From: Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH] target-arm: Store SPSR_EL1 state in banked_spsr[1] (SPSR_svc)
Date: Tue, 17 Mar 2015 19:19:35 +0000
Message-ID: <1426619975-2346-1-git-send-email-peter.maydell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A746048F93
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:13:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3EmPT-ZrbHaG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Mar 2015 15:13:02 -0400 (EDT)
Received: from mnementh.archaic.org.uk (mnementh.archaic.org.uk [81.2.115.146])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0D8648F4C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Mar 2015 15:13:02 -0400 (EDT)
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
Cc: Greg Bellows <greg.bellows@linaro.org>, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The AArch64 SPSR_EL1 register is architecturally mandated to
be mapped to the AArch32 SPSR_svc register. This means its
state should live in QEMU's env->banked_spsr[1] field.
Correct the buggy regdef that put it in banked_spsr[0] instead.

Signed-off-by: Peter Maydell <peter.maydell@linaro.org>
---
 target-arm/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
1.9.1
