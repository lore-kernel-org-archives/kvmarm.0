From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v6 11/13] arm64: add ptrace regsets for ptrauth key management
Date: Fri,  7 Dec 2018 18:39:29 +0000
Message-ID: <20181207183931.4285-12-kristina.martsenko@arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EDBE4A214
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 13:40:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9S4FTW8D2Esn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Dec 2018 13:40:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F754A36D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 13:40:44 -0500 (EST)
In-Reply-To: <20181207183931.4285-1-kristina.martsenko@arm.com>
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
Cc: Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Richard Henderson <richard.henderson@linaro.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add two new ptrace regsets, which can be used to request and change the
pointer authentication keys of a thread. NT_ARM_PACA_KEYS gives access
to the instruction/data address keys, and NT_ARM_PACG_KEYS to the
generic authentication key.

The regsets are only exposed if the kernel is compiled with
CONFIG_CHECKPOINT_RESTORE=y, as the intended use case is checkpointing
and restoring processes that are using pointer authentication. Normally
applications or debuggers should not need to know the keys (and exposing
the keys is a security risk), so the regsets are not exposed by default.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/uapi/asm/ptrace.h | 18 +++++++++
 arch/arm64/kernel/ptrace.c           | 72 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |  2 +
 3 files changed, 92 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index c2f249bcd829..fafa7f6decf9 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -236,6 +236,24 @@ struct user_pac_mask {
 	__u64		insn_mask;
 };
 
+/* pointer authentication keys (NT_ARM_PACA_KEYS, NT_ARM_PACG_KEYS) */
+
+struct user_pac_address_keys {
+	__u64		apiakey_lo;
+	__u64		apiakey_hi;
+	__u64		apibkey_lo;
+	__u64		apibkey_hi;
+	__u64		apdakey_lo;
+	__u64		apdakey_hi;
+	__u64		apdbkey_lo;
+	__u64		apdbkey_hi;
+};
+
+struct user_pac_generic_keys {
+	__u64		apgakey_lo;
+	__u64		apgakey_hi;
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI__ASM_PTRACE_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6c1f63cb6c4e..f18f14c64d1e 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -979,6 +979,56 @@ static int pac_mask_get(struct task_struct *target,
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &uregs, 0, -1);
 }
+
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int pac_address_keys_get(struct task_struct *target,
+				const struct user_regset *regset,
+				unsigned int pos, unsigned int count,
+				void *kbuf, void __user *ubuf)
+{
+	if (!system_supports_address_auth())
+		return -EINVAL;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread_info.keys_user, 0, -1);
+}
+
+static int pac_address_keys_set(struct task_struct *target,
+				const struct user_regset *regset,
+				unsigned int pos, unsigned int count,
+				const void *kbuf, const void __user *ubuf)
+{
+	if (!system_supports_address_auth())
+		return -EINVAL;
+
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+			&target->thread_info.keys_user, 0, -1);
+}
+
+static int pac_generic_keys_get(struct task_struct *target,
+				const struct user_regset *regset,
+				unsigned int pos, unsigned int count,
+				void *kbuf, void __user *ubuf)
+{
+	if (!system_supports_generic_auth())
+		return -EINVAL;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread_info.keys_user.apga, 0, -1);
+}
+
+static int pac_generic_keys_set(struct task_struct *target,
+				const struct user_regset *regset,
+				unsigned int pos, unsigned int count,
+				const void *kbuf, const void __user *ubuf)
+{
+	if (!system_supports_generic_auth())
+		return -EINVAL;
+
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+			&target->thread_info.keys_user.apga, 0, -1);
+}
+#endif /* CONFIG_CHECKPOINT_RESTORE */
 #endif /* CONFIG_ARM64_PTR_AUTH */
 
 enum aarch64_regset {
@@ -995,6 +1045,10 @@ enum aarch64_regset {
 #endif
 #ifdef CONFIG_ARM64_PTR_AUTH
 	REGSET_PAC_MASK,
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	REGSET_PACA_KEYS,
+	REGSET_PACG_KEYS,
+#endif
 #endif
 };
 
@@ -1074,6 +1128,24 @@ static const struct user_regset aarch64_regsets[] = {
 		.get = pac_mask_get,
 		/* this cannot be set dynamically */
 	},
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	[REGSET_PACA_KEYS] = {
+		.core_note_type = NT_ARM_PACA_KEYS,
+		.n = sizeof(struct user_pac_address_keys) / sizeof(u64),
+		.size = sizeof(u64),
+		.align = sizeof(u64),
+		.get = pac_address_keys_get,
+		.set = pac_address_keys_set,
+	},
+	[REGSET_PACG_KEYS] = {
+		.core_note_type = NT_ARM_PACG_KEYS,
+		.n = sizeof(struct user_pac_generic_keys) / sizeof(u64),
+		.size = sizeof(u64),
+		.align = sizeof(u64),
+		.get = pac_generic_keys_get,
+		.set = pac_generic_keys_set,
+	},
+#endif
 #endif
 };
 
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 3f23273d690c..c1afbc592531 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -421,6 +421,8 @@ typedef struct elf64_shdr {
 #define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
 #define NT_ARM_SVE	0x405		/* ARM Scalable Vector Extension registers */
 #define NT_ARM_PAC_MASK		0x406	/* ARM pointer authentication code masks */
+#define NT_ARM_PACA_KEYS	0x407	/* ARM pointer authentication address keys */
+#define NT_ARM_PACG_KEYS	0x408	/* ARM pointer authentication generic key */
 #define NT_ARC_V2	0x600		/* ARCv2 accumulator/extra registers */
 #define NT_VMCOREDD	0x700		/* Vmcore Device Dump Note */
 #define NT_MIPS_DSP	0x800		/* MIPS DSP ASE registers */
-- 
2.11.0
