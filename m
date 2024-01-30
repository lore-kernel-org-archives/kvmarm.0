Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872C15B1F6
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647547; cv=none; b=s+GP4F5zev/Q5o67dhq9P5MXihEsNFednuIesPkx6jvS8m+05Dw0wDBeGYU7wC+0vkCBT3LNsVi1OdJmo8jEwfZjpO3ejAdxRSWiZq3Q03VX6xVtUgxMheEQjpNdqGUkAwYyK7T+7wRjAwRPcbCvA8hRI+6ukq7XgMfbdUEHPK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647547; c=relaxed/simple;
	bh=9Vsgu4gJOf4jI0IRQ9JR0eGd9nGeKlEuw7398GwLIoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JyC8QY9de9jI6qpD+gyXxrAmHfub0w90+xQeE3JCXI8b/tHI6kwGw6gyJI4SmbCkAOc6WBqay628uTZX3i+tuw1x5LaOyKnkJ01xx18SGT8Y5a23dATqlAcsC+XV5yUv1FOFTPi7VfTuYcd+BVEWgke/ModNoGlXFYLaY6DpA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VG0vA9mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VG0vA9mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABA7C43394;
	Tue, 30 Jan 2024 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647547;
	bh=9Vsgu4gJOf4jI0IRQ9JR0eGd9nGeKlEuw7398GwLIoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VG0vA9mhgfaoXFFplT5MKapn2IXFBLXuilM2BrVhK1WlrqkV7fuYgZDsCOo0JULGY
	 sTF5ZB+NIJUZWBIHSnyynmv7lfm95ypgljURIhU8seL5xWxIp+8pjpfZ6mJwSjGDeG
	 94Wd0k/pI9DemBS5sDD9K6LcsE0HVJeiJbJQfOrfA4s4MFDWuJBQ/D4C84Qmg4Ghg9
	 eUTY38UAuoyj/gRCDfk+5QoMlXieTzXNeurIwySpYmUibrOnlzGdvjN1SBqTGogXov
	 CO5wFBrVsIVQ+30rLfIFHKOj/S6wcUZ3NnAJCzgqLxrcD9DQ2gmgiNMxrhZgmcSfFb
	 fd0md5Kp2v8TA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzJ-00GNsE-0z;
	Tue, 30 Jan 2024 20:45:45 +0000
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
Subject: [PATCH v2 01/25] arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
Date: Tue, 30 Jan 2024 20:45:08 +0000
Message-Id: <20240130204533.693853-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
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

