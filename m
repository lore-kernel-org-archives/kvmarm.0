Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2014228369
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810085; cv=none; b=JjcHgvzRU5XUWGVmx/Q0DwGQs8msbOem4LPe40wivZicpzG0ZkRQC8C8CBemQCtw06EYh6EegGu0KURQtiAgywT9PMwJcq5EaoSWJnOKXihEuaFnSrki7RRQ2BgJcIbHIoenjMBM0VRqo8gRSnDmWDCaGfRr4KLnKAcNAwQwYSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810085; c=relaxed/simple;
	bh=M4+ncPcwaTkqjCH19NoLaN/p8b3plUQAQ1c52P9IaMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OEDX8ICOz4T/sexcV8QZq4xn9CbDSCVMDmQ73qTpMV77cKSA3ACklmZWTghv9ObIk8EBxROSs8zuRCOpG/N3dPA8OgdPn8UDYDz+lCoZvIWnJOgEfeEYJiXEjZM1WKQ4Q5GUei8siLDyL4vIZeRJMaCmYWtqhlAR/S0TnXWJb+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A550113E;
	Mon,  9 Dec 2024 21:55:11 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 126B03F58B;
	Mon,  9 Dec 2024 21:54:38 -0800 (PST)
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
Subject: [PATCH V2 17/46] arm64/sysreg: Add register fields for PMECR_EL1
Date: Tue, 10 Dec 2024 11:22:42 +0530
Message-Id: <20241210055311.780688-18-anshuman.khandual@arm.com>
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

This adds register fields for PMECR_EL1 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index ff09da6c0b1e..214ad6da1dff 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2349,6 +2349,21 @@ Res0	63:5
 Field	4:0	SEL
 EndSysreg
 
+Sysreg	PMECR_EL1	3	0	9	14	5
+Res0	63:5
+UnsignedEnum	4:3	SSE
+	0b00	DISABLED
+	0b10	ENABLED_PROHIBITED
+	0b11	ENABLED_ALLOWED
+EndEnum
+Field	2	KPME
+UnsignedEnum	1:0	PMEE
+	0b00	PMUIRQ_E_PMU_D
+	0b10	PMUIRQ_D_PMU_D
+	0b11	PMUIRQ_D_PMU_E
+EndEnum
+EndSysreg
+
 Sysreg	PMIAR_EL1	3	0	9	14	7
 Field	63:0 ADDRESS
 EndSysreg
-- 
2.25.1

