Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AB922EFB
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUwZHpKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D62C433D9;
	Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897424;
	bh=A5I5Ank97gMJHjlMkiOS6x44usmfYJbXquzi5rguQ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUwZHpKLldeJ8mo8atkd28gWqJSvvQo1goZyKIaJaZLXZFQ1WAeslXXHI14phk0eH
	 9Nbcx3UK5ipAd1gg8tQV+YOWCxw6BX/h/2f1CCZCmkcBPr8ZwDV91CjzCaIG42uAxi
	 0I4F29hZGwbJhVpH4w4tEQudHlKTPwABv00Yvmh6WA8UcfcUSOOfcuvEeP+Qb4aGA7
	 xAAoR3GRBmSo8kxRvdlXtt8oKx2N4ABwYnSAauvMt7nV9I+G3/KVZ+YqD8Q0W9dDUE
	 5yqoEZfbQ4bgEfovvpiOkjc2Gcq4GeXRtc1CGrMd4t882KMOxbasPTvLCxG95fzrmp
	 F4jdjdeQG5aZg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayM-00CkQ4-EI;
	Mon, 13 Nov 2023 17:43:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 03/12] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
Date: Mon, 13 Nov 2023 17:42:35 +0000
Message-Id: <20231113174244.3026520-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231113174244.3026520-1-maz@kernel.org>
References: <20231113174244.3026520-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ARMv9.5 has infroduced ID_AA64MMFR4_EL1 with a bunch of new features.
Add the corresponding layout.

This is extracted from the public ARM SysReg_xml_A_profile-2023-09
delivery, timestamped d55f5af8e09052abe92a02adf820deea2eaed717.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 96cbeeab4eec..7fb3a4928256 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1675,6 +1675,43 @@ UnsignedEnum	3:0	TCRX
 EndEnum
 EndSysreg
 
+Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
+Res0	63:40
+UnsignedEnum	39:36	E3DSE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	35:28
+SignedEnum	27:24	E2H0
+	0b0000	IMP
+	0b1110	NI_NV1
+	0b1111	NI
+EndEnum
+UnsignedEnum	23:20	NV_frac
+	0b0000	NV_NV2
+	0b0001	NV2_ONLY
+EndEnum
+UnsignedEnum	19:16	FGWTE3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	HACDBS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	ASID2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+SignedEnum	7:4	EIESB
+	0b0000	NI
+	0b0001	ToEL3
+	0b0010	ToELx
+	0b1111	ANY
+EndEnum
+Res0	3:0
+EndSysreg
+
 Sysreg	SCTLR_EL1	3	0	1	0	0
 Field	63	TIDCP
 Field	62	SPINTMASK
-- 
2.39.2

