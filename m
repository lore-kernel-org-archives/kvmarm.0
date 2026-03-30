Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C762D334C31
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 15:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774884584; cv=none; b=LCwySLFDYgv9bIC15nO3w3zdbwT6/080aSTGsSUBJy7AkpjKqI9mwdoUG2KcdCEYsve/GIPuB6CEUZeJU4QhadyqkBE7qSbHGLvVloVxYgrFoTCAzKBNrqiPp6XzgooYXrFX7eNuiBXHCOowDDxGLeZ+1mWkIoB+olpSkNvXRWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774884584; c=relaxed/simple;
	bh=hhtJIBLdvdm+AIwtgCrXvY3R3zCBsqQURKRNTRro06o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=glQ+lZMpp48ZWWDGIPey2OWzZX9MxlzJa7pGWSOFEPoizezj+3upeELHvOMQ4QNFVIMxI9FUE1KJtCJ/ETxMPRvMLBplpC3Ez7eXXUkusCincCfL+9w5NkNP2S1R+X+0+NHQhiH4Ou8sDCx3qrmBD/lzkE2jJnVeML0wynUqkos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAo8uZSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAo8uZSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDA7C19423;
	Mon, 30 Mar 2026 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774884584;
	bh=hhtJIBLdvdm+AIwtgCrXvY3R3zCBsqQURKRNTRro06o=;
	h=From:To:Cc:Subject:Date:From;
	b=hAo8uZSCVoeQLGlJrSBUGct8Wnpan13+1XCHRRzaL3ROguFpCbRA9BEdHWYvYTmtX
	 YFQMaxWhdXiM7L4XWrcG+1NwRNrK3Gwl5AFEMrZo+Iofonz0isGjFFbuM5oQUK/4Dw
	 lKhA+zWoJKOA/P2QPFKU0rIBUfgUpzB5SrXXASbOWUpJos9nT+6/yJG6rEQlD+bdU/
	 CV6NVXtJwJv+Md+dU8TqmxPTImdC0WUnB1gRsSAvx+Gpsg+9sCxRBE0NJ6tK+vLr2H
	 mB1iJp7qGzGZ3ST+JEz8mzycby4NuGRnSK2E3qOpd0Wh1KqeFbHWlSE9ucfRjjKUt6
	 AS3IK13/5E1oQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()
Date: Mon, 30 Mar 2026 16:29:26 +0100
Message-ID: <20260330152927.26300-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running with VHE, TPIDR_EL2 is only used for the percpu offset once
the ARM64_HAS_VIRT_HOST_EXTN capability has been detected, at which
point cpu_copy_el2regs() will populate its contents from TPIDR_EL1.

Remove the redundant initialisation of TPIDR_EL2 from finalise_el2().

Cc: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

I spotted this by inspection as part of an ill-fated (abandoned) attempt
at repurposing tpidr_elx for something else.

 arch/arm64/kernel/hyp-stub.S | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 085bc9972f6b..8b8614c0b9a5 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -105,11 +105,9 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	msr_hcr_el2 x0
 	isb
 
-	// Use the EL1 allocated stack, per-cpu offset
+	// Use the EL1 allocated stack
 	mrs	x0, sp_el1
 	mov	sp, x0
-	mrs	x0, tpidr_el1
-	msr	tpidr_el2, x0
 
 	// FP configuration, vectors
 	mrs_s	x0, SYS_CPACR_EL12
-- 
2.53.0.1018.g2bb0e51243-goog

