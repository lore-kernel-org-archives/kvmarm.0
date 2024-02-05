Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE7F17565
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129287; cv=none; b=O4tqqr9GlPPON4MBPIMVUAXKdxhtdyy+qm/WyY/iuZBhXpUFCX3/WWTFkxwhYC728w8B/H8daWcLhzyAtzc5cj4MUKuBZg3hRSFHnzeBZGSzR7XCzpQCoZsWgFXt2rkcUSEhr17dEcJrw0+yyRFQ7e73C/mmCX6eWNLAQVWkF/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129287; c=relaxed/simple;
	bh=9Vsgu4gJOf4jI0IRQ9JR0eGd9nGeKlEuw7398GwLIoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QZsnKx50nyVd+H0bccRIBai5INC3YWg4AYemnMUhDAOJ2d8iLXScP9DZPSnENXsIWXxsI1VcKNEuIOc/lBNbp4AFGZ7l1iVRYidXidbqbG1Md6TtiXjLpOijkmC4SfuUhSxM6vrhK5L9GhWO1eFkhLCzr5ULOOIfvUGgZhR2SgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEnvaU1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEnvaU1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B269C433C7;
	Mon,  5 Feb 2024 10:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129287;
	bh=9Vsgu4gJOf4jI0IRQ9JR0eGd9nGeKlEuw7398GwLIoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEnvaU1VSImVa+pCLxX6sbk5nlLmnijSloAK/fypWniXf8pFaQa/Wlv3aB+dZ6m/t
	 vT38nWUXht55iCZpnOKv0uNPq6Rn5z2+sSushtCvRlwa9O7l69Qf7NUasmSF6bZuuE
	 nCpa2/CjyZVPjMbs+tJ9Id+Nb1NvyWm/l+B7dfAxSzgM36jbjf6QvRaOsWC43nWpEu
	 rJ1/8gORXO7fmy83yprDrk/ShC50/TdA7xdA3j9Y2dB00+ZuP6u5rc+jrBrwFS9cb9
	 CPcDBFejJPJwLLcDLBJYMLpxywBjdDLarHl49UhKmqsguCGzy0Ci5JDCz9aYzfRd70
	 elPcpys9fq/KQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJJ-000Nc3-3o;
	Mon, 05 Feb 2024 10:34:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 01/26] arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
Date: Mon,  5 Feb 2024 10:34:06 +0000
Message-Id: <20240205103431.1104133-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite having the control bits for FEAT_SPECRES and FEAT_PACM,
the ID registers fields are either incomplete or missing.

Fix it.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index fa3fe0856880..53daaaef46cb 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1366,6 +1366,7 @@ EndEnum
 UnsignedEnum	43:40	SPECRES
 	0b0000	NI
 	0b0001	IMP
+	0b0010	COSP_RCTX
 EndEnum
 UnsignedEnum	39:36	SB
 	0b0000	NI
@@ -1492,7 +1493,12 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64ISAR3_EL1	3	0	0	6	3
-Res0	63:12
+Res0	63:16
+UnsignedEnum	15:12	PACM
+	0b0000	NI
+	0b0001	TRIVIAL_IMP
+	0b0010	FULL_IMP
+EndEnum
 UnsignedEnum	11:8	TLBIW
 	0b0000	NI
 	0b0001	IMP
-- 
2.39.2

