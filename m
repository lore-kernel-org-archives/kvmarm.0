Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E915764CEC
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750668; cv=none; b=OubLzZFyVAvxokFDIE/XDjibFx/ooVgo87t459f7e5A/mpBJQHuWcHP8RwkpoUI4O0HmdLGCv/CfT8kX2IhQqCSVfVswvbnrgMsF5Gnu7txZeuOdjyxa72GIKQnPvzk0PqGW7pdirtKvXuFoQuFB13VfmAZSvc8KNQdZFrKCH08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750668; c=relaxed/simple;
	bh=ThyN2vIj83BOmPVXc8/s3ei33drmki21fWAy4QzYBvE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g3iZ4efhGpAN41wHYzsdHsGqmGlhEzeg+4z8lNaO9sINCJ6oIn/SFxakVV3D/gwIX7ZdETebzBjJnU7/+7a6J9r4nvSVLXF8tgFtiKxT1EAQlHddQ9QAzY+FszmLprjN8CgAAOvUfCCcp8uv9igEjp9GX3zyTr2QyP8zgbxcF/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB7D01424;
	Mon, 30 Sep 2024 19:44:54 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D30203F58B;
	Mon, 30 Sep 2024 19:44:21 -0700 (PDT)
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
Subject: [PATCH 05/47] arm64/sysreg: Add register fields for HDFGRTR2_EL2
Date: Tue,  1 Oct 2024 08:13:14 +0530
Message-Id: <20241001024356.1096072-6-anshuman.khandual@arm.com>
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

This adds register fields for HDFGRTR2_EL2 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dbaa58be2e52..87f04c56dea2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2487,6 +2487,34 @@ Field	1	ICIALLU
 Field	0	ICIALLUIS
 EndSysreg
 
+Sysreg HDFGRTR2_EL2	3	4	3	1	0
+Res0	63:24
+Field	23 nMDSTEPOP_EL1
+Field	22 nTRBMPAM_EL1
+Res0	21
+Field	20 nTRCITECR_EL1
+Field	19 nPMSDSFR_EL1
+Field	18 nSPMDEVAFF_EL1
+Field	17 nSPMID
+Field	16 nSPMSCR_EL1
+Field	15 nSPMACCESSR_EL1
+Field	14 nSPMCR_EL0
+Field	13 nSPMOVS
+Field	12 nSPMINTEN
+Field	11 nSPMCNTEN
+Field	10 nSPMSELR_EL0
+Field	9 nSPMEVTYPERn_EL0
+Field	8 nSPMEVCNTRn_EL0
+Field	7 nPMSSCR_EL1
+Field	6 nPMSSDATA
+Field	5 nMDSELR_EL1
+Field	4 nPMUACR_EL1
+Field	3 nPMICFILTR_EL0
+Field	2 nPMICNTR_EL0
+Field	1 nPMIAR_EL1
+Field	0 nPMECR_EL1
+EndSysreg
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1
-- 
2.25.1

