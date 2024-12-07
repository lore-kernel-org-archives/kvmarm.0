Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14D114A09E
	for <kvmarm@lists.linux.dev>; Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733598488; cv=none; b=SpnQj145CE5KO3fUNfJybWTVTGYIL+5Y21biT3/toiQWux/SXZicbzUj4nEBmKjDk5Yfj+ZUzgP/yAGt6S/N2LT8YykrnoGzU+NA8UkjqVf/HCThXb2DIwpvO1YAmp2rN6l0kxZ4orRRc8Xb7Pr6wV9bHNYg74YwnfVa90RUdKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733598488; c=relaxed/simple;
	bh=cgaTsKTJrsLBacLMgbwEl37CvHQ9qS/dDCpL+E4tjsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aOnHw91EBPrxgmCpIDBd+YxXuzGVmVd0rmrJPxjinUsxVKbrg4WLQImSQm5IHqBCBUy7SkUGoas0qU+zz6K4zMdJ8+yjK1dz0WYfLWWxNejuu3xGVzf5gWTURtOSr4hCLlmz7yENxLh6sZzApTJEz00V/Qcn6b4xcrrMLO5eCwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5q0Zcgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5q0Zcgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44791C4CEDC;
	Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733598488;
	bh=cgaTsKTJrsLBacLMgbwEl37CvHQ9qS/dDCpL+E4tjsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5q0ZcgqvR+NGRZBYXM31n2aBNVJQriUjidaK5LP278aZZIbJ3aTupU8nYelYWFa7
	 BmwbCw4+R2bHJmNQgjkbGca0y3z2oAjoW32fNDSPo2qTASpZy+va1oiCsv6u4yXVnt
	 vDJy2UGomvGDTTLLyrVXpXOUCQT+OnZvle01Hd3Lm2QUt24qBmdVxyAjuanB5IZjqe
	 V0dgQub3A23BX2G9pEv8FnzFpZhaEoFj1uiIAvcUWhkkuDTSndA6PfVGDQNNHvUtb6
	 it29EB9PdzQPVwI9U0IZPvbIJjx1OvsCxDWPUWeIS70OZ2mzZqkk1iEWFa4rKjdRfg
	 DRnU72gfcr5Gg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tK09u-001TOc-Fv;
	Sat, 07 Dec 2024 19:08:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/4] arm64/sysreg: Convert *_EL12 accessors to Mapping
Date: Sat,  7 Dec 2024 19:07:39 +0000
Message-Id: <20241207190740.2607673-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241207190740.2607673-1-maz@kernel.org>
References: <20241207190740.2607673-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Perform a bulk convert of the remaining EL12 accessors to use the
Mapping qualifier, which meakes things a bit clearer.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 19d137d9c50ed..ad2f6265f7948 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2954,23 +2954,23 @@ Field	63:0	PhysicalOffset
 EndSysreg
 
 Sysreg	CPACR_EL12	3	5	1	0	2
-Fields	CPACR_ELx
+Mapping	CPACR_EL1
 EndSysreg
 
 Sysreg	ZCR_EL12	3	5	1	2	0
-Fields	ZCR_ELx
+Mapping	ZCR_EL1
 EndSysreg
 
 Sysreg	SMCR_EL12	3	5	1	2	6
-Fields	SMCR_ELx
+Mapping	SMCR_EL1
 EndSysreg
 
 Sysreg	GCSCR_EL12	3	5	2	5	0
-Fields	GCSCR_ELx
+Mapping	GCSCR_EL1
 EndSysreg
 
 Sysreg	GCSPR_EL12	3	5	2	5	1
-Fields	GCSPR_ELx
+Mapping	GCSPR_EL1
 EndSysreg
 
 Sysreg	FAR_EL12	3	5	6	0	0
@@ -2982,7 +2982,7 @@ Fields	MPAM1_ELx
 EndSysreg
 
 Sysreg	CONTEXTIDR_EL12	3	5	13	0	1
-Fields	CONTEXTIDR_ELx
+Mapping	CONTEXTIDR_EL1
 EndSysreg
 
 SysregFields TTBRx_EL1
@@ -3087,7 +3087,7 @@ Fields	PIRx_ELx
 EndSysreg
 
 Sysreg	PIRE0_EL12	3	5	10	2	2
-Fields	PIRx_ELx
+Mapping	PIRE0_EL1
 EndSysreg
 
 Sysreg	PIRE0_EL2	3	4	10	2	2
@@ -3099,7 +3099,7 @@ Fields	PIRx_ELx
 EndSysreg
 
 Sysreg	PIR_EL12	3	5	10	2	3
-Fields	PIRx_ELx
+Mapping	PIR_EL1
 EndSysreg
 
 Sysreg	PIR_EL2		3	4	10	2	3
@@ -3119,7 +3119,7 @@ Fields	PIRx_ELx
 EndSysreg
 
 Sysreg	POR_EL12	3	5	10	2	4
-Fields	PIRx_ELx
+Mapping	POR_EL1
 EndSysreg
 
 Sysreg	S2POR_EL1	3	0	10	2	5
-- 
2.39.2

