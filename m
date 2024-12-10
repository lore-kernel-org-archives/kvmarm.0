Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB51228367
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810135; cv=none; b=UqZu46ffVsdhkd0IDFbr8fVYrn9JnWK7IlMup07/up5FGu0qDTNDpwbleOebHxkhVv/DETT5bSWlMMX4Ds+15WNbuaHs+LvlACoh4hvGZtuu/9Hg6LCpAjpuzM13A/Z03umyD1z4JJaL2wWoEp90awJIxnhepnhysYhM0VLUcYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810135; c=relaxed/simple;
	bh=fdPLXwOC4Qscsjzzd1bFWPe7IIhpnKaQqFHfQsEz0iU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=skhMGHX++kDtFqpr0gcCPN7g9B4JI+hlEWuiT5gVHe64skxiEJEdDvv6GvN+M9ra+mE6p7p4TwdhXQTNdwAWhwBN4adlgRc7t6XntPOrobCxSQb5Ik78bdv/ASSEJSAHhaPWZHvdwFqHsjjfz0+0nR+fw90NaxMByGvxD2Fck3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7788E113E;
	Mon,  9 Dec 2024 21:56:01 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D76293F58B;
	Mon,  9 Dec 2024 21:55:29 -0800 (PST)
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
Subject: [PATCH V2 24/46] arm64/sysreg: Add register fields for SPMCR_EL0
Date: Tue, 10 Dec 2024 11:22:49 +0530
Message-Id: <20241210055311.780688-25-anshuman.khandual@arm.com>
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

This adds register fields for SPMCR_EL0 as per the definitions based
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
index 7db912a81bbd..34323fe73188 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -165,6 +165,19 @@ Sysreg	PMCCNTSVR_EL1	2	0	14	11	7
 Field	63:0	CCNT
 EndSysreg
 
+Sysreg	SPMCR_EL0	2	3	9	12	0
+Res0	63:12
+Field	11	TR0
+Field	10	HDBG
+Field	9	FZ0
+Field	8	NA
+Res0	7:5
+Field	4	EX
+Res0	3:2
+Field	1	P
+Field	0	E
+EndSysreg
+
 Sysreg	SPMSCR_EL1	2	7	9	14	7
 Field	63:32	IMP_DEF
 Field	31	RAO
-- 
2.25.1

