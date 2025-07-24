Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992731EA7DF
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753338504; cv=none; b=bSoY9OZYV5E5lSczdsEv03Q1Gebt/978Y2L22i7XOpliVaDZGYZgGep+Kp/pckcWvTZ0eTRlW8aZ2oJtrB5E8RdZvP/EmAkYsK50VqW6NZoekLv3zwef38CFvIpgWNbsj9ow2Ci2NFei8OtwS8ev+/DF6ztu94k3jqC4RgfZXuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753338504; c=relaxed/simple;
	bh=k6Kq8eCf90rUCFXe+vmASvClgHQnQ4Zq65lzwbF5fsI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A1mcNPAjxMvRTaALSWHbEq0jcPWDmszkcyZP8aMiXK8EzX7fArWItB3gj2At2/NE6XRmLowzW77WODoY1TtAibSOLYIy9fguuww8DqD2ywXpNNWvHRL0LSdmEcfx21UTTl7PpHlwB4zEXrgCcIiSu73KO4vKzzVbMkIg8ODRx1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M11I32wA; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M11I32wA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753338499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NJ3YYah/o/dul5vflTXDKWEJHxQ36mQYBjF0hvJn370=;
	b=M11I32wAw9HBFIn9G1AIx/YB5CxRiMF1Ztxo26g7gsQxepNHTBe5zHzuLthRVdx2rC5vl6
	0ZJj3mzD2o6HP1JX2kb10nO5AyfGMVZcRjxezuTaqACnGNwEEt/qzfNvqMMFuuP7wJpsyt
	KoA9dyMS26PcgQs3lETGgAFcZbkM6bE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eauger@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 0/6] KVM: arm64: Allow userspace to write GICD_TYPER2.nASSGIcap
Date: Wed, 23 Jul 2025 23:27:59 -0700
Message-Id: <20250724062805.2658919-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v4 -> v5:
 - Fix polarity of nASSGIreq masking (Ben)
 - Explicitly call out some subtle changes made in changelogs (Eric)
 - Avoid open-coding irq_is_ppi() (Eric)

Oliver Upton (4):
  KVM: arm64: Disambiguate support for vSGIs v. vLPIs
  KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
  KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
  Documentation: KVM: arm64: Describe VGICv3 registers writable pre-init

Raghavendra Rao Ananta (2):
  KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
  KVM: arm64: selftests: Add test for nASSGIcap attribute

 .../virt/kvm/devices/arm-vgic-v3.rst          | 17 +++++
 arch/arm64/kvm/vgic/vgic-init.c               | 21 +++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 70 ++++++++++++-------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 33 +++++++--
 arch/arm64/kvm/vgic/vgic-v4.c                 |  4 +-
 arch/arm64/kvm/vgic/vgic.c                    |  4 +-
 arch/arm64/kvm/vgic/vgic.h                    |  8 +++
 include/kvm/arm_vgic.h                        |  3 +
 tools/testing/selftests/kvm/arm64/vgic_init.c | 42 ++++++++++-
 9 files changed, 150 insertions(+), 52 deletions(-)


base-commit: 86731a2a651e58953fc949573895f2fa6d456841
-- 
2.39.5

