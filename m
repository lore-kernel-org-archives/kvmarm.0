Received: from out-204.mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5534315AFB
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 23:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tRvOKSKj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697671941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jpOwTv4tY21pG4DLhEtXKahT34MLmNDzJzx+MDEsAF8=;
	b=tRvOKSKjR8m09bve4II6HOD35gUDu/S8yrHB4hup64GKJuzhn+o4urYzUu4YomGvQcLoXW
	Iftt61verYZnV7MLU6Aawgpwmmpjr25uqvq32X5q0di+b980cYl7prYelsOW1qLS31ii4r
	Z2U2eYT2O2nNhskZVZufA+AfsCts+ao=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/5] KVM: arm64: Load stage-2 in vcpu_load() on VHE
Date: Wed, 18 Oct 2023 23:32:07 +0000
Message-ID: <20231018233212.2888027-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks Zenghui for the review, I've addressed your feedback.

v2: https://lore.kernel.org/kvmarm/20231012205422.3924618-1-oliver.upton@linux.dev/

v2 -> v3:
 - Save the right context in __tlb_switch_to_guest()
 - Drop stale declarations from kvm_hyp.h
 - Fix typo in changelog

Marc Zyngier (2):
  KVM: arm64: Restore the stage-2 context in VHE's
    __tlb_switch_to_host()
  KVM: arm64: Reload stage-2 for VMID change on VHE

Oliver Upton (3):
  KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
  KVM: arm64: Rename helpers for VHE vCPU load/put
  KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()

 arch/arm64/include/asm/kvm_host.h  |  6 +++---
 arch/arm64/include/asm/kvm_hyp.h   |  7 ++-----
 arch/arm64/kvm/arm.c               |  9 +++++---
 arch/arm64/kvm/hyp/vhe/switch.c    | 33 ++++++++++++++++++------------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 ++++------
 arch/arm64/kvm/hyp/vhe/tlb.c       | 18 ++++++++++++----
 arch/arm64/kvm/vmid.c              | 11 +++++++---
 7 files changed, 57 insertions(+), 38 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.655.g421f12c284-goog

