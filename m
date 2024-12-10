Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3179232795
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810219; cv=none; b=Nz9HYY0Q1o/SVme8T98P9l2lMEVZlQ+awTObyJS/y/p2VPXwZC51mwjatorXjBGt5E2BjCH30O4XvBvVG+ZIALQhK65uxTJN7nrIV5xk7XdX8qvfJzU1bgLZuP0JTsnkaoPD32+LA0XKxbGlACDVQa5VRSJyV8ftI4i2gAe5glY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810219; c=relaxed/simple;
	bh=11Jq4A+6++f/hpvHdMx6u/W/Y6tK8u04dsLdOSvsX+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PBpY3up0ph5CV+BgfOKSC/OUOmvqETSyP6I2vDojU4eIPB/WFDNnrCzN/XF7VtApXpoZv6HJGZMQOGTUEc3hrNqayIInmj3JBNhT5+rD6+KHMssNFWynjoel15DZ+guL1XFr34B/c3lQdUoVDc4ioAC8AOa43o0RV89O1S5sFMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FD1E113E;
	Mon,  9 Dec 2024 21:57:25 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6E6123F58B;
	Mon,  9 Dec 2024 21:56:53 -0800 (PST)
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
Subject: [PATCH V2 43/46] arm64/sysreg: Add remaining debug registers affected by HDFGxTR2_EL2
Date: Tue, 10 Dec 2024 11:23:08 +0530
Message-Id: <20241210055311.780688-44-anshuman.khandual@arm.com>
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

The HDFGxTR2_EL2 registers trap a set of debug and trace related registers.
Almost all of those register encodings have been added in the tools sysreg
format. Let's also add all the remaining encodings which are formula based
(and only that, because we really don't care about what these registers
actually do at this stage).

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b8303a83c0bf..d1e3737a8ff8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -270,6 +270,12 @@
 #define SYS_TRCVMIDCCTLR1		sys_reg(2, 1, 3, 3, 2)
 #define SYS_TRCVMIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 1)
 
+#define SYS_SPMEVCNTR_EL0(m)		sys_reg(2, 3, 14, (0 | (m >> 3)), (m & 7))
+#define SYS_SPMEVTYPER_EL0(m)		sys_reg(2, 3, 14, (2 | (m >> 3)), (m & 7))
+#define SYS_SPMEVFILTR_EL0(m)		sys_reg(2, 3, 14, (4 | (m >> 3)), (m & 7))
+#define SYS_SPMEVFILT2R_EL0(m)		sys_reg(2, 3, 14, (6 | (m >> 3)), (m & 7))
+#define SYS_PMEVCNTSVR_EL1(m)		sys_reg(2, 0, 14, (8 | (m >> 3)), (m & 7))
+
 /* ETM */
 #define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
 
-- 
2.25.1

