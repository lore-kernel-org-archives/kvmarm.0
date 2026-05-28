Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0E613A258
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987300; cv=none; b=knSwSrGyilo90cgg3I+Pj3HIbG20S9cBYSAVBMev8QCHz5t/xUoA9cbZKyXcCFvs6vDfSrf7tX2kSPAUG/rXCmmD61kjZAW3dzZKAWg/gn9XSeKFwuMSfGFbY+5CpZiFHrg3JxuZ7LTgkpyqQWmnuza8oXyeSlGg6v+d5c0gNus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987300; c=relaxed/simple;
	bh=NmloSGFdxE4dsknEfJbF1zvVAVislJhqreJbtnq1bWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CvNylEKg5HxQLAcM1Whj8jEFNHfQoTnp3gPpnI6GTQuABP/ApBBxEBbjM3PZQ0Yapfo/pK8JPp5xqUczPMeTnJxhkHCz04vKEgmMekip9r5P+hQaKr2PhBJEqF5idyBCrl5FU83sqcDco8plVsIQPEssdW/uLEp0UiAa1R5ZtBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PQ9+Sllc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PQ9+Sllc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04A98460D;
	Thu, 28 May 2026 09:54:54 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AAC5B3F905;
	Thu, 28 May 2026 09:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779987299; bh=NmloSGFdxE4dsknEfJbF1zvVAVislJhqreJbtnq1bWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ9+Sllcc9MrbNxiBYaGPHnzqpwAXgz6Gd47VIlLTYrCty5dJqUWUIwVymZ/qVlwa
	 a8OdH6GyChaa4K3YgBdMpFvvBmLvDVHpGQJpoRmOokp3YpjAr6cKCVPbfyh4aJJryF
	 JKGGjXT5I5+PXX+yny6Uod4+JP4wlzVJX4RbDKfA=
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
Subject: [PATCH v2 02/18] KVM: arm64: Don't override FFR save/restore argument
Date: Thu, 28 May 2026 17:54:30 +0100
Message-Id: <20260528165446.701944-3-mark.rutland@arm.com>
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

