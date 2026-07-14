Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BD6367F48
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030402; cv=none; b=BXqPSi0OwjAa0UX0uNDHF3sKAAeMBcrPQQKMF+HTCvvSixLILvdfX6CeuBQxJspCrUKuPqUuEYg+9ZucI5pMV3BKFfeOUunDDmxsf4MUNcCJR8HDDt1F79Kk6E+nKu3xY1/+ZnLTxNwmYL5IJH04qQCh9lva6mHYGdIRsw98J3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030402; c=relaxed/simple;
	bh=Vau5I2x8GnBbz9bN28WC5XKuZItIuXTZBRiRMAyopJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nvc0885nHxDq4jGWut9l+brcwduL8vQomqKCgml47scSSgGZNxkYXIKtZgTQx4FwivZTWCYZNeAuVv0ysoh5hidAo2nTxJM6+4g93IbeA6vByD65kD9y//l1HzD8h3xN8po81oxy+8tXpn5Y7o4GUSD4e5yoSZNZgHEwnLN9dwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hDiOD7Ts; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hDiOD7Ts"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23F90497;
	Tue, 14 Jul 2026 04:59:55 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E03D03F93E;
	Tue, 14 Jul 2026 04:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784030399; bh=Vau5I2x8GnBbz9bN28WC5XKuZItIuXTZBRiRMAyopJc=;
	h=From:To:Cc:Subject:Date:From;
	b=hDiOD7TsElvLBUrXh3C69BLs3efiyfqZtMMmzqSnb4Awgt+4U4HiSuSRdS0JGnlPn
	 1Y9cPWC7yJj4140hjBSnQwRjyiV5zEeioGzeUH+k7NI4WCBW35I2uyaBK5eSrfMfpM
	 yrktwGjcnWu+i3FXHpAoC8D7M1fJWn7ZbdVx+jnA=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v4 0/6] KVM: arm64: nv: Implement nested stage-2 reverse map
Date: Tue, 14 Jul 2026 12:59:19 +0100
Message-ID: <20260714115926.2044757-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v4 of optimizing the shadow s2 mmu unmapping during MMU
notifiers. The general theme stays the same, but various
improvements/fixes are added. Thanks for all the feedback. Please see
below for the changes.

* Changes from v3 [1]:

  - Rebased on to the latest kvmarm/fixes.

  - Removed commit "KVM: arm64: Move shadow_pt_debugfs_dentry to reduce
    holes in kvm_s2_mmu" because the current shadow ptdump code is found
    to be buggy and the proposed fix removes shadow_pt_debugfs_dentry [2].

  - Rename some variables to improve readability e.g. ipa ->
    canonical_ipa, fault_ipa -> nested_ipa.

  - Skip reverse map optimization when !mmu->nested_stage2_enabled,
    and just unmap the canonical IPA range during MMU notifiers.

  - Change comment above the code that checks whether an identical
    reverse map already exists in kvm_record_nested_revmap() from saying
    it could be a permission update to saying another parallel stage-2
    fault could have inserted an identical reverse map. This is because
    permission update won't trigger kvm_record_nested_revmap().

  - Add helpers for checking maple tree entry flags VALID_ENTRY and
    UNKNOWN_IPA, also warn if both are set at the same time.

  - Test canonical IPA alignment with the mapping size during reverse
    map insertion.

  - Move clean up of kvm_unmap_gfn_range() to its own patch.

  - Avoid naming variables with "*dir*", as it can be misunderstood to
    be related to directories.

  - Use mas_find() instead of mas_find_range() as mas_find_range()
    returns every range including empty/NULL ranges, for our use case
    we only want to iterate over non-NULL ranges.

  - Added a trace point to track when the reverse map maple tree becomes
    "broken" i.e. maple tree insertion failure.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260510145338.322962-1-weilin.chang@arm.com/
[2]: https://lore.kernel.org/kvmarm/20260630121005.1130996-1-weilin.chang@arm.com/

Wei-Lin Chang (6):
  KVM: arm64: Use a variable for the canonical GPA in kvm_s2_fault_map()
  KVM: arm64: nv: Avoid full shadow s2 unmap
  KVM: arm64: nv: Add nested revmap broken tracepoint
  KVM: arm64: Refactor kvm_unmap_gfn_range() with common variables
  KVM: arm64: nv: Remove reverse map entries during TLBI handling
  KVM: arm64: nv: Create nested IPA direct map to speed up reverse map
    removal

 arch/arm64/include/asm/kvm_host.h   |   9 +
 arch/arm64/include/asm/kvm_nested.h |   6 +
 arch/arm64/kvm/mmu.c                |  42 +++--
 arch/arm64/kvm/nested.c             | 280 +++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c           |   3 +
 arch/arm64/kvm/trace_arm.h          |  27 +++
 6 files changed, 349 insertions(+), 18 deletions(-)

-- 
2.43.0

