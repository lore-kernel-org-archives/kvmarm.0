Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D322113B797
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752095671; cv=none; b=dTjak1jIk0O1hThrxuVYgQMoEDtSTCpGdk8e1C8rppYDclr9ymfDFTCgmwjHJiQw5bz9RpxXga4H5CJgosmchBBHX5lpO3Si1OjhlxP/bXQ00XetVjRnQs3LyPQjzvPpKN5TB4cFrvMG0um6MmXE2RDQx7UCS87kVk23IEcp4o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752095671; c=relaxed/simple;
	bh=26UxJr6CbmShfhHc4OzoAb5TUBLXb4/L+8N+9ITeDOU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jcYuc6BcArwSsKlD/LrL4ad9HAh2FNKFM9VKdxLF2YvVqzyZ18PPPk1menpbldMUocoJ/0W5KaKckNgC7A1WcemEahFDzKUL5LhMkw+s902pCkDdmUG0uDWPrWslBDrtavS26ca2UBryYyyD93D9IjhFki4KUXt9MVqJfxP0NzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r39Elf+u; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r39Elf+u"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752095666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gawA4kGhmtQz9va0a3vaXq1+FD3fiPWfSr0n9FP9Arw=;
	b=r39Elf+uzvDzN7eBMv/IPrmEAGek2E81V0RposBvhBZAJmIO0PKo3izji2GwUX6/7fv5PU
	qkE/DprQOVHpOb2dyeZxw/76BwZd1mmVoShWtGrxD7PVhvDJh+G5AWMgXviq7hTHcNp+Z6
	FH0sehxnemk3N+7hmoCyp88ye15f2Io=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 0/6] KVM: arm64: Allow userspace to write GICD_TYPER2.nASSGIcap
Date: Wed,  9 Jul 2025 14:14:11 -0700
Message-Id: <20250709211417.2074487-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Raghu -- sorry for stealing your series again. We've got another feature
under discussion that needs to allow writes to VGIC ID registers, I'd
like to have this in ASAP as a template.

This is hopefully the final take on this series, now modeled around
the GICD_TYPER2 register itself, allowing userspace to change the value
of it prior to initializing the VGIC.

Marc, looks like we do not allow GICD_IIDR to be written prior to init
after all. I've relaxed that register to have the same pre-init behavior
while still allowing it to be written post-init for ABI's sake.

Plan is for this to go in 6.17.

Oliver Upton (4):
  KVM: arm64: Disambiguate support for vSGIs v. vLPIs
  KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
  KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
  Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init

Raghavendra Rao Ananta (2):
  KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
  KVM: arm64: selftests: Add test for nASSGIcap attribute

 .../virt/kvm/devices/arm-vgic-v3.rst          | 17 +++++
 arch/arm64/kvm/vgic/vgic-init.c               | 16 ++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 70 ++++++++++++-------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 33 +++++++--
 arch/arm64/kvm/vgic/vgic-v4.c                 |  4 +-
 arch/arm64/kvm/vgic/vgic.c                    |  4 +-
 arch/arm64/kvm/vgic/vgic.h                    |  8 +++
 include/kvm/arm_vgic.h                        |  3 +
 tools/testing/selftests/kvm/arm64/vgic_init.c | 42 ++++++++++-
 9 files changed, 148 insertions(+), 49 deletions(-)


base-commit: 86731a2a651e58953fc949573895f2fa6d456841
-- 
2.39.5

