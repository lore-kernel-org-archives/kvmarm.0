From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 18/23] arm64: KVM: Add epilogue branching to the vector code
Date: Thu,  1 Mar 2018 15:55:33 +0000
Message-ID: <20180301155538.26860-19-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0A9E49E95
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:51:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hiYEt0unn1kg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:51:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0612249F71
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:24 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We are soon going to have to do some extra work in the BP hardening
vector slots. Instead of doing that work in the vectors themselves
(which would massively reduce the space available to deal with
Spectre v2), let's branch to an epilogue where we can do "stuff".

This has a number of consequences:
- We need some free registers, so we're spilling x0 and x1 on the
  stack
- In order to counterbalance this, we branch to the *second* instruction
  in the vectors, avoiding the initial store that is already there
  (or loading the registers back if we've branched to a panic vector)

This is all controlled by a new capability (ARM64_HARDEN_EL2_VECTORS)
which doesn't get enabled yet.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/kernel/bpi.S          | 57 +++++++++++++++++++++++++---------------
 arch/arm64/kvm/hyp/hyp-entry.S   |  2 ++
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 76a43a17449a..d4cc54ed0656 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -32,7 +32,7 @@
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
-/* #define ARM64_UNALLOCATED_ENTRY			14 */
+#define ARM64_HARDEN_EL2_VECTORS		14
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
 #define ARM64_HAS_NO_FPSIMD			16
 #define ARM64_WORKAROUND_REPEAT_TLBI		17
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index e5de33513b5d..e000cb390618 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -19,40 +19,55 @@
 #include <linux/linkage.h>
 #include <linux/arm-smccc.h>
 
-.macro ventry target
-	.rept 31
+.macro hyp_ventry offset
+	.align 7
+	.rept 29
 	nop
 	.endr
-	b	\target
+alternative_if ARM64_HARDEN_EL2_VECTORS
+	stp	x0, x1, [sp, #-16]!
+	mov	x0, #(\offset + 4)
+	b	__kvm_enter_vectors
+alternative_else
+	b	__kvm_hyp_vector + \offset
+	nop
+	nop
+alternative_endif
 .endm
 
-.macro vectors target
-	ventry \target + 0x000
-	ventry \target + 0x080
-	ventry \target + 0x100
-	ventry \target + 0x180
+.macro generate_vectors
+	hyp_ventry 0x000
+	hyp_ventry 0x080
+	hyp_ventry 0x100
+	hyp_ventry 0x180
 
-	ventry \target + 0x200
-	ventry \target + 0x280
-	ventry \target + 0x300
-	ventry \target + 0x380
+	hyp_ventry 0x200
+	hyp_ventry 0x280
+	hyp_ventry 0x300
+	hyp_ventry 0x380
 
-	ventry \target + 0x400
-	ventry \target + 0x480
-	ventry \target + 0x500
-	ventry \target + 0x580
+	hyp_ventry 0x400
+	hyp_ventry 0x480
+	hyp_ventry 0x500
+	hyp_ventry 0x580
 
-	ventry \target + 0x600
-	ventry \target + 0x680
-	ventry \target + 0x700
-	ventry \target + 0x780
+	hyp_ventry 0x600
+	hyp_ventry 0x680
+	hyp_ventry 0x700
+	hyp_ventry 0x780
 .endm
 
 	.align	11
 ENTRY(__bp_harden_hyp_vecs_start)
 	.rept 4
-	vectors __kvm_hyp_vector
+	generate_vectors
 	.endr
+
+__kvm_enter_vectors:
+
+	adr_l	x1, __kvm_hyp_vector
+	add	x0, x1, x0
+	br	x0
 ENTRY(__bp_harden_hyp_vecs_end)
 
 ENTRY(__qcom_hyp_sanitize_link_stack_start)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 0f62b5f76aa5..fc6a1006cc08 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -220,6 +220,8 @@ ENDPROC(\label)
 .macro invalid_vect target
 	.align 7
 	b	\target
+	ldp	x0, x1, [sp], #16
+	b	\target
 .endm
 
 ENTRY(__kvm_hyp_vector)
-- 
2.14.2
