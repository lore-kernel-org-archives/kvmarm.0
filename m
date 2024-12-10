Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B95A22B592
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810210; cv=none; b=Ojcqqvm37TD3d1GzG/MwEArLqzxGJU7exO2+xh0RqTtbWQGRv12w6F/80Qth1ZhquIQMZNCy8HW3P4cGoXjgU9VTopKswx3PekCp8BULrJueR7XLgt9ugFQZHw0vn2Oa0d51dZ33NNzcBtlh3YY0PgHTIksCu/v4W4DuCFTTxMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810210; c=relaxed/simple;
	bh=wkYu2P+rzPLa46JVxDVrYtZNh+5yUIabgO7rUEIIDqY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AXf0BNPYJK7rkp8aHwPgoSLbLgSZcvFBmR4e/wrAY2yHF+Y36yXVtNT8rs8rENdZjTx4dN8q1VeFUsVIJk8IWn3WcpbIzea4GifP5hS0Za1BHFSe9p4Rh2LrsXXycDwtC89UBGtUQdiHW/AS4ZyUUPOCOIwnBz2Fz5xMoaj/EFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5321339;
	Mon,  9 Dec 2024 21:57:16 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4BD173F58B;
	Mon,  9 Dec 2024 21:56:45 -0800 (PST)
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
Subject: [PATCH V2 41/46] arm64/sysreg: Add register fields for ERXGSR_EL1
Date: Tue, 10 Dec 2024 11:23:06 +0530
Message-Id: <20241210055311.780688-42-anshuman.khandual@arm.com>
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

This adds register fields for ERXGSR_EL1 as per the definitions based on
DDI0601 2024-09.

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
index 68dee898743e..2e732ea1dfb1 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3928,6 +3928,73 @@ Field	15:8	Attr1
 Field	7:0	Attr0
 EndSysregFields
 
+Sysreg ERXGSR_EL1	3	0	5	3	2
+Field	63	S63
+Field	62	S62
+Field	61	S61
+Field	60	S60
+Field	59	S59
+Field	58	S58
+Field	57	S57
+Field	56	S56
+Field	55	S55
+Field	54	S54
+Field	53	S53
+Field	52	S52
+Field	51	S51
+Field	50	S50
+Field	49	S49
+Field	48	S48
+Field	47	S47
+Field	46	S46
+Field	45	S45
+Field	44	S44
+Field	43	S43
+Field	42	S42
+Field	41	S41
+Field	40	S40
+Field	39	S39
+Field	38	S38
+Field	37	S37
+Field	36	S36
+Field	35	S35
+Field	34	S34
+Field	33	S33
+Field	32	S32
+Field	31	S31
+Field	30	S30
+Field	29	S29
+Field	28	S28
+Field	27	S27
+Field	26	S26
+Field	25	S25
+Field	24	S24
+Field	23	S23
+Field	22	S22
+Field	21	S21
+Field	20	S20
+Field	19	S19
+Field	18	S18
+Field	17	S17
+Field	16	S16
+Field	15	S15
+Field	14	S14
+Field	13	S13
+Field	12	S12
+Field	11	S11
+Field	10	S10
+Field	9	S9
+Field	8	S8
+Field	7	S7
+Field	6	S6
+Field	5	S5
+Field	4	S4
+Field	3	S3
+Field	2	S2
+Field	1	S1
+Field	0	S0
+EndSysreg
+
 Sysreg	MAIR2_EL1	3	0	10	2	1
 Fields	MAIR2_ELx
 EndSysreg
-- 
2.25.1

