From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 41/79] arm64: hyp-stub: Implement HVC_RESET_VECTORS stub
 hypercall
Date: Sun, 23 Apr 2017 19:08:51 +0200
Message-ID: <20170423170929.27334-42-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7824449C79
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BhGFWKiVOIqO for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:32 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96D6949CF3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:28 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id u65so7505036wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:15 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Let's define a new stub hypercall that resets the HYP configuration
to its default: hyp-stub vectors, and MMU disabled.

Of course, for the hyp-stub itself, this is a trivial no-op.
Hypervisors will have a bit more work to do.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/virt.h |  9 +++++++++
 arch/arm64/kernel/hyp-stub.S  | 11 ++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 1569c3a..435514c 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -44,6 +44,14 @@
  */
 #define HVC_SOFT_RESTART 2
 
+/*
+ * HVC_RESET_VECTORS - Restore the vectors to the original HYP stubs
+ */
+#define HVC_RESET_VECTORS 3
+
+/* Max number of HYP stub hypercalls */
+#define HVC_STUB_HCALL_NR 4
+
 /* Error returned when an invalid stub number is passed into x0 */
 #define HVC_STUB_ERR	0xbadca11
 
@@ -70,6 +78,7 @@ extern u32 __boot_cpu_mode[2];
 
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
 phys_addr_t __hyp_get_vectors(void);
+void __hyp_reset_vectors(void);
 
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index f53e8b8..8226fd9 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -73,8 +73,11 @@ el1_sync:
 	mov	x1, x3
 	br	x4				// no return
 
+3:	cmp	x0, #HVC_RESET_VECTORS
+	beq	9f				// Nothing to reset!
+
 	/* Someone called kvm_call_hyp() against the hyp-stub... */
-3:	ldr	x0, =HVC_STUB_ERR
+	ldr	x0, =HVC_STUB_ERR
 
 9:	eret
 ENDPROC(el1_sync)
@@ -127,3 +130,9 @@ ENTRY(__hyp_set_vectors)
 	hvc	#0
 	ret
 ENDPROC(__hyp_set_vectors)
+
+ENTRY(__hyp_reset_vectors)
+	mov	x0, #HVC_RESET_VECTORS
+	hvc	#0
+	ret
+ENDPROC(__hyp_reset_vectors)
-- 
2.9.0
