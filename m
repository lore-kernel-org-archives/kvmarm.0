Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98B9F226191
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810024; cv=none; b=FWMgCKfz5V6L5lIGKB4E0I323Xby3C1WBkUMobLVRyhIK38/3rEiGaxz0oWrhGSvNSqjpwRoN1a0tUcDPVEJXM9fG5Y6wSGsB9eo26LdDl1e1eR7+K4BUORMkNsUDNh6UshtB//DlXgZLvuPRln5zacwvNKQVeKppItLzZqoKec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810024; c=relaxed/simple;
	bh=ynHFhYOJaRn+pONLKmb/Lz4gw/YfaE3oLjKeTNMBY90=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dVEgWDrFjAvxUXICz1plgQ3/O0GjFsBA5uwZCN+NyHom8Zo2Wo4z/Mg057zJNQ1mpDE38CkJqVpzvpsoH3/bwyt/GtKYewF9O7yDf4EoE1Fv27uR0foJ1djC7Y7MybS50X3MOd1hgGGTFNL9+wAMCM7XcgUzx7vLrX+9LaZv5Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 400A0113E;
	Mon,  9 Dec 2024 21:54:10 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0C1F93F58B;
	Mon,  9 Dec 2024 21:53:37 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: ryan.roberts@arm.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH V2 04/46] arm64/sysreg: Update register fields for TRBIDR_EL1
Date: Tue, 10 Dec 2024 11:22:29 +0530
Message-Id: <20241210055311.780688-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241210055311.780688-1-anshuman.khandual@arm.com>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for TRBIDR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 59351931d907..10b1a0998d99 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3295,13 +3295,24 @@ Field	31:0	TRG
 EndSysreg
 
 Sysreg	TRBIDR_EL1	3	0	9	11	7
-Res0	63:12
+Res0	63:48
+Field	47:32	MaxBuffSize
+Res0	31:16
+UnsignedEnum	15:12	MPAM
+	0b0000	NI
+	0b0001	PMG
+	0b0010	IMP
+EndEnum
 Enum	11:8	EA
 	0b0000	NON_DESC
 	0b0001	IGNORE
 	0b0010	SERROR
 EndEnum
-Res0	7:6
+UnsignedEnum 7:6	AddrMode
+	0b00	VIRT_PHYS
+	0b01	VIRT_ONLY
+	0b10	PHYS_ONLY
+EndEnum
 Field	5	F
 Field	4	P
 Field	3:0	Align
-- 
2.25.1

