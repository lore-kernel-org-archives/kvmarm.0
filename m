Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E111374196
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 18:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772044057; cv=none; b=Vfu2g8S5EEDxgJ4LOKqczvJt547+n+KzVRYRyHen96HXk3D5HnjtZYxKh3kUy8BcJFiRssUgsIU8iRJhAhifWukAyVvwTB1YLf+bA3kPKbOI8EmiY8p+MVV4nQOG/DGr5XuY2qfZALVREOcSwtcEuYA+nr7YD8+TLtMZyNDU/Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772044057; c=relaxed/simple;
	bh=b7+LMWjNK3/4njTMMP73B9OiveWiB/WSoRJeoWAp5Gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LBZ5L5WmfAK5FvfwrgDl5//pyk6CiCSyA1AeLcaK3A2cf1lXWW5GG0sEmUwkRwQ9VxTEac0cH2am56X34LnMd/rZF8AVVGUYzAxGp9COETlE2Dl+KPUtVhP8jE6oQPpe1zhGlZr6rOoe5b1g2qvBRMcaiiOkrILQFBKsrVEg938=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A908C1691;
	Wed, 25 Feb 2026 10:27:29 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1CA173F73B;
	Wed, 25 Feb 2026 10:27:32 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping guest descriptor
Date: Wed, 25 Feb 2026 18:27:07 +0000
Message-Id: <20260225182708.3225211-8-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260225182708.3225211-1-yeoreum.yun@arm.com>
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
is enabled, avoiding the need to clear the PAN bit.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  2 ++
 arch/arm64/include/asm/futex.h   | 17 +----------------
 arch/arm64/include/asm/lsui.h    | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/at.c              | 30 +++++++++++++++++++++++++++++-
 4 files changed, 59 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/include/asm/lsui.h

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 177c691914f8..6e3da333442e 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
 		return true;
 	case ARM64_HAS_PMUV3:
 		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
+	case ARM64_HAS_LSUI:
+		return IS_ENABLED(CONFIG_ARM64_LSUI);
 	}
 
 	return true;
diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index b579e9d0964d..6779c4ad927f 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -7,11 +7,9 @@
 
 #include <linux/futex.h>
 #include <linux/uaccess.h>
-#include <linux/stringify.h>
 
-#include <asm/alternative.h>
-#include <asm/alternative-macros.h>
 #include <asm/errno.h>
+#include <asm/lsui.h>
 
 #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
 
@@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 
 #ifdef CONFIG_ARM64_LSUI
 
-#define __LSUI_PREAMBLE	".arch_extension lsui\n"
-
 #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
 static __always_inline int						\
 __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
@@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 {
 	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
 }
-
-#define __lsui_llsc_body(op, ...)					\
-({									\
-	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
-		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
-})
-
-#else	/* CONFIG_ARM64_LSUI */
-
-#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
-
 #endif	/* CONFIG_ARM64_LSUI */
 
 
diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
new file mode 100644
index 000000000000..8f0d81953eb6
--- /dev/null
+++ b/arch/arm64/include/asm/lsui.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_LSUI_H
+#define __ASM_LSUI_H
+
+#include <linux/compiler_types.h>
+#include <linux/stringify.h>
+#include <asm/alternative.h>
+#include <asm/alternative-macros.h>
+#include <asm/cpucaps.h>
+
+#define __LSUI_PREAMBLE	".arch_extension lsui\n"
+
+#ifdef CONFIG_ARM64_LSUI
+
+#define __lsui_llsc_body(op, ...)					\
+({									\
+	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
+		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
+})
+
+#else	/* CONFIG_ARM64_LSUI */
+
+#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
+
+#endif	/* CONFIG_ARM64_LSUI */
+
+#endif	/* __ASM_LSUI_H */
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 885bd5bb2f41..fd3c5749e853 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -9,6 +9,7 @@
 #include <asm/esr.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/lsui.h>
 
 static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
 {
@@ -1704,6 +1705,31 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	}
 }
 
+static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
+{
+	u64 tmp = old;
+	int ret = 0;
+
+	uaccess_ttbr0_enable();
+
+	asm volatile(__LSUI_PREAMBLE
+		     "1: caslt	%[old], %[new], %[addr]\n"
+		     "2:\n"
+		     _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w[ret])
+		     : [old] "+r" (old), [addr] "+Q" (*ptep), [ret] "+r" (ret)
+		     : [new] "r" (new)
+		     : "memory");
+
+	uaccess_ttbr0_disable();
+
+	if (ret)
+		return ret;
+	if (tmp != old)
+		return -EAGAIN;
+
+	return ret;
+}
+
 static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
 {
 	u64 tmp = old;
@@ -1779,7 +1805,9 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
 		return -EPERM;
 
 	ptep = (u64 __user *)hva + offset;
-	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
+	if (cpucap_is_possible(ARM64_HAS_LSUI) && cpus_have_final_cap(ARM64_HAS_LSUI))
+		r = __lsui_swap_desc(ptep, old, new);
+	else if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
 		r = __lse_swap_desc(ptep, old, new);
 	else
 		r = __llsc_swap_desc(ptep, old, new);
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

