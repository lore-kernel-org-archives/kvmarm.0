Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0592EA477
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753186813; cv=none; b=AMHgvXQ2+bTR3CsCAcPSEHk12g4ZKG9pDJi/zkjtURTUEr3U2ZSmv9CawyNKXy17yPMsVlODxt5QCag9GNctO7YcbuczXLM1fNdwuJ3XjOc1UAkFUipsC0fFPYNAAu7CB1btmZbaH/Yidr+fsfDncbmpWITQi0BcgTmqtVsPKi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753186813; c=relaxed/simple;
	bh=cWgygJDXMt6JwpKU8NgFPFGmx/+DwZkHXRta+fxpjwo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JE9Za+rdVrR6k2PqWToZbJowSJ9pngpCdq1Xwb7nSXLKZf4mZOOMv1f1imKk9KK30JfMAbUi4YRYOgqV8lkKAb+lYQmpB3MBxx7K0i0d/umO+Xi6DnYWHdoyDB/cQRavRQHuQV9DyNIgKoOLOCSFPTgPdlKfH6F1zebY0sEni3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF9CF152B;
	Tue, 22 Jul 2025 05:20:05 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DD6BB3F59E;
	Tue, 22 Jul 2025 05:20:08 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	broonie@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com,
	james.morse@arm.com,
	ardb@kernel.org,
	scott@os.amperecomputing.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v5 4/5] arm64: futex: refactor futex atomic operation
Date: Tue, 22 Jul 2025 13:19:55 +0100
Message-Id: <20250722121956.1509403-5-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250722121956.1509403-1-yeoreum.yun@arm.com>
References: <20250722121956.1509403-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor futex atomic operations using ll/sc method with
clearing PSTATE.PAN to prepare to apply FEAT_LSUI on them.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/futex.h | 183 ++++++++++++++++++++++-----------
 1 file changed, 124 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index bc06691d2062..fdec4f3f2b15 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -7,73 +7,164 @@
 
 #include <linux/futex.h>
 #include <linux/uaccess.h>
+#include <linux/stringify.h>
 
 #include <asm/errno.h>
 
-#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
+#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
 
-#define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
-do {									\
-	unsigned int loops = FUTEX_MAX_LOOPS;				\
+#define LLSC_FUTEX_ATOMIC_OP(op, asm_op)				\
+static __always_inline int						\
+__llsc_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
+{									\
+	unsigned int loops = LLSC_MAX_LOOPS;				\
+	int ret, val, tmp;						\
 									\
 	uaccess_enable_privileged();					\
-	asm volatile(							\
-"	prfm	pstl1strm, %2\n"					\
-"1:	ldxr	%w1, %2\n"						\
-	insn "\n"							\
-"2:	stlxr	%w0, %w3, %2\n"						\
-"	cbz	%w0, 3f\n"						\
-"	sub	%w4, %w4, %w0\n"					\
-"	cbnz	%w4, 1b\n"						\
-"	mov	%w0, %w6\n"						\
-"3:\n"									\
-"	dmb	ish\n"							\
+	asm volatile("// __llsc_futex_atomic_" #op "\n"		\
+	"	prfm	pstl1strm, %2\n"				\
+	"1:	ldxr	%w1, %2\n"					\
+	"	" #asm_op "	%w3, %w1, %w5\n"			\
+	"2:	stlxr	%w0, %w3, %2\n"					\
+	"	cbz	%w0, 3f\n"					\
+	"	sub	%w4, %w4, %w0\n"				\
+	"	cbnz	%w4, 1b\n"					\
+	"	mov	%w0, %w6\n"					\
+	"3:\n"								\
+	"	dmb	ish\n"						\
 	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)				\
 	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)				\
-	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),	\
+	: "=&r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp),		\
 	  "+r" (loops)							\
 	: "r" (oparg), "Ir" (-EAGAIN)					\
 	: "memory");							\
 	uaccess_disable_privileged();					\
-} while (0)
+									\
+	if (!ret)							\
+		*oval = val;						\
+									\
+	return ret;							\
+}
+
+LLSC_FUTEX_ATOMIC_OP(add, add)
+LLSC_FUTEX_ATOMIC_OP(or, orr)
+LLSC_FUTEX_ATOMIC_OP(and, and)
+LLSC_FUTEX_ATOMIC_OP(eor, eor)
+
+static __always_inline int
+__llsc_futex_atomic_set(int oparg, u32 __user *uaddr, int *oval)
+{
+	unsigned int loops = LLSC_MAX_LOOPS;
+	int ret, val;
+
+	uaccess_enable_privileged();
+	asm volatile("//__llsc_futex_xchg\n"
+	"	prfm	pstl1strm, %2\n"
+	"1:	ldxr	%w1, %2\n"
+	"2:	stlxr	%w0, %w4, %2\n"
+	"	cbz	%w3, 3f\n"
+	"	sub	%w3, %w3, %w0\n"
+	"	cbnz	%w3, 1b\n"
+	"	mov	%w0, %w5\n"
+	"3:\n"
+	"	dmb	ish\n"
+	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
+	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
+	: "=&r" (ret), "=&r" (val), "+Q" (*uaddr), "+r" (loops)
+	: "r" (oparg), "Ir" (-EAGAIN)
+	: "memory");
+	uaccess_disable_privileged();
+
+	if (!ret)
+		*oval = val;
+
+	return ret;
+}
+
+static __always_inline int
+__llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+	int ret = 0;
+	unsigned int loops = LLSC_MAX_LOOPS;
+	u32 val, tmp;
+
+	uaccess_enable_privileged();
+	asm volatile("//__llsc_futex_cmpxchg\n"
+	"	prfm	pstl1strm, %2\n"
+	"1:	ldxr	%w1, %2\n"
+	"	eor	%w3, %w1, %w5\n"
+	"	cbnz	%w3, 4f\n"
+	"2:	stlxr	%w3, %w6, %2\n"
+	"	cbz	%w3, 3f\n"
+	"	sub	%w4, %w4, %w3\n"
+	"	cbnz	%w4, 1b\n"
+	"	mov	%w0, %w7\n"
+	"3:\n"
+	"	dmb	ish\n"
+	"4:\n"
+	_ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
+	_ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
+	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
+	: "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
+	: "memory");
+	uaccess_disable_privileged();
+
+	if (!ret)
+		*oval = val;
+
+	return ret;
+}
+
+#define FUTEX_ATOMIC_OP(op)						\
+static __always_inline int						\
+__futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
+{									\
+	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
+}
+
+FUTEX_ATOMIC_OP(add)
+FUTEX_ATOMIC_OP(or)
+FUTEX_ATOMIC_OP(and)
+FUTEX_ATOMIC_OP(eor)
+FUTEX_ATOMIC_OP(set)
+
+static __always_inline int
+__futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+	return __llsc_futex_cmpxchg(uaddr, oldval, newval, oval);
+}
 
 static inline int
 arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
 {
-	int oldval = 0, ret, tmp;
-	u32 __user *uaddr = __uaccess_mask_ptr(_uaddr);
+	int ret;
+	u32 __user *uaddr;
 
 	if (!access_ok(_uaddr, sizeof(u32)))
 		return -EFAULT;
 
+	uaddr = __uaccess_mask_ptr(_uaddr);
+
 	switch (op) {
 	case FUTEX_OP_SET:
-		__futex_atomic_op("mov	%w3, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_set(oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op("add	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_add(oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_OR:
-		__futex_atomic_op("orr	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_or(oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_atomic_op("and	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, ~oparg);
+		ret = __futex_atomic_and(~oparg, uaddr, oval);
 		break;
 	case FUTEX_OP_XOR:
-		__futex_atomic_op("eor	%w3, %w1, %w5",
-				  ret, oldval, uaddr, tmp, oparg);
+		ret = __futex_atomic_eor(oparg, uaddr, oval);
 		break;
 	default:
 		ret = -ENOSYS;
 	}
 
-	if (!ret)
-		*oval = oldval;
-
 	return ret;
 }
 
@@ -81,40 +172,14 @@ static inline int
 futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_uaddr,
 			      u32 oldval, u32 newval)
 {
-	int ret = 0;
-	unsigned int loops = FUTEX_MAX_LOOPS;
-	u32 val, tmp;
 	u32 __user *uaddr;
 
 	if (!access_ok(_uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	uaddr = __uaccess_mask_ptr(_uaddr);
-	uaccess_enable_privileged();
-	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
-"	prfm	pstl1strm, %2\n"
-"1:	ldxr	%w1, %2\n"
-"	sub	%w3, %w1, %w5\n"
-"	cbnz	%w3, 4f\n"
-"2:	stlxr	%w3, %w6, %2\n"
-"	cbz	%w3, 3f\n"
-"	sub	%w4, %w4, %w3\n"
-"	cbnz	%w4, 1b\n"
-"	mov	%w0, %w7\n"
-"3:\n"
-"	dmb	ish\n"
-"4:\n"
-	_ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
-	_ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
-	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
-	: "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
-	: "memory");
-	uaccess_disable_privileged();
 
-	if (!ret)
-		*uval = val;
-
-	return ret;
+	return __futex_cmpxchg(uaddr, oldval, newval, uval);
 }
 
 #endif /* __ASM_FUTEX_H */
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

