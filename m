Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1C11DFE1
	for <kvmarm@lists.linux.dev>; Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733598488; cv=none; b=LHRyHHQUNes1R9zOEvuC5Z0szHiLHwbsmimgpNokll9AonMv9khUqeIVg6Xh2UHzQ98piAPjdxw+l49wOCmfr94RJD/EshUGnOW3msHyIzSqDrxI8TMW9HNzlBXH4NcrOr1fugGyiUtS5Vh5ZTPwJviJ8AoMJEKmTX/LHb5+mtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733598488; c=relaxed/simple;
	bh=0j8vGZ36dxNbKwWwiSrTlZRlNfkcvdeaJx1lNvFy98k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GHvzbVRrl0Vg2AMDQ+E+uMGF2p+JRdsl1mx0yWcKug3LYgRXMJUzGAvpgyqcb/Pvog3srbudT2imb5P7/LAP6j3Dpdq16+6DnSSZdm0ZizYt3x6AACG7NgQBVPt2NKy7HyI+ZKaIGL23q2z5DQ8iuh46dqz+EGHqluwK0ith63c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cj1tQVA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cj1tQVA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39180C4CECD;
	Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733598488;
	bh=0j8vGZ36dxNbKwWwiSrTlZRlNfkcvdeaJx1lNvFy98k=;
	h=From:To:Cc:Subject:Date:From;
	b=cj1tQVA/BPJZfPrBqbmzM2KpgqILpeBNeIWW9kHkz9yumzqeIA4LwgO+VSZ2Z/pMC
	 loNuKDimZlXvHLfsEhKMu+8s9FAqhDuejcKVDJHhrkL9YFIdEEiY9qJ+AXIKgca6zA
	 Duyg0h8BQIlvyuQeZV9FNvLqEu9vGwjHwtMZIziTO/HdvCnK/Yq25Ol5qWTdgmoQOX
	 fcvX7g0VXwUiwZ8UJcSpYiK1OLKSkEhbdh8b/u9PaE2J0fxU4Ez4rJh/aoj498vDUD
	 b9ihZ1PKq9lZz/CIHh2TJt2ajTNfPA+xDdEVHHCrw9lBEfEGp4sqTH2mtlZ7NmkMb/
	 h5XzS212VWUQw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tK09t-001TOc-Rb;
	Sat, 07 Dec 2024 19:08:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 0/4] arm64/sysreg: Get rid of *_ELx as fields for EL12 accessors
Date: Sat,  7 Dec 2024 19:07:36 +0000
Message-Id: <20241207190740.2607673-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We keep adding *_ELx definition to the sysreg as an abstraction for
the mapping between an EL1 register and its EL12 counterpart.

But nothing in the architecture has these ELx suffixes to describe
such abstraction. When they are mentioned, it always is as a shortcut
for EL1, EL2 or EL3, and never for EL12. That's because *_EL12 are
*not* registers. They are accessors, nothing else. So what we
currently have is not only bizarre, it is actively wrong.

This small series aims are injecting some sanity, by explicitly
describing EL12 registers as mappings to EL1 registers, and keeping
the ELx description as fields for the EL{1,2} registers.

Marc Zyngier (4):
  arm64/sysreg: Allow a 'Mapping' descriptor for system registers
  arm64/sysreg: Get rid of the TCR2_EL1x SysregFields
  arm64/sysreg: Convert *_EL12 accessors to Mapping
  arm64/sysreg: Get rid of CPACR_ELx SysregFields

 arch/arm64/include/asm/el2_setup.h      |  6 ++--
 arch/arm64/include/asm/kvm_arm.h        |  2 --
 arch/arm64/include/asm/kvm_emulate.h    | 40 ++++++++++++-------------
 arch/arm64/include/asm/kvm_nested.h     |  8 ++---
 arch/arm64/kernel/cpufeature.c          |  4 +--
 arch/arm64/kvm/at.c                     |  6 ++--
 arch/arm64/kvm/emulate-nested.c         |  2 +-
 arch/arm64/kvm/fpsimd.c                 |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  4 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  6 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 16 +++++-----
 arch/arm64/mm/proc.S                    |  5 ++--
 arch/arm64/tools/gen-sysreg.awk         |  2 +-
 arch/arm64/tools/sysreg                 | 39 ++++++++++++------------
 16 files changed, 73 insertions(+), 75 deletions(-)

-- 
2.39.2

