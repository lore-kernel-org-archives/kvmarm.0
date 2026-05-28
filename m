Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBCD277007
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987330; cv=none; b=A6z3lwNHObfLTuFaxBTR/2duqPGVlDINQ83MkEDDtsR7eK4l54jif6sl6+mQHhq7NIGhlmOAW+ZmvWGF1pSL3ym51jpOfWfE2E0+HvTlL+qLzk1UP1+o/mm9Fyad0vH8cay725SbkNg5S6MU2JBD3ZmbpjqVKyJ/FBTLJhrew1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987330; c=relaxed/simple;
	bh=VV+fwEI2oRDciEKVwmpXCawYRlotLtMhk6b7N6IOyBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UGr33v1BcrcSk2I1BIOm9WnV62Kp4iblrviUpME00bdLTSONzdBqCsspP0tCaQz6wpLo+9hOpbQo89GZpM2kc1itX5/wVD8BS5s1gkOXT2fbkqYoPJ5Yr4knHVjiLMesWcTE0BV94BZqVgQd+0bDROakx9FuoVC/jhUYtQ6T0XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CeeJHJBs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CeeJHJBs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16E27460D;
	Thu, 28 May 2026 09:55:23 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BAF9E3F905;
	Thu, 28 May 2026 09:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779987328; bh=VV+fwEI2oRDciEKVwmpXCawYRlotLtMhk6b7N6IOyBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeeJHJBseAMy80yCyls4Rbp17zh7afAIM/0CNbSaQfGMyFkc9fFNT1ruumoWRIoGP
	 9bv7vXPhQQwnejQ8Kruq27014n4l51oXHVEvUp7pSljeZmSJKlyqJw7csnNsRXRE5p
	 3V5BFr3xrquex8r/oaxHnA2gjJkduVwhm5NuD7Q8=
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
	vladimir.murzin@arm.com,
	will@kernel.org
Subject: [PATCH v2 18/18] arm64: fpsimd: Remove <asm/fpsimdmacros.h>
Date: Thu, 28 May 2026 17:54:46 +0100
Message-Id: <20260528165446.701944-19-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260528165446.701944-1-mark.rutland@arm.com>
References: <20260528165446.701944-1-mark.rutland@arm.com>
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
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
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

