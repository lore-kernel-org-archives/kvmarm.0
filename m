Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7081AD32
	for <kvmarm@lists.linux.dev>; Thu, 16 Mar 2023 21:14:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679001265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1YvQL41zYrATTU0Luq6nSMyn7+ylWGdh70Ui67rDKGE=;
	b=Jn8eQfS8Aeyuvk+lHWpWVSAkcidsRIcEvCBjwq77VzYkm0qIpgiayEliE9evOLXw4SqQjP
	lxVPSBFvP4BiGtcxNa3rLbAKd218kByPHam2JyLAtVmaZF8ImT6R/WSr+mDWXJ22bjZ5ti
	WFD6ms6klL7pKC5zg4TJv9WVfLv0QIU=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/4] KVM: arm64: Fix vcpu->mutex v. kvm->lock inversion
Date: Thu, 16 Mar 2023 21:14:08 +0000
Message-Id: <20230316211412.2651555-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As it so happens, lock ordering in KVM/arm64 is completely backwards.
There's a significant amount of VM-wide state that needs to be accessed
from the context of a vCPU. Until now, this was accomplished by
acquiring the kvm->lock, but that cannot be nested within vcpu->mutex.

This series fixes the issue with some fine-grained locking for MP state
and a new, dedicated mutex that can nest with both kvm->lock and
vcpu->mutex.

Tested with kvmtool and QEMU scaled up to 64 vCPUs on a kernel w/
lockdep enabled. Applies to kvmarm/next.

v1: http://lore.kernel.org/kvmarm/20230308083947.3760066-1-oliver.upton@linux.dev

v1 -> v2:
 - Add a dedicated lock for serializing writes to MP state
 - Inform lockdep of acquisition order at time of VM/vCPU creation
 - Plug a race with GIC creation (Sean)
 - Use the config_lock in GIC ITS flows as well. There is now a single
   (valid) use of kvm->lock when enabling MTE.

Oliver Upton (4):
  KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
  KVM: arm64: Avoid lock inversion when setting the VM register width
  KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
  KVM: arm64: Use config_lock to protect vgic state

 arch/arm64/include/asm/kvm_host.h     |  4 ++
 arch/arm64/kvm/arm.c                  | 45 +++++++++++++++++++----
 arch/arm64/kvm/guest.c                |  2 +
 arch/arm64/kvm/hypercalls.c           |  4 +-
 arch/arm64/kvm/pmu-emul.c             | 23 +++---------
 arch/arm64/kvm/psci.c                 | 19 +++++-----
 arch/arm64/kvm/reset.c                | 16 ++++----
 arch/arm64/kvm/vgic/vgic-debug.c      |  8 ++--
 arch/arm64/kvm/vgic/vgic-init.c       | 33 ++++++++++-------
 arch/arm64/kvm/vgic/vgic-its.c        | 29 ++++++---------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 53 ++++++++++++---------------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c       | 12 +++---
 arch/arm64/kvm/vgic/vgic-v4.c         | 11 +++---
 arch/arm64/kvm/vgic/vgic.c            |  2 +-
 15 files changed, 146 insertions(+), 119 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

