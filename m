Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5CC470453;
	Wed, 22 Jul 2026 07:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706177; cv=none; b=skvLvVEJAyVx7T2Pi8DwSoeRLJR5yN9gCkJv1GpkyJJZxL8TptlzXRo0DhQQ/HtKqiGIILMC6Byjaw1UmTSXvWqfn4M5ZrIgfNX0h7HpzrwwyUKe1+V1nRQp/17AMk8fdr8HnI8fMn1tqcCPaKLexd5BZIdCJYW2IoEInFJIaXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706177; c=relaxed/simple;
	bh=8ReLyo99+3BSTd1Xql5bX81ZBLTfJ6wPPGpdyieXCiU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EIX93Roi+r2Wsd6BiFEj/Nta1qKb+Qp4x6XdIea3RmdbRKkbT4kfeQ6SX8X2h4UBfz9DvFOpWHCfse0bXyv49cjOIOogNqEbplUYKuPRT/h4cZK8bpVcDuPTclJbUmB4xASuaN2lostyvZGkOHPoPl4+oifFdjV3X8foiRhOueA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLOZ+9bw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLOZ+9bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9781F000E9;
	Wed, 22 Jul 2026 07:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706176;
	bh=qeSszTM+/o+DOqeO6LdTK+Rn0FerMN3RuIO82gxmYhM=;
	h=From:To:Cc:Subject:Date;
	b=ZLOZ+9bw6W4ZKdFriI2QHOQlPSIs4JvXOVZZz9ccd/tZmwqZBISqgzvz4P+e4A7JW
	 rqo2ome89bape05GQ0JAzWIFr2473BKlD3iIHVOmjCgMcJ+lFPmAKDXfLN3oHzzUS8
	 JxVbqcuxebVdxx7Gwj0VoK5t0Lo6BVPAD1xVWGqYbqYZ1w3+VTGNP3dJbVNJ4zgdge
	 KiwZ0brzeEMx7mxNj17zkRm/OGEFxsKeU+TdgZOY+bo/2l6SDK7Co2el5IHtEsMfmt
	 u/hCEAEW9S8vKY5VyslbN+iXgImmChL3BxI/3Co1fixPUj1sRKy67RByCWWiLii/xq
	 r/Iu4GWHr8hGA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbR-00000007VfN-2i7N;
	Wed, 22 Jul 2026 07:42:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 00/28] KVM: arm64: Add support for FEAT_NV2p1 and FEAT_NV3
Date: Wed, 22 Jul 2026 08:42:06 +0100
Message-ID: <20260722074234.3330999-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the thid version of a series adding support for two
extensions targeting Nested Virt on arm64:

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
are in the double digit of percentage point reduction, see below for
details.

Does it make NV better? Yes!
Does it make NV good? Get real!

Anyway, patches on top of -rc4.

* Side notes about performance evaluation with NV3 emulation:

If you are interested in the NV3 emulation, I have a branch [0] that
contains it all. Note that the improvement only kicks while running an
L2 guest running at EL2 -- L1 will not see any improvement. But I get
close to 40% improvements on L2, and 60% on L3 for the only workload
that really matters (Debian Installer).

If all your nested guests are running this hack, then you can pass
"kvm-arm.mode=nested,nvtge" on the host command line, and all the
nested guests will opt in the accelerated behaviour.

If you like to live dangerously (or have a machine that does not have
FEAT_HCX), you can instead pass 'kvm-arm.mode=nested,nvtge=force', and
ERET will get the acceleration without even guest buy-in.

* From v2 [2]:

  - Improved comments on the subtleties of trapping ERET in nested
    contexts

  - Rebased on top of v7.2-rc4

  - Collected RBs from Yao Yuan, with thanks

* From v1 [1]:

 - Expanded generation of RESx and UNKN symbols to both Mapping and
   Fields qualifiers

  - Dropped HFGIRT_EL2.ERET checks on ERET fast-path

  - Fixed the NVHCR_EL2 trap handling

  - Added FORCE_RESx() to HCRX_EL2 constraints

  - Fixed ID_AA64MMFR4_EL1 sanitisation

  - Added NV3 acceleration for TLBIOS

  - Collected RBs from Joey, with thanks

[0] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv3
[1] https://lore.kernel.org/r/20260702160248.1377250-1-maz@kernel.org
[2] https://lore.kernel.org/r/20260714091641.1970822-1-maz@kernel.org

Marc Zyngier (28):
  arm64: sysreg: Emit RESx/UNKN values for Mapping/Fields definitions
  arm64: Update ID_AA64MMFR4_EL1 description to 2026-03 JSON release
  KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE
  KVM: arm64: Drop __HCRX_EL2_* masks
  KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2 sanitisation
  KVM: arm64: Classify CPTR_EL2 as a SR_LOC_SPECIAL register
  KVM: arm64: Don't evaluate HCR_EL2.NV nor HFGITR_EL2.ERET on ERET fast
    path
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
 arch/arm64/include/asm/kvm_emulate.h       | 45 ++++++++++++++++-
 arch/arm64/include/asm/kvm_host.h          |  3 +-
 arch/arm64/include/asm/vncr_mapping.h      |  2 +-
 arch/arm64/kernel/cpufeature.c             | 18 ++++++-
 arch/arm64/kernel/image-vars.h             |  1 +
 arch/arm64/kernel/pi/idreg-override.c      | 10 ++++
 arch/arm64/kvm/arch_timer.c                | 10 +++-
 arch/arm64/kvm/config.c                    | 27 +++++++++-
 arch/arm64/kvm/emulate-nested.c            | 18 +++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 27 ++++++++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 11 +++++
 arch/arm64/kvm/hyp/vhe/switch.c            | 52 +++++++++++++++-----
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 21 +++++---
 arch/arm64/kvm/nested.c                    | 14 +++++-
 arch/arm64/kvm/sys_regs.c                  | 57 ++++++++++++++++++++--
 arch/arm64/tools/cpucaps                   |  2 +
 arch/arm64/tools/gen-sysreg.awk            |  8 +--
 arch/arm64/tools/sysreg                    | 44 +++++++++++++++--
 20 files changed, 321 insertions(+), 65 deletions(-)

-- 
2.47.3

