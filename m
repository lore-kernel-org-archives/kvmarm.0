From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 04/22] arm64: KVM: Allow the main HYP code to use the init hyp stub implementation
Date: Thu, 23 Feb 2017 10:26:39 +0000
Message-ID: <20170223102657.23100-5-marc.zyngier@arm.com>
References: <20170223102657.23100-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170223102657.23100-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We now have a full hyp-stub implementation in the KVM init code,
but the main KVM code only supports HVC_GET_VECTORS, which is not
enough.

Instead of reinventing the wheel, let's reuse the init implementation
by branching to the idmap page when called with a hyp-stub hypercall.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5e9052f087f2..21eeb2552f33 100644
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
