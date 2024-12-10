Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704A4228363
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810014; cv=none; b=Z0D3GKveeZYH4/vd4v+CvyqvrEUNNvt9NQwZg9btNUSB91N/HTWdv99YBWtDRMsDuxoLOCRObYd97JLGPuhJ64G0eMEJzDJiFpnKUOzZ4BseEJLb/HGs+uMyQ+5lhWuvXSIEb8PZSjXjReAOVmONQCpYecSR+ZEUlwSMjttvPIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810014; c=relaxed/simple;
	bh=78MzFxfAh+jQPiDYCa7bJ4b6F6mZ9hWEu/lCNwjiTco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IPuXhtEES5rejkhU6UKWjahV3xyhbiLAJipu09tM9VvfqCr+JtIB0tQSKlPTbR4bQY8juYnhgh8rRwUjCrTg6VTiXY/7gk9dEAQynrikQXfxSCIpOSg1EOjtK9pw77sRKGzAWbBfRkni1BZvpzw9AdK16gMfvMvCwsbrqjYeVsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDC33113E;
	Mon,  9 Dec 2024 21:54:00 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08E103F58B;
	Mon,  9 Dec 2024 21:53:28 -0800 (PST)
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
Subject: [PATCH V2 02/46] arm64/sysreg: Update register fields for ID_AA64MMFR4_EL1
Date: Tue, 10 Dec 2024 11:22:27 +0530
Message-Id: <20241210055311.780688-3-anshuman.khandual@arm.com>
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

This updates ID_AA64MMFR4_EL1 register as per the definitions based on
DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a6cbe0dcd63b..b5bda7c94689 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1872,12 +1872,21 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
-Res0	63:40
+Res0	63:48
+UnsignedEnum	47:44	SRMASK
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	43:40
 UnsignedEnum	39:36	E3DSE
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-Res0	35:28
+Res0	35:32
+UnsignedEnum	31:28	RMEGDI
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 SignedEnum	27:24	E2H0
 	0b0000	IMP
 	0b1110	NI_NV1
@@ -1886,6 +1895,7 @@ EndEnum
 UnsignedEnum	23:20	NV_frac
 	0b0000	NV_NV2
 	0b0001	NV2_ONLY
+	0b0010	SOFTWARE
 EndEnum
 UnsignedEnum	19:16	FGWTE3
 	0b0000	NI
@@ -1905,7 +1915,10 @@ SignedEnum	7:4	EIESB
 	0b0010	ToELx
 	0b1111	ANY
 EndEnum
-Res0	3:0
+UnsignedEnum	3:0	PoPS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 EndSysreg
 
 Sysreg	SCTLR_EL1	3	0	1	0	0
-- 
2.25.1

