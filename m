Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E8C30DD2C
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 09:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762422064; cv=none; b=saX8I1T8q2GD2V5qOSPlHfwEyAbkd6gHbRPCTF56ulg85iBR1xBNnVVToTjuicLu/IrvUTUjj68kinhFRpGbXj8SQXOcLu6TqRCpKU7MgPNGltcfMAKvkXp+JRzEjeCAdqLwrC8VbIaBtisvd9os3NYlXY25A366SW+igBzOngg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762422064; c=relaxed/simple;
	bh=8wkKqIwNbyN7I7/HPYVeMmDdvS4HQpc4c7E7Cb3xp5o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hd1MOuM+JRzcHaieZEueg5hi50kc6etzJOZbPK6DOSIoKEYMlmL1IUKcHa9ZQ6l6AOt2eYxBpw6eut1MWMAHIIR2EPhwEtvZMXrtHzMbdjkh36q3UqbirYnRSswAcifmlS3edZ3Fq/s9HOTm/5Kht3Vr3pOUDwjsUwKwi1hK4bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AE981764;
	Thu,  6 Nov 2025 01:40:53 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C20953F63F;
	Thu,  6 Nov 2025 01:40:57 -0800 (PST)
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
Subject: [PATCH v11 9/9] arm64: armv8_deprecated: apply FEAT_LSUI for swpX emulation.
Date: Thu,  6 Nov 2025 09:40:23 +0000
Message-Id: <20251106094023.1371246-10-yeoreum.yun@arm.com>
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

apply FEAT_LSUI instruction to emulate deprecated swpX instruction.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kernel/armv8_deprecated.c | 77 +++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/armv8_deprecated.c b/arch/arm64/kernel/armv8_deprecated.c
index d15e35f1075c..b8e6d71f766d 100644
--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -13,6 +13,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/cpufeature.h>
+#include <asm/lsui.h>
 #include <asm/insn.h>
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
@@ -86,13 +87,77 @@ static unsigned int __maybe_unused aarch32_check_condition(u32 opcode, u32 psr)
  *	   Rn  = address
  */
 
+/* Arbitrary constant to ensure forward-progress of the loop */
+#define __SWP_LOOPS	4
+
+#ifdef CONFIG_AS_HAS_LSUI
+static __always_inline int
+__lsui_user_swp_asm(unsigned int *data, unsigned int addr)
+{
+	int err = 0;
+	unsigned int temp;
+
+	asm volatile("// __lsui_user_swp_asm\n"
+	__LSUI_PREAMBLE
+	"1:	swpt		%w1, %w2, [%3]\n"
+	"	mov		%w1, %w2\n"
+	"2:\n"
+	_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
+	: "+r" (err), "+r" (*data), "=&r" (temp)
+	: "r" ((unsigned long)addr)
+	: "memory");
+
+	return err;
+}
+
+static __always_inline int
+__lsui_user_swpb_asm(unsigned int *data, unsigned int addr)
+{
+	u8 i, idx;
+	int err = -EAGAIN;
+	u64 __user *addr_al;
+	u64 oldval;
+	union {
+		u64 var;
+		u8 raw[sizeof(u64)];
+	} newval, curval;
+
+	idx = addr & (sizeof(u64) - 1);
+	addr_al = (u64 __user *)ALIGN_DOWN(addr, sizeof(u64));
+
+	for (i = 0; i < __SWP_LOOPS; i++) {
+		if (get_user(oldval, addr_al))
+			return -EFAULT;
+
+		curval.var = newval.var = oldval;
+		newval.raw[idx] = *data;
+
+		asm volatile("// __lsui_user_swpb_asm\n"
+		__LSUI_PREAMBLE
+		"1: cast	%x2, %x3, %1\n"
+		"2:\n"
+		_ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w0)
+		: "+r" (err), "+Q" (*addr_al), "+r" (curval.var)
+		: "r" (newval.var)
+		: "memory");
+
+		if (curval.var == oldval) {
+			err = 0;
+			break;
+		}
+	}
+
+	if (!err)
+		*data = curval.raw[idx];
+
+	return err;
+}
+#endif /* CONFIG_AS_HAS_LSUI */
+
 /*
  * Error-checking SWP macros implemented using ldxr{b}/stxr{b}
  */
 
-/* Arbitrary constant to ensure forward-progress of the LL/SC loop */
-#define __SWP_LL_SC_LOOPS	4
-
 #define LLSC_USER_SWPX(B)					\
 static __always_inline int					\
 __llsc_user_swp##B##_asm(unsigned int *data, unsigned int addr)	\
@@ -117,7 +182,7 @@ __llsc_user_swp##B##_asm(unsigned int *data, unsigned int addr)	\
 	_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)			\
 	: "=&r" (err), "+r" (*data), "=&r" (temp), "=&r" (temp2)\
 	: "r" ((unsigned long)addr), "i" (-EAGAIN),		\
-	  "i" (__SWP_LL_SC_LOOPS)				\
+	  "i" (__SWP_LOOPS)					\
 	: "memory");						\
 	uaccess_disable_privileged();				\
 								\
@@ -128,9 +193,9 @@ LLSC_USER_SWPX()
 LLSC_USER_SWPX(b)
 
 #define __user_swp_asm(data, addr) \
-	__llsc_user_swp_asm(data, addr)
+	__lsui_llsc_body(user_swp_asm, data, addr)
 #define __user_swpb_asm(data, addr) \
-	__llsc_user_swpb_asm(data, addr)
+	__lsui_llsc_body(user_swpb_asm, data, addr)
 
 /*
  * Bit 22 of the instruction encoding distinguishes between
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

