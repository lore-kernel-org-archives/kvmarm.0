Received: from out-199.mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3313736AF1
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 20:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NedOA8L3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697144072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hH/6ryfUc+/tIlTi+eA+fuz2bDwWb8WV0AB+9dQDmYI=;
	b=NedOA8L32M+cDyND6QvzqfqcnLdb3In0MFMQTGs+kTKZ3vW7Y7+Kqu+ah1HfZXmKvHctMJ
	3QmhxnhCYVw7c9KUufz4iJK5WTm5PWLvkwr6wviD258P6i2XvuVUqxKyN0HZOhRagHed05
	z15uuhYNsvocYxIyG1q2e3jfQEC9aCU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/5] KVM: arm64: Load stage-2 in vcpu_load() on VHE
Date: Thu, 12 Oct 2023 20:54:17 +0000
Message-ID: <20231012205422.3924618-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Clearly my half-assed attempt at this series needed a bit of TLC.
Respinning with Marc's diff to make sure the stage-2 is in a consistent
state after VMID rollover and MMU notifiers triggering TLB invalidation.

v2: https://lore.kernel.org/kvmarm/20231006093600.1250986-1-oliver.upton@linux.dev/

Marc Zyngier (2):
  KVM: arm64: Restore the stage-2 context in VHE's
    __tlb_switch_to_host()
  KVM: arm64: Reload stage-2 for VMID change on VHE

Oliver Upton (3):
  KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
  KVM: arm64: Rename helpers for VHE vCPU load/put
  KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()

 arch/arm64/include/asm/kvm_host.h  |  6 +++---
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/arm.c               |  9 +++++---
 arch/arm64/kvm/hyp/vhe/switch.c    | 33 ++++++++++++++++++------------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 ++++------
 arch/arm64/kvm/hyp/vhe/tlb.c       | 18 ++++++++++++----
 arch/arm64/kvm/vmid.c              | 11 +++++++---
 7 files changed, 57 insertions(+), 33 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.655.g421f12c284-goog

