From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH 10/10] KVM: arm: enable trapping of all debug registers
Date: Sat, 16 May 2015 12:45:51 +0800
Message-ID: <1431751551-4788-11-git-send-email-zhichao.huang@linaro.org>
References: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C13185183D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 May 2015 00:38:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bkzHdxX5GfPY for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 May 2015 00:38:11 -0400 (EDT)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
 [209.85.220.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 006515181F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 May 2015 00:38:11 -0400 (EDT)
Received: by padbw4 with SMTP id bw4so47601853pad.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 21:47:23 -0700 (PDT)
In-Reply-To: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Enable trapping of the debug registers, allowing guests to use
the debug infrastructure.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kvm/interrupts_head.S | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index ed406be..107bda4 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -886,10 +886,21 @@ ARM_BE8(rev	r6, r6  )
 .endm
 
 /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
- * (hardware reset value is 0) */
+ * (hardware reset value is 0)
+ *
+ * Clobbers r2-r4
+ */
 .macro set_hdcr operation
 	mrc	p15, 4, r2, c1, c1, 1
-	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)
+	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA)
+
+	// Check for KVM_ARM_DEBUG_DIRTY, and set debug to trap
+	// if not dirty.
+	ldr	r4, [vcpu, #VCPU_DEBUG_FLAGS]
+	cmp	r4, #KVM_ARM_DEBUG_DIRTY
+	beq	1f
+	orr	r3, r3,  #HDCR_TDA
+1:
 	.if \operation == vmentry
 	orr	r2, r2, r3		@ Trap some perfmon accesses
 	.else
-- 
1.7.12.4
