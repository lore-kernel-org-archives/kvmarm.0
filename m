Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8F530DD10
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 09:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762422056; cv=none; b=lqn+hJoU8zyVu5iuenrMkCKx8yBJjWR7SSv72p0UV+pMr5Vx/hDQv4lX83eE6a6M0Gm60lC/lWGQa2DF6no+RfCexQACXDDfupDSHzFbcHLyDTaYaO25MVJ5XMMasNbVhFAczNzDU0xH04dRV1tnP/FEplqegrB57CKqkINdnNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762422056; c=relaxed/simple;
	bh=Siq3+iA38MqxK3xJbo8RkPsAI6AmzKtsRsvhoQPlvsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kVuG/E0iNzIbctxc+pI/OK7uDr+dOHADCFj+t9CGwoTsJTAPb1tYN/Wk/4p0BSfrkG3hu9cO742WUreN2+pFJqRrGV7awY9nlHumxP2SuhylJ5C93FZ4+KmCRLLXSSqz3N/4rmd2bu9X3qFNgV4Kg9yGFZ9Kd7qG3SKvjL4Av8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46B2515A1;
	Thu,  6 Nov 2025 01:40:46 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8F2063F63F;
	Thu,  6 Nov 2025 01:40:50 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	yangyicong@hisilicon.com,
	scott@os.amperecomputing.com,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	pbonzini@redhat.com,
	shuah@kernel.org,
	mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v11 7/9] arm64: separate common LSUI definitions into lsui.h
Date: Thu,  6 Nov 2025 09:40:21 +0000
Message-Id: <20251106094023.1371246-8-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251106094023.1371246-1-yeoreum.yun@arm.com>
References: <20251106094023.1371246-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch prepares for applying LSUI to the armv8_deprecated
SWP instruction.
Some LSUI-related definitions can be reused by armv8_deprecated.c,
so move the common definitions into a separate header file, lsui.h.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/futex.h | 15 +--------------
 arch/arm64/include/asm/lsui.h  | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/include/asm/lsui.h

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 6778ff7e1c0e..ca9487219102 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -9,9 +9,8 @@
 #include <linux/uaccess.h>
 #include <linux/stringify.h>
 
-#include <asm/alternative.h>
-#include <asm/alternative-macros.h>
 #include <asm/errno.h>
+#include <asm/lsui.h>
 
 #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
 
@@ -97,8 +96,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
  * operation.
  */
 
-#define __LSUI_PREAMBLE	".arch_extension lsui\n"
-
 #define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
 static __always_inline int						\
 __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
@@ -249,16 +246,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
 }
 
-#define __lsui_llsc_body(op, ...)					\
-({									\
-	alternative_has_cap_likely(ARM64_HAS_LSUI) ?			\
-		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
-})
-
-#else	/* CONFIG_AS_HAS_LSUI */
-
-#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
-
 #endif	/* CONFIG_AS_HAS_LSUI */
 
 
diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
new file mode 100644
index 000000000000..1a2ad408a47b
--- /dev/null
+++ b/arch/arm64/include/asm/lsui.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_LSUI_H
+#define __ASM_LSUI_H
+
+#ifdef CONFIG_AS_HAS_LSUI
+
+#define __LSUI_PREAMBLE	".arch_extension lsui\n"
+
+#include <linux/stringify.h>
+#include <asm/alternative.h>
+#include <asm/alternative-macros.h>
+#include <asm/cpucaps.h>
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
+#endif	/* __ASM_LSUI_H */
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

