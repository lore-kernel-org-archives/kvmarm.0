From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 19/28] ARM: KVM: Allow the main HYP code to use the init
 hyp stub implementation
Date: Tue, 21 Mar 2017 19:20:49 +0000
Message-ID: <20170321192058.9300-20-marc.zyngier@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 159CA40BD2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VWFsfOckIF8j for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 15:20:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE88240CD8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:37 -0400 (EDT)
In-Reply-To: <20170321192058.9300-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

We now have a full hyp-stub implementation in the KVM init code,
but the main KVM code only supports HVC_GET_VECTORS, which is not
enough.

Instead of reinventing the wheel, let's reuse the init implementation
by branching to the idmap page when called with a hyp-stub hypercall.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/hyp-entry.S | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index 1f8db7d21fc5..a35baa81fd23 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -126,11 +126,30 @@ hyp_hvc:
 	 */
 	pop	{r0, r1, r2}
 
-	/* Check for __hyp_get_vectors */
-	cmp	r0, #HVC_GET_VECTORS
-	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
-	beq	1f
+	/*
+	 * Check if we have a kernel function, which is guaranteed to be
+	 * bigger than the maximum hyp stub hypercall
+	 */
+	cmp	r0, #HVC_STUB_HCALL_NR
+	bhs	1f
 
+	/*
+	 * Not a kernel function, treat it as a stub hypercall.
+	 * Compute the physical address for __kvm_handle_stub_hvc
+	 * (as the code lives in the idmaped page) and branch there.
+	 * We hijack ip (r12) as a tmp register.
+	 */
+	push	{r1}
+	ldr	r1, =kimage_voffset
+	ldr	r1, [r1]
+	ldr	ip, =__kvm_handle_stub_hvc
+	sub	ip, ip, r1
+THUMB(	add	ip, ip, #1)
+	pop	{r1}
+
+	bx	ip
+
+1:
 	push	{lr}
 
 	mov	lr, r0
@@ -142,7 +161,7 @@ THUMB(	orr	lr, #1)
 	blx	lr			@ Call the HYP function
 
 	pop	{lr}
-1:	eret
+	eret
 
 guest_trap:
 	load_vcpu r0			@ Load VCPU pointer to r0
-- 
2.11.0
