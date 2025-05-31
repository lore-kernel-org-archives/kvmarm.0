Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3664A21
	for <kvmarm@lists.linux.dev>; Sat, 31 May 2025 01:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748654761; cv=none; b=bwgARBHl2nNu8FeF7zVT+g+mxY0TZs1PxjWV1yMVZ73bNgARgKa4m4uA19pKVfM7J7rzJO4K5/9XfGypaly7tejMRwQA+HTxkfslevfaqSXBz2VCdEACo15tKn2xvRBWomaWUgDSqOCGzNpQkLgT2bfvcn32eLr6Jwz3TBXLvh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748654761; c=relaxed/simple;
	bh=NMzCDBVA6Jwbp6bgbYi7zhjOCPs57oErrhOYbEk0Faw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NPfvUoo2qPNexm902o5UXw6/aPI03dNgRmUwRA901rIM40J6Mwy7zCjbFL1Ut/b2DPJ8ijEOzvJrw9GjFnG7fjiUTPY5x5ACJV2/rdVR9CBNRlz6sCtv1CJE9OYfT8AbvUoi1IwkZ8zuYjTwsoXuno3ite5++kWXxFb3oOXa7dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ICAefNPf; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ICAefNPf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748654755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4qgcf9CA8yuSqgpxE84a6xIK8JIit4KLm7YBZABk1vk=;
	b=ICAefNPfD2yEN5HvpCTJCyyMhw73h+k2KYncdtielcRVzJhG1msexBucnlENbgJwfEpo0f
	3Bo1YJRkFjionHvRywRrwMxvTaK4qmVbLGQlGqjcuziQx5PNsaVe/qk1u+aHjqJtmIOEZX
	+VKev5srbkZ0UQLk68rjYz5eLfsfHdE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/4] KVM: arm64: Add attribute to control GICD_TYPER2.nASSGIcap
Date: Fri, 30 May 2025 18:25:41 -0700
Message-Id: <20250531012545.709887-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Raghu, I applied this locally for review and wound up changing enough
things to where it was easier just to repost. Sorry, hope you don't
mind.

v1: https://lore.kernel.org/kvmarm/20250514192159.1751538-1-rananta@google.com/

v1 -> v2:
 - Drop all use of GICv4 in the UAPI and KVM-internal helpers in favor
   of nASSGIcap. This changes things around to model a guest feature,
   not a host feature.

 - Consolidate UAPI into a single attribute and expect userspace to use
   to read the attribute for discovery, much like we do with the ID
   registers

 - Squash documentation together with implementation

 - Clean up maintenance IRQ attribute handling, which I ran into as part
   of reviewing this series

Oliver Upton (2):
  KVM: arm64: Disambiguate support for vSGIs v. vLPIs
  KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling

Raghavendra Rao Ananta (2):
  KVM: arm64: Introduce attribute to control GICD_TYPER2.nASSGIcap
  KVM: arm64: selftests: Add test for nASSGIcap attribute

 .../virt/kvm/devices/arm-vgic-v3.rst          | 29 ++++++
 arch/arm64/include/uapi/asm/kvm.h             |  3 +
 arch/arm64/kvm/vgic/vgic-init.c               |  7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 88 +++++++++++++------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 24 +++--
 arch/arm64/kvm/vgic/vgic-v4.c                 |  4 +-
 arch/arm64/kvm/vgic/vgic.c                    |  4 +-
 arch/arm64/kvm/vgic/vgic.h                    |  7 ++
 include/kvm/arm_vgic.h                        |  3 +
 tools/testing/selftests/kvm/arm64/vgic_init.c | 41 +++++++++
 10 files changed, 172 insertions(+), 38 deletions(-)


base-commit: 1b85d923ba8c9e6afaf19e26708411adde94fba8
-- 
2.39.5

