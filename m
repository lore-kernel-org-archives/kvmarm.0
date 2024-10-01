Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC4657CBA
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750690; cv=none; b=jjgaTToIOU2xwmhtxfJAtViJCOmCOUVXI+gRFDjshB4MRT7MppCqaWg25CLT0AM7XUkSSVmPo7w303zvFzbdUsv5ER2Z/8Tml4rcOneawGRm7llcUpoKrXjgAblzEzfSwTzH1MYC3+zwAlPZJ/h7ro4cuOcPPu3TvGGt83cZwI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750690; c=relaxed/simple;
	bh=oQj98SQqbWjtBlbdRFDsOzuafqgXr/rZSTtlZabcbtY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KjbkY/4giLIzRSEVYnsf684etwGkNOAnHY89xjYlU+WBN/eRuR4JRZ4pS5IgWiY0BsnB8uNzeryWulxEY4EsNno8wS7Bv2FgMcx6SpqNag/0YtslPNFk884zoG6mQzdlrdQROwZBUJQJoHrKjM4AnRl6FAvjWa3rvE9FEEcbnqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91ADD367;
	Mon, 30 Sep 2024 19:45:18 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A029A3F58B;
	Mon, 30 Sep 2024 19:44:45 -0700 (PDT)
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
Subject: [PATCH 11/47] arm64/sysreg: Add register fields for PMSIDR_EL1
Date: Tue,  1 Oct 2024 08:13:20 +0530
Message-Id: <20241001024356.1096072-12-anshuman.khandual@arm.com>
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

This adds register fields for PMSIDR_EL1 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b1ee29783628..eb2935df13f2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2139,7 +2139,16 @@ Field	15:0	MINLAT
 EndSysreg
 
 Sysreg	PMSIDR_EL1	3	0	9	9	7
-Res0	63:25
+Res0	63:33
+Field	32	SME
+UnsignedEnum	31:28	ALTCLK
+	0b0000	NI
+	0b0001	IMP
+	0b1111	IMP_DEF
+EndEnum
+Field	27	FPF
+Field	26	EFT
+Field	25	CRR
 Field	24	PBT
 Field	23:20	FORMAT
 Enum	19:16	COUNTSIZE
@@ -2157,7 +2166,10 @@ Enum	11:8	INTERVAL
 	0b0111	3072
 	0b1000	4096
 EndEnum
-Res0	7
+UnsignedEnum	7	FDS
+	0b0	NI
+	0b1	IMP
+EndEnum
 Field	6	FnE
 Field	5	ERND
 Field	4	LDS
-- 
2.25.1

