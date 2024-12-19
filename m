Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D3319CD07
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629640; cv=none; b=EBtrCqseuR/IR5K1I4gEYHXcf+jE8vjIHjiam//V+0Na4jC0MPkF2XPk5zc/JYIIOIv3yAjpaCe7H7iHUjgbVOeBF1Mm8OdJcJP5ryY5GpgrCzsNDi10oFrZg1dt5dbJF6QHNjao5i743cydnOfTv4yHmUQut7Nk9XdL28qcTn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629640; c=relaxed/simple;
	bh=nPaZbXOBBHrFlixt9/15NDrzHBuF0m3Er3DJCCqqVmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DIejeOmHrHCdOqyhpD0+i7q2QJ7x+wAjX1SzXhwlFcRQe5SiX8CexQVINAnjFH20nH5AevXIwTee5iiQ8tXulrTQTP6MxXgojGWlxA8N4qLzY/UWBVPaQiW1InGb1JbpW21Z11TiMx3Hu5UCx5W87N4DxioDal8OGUXW37NAY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIFT39YZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIFT39YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9638CC4CEDF;
	Thu, 19 Dec 2024 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629640;
	bh=nPaZbXOBBHrFlixt9/15NDrzHBuF0m3Er3DJCCqqVmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIFT39YZxqt5Ce2b0r3ULR4f5l36wn+8kMX1Pm8Mw0C0g6cF/lfZg1h+lE/nekHUr
	 YgG7exTvmnshUf8BZZl2kRpJQM7Jznbjfv+73tqaWsTt0Gou5src+SxrAf1MNooZsD
	 s/PeyzNDLPCw3HlrESeagQdG2D1GscCUkOSSxiD5Xle1AiSYscjbdYoQvHfPhsOc1M
	 kDWRXJp6K9qp40XFtxQqSgpNeyLFyODgORVLwVk3KYiEXBoZDLIlHbBb2s/HAuEaMP
	 FbuuJVI3Dmi2iHu8zywfnKnbsY9txGagxwS9mAfE0V2itplv5AHA3I5+WSWa6aPWU5
	 sZSGfHdb5YxOg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tOKPO-005Lao-PJ;
	Thu, 19 Dec 2024 17:33:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 3/4] arm64/sysreg: Convert *_EL12 accessors to Mapping
Date: Thu, 19 Dec 2024 17:33:49 +0000
Message-Id: <20241219173351.1123087-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241219173351.1123087-1-maz@kernel.org>
References: <20241219173351.1123087-1-maz@kernel.org>
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
Mapping qualifier, which makes things a bit clearer.

Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 64712e00787f9..899526e16a4cd 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2955,23 +2955,23 @@ Field	63:0	PhysicalOffset
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
@@ -2983,7 +2983,7 @@ Fields	MPAM1_ELx
 EndSysreg
 
 Sysreg	CONTEXTIDR_EL12	3	5	13	0	1
-Fields	CONTEXTIDR_ELx
+Mapping	CONTEXTIDR_EL1
 EndSysreg
 
 SysregFields TTBRx_EL1
@@ -3088,7 +3088,7 @@ Fields	PIRx_ELx
 EndSysreg
 
 Sysreg	PIRE0_EL12	3	5	10	2	2
-Fields	PIRx_ELx
+Mapping	PIRE0_EL1
 EndSysreg
 
 Sysreg	PIRE0_EL2	3	4	10	2	2
@@ -3100,7 +3100,7 @@ Fields	PIRx_ELx
 EndSysreg
 
 Sysreg	PIR_EL12	3	5	10	2	3
-Fields	PIRx_ELx
+Mapping	PIR_EL1
 EndSysreg
 
 Sysreg	PIR_EL2		3	4	10	2	3
@@ -3120,7 +3120,7 @@ Fields	PIRx_ELx
 EndSysreg
 
 Sysreg	POR_EL12	3	5	10	2	4
-Fields	PIRx_ELx
+Mapping	POR_EL1
 EndSysreg
 
 Sysreg	S2POR_EL1	3	0	10	2	5
-- 
2.39.2

