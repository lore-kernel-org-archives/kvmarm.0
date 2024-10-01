Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFCA6BB39
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750813; cv=none; b=GWRkalfHMLfvJNybSQbgpn9o8nEf3+I1PCkhYfvqEYo5h0i5VX+mJmsV+9AYRBZ+MAQTZh4NtZ8fCojShJnr0aLbqDsvmzg42I+9uBTcgX7sS2c+y2QeNFWvh9QJ9kUw8GY5ym/6CgRh/Tynj8tdtdPMGb8CAU8eozWsExXXbc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750813; c=relaxed/simple;
	bh=+3w73czdioQwj6aiUTB7t0Sm7NVDA77y+7j8AoScM0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LS2oKvAlaY+s6h5GNy85mNwqK1PCvgDA3VOrNq+z2rHj9a2j+xQeSqPhX/dl29mrkQcGFL22wmynifcM/vF7pJ3CzUSV11c2fT8CO6981YjWonNkeASjEVgsZAiXl2U9utX2yUKVx3JlstKZIkJ8zQo8Tjy/wAFdWLrw22f/4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A92EB367;
	Mon, 30 Sep 2024 19:47:21 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C0EB53F58B;
	Mon, 30 Sep 2024 19:46:48 -0700 (PDT)
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
Subject: [PATCH 42/47] arm64/sysreg: Add register fields for ERXGSR_EL1
Date: Tue,  1 Oct 2024 08:13:51 +0530
Message-Id: <20241001024356.1096072-43-anshuman.khandual@arm.com>
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

This adds register fields for ERXGSR_EL1 as per the definitions based on
DDI0601 2024-06.

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
index 815e53200823..b464d02e5fb9 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3641,6 +3641,73 @@ Field	15:8	Attr1
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

