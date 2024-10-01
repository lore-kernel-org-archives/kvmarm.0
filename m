Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42257188A05
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750718; cv=none; b=TG7X23KbXtbRywEnlT8/fBk9N/CvEphO/VRv1Dj6eiPUGApw8VuJf4wRpA7CwrIplJR3fAUuN2pVaiEfb2yLDrCyA12RHk1/YGx0y1C9K71I4WcMZkCUr0FfGlGGsl46ykQURaDtFmKgWQ6EAn1XgAlk5tpQ57/UrpEdUao5lOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750718; c=relaxed/simple;
	bh=lO0hxxeHm+toHm9ZcCaYAjpqeAynTqAjw4d2muiuxlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fYhiMfqe55Qe/Gr1HcYdwPf174aRB+G04YnKPzwicNhghLKI3QHRMq7vTwGxnZ/2dkO91AtKTdZrzv77/3O15wdSoHDjfE7ait42v7hlDLPYx8JJ6Nt7LeSWVTj0ManSrWTD1gsdJhuq/yyDChoOdhEDvPwfkxXM/5c4tIqdD8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DBA8367;
	Mon, 30 Sep 2024 19:45:46 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C96E3F58B;
	Mon, 30 Sep 2024 19:45:13 -0700 (PDT)
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
Subject: [PATCH 18/47] arm64/sysreg: Add register fields for PMECR_EL1
Date: Tue,  1 Oct 2024 08:13:27 +0530
Message-Id: <20241001024356.1096072-19-anshuman.khandual@arm.com>
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

This adds register fields for PMECR_EL1 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b237813f6606..7e16e436eb58 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2246,6 +2246,21 @@ Res0	63:5
 Field	4:0	SEL
 EndSysreg
 
+Sysreg	PMECR_EL1	3	0	9	14	5
+Res0	63:5
+UnsignedEnum	4:3	SSE
+	0b00	DISABLED
+	0b10	ENABLED_PROHIBITED
+	0b11	ENABLED_ALLOWED
+EndEnum
+Field	2	KPME
+UnsignedEnum	1:0	PMEE
+	0b00	PMUIRQ_E_PMU_D
+	0b10	PMUIRQ_D_PMU_D
+	0b11	PMUIRQ_D_PMU_E
+EndEnum
+EndSysreg
+
 Sysreg	PMIAR_EL1	3	0	9	14	7
 Field	63:0 ADDRESS
 EndSysreg
-- 
2.25.1

