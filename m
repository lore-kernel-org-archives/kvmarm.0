Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397F7228CAF
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 05:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810214; cv=none; b=A/VFzGRpTNrUCrPbuS7Drj072NfEgdsrqt0gj19Kof5yV6CRRtTChuZQsnhaHVMZ7i14RTWhMQW//cVCxKQulHO18W+fzM4D6NCyZgG1YFwNGgBHo7NUNgkRbiCa0NluKJrc8MIBGFBKGnqj/bf7j46i9NY2u4UXV83fKePGmpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810214; c=relaxed/simple;
	bh=vXo6OoNwjF/iFoP7SMLckU7OqQVemdOtBB7G9hQEaXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E3k+FUuteAIMYcp1jEG6qXXN+7wK+U0XdHDMv8RRjGrpsu315UbNVpoQFHUxyUE/shijUxQ7l8mGwruBWjvmOhkNzLsOzOSTOdmDxVJviMG2ybVijfBmT7qYS0t1+D5QJgA/Lx1R+aGJLIplETXF+USzPdoaac0rreuisCUE4iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E83C4339;
	Mon,  9 Dec 2024 21:57:20 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.48.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 592E03F58B;
	Mon,  9 Dec 2024 21:56:49 -0800 (PST)
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
Subject: [PATCH V2 42/46] arm64/sysreg: Add register fields for SPMACCESSR_EL2
Date: Tue, 10 Dec 2024 11:23:07 +0530
Message-Id: <20241210055311.780688-43-anshuman.khandual@arm.com>
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

This adds register fields for SPMACCESSR_EL2 as per the definitions based
on DDI0601 2024-09.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/tools/sysreg | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 2e732ea1dfb1..8a6957cfa0e4 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -655,6 +655,41 @@ Field	1	P1
 Field	0	P0
 EndSysreg
 
+Sysreg	SPMACCESSR_EL2	2	4	9	13	3
+Field	63:62	P31
+Field	61:60	P30
+Field	59:58	P29
+Field	57:56	P28
+Field	55:54	P27
+Field	53:52	P26
+Field	51:50	P25
+Field	49:48	P24
+Field	47:46	P23
+Field	45:44	P22
+Field	43:42	P21
+Field	41:40	P20
+Field	39:38	P19
+Field	37:36	P18
+Field	35:34	P17
+Field	33:32	P16
+Field	31:30	P15
+Field	29:28	P14
+Field	27:26	P13
+Field	25:24	P12
+Field	23:22	P11
+Field	21:20	P10
+Field	19:18	P9
+Field	17:16	P8
+Field	15:14	P7
+Field	13:12	P6
+Field	11:10	P5
+Field	9:8	P4
+Field	7:6	P3
+Field	5:4	P2
+Field	3:2	P1
+Field	1:0	P0
+EndSysreg
+
 Sysreg	SPMSCR_EL1	2	7	9	14	7
 Field	63:32	IMP_DEF
 Field	31	RAO
-- 
2.25.1

