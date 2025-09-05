Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C61836CC9E
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 14:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757082106; cv=none; b=AbtODGjTraHpOFR+3rxQvF30cXWS/7Q1ToDMNoCjHy/Fv18X65iApU8eFD28RghfAxZK4mNPnFWr/8Yt0JV15gRIePH3x1qqoMf9kz/e02bhAY751ZJQzBH/qhepBRqLQqlnuR+3VBZtXuSP510vg52wb0wQXlu16iyuW4SNNRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757082106; c=relaxed/simple;
	bh=l2X2gD8rpVn93k+Ce9cWSPWhKVrm+9ailUyBS3fkx/0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VrQPKws9cxsxBEkEuzVIdoq3eeaqK7Ia/Jhkp3u9QFUvI8DJ7sD4bM97pS7+UzMKyd+Ik4CIryQ0/+9hclqqSoAwvTEKOIGv1kHjOOJgHjpyN40ibAqABQUomCjITnCDdsG0ybst3U26bYnobxW2g0WW3R13r6R5fokCbTkPlwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uuAQuaO7; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uuAQuaO7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757082103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7XOlyl1+L/F/x+ZmZ8UGrxdRSg53IZ3sEh1L9YH8CEU=;
	b=uuAQuaO7vaTwnWMD5OOXam/pXtzQ81Af8+GJXlnscu3ewesdZ07QB7u+IQq6KfsNfnuyLT
	60YYyhY5ZmRaXBAH/xaaBl+dMkRihajv2sK+RreiT9LyX83j58YmXCYZEpWD9er6JPlNDp
	DQbsaejXwKiuGNspZO8QUWDI2fbXZyw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/6] KVM: arm64: vgic-v3: Fix yet another lock ordering turd
Date: Fri,  5 Sep 2025 03:05:25 -0700
Message-Id: <20250905100531.282980-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v1: https://lore.kernel.org/kvmarm/20250904062348.223976-1-oliver.upton@linux.dev/

v1 -> v2:
 - Drop union misbehavior + misleading comment (Marc)
 - Fix LPI check to include the first one (Ben)
 - Clarify changelog to make lock relaxation slightly more obvious

Oliver Upton (6):
  KVM: arm64: vgic: Drop stale comment on IRQ active state
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
 include/kvm/arm_vgic.h           |  9 ++--
 7 files changed, 79 insertions(+), 41 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.39.5

