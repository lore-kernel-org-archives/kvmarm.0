Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E555718E038
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 05:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093692; cv=none; b=new9nSmOPt7CUCEy3glL3A/pqiU40kqzEadWzRG5PXxXV8J9tn/havF/sTUWQbs6CCW1+yApxIgauHxdW5M2knTHUWt87OmZTvKH3YzbPjAapvli5VvPqdSGffMUrkCJguiWeTlxYQvAQ1CFXoahwGLBxKlzY7E+dLfWGzDDIMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093692; c=relaxed/simple;
	bh=Yt/L28bmCc/WV3XKOrGcwxe1nKbizUUlTdTGxL6TMsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OsJBSG0+CyVxq+rH4MF43Ltyyzb6TdI4Rv19EohoGFQfrCEAWf/6dEqYgpfpEU4XfvR0SjrrX7f8YC/6JEvcz29ln/dGB94OEN4JSLF4jxcBrTxGPlU3ik16f3ziF09ndWE8QI6dYs9G9Rny8kpvQGdZlYOCPHwDoGYzPL/+tBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE05B13D5;
	Sun, 27 Oct 2024 22:35:19 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AC0FB3F66E;
	Sun, 27 Oct 2024 22:34:46 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH V2 3/7] arm64/sysreg: Add register fields for HDFGRTR2_EL2
Date: Mon, 28 Oct 2024 11:04:22 +0530
Message-Id: <20241028053426.2486633-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241028053426.2486633-1-anshuman.khandual@arm.com>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for HDFGRTR2_EL2 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a92fc241fb4e..1ee850b3e7a7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2476,6 +2476,35 @@ Field	1	ICIALLU
 Field	0	ICIALLUIS
 EndSysreg
 
+Sysreg HDFGRTR2_EL2	3	4	3	1	0
+Res0	63:25
+Field	24	nPMBMAR_EL1
+Field	23	nMDSTEPOP_EL1
+Field	22	nTRBMPAM_EL1
+Res0	21
+Field	20	nTRCITECR_EL1
+Field	19	nPMSDSFR_EL1
+Field	18	nSPMDEVAFF_EL1
+Field	17	nSPMID
+Field	16	nSPMSCR_EL1
+Field	15	nSPMACCESSR_EL1
+Field	14	nSPMCR_EL0
+Field	13	nSPMOVS
+Field	12	nSPMINTEN
+Field	11	nSPMCNTEN
+Field	10	nSPMSELR_EL0
+Field	9	nSPMEVTYPERn_EL0
+Field	8	nSPMEVCNTRn_EL0
+Field	7	nPMSSCR_EL1
+Field	6	nPMSSDATA
+Field	5	nMDSELR_EL1
+Field	4	nPMUACR_EL1
+Field	3	nPMICFILTR_EL0
+Field	2	nPMICNTR_EL0
+Field	1	nPMIAR_EL1
+Field	0	nPMECR_EL1
+EndSysreg
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1
-- 
2.25.1

