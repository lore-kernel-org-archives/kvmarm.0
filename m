Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D5C228C9A
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810089; cv=none; b=JE4GDgw3RWbr9xwjaRyd+utNOGwG0IFDtGsEBOoQrLrrsVQPJqMM0FNttt74aJ3Az1VYGBvEJQSpgNoc4FT4HGBRNyqlHYnMoOlCTz/qKD43FhylME4v12hIwPI129SOe/Q86YqlQ8oeK2N0eBVaSFGzQRhTIhOfILwVcjuYq3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810089; c=relaxed/simple;
	bh=0BHcnjE7VF47kw7PHL2Jk0TCllqkDuGxHwUZIk9mJqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nex6EfzpMRpkSn2udaRlcpxBj5agfwlNn4wbaf58QSMVymoRwgfntxDPDOYkvA2uFYzPh2b8fH7BHX0asa9Oz0Od00TjVlHi0IBDb4KNZcIqMiaXNknUy5K88743GBQoy3TFz904CyKnBFIqK3dpQtBiIaVAkOM13CvktqD7JaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C8D6113E;
	Mon,  9 Dec 2024 21:55:16 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A6A113F58B;
	Mon,  9 Dec 2024 21:54:43 -0800 (PST)
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
Subject: [PATCH V2 18/46] arm64/sysreg: Add register fields for PMUACR_EL1
Date: Tue, 10 Dec 2024 11:22:43 +0530
Message-Id: <20241210055311.780688-19-anshuman.khandual@arm.com>
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

This adds register fields for PMUACR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 214ad6da1dff..462adb8031ca 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2349,6 +2349,43 @@ Res0	63:5
 Field	4:0	SEL
 EndSysreg
 
+Sysreg	PMUACR_EL1	3	0	9	14	4
+Res0	63:33
+Field	32	FM
+Field	31	C
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	PMECR_EL1	3	0	9	14	5
 Res0	63:5
 UnsignedEnum	4:3	SSE
-- 
2.25.1

