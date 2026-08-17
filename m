Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0F83AFD16
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 10:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786962758; cv=none; b=f+e6cWaPBOLPwTuIMI/lDO3yaL+igLwRDOGUehSjwEIZDYW/x5pFGO+eBCSVYWUyk9crFYk++x+9rhkx1AeWrr6M4HmqS4dFybmvQXeQuicU7D7LoetkUk2NvOlMJLk0u73V+iKENATrJ3pfCVeW8/NvbEVBqTAPFpc6TlzswM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786962758; c=relaxed/simple;
	bh=YrQ+5Ek+FlurOmzHQ7gb21A41dW+jGsFylmIBQ2cRiY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X4REMsEfWMrMkxrvc9yB8Wy/6lT+jPosp57o1IVvNNdpl70TUvIdVIW1Xr3+2aYZLGY5+78TKLrLUxgNFy6kmW2dV9sPL81A7l3/ErTxLa0ncHtSrCWU7HAjxQ51BRVbfDRlIL1GP0vDCCWNAsJR7l8YaV2/vkjFjWG+9QGU7mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ldiadiYO; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ldiadiYO"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YrQ+5Ek+FlurOmzHQ7gb21A41dW+jGsFylmIBQ2cRiY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786962752; v=1; x=1787567552;
 b=ldiadiYODNGpW3y2EueZsa8mdgwjBFTDWq04ObllGlhVylhB22cN+AM0qzYgXR7AUTqftM4a
 CSWvbXa+KDm0ezhseiczq3hEWLOa3BgRYbHoUFPdLUQAoq/GRw1KONWSmW9Le0ZgUKAOc9Xn4vD
 CMZY+Cmuj1UdYri9Gkq0vDTw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 4750f82dee378e17;
	Mon, 17 Aug 2026 10:32:32 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v2 0/4] KVM: arm64: Fix unguarded GICv5 CPU interface accesses
Date: Mon, 17 Aug 2026 11:32:24 +0100
Message-Id: <20260817103228.1203140-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - Reject anything that is not VGIC_V3 rather than listing the models,
    which drops the VGIC_V2 case. (Sascha)
  - Tightened the UNDEF sentence in patch 2's commit message. No code
    change.
  - Collected Sascha's Reviewed-by on patches 2 to 4, thanks for the
    reviews.
  - Rebased onto Linux 7.2.

This series stops KVM reaching GICv5 CPU interface registers on hardware
that does not implement them, in three places with no guard.

Under pKVM the first two are reachable from an untrusted host. EL2
copies vgic_model out of the host's struct kvm without validating it,
and the nVHE world switch dispatches on that field with no cpucap guard,
so a host writing KVM_DEV_TYPE_ARM_VGIC_V5 steers EL2 into ICC_ICSR_EL1
and the ICH_PPI_* registers. Separately, __vgic_v5_save_apr and
__vgic_v5_restore_vmcr_apr sit in the hypercall band the de-privileged
host may still call, and pKVM never registers a GICv5 vgic, so neither
has a valid caller in protected mode. Without FEAT_GCIE those registers
are UNDEFINED at EL2, so either path panics the hypervisor. Both need a
compromised host kernel rather than host userspace, so this is hardening
and not a guest-reachable hole.

I had said these paths were unreachable under pKVM because
vgic_v5_probe() skips GICv5 registration in protected mode [2]. That was
wrong. The skip is host-side only, and does not constrain what a
malicious host can call.

The third one is not pKVM. can_access_vgic_from_kernel() excludes only
the GICv3 system register interface, so on a native GICv5 system without
FEAT_GCIE_LEGACY the kernel reaches EL2-only registers from EL1 under
nVHE, and the world switch does the same work at EL2 anyway.

The last patch drops the VGICv3 reference from two nVHE world switch
comments that cover GICv5 too. No functional change.

Tested on QEMU. I also checked the first one with a local host patch
that hands EL2 a GICv5 model: it panics at __vgic_v5_restore_state
before the series and boots cleanly after.

Based on Linux 7.2 (8d3ae59288f1e). It also applies cleanly to
kvmarm/next and kvmarm/fixes.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260806100256.371164-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/CA%2BEHjTyGULmVCgyoya3bXG4gRj0OYFE1gnJLhNE6kvCrZFtXyQ@mail.gmail.com/

Fuad Tabba (4):
  KVM: arm64: Validate the host-provided vgic model in pKVM
  KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
  KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
  KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch

 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 ++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 11 +++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c   |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         | 12 ++++++++----
 4 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.39.5

