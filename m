Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CCE13C801
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750682; cv=none; b=X43RUwXMn4DwxuSnUzl254pEQIDbk0mpYXQisBpTi6vQI9kl61DUPrcrFpgl7Vqz3sXWymsz6Hz0KER/NF2ZytlU8uT6UKetil72t7hWNxRwar2gxM0SmLYWP86JmCf57WXlsCillgXhQz+eA0zRdN0NL8o0AiZx9P1LMdP5ya0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750682; c=relaxed/simple;
	bh=VfmzQzuyjW7A6Z03KLvTzw4NM+GaIF5JZ8dWr2bc3qw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U5dc6GHpJL3vJpd3pKbhf4bU7ZSdXjP3fcjeXS0qXSDKyMjwY0WxCEWHNsGDmMyiokg3f1xbCE/dM7P011dxHZ9RgjAm6u51ACfUMv5nmfo+CsDHu1i0HDA2hZfjcCgjQWa7MF3ks8Lq8KRqvqH5omAuRTqftMjji+3IGT573Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E295DA7;
	Mon, 30 Sep 2024 19:45:10 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ADF483F58B;
	Mon, 30 Sep 2024 19:44:37 -0700 (PDT)
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
Subject: [PATCH 09/47] arm64/sysreg: Add register fields for HFGWTR2_EL2
Date: Tue,  1 Oct 2024 08:13:18 +0530
Message-Id: <20241001024356.1096072-10-anshuman.khandual@arm.com>
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

This adds register fields for HFGWTR2_EL2 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a790e2cc8003..6a1db83ac44e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2549,6 +2549,13 @@ Field	1	nERXGSR_EL1
 Field	0	nPFAR_EL1
 EndSysreg
 
+Sysreg	HFGWTR2_EL2	3	4	3	1	3
+Res0	63:3
+Field	2	nRCWSMASK_EL1
+Res0	1
+Field	0	nPFAR_EL1
+EndSysreg
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1
-- 
2.25.1

