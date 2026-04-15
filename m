Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C2032AAC5
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254181; cv=none; b=pFSNmMxvdJHyxhmIYQW6UmZ5CR+kpvdf2bR0oeVBIbs/KCIclcxBBKHwmoGCV9b1FcjG8nXzNAxF2E87e4Mz7kcCZt8+s+k8PKUEmrwWmTON/RnRNciXUFbJW4KF8dDKSyNEqpkI65cHjPzTw+cG52zG6s78fy1rJ4YFLO7Iy7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254181; c=relaxed/simple;
	bh=+qvw/cNR5lgyckmvSm1tTdqwHPtUgkC0Qv6B2PrVngs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BkXaZ+3lrMmmL5NwmnWVjQclu4xFvXJ8zm7vYGR/aywt2RyIjxAPe6ebC6zO9+1WlcoaAoUKA+E7z/4zp1/wBoixZAIMnVqUHJ4un8vSHta6sIVkPzVeBgrz5tVPzLnpjiNKtUTtGTb/l7IIoN3dBa5xTxq2tmJvZgWO5WWe+Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmC5eyMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmC5eyMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE07C19424;
	Wed, 15 Apr 2026 11:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254181;
	bh=+qvw/cNR5lgyckmvSm1tTdqwHPtUgkC0Qv6B2PrVngs=;
	h=From:To:Cc:Subject:Date:From;
	b=KmC5eyMuR+XFPGaMlZqK3ijPc8id/M5/qf3x56MTWVXa2C1Mcmy9Si8onfRL+CedP
	 fKUB+g3ixmH7QMkS0BVUN2GriVjqmFOHg8gfHCDqAQ77Zt2jzpVjd0PFuXFKEUVUjZ
	 hi2a41QPnsYocHduW7YJykzs1Tcll3+9dt2XnJsn12bynMkI4m2O1OLgpP1Dh8WhXc
	 ihFUiOaVSYAcCTdQM8ZpaayDQy3DH0oidRR+7IvdlUXiITpAVM3w5x9Iu7FwA4VqNx
	 khtfX9wqQ3kUcYIsChcsYLAOtM2f+M1/XJZkwIPGt0sVfXxDYLyv0y53y6rGLDR49u
	 Q7Ryr452diABQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqx-0000000Bqsi-0aPT;
	Wed, 15 Apr 2026 11:56:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 00/18] KVM: arm64: Second batch of vgic fixes for 7.1
Date: Wed, 15 Apr 2026 12:55:41 +0100
Message-ID: <20260415115559.2227718-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With the GICv5 PPi support merged in, it has become obvious that a few
things could be improved, both from the correctness and
maintainability angles.

Sascha and I have been working on this, and this series is the sum of
our collective efforts.

The most important bits are related to the changes affecting the timer
for v3-on V5, and the corresponding change in the GICv5 host driver,
aligning it with its GICv3 counterpart.

Patches on top of kvmarm/next.

Marc Zyngier (9):
  KVM: arm64: vgic-v5: Add for_each_visible_v5_ppi() iterator
  KVM: arm64: vgic-v5: Move PPI caps into kvm_vgic_global_state
  KVM: arm64: vgic-v5: Remove use of __assign_bit() with a constant
  KVM: arm64: vgic-v5: Drop pointless ARM64_HAS_GICV5_CPUIF check
  KVM: arm64: vgic: Constify struct irq_ops usage
  KVM: arm64: vgic: Consolidate vgic_allocate_private_irqs_locked()
  KVM: arm64: vgic-v5: Drop defensive checks from
    vgic_v5_ppi_queue_irq_unlock()
  KVM: arm64: vgic: Rationalise per-CPU irq accessor
  KVM: arm64: vgic-v5: Limit support to 64 PPIs

Sascha Bischoff (9):
  KVM: arm64: vgic-v5: Add missing trap handing for NV triage
  KVM: arm64: vgic-v5: Atomically assign bits to PPI DVI bitmap
  KVM: arm64: selftests: Add missing GIC CDEN to no-vgic-v5 selftest
  KVM: arm64: selftests: Cleanup unused vars in GICv5 PPI selftest
  KVM: arm64: selftests: Improve error handling for GICv5 PPI selftest
  Documentation: KVM: Fix typos in VGICv5 documentation
  Documentation: KVM: Clarify that PMU_V3_IRQ IntID requirements for
    GICv5
  irqchip/gic-v5: Immediately exec priority drop following activate
  KVM: arm64: Fix arch timer interrupts for GICv3-on-GICv5 guests

 .../virt/kvm/devices/arm-vgic-v5.rst          |  6 +-
 Documentation/virt/kvm/devices/vcpu.rst       |  7 +-
 arch/arm64/kvm/arch_timer.c                   | 31 +++----
 arch/arm64/kvm/emulate-nested.c               |  8 ++
 arch/arm64/kvm/hyp/vgic-v5-sr.c               | 82 ++++---------------
 arch/arm64/kvm/sys_regs.c                     | 19 ++---
 arch/arm64/kvm/vgic/vgic-init.c               | 45 ++++------
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  9 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 51 ++++--------
 arch/arm64/kvm/vgic/vgic.c                    | 27 +++---
 arch/arm64/kvm/vgic/vgic.h                    |  3 +
 drivers/irqchip/irq-gic-v5.c                  | 13 +--
 include/kvm/arm_vgic.h                        | 19 +++--
 tools/testing/selftests/kvm/arm64/no-vgic.c   |  1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 10 +--
 15 files changed, 132 insertions(+), 199 deletions(-)

-- 
2.47.3

