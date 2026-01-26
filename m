Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3218B14BF92;
	Mon, 26 Jan 2026 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429854; cv=none; b=g9nKhhrwQWEgSBeP+8ymgBWLLFA6OHPx2HrukUStTeQ8hODpUaaR6hhv1gH5eDfR12S+3+IT4dZVz0BSZhYKrZsRE2mvfjJl4ExAbU5AEIMFLDBwLvQvoXjODc5hqTIv0z3ehaszr8cLOmK1JNhL/IVy3/WGkVYvfsi+0IOJk5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429854; c=relaxed/simple;
	bh=uc5X5aKabC+jCw4M1h0zdw2/00NHc+cDLz/jTFu+bto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SFcibnD9XA7NZBXK29dUPlhW/wDgvQhp64Rxq4azIf4KGgHFfrAigrKWugu2GBTWFi3MBW1PGf+h0TzSKvtUFbF2LwXgg0nzI5pOWkXmNi79HeJOUWvtSBY0mZMjPVYcCHHVq730oc1DD1tpL7SCcG8hMYyrN6G1Y+7Epx70AiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azV2pcb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azV2pcb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C87C19422;
	Mon, 26 Jan 2026 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429853;
	bh=uc5X5aKabC+jCw4M1h0zdw2/00NHc+cDLz/jTFu+bto=;
	h=From:To:Cc:Subject:Date:From;
	b=azV2pcb36iRUs7IUKxkq3qU4RgLIqeHxfaQhDga1WIrF550NnLHv9AbgFlLynA20c
	 7uM0PuXkGrohnpB8g2Y/uHLdtW4ZeIyJQLIo0XPsAHRoJiX46hELd1HyA0kCE1uLms
	 stnJ4fkdKEcgvdxyrbe5zZdkWsO6CrTdg4BOrkpQCeAbV3Bg6QRtfN76MCUY+tqxuK
	 o8PDmGB5R8ZFbnkEpNhBqzcGfYpdbXtmc4Y5EENLCMVjlFp44nVdT1Ro+7SZEcc4xc
	 gIyvwBNZx2DLCQ0ybb7gxkH6OPSprIQ0ayuCT51XMg8fXB4bQIkRzWhJNyFmlBtrDz
	 U8WHYCoWclOeQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLX9-00000005hx6-2B8p;
	Mon, 26 Jan 2026 12:17:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 00/20] KVM: arm64: Generalise RESx handling
Date: Mon, 26 Jan 2026 12:16:34 +0000
Message-ID: <20260126121655.1641736-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Having spent some time dealing with some dark corners of the
architecture, I have realised that our RESx handling is a bit patchy.
Specially when it comes to RES1 bits, which are not clearly defined in
config.c, and rely on band-aids such as FIXED_VALUE.

This series takes the excuse of adding SCTLR_EL2 sanitisation to bite
the bullet and pursue several goals:

- clearly define bits that are RES1 when a feature is absent

- have a unified data structure to manage both RES0 and RES1 bits

- deal with the annoying complexity of some features being
  conditioned on E2H==1

- allow a single bit to take different RESx values depending on the
  value of E2H

This allows quite a bit of cleanup, including the total removal of the
FIXED_VALUE horror, which was always a bizarre construct. We also get
a new debugfs file to introspect the RESx settings for a given guest.

Overall, this lowers the complexity of expressing the configuration
constraints, for very little code (most of the extra lines are
introduced by the debugfs stuff, and SCTLR_EL2 being added to the
sysreg file).

Patches on top of my kvm-arm64/vtcr branch (which is currently
simmering in -next).

Marc Zyngier (20):
  arm64: Convert SCTLR_EL2 to sysreg infrastructure
  KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
  KVM: arm64: Introduce standalone FGU computing primitive
  KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
  KVM: arm64: Extend unified RESx handling to runtime sanitisation
  KVM: arm64: Inherit RESx bits from FGT register descriptors
  KVM: arm64: Allow RES1 bits to be inferred from configuration
  KVM: arm64: Correctly handle SCTLR_EL1 RES1 bits for unsupported
    features
  KVM: arm64: Convert HCR_EL2.RW to AS_RES1
  KVM: arm64: Simplify FIXED_VALUE handling
  KVM: arm64: Add REQUIRES_E2H1 constraint as configuration flags
  KVM: arm64: Add RESx_WHEN_E2Hx constraints as configuration flags
  KVM: arm64: Move RESx into individual register descriptors
  KVM: arm64: Simplify handling of HCR_EL2.E2H RESx
  KVM: arm64: Get rid of FIXED_VALUE altogether
  KVM: arm64: Simplify handling of full register invalid constraint
  KVM: arm64: Remove all traces of FEAT_TME
  KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
  KVM: arm64: Add sanitisation to SCTLR_EL2
  KVM: arm64: Add debugfs file dumping computed RESx values

 arch/arm64/include/asm/kvm_host.h             |  33 +-
 arch/arm64/include/asm/sysreg.h               |   7 -
 arch/arm64/kvm/config.c                       | 430 ++++++++++--------
 arch/arm64/kvm/emulate-nested.c               |  10 +-
 arch/arm64/kvm/nested.c                       | 151 +++---
 arch/arm64/kvm/sys_regs.c                     |  98 ++++
 arch/arm64/tools/sysreg                       |  82 +++-
 tools/arch/arm64/include/asm/sysreg.h         |   6 -
 tools/perf/Documentation/perf-arm-spe.txt     |   1 -
 .../testing/selftests/kvm/arm64/set_id_regs.c |   1 -
 10 files changed, 510 insertions(+), 309 deletions(-)

-- 
2.47.3

