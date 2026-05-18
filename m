Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C233F39D8
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118309; cv=none; b=KtIBngQcMp1IL0EQ595jD0+uupLbHwjMGrl1HEGwbstHoU8DPRjzUC7HVERVA5Pu5NSDYRn0MfLu8hVfapZ0CpbZVT0rVtGpJqj52ZsSk/SyE4YtqJvfSt474iHJf1oPL7p1SneMmMTTNfoa79sUFrWMzLCcPk+MYxz8iV4SRmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118309; c=relaxed/simple;
	bh=TaL0vGDEszMByRNDVpz/8GnVwTdL8YYz0VnNw2wxbGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qwgVMItMB5fmC++k+0Qs7Ag2hEfLALdziD7EG0C41XLyn7QQq/KcFIGWG39FolYBBz301Dvu3LvqDd79Pm/+zKgrLcG3dUsPYqZbyTtRyuznFtSPGwA25CKtxG/nUDwfLWdX9mcJAriixp7Ys3k35ndP6Kp4fo6870Nc37Ui00M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4/mNYg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4/mNYg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03933C2BCC6;
	Mon, 18 May 2026 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779118309;
	bh=TaL0vGDEszMByRNDVpz/8GnVwTdL8YYz0VnNw2wxbGA=;
	h=From:To:Cc:Subject:Date:From;
	b=O4/mNYg1V5kkPZinsY4CrYsg0XLHAPWKJfdRL6SKHfgihCrOi8AI62nGNsFyWLRmr
	 PuMIxhyshowGteayZnXXhRY4wdL+nxU1UNItNDjCUjREK5t357VzPAkYu5w6cSF3cw
	 wLr3GpKJBZBOOxhPZPuVNVZPkScSdYWxFxd7DA2uSBO4JEMGiSbD9KwZz6PU2VTg1R
	 apIVmw0tsobf7ClVKOuQuwERXoxXrkyAkpLZuAZlOGsBRw6Bw9zObwo+ttLar9aHpM
	 o3JETNs0CC5sD74A4E0XfbkKWLTuaDFk+rZy1ZhWd+FYkKe8WUjWIXSC83sA6H8TAk
	 s5cXhh3abM9YQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2] KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()
Date: Mon, 18 May 2026 16:31:26 +0100
Message-ID: <20260518153127.6078-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, it is not necessary for __finalise_el2() to configure
TPIDR_EL2:

* The hyp stub code does not consume the value of TPIDR_EL2.

* On the boot cpu, TPIDR_EL1 is used for the percpu offset until the
  ARM64_HAS_VIRT_HOST_EXTN cpucap is detected and boot alternatives
  are patched. Before boot alternatives are patched,
  cpu_copy_el2regs() will copy TPIDR_EL1 into TPIDR_EL2. It is not
  necessary for __finalise_el2() to initialise TPIDR_EL2 before this.

* Secondary CPUs are brought up after boot alternatives have been
  patched, and __secondary_switched() will initialize TPIDR_EL2 in
  'init_cpu_task', after finalise_el2() calls __finalise_el2()

* KVM hyp code which may consume TPIDR_EL2 is brought up after all
  secondaries have been booted, once TPIDR_El2 has been configured on
  all CPUs.

Remove the redundant initialisation from __finalise_el2().

Cc: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

v2: Use Mark's commit message, add his R-b tag, rebase onto -rc4.
Link to v1: https://lore.kernel.org/r/20260330152927.26300-1-will@kernel.org

 arch/arm64/kernel/hyp-stub.S | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 634ddc904244..37c6976e44a4 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -104,11 +104,9 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	mov_q	x0, HCR_HOST_VHE_FLAGS
 	msr_hcr_el2 x0
 
-	// Use the EL1 allocated stack, per-cpu offset
+	// Use the EL1 allocated stack
 	mrs	x0, sp_el1
 	mov	sp, x0
-	mrs	x0, tpidr_el1
-	msr	tpidr_el2, x0
 
 	// FP configuration, vectors
 	mrs_s	x0, SYS_CPACR_EL12
-- 
2.54.0.563.g4f69b47b94-goog

