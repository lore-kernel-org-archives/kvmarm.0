Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5354E1C88
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 21:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717371; cv=none; b=nxvz/LmF1J4NaSPiRZmkiAZqZbf+/y5IL6evScboNfw1SvB8qA/U8m8KXosaIbPfQvbXnNUcwMHS03dxuEZdF+Yb70SY2BwjHgMUjrTPyu7OeJLIxOQFLUyudqU5i3kHiCBx+3lwP0tIDdT57wrJDs6g4fxnXYjsCcnf+OfZ37g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717371; c=relaxed/simple;
	bh=rm0qHNuqRK41Mkdi8hli3+vV+Nxnfg2XtKsP7fytjYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lwVOjYXa2cNSDarc7/EaJBLP37wiGZHRo06Ez+g3OyuRw0N92HMmSPhFOiMdj4ClXi+iwTU2uUaZ5eoNoL4pG3gVHU9nzaZ/Fwh/LwJArhOtDdf6swal5/j5eJ1d4bQS5fbGeXpvOzJ2ASdGkZN0zR+gYktXLmscT9e409sdT50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hk550CG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hk550CG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1471F000FF;
	Tue, 29 Sep 2026 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790717370;
	bh=JLTc6lkTJhEU8HLUPaifWNBFc2Bnw867ptaidTB+N70=;
	h=From:To:Cc:Subject:Date;
	b=hk550CG4RpphxyM5k5hLNdZsFkwrocnUsCSUvL3K1ql+0hSSDE0hORmnXxOlQioDJ
	 gQBUp/QaZTn16gZ/BwoC4wICx02O0cyq61Z5D1VCd6YY5xuTkwevgRiyII0usPZ8zd
	 9pLU1bD7R3/Pn1oCF4vMLWw3js9DG7UAk2c1WDTfwm2phpJ99aBDbsMioKa0gz62ne
	 j164QCL8cS8TZ3TpVz3uSFFnT3Y2ZEIEex6JZ5+EFw2IXx2XV7Oi5kymHds6B/9wjy
	 2ohXOxjJeJTmpwJsDYigA7BNcjSLH54c/9umPI3uqGUDh/FCzffNZYQ/S7pvBpKpuP
	 nF6DKGg1IXMvA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 0/4] KVM: arm64: vgic: Stop migrating IRQ from vgic_prune_ap_list()
Date: Tue, 29 Sep 2026 14:29:21 -0700
Message-ID: <20260929212925.31775-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VGIC has been getting a lot of undesired attention lately, as
there's plenty of weird and wonderful ways that the guest can play games
with KVM. My general impression on the whole matter is that modifying AP
lists remotely is a giant mess, with the worst offender being
vgic_prune_ap_list().

This series aims to sidestep the issue by only recalling IRQs from an AP
list if the vCPU has been paused. Keeping the overheads reasonable also
means adding support for pausing a single vCPU instead of the entire
VM, so update the eligible users of kvm_arm_halt_guest() to something
more relaxed while we're at it.

Marc, this series applies on top of your own for LPI malice [1]. You'll
note that I've taken some of it for 7.3 while leaving the rest for you
to take in 7.4, I'm perfectly happy with Patch 3 and 4 getting squashed
into the corresponding bits of your own series if you prefer.

Tested semi-rigorously on an Altra machine and the Orion board, using
both real guests and an LLM-generated selftest specific for migrating
pending LPIs. The latter was way too big to make sense of, I'll try and
post a test if I can it into something tidy.

[1]: https://lore.kernel.org/kvmarm/20260929093548.3598547-1-maz@kernel.org/ 

Oliver Upton (4):
  KVM: arm64: Add helpers to halt a vCPU
  KVM: arm64: vgic: Move IRQ migrations out of vgic_prune_ap_list()
  KVM: arm64: vgic-v3: Only pause the targeted vCPU when disabling LPIs
  KVM: arm64: vgic-v3: Pause the source vCPU when processing MOVALL cmd

 arch/arm64/include/asm/kvm_host.h  |   2 +
 arch/arm64/kvm/arm.c               |  18 ++-
 arch/arm64/kvm/vgic/vgic-its.c     |  19 ++-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  11 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  18 ++-
 arch/arm64/kvm/vgic/vgic.c         | 184 +++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic.h         |  24 ++++
 include/kvm/arm_vgic.h             |   1 +
 8 files changed, 164 insertions(+), 113 deletions(-)


base-commit: cfaf3b76669d386912a91103671691692f81c316
-- 
2.47.3

