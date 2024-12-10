Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3B622839B
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810157; cv=none; b=SLOinNKPSBCszJasf5jQfmQpHG6fP9dFKR3ub0A4vEpYv3aDy5e9fLMY4l7cUKphfS/NOxufnIkwKt0oXZP0wna8neqqqcx2H+p6vsukJyEc88qeDmoXqkwVeTpKw8WlnBR9WMFBUZq+zdUUFZH4GuDVqsXofoiOi5K8RXkfQLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810157; c=relaxed/simple;
	bh=Jp8BQRF9YBKuaWKeYPiq4B4xBdhrI+r4KnyrIJ+CHkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TURUiszYFqcU/MhPwty0YuevypIz7oYPD5K80Ldoxq8mRh/jB8xACxrYG9nOFOjCHr5cMaPFLAV3ttLj0+cJgII/eaUzRQpghdgvR1drhfnm0MRIXbkAzYtdzVo2O44vd4svA4R4Xj5J25tfTtQWJyWYENe5cajHfoBS9J8XF4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E3D2113E;
	Mon,  9 Dec 2024 21:56:23 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D028F3F77D;
	Mon,  9 Dec 2024 21:55:51 -0800 (PST)
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
Subject: [PATCH V2 29/46] arm64/sysreg: Add register fields for SPMCNTENCLR_EL0
Date: Tue, 10 Dec 2024 11:22:54 +0530
Message-Id: <20241210055311.780688-30-anshuman.khandual@arm.com>
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

This adds register fields for SPMCNTENCLR_EL0 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 67 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 82fe720472cc..9f278055fe77 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -312,6 +312,73 @@ Field	1	P
 Field	0	E
 EndSysreg
 
+Sysreg	SPMCNTENCLR_EL0	2	3	9	12	2
+Field	63	P63
+Field	62	P62
+Field	61	P61
+Field	60	P60
+Field	59	P59
+Field	58	P58
+Field	57	P57
+Field	56	P56
+Field	55	P55
+Field	54	P54
+Field	53	P53
+Field	52	P52
+Field	51	P51
+Field	50	P50
+Field	49	P49
+Field	48	P48
+Field	47	P47
+Field	46	P46
+Field	45	P45
+Field	44	P44
+Field	43	P43
+Field	42	P42
+Field	41	P41
+Field	40	P40
+Field	39	P39
+Field	38	P38
+Field	37	P37
+Field	36	P36
+Field	35	P35
+Field	34	P34
+Field	33	P33
+Field	32	P32
+Field	31	P31
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
 Sysreg	SPMOVSCLR_EL0	2	3	9	12	3
 Field	63	P63
 Field	62	P62
-- 
2.25.1

