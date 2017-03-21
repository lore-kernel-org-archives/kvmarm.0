From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 07/28] arm64: KVM: Allow the main HYP code to use the init
 hyp stub implementation
Date: Tue, 21 Mar 2017 19:20:37 +0000
Message-ID: <20170321192058.9300-8-marc.zyngier@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8CBD40C46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zV-hxC1ds70F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 15:20:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE5840CEA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:13 -0400 (EDT)
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

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index d8ef788646c6..4f34c5996f86 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -87,10 +87,24 @@ alternative_endif
 	/* Here, we're pretty sure the host called HVC. */
 	ldp	x0, x1, [sp], #16
 
-	cmp	x0, #HVC_GET_VECTORS
-	b.ne	1f
-	mrs	x0, vbar_el2
-	b	2f
+	/* Check for a stub HVC call */
+	cmp	x0, #HVC_STUB_HCALL_NR
+	b.hs	1f
+
+	/*
+	 * Compute the idmap address of __kvm_handle_stub_hvc and
+	 * jump there. Since we use kimage_voffset, do not use the
+	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
+	 * (by loading it from the constant pool).
+	 *
+	 * Preserve x0-x4, which may contain stub parameters.
+	 */
+	ldr	x5, =__kvm_handle_stub_hvc
+	ldr_l	x6, kimage_voffset
+
+	/* x5 = __pa(x5) */
+	sub	x5, x5, x6
+	br	x5
 
 1:
 	/*
@@ -99,7 +113,7 @@ alternative_endif
 	kern_hyp_va	x0
 	do_el2_call
 
-2:	eret
+	eret
 
 el1_trap:
 	/*
-- 
2.11.0
