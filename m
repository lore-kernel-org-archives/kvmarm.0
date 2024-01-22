Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057E540BE2
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954738; cv=none; b=kIksqzVED5q9oYE3MTjV2F8nHJNwx9XJA7/+YQd4mkSCpPhWkVdh8CRym/q6IHIaNVUMrvYiNxXeE8wuyOVpeQsYpUiyUAHGo586W8GtL65QddQDtodx3EDb3hnjlD+tKNJWnTdu/lFEqWS/tdXTf3bR3F3vhTGQFfeDAKEPuxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954738; c=relaxed/simple;
	bh=6RO9Q8UYGwFAwdokQLQ1xdr5FQOvHmWjjVoYab3NnOk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z/v9Mjrdgs0dU7HpD0ZGKUvro2UqbQPAz9Wa0GStUeVpvHKxT1W05Hqktuzc5wJfE8G5WPiOAFRvcZO14qWweEDSo2eurVPwYwp9znZ5IV3ZA/+jQbPaU0DVNhRWzIq6bEmJOhtvh/WhzA9lA1J0av1uOHJKeF+ypPDnO+w4AoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaOnLFhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaOnLFhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F9FC43394;
	Mon, 22 Jan 2024 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954737;
	bh=6RO9Q8UYGwFAwdokQLQ1xdr5FQOvHmWjjVoYab3NnOk=;
	h=From:To:Cc:Subject:Date:From;
	b=FaOnLFhu+8fXKXGT5TSj4vJeidSZMX6FOZ0XMVdy5nBYv7CRSSC0Pml9qdAn2ej5I
	 Q1iKjox3v92x7H5GOr3uHkryuZm5TbbMp7gkxqMIsBt5LiJUN724YwzreoBhAFBCHO
	 ENhDE1QdNkHIucNJzltVqfgr6r49gFhDJrK7JTkNyNdC+bUNavZnGadwQlZ+39XzT5
	 cv2IClMorZHl3YXHYfsv0uzb6CRfFkKr3StLhAz4V/JqINWBd9iP8XP+RCj7KchBI3
	 c0gq89MaPz7ev7zaqjtGk3/rdTLvWxK3ECUI9lTUwXbZl2Mp6YexhYoWkVXeF4/QAg
	 vPIFC9cTSes2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0kx-00DjkQ-FI;
	Mon, 22 Jan 2024 20:18:55 +0000
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
Subject: [PATCH 00/25] KVM/arm64: VM configuration enforcement
Date: Mon, 22 Jan 2024 20:18:27 +0000
Message-Id: <20240122201852.262057-1-maz@kernel.org>
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

Until recently, implementing a new feature in KVM was a matter of
looking at the CPU capability, and enabling the feature if it was
present. Very little effort was put into producing a configuration
that was independent of the host.

That was until we made the ID registers writable. Now, userspace can
configure a VM with an expected set of features, and relies on the
hypervisor to provide the corresponding architectural behaviour
(within the limits of what the architecture can actually enforce, more
on that later). Unfortunately, this last point has so far been left

Enforcing these constraints is important:

- VMs need to migrate between hosts that implement different feature
  sets. Allowing the guest to crate state on one system, and then to
  crash on another, is not an acceptable outcome. Yes, the SW was
  buggy, but it is the migration that broke it, and the hypervisor is
  at fault. Not handling this correctly also has the potential to
  create covert channels, something that I'm sure cloud vendors are
  really eager to put in production.

- Making sure that an unadvertised feature UNDEFs is a way to limit
  unexpected behaviours in an unsuspecting hypervisor. Specially when
  the architecture is as hostile to SW as this one.

- Honouring the VM configuration allows the KVM support to be phased,
  unless we want to mandate full NV support for everything right now.

This patch series aims to plug a number of the existing holes by
providing some basic mechanisms:

(1) add a way to easily parse the guest's ID registers and work out
    whether a particular level of support is advertised. This is
    provided as a small set of basic accessors that simply return a
    boolean indicating whether the supporting condition is satisfied.

(2) offer a way to enforce the effective values of the system
    registers backed by the VNCR page, even if the guest can write
    whatever it sees fit there. This is done by maintaining a set of
    RES0/RES1 masks computed from the guest's feature set, and these
    masks applied on each access to the in-memory register.

(3) provide a way to force a system register to UNDEF if there is a
    FGT associated with it. These so-called 'Fine-Grained UNDEF' bits
    shadow the FGT and are used to route the resulting exception.

Under the hood, this results in a number of significant changes: the
NV trap handling xarray becomes the basic data structure for handling
traps, even in non-NV configurations, and there is a number of new
data structures to manage the effective state. Oh, and we get some
more debugfs crap (which I'm not necessarily keen on merging).

A lot of effort has been put into computing the configuration only
once and rely on shadow data to enforce the desired behaviour.

Note that not all the possible configurations are handled:

- the surface is pretty large, and I have only tried to come up with
  significant *examples* of how things could be done. There is tons of
  additional work to be done beyond these patches.

- the architecture doesn't always allow some features to be completely
  hidden (any register backed by VNCR is always 'visible' if present
  on the host).

I expect that /some/ of this work could make it into 6.9 and be used
by any new feature added to KVM from that point onwards.

This series is based on v6.8-rc1 plus my E2H0 series, and is a prefix
for the rest of the NV series.

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
 arch/arm64/include/asm/kvm_host.h          | 110 +++++++++
 arch/arm64/include/asm/kvm_nested.h        |   1 -
 arch/arm64/kvm/Kconfig                     |   1 -
 arch/arm64/kvm/arm.c                       |   7 +
 arch/arm64/kvm/emulate-nested.c            | 209 ++++++++++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 130 +++++-----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  15 +-
 arch/arm64/kvm/nested.c                    | 265 ++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c                  | 224 ++++++++++++++---
 arch/arm64/kvm/sys_regs.h                  |   2 +
 arch/arm64/tools/sysreg                    |   8 +-
 12 files changed, 824 insertions(+), 152 deletions(-)

-- 
2.39.2

