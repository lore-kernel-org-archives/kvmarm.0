Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CAD14A097
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750782; cv=none; b=FPWk2tzdN7yXyULnLntA4AhORofIezswGbGTG8HQY5qXFZG+oXq7cF3m5BgFajM/JXWYm3H4ebQEk6FOjHvJrCg2RJhdI2c3nVT9TKzUTDvACYdgLumbXcpviLa8O1Iq+17wygBm5or0VEwhcBawTSBYHTOSzb86bB4YaJEplPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750782; c=relaxed/simple;
	bh=Om6ymydDeguPMUB5Oc+eo1SUOxo80N/JEHUsZwT5Uyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iNWucNh3fmiNCRpeZy1i+F/iGduCCm8PvxrGrQSg2emqD7xFH6Yd9maiFCxa9k9ojjL383q8wtLJNmLqL7n7mSjQIziU0+80aIlSYqGC7sHayGitcAfqHmXw0xBGYiGk3IZ/n/BOoGCjyIbyNVCAu/emOQY8EUWtwikd8an2fAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9494367;
	Mon, 30 Sep 2024 19:46:49 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E7CD93F58B;
	Mon, 30 Sep 2024 19:46:16 -0700 (PDT)
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
Subject: [PATCH 34/47] arm64/sysreg: Add register fields for SPMIIDR_EL1
Date: Tue,  1 Oct 2024 08:13:43 +0530
Message-Id: <20241001024356.1096072-35-anshuman.khandual@arm.com>
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

This adds register fields for SPMIIDR_EL1 as per the definitions based
on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a649958b9fe8..073d92fd085a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -149,6 +149,16 @@ Field	3:2	P1
 Field	1:0	P0
 EndSysreg
 
+Sysreg	SPMIIDR_EL1	2	0	9	13	4
+Res0	63:32
+Field	31:20	ProductID
+Field	19:16	Variant
+Field	15:12	Revision
+Field	11:8	Implementer_high
+Res0	7
+Field	6:0	Implementer_low
+EndSysreg
+
 Sysreg	SPMDEVAFF_EL1	2	0	9	13	6
 Res0	63:40
 Field	39:32	Aff3
-- 
2.25.1

