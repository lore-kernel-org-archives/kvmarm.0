Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B699957323
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750774; cv=none; b=IoLqpwCzKicBDSqNsQ1OB5SEkewoGMUT5N8968PVF5bfhzZeU7oXd1dLwCeJZAO5lroy7gOuvq/Jyh3xwrGYXv2MsufLyfzKTBbjXoaiTGEzMDOKbvjaBOuWvxpTWiC6/k+QDrUyseCDUejOronWdwEt7ZvLRpUsiwYG8BCju/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750774; c=relaxed/simple;
	bh=OQyUWh4SFtdVNSomaxklDoFNEqsv6XPrHY/p9Twk2x4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hwyI2AzCKsOWrndLfsUD65465lWI53x1gZq8XOGfOVruRc+YihzWjzezfi45jjRsETp/dV8jOCP5pt6IdgJIu3k5WPr39IsAIkeF6PoUxlRz2qC0c63M/yZIHqgAG1y26bqvdRHwds6ROVwqZQHy1RXl59HB5Krg9Fvb+H/hLeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2F70367;
	Mon, 30 Sep 2024 19:46:41 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F1B8F3F58B;
	Mon, 30 Sep 2024 19:46:08 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 32/47] arm64/sysreg: Add register fields for SPMSELR_EL0
Date: Tue,  1 Oct 2024 08:13:41 +0530
Message-Id: <20241001024356.1096072-33-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241001024356.1096072-1-anshuman.khandual@arm.com>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for SPMSELR_EL0 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7369a044c649..7144a65aed5e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -513,6 +513,18 @@ Field	1	P1
 Field	0	P0
 EndSysreg
 
+Sysreg	SPMSELR_EL0	2	3	9	12	5
+Res0	63:10
+Field	9:4	SYSPMUSEL
+Res0	3:2
+UnsignedEnum	1:0	BANK
+	0b00	BANK_0
+	0b01	BANK_1
+	0b10	BANK_2
+	0b11	BANK_3
+EndEnum
+EndSysreg
+
 Sysreg	SPMOVSSET_EL0	2	3	9	14	3
 Field	63	P63
 Field	62	P62
-- 
2.25.1

