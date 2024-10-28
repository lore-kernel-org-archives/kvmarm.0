Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D9D18DF76
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 05:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093688; cv=none; b=iU4Nykm4Z1N+4/Pmg35KQZB+sKcNI5mUgZ+nP8h+EYny2mtgCmXlqx91jHg+956j6+T/SIxEMWMYd2FFy9VFy5VJds6VlgPYpxhXVRg7i5/VzsKVG6u9ZLO2Af2NipYUrNx/ax710ba2ZTOOaH5C7YnC5XbUAVZaaOf2+LqBlEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093688; c=relaxed/simple;
	bh=w6v4ohXQqoYDYUvsdD62pXw6sZNKdkMLDTOtQLh2kgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mIZqmGM9I5wD/8szmwqx2Wyyf1oce6YSFZLKwiXXz2kfcFCH7VJFtAxGEdfcx2t3Hhh8xBPYxvJM5TnDS6pGZMoR+/GPJ4fbXR4JkcpRLP3gOpsIiWA1teV0z1KcEF+zod36R2I5ovoOsIzj4mo9Ylfw8JaqLvHDL0LZJQgGYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E55DD497;
	Sun, 27 Oct 2024 22:35:15 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9A1E33F66E;
	Sun, 27 Oct 2024 22:34:42 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH V2 2/7] arm64/sysreg: Add register fields for MDSELR_EL1
Date: Mon, 28 Oct 2024 11:04:21 +0530
Message-Id: <20241028053426.2486633-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241028053426.2486633-1-anshuman.khandual@arm.com>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds register fields for MDSELR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 41b0e54515eb..a92fc241fb4e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -93,6 +93,17 @@ Res0	63:32
 Field	31:0	DTRTX
 EndSysreg
 
+Sysreg	MDSELR_EL1	2	0	0	4	2
+Res0	63:6
+Enum	5:4	BANK
+	0b00	BANK_0
+	0b01	BANK_1
+	0b10	BANK_2
+	0b11	BANK_3
+EndEnum
+Res0	3:0
+EndSysreg
+
 Sysreg	OSECCR_EL1	2	0	0	6	2
 Res0	63:32
 Field	31:0	EDECCR
-- 
2.25.1

