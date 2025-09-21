Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71AAE70814
	for <kvmarm@lists.linux.dev>; Sun, 21 Sep 2025 00:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758416009; cv=none; b=ZDIJZZFPuzEeeAcpO+eIlLnsBlxTfb94fRbv08VZIAbgZdpQ7VLufHw2g6gVvFFxoJ1Bwk490vV1aXgRVnaTsIttatToZ//ACFHTZ+KZ7iCsghtyPB9Y9C6EPfgPlijgFaeu4weOHen9Cmor0DSbjRISlWpLbWHaHm/iQfteJSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758416009; c=relaxed/simple;
	bh=oJy8z/5rza5xy9tQynvogFzeIX7QDc9jffbVOSf09QU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TSRIuGKFBI0HyUuVwc79cxUttZTeQzHtgkmNlU5iN+O7IK8M2HYVSGIoyQhuqnIbvZw8jRb2bIB0xT2hF4/qiQmfG10DBVO0Nzru0EIMPFLjtw0KGGXv6rP/zFkzHsaSEikg1lgYCoOzkcA5Lsxp2xtlGgf2WRbUo6sstDtn694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACD0C1655;
	Sat, 20 Sep 2025 17:53:18 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8726A3F66E;
	Sat, 20 Sep 2025 17:53:23 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH V5 4/4] KVM: arm64: Move inside all required TCR_XXX macros
Date: Sun, 21 Sep 2025 06:23:00 +0530
Message-Id: <20250921005300.2535994-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250921005300.2535994-1-anshuman.khandual@arm.com>
References: <20250921005300.2535994-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move all required TCR_XXX macros into KVM header (asm/kvm_arm.h) for their
continued usage in KVM.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h       | 43 ++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h | 43 --------------------------
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..236e828c69cc 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -107,6 +107,49 @@
 
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
index 2c0ba17ed1a3..5059abda78d8 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -231,49 +231,6 @@
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
2.25.1

