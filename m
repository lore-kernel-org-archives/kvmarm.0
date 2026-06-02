Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38423ED5CC
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780413135; cv=none; b=aM1jKgsZB/2GYf1EZkCMa0auR0/gzcNRNW+MhIM7d0JN1jmSPtLbfXmBcsMmC3q401KKTYQj51T0HDeKLRQhHsbDQ/cQtRBk0tR4DPw0ESsx6L144VKlfFkTS9L4zmO38frHr8y2Szb9ojtrke/Xg8XJ7TSqjsZL/zRCioj1/+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780413135; c=relaxed/simple;
	bh=NmloSGFdxE4dsknEfJbF1zvVAVislJhqreJbtnq1bWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=thqa2NfiuzC0Gv3ecPIvL8fdRKDuejk0jC4szbL6qzTTL5ol5gfGja8xGR1BHUXnVbYq5Ap/KSqukC058GFctC6zAjpEFWs0OKCPYMYmdGC44CLMlcB+PNTDtuKHlSAwBv/ImDtgjHAradOonAI6hj6qzTmgjCmAKTiRy3hxfkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bSxl1M3i; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bSxl1M3i"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EC6F3582;
	Tue,  2 Jun 2026 08:12:08 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B5E5D3F7D8;
	Tue,  2 Jun 2026 08:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780413133; bh=NmloSGFdxE4dsknEfJbF1zvVAVislJhqreJbtnq1bWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSxl1M3itiI1XT1bL33irkU25eCgF1E3jZQH26c76dEJZriU2s3WkdG9JE994i93N
	 +5KLp8RsJAJ/3yzS7dBoBp9AicRhw4uBOcZw7UG4Ep6kXVlFgDcE8AbvG+n1T/ZHda
	 GAzCFzY7hq4tukl496/zJT7PuftfU79Yco3Bz1PI=
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
Subject: [PATCH v3 02/18] KVM: arm64: Don't override FFR save/restore argument
Date: Tue,  2 Jun 2026 16:11:34 +0100
Message-Id: <20260602151150.925126-3-mark.rutland@arm.com>
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

The __sve_save_state() and __sve_restore_state() functions take a
parameter describing whether to save/restore the FFR, but both functions
silently override this with '1'. This has always been benign (and
callers have all passed 'true' since the parameter was introduced), but
clearly this is not intentional.

Historically, the functions always saved/restored the FFR, and there was
no parameter to control this.

In v5.16, the sve_save and sve_load assembly macros used by
__sve_save_state() and __sve_restore_state() were changed to make
saving/restoring FFR optional. The implementations of __sve_save_state()
and __sve_restore_state() were changed to pass '1' to their respective
macros, and the prototypes of __sve_save_state() and
__sve_restore_state() were unchanged. See commit:

  9f5848665788 ("arm64/sve: Make access to FFR optional")

In v6.10, the prototypes of __sve_save_state() and __sve_restore_state()
were changed to add 'save_ffr' and 'restore_ffr' parameters
respectively, but the implementations were not changed to stop passing 1
to their respective macros. All callers were changed to pass 'true' to
__sve_save_state() and __sve_restore_state(). See commit:

  45f4ea9bcfe9 ("KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state")

This is all benign, but clearly unintentional, and it gets in the way of
cleaning up the FPSIMD/SVE/SME code. Remove the unnecessary overriding.

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
 arch/arm64/kvm/hyp/fpsimd.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index e950875e31cee..6e16cbfc5df27 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -21,13 +21,11 @@ SYM_FUNC_START(__fpsimd_restore_state)
 SYM_FUNC_END(__fpsimd_restore_state)
 
 SYM_FUNC_START(__sve_restore_state)
-	mov	x2, #1
 	sve_load 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_restore_state)
 
 SYM_FUNC_START(__sve_save_state)
-	mov	x2, #1
 	sve_save 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_save_state)
-- 
2.30.2

