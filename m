Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9664B22758E
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810115; cv=none; b=gGLRgugOIK5AJNzpQ6f+mTUft+mWVqhNUxNZbRiUgEAkmxxIf4dynZLmfBRwYJ2Q9dMc/RqBc8x6J167ZJxBDIWIufny2Ua1G26vV6NNq1wIz4Nc7cJ8Y9Jb7ToFEyo8ip5wJ8IFuw4yrllH8iH4gPMbHz1KTj/qbGho+MtktXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810115; c=relaxed/simple;
	bh=xDvYe+54EMF2B2Y2JXi299olf8ukZjk3XFWVyAaTHQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nRfEijJLURCMQHacrWmwF/BDJdLS2jtaDeWHPd3bySJ3pmJ/b4xg1Vs5gtVJAkXPsScyHpLaS1FBJWi1ZGZeipSrqTOCSBej8YUO9kocYR7FRdLJWuzR1g7G+rqqRbPZgoaeKYYoZTHvp7ENOMisYm/Ot6U1T/K3SNVg1+36MyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24B63113E;
	Mon,  9 Dec 2024 21:55:42 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AA6903F58B;
	Mon,  9 Dec 2024 21:55:02 -0800 (PST)
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
Subject: [PATCH V2 20/46] arm64/sysreg: Add register fields for SPMSCR_EL1
Date: Tue, 10 Dec 2024 11:22:45 +0530
Message-Id: <20241210055311.780688-21-anshuman.khandual@arm.com>
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

This adds register fields for SPMSCR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 00d0015d7df4..22d2ba231059 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -130,6 +130,15 @@ Sysreg	PMCCNTSVR_EL1	2	0	14	11	7
 Field	63:0	CCNT
 EndSysreg
 
+Sysreg	SPMSCR_EL1	2	7	9	14	7
+Field	63:32	IMP_DEF
+Field	31	RAO
+Res0	30:5
+Field	4	NAO
+Res0	3:1
+Field	0	SO
+EndSysreg
+
 Sysreg ID_PFR0_EL1	3	0	0	1	0
 Res0	63:32
 UnsignedEnum	31:28	RAS
-- 
2.25.1

