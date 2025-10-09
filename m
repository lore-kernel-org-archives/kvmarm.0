Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7345B2DFA3A
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 12:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011965; cv=none; b=Fn2jaSbpJN2iKlzQiSemQz+V+5RQIdAj+UJ32bclczSFpn5f0W2SciHbgYI4tJwR0+A81nmCEg01OLnSCNbGJrji2Q9UQqj4o72YRaIyZAHjTzfhSXjfrYNKheVl0BVMyrv/ZxbmZt6qIRPgT32wfevDAhlaBO34M+EoCCziuac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011965; c=relaxed/simple;
	bh=6IKkBB3jceClisvK/miSVJ8gU+YX4OmzT5+w66k5iuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rJameHr1f/CIf1AEuitpo8hukqhT/2UmjGT2i8/FcWRxZxDpNTM1YXdbB5UMqq+eYKfIL4Ts3SqDYHQVbYnGDZTAYxY+5QrPz7Z6YjmQavJIlCv5j5+tIDWOBX3dEW6rujDlEV1yfk1A+JoXH/s9pEj0CitFilWwKJh52IujI6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfOPzIR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfOPzIR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC516C4CEE7;
	Thu,  9 Oct 2025 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760011965;
	bh=6IKkBB3jceClisvK/miSVJ8gU+YX4OmzT5+w66k5iuA=;
	h=From:To:Cc:Subject:Date:From;
	b=OfOPzIR9/4pEfJkx3ibwGihYhFDVAJvhkKJ7gJ6AEY9CXSdiMXcvieCHHZUSmTDQ0
	 ZXnUkE/9BAtShD5WOSeG84sGWBZi/j+sfzJvK+7cMVUHut49jGOdgBO0/ag7sSxxUE
	 954cYH30yf4r0/fwiTbgtaQpfcGRjBgqufTZcTSolK1W+lMMzha4uXuxNlFowYMEI4
	 uzKJVV/1Z/4P2COFfSCAa2kKLnu7w9hcNOQrv680ocwRh6yA75jZYJofXJjsjdMY/l
	 9Z2IOju3VoChUV3BGa+n43TPVYEeFDaCzzc1wrXJYJc/f3YVJAF+f0tFmFcF0vQ8bu
	 jj3swl/KwJEiQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v6pVi-0000000CcaD-1h4w;
	Thu, 09 Oct 2025 12:12:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jan Kotas <jank@cadence.com>
Subject: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Date: Thu,  9 Oct 2025 13:12:39 +0100
Message-ID: <20251009121239.29370-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, jank@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently have two ways to identify CPUs that only implement FEAT_VHE
and not FEAT_E2H0:

- either they advertise it via ID_AA64MMFR4_EL1.E2H0,
- or the HCR_EL2.E2H bit is RAO/WI

However, there is a third category of "cpus" that fall between these
two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
is zero.

A consequence of this is that on systems such as Neoverse V2, a NV
guest cannot reliably detect that it is in a VHE-only configuration
(E2H is writable, and ID_AA64MMFR0_EL1 is 0), despite the hypervisor's
best effort to repaint the id register.

Replace the RAO/WI test by a sequence that makes use of the VHE
register remnapping between EL1 and EL2 to detect this situation,
and work out whether we get the VHE behaviour even after having
set HCR_EL2.E2H to 0.

This solves the NV problem, and provides a more reliable acid test
for CPUs that do not completely follow the letter of the architecture
while providing a RES1 behaviour for HCR_EL2.E2H.

Suggested-by: Marc Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com
---
 arch/arm64/include/asm/el2_setup.h | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 46033027510cc..b7640e2c20503 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -24,22 +24,40 @@
 	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
 	 * can reset into an UNKNOWN state and might not read as 1 until it has
 	 * been initialized explicitly.
-	 *
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
-	 * don't advertise it (they predate this relaxation).
-	 *
 	 * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
 	 * indicating whether the CPU is running in E2H mode.
 	 */
 	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
 	sbfx	x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
 	cmp	x1, #0
-	b.ge	.LnVHE_\@
+	b.lt	.LnE2H0_\@
 
+	/*
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but don't
+	 * advertise it (they predate this relaxation). Check for an
+	 * essential VHE property (system register remapping) to decide
+	 * whether we're effectively VHE-only or not.
+	 *
+	 * This is also useful for for NV guests on CPUs that can't trap
+	 * ID_AA64MMFR4_EL1 as they don't have FEAT_FGT.
+	 */
+	msr_hcr_el2 x0		// Setup HCR_EL2 as nVHE
+	isb
+	mov	x1, #1		// Write something to FAR_EL1
+	msr	far_el1, x1
+	isb
+	mov	x1, #2		// Try to overwrite it via FAR_EL2
+	msr	far_el2, x1
+	isb
+	mrs	x1, far_el1	// If we see the latest write in FAR_EL1,
+	cmp	x1, #2		// we can safely assume we are VHE only.
+	b.ne	.LnVHE_\@	// Otherwise, we know that nVHE works.
+
+.LnE2H0_\@:
 	orr	x0, x0, #HCR_E2H
-.LnVHE_\@:
 	msr_hcr_el2 x0
 	isb
+.LnVHE_\@:
 .endm
 
 .macro __init_el2_sctlr
-- 
2.47.3

