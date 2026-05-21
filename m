Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AE129D294
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370006; cv=none; b=Uq7WpY0AP/PSCFZ8BqODhN5ReI2f32pvzNgMhI94YCbDa6mnZUZowhogMwnL2V8X/VGY4hrvLUhUnf1WRI84LRc7+Tj5pFJ6tc7yg5ZHps/OinHzqFypNzKYOT6QBGIRx6NoKNtQI5QDFnPHkK9W1PHs5U729RuCXSCpydAAdGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370006; c=relaxed/simple;
	bh=llnyiANsOsRM3HbPgqLTHWwToaMc4R+8v2jSLs6a3Lo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qo732wmgcP01uDwAsByedVurQ4fociaTzh0q5sg27fkuEgYTW+VL92KS6UU5TfgC2BofQTmkX5DahGZSq8tfp1SoXeLuVtEaANwISa3hcitH4j7W6ZVj7vapbtnPwBhj3u0YBH4lCPOb5PYYyl0ha8Jdwd6k5pi0uTbZUp0X5zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ol/QBdbL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ol/QBdbL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4ADC82BCB;
	Thu, 21 May 2026 06:26:39 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 167703F7B4;
	Thu, 21 May 2026 06:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779370004; bh=llnyiANsOsRM3HbPgqLTHWwToaMc4R+8v2jSLs6a3Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ol/QBdbLkqZIXpayzWMkU3kxblH3fzRKCgTJmGo+hglpTA+kY2lOrv80arG7MYjbJ
	 CwWflBtC02DQnKr3VAq+JHvgAZXYjrMPA6oju/sAIjpxbAtItlgQOYHLdoHPxotR3u
	 Ys/FgXK6ro7FN7Gyby/MR6EjrmfOie6j1KpHwiF4=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 18/18] arm64: fpsimd: Remove <asm/fpsimdmacros.h>
Date: Thu, 21 May 2026 14:25:56 +0100
Message-Id: <20260521132556.584676-19-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We no longer need any of the remaining macros in <asm/fpsimdmacros.h>.

Remove all of it.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/fpsimdmacros.h | 64 ---------------------------
 1 file changed, 64 deletions(-)
 delete mode 100644 arch/arm64/include/asm/fpsimdmacros.h

diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
deleted file mode 100644
index a763fd03ffef3..0000000000000
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * FP/SIMD state saving and restoring macros
- *
- * Copyright (C) 2012 ARM Ltd.
- * Author: Catalin Marinas <catalin.marinas@arm.com>
- */
-
-#include <asm/assembler.h>
-
-/* Sanity-check macros to help avoid encoding garbage instructions */
-
-.macro _check_general_reg nr
-	.if (\nr) < 0 || (\nr) > 30
-		.error "Bad register number \nr."
-	.endif
-.endm
-
-.macro _sve_check_zreg znr
-	.if (\znr) < 0 || (\znr) > 31
-		.error "Bad Scalable Vector Extension vector register number \znr."
-	.endif
-.endm
-
-.macro _sve_check_preg pnr
-	.if (\pnr) < 0 || (\pnr) > 15
-		.error "Bad Scalable Vector Extension predicate register number \pnr."
-	.endif
-.endm
-
-.macro _check_num n, min, max
-	.if (\n) < (\min) || (\n) > (\max)
-		.error "Number \n out of range [\min,\max]"
-	.endif
-.endm
-
-.macro _sme_check_wv v
-	.if (\v) < 12 || (\v) > 15
-		.error "Bad vector select register \v."
-	.endif
-.endm
-
-.macro __for from:req, to:req
-	.if (\from) == (\to)
-		_for__body %\from
-	.else
-		__for %\from, %((\from) + ((\to) - (\from)) / 2)
-		__for %((\from) + ((\to) - (\from)) / 2 + 1), %\to
-	.endif
-.endm
-
-.macro _for var:req, from:req, to:req, insn:vararg
-	.macro _for__body \var:req
-		.noaltmacro
-		\insn
-		.altmacro
-	.endm
-
-	.altmacro
-	__for \from, \to
-	.noaltmacro
-
-	.purgem _for__body
-.endm
-- 
2.30.2

