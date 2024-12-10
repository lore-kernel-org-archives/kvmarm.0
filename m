Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17D222759B
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810071; cv=none; b=EJ7xRejqKBe9tAXynkZ+6aRsMIvdA9suaec6VyMYF/tDEhDmo/tCANbShMxsZ2WEpWVKR2bL+9Ndxamgltk+DcXr8BO0192HASkfdLVNTs+K/c6NCSrDPgTByIVf0z2gG1RrY9p7MD+ISF+L01MfOqJUucjcDZ3NE5J3lYmiqWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810071; c=relaxed/simple;
	bh=j1ybNRUTMBxdwGJO8XFVrc5i9puGNqFHgg0H+YKyb/w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ECHypJKDIc/FkHosoeIL0GpBaOrDKXZrK+5JPtmyWfGoRbRV/OTAmYtbXFkFVI+5MgjGqyeySmmxRW6ZqBt+Djwn3/WnPw4DP5jCjHo6Sap86R+ehRHWNVOZEy8pL4HG4eNB8gzra4Es347C3byuMdrvbHOwZRavyXD52CPKZ6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DADE113E;
	Mon,  9 Dec 2024 21:54:57 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 563473F58B;
	Mon,  9 Dec 2024 21:54:25 -0800 (PST)
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
Subject: [PATCH V2 14/46] arm64/sysreg: Add register fields for SPMDEVAFF_EL1
Date: Tue, 10 Dec 2024 11:22:39 +0530
Message-Id: <20241210055311.780688-15-anshuman.khandual@arm.com>
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

This adds register fields for SPMDEVAFF_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index fcb4ecd85d35..18b814ff2c41 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -114,6 +114,18 @@ Res0	63:1
 Field	0	OSLK
 EndSysreg
 
+Sysreg	SPMDEVAFF_EL1	2	0	9	13	6
+Res0	63:40
+Field	39:32	Aff3
+Field	31	F0V
+Field	30	U
+Res0	29:25
+Field	24	MT
+Field	23:16	Aff2
+Field	15:8	Aff1
+Field	7:0	Aff0
+EndSysreg
+
 Sysreg ID_PFR0_EL1	3	0	0	1	0
 Res0	63:32
 UnsignedEnum	31:28	RAS
-- 
2.25.1

