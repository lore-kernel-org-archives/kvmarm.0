Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88912868AD
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 07:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756970913; cv=none; b=tH/vfbPiKB548cIXWRs8dao3UQXojqlfTlJ9LU9yiffIB25jnxSdLH8/tqphPdkO/h7NwdGQAqQBGKFmJJsHLejAK7F9dzuZ94p1964NZTcESAPvcN4SM48O9VZ1X0SPWvUqKabeyP/Q7vCbFCE274+Dxtp9ve34kJ+w5vIpofk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756970913; c=relaxed/simple;
	bh=cBXk1zuME5mPoWxJrbhKeqU6sOeaDcZt/44yFbgHYuU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fy2TzgguChnjVaQf/X+D4QIzqP76uH8wDoqDATAMZmFnymk5g/tlZy/rWgBUO3ijtKm6whuxQSJCH7wg6yz6v6zseSZ7kvSDxxLHvabiTWwDUVfQv2EpCy5SX1dLm9YMY0GhuUTnxU6ixIBbfbpBQOB/DiKVYhU9K8ZjeK6VrsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bc4U5BtB; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bc4U5BtB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756970907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dq1K2l8GLmezhxBKuzfJKwuUGmebYvdCC3KQBnaYDNA=;
	b=Bc4U5BtBsG+ChAeYiHkaq6bfuBWj1Wh6EqrW9gJ7E9EQjMiKJGnM1jzb8nxf/vJrPTqHyJ
	IO0NdlOBggdv3qKMNqXJwLrEFlbsTm1PkelVfsMftrhNVJmaI4ampnOGIUNDc1/CEeoyAW
	OYqkY6P0dzQGLsooHnSPVCHdKetKGDE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/5] KVM: arm64: vgic-v3: Fix yet another lock ordering turd
Date: Wed,  3 Sep 2025 23:23:43 -0700
Message-Id: <20250904062348.223976-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

syzkaller found yet another locking bug in the VGIC [*], this time due
to nesting a 'plain' spinlock (xa_lock) inside of a raw spinlock
(ap_list_lock). Given the way we do refcounts on LPIs it is possible
for this exact sort of issue to crop up where the last reference may
be dropped in unexpected places.

Small series to fix the issue by deferring xarray modifications outside
of the ap_list_lock critical section along with some slight lockdep
hinting to make these rare bugs a bit more obvious.

Applies to 6.17-rc4.

Oliver Upton (5):
  KVM: arm64: vgic-v3: Use bare refcount for VGIC LPIs
  KVM: arm64: Spin off release helper from vgic_put_irq()
  KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks
  KVM: arm64: vgic-v3: Don't require IRQs be disabled for LPI xarray
    lock
  KVM: arm64: vgic-v3: Indicate vgic_put_irq() may take LPI xarray lock

 arch/arm64/kvm/vgic/vgic-debug.c |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c  |  6 +--
 arch/arm64/kvm/vgic/vgic-its.c   | 15 +++---
 arch/arm64/kvm/vgic/vgic-v4.c    |  2 +-
 arch/arm64/kvm/vgic/vgic.c       | 78 +++++++++++++++++++++++---------
 arch/arm64/kvm/vgic/vgic.h       |  8 ++--
 include/kvm/arm_vgic.h           | 10 ++--
 7 files changed, 80 insertions(+), 41 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.39.5

