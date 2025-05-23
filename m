Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4618E78F44
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748029657; cv=none; b=oznUV4kB1+ayUmxY3PDhGb4lPMNaiOeO+pFuj8LWiz/qBz4jne0r0mjN+onmsbbGiapt3VtGeFBO7tiTUF3ae6Tg62A+i+gEh7gAN4zMWRBzrB2JpWEN0GhBvdumXQF6J5ygqUmdh2Q4xBQyBqHQOlgK0TxAPcN5Od6BrcsZKYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748029657; c=relaxed/simple;
	bh=HifGtNmoVBHSDFEsJvQK3ecLXgh5gzjIqEgpToLJDnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dSksS1T+Ot8EwPvwQs3/hGkZkUWyJjBd2sIjGOVHT0oN305VdjaLPtoDr02CfP0hvsorhUa1Z9IXuwZ6pcSI/05XW/QhAHCaNxn+0djQj4LqswHJFLDj1eKBehIwuc1saxUKfzkBp+PFmt8t0DTA1D5q/G2cTPU9suSYAH9HdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EemyDbaj; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EemyDbaj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748029651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EIpV72zE6l87qdU1t5vWmSJUV4H3BaimKJ5yYmgWBJ8=;
	b=EemyDbajPhcSDToMDcaITfM2hkTIiAk6KYFTO//UGekn4mhIccn/EJnvLJxfUxJaRpGASE
	HNGHGl5nJTOmE6gKR1rNg4vJHje3ikO6qNLKO0AuiZ3CK82X2dQXcrOv6xvTUmjVFLMo+g
	aZxI3jDYg927zxXqvuEmW3ChJfhCvek=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/5] KVM: arm64: Some VGIC-related fixes
Date: Fri, 23 May 2025 12:47:17 -0700
Message-Id: <20250523194722.4066715-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v1 -> v2:
 - Added details to changelog about why its_lock gets removed later from
   vgic_v4_unset_forwarding() (Marc)
 - Fix email address for Sweet Tea's Tested-by tags (sorry about that!)

v1: https://lore.kernel.org/kvmarm/20250523160810.4049313-1-oliver.upton@linux.dev/

Oliver Upton (5):
  KVM: arm64: Use lock guard in vgic_v4_set_forwarding()
  KVM: arm64: Protect vLPI translation with vgic_irq::irq_lock
  KVM: arm64: Resolve vLPI by host IRQ in vgic_v4_unset_forwarding()
  KVM: arm64: Unmap vLPIs affected by changes to GSI routing information
  KVM: arm64: vgic-init: Plug vCPU vs. VGIC creation race

 arch/arm64/kvm/arm.c            | 26 +++++++++-
 arch/arm64/kvm/vgic/vgic-init.c | 27 +++++++++-
 arch/arm64/kvm/vgic/vgic-its.c  | 48 ++++++++---------
 arch/arm64/kvm/vgic/vgic-v4.c   | 92 ++++++++++++++++++---------------
 include/kvm/arm_vgic.h          |  3 +-
 5 files changed, 125 insertions(+), 71 deletions(-)


base-commit: 1b85d923ba8c9e6afaf19e26708411adde94fba8
-- 
2.39.5

