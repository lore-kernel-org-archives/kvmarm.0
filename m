Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044B91D514B
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214483; cv=none; b=pJfbOc5BuXR4GHx48WhkmZOTrZs26jKnmcRgxUr0jGlFhLnv6pfk6qO/2OiDBbctBbVLW4nKOTKrCCZKsE8UiBL+3CLI0E5LkgmZyJzCK5Pqo1tEVN/RGpdZNCMXV2uS3iXaqfig+pj+4TyZr92V13eTI8RlwixQno5BC2yBOwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214483; c=relaxed/simple;
	bh=TxlTgX+2KxlezUcYIU53c1C9S/07ZENXKrK6moE2IX4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MI3NUhXbIodT9IUqAG62h9xfjBlIX1g57wAMiZZXsrinCzPD+kJdf25WEqO6q0xmI4eIftWNe8uPjqzPQ22+ynVAgkEcpDihWFTJinrHtAHOOVDvGc5HTQbwXv9HQRaoOtSQL6IjpNVDRNsL415PK4cl6UZytxZsdupK5F9R7Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfWCnatJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfWCnatJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93367C4CEE9;
	Wed,  9 Apr 2025 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214482;
	bh=TxlTgX+2KxlezUcYIU53c1C9S/07ZENXKrK6moE2IX4=;
	h=From:To:Cc:Subject:Date:From;
	b=MfWCnatJDbL67OwmTSK9e1l7miKAxnuXSj4A7+cly8IIxtSL5wGm8Z5rLl4zftGlW
	 8XyjYTQVtSNeBjmP3S+c/urrGhhqTJRuEtJ3PSmyRlI1SRUsZ0jvR5sLMqz5H0Nz88
	 zLOKaMhthEpx/gIky6eR040iI8Ul9+vESzDk7uUyE6AYh7fxz4W9UrBSfGpQ/vByBo
	 2EGd/jd2ZZ/6XOst9sgP03f06ydlTu6dLFxNNOuBTLloqdGsRuO8+I/bP8KLpI8gFs
	 sRuSuUmFxsoKEKmmBdn8yv8WOeWfhCbGO8LeyAclsMMoucrHGx7D8dQeOaQmtihdV8
	 q/yaYHTG5DkZg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u2Xrb-003vQT-PF;
	Wed, 09 Apr 2025 17:01:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 0/6] KVM: arm64: EL2 PMU handling fixes
Date: Wed,  9 Apr 2025 17:01:00 +0100
Message-Id: <20250409160106.6445-1-maz@kernel.org>
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

Joey reports that some of his PMU tests do not behave quite as
expected:

- MDCR_EL2.HPMN is set to 0 out of reset

- PMCR_EL0.P should reset all the counters when written from EL2

Oliver points out that setting PMCR_EL0.N from userspace by writing to
the register is silly with NV, and that we need a new PMU attribute
instead.

On top of that, I figured out that we had a number of little gotchas:

- It is possible for a guest to write an HPMN value that is out of
  bound, and it seems valuable to limit it

- PMCR_EL0.N should be the maximum number of counters when read from
  EL2, and MDCR_EL2.HPMN when read from EL0/EL1

- Prevent userspace from updating PMCR_EL0.N when EL2 is available

I haven't added any Cc stable, as NV is not functional upstream yet.

* From v1 [1]:

  - Added patch for the new PMU attribute
  - Added fix for HPMN limit
  - Prevent update of PMCR_EL0.N with NV
  - Fix kvm_vcpu_read_pmcr()
  - Rebased on 6.15-rc1

[1] https://lore.kernel.org/r/20250217112412.3963324-1-maz@kernel.org

Marc Zyngier (6):
  KVM: arm64: Fix MDCR_EL2.HPMN reset value
  KVM: arm64: Contextualise the handling of PMCR_EL0.P writes
  KVM: arm64: Allow userspace to limit the number of PMU counters for
    EL2 VMs
  KVM: arm64: Don't let userspace write to PMCR_EL0.N when the vcpu has
    EL2
  KVM: arm64: Handle out-of-bound write to HDCR_EL2.HPMN
  KVM: arm64: Let kvm_vcpu_read_pmcr() return an EL-dependent value for
    PMCR_EL0.N

 Documentation/virt/kvm/devices/vcpu.rst | 24 ++++++++++++
 arch/arm64/include/uapi/asm/kvm.h       |  9 +++--
 arch/arm64/kvm/pmu-emul.c               | 51 ++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c               | 43 ++++++++++++++++-----
 4 files changed, 107 insertions(+), 20 deletions(-)

-- 
2.39.2

