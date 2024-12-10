Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3FC228390
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810187; cv=none; b=TIGgNMaXgsD3kDAhm0H9Nw2b4WMMDZV/CMoYeM2oywRB7WhIEkJpoJ9X1uRFqQQex+017OIs8fifCRrF1bppirLDJBacmGtgiwB5m3FClNkF5CXq+S9jkMGzgpPen5RdUvb7shix2YC7AVIyc8PQx0Aamr/hvNX/3bBGZbEEGgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810187; c=relaxed/simple;
	bh=ZAHAQ9t0ZGyTq43bWFjvLalyvzkcA5AXsZw3M2eXa/w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZXok1Mi6MporBXM0XlxJc/9TsviIhIpJ2DEjoYGRSApkSWRC8SuSF5YVlH8ItWRUFWiJdwPRMwZ4ZOrpyk25lvP76JOGZ4sAqU2lSI826KHKzZAQ0n4MGAYBjLZL7BCz2dFlEfkllwQCGPf1Q6HmjavlsVTprxjrxhMRanir4Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47317113E;
	Mon,  9 Dec 2024 21:56:54 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 887D73F58B;
	Mon,  9 Dec 2024 21:56:22 -0800 (PST)
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
Subject: [PATCH V2 36/46] arm64/sysreg: Add register fields for PMSSCR_EL1
Date: Tue, 10 Dec 2024 11:23:01 +0530
Message-Id: <20241210055311.780688-37-anshuman.khandual@arm.com>
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

This adds register fields for PMSSCR_EL1 as per the definitions based
on DDI0601 2024-09.

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
index f4f5d22948ad..c87017e69be1 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2863,6 +2863,13 @@ Res0	63:5
 Field	4:0	SEL
 EndSysreg
 
+Sysreg	PMSSCR_EL1	3	0	9	13	3
+Res0	63:33
+Field	32	NC
+Res0	31:1
+Field	0	SS
+EndSysreg
+
 Sysreg	PMUACR_EL1	3	0	9	14	4
 Res0	63:33
 Field	32	FM
-- 
2.25.1

