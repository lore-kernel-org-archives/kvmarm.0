Received: from out-205.mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4844AF9D9
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 09:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qMeeXG8m"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696584973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4L7QKCIOuLwlmI4f8DHHeZCgEjiZggyjVQSyHHX4IiA=;
	b=qMeeXG8mB1qR2yjfqx1xXD732ta9yS/cPbDc9TeN/AVUWPhDCMZSIlgX1MakvBLDyryMy9
	0J7SmC3adV18e1/18temoN8nd8dKsxjp94L3sq1AwrYN313fVnmKbhYtaHweZu0pZJ/kOJ
	YNQg7P5WUTEQTzmAbIoRXl6BVvm/Hsw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Load the stage-2 MMU from vcpu_load() for VHE
Date: Fri,  6 Oct 2023 09:35:57 +0000
Message-ID: <20231006093600.1250986-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Unlike nVHE, there is no need to switch the stage-2 MMU around on guest
entry/exit in VHE mode as the host is running at EL2. Despite this KVM
reloads the stage-2 on every guest entry, which is needless.

This series moves the setup of the stage-2 MMU context to vcpu_load()
when running in VHE mode. This is likely to be a win across the board,
but also allows us to remove an ISB on the guest entry path for systems
with one of the speculative AT errata.

None of my machines affected by the AT errata are VHE-capable, so it'd
be appreciated if someone could give this series a go and make sure I
haven't wrecked anything.

Oliver Upton (3):
  KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
  KVM: arm64: Rename helpers for VHE vCPU load/put
  KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()

 arch/arm64/include/asm/kvm_host.h  |  4 ++--
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/arm.c               |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c    | 33 ++++++++++++++++++------------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 ++++------
 arch/arm64/kvm/hyp/vhe/tlb.c       |  1 -
 6 files changed, 30 insertions(+), 25 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.609.gbb76f46606-goog

