Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A496022617B
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810062; cv=none; b=CO8gdHCzb6axRjeVxONwhxXQI2qltMUNp+IrH8+BKIV9DvAzJvkMtxORdPQw2Sf8ZTRsQ8O2HOsDjxA/dIxkwu5AXVi8aZ91jlFfb5ppw9aWBSixJAqrwVOEDOo6iIaeCDFJtIF3NST8+HIpp21SzP+Hvd64j4qGwNUpNaBHXag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810062; c=relaxed/simple;
	bh=1RlLYctFbW5Kwc1/mtCPA1pFyYkzRM/kpPE2QU96Saw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p5Zptn0XrPqybdPkmUM64/5iiXz1hPgk4yyW+nyeh4/Oqt+mRiJm/grFkStokG92ZcyJ9O9+qIIOSjVm3DHQw2JcCNRV6k/DaK/F+EKgxSLXto6Qt62AxerRTMX1UDxuPq47Icn8bBMxFurzFv9ql0ahSzEsvSvsDuR/MHQeivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50C4D113E;
	Mon,  9 Dec 2024 21:54:48 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EB6373F58B;
	Mon,  9 Dec 2024 21:54:15 -0800 (PST)
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
Subject: [PATCH V2 12/46] arm64/sysreg: Add register fields for TRBMPAM_EL1
Date: Tue, 10 Dec 2024 11:22:37 +0530
Message-Id: <20241210055311.780688-13-anshuman.khandual@arm.com>
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

This adds register fields for TRBMPAM_EL1 as per the definitions based
on DDI0601 2024-09.

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
index a5e31e4c4474..78564b24b187 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3413,6 +3413,19 @@ EndEnum
 Field	7:0	Attr
 EndSysreg
 
+Sysreg	TRBMPAM_EL1	3	0	9	11	5
+Res0	63:27
+Field 	26	EN
+UnsignedEnum	25:24	MPAM_SP
+	0b00	SECURE_PARTID
+	0b01	NON_SECURE_PARTID
+	0b10	ROOT_PARTID
+	0b11	REALM_PARTID
+EndEnum
+Field	23:16	PMG
+Field	15:0	PARTID
+EndSysreg
+
 Sysreg	TRBTRG_EL1	3	0	9	11	6
 Res0	63:32
 Field	31:0	TRG
-- 
2.25.1

