From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v4 14/15] KVM: arm: implement lazy world switch for debug
 registers
Date: Mon, 10 Aug 2015 21:26:06 +0800
Message-ID: <1439213167-8988-15-git-send-email-zhichao.huang@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6496B5A7DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:16:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UP3Sy2zbmep5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:16:09 -0400 (EDT)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
 [209.85.220.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C06B5A79E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:16:09 -0400 (EDT)
Received: by pacrr5 with SMTP id rr5so104075544pac.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:29:10 -0700 (PDT)
In-Reply-To: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Avoid world-switching all the debug registers when neither the host
nor the guest has configured any [WB]points.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kvm/interrupts_head.S | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index b9e7410..7ad0adf 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -332,6 +332,21 @@ vcpu	.req	r0		@ vcpu pointer always in r0
 	sub	r12, r2, r12		@ How many WPs to skip
 .endm
 
+/* If VCPU_DEBUG_FLAGS is not set, it means that neither the host
+ * nor the guest has configured any [WB]points.
+ *
+ * We avoid world-switching all the debug registers in that case.
+ *
+ * Assume vcpu pointer in vcpu reg
+ *
+ * clobbers r2
+ */
+.macro skip_debug_state target
+	ldr	r2, [vcpu, #VCPU_DEBUG_FLAGS]
+	cmp	r2, #0
+	beq	\target
+.endm
+
 /* Reads cp14 registers from hardware.
  * Writes cp14 registers in-order to the CP14 struct pointed to by r10
  *
@@ -340,12 +355,14 @@ vcpu	.req	r0		@ vcpu pointer always in r0
  * Clobbers r2-r12
  */
 .macro save_debug_state
+	skip_debug_state 9999f
+
 	read_hw_dbg_num
 	cp14_read_and_str r10, 4, cp14_DBGBVR0, r11
 	cp14_read_and_str r10, 5, cp14_DBGBCR0, r11
 	cp14_read_and_str r10, 6, cp14_DBGWVR0, r12
 	cp14_read_and_str r10, 7, cp14_DBGWCR0, r12
-
+9999:
 	/* DBGDSCR reg */
 	mrc	p14, 0, r2, c0, c1, 0
 	str	r2, [r10, #CP14_OFFSET(cp14_DBGDSCRext)]
@@ -359,12 +376,14 @@ vcpu	.req	r0		@ vcpu pointer always in r0
  * Clobbers r2-r12
  */
 .macro restore_debug_state
+	skip_debug_state 9999f
+
 	read_hw_dbg_num
 	cp14_ldr_and_write r10, 4, cp14_DBGBVR0, r11
 	cp14_ldr_and_write r10, 5, cp14_DBGBCR0, r11
 	cp14_ldr_and_write r10, 6, cp14_DBGWVR0, r12
 	cp14_ldr_and_write r10, 7, cp14_DBGWCR0, r12
-
+9999:
 	/* DBGDSCR reg */
 	ldr	r2, [r10, #CP14_OFFSET(cp14_DBGDSCRext)]
 	mcr	p14, 0, r2, c0, c2, 2
-- 
1.7.12.4
