Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACE13CBE6C;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039791; cv=none; b=NydFP1e6oui3Al3xYfqRINzt516M6mRV94fSnVQjpwWuPixGuc0aeIKsgJVs1wlZxRP16UD45MzPXEWHqTZmSC1OOyHnjB4XmUPa9JrwJ8VtTM8RihI6Zd6NUgYrtCyONlVY1CI+GWin6UfDBTUeJpCKXd9Y1bHlsESd8Kz+D1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039791; c=relaxed/simple;
	bh=+QCbdHNHmHFia4f4ihvIccWXyxvqGeamB1Ak1UNFefk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U38yg1OW2RJODHC4Ak98Il0ltwHixDBDxSZbr9XTQ/heXMJINOCcMq1bdNFDGVZoKKvHsSOKr2KsnwgkRnhsG6sQ1rlLkBb1fSnNUekfYn5xiH/3/q6NujSJxQyMzNfzpwB4FwP9J23ZCjIfBurDr2rliwEAh/jw9SQ6AlWDRdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUtTc+qd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUtTc+qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE9AC4CEF7;
	Wed,  1 Apr 2026 10:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039791;
	bh=+QCbdHNHmHFia4f4ihvIccWXyxvqGeamB1Ak1UNFefk=;
	h=From:To:Cc:Subject:Date:From;
	b=HUtTc+qdBZnLXKPylb0z1+68iCLw5jkX1/ut0r6g/SMeABYvS+8ZmNqnA0AFwuA37
	 A/D46LyZvWkT2WkTX3s/Mm70TO6LslwBShA5UOhSK3fg7PW2O0Csg+PqsiZthfyAat
	 KBtKcLv1xeEa/AF4n67RfIylxJswxIDwS+9QlVTo228wmSuefAXQWKom0TRAfxVfCY
	 k8c+FiN25qiNwqTGWOU4taEH/W2mMd14FwaF64ZblEUZXNtk/sSnfZDzPzGxmK5vb3
	 jglbWUv6YN04xPQ1LsbD10tKpeoGXVIr0JDi98lpg6KljUmmNWFFG8IT+HRvFTUNYI
	 f6rvptv5L7pHA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw1-00000007oRQ-0SVj;
	Wed, 01 Apr 2026 10:36:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 00/16] KVM: arm64: First batch of vgic-v5 related fixes
Date: Wed,  1 Apr 2026 11:35:55 +0100
Message-ID: <20260401103611.357092-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the second revision of this series attempting to fix a number
of issues reported on the vgic-v5 PPI series.

* From v1 [1]:

  - Partially reverted the effective priority mask fix, as Sascha
    pointed out the crucial difference in the way GICv5 manages the
    PCR compared to GICv[234]'s PMR.

  - Added a fix for dealing with the pending HW-backed PPIs.

  - Added a workaround for the set_id_regs selftest, already posted
    separately, but included here for completeness (and ease of
    merging).

Patches on top of my kvm-arm64/vgic-v5-ppi branch.

[1] https://lore.kernel.org/r/20260326153530.3981879-1-maz@kernel.org

Marc Zyngier (16):
  KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
  KVM: arm64: Don't skip per-vcpu NV initialisation
  arm64: Fix field references for ICH_PPI_DVIR[01]_EL2
  KVM: arm64: Fix writeable mask for ID_AA64PFR2_EL1
  KVM: arm64: Account for RESx bits in __compute_fgt()
  KVM: arm64: vgic-v5: Hold config_lock while finalizing GICv5 PPIs
  KVM: arm64: vgic-v5: Transfer edge pending state to ICH_PPI_PENDRx_EL2
  KVM: arm64: vgic-v5: Cast vgic_apr to u32 to avoid undefined
    behaviours
  KVM: arm64: vgic-v5: Make the effective priority mask a strict limit
  KVM: arm64: vgic-v5: Correctly set dist->ready once initialised
  KVM: arm64: Kill arch_timer_context::direct field
  KVM: arm64: Remove evaluation of timer state in
    kvm_cpu_has_pending_timer()
  KVM: arm64: Move GICv5 timer PPI validation into
    timer_irqs_are_valid()
  KVM: arm64: Correctly plumb ID_AA64PFR2_EL1 into pkvm idreg handling
  KVM: arm64: Don't advertises GICv3 in ID_PFR1_EL1 if AArch32 isn't
    supported
  KVM: arm64: set_id_regs: Allow GICv3 support to be set at runtime

 arch/arm64/kvm/arch_timer.c                   | 32 +++++-------
 arch/arm64/kvm/config.c                       |  4 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  2 +-
 arch/arm64/kvm/sys_regs.c                     | 20 +++----
 arch/arm64/kvm/vgic/vgic-init.c               | 32 ++++++++----
 arch/arm64/kvm/vgic/vgic-v5.c                 | 24 +++++++--
 arch/arm64/tools/sysreg                       |  4 +-
 include/kvm/arm_arch_timer.h                  |  3 --
 .../testing/selftests/kvm/arm64/set_id_regs.c | 52 ++++++++++++++++---
 9 files changed, 115 insertions(+), 58 deletions(-)


base-commit: ce29261ec6482de54320c03398eb30e9615aee40
-- 
2.47.3

