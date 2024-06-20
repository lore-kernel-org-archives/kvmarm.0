Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795724AEF7
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 06:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718866714; cv=none; b=eql2GbNVWJfWNAbUnhX973E8WC5C+dSGP+Zwkdxfdj8S6vImhPitSCNskdutKfkn5wPfOHq/IevdMS1W/tUWeFmXZhe+pHeuZQzIRsLQGycW/KMSJL5PCswQRuiM3+U+PqlbyVUtXWoX3etGFb3Oj5e4/F0cxX5BT9rsjcncPaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718866714; c=relaxed/simple;
	bh=Mnxp7ulmZhX7evHvfvvrVYDQQD3VnbjXhZM63/SYV50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VvO3u05buyL1gP4YSpqSPinPdWqpY9yiYZWxj/NiFn/7AGR/4WqCebp6y9bDSyYXIMyKdmcQmDfjI7eUFBKCkshKdHGSgCI9EsIYieZ/2jEO2EaDyOd4Su3PUd8Yvr/ncl2L0p1TRKE/YME4iMVYGT5Hhbi5kvzocDnfCKyl6D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0AE71042;
	Wed, 19 Jun 2024 23:58:57 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.46.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 185A23F73B;
	Wed, 19 Jun 2024 23:58:28 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 03/10] arm64/sysreg: Add register fields for ID_AA64DFR2_EL1
Date: Thu, 20 Jun 2024 12:28:00 +0530
Message-Id: <20240620065807.151540-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240620065807.151540-1-anshuman.khandual@arm.com>
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for ID_AA64DFR2_EL1 as per the definitions based
on DDI0601 2024-03.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 4b44ea5dce7e..df9111d11bc0 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1294,6 +1294,19 @@ Field	15:8	BRPs
 Field	7:0	SYSPMUID
 EndSysreg
 
+Sysreg	ID_AA64DFR2_EL1	3	0	0	5	2
+Res0	63:8
+UnsignedEnum	7:4	BWE
+	0b0000	NI
+	0b0001	IMP
+	0b0010	IMP_WPT
+EndEnum
+UnsignedEnum	3:0	STEP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
 Sysreg	ID_AA64AFR0_EL1	3	0	0	5	4
 Res0	63:32
 Field	31:28	IMPDEF7
-- 
2.25.1

