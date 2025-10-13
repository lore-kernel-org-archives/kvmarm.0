Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91BBB2D5935
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 05:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760333410; cv=none; b=HNsMz+ZrFtu0u5NIKlWaE7Oyuk1dBU19XgcggHUOvanV5u3LUiVhdkNwmjCHt75Iq9iaVrKNsgVQM62bof6qONp5NQwMpE2fcx5DFLQjBgIbZ9s0sIHKDc3wSFvrA8MCdpS9HuKKO0j3+T+8aLyPtfVQhgZYc3gtCzgf7Tmlk+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760333410; c=relaxed/simple;
	bh=eXjFawBO75dkBlcbyIJ4YSZyLJyIPS3J1SQ+dz9pvTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s7SWaM/5WamaFg/+gm1z1zaZ6OdRx7JJ2DJHdPfOXjJubbPISsH8rErN4w+auhvfN8z3EgJ1UrbmqrNO1pMxSFjtOBJBiKt/tgglGoUjF09Ctihy9vv0ePobMdFNpoItY12r6PIG02stMt3Wvs4/VSLQNSL0ALC575jL3LbaeZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23B6E1D15;
	Sun, 12 Oct 2025 22:30:00 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A6A193F6A8;
	Sun, 12 Oct 2025 22:30:04 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH V6 3/3] KVM: arm64: Move inside all required TCR_XXX macros
Date: Mon, 13 Oct 2025 10:59:45 +0530
Message-Id: <20251013052945.2197190-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251013052945.2197190-1-anshuman.khandual@arm.com>
References: <20251013052945.2197190-1-anshuman.khandual@arm.com>
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
 arch/arm64/include/asm/kvm_arm.h       | 45 ++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h | 45 --------------------------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..0b2cfb13299b 100644
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
index d49180bb7cb3..5059abda78d8 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -231,51 +231,6 @@
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
2.25.1

