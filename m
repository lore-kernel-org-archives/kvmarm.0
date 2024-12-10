Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D7822B58A
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810202; cv=none; b=DRNuohedWLChhaQpI01N8nmUQcUVrmO0Gp/WNASfQpaHPy2xuFPOwHkEwT45a4ns4yUUkTk02Svl9NC/UEI4EJXvVPvHUVHlL6+b6GDLJG5xPJawkxa7/o7QOFOpW1VCqp5HLDIxfiLZg5TmCujU/E9ScqYvn+x8ftRZ/z65uQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810202; c=relaxed/simple;
	bh=mKSz9G7BgkeSslfEeHzwtZ3pc/2kPz8R8140Lhx69fk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a5mTOGTNHMdiG5P3L+Af62RaYyCbeJUAO1WS9/ko8eX6iijsNx4lKjf289srX4tYh4k7cVCgEiw+Yb8lcjspmLowOk4VTUmpcKPPoq4xjIqQAEr6eLgBz7XWQkVk4tN3ETyFP1yo/RwnkaT85mrPOSLQQu6KOFtgyVQBoa7yCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95766113E;
	Mon,  9 Dec 2024 21:57:08 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F32513F58B;
	Mon,  9 Dec 2024 21:56:36 -0800 (PST)
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
Subject: [PATCH V2 39/46] arm64/sysreg: Add register fields for SPMCGCR1_EL1
Date: Tue, 10 Dec 2024 11:23:04 +0530
Message-Id: <20241210055311.780688-40-anshuman.khandual@arm.com>
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

This adds register fields for SPMCGCR1_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index e97572c4f370..819163d1c673 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -129,6 +129,10 @@ Sysreg	SPMCGCR0_EL1	2	0	9	13	0
 Fields	SPMCGCRx_EL1
 EndSysreg
 
+Sysreg	SPMCGCR1_EL1    2       0       9       13      1
+Fields	SPMCGCRx_EL1
+EndSysreg
+
 Sysreg	SPMACCESSR_EL1	2	0	9	13	3
 Field	63:62	P31
 Field	61:60	P30
-- 
2.25.1

