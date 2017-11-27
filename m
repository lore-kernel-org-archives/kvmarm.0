From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 08/12] arm64: perf: strip PAC when unwinding userspace
Date: Mon, 27 Nov 2017 16:38:02 +0000
Message-ID: <20171127163806.31435-9-mark.rutland@arm.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E57549D6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 11:36:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vQ5RQ-2aKrTS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Nov 2017 11:36:24 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8B8449DC4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 11:36:24 -0500 (EST)
In-Reply-To: <20171127163806.31435-1-mark.rutland@arm.com>
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
Cc: linux-arch@vger.kernel.org, cdall@linaro.org, arnd@arndb.de, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When the kernel is unwinding userspace callchains, we can't expect that
the userspace consumer of these callchains has the data necessary to
strip the PAC from the stored LR.

This patch has the kernel strip the PAC from user stackframes when the
in-kernel unwinder is used. This only affects the LR value, and not the
FP.

This only affects the in-kernel unwinder. When userspace performs
unwinding, it is up to userspace to strip PACs as necessary (which can
be determined from DWARF information).

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yao Qi <yao.qi@arm.com>
---
 arch/arm64/include/asm/pointer_auth.h | 7 +++++++
 arch/arm64/kernel/perf_callchain.c    | 5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
index b08ebec4b806..07788ce755bc 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -79,6 +79,12 @@ static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
  */
 #define ptrauth_pac_mask() 	GENMASK(54, VA_BITS)
 
+/* Only valid for EL0 TTBR0 instruction pointers */
+static inline unsigned long ptrauth_strip_insn_pac(unsigned long ptr)
+{
+	return ptr & ~ptrauth_pac_mask();
+}
+
 #define mm_ctx_ptrauth_init(ctx) \
 	ptrauth_keys_init(&(ctx)->ptrauth_keys)
 
@@ -89,6 +95,7 @@ static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
 	ptrauth_keys_dup(&(oldctx)->ptrauth_keys, &(newctx)->ptrauth_keys)
 
 #else
+#define ptrauth_strip_insn_pac(lr)	(lr)
 #define mm_ctx_ptrauth_init(ctx)
 #define mm_ctx_ptrauth_switch(ctx)
 #define mm_ctx_ptrauth_dup(oldctx, newctx)
diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index bcafd7dcfe8b..928204f6ab08 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -35,6 +35,7 @@ user_backtrace(struct frame_tail __user *tail,
 {
 	struct frame_tail buftail;
 	unsigned long err;
+	unsigned long lr;
 
 	/* Also check accessibility of one struct frame_tail beyond */
 	if (!access_ok(VERIFY_READ, tail, sizeof(buftail)))
@@ -47,7 +48,9 @@ user_backtrace(struct frame_tail __user *tail,
 	if (err)
 		return NULL;
 
-	perf_callchain_store(entry, buftail.lr);
+	lr = ptrauth_strip_insn_pac(buftail.lr);
+
+	perf_callchain_store(entry, lr);
 
 	/*
 	 * Frame pointers should strictly progress back up the stack
-- 
2.11.0
