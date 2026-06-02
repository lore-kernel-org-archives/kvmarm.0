Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0376A31F99C
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780413133; cv=none; b=m1ObamYMx1mYXU/r73RAW+jBmEUoCwNiltL04oH2QwQMskrehmv1Quc3+Z+XnDCsCswsli+jx+j28ISbWuU4LKiexXcwenixiTvhJN7OkAPpBoXANE1KG2dJy1ffjMYj1KVC0ehjrSeNC30nBb51g6fbp/891MlX+a1uK7amJE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780413133; c=relaxed/simple;
	bh=IabF/qhrKADpVfYSXfZTKIbKpsiQcARly16NJbg+a/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BjLIPOTctdIaGT8tvdX1Rhw3wEwLq0CtHnu42PtR2DQZs8fXw5+j+xF1TPJxPjxqTPAQ9UMMBUd06kNtDj4ovS0vVhGj0o+7/MSpc35sFypqgv75vr7rcFdbWAmypcyWpijOMOzg807sLFmSN1r7DESVY77Wy+T6CqI/TiGRwZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VCeBIblM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VCeBIblM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FE363573;
	Tue,  2 Jun 2026 08:12:06 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0E3A53F7D8;
	Tue,  2 Jun 2026 08:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780413131; bh=IabF/qhrKADpVfYSXfZTKIbKpsiQcARly16NJbg+a/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCeBIblMqNdooc4SEP68CT37qb4S7n05TdKsTWhDmeO0gHYHZhysUktSqiAEOVv1k
	 BOT6FT1vJ6fpIQ3reFbhW69Xk7azwm2+Lovb/qRTwR6YM8yDgyxlKYCffUaS3lP9/v
	 tS6LN0eBMCtfMnXXdot3EkOznGX3j4sofTwIReUs=
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
Subject: [PATCH v3 01/18] KVM: arm64: Don't include <asm/fpsimdmacros.h>
Date: Tue,  2 Jun 2026 16:11:33 +0100
Message-Id: <20260602151150.925126-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260602151150.925126-1-mark.rutland@arm.com>
References: <20260602151150.925126-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need for hyp/entry.S to include <asm/fpsimdmacros.h>.

The fpsimd macros have never been used by code in hyp/entry.S, and were
instead used by code in hyp/fpsimd.S.

Remove the unnecessary include.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/entry.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 11a10d8f5beb2..308100ed25de9 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -8,7 +8,6 @@
 
 #include <asm/alternative.h>
 #include <asm/assembler.h>
-#include <asm/fpsimdmacros.h>
 #include <asm/kvm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
-- 
2.30.2

