Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAFC268C55
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748934524; cv=none; b=uL5Th3oPlQbSZ2wtuGu5lfyYeT2bQI4iQn+bwKCMmlsrnBoB/xhVl3QfnvFGTCsOYTpyy6haiylam6mDwXlNh2wMbsrv+QfYpnEvTek+luMDNN0kX1SRXW5j47P9nv4B3PPHnHeVtgND1XEBmITGKKZeNbUTG8a6F7iWjubztnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748934524; c=relaxed/simple;
	bh=vDjDeOJoD8W/7MpPea4jV/CiHifHXJQj4nT62rmfbH0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=USK/AC/Tuh9pItq5x0pZ6f3ImQ1HBzC5gwsIOpLv11skucIhXTcVoeboa5IgYLHMbUt5mSV0hDfU5ju3a+dbjc6HLAswpxAEr81tFe/s1xkcDM40WEAzoZd6322sHwP4JSf9ueKJ2f2F1HrqbGU/RJxj7bx/D7bBMLwH/cRONdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKOgFFTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKOgFFTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F0FC4CEF1;
	Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748934523;
	bh=vDjDeOJoD8W/7MpPea4jV/CiHifHXJQj4nT62rmfbH0=;
	h=From:To:Cc:Subject:Date:From;
	b=cKOgFFTOxm8K5q4Z9XUBlLZENU8u+clbftsXWTA2SRMZ5qpixPO98LIjPCTEISm2v
	 yqc2WP3xOgY2KdSf5gLRD2W0htHctVFyrrZ6ODHtwO5aLlaBL1lo6/HVR4bRLyyBul
	 HfzQoQgGmNgKCc3CR3PJxzgOFvfW11xHcBYzsGwmTVVcxjQuiVYDkkpZ6fHFd9o8+b
	 uQC48btiW4xZS7l9CfbxwQAeV1W/rJfAY21LXJuY+np0zaGKUzCFoERza+yjLCGZsX
	 IsGYd6yYUj2bEgwwqnFLypHb50hcpUqCUv1H5IJGHa/qxxI4JYNmVLruqoL90RHA/9
	 B2sbqRuEfyciA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uMLlJ-002isr-5r;
	Tue, 03 Jun 2025 08:08:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/4] KVM: arm64: vcpu sysreg accessor rework
Date: Tue,  3 Jun 2025 08:08:20 +0100
Message-Id: <20250603070824.1192795-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series tries to bring some sanity to the way the RESx masks
are applied when accessing the in-memory view of the guest's
system registers.

Currently, we have *one* accessor (__vcpu_sys_reg()) that can either
be used as a rvalue or lvalue while that applies the RESx masks behind
the scenes. This works fine when used as a rvalue.

However, when used as a lvalue, it does the wrong thing, as it only
sanitises the value we're about to overwrite. This is pointless work
and potentially hides bugs.

I propose that we move to a set of store-specific accessors (for
assignments and RMW) instead of the lvalue hack, ensuring that the
assigned value is the one that gets sanitised. This then allows the 
legacy accessor to be converted to rvalue-only.

Given the level of churn this introduces, I'd like this to land very
early in the cycle. Either before 6.16-rc2, or early in 6.17.

* From v1 [1]

  - rebased to kvmarm-fixes-6.16-1

[1] https://lore.kernel.org/all/20250113183524.1378778-1-maz@kernel.org/

Marc Zyngier (4):
  KVM: arm64: Add assignment-specific sysreg accessor
  KVM: arm64: Add RMW specific sysreg accessor
  KVM: arm64: Don't use __vcpu_sys_reg() to get the address of a sysreg
  KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand

 arch/arm64/include/asm/kvm_host.h          | 31 +++++++++--
 arch/arm64/kvm/arch_timer.c                | 18 +++----
 arch/arm64/kvm/debug.c                     |  4 +-
 arch/arm64/kvm/fpsimd.c                    |  4 +-
 arch/arm64/kvm/hyp/exception.c             |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  4 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  4 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |  4 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 48 ++++++++---------
 arch/arm64/kvm/nested.c                    |  2 +-
 arch/arm64/kvm/pmu-emul.c                  | 24 ++++-----
 arch/arm64/kvm/sys_regs.c                  | 60 +++++++++++-----------
 arch/arm64/kvm/sys_regs.h                  |  4 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c       | 10 ++--
 15 files changed, 125 insertions(+), 102 deletions(-)

-- 
2.39.2

