Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7C543B4B2
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010641; cv=none; b=b4mV44st/OrnWho+87jC50etqi8n9LeHAiY6T78VEEf2cWGqrjJPiIEMa3uqpFAsCi3HVO1p+c+Z9hTdzAo9rjvuMoomFxXXMwrGlCI9xVB8mtQ2zO+zIMIgzugoK5PRSXPSc/MSm64xzBuN46UtXg8dhXUVeYP82jaIm9/qYlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010641; c=relaxed/simple;
	bh=p5CS4Ob/X8SD/biw/X8McI5Dm4k5vtPdr3XdJhL98OA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hdgVa9Ne7FHXKHusUAyxz/OzUQgePky6rvtOWz7xPmj/A8Q40oBsIGPDCEeNHhyP6u/tSAloGztv+tyjnOzMRhV+TK9cwNkiQh9WTCE9byfRxSv0v+hfqemGtgq+39GmIRf40uTyjm0cugecRv91FWHLir4yWmJyfy3+ZXcY7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T/DPOHR7; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T/DPOHR7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786010625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3S2poz7UmuzQNE0KnSIBmguQesr8Wp2egthXDvqh2KU=;
	b=T/DPOHR7R2QA6bW5ci/d19NVL8nHVaurYq58LS4jLB5oIyswzXsehzzCXxYdxWadCWnRfn
	69K/WBeQ3T9eVYEQineEW9nT4mvPQKY0KL4kdxMOtHLfYn2jpcF8Mk60Qi6JF5QlEbrsgb
	V2IlsUkO1NuwIjroY4kZPRx2moygjOg=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v1 0/4] KVM: arm64: Fix unguarded GICv5 CPU interface accesses
Date: Thu,  6 Aug 2026 11:02:52 +0100
Message-Id: <20260806100256.371164-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

This series stops KVM reaching GICv5 CPU interface registers on hardware
that does not implement them, in three places with no guard.

Under pKVM the first two are reachable from an untrusted host. EL2
copies vgic_model out of the host's struct kvm without validating it,
and the nVHE world switch dispatches on that field with no cpucap
guard, so a host writing KVM_DEV_TYPE_ARM_VGIC_V5 steers EL2 into
ICC_ICSR_EL1 and the ICH_PPI_* registers. Separately, __vgic_v5_save_apr
and __vgic_v5_restore_vmcr_apr sit in the hypercall band the
de-privileged host may still call, and pKVM never registers a GICv5
vgic, so neither has a valid caller in protected mode. Without
FEAT_GCIE those registers are UNDEFINED at EL2, so either path panics
the hypervisor. Both need a compromised host kernel rather than host
userspace, so this is hardening and not a guest-reachable hole.

I had said these paths were unreachable under pKVM because
vgic_v5_probe() skips GICv5 registration in protected mode [1]. That was
wrong. The skip is host-side only, and does not constrain what a
malicious host can call.

The third one is not pKVM. can_access_vgic_from_kernel() excludes only
the GICv3 system register interface, so on a native GICv5 system
without FEAT_GCIE_LEGACY the kernel reaches EL2-only registers from EL1
under nVHE, and the world switch does the same work at EL2 anyway.

The last patch drops the VGICv3 reference from two nVHE world switch
comments that cover GICv5 too. No functional change.

Tested on QEMU. I also checked the first one with a local host patch
that hands EL2 a GICv5 model: it panics at __vgic_v5_restore_state
before the series and boots cleanly after.

Based on Linux 7.2-rc6 (075b74841bd00). It also applies cleanly to
kvmarm/next and kvmarm/fixes.

I really should stop looking at the GIC, but I won't be able to anytime
soon I'm afraid...

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA%2BEHjTyGULmVCgyoya3bXG4gRj0OYFE1gnJLhNE6kvCrZFtXyQ@mail.gmail.com/

Fuad Tabba (4):
  KVM: arm64: Validate the host-provided vgic model in pKVM
  KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
  KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
  KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch

 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 ++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 16 ++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c   |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         | 12 ++++++++----
 4 files changed, 30 insertions(+), 8 deletions(-)


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
2.39.5

