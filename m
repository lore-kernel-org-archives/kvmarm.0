Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676824FE2FC
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896592; cv=none; b=pR2QuIXSPclEQIGsDB364TGVgsOR+5vEptKfCNdwUG7f6xJqsQDavWCqpN/FaunC2dFH/1bDxl9mnMVAvSiLDJURpdv0mQdOK4i49hzyYhpQEX79MHCN0Ukn9ReGebR27uns9zvNUMugB1Owmpqa4Ty1+WoV743KS70DytGg2Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896592; c=relaxed/simple;
	bh=y2R6NBrHjheGHSZTteqvlbzTFmQm/wwqApfJmYPq3NY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KjwQBYNldu8OZaHVXEt329Chsign2X/m3SZGQ6+w2jmvdOMRaslw0kQdtPmwsRpsu62SptTHJdUSPqyhZeY8jJ6sM+UMAqlGMSVFpE/alD0e2QL8zBX/QANa1JSiEFE0OwetSxHw7zRfE5cQkeISHns6gyFbFN0dIIs6E6i2GRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xJU0p2b3; arc=none smtp.client-ip=95.215.58.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xJU0p2b3"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=y2R6NBrHjheGHSZTteqvlbzTFmQm/wwqApfJmYPq3NY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791896589; v=1; x=1792501389;
 b=xJU0p2b34cASzoqnDXdcP1LUe6blky2pN5HnMBdYHmTdodJZyovgmw67+2ET9vmy0ZIT9mPH
 4nEOun9a3X6d64MjP82lKINsMzFkBLF1rmlZtiLMrIJBseivhccO8EP4mNaUy3Gzd/HeBTh/0z2
 Za/qeBu2vo5zrr0e+Ki/bReo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ab2dce741b53664b;
	Tue, 13 Oct 2026 13:03:09 +0000
X-Mizu-Trace-ID: ab2dce741b53664b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] arm64: sysreg: Mark fields the architecture dropped as RES0
Date: Tue, 13 Oct 2026 14:02:46 +0100
Message-Id: <20261013130247.4135515-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013130247.4135515-1-fuad.tabba@linux.dev>
References: <20261013130247.4135515-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit d65bf6e317e7 ("KVM: arm64: Remove all traces of FEAT_TME")
turned the TME fields of SCTLR_EL1 into RES0, but left their copies in
SCTLRMASK_EL1. PMICFILTR_EL0.T and BRBFCR_EL1.LASTFAILED have gone from
the architecture as well. All six fields are RES0 in DDI0601 2026-09.

Mark them RES0 to match the spec. Nothing in the tree refers to them.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/tools/sysreg | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 341db8e9b6c37..99af1c39478be 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1420,8 +1420,7 @@ Field	17	DIRECT
 Field	16	EnI
 Res0	15:8
 Field	7	PAUSED
-Field	6	LASTFAILED
-Res0	5:0
+Res0	6:0
 EndSysreg
 
 Sysreg	BRBTS_EL1	2	1	9	0	2
@@ -2663,11 +2662,7 @@ Field	57	EPAN
 Field	56	EnALS
 Field	55	EnAS0
 Field	54	EnASR
-Field	53	TME
-Field	52	TME0
-Field	51	TMT
-Field	50	TMT0
-Res0	49:47
+Res0	53:47
 Field	46	TWEDEL
 Field	45	TWEDEn
 Field	44	DSSBS
@@ -2985,7 +2980,7 @@ Field	27	NSH
 Field	26	M
 Res0	25
 Field	24	SH
-Field	23	T
+Res0	23
 Field	22	RLK
 Field	21	RLU
 Field	20	RLH
-- 
2.39.5

