Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842523BED0C
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268814; cv=none; b=d5XyGM0VokGoUKp/srRv2bwi2Mb09qT09/O+J18aWkrmxaxQIJ5YGrPPeotgH/yS3CE3l1+iDTsl0jqmgdy8VuT7pFDZhGZmkm1h6uxeAo889A7pSFMZWNTAp1MCS8AicKUNHZjFsQOssjORCMIzIEWQNBCrAnD72gSX2KbvTL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268814; c=relaxed/simple;
	bh=TGJQmtbSiP9azTwUVdzt+kkZ8/nNplEeIqsmNrh7dKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UzhHEeCPK/dOw28IvZcb0VDkztVmFL+Xu4Ke+6zU4aMQCW28+pRGZwLX85Hs7z2ed3rLyyITnvL7HrwWMi1aMDPpNwseUoLu/GjBbt3YKh47ZDWVEViqKZ3qaWfEvb+H/AEP1Z2yCmZ98iNimUhQeX451KKR86WIjUauS+t5pz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiyUsquS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiyUsquS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE171F00893;
	Wed, 20 May 2026 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268812;
	bh=8+SRIXb2EC27fQJGeFQBobVsfJFKqxmSb21xBPCc05Y=;
	h=From:To:Cc:Subject:Date;
	b=kiyUsquSM9fLU8RCEgybaCgLkg2v5vmgL2OHEaTf9f/73v7YJ9Fkn0M6asfzp4mgJ
	 59fCq+OAIjxTGJiYeVGL2MwSyWEqsvuORkCzH1E1s6HdqmXJhZcjjl94Bs4nHZ2m4W
	 iIzK/Hx7QkMYkEQde3/eAaeL0AMwEFEXFTfXj511ozQTI8UXdV9AKbC/h0locHL4rq
	 Ymyef2PoJHA0mKgvsKEycPmTjZedGzkI6aKwai20bHO9Hwd/5gg0i72E8EV2tp5lj3
	 +UOd0t+xGSzPRKR46lcrES00wsDGV4fwv8uVh20HmMfewkshbE7LnnkfJMdumbeDaD
	 MOeZT0YrRwHeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd62-00000004IaV-0Xct;
	Wed, 20 May 2026 09:20:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 00/18] KVM: arm64: vgic-v5 fixes for 7.2
Date: Wed, 20 May 2026 10:19:31 +0100
Message-ID: <20260520091949.542365-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Having completely missed the 7.1 window, this is a repost of this
series cleaning-up the vgic-v5 PPI support now targeting 7.2.

Not a lot has changed since v1 [1], only the documentation typo
spotted by our eagle-eyed Joey.

[1] https://lore.kernel.org/r/20260415115559.2227718-1-maz@kernel.org

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

