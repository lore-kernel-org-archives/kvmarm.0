Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3085648C8D7;
	Thu, 15 Oct 2026 10:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058746; cv=none; b=dev82UbUxFhLAGD9gLa9qLfrQmGrbh+kPPKTAPUz0ceDXjTlAX9QMYXTTJvPxoT5tMMtFSPDI1YJav0V5Tnl8fbPicxS5VAHQkFt1g2H18Zkav6yzYJnj5w/9/zAvx9DCc7Kr7a25MqwCNm92hVNmZADw0wjnbw/ceXFqP3cbzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058746; c=relaxed/simple;
	bh=ck0rw/kzwTeA8DIITnSvou9ZIQdgWos5PNKDTO8WP44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pg73B6SEbMjNbL+cAYP69EQIGtm7vCLF4lucVC+reDYfDPByQt8GJHehWnXL3V28ppemLMSd6rwfAKHjP/tWpGyrWU+ioesVRKdJkESWzugFtlrlJKL2yl8Ilqv4uYcyr0pcx0wAr/Glbh3/V3wbg1BSW3mvXspNRvBN9X1uISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ddg/nBt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ddg/nBt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D331F000C5;
	Thu, 15 Oct 2026 10:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792058744;
	bh=O2M4w/ZFagUjIv202JHTtOzgBHFi+5K/W5bohYPHYz8=;
	h=From:To:Cc:Subject:Date;
	b=Ddg/nBt6jS+ELONe4oMAh0lQ+r3B91fEWE+/uzkG/CE13m3UYxb+yq0MMLIbkxhwy
	 vfbplBvUmBCiZF15fjrTcYiDGrUo7mbWHObJ/xIfNE+iBhBj3e7mPSmlh7J4mqmeqn
	 ZIrnGLaRuEMhOY3u9KnazIgXosIrTP+e4hxtRX1/58mWp8WjqbuhEz90FZY2ZpoBtN
	 LXPdpTRTzgGzpND6cstTj/UKSH0giaL/kKjXRdkYJTosJtNZz52UKsU1UWEHZbf4fg
	 +1jt1wdJ2Sm95wh029vsherJnGq4jEn93am6b3YWFyfuSkUxFWb1zV+yRO+ZL9w3Uz
	 USgIY/FHtMSSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xHILG-00000003EfK-1xhU;
	Thu, 15 Oct 2026 10:05:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 0/7] KVM: arm64: Fix cross-CPU vcpu pausing
Date: Thu, 15 Oct 2026 11:05:32 +0100
Message-ID: <20261015100539.1011760-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series is a follow-up on what I previously posted at [1], and has
now grown a few more fixes, and inherited an improvement from Oliver.
Some of the fixes have already been merged, so what we have here
serves a slightly different goal.

As we are simplifying (and fixing) a bunch of vgic behaviours, it
becomes necessary to pause one (or all) vcpu(s) and *reliably*
introspect the state of interrupts.

It appears that the current KVM behaviour is remarkably broken:

- OUTSIDE_GUEST_MODE is published too early, before we have resynced
  the state, making it unreliable

- IN_GUEST_MODE is published too late, once we have already placed
  volatile state on the CPU (interrupts, for example), and making the
  in-memory state stale (edge pending bits are a particular sore spot)

- self-generated requests are sometimes posted too late, after we have
  committed to entering the guest, and are therefore delayed

- the pausing mechanism itself is unreliable, as it has no requirement
  to be called whilst holding a global lock, and therefore is able to
  nest, while it is backed by a simple boolean

This series addresses these defects, and builds on top of it to:

- add pausing to a single vcpu in addition to the full VM pausing

- convert LPI disabling and the MOVALL command to vcpu pausing

Patches on top of -rc6, most of them being Cc stable without any
qualification (this has been broken for as long as I can remember).

[1] https://lore.kernel.org/r/20260929093548.3598547-1-maz@kernel.org

Marc Zyngier (6):
  KVM: arm64: nv: Move L2->L1 switch on interrupt early
  KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being
    saved
  KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded
  KVM: arm64: Turn vcpu->arch.pause into a counter
  KVM: arm64: vgic: Stop the target vcpu when disabling LPIs
  KVM: arm64: vgic-its: Stop the VM when handling MOVALL

Oliver Upton (1):
  KVM: arm64: Add helpers to halt a vCPU

 arch/arm64/include/asm/kvm_host.h  |  9 ++--
 arch/arm64/kvm/arm.c               | 69 ++++++++++++++++++++----------
 arch/arm64/kvm/nested.c            |  8 ++++
 arch/arm64/kvm/vgic/vgic-its.c     | 11 +++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 10 +++++
 arch/arm64/kvm/vgic/vgic.c         |  8 +---
 6 files changed, 81 insertions(+), 34 deletions(-)

-- 
2.47.3

