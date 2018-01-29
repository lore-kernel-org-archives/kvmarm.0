From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 15/16] arm/arm64: smccc: Implement SMCCC v1.1 inline
 primitive
Date: Mon, 29 Jan 2018 17:45:58 +0000
Message-ID: <20180129174559.1866-16-marc.zyngier@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8637549D40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jan 2018 12:43:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CGyWSbqw+MGW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jan 2018 12:42:56 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D95FE49E09
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jan 2018 12:41:12 -0500 (EST)
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Robin Murphy <robin.murphy@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

One of the major improvement of SMCCC v1.1 is that it only clobbers
the first 4 registers, both on 32 and 64bit. This means that it
becomes very easy to provide an inline version of the SMC call
primitive, and avoid performing a function call to stash the
registers that would otherwise be clobbered by SMCCC v1.0.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/arm-smccc.h | 157 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index dd44d8458c04..bc5843728909 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -150,5 +150,162 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
 
 #define arm_smccc_hvc_quirk(...) __arm_smccc_hvc(__VA_ARGS__)
 
+/* SMCCC v1.1 implementation madness follows */
+#ifdef CONFIG_ARM64
+
+#define SMCCC_SMC_INST	"smc	#0"
+#define SMCCC_HVC_INST	"hvc	#0"
+
+#define __arm_smccc_1_1_prologue(inst)					\
+	inst "\n"							\
+	"cbz	%[ptr], 1f\n"						\
+	"stp	%x[r0], %x[r1], %[ra0]\n"				\
+	"stp	%x[r2], %x[r3], %[ra2]\n"				\
+	"1:\n"								\
+	: [ra0] "=Ump" (*(&___res->a0)),				\
+	  [ra2] "=Ump" (*(&___res->a2)),
+
+#define __arm_smccc_1_1_epilogue	: "memory"
+		     
+#endif
+
+#ifdef CONFIG_ARM
+#include <asm/opcodes-sec.h>
+#include <asm/opcodes-virt.h>
+
+#define SMCCC_SMC_INST	__SMC(0)
+#define SMCCC_HVC_INST	__HVC(0)
+
+#define __arm_smccc_1_1_prologue(inst)					\
+	inst "\n"							\
+	"cmp	%[ptr], #0\n"						\
+	"stmne	%[ptr], {%[r0], %[r1], %[r2], %[r3]}\n"			\
+	: "=m" (*___res),
+
+#define __arm_smccc_1_1_epilogue	: "memory", "cc"
+		     
+#endif
+
+#define __constraint_write_0						\
+	[r0] "+r" (r0), [r1] "=r" (r1), [r2] "=r" (r2), [r3] "=r" (r3)
+#define __constraint_write_1						\
+	[r0] "+r" (r0), [r1] "+r" (r1), [r2] "=r" (r2), [r3] "=r" (r3)
+#define __constraint_write_2						\
+	[r0] "+r" (r0), [r1] "+r" (r1), [r2] "+r" (r2), [r3] "=r" (r3)
+#define __constraint_write_3						\
+	[r0] "+r" (r0), [r1] "+r" (r1), [r2] "+r" (r2), [r3] "+r" (r3)
+#define __constraint_write_4	__constraint_write_3
+#define __constraint_write_5	__constraint_write_3
+#define __constraint_write_6	__constraint_write_3
+#define __constraint_write_7	__constraint_write_3
+
+#define __constraint_read_0	: [ptr] "r" (___res)
+#define __constraint_read_1	__constraint_read_0
+#define __constraint_read_2	__constraint_read_0
+#define __constraint_read_3	__constraint_read_0
+#define __constraint_read_4	__constraint_read_3, "r" (r4)
+#define __constraint_read_5	__constraint_read_4, "r" (r5)
+#define __constraint_read_6	__constraint_read_5, "r" (r6)
+#define __constraint_read_7	__constraint_read_6, "r" (r7)
+
+#define ___count_args(_0, _1, _2, _3, _4, _5, _6, _7, _8, x, ...) x
+
+#define __count_args(...)						\
+	___count_args(__VA_ARGS__, 7, 6, 5, 4, 3, 2, 1, 0)
+
+#define __declare_arg_0(a0, res)					\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register unsigned long r1 asm("r1");				\
+	register unsigned long r2 asm("r2");				\
+	register unsigned long r3 asm("r3")
+
+#define __declare_arg_1(a0, a1, res)					\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register typeof(a1)    r1 asm("r1") = a1;			\
+	register unsigned long r2 asm("r2");				\
+	register unsigned long r3 asm("r3")
+
+#define __declare_arg_2(a0, a1, a2, res)				\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register typeof(a1)    r1 asm("r1") = a1;			\
+	register typeof(a2)    r2 asm("r2") = a2;			\
+	register unsigned long r3 asm("r3")
+
+#define __declare_arg_3(a0, a1, a2, a3, res)				\
+	struct arm_smccc_res   *___res = res;				\
+	register u32           r0 asm("r0") = a0;			\
+	register typeof(a1)    r1 asm("r1") = a1;			\
+	register typeof(a2)    r2 asm("r2") = a2;			\
+	register typeof(a3)    r3 asm("r3") = a3
+
+#define __declare_arg_4(a0, a1, a2, a3, a4, res)			\
+	__declare_arg_3(a0, a1, a2, a3, res);				\
+	register typeof(a4) r4 asm("r4") = a4
+
+#define __declare_arg_5(a0, a1, a2, a3, a4, a5, res)			\
+	__declare_arg_4(a0, a1, a2, a3, a4, res);			\
+	register typeof(a5) r5 asm("r5") = a5
+
+#define __declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res)		\
+	__declare_arg_5(a0, a1, a2, a3, a4, a5, res);			\
+	register typeof(a6) r6 asm("r6") = a6
+
+#define __declare_arg_7(a0, a1, a2, a3, a4, a5, a6, a7, res)		\
+	__declare_arg_6(a0, a1, a2, a3, a4, a5, a6, res);		\
+	register typeof(a7) r7 asm("r7") = a7
+
+#define ___declare_args(count, ...) __declare_arg_ ## count(__VA_ARGS__)
+#define __declare_args(count, ...)  ___declare_args(count, __VA_ARGS__)
+
+#define ___constraint_write(count)  __constraint_write_ ## count
+#define __constraint_write(count)   ___constraint_write(count)
+
+#define ___constraint_read(count)   __constraint_read_ ## count
+#define __constraint_read(count)    ___constraint_read(count)
+
+#define __arm_smccc_1_1(inst, ...)					\
+	do {								\
+		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
+		asm(__arm_smccc_1_1_prologue(inst)			\
+		    __constraint_write(__count_args(__VA_ARGS__))	\
+		    __constraint_read(__count_args(__VA_ARGS__))	\
+		    __arm_smccc_1_1_epilogue);				\
+	} while (0)
+
+/*
+ * arm_smccc_1_1_smc() - make an SMCCC v1.1 compliant SMC call
+ *
+ * This is a variadic macro taking one to eight source arguments, and
+ * an optional return structure.
+ *
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This macro is used to make SMC calls following SMC Calling Convention v1.1.
+ * The content of the supplied param are copied to registers 0 to 7 prior
+ * to the SMC instruction. The return values are updated with the content
+ * from register 0 to 3 on return from the SMC instruction if not NULL.
+ */
+#define arm_smccc_1_1_smc(...)	__arm_smccc_1_1(SMCCC_SMC_INST, __VA_ARGS__)
+
+/*
+ * arm_smccc_1_1_hvc() - make an SMCCC v1.1 compliant HVC call
+ *
+ * This is a variadic macro taking one to eight source arguments, and
+ * an optional return structure.
+ *
+ * @a0-a7: arguments passed in registers 0 to 7
+ * @res: result values from registers 0 to 3
+ *
+ * This macro is used to make HVC calls following SMC Calling Convention v1.1.
+ * The content of the supplied param are copied to registers 0 to 7 prior
+ * to the HVC instruction. The return values are updated with the content
+ * from register 0 to 3 on return from the HVC instruction if not NULL.
+ */
+#define arm_smccc_1_1_hvc(...)	__arm_smccc_1_1(SMCCC_HVC_INST, __VA_ARGS__)
+
 #endif /*__ASSEMBLY__*/
 #endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.14.2
