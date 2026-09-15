Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B04AA3FF
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 12:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475936; cv=none; b=S6hwyUUvUCU9w755pLpHVILEVB242t3tBxII5vLlyYYGrvXENchvkWlQLD5av4ZUQl/KC29jMSpWV0sS6FKHi4wt+201/bBrFsq/aafsQ7IwzkgSTDAAcYHdbJD86kjNY01KtgVsp8a3/z4jS/5bp0fs1bgNriwkVQKvnNYC1kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475936; c=relaxed/simple;
	bh=9BK6KSWU/pNCdY7VOPXtWIpA+Tq/NOwuoRA+4C/MS3w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rj9sYHsW0dTJ9wTydw7DUZXtkU0/ukzzokGlPuWSr1wbTTBsmwWTy8tZd3kqTGd1y+Rnu84tW5/vZEf5Ib3Oi79zk64RPI1wy9M14l2m1L3dSgbCpUe5EZbz82eXTVEHMJ1QNfNcJVe17OdVw8eLehkg6t/01Qe79CWB5S12fOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CcZ8qJLT; arc=none smtp.client-ip=91.218.175.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CcZ8qJLT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9BK6KSWU/pNCdY7VOPXtWIpA+Tq/NOwuoRA+4C/MS3w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475931; v=1; x=1790080731;
 b=CcZ8qJLThzDjrfhqDCYCRRWFtKc63foPJvNXHo57GxcjdmYs96KpNVVLrN/7AKL+JklT9FEC
 Vz5xcTQeB7FQOaTFvLp2kdOqHLkonqiM5/LJeNxDfYigLBD4Nh5R39BeZbEubQ+u57QbUuBfuNV
 Y36miWvUtqeNaDz2ur0SZQ48=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2862c013ce371715;
	Tue, 15 Sep 2026 12:38:50 +0000
X-Mizu-Trace-ID: 2862c013ce371715
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH 0/7] KVM: arm64: pKVM host hypercall and GICv5 CPU interface fixes
Date: Tue, 15 Sep 2026 13:38:39 +0100
Message-Id: <20260915123846.2317931-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This series consolidates three postings, which it supersedes:
  - The stage-2 MMU pointer hypercall rejection [1]: patch 2, reworked
    to move the hypercalls out of the always-available band instead of
    guarding each handler, and covering __kvm_flush_vm_context() too
    (Marc). __kvm_flush_cpu_context() stays in the set, which the
    sketch on the thread left out.
  - The GICv5 CPU interface series [2]: its hypercall patch reworked
    the same way, as patch 1, and its other three as patches 3, 6 and
    7, with 3's comment and 7's message trimmed and 6 unchanged.
    Sascha's Reviewed-by on the reworked patch isn't carried, the code
    having changed.
  - The __kvm_adjust_pc() host pointer fixes [3]: patches 4 and 5,
    with Vincent's and Joey's nits taken and their Reviewed-by
    collected. (thanks!)

Under pKVM, EL2 still trusts the host at the hypercall boundary in a
few places: hypercalls the host has no use for in protected mode stay
callable, the __kvm_adjust_pc() hypercall it does use takes a host
vCPU nothing pins or validates, and the vgic model EL2 copies out of
the host's struct kvm goes unchecked.

Patches 1 and 2 move the GICv5 CPU interface save/restore and the
stage-2 flushes into the band the dispatcher rejects once pKVM has
finalised. Patch 3 validates the vgic model EL2 copies from the host.
Patches 4 and 5 fix two host pointers dereferenced unvalidated on the
__kvm_adjust_pc() path, the vCPU's VM and the vCPU itself: either
panics the hypervisor if unmapped, and the VM read leaks a bit of hyp
memory through PSR_TCO on MTE hardware. Both carry Cc: stable. The
pKVM core series [4] carries the same two fixes as its patches 2 and
3, in the form posted before Vincent's nits, so that it applies as
is. Patches 6 and 7 are the rest of [2]: the EL1 side of the GICv5
access on nVHE, and a comment fix.

Patch 2 carries no Fixes: tag, no in-tree host path reaching those
hypercalls under pKVM; patch 1 keeps the one it was posted with.

The GICv5 residency and VDPEND hypercalls queued for 7.4 carry the
per-handler check the superseded GICv5 patch used, and can move the
same way.

Superseded postings:
  - 20260914174521.832575-1-fuad.tabba@linux.dev
  - 20260817103228.1203140-1-fuad.tabba@linux.dev (and its v1,
    20260806100256.371164-1-fuad.tabba@linux.dev)
  - 20260915070418.3209779-1-fuad.tabba@linux.dev (and its v1,
    20260914065136.3418404-1-fuad.tabba@linux.dev)

Based on v7.3-rc3 (fd73f4a665989). On kvmarm/next, patches 1 and 2
conflict with the new GICv5 hypercall IDs and patch 5 with the typed
hypercall handlers.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260914174521.832575-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260817103228.1203140-1-fuad.tabba@linux.dev/
[3] https://lore.kernel.org/all/20260915070418.3209779-1-fuad.tabba@linux.dev/
[4] https://lore.kernel.org/all/20260914113338.159227-1-fuad.tabba@linux.dev/

Fuad Tabba (7):
  KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
  KVM: arm64: Reject the stage-2 flush hypercalls under pKVM
  KVM: arm64: Validate the host-provided vgic model in pKVM
  KVM: arm64: Validate the host vCPU's VM before reading it under pKVM
  KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
  KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
  KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch

 arch/arm64/include/asm/kvm_asm.h           | 16 ++++----
 arch/arm64/kvm/hyp/exception.c             |  5 ++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 28 +++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |  2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 36 +++++++++++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 47 +++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c           |  4 +-
 arch/arm64/kvm/vgic/vgic.c                 | 12 ++++--
 8 files changed, 125 insertions(+), 25 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

