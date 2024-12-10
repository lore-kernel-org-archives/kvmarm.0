Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E33228C94
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810173; cv=none; b=b/PuBuydv7uXiidhq7iwCddxr3D1y6u7XXzn4a+i9iFQELywCP/R6p2kOXf5GsZZRnBINo5l1tQsD3RH7uPKu5SMDxQrv/wpb9flZQX4DwR+PO1twVPoLGL3FcCfh8AI6pLmYio0812Fscxcz9DcUPcq8JYDy0cA5FKqCJMiXlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810173; c=relaxed/simple;
	bh=0HplCQVjtuZ3jzxu1QmoTxKUxzJ4K9fX8Yz0im3TuXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XcvvhHtNeBWxfw4qJpwIVVi+aZY2rMxX3HyVzbyn2FCY5H6TIINF4TDMjd8B/NYhYROqGJsWYTjyuiU70fDMp8rJ67vcc9QS2yMYiYaxFY7fZsPioWPWaWwcAPfp9ASUZWRMcC5HlrQAAOSHtgcE8nDM9YsBJcOuOdiQYjE+BBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FF59113E;
	Mon,  9 Dec 2024 21:56:40 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8B2563F58B;
	Mon,  9 Dec 2024 21:56:08 -0800 (PST)
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
Subject: [PATCH V2 33/46] arm64/sysreg: Add register fields for SPMIIDR_EL1
Date: Tue, 10 Dec 2024 11:22:58 +0530
Message-Id: <20241210055311.780688-34-anshuman.khandual@arm.com>
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

This adds register fields for SPMIIDR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b19b8e594524..3b217ce3fe28 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -149,6 +149,14 @@ Field	3:2	P1
 Field	1:0	P0
 EndSysreg
 
+Sysreg	SPMIIDR_EL1	2	0	9	13	4
+Res0	63:32
+Field	31:20	ProductID
+Field	19:16	Variant
+Field	15:12	Revision
+Field	11:0	Implementer
+EndSysreg
+
 Sysreg	SPMDEVAFF_EL1	2	0	9	13	6
 Res0	63:40
 Field	39:32	Aff3
-- 
2.25.1

