Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F2B449EA4
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 07:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791530516; cv=none; b=nptcRIz+KBFBwaMUzOpJ48J1kTcLyl7Gy67ftu9EPv0UNmDerITcihFO9j+FmYpAo2kGypDt0Lt8r6m4rwJ2xqlSUfhPf0wpTCKi0f3CZzm9c09PSlI8k4M8NcTEVncJFWvaXc/olo311BgfU8jGfSWhUIOuh5hNowuhbxHvQ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791530516; c=relaxed/simple;
	bh=eDr9qjbDolMTro9PuTSl1NUMeg1X4qjYnOhBaA6KHn0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g+PXJzdfMCfsecpscr4hOwF8NKiUbsMkY7MqQy8CVo/hM5uD7fAu92j1gPJcO4SyJj87odQc8psYtuwPUU/4hmcbdUonyHc931IcWL1VAVJdwhdZuPe3ehQeFn4rPy7HzCVFkUIXaE19RncP+wsmaWnaUkPzakeLYC5SHyn4R6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QBamTnqe; arc=none smtp.client-ip=95.215.58.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QBamTnqe"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=eDr9qjbDolMTro9PuTSl1NUMeg1X4qjYnOhBaA6KHn0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791530512; v=1; x=1792135312;
 b=QBamTnqegQZF2tA8Df/34tbz2lyvUTdLGhl5uhL2NPbxzgg130RZAvRe/gsN8ZWCTwOtZSy8
 CgLO1fHJXlnc7RBkqjs5aTVDUL8GNEIen2W0UE08AWzobddBn/4x+4tvUVDy3AxddNbVLwfQrWY
 3NKqOQV8sDiiRd8Xt+buNmi8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0e4ce33aa79cbb04;
	Fri, 09 Oct 2026 07:21:52 +0000
X-Mizu-Trace-ID: 0e4ce33aa79cbb04
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: catalin.marinas@arm.com,
	will@kernel.org
Cc: mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	anshuman.khandual@arm.com,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: Use symbolic constants for the ccmp NZCV immediates
Date: Fri,  9 Oct 2026 08:21:47 +0100
Message-Id: <20261009072147.474952-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ccmp instructions in the EL2 setup code, reset_pmuserenr_el0 and
the hyp vectors give the flags to set when their condition fails as a
raw NZCV immediate, #4 or #8. Which condition that leaves true for the
branch that follows has to be worked out from the pseudocode each time.

Define CCMP_NZCV_EQ and CCMP_NZCV_LT from the PSR bits, named for the
condition each leaves true, and pass those instead.

No functional change intended.

Suggested-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/all/asIQ1ZwUjkmNJbRP@willie-the-truck/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/assembler.h | 2 +-
 arch/arm64/include/asm/el2_setup.h | 4 ++--
 arch/arm64/include/asm/ptrace.h    | 4 ++++
 arch/arm64/kvm/hyp/hyp-entry.S     | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 0b58b550e8dce..b4b97e03db828 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -500,7 +500,7 @@ alternative_else_nop_endif
 	mrs	\tmpreg, id_aa64dfr0_el1
 	ubfx	\tmpreg, \tmpreg, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
 	cmp	\tmpreg, #ID_AA64DFR0_EL1_PMUVer_NI
-	ccmp	\tmpreg, #ID_AA64DFR0_EL1_PMUVer_IMP_DEF, #4, ne
+	ccmp	\tmpreg, #ID_AA64DFR0_EL1_PMUVer_IMP_DEF, #CCMP_NZCV_EQ, ne
 	b.eq	9000f				// Skip if no PMU present or IMP_DEF
 	msr	pmuserenr_el0, xzr		// Disable PMU access from EL0
 9000:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 1da277baacf78..c0ece880e85bd 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -137,7 +137,7 @@
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x0, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
 	cmp	x0, #ID_AA64DFR0_EL1_PMUVer_NI
-	ccmp	x0, #ID_AA64DFR0_EL1_PMUVer_IMP_DEF, #4, ne
+	ccmp	x0, #ID_AA64DFR0_EL1_PMUVer_IMP_DEF, #CCMP_NZCV_EQ, ne
 	b.eq	.Lskip_pmu_\@			// Skip if no PMU present or IMP_DEF
 	mrs	x0, pmcr_el0			// Disable debug access traps
 	ubfx	x0, x0, #11, #5			// to EL2 and allow access to
@@ -422,7 +422,7 @@
 	mrs	x1, id_aa64dfr0_el1
 	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
 	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_IMP_DEF
-	ccmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9, #8, ne
+	ccmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9, #CCMP_NZCV_LT, ne
 	b.lt	.Lskip_pmuv3p9_\@		// Skip if < PMUv3p9 or IMP_DEF
 
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index f7dc5fb9427d6..15c381ef7d2c2 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -30,6 +30,10 @@
 #define PSR_MODE_THREAD_BIT	(1 << 0)
 #define PSR_IL_BIT		(1 << 20)
 
+/* CCMP NZCV immediates that make the named condition hold */
+#define CCMP_NZCV_EQ		(PSR_Z_BIT >> 28)
+#define CCMP_NZCV_LT		(PSR_N_BIT >> 28)
+
 /* AArch32-specific ptrace requests */
 #define COMPAT_PTRACE_GETREGS		12
 #define COMPAT_PTRACE_SETREGS		13
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 03f97d71984c4..8621eacd13738 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -46,7 +46,7 @@ el1_sync:				// Guest trapped into EL2
 	mrs	x0, esr_el2
 	ubfx	x0, x0, #ESR_ELx_EC_SHIFT, #ESR_ELx_EC_WIDTH
 	cmp	x0, #ESR_ELx_EC_HVC64
-	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
+	ccmp	x0, #ESR_ELx_EC_HVC32, #CCMP_NZCV_EQ, ne
 	b.ne	el1_trap
 
 	/*
-- 
2.39.5

