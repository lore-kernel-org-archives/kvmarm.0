Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3F82EA48A
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753186816; cv=none; b=pKUU4Y2EDw96pKy2GPHVq+ow09gkrJeoWdzJMD5RZbHjmPY5b5IrhUZ7UVJaZs0bBO7kmE2XbVDBG9aVtvqjQWHUGEcfkCILeyvrMkvEkokgxgEun46cy4pLsadhjE1ihH0Uygda6ItZpRbz4CBNedvAt9Wpo+ixqGBcY6W9CAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753186816; c=relaxed/simple;
	bh=R/uCGAFuKyk/yhRsJFbZFTF2BDn+0ZJdwuNVRlQb7rU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gwh14IlW60cFSMGfgSL4jsjf+PD/sTUMse8SAc2aWpGg/3i8DhFuaPYcuCyUY3obHQbz9A1JnEscNi02sI7FMBnFEy94MglraDTOplwx8SQimRUjuDQQbvzNs1I9KtCqH/Jh2Hq9rcwxGyRIaeii+FyhdIK16iX2CJgR0DGUB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A5CE169E;
	Tue, 22 Jul 2025 05:20:08 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C9103F59E;
	Tue, 22 Jul 2025 05:20:11 -0700 (PDT)
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
Subject: [PATCH v5 5/5] arm64: futex: support futex with FEAT_LSUI
Date: Tue, 22 Jul 2025 13:19:56 +0100
Message-Id: <20250722121956.1509403-6-yeoreum.yun@arm.com>
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

Current futex atomic operations are implemented with ll/sc instructions
and clearing PSTATE.PAN.

Since Armv9.6, FEAT_LSUI supplies not only load/store instructions but
also atomic operation for user memory access in kernel it doesn't need
to clear PSTATE.PAN bit anymore.

With theses instructions some of futex atomic operations don't need to
be implmented with ldxr/stlxr pair instead can be implmented with
one atomic operation supplied by FEAT_LSUI.

However, some of futex atomic operations still need to use ll/sc way
via ldtxr/stltxr supplied by FEAT_LSUI since there is no correspondant
atomic instruction or doesn't support word size operation.
(i.e) eor, cas{mb}t

But It's good to work without clearing PSTATE.PAN bit.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/futex.h | 142 ++++++++++++++++++++++++++++++++-
 1 file changed, 141 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index fdec4f3f2b15..38fc98f4af46 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -9,6 +9,8 @@
 #include <linux/uaccess.h>
 #include <linux/stringify.h>
 
+#include <asm/alternative.h>
+#include <asm/alternative-macros.h>
 #include <asm/errno.h>
 
 #define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
@@ -115,11 +117,149 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 	return ret;
 }
 
+#ifdef CONFIG_AS_HAS_LSUI
+
+#define __LSUI_PREAMBLE	".arch_extension lsui\n"
+
+#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
+static __always_inline int						\
+__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
+{									\
+	int ret = 0;							\
+	int val;							\
+									\
+	mte_enable_tco();						\
+	uaccess_ttbr0_enable();						\
+									\
+	asm volatile("// __lsui_futex_atomic_" #op "\n"			\
+	__LSUI_PREAMBLE							\
+	"1:	" #asm_op #mb "	%w3, %w2, %1\n"				\
+	"2:\n"								\
+	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)				\
+	: "+r" (ret), "+Q" (*uaddr), "=r" (val)				\
+	: "r" (oparg)							\
+	: "memory");							\
+									\
+	mte_disable_tco();						\
+	uaccess_ttbr0_disable();					\
+									\
+	if (!ret)							\
+		*oval = val;						\
+									\
+	return ret;							\
+}
+
+LSUI_FUTEX_ATOMIC_OP(add, ldtadd, al)
+LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
+LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
+LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
+
+static __always_inline int
+__lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
+{
+	return __lsui_futex_atomic_andnot(~oparg, uaddr, oval);
+}
+
+static __always_inline int
+__lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
+{
+	unsigned int loops = LLSC_MAX_LOOPS;
+	int ret, val, tmp;
+
+	mte_enable_tco();
+	uaccess_ttbr0_enable();
+
+	/*
+	 * there are no ldteor/stteor instructions...
+	 */
+	asm volatile("// __lsui_futex_atomic_eor\n"
+	__LSUI_PREAMBLE
+	"	prfm	pstl1strm, %2\n"
+	"1:	ldtxr	%w1, %2\n"
+	"	eor	%w3, %w1, %w5\n"
+	"2:	stltxr	%w0, %w3, %2\n"
+	"	cbz	%w0, 3f\n"
+	"	sub	%w4, %w4, %w0\n"
+	"	cbnz	%w4, 1b\n"
+	"	mov	%w0, %w6\n"
+	"3:\n"
+	"	dmb	ish\n"
+	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
+	_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
+	: "=&r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp),
+	  "+r" (loops)
+	: "r" (oparg), "Ir" (-EAGAIN)
+	: "memory");
+
+	mte_disable_tco();
+	uaccess_ttbr0_disable();
+
+	if (!ret)
+		*oval = val;
+
+	return ret;
+}
+
+static __always_inline int
+__lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+	int ret = 0;
+	unsigned int loops = LLSC_MAX_LOOPS;
+	u32 val, tmp;
+
+	mte_enable_tco();
+	uaccess_ttbr0_enable();
+
+	/*
+	 * cas{al}t doesn't support word size...
+	 */
+	asm volatile("//__lsui_futex_cmpxchg\n"
+	__LSUI_PREAMBLE
+	"	prfm	pstl1strm, %2\n"
+	"1:	ldtxr	%w1, %2\n"
+	"	eor	%w3, %w1, %w5\n"
+	"	cbnz	%w3, 4f\n"
+	"2:	stltxr	%w3, %w6, %2\n"
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
+
+	mte_disable_tco();
+	uaccess_ttbr0_disable();
+
+	if (!ret)
+		*oval = oldval;
+
+	return ret;
+}
+
+#define __lsui_llsc_body(op, ...)					\
+({									\
+	alternative_has_cap_likely(ARM64_HAS_LSUI) ?			\
+		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
+})
+
+#else	/* CONFIG_AS_HAS_LSUI */
+
+#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
+
+#endif	/* CONFIG_AS_HAS_LSUI */
+
+
 #define FUTEX_ATOMIC_OP(op)						\
 static __always_inline int						\
 __futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)		\
 {									\
-	return __llsc_futex_atomic_##op(oparg, uaddr, oval);		\
+	return __lsui_llsc_body(futex_atomic_##op, oparg, uaddr, oval);	\
 }
 
 FUTEX_ATOMIC_OP(add)
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

