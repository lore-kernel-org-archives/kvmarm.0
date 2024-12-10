Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B15C228363
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810049; cv=none; b=fQDzml20cUVEuD11X7AL66xSjobRULwB3c/9MmoQaZpUKj3v7Mvdq6iqZhUssLmZ53hJXtQWtArHqDdLhqj5RqkIg/ME63je8fGQGmdjfFXajbtGpqq80yTqAbtZjGYCS2v9yzViagRKjgaqeTR1d3O3YHsCgLvJ4fdeNohGS0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810049; c=relaxed/simple;
	bh=RDLCQUMVhAh14mOgAunk8JK5tcWOHlOXVPkkMiA9+1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RC2GoBgA0io5/iTJBmF9EwTQRcH2TDVJNZtumif9hQX7EycvhhoaGwy+6j+CKoJH8im6UVfTQ1MR5j5ht0LcxpmaqBs3WarPP4P1kWfFZhMIYxSVRB8MFZn34myFZdmXM/yrFTFhEFBj7JhYbHILFJD5uUUhv8jIU07DDv923uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB3AE113E;
	Mon,  9 Dec 2024 21:54:33 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D08AC3F58B;
	Mon,  9 Dec 2024 21:54:01 -0800 (PST)
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
Subject: [PATCH V2 09/46] arm64/sysreg: Add register fields for HFGWTR2_EL2
Date: Tue, 10 Dec 2024 11:22:34 +0530
Message-Id: <20241210055311.780688-10-anshuman.khandual@arm.com>
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

This adds register fields for HFGWTR2_EL2 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 9513ae05dc93..30a0d3ee71a7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2638,6 +2638,25 @@ Field	1	nERXGSR_EL1
 Field	0	nPFAR_EL1
 EndSysreg
 
+Sysreg	HFGWTR2_EL2	3	4	3	1	3
+Res0	63:15
+Field	14	nACTLRALIAS_EL1
+Field	13	nACTLRMASK_EL1
+Field	12	nTCR2ALIAS_EL1
+Field	11	nTCRALIAS_EL1
+Field	10	nSCTLRALIAS2_EL1
+Field	9	nSCTLRALIAS_EL1
+Field	8	nCPACRALIAS_EL1
+Field	7	nTCR2MASK_EL1
+Field	6	nTCRMASK_EL1
+Field	5	nSCTLR2MASK_EL1
+Field	4	nSCTLRMASK_EL1
+Field	3	nCPACRMASK_EL1
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

