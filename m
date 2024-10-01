Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41B7433A2
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750663; cv=none; b=Uk4YwbeEgKdvXAIvvwFvH/jPjnUy+EI3Mfm+U0TvDMUD8/kD+ntQrNR3wB4Zs0C+vIx1MeD3EIO7lPINjBaq1uVJ1mqKo+lkFysbGl8hd53QZqdB4ffoY0aVsvTbdjLZfF26oMgwFTWIf10z0zJjicH6wXQIbLBVA/8N27a2LsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750663; c=relaxed/simple;
	bh=iWmVd5KiP80E0rsgjUkS/5lP5sRP+tDud2E5rI6LG6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZD2pYS6ZLAo7i7Cu3e7x8o7XxIIxyaxD4eRk5IbozywMVUnExAcTSgiq2EiZIbH6VKjOIsybXVknlDqZq9zsIHj5YytBR1Ty8+FHFuwz0hdEGWDfLVgNDiz+Fb2doAdjOinwLZeHjVK8+7VuORrh3HFt6uhJ8NiCrgOBmpgFwsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C68CBDA7;
	Mon, 30 Sep 2024 19:44:50 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D59943F58B;
	Mon, 30 Sep 2024 19:44:17 -0700 (PDT)
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
Subject: [PATCH 04/47] arm64/sysreg: Add register fields for ID_AA64DFR2_EL1
Date: Tue,  1 Oct 2024 08:13:13 +0530
Message-Id: <20241001024356.1096072-5-anshuman.khandual@arm.com>
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

This adds register fields for ID_AA64DFR2_EL1 as per the definitions based
on DDI0601 2024-06.

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
index 6c0893d0204a..dbaa58be2e52 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1296,6 +1296,19 @@ Field	15:8	BRPs
 Field	7:0	SYSPMUID
 EndSysreg
 
+Sysreg	ID_AA64DFR2_EL1	3	0	0	5	2
+Res0	63:8
+UnsignedEnum	7:4	BWE
+	0b0000	NI
+	0b0001	IMP
+	0b0010	IMP_WPT
+EndEnum
+UnsignedEnum	3:0	STEP
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+EndSysreg
+
 Sysreg	ID_AA64AFR0_EL1	3	0	0	5	4
 Res0	63:32
 Field	31:28	IMPDEF7
-- 
2.25.1

