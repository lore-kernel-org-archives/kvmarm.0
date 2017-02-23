From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 13/22] ARM: hyp-stub: Implement HVC_RESET_VECTORS stub
 hypercall
Date: Thu, 23 Feb 2017 10:26:48 +0000
Message-ID: <20170223102657.23100-14-marc.zyngier@arm.com>
References: <20170223102657.23100-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE4C40F84
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:26:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jrLR6S0JuKRJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Feb 2017 05:26:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 473784104E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:26:51 -0500 (EST)
In-Reply-To: <20170223102657.23100-1-marc.zyngier@arm.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Let's define a new stub hypercall that resets the HYP configuration
to its default: hyp-stub vectors, and MMU disabled.

Of course, for the hyp-stub itself, this is a trivial no-op.
Hypervisors will have a bit more work to do.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/virt.h |  3 +++
 arch/arm/kernel/hyp-stub.S  | 11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 4ea16fcaf2ed..5186718aab68 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -101,6 +101,9 @@ extern char __hyp_text_end[];
 #define HVC_GET_VECTORS 0
 #define HVC_SET_VECTORS 1
 #define HVC_SOFT_RESTART 2
+#define HVC_RESET_VECTORS 3
+
+#define HVC_STUB_HCALL_NR 4
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 15eaa14322a7..21794d4a8f36 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -216,7 +216,10 @@ __hyp_stub_do_trap:
 	bne	1f
 	bx	r1
 
-1:	mov	r0, #-1
+1:	teq	r0, #HVC_RESET_VECTORS
+	beq	__hyp_stub_exit
+
+	mov	r0, #-1
 
 __hyp_stub_exit:
 	__ERET
@@ -264,6 +267,12 @@ ENTRY(__hyp_soft_restart)
 	ret	lr
 ENDPROC(__hyp_soft_restart)
 
+ENTRY(__hyp_reset_vectors)
+	mov	r0, #HVC_RESET_VECTORS
+	__HVC(0)
+	ret	lr
+ENDPROC(__hyp_reset_vectors)
+
 #ifndef ZIMAGE
 .align 2
 .L__boot_cpu_mode_offset:
-- 
2.11.0
