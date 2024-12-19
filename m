Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A315B19AD5C
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629640; cv=none; b=UYP0ZWO6hxvW6mTJ5b2NqC3bXJGRVr1UT3qqYRuYy8Pf0eXna9r5UhWMQIrFrwFufaDAxOAUMfL5xC4D9GmASfUaNovU8YCYan1By0Fuq+hcfvlg4KMMsTem6I3Bwu2S8qkF9SUlqUzUEJL9PcIJVybX3JjzEiqo5eX++ONCSBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629640; c=relaxed/simple;
	bh=QZmElIefHd/oEum8VNselLfsNxqkON0BuYmRcf8dbh0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W6bEZ/M7kTPF540wbc7sJuu4CoHnTxWbtN5vV1p0oA76MySGEXNlXmTR9klf4AIsHy4DEnZKkw5wrQsrEl7zLGgyI9QmFGK/FZ36qZtsh7mBWRD+KIOgz61axVSV7P6XBsXIy6lFDJ3dsZmFg0RDHqlj7svfS5ak4ktihHBtmZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MK4G+wn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MK4G+wn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5E4C4CED4;
	Thu, 19 Dec 2024 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629640;
	bh=QZmElIefHd/oEum8VNselLfsNxqkON0BuYmRcf8dbh0=;
	h=From:To:Cc:Subject:Date:From;
	b=MK4G+wn8GF8g2vSEjXQEUJNP4JuCWiDCTw7shy5AE77JF2OcDeMmDFS5yborql6VT
	 3m1itFmskKXZHyYGT/PtdZw7YILc6/Nx+FhfigLPnqYvrtVqcJxZbRWgcr9nL1Y6mO
	 pbnjAPgWYwWoncexDxR1WxCINi2X5dodbsnsqzyEEQ/CO/uwgUqza5Pt+gcAMTVw6I
	 znqLcuSJX57syNk5oxKMmR7d3efdWqZZSGWZRXL8WzBbpn105I0lQBnpm+c17iz/yU
	 do4UlBlWn7p1z/l7NcduWrqUxcjhBtKb2A5CXrIIFDvMGANJVqsuroXco+yJ314pD1
	 57q+YHlet9q/g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tOKPO-005Lao-8W;
	Thu, 19 Dec 2024 17:33:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 0/4] arm64/sysreg: Get rid of *_ELx as fields for EL12 accessors
Date: Thu, 19 Dec 2024 17:33:46 +0000
Message-Id: <20241219173351.1123087-1-maz@kernel.org>
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

* From v1:

  - Fixed the description in the first patch following Mark's proposal

  - Couple of spelling funnies being fixed

  - Collected Acks and RBs.

Marc Zyngier (4):
  arm64/sysreg: Allow a 'Mapping' descriptor for system registers
  arm64/sysreg: Get rid of the TCR2_EL1x SysregFields
  arm64/sysreg: Convert *_EL12 accessors to Mapping
  arm64/sysreg: Get rid of CPACR_ELx SysregFields

 arch/arm64/include/asm/el2_setup.h      |  6 ++--
 arch/arm64/include/asm/kvm_arm.h        |  2 --
 arch/arm64/include/asm/kvm_emulate.h    | 40 +++++++++++-----------
 arch/arm64/include/asm/kvm_nested.h     |  8 ++---
 arch/arm64/kernel/cpufeature.c          |  4 +--
 arch/arm64/kvm/at.c                     |  6 ++--
 arch/arm64/kvm/emulate-nested.c         |  2 +-
 arch/arm64/kvm/fpsimd.c                 |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  4 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  6 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 16 ++++-----
 arch/arm64/mm/proc.S                    |  5 +--
 arch/arm64/tools/gen-sysreg.awk         |  2 +-
 arch/arm64/tools/sysreg                 | 44 ++++++++++++-------------
 16 files changed, 76 insertions(+), 77 deletions(-)

-- 
2.39.2

