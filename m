Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E1626A1C1
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 04:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493100; cv=none; b=kTNwXwalgmel1awR4gTb9ppdtcVD/Sw/q0hjo41QMX9qGpsQ8VadBARgQKu+95BpZJKRD3UlauhpP4R6cTrYqaezjN6vWWOyc+XDzVpNEQkXKSpcTNMhHYTUQxP4K2WeUJR+drUwtVrYMZ3mAx9EuVp61NF+9qB1hd5PBoOy3W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493100; c=relaxed/simple;
	bh=2OwGZeMLcO256otAUuyepHUmQcwRbEUAG21vRccL/C8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kEesQFtINsVla0LZHuJ6NfvVWmnef6XJQc7Nb2TZXmtK+Y1L38luqbyTjCqesxiXjFrn+OSGBygae7Cm/Xwcwj++3Xi61f4HWRRPQ4IK62TGM/hwpXQN/dW9aXeLhb7xsE02El3wnXGrCkPZZUwUa/zPotMdEFY/u5uK99GiXZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECA812A2A;
	Sun, 17 Aug 2025 21:58:04 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4BBC73F58B;
	Sun, 17 Aug 2025 21:58:10 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] arm64/sysreg: Update TCR_EL1 register
Date: Mon, 18 Aug 2025 10:27:56 +0530
Message-Id: <20250818045759.672408-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250818045759.672408-1-anshuman.khandual@arm.com>
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update TCR_EL1 register fields as per latest ARM ARM DDI 0487 7.B and while
here drop an explicit sysreg definition SYS_TCR_EL1 from sysreg.h, which is
now redundant.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  2 --
 arch/arm64/tools/sysreg         | 52 ++++++++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d5b5f2ae1afa..ad5c901af229 100644
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
index 696ab1f32a67..4bdae8bb11dc 100644
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
+UnsignedEnum   31:30   TG1
+	0b01	16K
+	0b10	4K
+	0b11	64K
+EndEnum
+UnsignedEnum   29:28   SH1
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+UnsignedEnum   27:26  ORGN1
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+UnsignedEnum   25:24   IRGN1
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
+UnsignedEnum   15:14   TG0
+	0b00	4K
+	0b01	64K
+	0b10	16K
+EndEnum
+UnsignedEnum   13:12   SH0
+	0b00	NONE
+	0b10	OUTER
+	0b11	INNER
+EndEnum
+UnsignedEnum   11:10  ORGN0
+	0b00	NC
+	0b01	WBWA
+	0b10	WT
+	0b11	WBnWA
+EndEnum
+UnsignedEnum   9:8   IRGN0
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

