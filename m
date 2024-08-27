Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814F4802
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718172; cv=none; b=Jetq/JKntsEkhtLfmZYcP/R71l6y7VKNat8OYL2TlRQiNkJhLmOkHclzTxZz0/Va2lnbpCZmWkPv+vaHHJK/l8kkYKWWgZcKAvc7XeFYqTeEsf32+jp+Nr+fGZo7is816c5p8Qu/WpG8i0peHC/dtF3148IPbSGnHS03+7YNBEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718172; c=relaxed/simple;
	bh=CVgZ6JSLi9o/rGq8Gg5MbbvfzKGcrPKnUaFQmky70Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HzOveLr4hXAfYgro0q9pqnDhUh8JmxnZ5cWy5xBN+359+O3oIjx+QjGiBQ0Jgpa4z6cdCaSq8loiq5ZYL8MsUbfTMOF940GxkxoBPz06sny93mw44NItYGHHWTyjNucsY2rUtXJ1D2Xk5/o87JvJcoh79IhL+wKlHsdDnXyA3l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aj1R5rUC; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aj1R5rUC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+aS9JBXyqvbXhWHYjzwuCT5J+DxGuOdUGh/qszYqjIw=;
	b=aj1R5rUCB462d0hJw7NQLtzOGzI4IWKkyrxOIzMhOOGlyPIdNoonr/WtGvBBQC8SkfvWfz
	Cz06Jkcb+oNrJ2Sbw5C6zuRhsg5B3AYF0mT0Wisl5RVQIpLSmkY/dbf/KAvSj3O4XPu60+
	TdzSWSw0/wIMU1gAz5ayf8MZgPBGIdY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/12] KVM: arm64: nv: More complete support for FEAT_PMUv3
Date: Tue, 27 Aug 2024 00:22:23 +0000
Message-ID: <20240827002235.1753237-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Well, looks like that grew a bit :)

The coarse-grained traps for the PMU available at EL2 are annoyingly
effective in both guest and host contexts, meaning the traps need to be
evaluated for a VM's host EL0. Yuck.

First couple patches align the PMU emulation w/ the architecture, where
a PMU has an implemented set of counters *and* a dynamic view of said
counters based on the current context.

Patches 2-9 add support for Host EL0 traps to the NV trap
infrastructure, and takes advantage of it for MDCR_EL2.{TPM, TPMCR,
HPMN}.

The whole interaction of CGTs declaring their EL0-ness is a bit shaky,
since it is a property of the triaged sysreg itself. I structured it
this way for the mostly theoretical problem of a sysreg having multiple
traps, only some of which take effect in Host EL0.

Last bit is the event filter fixes I had from before.

v1: https://lore.kernel.org/kvmarm/20240824001402.3909504-1-oliver.upton@linux.dev/

Oliver Upton (12):
  KVM: arm64: Rename kvm_pmu_valid_counter_mask()
  KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN
  KVM: arm64: nv: Rename BEHAVE_FORWARD_ANY
  KVM: arm64: nv: Add support for describing traps that affect Host EL0
  KVM: arm64: nv: Reinject traps that take effect in Host EL0
  KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
  KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
  KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
  KVM: arm64: nv: Advertise support for FEAT_HPMN0
  KVM: arm64: Add helpers to determine if PMC counts at a given EL
  KVM: arm64: nv: Honor NSH filter when in hyp context
  KVM: arm64: nv: Reprogram PMU events affected by nested transition

 arch/arm64/include/asm/kvm_emulate.h |   5 +
 arch/arm64/kvm/emulate-nested.c      | 319 +++++++++++++++++----------
 arch/arm64/kvm/nested.c              |   5 +-
 arch/arm64/kvm/pmu-emul.c            |  97 ++++++--
 arch/arm64/kvm/sys_regs.c            |  12 +-
 include/kvm/arm_pmu.h                |  12 +-
 6 files changed, 311 insertions(+), 139 deletions(-)


base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
-- 
2.46.0.295.g3b9ea8a38a-goog

