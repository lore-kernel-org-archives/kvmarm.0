Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BC283FE36D
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337989; cv=none; b=EabNa66YIBiWTc08Qjgqufbkdf3kkXqNqy2+DQ0tad2mSbHkohXWyl9ikrPX3sWt9aWv8joBCe7hcWdPHbrQmv55+CYhyk/210msIdhgnw3EiuTMpcPmOf9bKHOeV0F86LtMyHNGAVfKc7dphkmNXQyqLNmAMGcSH5ciw7KgqU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337989; c=relaxed/simple;
	bh=hmrsPcUKbH2aliBzWhmeFYY6NKNx0rg11MOal3qm7xM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hHiiG710BtzoNMxVGBbzqd2Fy6enytGeuP8btAkmLiEfffFL1f3FugEYl86PfcFKH6krJbuJkZrToj/d0fw7pRRGfuzk124gFIXUIByOnSKD0qCBVBmGxTbcSOIQYtRtXw+ZQSe9r7ngVLdYLASltzAD4dA6JaUXp+aRfRey9As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 606FB165C;
	Thu, 12 Mar 2026 10:53:01 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0CAA73F73B;
	Thu, 12 Mar 2026 10:53:04 -0700 (PDT)
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
Subject: [PATCH v16 7/8] KVM: arm64: use CAST instruction for swapping guest descriptor
Date: Thu, 12 Mar 2026 17:52:42 +0000
Message-Id: <20260312175243.1593864-8-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312175243.1593864-1-yeoreum.yun@arm.com>
References: <20260312175243.1593864-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the CAST instruction to swap the guest descriptor when FEAT_LSUI
is enabled, avoiding the need to clear the PAN bit.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kvm/at.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 6588ea251ed7..ccdf76d46a2e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -9,6 +9,7 @@
 #include <asm/esr.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/lsui.h>
 
 static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
 {
@@ -1681,6 +1682,43 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	}
 }
 
+static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
+{
+	u64 tmp = old;
+	int ret = 0;
+
+	/*
+	 * FEAT_LSUI is supported since Armv9.6, where FEAT_PAN is mandatory.
+	 * However, this assumption may not always hold:
+	 *
+	 *   - Some CPUs advertise FEAT_LSUI but lack FEAT_PAN.
+	 *   - Virtualisation or ID register overrides may expose invalid
+	 *     feature combinations.
+	 *
+	 * Rather than disabling FEAT_LSUI when FEAT_PAN is absent, wrap LSUI
+	 * instructions with uaccess_ttbr0_enable()/disable() when
+	 * ARM64_SW_TTBR0_PAN is enabled.
+	 */
+	uaccess_ttbr0_enable();
+
+	asm volatile(__LSUI_PREAMBLE
+		     "1: cast	%[old], %[new], %[addr]\n"
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
@@ -1756,7 +1794,9 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
 		return -EPERM;
 
 	ptep = (u64 __user *)hva + offset;
-	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
+	if (cpus_have_final_cap(ARM64_HAS_LSUI))
+		r = __lsui_swap_desc(ptep, old, new);
+	else if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
 		r = __lse_swap_desc(ptep, old, new);
 	else
 		r = __llsc_swap_desc(ptep, old, new);
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

