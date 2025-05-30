Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C069628C030
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 23:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748646399; cv=none; b=Do68BZ1YAxvbEsiMM5BLs53IXeEKjJe1PqaMteTVkJ5cutZajElL7mMkVbAoHgWPO6RxvZ+7yNyywsZucLPQPWfhQuwwLmMLZyOLusfNCcAhIeWfP3tMZ97YpWhXqiFzEpHeGz6vKj8Qg67W5Pm0ljC1AsiyRac5u9xRurAloGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748646399; c=relaxed/simple;
	bh=uTqsjo/yO3jpHxju/bz56x2fOcFT7LLp5YMH8vc+Zkg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=chOGcPEFOa4m4v9OEFB2xqW1Q6UJZ6GnGgfuKsP+q1SvTv22AY3WogJGw3We50T7gJq4go+j7t+24f4iK1zbZc8rLO4uHxSnMhuwVyUEEwAWY7B6Jm/G/4bssKuz6cPheKV6v7MQs1C0lIKI+1CZNO8oXUty9kPuaxtQ8L3FZP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VRSWuZ6W; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VRSWuZ6W"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748646394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PNOe14ezHpUqqE7eG+YotzmvCAay14BuhxPEiTNXx44=;
	b=VRSWuZ6WLHnanYyLj+4J6eh1DsyROydCXuC21hvBCgkHVbYygIcUkfUxcNgQpHstl7dipl
	RicaTWTZSlfXS+vuv289cG667N832uKYFICvd0XXz+qhXw9fQHbYcJYNiRy7M5Rqe6Lyyo
	Fnr7VXbCX2iq8Rz7lwweiOzwg004XVQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/4] KVM: arm64: nv: Fixes for external abort exception routing
Date: Fri, 30 May 2025 16:06:19 -0700
Message-Id: <20250530230623.650888-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

SEAs and SErrors come with a set of exception routing rules that are
potentially affected by EL2. KVM currently ignores these and just
injects the exceptions into the present context.

This series aims to address that, enlightening some of the injection
plumbing to the presence of vEL2. Additionally, patches 2 and 4 are
minor fixes for bugs that I found along the way.

Oliver Upton (4):
  KVM: arm64: nv: Respect exception routing rules for SEAs
  KVM: arm64: nv: Ensure Address size faults affect correct ESR
  KVM: arm64: nv: Honor SError exception routing / masking
  KVM: arm64: Treat vCPU with pending SError as runnable

 arch/arm64/include/asm/kvm_emulate.h | 31 ++++++++++--
 arch/arm64/include/asm/kvm_host.h    | 20 ++++++--
 arch/arm64/include/asm/kvm_nested.h  |  2 +
 arch/arm64/kvm/arm.c                 |  7 ++-
 arch/arm64/kvm/emulate-nested.c      | 53 ++++++++++++++++++++
 arch/arm64/kvm/guest.c               | 36 +++++++------
 arch/arm64/kvm/handle_exit.c         |  4 +-
 arch/arm64/kvm/inject_fault.c        | 75 +++++++++++-----------------
 arch/arm64/kvm/mmio.c                |  6 +--
 arch/arm64/kvm/mmu.c                 | 17 ++-----
 arch/arm64/kvm/nested.c              | 36 +++++++++++++
 11 files changed, 203 insertions(+), 84 deletions(-)


base-commit: 1b85d923ba8c9e6afaf19e26708411adde94fba8
-- 
2.39.5

