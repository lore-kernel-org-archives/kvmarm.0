Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8730C69D35
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647547; cv=none; b=HkjT29fFYfw1uCCy3Pr5UWvcOdGmQGhFP5uTP3nLdpE9FlrQ99cYF8uU93d/Y6daiWHQAzFxbzeRQRtYYU1MzR3eai9XcEl8ci9ztb9Wjr5q3Jsy4hD8K8Yu/H/yNUDNBD6OWpNL7YljOgBcernXA23iCJ6TNJsgsv6/NfMRlOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647547; c=relaxed/simple;
	bh=TslrQQTy8inB70RnuWi+lLXP9OJHgh1SOHNDymI5k9M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QP8peNcr9rSX4ZfOFTxXVYfMjgzNSioswhKy8hMxtDA543eHNQB2pZizvahWJmkSP4Wo7kYa7MP01V8zOwkNFgWkIXTrvWyCFhdQoHxLW5Gvu+zEH+P6EqdsDHki+DWma973RUSOBtjT6jgm32E3dCAUcCrxL9IXuzDQa8c0jgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxNpx91N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxNpx91N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167E4C433F1;
	Tue, 30 Jan 2024 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647547;
	bh=TslrQQTy8inB70RnuWi+lLXP9OJHgh1SOHNDymI5k9M=;
	h=From:To:Cc:Subject:Date:From;
	b=hxNpx91N0mKhEW4xu+aysPZaKrI3ELudvvNiEH17u0Bt630y7bl0LWVW7PlOneQ84
	 SdM2i7pSEcc0et9HYejsi/AJPzfRwE2gVT9ojkq9bm00yszNlNIESsVsQlI6bKyU1C
	 3OinhCV4Oyo7ZwkQm7KSul0h2aSUFqzYpu+CwhDsW/cOs5nv8kzw65sA/YiHlitymD
	 m7sSXMdL1PtT6LNUWjNV1pWGNTFW2rKAQ5IU6NgGbiM2YAi13KpkALQi3On4dFcxrC
	 DIjjLUpfmOdoWbDRwNEjFyLEsxTRyrq/ayxyxLE78bg1Bo1aK4cV+doBJjWjnX8CR+
	 GPPb4JTjcW9NQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzI-00GNsE-Nw;
	Tue, 30 Jan 2024 20:45:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 00/25] KVM/arm64: VM configuration enforcement
Date: Tue, 30 Jan 2024 20:45:07 +0000
Message-Id: <20240130204533.693853-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is the second version of this configurationm enforcement series
after some really awesome reviewing with from Joey.

I think I have taken most of the feedback into account, but please
shout if I have ignored something.

* From v1: [1]
  - Fix embarrassing crash with FEAT_MOPS
  - Better error handling in the FGT code
  - Added/Fixed comments
  - Simplified the __vcpu_sys_reg() macro
  - Fixed FEAT_PIR handling
  - Folded in Oliver's PMU rework

[1] https://lore.kernel.org/all/20240122201852.262057-1-maz@kernel.org

Marc Zyngier (25):
  arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
  KVM: arm64: Add feature checking helpers
  KVM: arm64: nv: Add sanitising to VNCR-backed sysregs
  KVM: arm64: nv: Add sanitising to EL2 configuration registers
  KVM: arm64: nv: Add sanitising to VNCR-backed FGT sysregs
  KVM: arm64: nv: Add sanitising to VNCR-backed HCRX_EL2
  KVM: arm64: nv: Drop sanitised_sys_reg() helper
  KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
  KVM: arm64: nv: Correctly handle negative polarity FGTs
  KVM: arm64: nv: Turn encoding ranges into discrete XArray stores
  KVM: arm64: Drop the requirement for XARRAY_MULTI
  KVM: arm64: nv: Move system instructions to their own sys_reg_desc
    array
  KVM: arm64: Always populate the trap configuration xarray
  KVM: arm64: Register AArch64 system register entries with the sysreg
    xarray
  KVM: arm64: Use the xarray as the primary sysreg/sysinsn walker
  KVM: arm64: Rename __check_nv_sr_forward() to triage_sysreg_trap()
  KVM: arm64: Add Fine-Grained UNDEF tracking information
  KVM: arm64: Propagate and handle Fine-Grained UNDEF bits
  KVM: arm64: Move existing feature disabling over to FGU infrastructure
  KVM: arm64: Streamline save/restore of HFG[RW]TR_EL2
  KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
  KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the
    guest
  KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the
    guest
  KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest
  KVM: arm64: Add debugfs file for guest's ID registers

 arch/arm64/include/asm/kvm_arm.h           |   4 +-
 arch/arm64/include/asm/kvm_host.h          | 107 ++++++++-
 arch/arm64/include/asm/kvm_nested.h        |   1 -
 arch/arm64/kvm/Kconfig                     |   1 -
 arch/arm64/kvm/arm.c                       |   7 +
 arch/arm64/kvm/emulate-nested.c            | 231 +++++++++++++-----
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 130 +++++-----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  24 +-
 arch/arm64/kvm/nested.c                    | 265 ++++++++++++++++++++-
 arch/arm64/kvm/pmu-emul.c                  |  11 +-
 arch/arm64/kvm/sys_regs.c                  | 235 +++++++++++++++---
 arch/arm64/kvm/sys_regs.h                  |   2 +
 arch/arm64/tools/sysreg                    |   8 +-
 include/kvm/arm_pmu.h                      |  11 -
 14 files changed, 856 insertions(+), 181 deletions(-)

-- 
2.39.2

