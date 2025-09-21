Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445BD25771
	for <kvmarm@lists.linux.dev>; Sun, 21 Sep 2025 00:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758416001; cv=none; b=uXtE3vVOuOdOBRSnciGTicjYnr2z+NDXlY3nFFL0fLYavddzSXpR7f5+jXqKkhSZu/5Yy6uXFN9+wiV4pccU26k8y+yU4gxxDnT/WZmPrg/h1begbDPVC6P4c3nv7YAzmMhJJzd6jClLIQyraqOZ7hdfANmCJgqvrOmoWQ/gr2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758416001; c=relaxed/simple;
	bh=+fEggw264szyXeh0G4ZSmG3kkdNutuVlCIOwPZJpKmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cpp+Xj0mhqsirVv7qQc2CENE3Rszw+TFsjOICTmB0Sxu2NiLg8lFGtZhhskZDqUNxTewp0isdSVAI+b/hytwRF2Jwiyq9cq+dIsjrLMRqM/1Gqf2T2iokwmuzBtKo6+r5sxd+p0cRx/4ni/N9WVOK4SuakF4EkAsSGb2xOSYUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8775F22F8;
	Sat, 20 Sep 2025 17:53:10 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6037C3F66E;
	Sat, 20 Sep 2025 17:53:15 -0700 (PDT)
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
Subject: [PATCH V5 2/4] arm64/sysreg: Update TCR_EL1 register
Date: Sun, 21 Sep 2025 06:22:58 +0530
Message-Id: <20250921005300.2535994-3-anshuman.khandual@arm.com>
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

Update TCR_EL1 register fields as per latest ARM ARM DDI 0487 L.B and while
here drop an explicit sysreg definition SYS_TCR_EL1 from sysreg.h, which is
now redundant.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
The updated TCR_EL1 fields also matches with latest released TCR_EL1 layout.

https://developer.arm.com/documentation/ddi0601/2025-06/AArch64-Registers/TCR-EL1--Translation-Control-Register--EL1-?lang=en

 arch/arm64/include/asm/sysreg.h |  2 --
 arch/arm64/tools/sysreg         | 52 ++++++++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6604fd6f33f4..71febc944adb 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -281,8 +281,6 @@
 #define SYS_RGSR_EL1			sys_reg(3, 0, 1, 0, 5)
 #define SYS_GCR_EL1			sys_reg(3, 0, 1, 0, 6)
 
-#define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
-
 #define SYS_APIAKEYLO_EL1		sys_reg(3, 0, 2, 1, 0)
 #define SYS_APIAKEYHI_EL1		sys_reg(3, 0, 2, 1, 1)
 #define SYS_APIBKEYLO_EL1		sys_reg(3, 0, 2, 1, 2)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a67..85da09795527 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4756,17 +4756,53 @@ Field   37      TBI0
 Field   36      AS
 Res0    35
 Field   34:32   IPS
-Field   31:30   TG1
-Field   29:28   SH1
-Field   27:26   ORGN1
-Field   25:24   IRGN1
+Enum	31:30   TG1
+	0b01	16K
+	0b10	4K
+	0b11	64K
+EndEnum
+Enum	29:28   SH1
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+Enum	27:26  ORGN1
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Enum	25:24   IRGN1
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
 Field   23      EPD1
 Field   22      A1
 Field   21:16   T1SZ
-Field   15:14   TG0
-Field   13:12   SH0
-Field   11:10   ORGN0
-Field   9:8     IRGN0
+Enum	15:14   TG0
+	0b00	4K
+	0b01	64K
+	0b10	16K
+EndEnum
+Enum	13:12   SH0
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+Enum	11:10  ORGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+Enum	9:8   IRGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
 Field   7       EPD0
 Res0    6
 Field   5:0     T0SZ
-- 
2.25.1

