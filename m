Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45E73E0238;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039791; cv=none; b=HVV0f/ZzH6B3Z7HdhEvYSQ1NBaSOS7OkP2YKwrEbP8scNGmOpbFCd63cWsXEnh/0rZ+tGw4xCf4UMwCfsM6wh1hBQEWS4GXj/ZkfgFZGJfCgT6BhQls9H9CvC0J6S0FA9E3cwXHIPwfDG6j7NWmYpihloka21Z6PMeHBiSTCz9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039791; c=relaxed/simple;
	bh=w1fPDoEy+oy5xwwPakENiPrrfB6YomaGgYQhWWBLZ28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+cjFlp1F3uq5jr/M6livdmpjOLp6q6yjM51NIYlbPUawyCtoInt9FxeSzFaQEnCUrEk9UgcniBLmnZzoLpZ2kzPI6pkv5EdQEbRm4cu5kCYvM0Eh6wH184bL55yx/PQAW/BbXh33yB/kx/+GoCFpskBJ5ZQNHiktNnraY3ULC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOM3cFCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOM3cFCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99ACC2BCB4;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039791;
	bh=w1fPDoEy+oy5xwwPakENiPrrfB6YomaGgYQhWWBLZ28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOM3cFCV64rMtE5hNq8o3dDdcXx1cOQDxnDTb1pGvqzkCpTLppnGis9Rwftwgi6Kb
	 KHPk9WFE2wYA068y2Gy0y9qXOHulmnnTKZ+yeHPe4SBYnqiC7Qwv8eIFGyhUYjN0At
	 /u2IVQ4vrhWavSOHluTjDhefJNgn08fBd4P+/qDQkZlN3Dyf46lCsaz+kOHm/fi0eP
	 xHU1Q6pstfIjj7l0MCUuJRPrNXQIK4qn2p5z9xhcKA7QeUbNWrswHjtdG4/ZiS5U0x
	 05XeRcbvzMZilzN760IJtUevishKUPXVhAT9jD8ktShNHBbvRY9xMOJnsTCYsTcuH7
	 v8RkPAhPeVjgg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw1-00000007oRQ-3fzO;
	Wed, 01 Apr 2026 10:36:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 03/16] arm64: Fix field references for ICH_PPI_DVIR[01]_EL2
Date: Wed,  1 Apr 2026 11:35:58 +0100
Message-ID: <20260401103611.357092-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ICH_PPI_DVIR[01]_EL2 registers should refer to the ICH_PPI_DVIRx_EL2
fields, instead of ICH_PPI_DVIx_EL2.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: 2808a8337078f ("arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 51dcca5b2fa6e..3b57cb692c5be 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4888,11 +4888,11 @@ Field	0	DVI0
 EndSysregFields
 
 Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
-Fields ICH_PPI_DVIx_EL2
+Fields ICH_PPI_DVIRx_EL2
 EndSysreg
 
 Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
-Fields ICH_PPI_DVIx_EL2
+Fields ICH_PPI_DVIRx_EL2
 EndSysreg
 
 SysregFields	ICH_PPI_ENABLERx_EL2
-- 
2.47.3

