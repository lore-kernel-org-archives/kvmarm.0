Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421CC184D
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729124402; cv=none; b=pbcqDJo+WgEydURf5q4DwGdr/NxcGWAdAmo8cTRW4OyGeDtLv8Coi/gH3hc8cYkm8zA2UKbPdHC1LkFoEHSCiIe1DxW9Pno2AXXj7QAHbQpWVQrmGPO43L2zVBcNF5lmowoPYwofse8PVI/8gCh+UDwh75ZsvIER8JtVvRketzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729124402; c=relaxed/simple;
	bh=W9S3aEBQs4Xe/c31t3KPNF9p+Nn9Q5unM2gPYPXOE8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gXxMFv/dFsGyzuFBHwi7OraeG7b+qwDk88nmDgk+BvLXzz/ie3aBocXJIO3lXTxbpT57tHrX+wY3YY5NKJuTIhD2THV805FCWpoyzvghh1JQKHLuhJYoO4bSFmaFBTgoTEhdxskCk1iV9e/RQRPG7udQcIM1IRmM/OgIILm8WEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HC/9fEaJ; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HC/9fEaJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729124397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1KS/vTVuDnN8DucUm3NvFtoqZzs2aHUgHiSr9crl+7I=;
	b=HC/9fEaJHaXDO+7jHipmsZWWMi6IwI6hT62yY4omEEqnDUdsjrm2g25yF63Bm6YGWw4b2T
	cla042mWGqGS6E+uKnT45Aq2BXxoqXwvuZvkJrKXnTKxJqxviJ3CIRjr1TJ3hIwIKavicu
	s7cm4Zhzqjh1gIqt28G7Hdivmm1NDFY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Ensure VGIC is fully initialized before entering guest
Date: Thu, 17 Oct 2024 00:19:45 +0000
Message-ID: <20241017001947.2707312-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix for the race [*] that I had mentioned last week. The first patch
isn't entirely necessary, but it gets rid of a bogus check that could've
potentially raced with kvm_vgic_map_resources() as vgic_dist::ready is
no longer protected with the config_lock.

Applies to kvmarm/fixes.

Oliver Upton (2):
  KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
  KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration

 arch/arm64/kvm/vgic/vgic-init.c       | 13 +++++++++++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  7 ++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)


base-commit: df5fd75ee305cb5927e0b1a0b46cc988ad8db2b1
-- 
2.47.0.rc1.288.g06298d1525-goog

