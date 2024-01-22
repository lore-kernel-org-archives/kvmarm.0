Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39553FE5F
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947241; cv=none; b=dM9MikvP/cLrBw4QH4Dvoymiimx4OfpkFXUjHhG1ssX6wOmOMLXsw17uEC83ZSqWq2Dm01ER4PlDLFz4gFDQCMdQk+nKibrdDuklKjDamdXTygAQWPgyfzVb5l71W89kgG6qI0LECuszSsOhkKHT3mf0xwd5iyRhK6nPmq9ZsqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947241; c=relaxed/simple;
	bh=P/4V+i/EtjGeVTyYKiWi07tTDVAjq/TyRbVJcMg9KFM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fmQ2zjj7QChGeA0uuIq6hELNzhwscLMVruWlUGExQPUxP/AAF450XpcZXbWGnQFrEAvMcxxEHLuNX1ee1Iy4qiKQVSFTe7SN6ENJNG+2jSEt9w/K5vRIZDDlrayYi5ozpm/2bus3CwesheFWjizeJ2sDDUILK7zwuj5BzulYTzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7A2J7qE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7A2J7qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA80C43141;
	Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947241;
	bh=P/4V+i/EtjGeVTyYKiWi07tTDVAjq/TyRbVJcMg9KFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7A2J7qEYDxuhlAtlS4jECM1sl1nGH8z45z3vWu9WykBJH9pAkZiViYoM7SwoNXdX
	 BKuGRkmuyg9rd6qSUgdWwychhpOpminQDEGiyDWlNyXPHot/Eil7lBI6UV9b7BZooP
	 v4XRF2Fr01sfwcCr7PhF9/UbfSi9VYUFqn8U2uZuMb7DYN/UHvF6AZ/YytzF1pFbEF
	 5AbBra8zB7dQT5XYu0joaA93nQcwaDG0Wtvr47QpdTZWJijRd2bsbVDQoHJCxl1T/H
	 clN0asWoTevmOvfgWnSRbuGdLPjFsiFkTZbYBQAuflJR93vZC+iLELavriL5Q66V2n
	 XWsxTiHlGvhqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo3-00Dh6E-6i;
	Mon, 22 Jan 2024 18:13:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 04/10] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
Date: Mon, 22 Jan 2024 18:13:38 +0000
Message-Id: <20240122181344.258974-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122181344.258974-1-maz@kernel.org>
References: <20240122181344.258974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, ardb@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ARMv9.5 has infroduced ID_AA64MMFR4_EL1 with a bunch of new features.
Add the corresponding layout.

This is extracted from the public ARM SysReg_xml_A_profile-2023-09
delivery, timestamped d55f5af8e09052abe92a02adf820deea2eaed717.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 4c9b67934367..fa3fe0856880 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1791,6 +1791,43 @@ UnsignedEnum	3:0	TCRX
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

