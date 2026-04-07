Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A562C175A9D;
	Tue,  7 Apr 2026 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775572217; cv=none; b=s1Ws3zKSpjVMNHPQINsgGzG+LQdqSR0k8wos8PzjRwOkZf70dDsvws2f0/gMpgvj0D053kIfT+up9IXdAVK5Md6RszWrCmZbruy02ecv16k5lx36gHB4t9QWvB/sGwCr8lqTq5vaPJ39SEWMY+1HQRd2NsDHAgIuLDIUvVK7ZJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775572217; c=relaxed/simple;
	bh=S2a66R25M2ED9iApd77nQWSljUUEXLR9ndadmbDuSus=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=liaAb8883ipheFlD5mZm8pD4MReBLoLEr6aq9uomKTzWb6FyusRkkyycVwjJc6ggBAuU9nOsgtSIzh0fnT2o62bIoGIUJxjYM1qmuSBQWqLQ6cXuiQOVu+KKTs7PFc7eAxxjGInNc/aHU6BYsqAIr1wRyLdDMRAYxQxvSe08xzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtTCSSex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtTCSSex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2794CC19424;
	Tue,  7 Apr 2026 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775572217;
	bh=S2a66R25M2ED9iApd77nQWSljUUEXLR9ndadmbDuSus=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BtTCSSexqqOVxXwcQ414Ny61PUY9mAcMdzGtvv4DmvWPbKwDzO3QUKIOZawG4NDBb
	 27cpDSCJqdFlxHkKlEEb0cm4OE+pvfqM2BcaTdmMwHXRkKx8p6x4Qds7OGnitTRCyL
	 c+2q63xzYl2N+RWGeOg8aONVk+gRTVX21H96AF6if+3FyFs1a+/SnK89JNa4DDY+eN
	 rJ6mB/4gyXQcScgfPE+ruhjydng5z5fWep7FOTW/8ffKw6QKM37R01tNh5/nzowm3t
	 /FXODuhHIQ5sS6lu3xtkgOM4HHWlbiwvfOVoF9fAy9nG/u4qJDy5BVjsA6ltQ1ZN79
	 +FTX5kl9dXb0A==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 07 Apr 2026 09:29:47 -0500
Subject: [PATCH v4 5/6] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-arm-debug-8-9-v4-5-a4864e69b0ea@kernel.org>
References: <20260407-arm-debug-8-9-v4-0-a4864e69b0ea@kernel.org>
In-Reply-To: <20260407-arm-debug-8-9-v4-0-a4864e69b0ea@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
 Oliver Upton <oupton@kernel.org>
X-Mailer: b4 0.15-dev

From: Anshuman Khandual <anshuman.khandual@arm.com>

Fine grained trap control for MDSELR_EL1 register needs to be configured in
HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
is also present.

MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
watchpoint exceptions when kernel enters at EL1, but EL2 is also present.

While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v4:
 - Add that the requirements only apply when there are >16
   breakpoints/watchpoints
 - Adapt to changes in v7.0-rc1
---
 Documentation/arch/arm64/booting.rst | 13 +++++++++++++
 arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index 13ef311dace8..00ba91bbd278 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -369,6 +369,19 @@ Before jumping into the kernel, the following conditions must be met:
     - ZCR_EL2.LEN must be initialised to the same value for all CPUs the
       kernel will execute on.
 
+  For CPUs with FEAT_Debugv8p9 extension present and >16 breakpoints or
+  watchpoints:
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
+    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
+    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
+
+  - If EL3 is present:
+
+    - MDCR_EL3.EBWE (bit 43) must be initialized to 0b1
+
   For CPUs with the Scalable Matrix Extension (FEAT_SME):
 
   - If EL3 is present:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 85f4c1615472..b51a280c18c0 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -174,6 +174,13 @@
 						// to own it.
 
 .Lskip_trace_\@:
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
+	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
+	b.lt	.Lskip_dbg_v8p9_\@
+
+	orr	x2, x2, #MDCR_EL2_EBWE
+.Lskip_dbg_v8p9_\@:
 	msr	mdcr_el2, x2			// Configure debug traps
 .endm
 
@@ -438,6 +445,13 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
 
 .Lskip_spefds_\@:
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
+	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
+	b.lt	.Lskip_dbg_v8p9_\@
+
+	mov_q   x0, HDFGWTR2_EL2_nMDSELR_EL1
+.Lskip_dbg_v8p9_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x0
 	msr_s   SYS_HFGRTR2_EL2, xzr

-- 
2.53.0

