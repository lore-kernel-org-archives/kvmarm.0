Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442441BD9CD
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 04:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734322132; cv=none; b=JuO3Z0fyL7Xq8X85K1zNDAiixid6Spoyu4JjHQcdeZahts4D3VbDSID4dC+V2slbf7np973BInuQPCeL7UV+ouwb3Vmte+Kpz1fgBtWip5ajRO12vA95KkMirCD5bNz3wJOa64LEnSop4VeFeNN8+aRFkOo4TX1y6n/bfD+5DJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734322132; c=relaxed/simple;
	bh=IUJZIYdttaUlv6hbhzryrA4QhshdOKnDcCZXtcCN+J8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PshwB9DB4iJbLm2/Jsw8rJqGV1mXvO4ibtREPGWwFiRsTT+898qGQyEfmCEiYyVtliftDTP1HJb1sR++pR8WJDOFu2L9aZstOi7fntQxJDKrJ2LEGFEJDrtUDQqJc05bkFo7c90wuanAWBp4c0N3mdq9yIkLqPS3g6U88Vmv4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E5741AC1;
	Sun, 15 Dec 2024 20:09:18 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4D71E3F58B;
	Sun, 15 Dec 2024 20:08:46 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH V3 2/7] arm64/sysreg: Add register fields for MDSELR_EL1
Date: Mon, 16 Dec 2024 09:38:26 +0530
Message-Id: <20241216040831.2448257-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241216040831.2448257-1-anshuman.khandual@arm.com>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for MDSELR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a6cbe0dcd63b..fe878eb194a0 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -93,6 +93,17 @@ Res0	63:32
 Field	31:0	DTRTX
 EndSysreg
 
+Sysreg	MDSELR_EL1	2	0	0	4	2
+Res0	63:6
+Enum	5:4	BANK
+	0b00	BANK_0
+	0b01	BANK_1
+	0b10	BANK_2
+	0b11	BANK_3
+EndEnum
+Res0	3:0
+EndSysreg
+
 Sysreg	OSECCR_EL1	2	0	0	6	2
 Res0	63:32
 Field	31:0	EDECCR
-- 
2.25.1

