Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A21A346770
	for <kvmarm@lists.linux.dev>; Sat, 14 Mar 2026 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773510719; cv=none; b=u4f0UH4nVPz70b91caGzgIq5e6qYYm8CBZPQF7WzFWDOAeKUPcH1xiImRjiE9f+WXbA4ZzVT1CRjrmyG5Mtmi4R7Hi1jlbVozCrsaOV0Ldc9WzqzO3PBfpbhNyLNV9SzRZTRV3MSZgdDcpWbgqACnH2HrCywHDgw99ZCdTjT/Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773510719; c=relaxed/simple;
	bh=I4J9rKMhApLJCCl52+Grp6+AKq8MbmNhvolUbJ5B1cs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BJ6PTWrj4AY5Sco6vYCHqqh1phfP2z2uR/M8ZNWotzbsaft9wdzI/TXaEJLP47x/DpL5SYbqobW6J69uvwc/ZdS7/XQhMVRTxWphiSeq2rXh8HmOFRE2zgRuLw0NyYU7eTXHPBx9rBpTZs7A43dCPz8v9DwvyMjBA6hCNV/tvI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F739152B;
	Sat, 14 Mar 2026 10:51:51 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B28AB3F73B;
	Sat, 14 Mar 2026 10:51:54 -0700 (PDT)
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
Subject: [PATCH v17 7/8] KVM: arm64: use CAST instruction for swapping guest descriptor
Date: Sat, 14 Mar 2026 17:51:32 +0000
Message-Id: <20260314175133.1084528-8-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260314175133.1084528-1-yeoreum.yun@arm.com>
References: <20260314175133.1084528-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the CAST instruction to swap the guest descriptor when FEAT_LSUI
is enabled, avoiding the need to clear the PAN bit.

FEAT_LSUI is introduced in Armv9.6, where FEAT_PAN is mandatory. However,
this assumption may not always hold:

 - Some CPUs may advertise FEAT_LSUI but lack FEAT_PAN.
 - Virtualization or ID register overrides may expose invalid feature
   combinations.

Therefore, instead of disabling FEAT_LSUI when FEAT_PAN is absent, wrap
LSUI instructions with uaccess_ttbr0_enable()/disable() when
ARM64_SW_TTBR0_PAN is enabled.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kvm/at.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 6588ea251ed7..1adf88a57328 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -9,6 +9,7 @@
 #include <asm/esr.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/lsui.h>
 
 static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
 {
@@ -1681,6 +1682,35 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
 	}
 }
 
+static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
+{
+	u64 tmp = old;
+	int ret = 0;
+
+	/*
+	 * Wrap LSUI instructions with uaccess_ttbr0_enable()/disable(),
+	 * as PAN toggling is not required.
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
@@ -1756,7 +1786,9 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
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

