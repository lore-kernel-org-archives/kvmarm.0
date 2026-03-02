Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C54E33987
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 08:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772439416; cv=none; b=phBQRahlmzYObXaLAYV4FiH1JWovKXU2XWMN//ZVWhQZ7SzwiyjuPXySfgzspF3UeB4arPqTvUjqmpdYVWVykPLJX+63HrN/+6XU3Ot16uplXs/W+quuJBQiyN7UGX9hrxiZHcYnWrVfTl1UkqDZueBYNAssRDiiv/lkm0sZ89w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772439416; c=relaxed/simple;
	bh=gvBbCBgEcIFqDVI1QeEmkRwEf9oU0LqaFRQl2eyN+VU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fVn5VDOWQAaKSjq8hoXqndlHUXJh5b4T5tK62+5uX7kB1gvOhPPYBDUC4ZRrzRTXcRUTyhm0tfJrpXnyNxGTWOvCFI40cxvEBhJ02NtqGKvsXQrp1PMK/YYFJPuTD3pb2NR3kXTlJy0morFuwMYvMuQbhD01YnwOu3jViPwZKww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4125114BF;
	Mon,  2 Mar 2026 00:16:47 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1C6953F7BD;
	Mon,  2 Mar 2026 00:16:51 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Move inside all remaining TCR_XXX macros
Date: Mon,  2 Mar 2026 08:16:46 +0000
Message-Id: <20260302081646.2866370-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move all remaining TCR_XXX macros inside KVM specific header i.e kvm_arm.h
for their continued usage in KVM, as there are no more stage-1 usage left.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies on v7.0-rc2

https://lore.kernel.org/all/20251013052945.2197190-4-anshuman.khandual@arm.com/

 arch/arm64/include/asm/kvm_arm.h       | 45 ++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h | 45 --------------------------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3f9233b5a130..a7bbf853100e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -107,6 +107,51 @@
 
 #define MPAMHCR_HOST_FLAGS	0
 
+#define TCR_T0SZ_MASK		TCR_EL1_T0SZ_MASK
+#define TCR_T1SZ_MASK		TCR_EL1_T1SZ_MASK
+
+#define TCR_EPD0_MASK		TCR_EL1_EPD0_MASK
+#define TCR_EPD1_MASK		TCR_EL1_EPD1_MASK
+
+#define TCR_IRGN0_MASK		TCR_EL1_IRGN0_MASK
+#define TCR_IRGN0_WBWA		(TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT)
+
+#define TCR_ORGN0_MASK		TCR_EL1_ORGN0_MASK
+#define TCR_ORGN0_WBWA		(TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT)
+
+#define TCR_SH0_MASK		TCR_EL1_SH0_MASK
+#define TCR_SH0_INNER		(TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT)
+
+#define TCR_SH1_MASK		TCR_EL1_SH1_MASK
+
+#define TCR_TG0_SHIFT		TCR_EL1_TG0_SHIFT
+#define TCR_TG0_MASK		TCR_EL1_TG0_MASK
+#define TCR_TG0_4K		(TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT)
+#define TCR_TG0_64K		(TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT)
+#define TCR_TG0_16K		(TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT)
+
+#define TCR_TG1_SHIFT		TCR_EL1_TG1_SHIFT
+#define TCR_TG1_MASK		TCR_EL1_TG1_MASK
+#define TCR_TG1_16K		(TCR_EL1_TG1_16K << TCR_EL1_TG1_SHIFT)
+#define TCR_TG1_4K		(TCR_EL1_TG1_4K << TCR_EL1_TG1_SHIFT)
+#define TCR_TG1_64K		(TCR_EL1_TG1_64K << TCR_EL1_TG1_SHIFT)
+
+#define TCR_IPS_SHIFT		TCR_EL1_IPS_SHIFT
+#define TCR_IPS_MASK		TCR_EL1_IPS_MASK
+#define TCR_A1			TCR_EL1_A1
+#define TCR_ASID16		TCR_EL1_AS
+#define TCR_TBI0		TCR_EL1_TBI0
+#define TCR_TBI1		TCR_EL1_TBI1
+#define TCR_HA			TCR_EL1_HA
+#define TCR_HD			TCR_EL1_HD
+#define TCR_HPD0		TCR_EL1_HPD0
+#define TCR_HPD1		TCR_EL1_HPD1
+#define TCR_TBID0		TCR_EL1_TBID0
+#define TCR_TBID1		TCR_EL1_TBID1
+#define TCR_E0PD0		TCR_EL1_E0PD0
+#define TCR_E0PD1		TCR_EL1_E0PD1
+#define TCR_DS			TCR_EL1_DS
+
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 5e6809a462c7..cd5571afd868 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -229,51 +229,6 @@
 #define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_EL1_T0SZ_SHIFT)
 #define TCR_T1SZ(x)		((UL(64) - (x)) << TCR_EL1_T1SZ_SHIFT)
 
-#define TCR_T0SZ_MASK		TCR_EL1_T0SZ_MASK
-#define TCR_T1SZ_MASK		TCR_EL1_T1SZ_MASK
-
-#define TCR_EPD0_MASK		TCR_EL1_EPD0_MASK
-#define TCR_EPD1_MASK		TCR_EL1_EPD1_MASK
-
-#define TCR_IRGN0_MASK		TCR_EL1_IRGN0_MASK
-#define TCR_IRGN0_WBWA		(TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT)
-
-#define TCR_ORGN0_MASK		TCR_EL1_ORGN0_MASK
-#define TCR_ORGN0_WBWA		(TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT)
-
-#define TCR_SH0_MASK		TCR_EL1_SH0_MASK
-#define TCR_SH0_INNER		(TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT)
-
-#define TCR_SH1_MASK		TCR_EL1_SH1_MASK
-
-#define TCR_TG0_SHIFT		TCR_EL1_TG0_SHIFT
-#define TCR_TG0_MASK		TCR_EL1_TG0_MASK
-#define TCR_TG0_4K		(TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT)
-#define TCR_TG0_64K		(TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT)
-#define TCR_TG0_16K		(TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT)
-
-#define TCR_TG1_SHIFT		TCR_EL1_TG1_SHIFT
-#define TCR_TG1_MASK		TCR_EL1_TG1_MASK
-#define TCR_TG1_16K		(TCR_EL1_TG1_16K << TCR_EL1_TG1_SHIFT)
-#define TCR_TG1_4K		(TCR_EL1_TG1_4K << TCR_EL1_TG1_SHIFT)
-#define TCR_TG1_64K		(TCR_EL1_TG1_64K << TCR_EL1_TG1_SHIFT)
-
-#define TCR_IPS_SHIFT		TCR_EL1_IPS_SHIFT
-#define TCR_IPS_MASK		TCR_EL1_IPS_MASK
-#define TCR_A1			TCR_EL1_A1
-#define TCR_ASID16		TCR_EL1_AS
-#define TCR_TBI0		TCR_EL1_TBI0
-#define TCR_TBI1		TCR_EL1_TBI1
-#define TCR_HA			TCR_EL1_HA
-#define TCR_HD			TCR_EL1_HD
-#define TCR_HPD0		TCR_EL1_HPD0
-#define TCR_HPD1		TCR_EL1_HPD1
-#define TCR_TBID0		TCR_EL1_TBID0
-#define TCR_TBID1		TCR_EL1_TBID1
-#define TCR_E0PD0		TCR_EL1_E0PD0
-#define TCR_E0PD1		TCR_EL1_E0PD1
-#define TCR_DS			TCR_EL1_DS
-
 /*
  * TTBR.
  */
-- 
2.30.2

