Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEA41756F
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129287; cv=none; b=qPYOsOyVBKLpVYojJKLWUZtCbL2KUVfCW4C9lg6w4F9t3Fu1uSnWuXxZnUV6m+Te81TAhvCDQc7uNUmxIl2oM1D6ixn9CHAqKkrOL9SafGpSfNsYPVTXKa7q1udaA9/WFYdPTkeHObtDRu9CFlEQdF7uB4980W0hLj9NaBZgrLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129287; c=relaxed/simple;
	bh=kATcKRrqp+KeXZT4MEsXYWVUiosjAVDb43BXlRGcHyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VbT7oAa1EyGF6n5sJjDahco2/iABQSOlKGkTVKfnKRObFOl5reXALjWxANV6ljagcRINquh4LWnSOctvklA1NWJioPWDjvaVWdaJmCYWJslbKC+tzCF3anDuBdQXjN7TbxlXhWuIkX1jhjtmHvwYe5B7633UUYQdo3ADyavImrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hi4aFb8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hi4aFb8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D44DC433F1;
	Mon,  5 Feb 2024 10:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129287;
	bh=kATcKRrqp+KeXZT4MEsXYWVUiosjAVDb43BXlRGcHyQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Hi4aFb8XxKqjkzKzDlWbR/OgaPXnsy+v1Xig7Obq3iI2n9b17Y3SfLkVsT3CiYodX
	 7hIG14CY6mFTls3QGwUpAy3yGoVwG9OpoqFgZjnl67pUGGmzf1DzrSbaCkxQpNT1WU
	 h2PMkDGXM9DZJnRNRI7r1VF/mrH2nE0pt77vhIo/6Oe/UJMWwhq9WhPWSzMU0VSg9r
	 IYi2mJLTEyrNRVy9svI+4qHZ4h2YM1T+QNNQMfZ7b9MUwGzh6kQ5N+D2cLUWXv8/PA
	 F9t0NdJrIqKaGY4fUKpEA7VYAzaEwoisZw+XulfRGeZUsX7mV1G8u34raI0WoPjajI
	 IT4wCkjJeoAow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJI-000Nc3-PQ;
	Mon, 05 Feb 2024 10:34:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 00/26] KVM/arm64: VM configuration enforcement
Date: Mon,  5 Feb 2024 10:34:05 +0000
Message-Id: <20240205103431.1104133-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the third version of this configurationm enforcement series
after some heroic reviewing from Joey (again) and Suzuki. Many thanks
to both.

I think I have taken most of the feedback into account, but please
shout if I have ignored something.

* From v2: [2]

  - Fix totally broken handling of negative features by delegating the
    work that requires a functionnal brain to other people

  - Fix handling of HCR_ENSCXT as RES0 instead of RES1 (and its
    consequences...)

  - Add handling of VTTBR_EL2.CNP being RES0

  - Add a snapshot of all RES0/RES1 fields so that we can catch them
    being changed behind our backs

  - Various cleanups

* From v1: [1]
  - Fix embarrassing crash with FEAT_MOPS

  - Better error handling in the FGT code

  - Added/Fixed comments

  - Simplified the __vcpu_sys_reg() macro

  - Fixed FEAT_PIR handling

  - Folded in Oliver's PMU rework

[1] https://lore.kernel.org/all/20240122201852.262057-1-maz@kernel.org
[2] https://lore.kernel.org/all/20240130204533.693853-1-maz@kernel.org

Marc Zyngier (26):
  arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
  KVM: arm64: Add feature checking helpers
  KVM: arm64: nv: Add sanitising to VNCR-backed sysregs
  KVM: arm64: nv: Add sanitising to EL2 configuration registers
  KVM: arm64: nv: Add sanitising to VNCR-backed FGT sysregs
  KVM: arm64: nv: Add sanitising to VNCR-backed HCRX_EL2
  KVM: arm64: nv: Drop sanitised_sys_reg() helper
  KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
  KVM: arm64: nv: Correctly handle negative polarity FGTs
  KVM: arm64: nv: Turn encoding ranges into discrete XArray stores
  KVM: arm64: Drop the requirement for XARRAY_MULTI
  KVM: arm64: nv: Move system instructions to their own sys_reg_desc
    array
  KVM: arm64: Always populate the trap configuration xarray
  KVM: arm64: Register AArch64 system register entries with the sysreg
    xarray
  KVM: arm64: Use the xarray as the primary sysreg/sysinsn walker
  KVM: arm64: Rename __check_nv_sr_forward() to triage_sysreg_trap()
  KVM: arm64: Add Fine-Grained UNDEF tracking information
  KVM: arm64: Propagate and handle Fine-Grained UNDEF bits
  KVM: arm64: Move existing feature disabling over to FGU infrastructure
  KVM: arm64: Streamline save/restore of HFG[RW]TR_EL2
  KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
  KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the
    guest
  KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the
    guest
  KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest
  KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later
    checking
  KVM: arm64: Add debugfs file for guest's ID registers

 arch/arm64/include/asm/kvm_arm.h           |   4 +-
 arch/arm64/include/asm/kvm_host.h          |  98 +++++++-
 arch/arm64/include/asm/kvm_nested.h        |   1 -
 arch/arm64/kvm/Kconfig                     |   1 -
 arch/arm64/kvm/arm.c                       |   7 +
 arch/arm64/kvm/check-res-bits.h            | 121 ++++++++++
 arch/arm64/kvm/emulate-nested.c            | 231 +++++++++++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 130 +++++-----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  24 +-
 arch/arm64/kvm/nested.c                    | 267 ++++++++++++++++++++-
 arch/arm64/kvm/pmu-emul.c                  |  11 +-
 arch/arm64/kvm/sys_regs.c                  | 238 +++++++++++++++---
 arch/arm64/kvm/sys_regs.h                  |   2 +
 arch/arm64/tools/sysreg                    |   8 +-
 include/kvm/arm_pmu.h                      |  11 -
 15 files changed, 973 insertions(+), 181 deletions(-)
 create mode 100644 arch/arm64/kvm/check-res-bits.h

-- 
2.39.2

