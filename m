Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68E1208D0;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008181; cv=none; b=Re6V9rUzmB7ZDZlynaUuwH2iIDCO1ONTDfgSZRI/l8TOdvDcg6sZrcfzRm1sWIMg4DEtTZm0Brq+NexfUMu5DZ86rgiDjoCJJgES+6BNNUt/y16fKm3Pv1mPD8vt/YtV2ThcyxVfnaQ3xC/RTR/Khi36bpasBqaL8X+DP0cQ1Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008181; c=relaxed/simple;
	bh=w9RFbvaKNKUlRfD717tC1omLCExcaXt8NFx4VzCt3ko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fVet0jonTEFKOS7lrElUeeo/7lSi+ZcXxKUQ5SNwy4AmP3+x9lPs+E94k7ZK/AbsZb+RF+LfAbPWczv6QbGrttA0FvzBtKGkydmfrrOshxv9nBXenzKCr8lpgBhVm2YGBV8f+OtcFRER4E32i31QEF3r1jTon/XJ/hG5gg8gsTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTbNbKQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTbNbKQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA5D1F00A3D;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008180;
	bh=lkRmJfjduZK9IpL92pMpmu7hELRF8zY2e5+CUCrWXcs=;
	h=From:To:Cc:Subject:Date;
	b=XTbNbKQ+/p0h8CFLoiMLzwJChp9SYauDq9FBOQXktnbBXLGwRFtznu33HATZQ+xc+
	 qRWpPzHQdBdSyHbxWH2n1zWPDGYg3lH9vsBUg5edBoOF18wcgfZ5HfEzpg1ITQjlTT
	 czkcd5UD4cvu9byr2oJBHudAI9sDqsrmQJffFdsJ3OyNAlj6Xp4DK5dPfQbFJzVzDL
	 M38chUi7n5zfSAMI3xCgvPND2HT4KE65n1jAfJPyWLQ6LbDOYjubPyxn5DQa3drMda
	 bPv7bJUxJrIQUmS3L0iB4HoxqybK9GfAKPeYE5z1NAzKwekbmHQyKH4WeyKsI/xgyf
	 ObCoURcQ3YkDg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsQ-00000000ojd-0KJS;
	Thu, 02 Jul 2026 16:02:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 00/28] KVM: arm64: Add support for FEAT_NV2p1 and FEAT_NV3
Date: Thu,  2 Jul 2026 17:02:20 +0100
Message-ID: <20260702160248.1377250-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series adds support for two extensions targeting Nested Virt on
arm64:

- FEAT_NV2p1 is effectively a bug fix for two registers (CNTHCTL_EL2
  and CPTR_EL2) that are missing stateful bits when accessed from EL1
  in a NV configuration. When this is present, the hypervisor can
  avoid a bunch of traps.

- FEAT_NV3 is much more ambitious, and changes the way ERET behaves in
  a NV environment. By moving EL1 accesses to HCR_EL2 from memory (via
  VNCR) to a dedicated register (NVHCR_EL2), the HW can detect whether
  the guest is performing an ERET for itself (NVHCR_EL2.TGE==1) or to
  its own guest (NVHCR_EL2.TGE==0). In the former case, ERET is done
  directly, and no trap occurs. Similar optimisations are available
  for a class of TLBI instructions.

The whole thing has been tested on an FVP model, and shown measurable
improvements for an L1 guest (about 1.5% fewer instructions).

Given that this isn't very convincing on its own, I have built an
approximate emulation of FEAT_NV3 that L1 (and deeper levels) can use
on actual production hardware. For these deeper levels, the numbers
are in the double digit of percentage point reduction (those
interested can look at the patches in the kvm-arm64/nv3 branch in my
tree).

Does it make NV better? Yes!
Does it make NV good? Get real!

Anyway, patches on top of -rc1 plus the current state of kvmarm/fixes.

Marc Zyngier (28):
  arm64: sysreg: Emit RESx/UNKN values for Mapping definitions
  arm64: Update ID_AA64MMFR4_EL1 description to 2026-03 JSON release
  KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE
  KVM: arm64: Drop __HCRX_EL2_* masks
  KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2 sanitisation
  KVM: arm64: Classify CPTR_EL2 as a SR_LOC_SPECIAL register
  KVM: arm64: Don't evaluate HCR_EL2.NV on ERET fast path
  arm64: Add ARM64_HAS_NV2P1 capability
  KVM: arm64: Relax CPTR_EL2 handling when FEAT_NV2p1 is present
  KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present
  KVM: arm64: Expose FEAT_NV2p1 to NV guests
  arm64: Add FEAT_NV2p1 detection
  arm64: sysreg: Add NVHCR_EL2 description as a mirror of HCR_EL2
  arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
  arm64: Add ARM64_HAS_NV3 capability
  KVM: arm64: Split NV-specific exit fixups from the non-NV handling
  KVM: arm64: Add NV3 control bits to HCRX_EL2 sanitisation
  KVM: arm64: Add kvm_has_nv{2,3}() predicates
  KVM: arm64: Make HCR_EL2 a non-VNCR register
  KVM: arm64: Add sanitisation for NVHCR_EL2
  KVM: arm64: Add NVHCR_EL2 handling to the sysreg array
  KVM: arm64: Add routing for NVHCR_EL2 trap
  KVM: arm64: Add NVHCR_EL2 context switching
  KVM: arm64: Engage NV3 ERET trap elision
  KVM: arm64: Engage NV3 TLBI trap elision
  KVM: arm64: Add FEAT_NV3 detection
  KVM: arm64: Expose FEAT_NV3 to guests
  arm64: Add override for ID_AA64MMFR4_EL1.NV_frac

 arch/arm64/include/asm/cpufeature.h        |  1 +
 arch/arm64/include/asm/kvm_arm.h           | 15 ------
 arch/arm64/include/asm/kvm_emulate.h       | 41 +++++++++++++++-
 arch/arm64/include/asm/kvm_host.h          |  3 +-
 arch/arm64/include/asm/vncr_mapping.h      |  2 +-
 arch/arm64/kernel/cpufeature.c             | 18 ++++++-
 arch/arm64/kernel/image-vars.h             |  1 +
 arch/arm64/kernel/pi/idreg-override.c      | 10 ++++
 arch/arm64/kvm/arch_timer.c                | 10 +++-
 arch/arm64/kvm/config.c                    | 25 +++++++++-
 arch/arm64/kvm/emulate-nested.c            | 16 ++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 27 ++++++++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 11 +++++
 arch/arm64/kvm/hyp/vhe/switch.c            | 44 +++++++++++++----
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 21 +++++---
 arch/arm64/kvm/nested.c                    | 14 +++++-
 arch/arm64/kvm/sys_regs.c                  | 57 ++++++++++++++++++++--
 arch/arm64/tools/cpucaps                   |  2 +
 arch/arm64/tools/gen-sysreg.awk            | 14 ++++--
 arch/arm64/tools/sysreg                    | 42 ++++++++++++++--
 20 files changed, 313 insertions(+), 61 deletions(-)

-- 
2.47.3

