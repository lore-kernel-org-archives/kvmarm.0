Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F9D3806AA
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369970; cv=none; b=lRCBw4iLs0sRqo8/Knm3BG5wPkrDdEpWT0nbj7wLwXTrb4xgfhyHL1lEDAwoYxhvADFp5azjb430gpqZUDZdr6pSWOpO4/7mDC592o3sEmyix87kAmtZgRxo05igChxtXaa0NEy2MvT2a4Q4sDH04DtUA159u8HjVuIMamAyvHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369970; c=relaxed/simple;
	bh=nbea7DoplJ2jo710471pZZ5/IQgX6MpmBMVAh7D0sKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LkvahXTjsKgyzfCZpa7VGNA2jO5wv8fvfcVhfkvpFB5EGmWdRsm74Y7WvnoSX78hutNI5DfBkA7te5aPkjua7yZcTcKxfhu2tvhvp2AiC6+joqrEdSfPYm4VAjE/UtV6SFse7xmKjm9r67WxZMjOjX+qapXKsiDYx3wGv24vS/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Eq0U73Pw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Eq0U73Pw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 449A12BCB;
	Thu, 21 May 2026 06:26:02 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1F0C63F7B4;
	Thu, 21 May 2026 06:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779369967; bh=nbea7DoplJ2jo710471pZZ5/IQgX6MpmBMVAh7D0sKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq0U73PwY+hsOWqgG/BsAOuFxLw5vWjdjVq/7yDNmJ3vYciqy0e7etd1oK9n+Jvv2
	 Tul3IGo01goXHYDCapAjIgDpKx4Za5F9MSolnCszqBAyL2Hh0gAwVS3GnKMkMYfkoH
	 scVOeZsYUSeqhZ1HQ2itTz0iCeni/jNg2qi15XYQ=
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
Subject: [PATCH 01/18] KVM: arm64: Don't include <asm/fpsimdmacros.h>
Date: Thu, 21 May 2026 14:25:39 +0100
Message-Id: <20260521132556.584676-2-mark.rutland@arm.com>
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

There's no need for hyp/entry.S to include <asm/fpsimdmacros.h>.

The fpsimd macros have never been used by code in hyp/entry.S, and were
instead used by code in hyp/fpsimd.S.

Remove the unnecessary include.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
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

