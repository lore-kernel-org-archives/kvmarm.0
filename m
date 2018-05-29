From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v4 14/15] ARM: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast handling
Date: Tue, 29 May 2018 10:10:10 +0100
Message-ID: <E1fNadu-0000hX-3S@rmk-PC.armlinux.org.uk>
References: <20180529090756.GG17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 492BA4A0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 May 2018 05:01:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RxFwHtZ9StTx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 May 2018 05:00:47 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 066E94A0E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 May 2018 04:59:41 -0400 (EDT)
In-Reply-To: <20180529090756.GG17671@n2100.armlinux.org.uk>
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We want SMCCC_ARCH_WORKAROUND_1 to be fast. As fast as possible.
So let's intercept it as early as we can by testing for the
function call number as soon as we've identified a HVC call
coming from the guest.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/kvm/hyp/hyp-entry.S | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index 918a05dd2d63..aa3f9a9837ac 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -16,6 +16,7 @@
  * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/linkage.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
@@ -202,7 +203,7 @@ ENDPROC(__hyp_do_panic)
 	lsr     r2, r2, #16
 	and     r2, r2, #0xff
 	cmp     r2, #0
-	bne	guest_trap		@ Guest called HVC
+	bne	guest_hvc_trap		@ Guest called HVC
 
 	/*
 	 * Getting here means host called HVC, we shift parameters and branch
@@ -253,6 +254,20 @@ THUMB(	orr	lr, #1)
 	pop	{r2, lr}
 	eret
 
+guest_hvc_trap:
+	movw	r2, #:lower16:ARM_SMCCC_ARCH_WORKAROUND_1
+	movt	r2, #:upper16:ARM_SMCCC_ARCH_WORKAROUND_1
+	ldr	r0, [sp]		@ Guest's r0
+	teq	r0, r2
+	bne	guest_trap
+	add	sp, sp, #12
+	@ Returns:
+	@ r0 = 0
+	@ r1 = HSR value (perfectly predictable)
+	@ r2 = ARM_SMCCC_ARCH_WORKAROUND_1
+	mov	r0, #0
+	eret
+
 guest_trap:
 	load_vcpu r0			@ Load VCPU pointer to r0
 
-- 
2.7.4
