Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9248339AB
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750762; cv=none; b=J35yNXsyIMSvVCx85yNvWB6PSYq5ReqRjlIcFWW7Krg/xEXZLArljotcrnP+LNkF4xusHufwmZ0f/eWLxO+1ozPYvlFe9y0EclyV94uBzw4N8JaMqbDwctcjzhHGc0V9gON+2oydaA4qYmF+cxZiYUfgddnoqcQqVrWVjUD6U+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750762; c=relaxed/simple;
	bh=vvHL7uNHZdTtxc5jbDqAKCnw4MdrQdYoxbelcglDZZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qWQ4K2IfXu+Y7FFZ5eY//U6WrlE3bjssPZByslp6pP3lFhhTO5WhoI2SStI0rlTGPkUYLuESmQ//IV3I5uIRVWAyGeYL4GQXiQi6jZ10JPXELvtz/8xWFwqBCbkUJWWNyQLZQXCMCdlBNCYZMRcWQNR9NKzNn8XuW79T6O6Yeek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CC94DA7;
	Mon, 30 Sep 2024 19:46:30 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 242283F58B;
	Mon, 30 Sep 2024 19:45:56 -0700 (PDT)
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
Subject: [PATCH 29/47] arm64/sysreg: Add register fields for SPMINTENSET_EL1
Date: Tue,  1 Oct 2024 08:13:38 +0530
Message-Id: <20241001024356.1096072-30-anshuman.khandual@arm.com>
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

This adds register fields for SPMINTENSET_EL1 as per the definitions based
on DDI0601 2024-06.

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
index 6c2696640083..e25418b95b96 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -161,6 +161,73 @@ Field	15:8	Aff1
 Field	7:0	Aff0
 EndSysreg
 
+Sysreg	SPMINTENSET_EL1	2	0	9	14	1
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
 Sysreg	SPMINTENCLR_EL1	2	0	9	14	2
 Field	63	P63
 Field	62	P62
-- 
2.25.1

