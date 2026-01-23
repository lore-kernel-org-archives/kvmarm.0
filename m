Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335733EBF29
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195803; cv=none; b=l9BKki5zo+U2sgsmqN5/3o38YBvrtz7CtF/NYBKevir+Owp30DdzLu5chyKKly2IAYBVS8plye+Jci1fOrnB6Z2jBLllX51IITRQYj9+GWJkPRIPH4IxpBPsbzf09OUs4u14wT3Ho370Sb6EE3h8knQTeXXM3afEDOuHiKAQHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195803; c=relaxed/simple;
	bh=XxB6UOz64bCcf9pmfvZiOwm4zMTUPBq+6kKgJ7LtMiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1qAGkpkuz5kxRqtbUcc3xdTKiOPmX0W2ElSsv/2VcMuJqlkQn1xPIGYY1rnuPLNYgoz+1p2FoR10W0AeLzEG0RkL/aJkuXMCsBJqsByA3LwxDeYPdDfOOSz6we7z1Mo1CLHx3/iejfbt2PfKbYykyFDnjWWq7M6fJxRkzqVNE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oogvoKpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oogvoKpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4DBC4CEF1;
	Fri, 23 Jan 2026 19:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769195802;
	bh=XxB6UOz64bCcf9pmfvZiOwm4zMTUPBq+6kKgJ7LtMiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oogvoKpFPuV7RpbQn6CLNwFSkDa8ewZGdc7U82/x3VToh1JYSjMd4sI4wIDF0aEHf
	 CV1l0vkIXpF2DanpXkzkLHHq0ty3X+2ZHb1HRdqqTyVzei26GI0BsA6RXFNTUtkSaI
	 CR4rNcJa0LfKBN5t8jTs0vQTEIAvO1kmAGa9UJ2hwvqqoUJbd9vpK69Itsw9GdVWHw
	 2+n9zSTzsOQ/VT7BDmemvo5BKhgkkUgMPt7ULjWs5H0dA5+cKkOU9vZ1ZuTPcXQH+O
	 G+Y+zl+n+s4QfNBd5GK2j9UjnTv7kJ4z86e8AMt9RiXxZ5xGaOAMM5XgYAqBNQl+Wl
	 Bs9XPMp/9toAA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vjMe8-00000005A2V-3NGw;
	Fri, 23 Jan 2026 19:16:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 1/5] arm64: Add MT_S2{,_FWB}_AS_S1 encodings
Date: Fri, 23 Jan 2026 19:16:33 +0000
Message-ID: <20260123191637.715429-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123191637.715429-1-maz@kernel.org>
References: <20260123191637.715429-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

pKVM usage of S2 translation on the host is purely for isolation
purposes, not translation. To that effect, the memory attributes
being used must be that of S1.

With FWB=0, this is easily achieved by using the Normal Cacheable
type (which is the weakest possible memory type) at S2, and let S1
pick something stronger as required.

With FWB=1, the attributes are combined in a different way, and we
cannot arbitrarily use Normal Cacheable. We can, however, use a
memattr encoding that indicates that the final attributes are that
of Stage-1.

Add these encoding and a few pointers to the relevant parts of the
specification. It might come handy some day.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/memory.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 9d54b2ea49d66..a2b7a33966ff1 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -175,19 +175,24 @@
 #define MT_DEVICE_nGnRE		4
 
 /*
- * Memory types for Stage-2 translation
+ * Memory types for Stage-2 translation when HCR_EL2.FWB=0. See R_HMNDG,
+ * R_TNHFM, R_GQFSF and I_MCQKW for the details on how these attributes get
+ * combined with Stage-1.
  */
 #define MT_S2_NORMAL		0xf
 #define MT_S2_NORMAL_NC		0x5
 #define MT_S2_DEVICE_nGnRE	0x1
+#define MT_S2_AS_S1		MT_S2_NORMAL
 
 /*
- * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
- * Stage-2 enforces Normal-WB and Device-nGnRE
+ * Memory types for Stage-2 translation when HCR_EL2.FWB=1. Stage-2 enforces
+ * Normal-WB and Device-nGnRE, unless we actively say that S1 wins. See
+ * R_VRJSW and R_RHWZM for details.
  */
 #define MT_S2_FWB_NORMAL	6
 #define MT_S2_FWB_NORMAL_NC	5
 #define MT_S2_FWB_DEVICE_nGnRE	1
+#define MT_S2_FWB_AS_S1		7
 
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
-- 
2.47.3

