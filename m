From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v5 09/17] arm64: perf: strip PAC when unwinding userspace
Date: Fri,  5 Oct 2018 09:47:46 +0100
Message-ID: <20181005084754.20950-10-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

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
[kristina: add pointer_auth.h #include]
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/pointer_auth.h | 7 +++++++
 arch/arm64/kernel/perf_callchain.c    | 6 +++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
index 15486079e9ec..f5a4b075be65 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -57,6 +57,12 @@ static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
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
 
@@ -64,6 +70,7 @@ static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
 	ptrauth_keys_switch(&(ctx)->ptrauth_keys)
 
 #else /* CONFIG_ARM64_PTR_AUTH */
+#define ptrauth_strip_insn_pac(lr)	(lr)
 #define mm_ctx_ptrauth_init(ctx)
 #define mm_ctx_ptrauth_switch(ctx)
 #endif /* CONFIG_ARM64_PTR_AUTH */
diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index bcafd7dcfe8b..94754f07f67a 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -18,6 +18,7 @@
 #include <linux/perf_event.h>
 #include <linux/uaccess.h>
 
+#include <asm/pointer_auth.h>
 #include <asm/stacktrace.h>
 
 struct frame_tail {
@@ -35,6 +36,7 @@ user_backtrace(struct frame_tail __user *tail,
 {
 	struct frame_tail buftail;
 	unsigned long err;
+	unsigned long lr;
 
 	/* Also check accessibility of one struct frame_tail beyond */
 	if (!access_ok(VERIFY_READ, tail, sizeof(buftail)))
@@ -47,7 +49,9 @@ user_backtrace(struct frame_tail __user *tail,
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
