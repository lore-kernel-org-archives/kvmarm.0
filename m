Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0471D3CF58
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750659; cv=none; b=Cs/BTaVCg5bUf8VNQNkJ1MssIMKs+7xWDqmdlXrn/RWqBZouOwYTLp0cNMy/+I37e5Bh3hCeJgET4ipLwpbN6X8imPsxC9QEB0JqeX+HdHQA06Db6+QAyaMu3BRrue+iaLBSCh+wcht+z0uEGtVz8mtYsQMLhZOqvLie7XoU9gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750659; c=relaxed/simple;
	bh=zy5jMEzeZKEQbK80Q1ALmj2NdOI7sH0SCnDz4cQBGS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PtNXz+aNov9diZ8VwENoNF/j4A6z1DhBqcHbkGKNIOavzVXQqFPu3Fqxf2Gngk1chQTDzOkYEy9iY3r4ZaIl2u4pE7xsk3T9rsShcR4FWfRVDDICngkAR/d3MVNELDeNQ+F8UjBSmRBKVdb+JHZk8l62vEYnY828sfJ2lFTYZig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD67C367;
	Mon, 30 Sep 2024 19:44:46 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DCB9A3F58B;
	Mon, 30 Sep 2024 19:44:13 -0700 (PDT)
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
Subject: [PATCH 03/47] arm64/sysreg: Update register fields for ID_AA64PFR0_EL1
Date: Tue,  1 Oct 2024 08:13:12 +0530
Message-Id: <20241001024356.1096072-4-anshuman.khandual@arm.com>
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

This updates ID_AA64PFR0_EL1.RAS and ID_AA64PFR0_EL1.RME register fields as
per the definitions based on DDI0601 2024-06.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 0e90d40af2bd..6c0893d0204a 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -873,6 +873,7 @@ EndEnum
 UnsignedEnum	55:52	RME
 	0b0000	NI
 	0b0001	IMP
+	0b0010	GPC2
 EndEnum
 UnsignedEnum	51:48	DIT
 	0b0000	NI
@@ -899,6 +900,7 @@ UnsignedEnum	31:28	RAS
 	0b0000	NI
 	0b0001	IMP
 	0b0010	V1P1
+	0b0011	V2
 EndEnum
 UnsignedEnum	27:24	GIC
 	0b0000	NI
-- 
2.25.1

