Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AAF763E4
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 10:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707389681; cv=none; b=c1uXibQbHhd6LR6F+UQuUE3dW4yop9P3+bKbrvxb0TdbA6VE1S4intZJNBXJcx/eJfQleMNUKrt+kabI6HN3I49k7cGvv2NiTNCwORogSluK2xGHo70O3HZdKGMQ+ScHiTdR9HSq+7QxBaCWkTP8m/O/h6y2I30imvv7VKVu59I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707389681; c=relaxed/simple;
	bh=+ocXPP4VxOO5l2aBxDasVoGzHcV0py5uAeVSIEZmfdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HApUy/QA1N82ksrBXUWtrnPry6KA7jBU28LUPt8VrBQT8E1aJGU/G+6q2V7U1LYEktGINTW4t0+Hz2xYs7vV/VkmZdNfhd4zVXLOCx1pPBrCn4VHFWX/FEGirRYSCoE3tCFJllvk4oKHWwH5UZ0VqwGxsW339J+5lR3inECUDEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F25BDA7;
	Thu,  8 Feb 2024 02:55:20 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95B113F762;
	Thu,  8 Feb 2024 02:54:36 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v1 1/2] KVM: arm64: add comments to __kern_hyp_va
Date: Thu,  8 Feb 2024 10:54:21 +0000
Message-Id: <20240208105422.3444159-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240208105422.3444159-1-joey.gouly@arm.com>
References: <20240208105422.3444159-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document this function a little, to make it easier to understand.

The assembly comments were copied from the kern_hyp_va asm macro.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_mmu.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e3e793d0ec30..d248a7ae627a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -127,14 +127,24 @@ void kvm_apply_hyp_relocations(void);
 
 #define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
 
+/*
+ * Convert a kernel VA into a HYP VA.
+ *
+ * Can be called from hyp or non-hyp context.
+ */
 static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 {
+/*
+ * This #ifndef is an optimisation for when this is called from VHE hyp
+ * context.  When called from a VHE non-hyp context, kvm_update_va_mask() will
+ * replace the instructions with `nop`s.
+ */
 #ifndef __KVM_VHE_HYPERVISOR__
-	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"
-				    "ror %0, %0, #1\n"
-				    "add %0, %0, #0\n"
-				    "add %0, %0, #0, lsl 12\n"
-				    "ror %0, %0, #63\n",
+	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_mask */
+				    "ror %0, %0, #1\n"         /* rotate to the first tag bit */
+				    "add %0, %0, #0\n"         /* insert the low 12 bits of the tag */
+				    "add %0, %0, #0, lsl 12\n" /* insert the top 12 bits of the tag */
+				    "ror %0, %0, #63\n",       /* rotate back */
 				    ARM64_ALWAYS_SYSTEM,
 				    kvm_update_va_mask)
 		     : "+r" (v));
-- 
2.25.1

