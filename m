From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 09/27] arm64/sve: Signal frame and context structure definition
Date: Wed,  9 Aug 2017 13:05:15 +0100
Message-ID: <1502280338-23002-10-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACDF749C40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:05:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7u1y8fBIhNWT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 08:05:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5783449C3E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:05:19 -0400 (EDT)
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, gdb@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Yao Qi <Yao.Qi@arm.com>, Alan Hayward <alan.hayward@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch defines the representation that will be used for the SVE
register state in the signal frame, and implements support for
saving and restoring the SVE registers around signals.

The same layout will also be used for the in-kernel task state.

Due to the variability of the SVE vector length, it is not possible
to define a fixed C struct to describe all the registers.  Instead,
Macros are defined in sigcontext.h to facilitate access to the
parts of the structure.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/uapi/asm/sigcontext.h | 113 ++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
index f0a76b9..0533bdf 100644
--- a/arch/arm64/include/uapi/asm/sigcontext.h
+++ b/arch/arm64/include/uapi/asm/sigcontext.h
@@ -16,6 +16,8 @@
 #ifndef _UAPI__ASM_SIGCONTEXT_H
 #define _UAPI__ASM_SIGCONTEXT_H
 
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 
 /*
@@ -41,10 +43,11 @@ struct sigcontext {
  *
  *	0x210		fpsimd_context
  *	 0x10		esr_context
+ *	0x8a0		sve_context (vl <= 64) (optional)
  *	 0x20		extra_context (optional)
  *	 0x10		terminator (null _aarch64_ctx)
  *
- *	0xdb0		(reserved for future allocation)
+ *	0x510		(reserved for future allocation)
  *
  * New records that can exceed this space need to be opt-in for userspace, so
  * that an expanded signal frame is not generated unexpectedly.  The mechanism
@@ -116,4 +119,112 @@ struct extra_context {
 	__u32 __reserved[3];
 };
 
+#define SVE_MAGIC	0x53564501
+
+struct sve_context {
+	struct _aarch64_ctx head;
+	__u16 vl;
+	__u16 __reserved[3];
+};
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * The SVE architecture leaves space for future expansion of the
+ * vector length beyond its initial architectural limit of 2048 bits
+ * (16 quadwords).
+ */
+#define SVE_VQ_MIN		1
+#define SVE_VQ_MAX		0x200
+
+#define SVE_VL_MIN		(SVE_VQ_MIN * 0x10)
+#define SVE_VL_MAX		(SVE_VQ_MAX * 0x10)
+
+#define SVE_NUM_ZREGS		32
+#define SVE_NUM_PREGS		16
+
+#define sve_vl_valid(vl) \
+	((vl) % 0x10 == 0 && (vl) >= SVE_VL_MIN && (vl) <= SVE_VL_MAX)
+#define sve_vq_from_vl(vl)	((vl) / 0x10)
+#define sve_vl_from_vq(vq)	((vq) * 0x10)
+
+/*
+ * If the SVE registers are currently live for the thread at signal delivery,
+ * sve_context.head.size >=
+ *	SVE_SIG_CONTEXT_SIZE(sve_vq_from_vl(sve_context.vl))
+ * and the register data may be accessed using the SVE_SIG_*() macros.
+ *
+ * If sve_context.head.size <
+ *	SVE_SIG_CONTEXT_SIZE(sve_vq_from_vl(sve_context.vl)),
+ * the SVE registers were not live for the thread and no register data
+ * is included: in this case, the SVE_SIG_*() macros should not be
+ * used except for this check.
+ *
+ * The same convention applies when returning from a signal: a caller
+ * will need to remove or resize the sve_context block if it wants to
+ * make the SVE registers live when they were previously non-live or
+ * vice-versa.  This may require the the caller to allocate fresh
+ * memory and/or move other context blocks in the signal frame.
+ *
+ * Changing the vector length during signal return is not permitted:
+ * sve_context.vl must equal the thread's current vector length when
+ * doing a sigreturn.
+ *
+ *
+ * Note: for all these macros, the "vq" argument denotes the SVE
+ * vector length in quadwords (i.e., units of 128 bits).
+ *
+ * The correct way to obtain vq is to use sve_vq_from_vl(vl).  The
+ * result is valid if and only if sve_vl_valid(vl) is true.  This is
+ * guaranteed for a struct sve_context written by the kernel.
+ *
+ *
+ * Additional macros describe the contents and layout of the payload.
+ * For each, SVE_SIG_x_OFFSET(args) is the start offset relative to
+ * the start of struct sve_context, and SVE_SIG_x_SIZE(args) is the
+ * size in bytes:
+ *
+ *	x	type				description
+ *	-	----				-----------
+ *	REGS					the entire SVE context
+ *
+ *	ZREGS	__uint128_t[SVE_NUM_ZREGS][vq]	all Z-registers
+ *	ZREG	__uint128_t[vq]			individual Z-register Zn
+ *
+ *	PREGS	uint16_t[SVE_NUM_PREGS][vq]	all P-registers
+ *	PREG	uint16_t[vq]			individual P-register Pn
+ *
+ *	FFR	uint16_t[vq]			first-fault status register
+ *
+ * Additional data might be appended in the future.
+ */
+
+#define SVE_SIG_ZREG_SIZE(vq)	((__u32)(vq) * 16)
+#define SVE_SIG_PREG_SIZE(vq)	((__u32)(vq) * 2)
+#define SVE_SIG_FFR_SIZE(vq)	SVE_SIG_PREG_SIZE(vq)
+
+#define SVE_SIG_REGS_OFFSET	((sizeof(struct sve_context) + 15) / 16 * 16)
+
+#define SVE_SIG_ZREGS_OFFSET	SVE_SIG_REGS_OFFSET
+#define SVE_SIG_ZREG_OFFSET(vq, n) \
+	(SVE_SIG_ZREGS_OFFSET + SVE_SIG_ZREG_SIZE(vq) * (n))
+#define SVE_SIG_ZREGS_SIZE(vq) \
+	(SVE_SIG_ZREG_OFFSET(vq, SVE_NUM_ZREGS) - SVE_SIG_ZREGS_OFFSET)
+
+#define SVE_SIG_PREGS_OFFSET(vq) \
+	(SVE_SIG_ZREGS_OFFSET + SVE_SIG_ZREGS_SIZE(vq))
+#define SVE_SIG_PREG_OFFSET(vq, n) \
+	(SVE_SIG_PREGS_OFFSET(vq) + SVE_SIG_PREG_SIZE(vq) * (n))
+#define SVE_SIG_PREGS_SIZE(vq) \
+	(SVE_SIG_PREG_OFFSET(vq, SVE_NUM_PREGS) - SVE_SIG_PREGS_OFFSET(vq))
+
+#define SVE_SIG_FFR_OFFSET(vq) \
+	(SVE_SIG_PREGS_OFFSET(vq) + SVE_SIG_PREGS_SIZE(vq))
+
+#define SVE_SIG_REGS_SIZE(vq) \
+	(SVE_SIG_FFR_OFFSET(vq) + SVE_SIG_FFR_SIZE(vq) - SVE_SIG_REGS_OFFSET)
+
+#define SVE_SIG_CONTEXT_SIZE(vq) (SVE_SIG_REGS_OFFSET + SVE_SIG_REGS_SIZE(vq))
+
+
 #endif /* _UAPI__ASM_SIGCONTEXT_H */
-- 
2.1.4
