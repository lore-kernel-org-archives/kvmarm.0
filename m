Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F074B1A38E9
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750798; cv=none; b=OiF/RReE3oBiNJol7ub/MZwaiYIczbIV4E+ljmYm5EPUdBqgg/Lem4TURbGvnYZ5w54iGa982xchZlsu0AUFK05i7ICnt5aR7jaKan11zK46oOkS+Ur8tBny2MRuPcYA4634I5UhzzMX5iVmqtBa8V9A/ebZ3PEJMTwfPlJQRD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750798; c=relaxed/simple;
	bh=MsnaYWW7jfLrjyZAXfBIbCKlZUwms0GEnswCChULUyc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sq0J4/RjicWR304xanHejggRzdZiYvsPMaIVFY3WisbZqtFfrjKqM2pF5oVjvXhL7/a1kcnBWEgdh6oRB1hhKKW5Gdo9G+8Qy92etrQkKH0DQR2HatjxbT2EDC1F/ZIZBPgf2Z54oXpg280Xul22UDjyMyjQi1xszca4ghJ7x/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7D24367;
	Mon, 30 Sep 2024 19:47:05 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D68C13F58B;
	Mon, 30 Sep 2024 19:46:32 -0700 (PDT)
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
Subject: [PATCH 38/47] arm64/sysreg: Add register fields for PMZR_EL0
Date: Tue,  1 Oct 2024 08:13:47 +0530
Message-Id: <20241001024356.1096072-39-anshuman.khandual@arm.com>
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

This adds register fields for PMZR_EL0 as per the definitions based
on DDI0601 2024-06.

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
index 0043268765d5..020fda4fbd9b 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2988,6 +2988,43 @@ Res0	19:16
 Field	15:0	evtCount
 EndSysreg
 
+Sysreg	PMZR_EL0	3	3	9	13	4
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
 SysregFields	HFGxTR_EL2
 Field	63	nAMAIR2_EL1
 Field	62	nMAIR2_EL1
-- 
2.25.1

