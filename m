Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DA01A6808
	for <kvmarm@lists.linux.dev>; Sat, 11 Apr 2026 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775911856; cv=none; b=bAKzlRiCPF4/qXgFfCUXhWXgxuX0xop+jVZGeh7OLM3K3c++B6ZavB13mkCek3mBX6IYvmhfAvsYjrVZ7Y/sm7MTci9DX2QVd9r9UvmCCbHQWBll6gpXqcnnZcRB5YtTM7a/5fzeXGA4FDtPBgNAtUuFz8ohlGMJJvMe/d7VVzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775911856; c=relaxed/simple;
	bh=PCUm7AJBwfv68VRHQn0akZBOL7JjGV0tbIGrCcwnybM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iqURWRZSOqd5t7cWMDGcjg08cTJgAAs3QsEINPgLC9LnwKuFw+02pk5MFdVUk/lLk4Dbbn9VJNkkECg3S+oT1GOOLE0hWUYdX0EsPTgUQeW7EWT2wSG8uiw55NjYNlOJRmktqXCk9eAaLQeF16Kkl4ZyutLY+RrHTD0hzRCi2fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C+l8LqWd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C+l8LqWd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAC502C46;
	Sat, 11 Apr 2026 05:50:45 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA5253F641;
	Sat, 11 Apr 2026 05:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775911851; bh=PCUm7AJBwfv68VRHQn0akZBOL7JjGV0tbIGrCcwnybM=;
	h=From:To:Cc:Subject:Date:From;
	b=C+l8LqWd7CndiGGtpMNKlqHsvST33l2Sah2HTljSJ1uELhMV/Y6hBVNBeb86HdssJ
	 y2i4C6gTV1lcthYso2WN4vPG9QPWHDB4r51CKbkc6C1oQytl0PPnJal4TSimvdD/Rx
	 fqXwCC1yZA3p6pRYnbA6WhknHmmCHqoK4R7Qh94g=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 0/1] KVM: arm64: nv: Implement nested stage-2 reverse map
Date: Sat, 11 Apr 2026 13:50:23 +0100
Message-ID: <20260411125024.3735989-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v2 of optimizing the shadow s2 mmu unmapping during MMU
notifiers. Thanks to Sashiko, who helped point out the many problems [1]
in v1.

* Changes from v1 [2]:

  - Rebased on to a newer kvmarm/next, where user_mem_abort() underwent
    a significant refactor.

  - Added a flag VALID_ENTRY (bit 63) to each non-polluted reverse map
    entry, so that if nested IPA == 0, we still insert a non-zero entry
    to the maple tree.

  - Added usage of the maple tree lock while using the tree. Previously
    I though I could piggyback on kvm->mmu_lock, but this doesn't work
    for 2 reasons:
      1. The maple tree advanced API (mas_*) expects the maple tree lock
         to be held.
      2. At stage-2 fault time, kvm->mmu_lock is only taken for read.
         Therefore even if 1. does not matter, parallel accesses to the
         maple tree could still happen.

  - Changed from using GFP_KERNEL_ACCOUNT to (GFP_NOWAIT | __GFP_ACCOUNT)
    in maple tree operations. This is done because GFP_KERNEL_ACCOUNT
    can sleep, and we are holding kvm->mmu_lock while doing the
    operations.

  - Made the code able to tolerate reverse map creation failure. In v1
    if a maple tree operation fails, the error is reported back to the
    caller which in the end fails the vCPU run. It shouldn't be this way
    as the reverse map is an optimization and it shouldn't fail the
    normal operation as we can fallback to a full unmap.

  - Added a boolean nested_revmap_broken in struct kvm_s2_mmu. If
    reverse map creation fails, the reverse map becomes unreliable. Keep
    this failure information with nested_revmap_broken so that we can
    fallback when we need to unmap.

  - Removed patch 2,3,4 for now. After we start using the maple tree
    lock, and keeping track of the reverse map failure state in
    nested_revmap_broken, the s2 mmu look up acceleration in v1 patch 2
    becomes very complicated, as the canonical maple tree used to speed
    up s2 mmu look up can also encounter allocation failures which we
    also need to keep track of and fallback. In the mean time the
    consistency between the trees is not easy to reason about when
    errors happen. Additionally, the extra lock of the canonical maple
    tree also needs to be considered and care must be taken to not
    introduce lock order inversion.
    Given the above I believe it is best to leave the reverse map
    improvements out for now, so as to not use too much time thinking
    about optimization before the initial version of the reverse map is
    even good.

Thanks!

[1]: https://sashiko.dev/#/patchset/20260330100633.2817076-1-weilin.chang%40arm.com
[2]: https://lore.kernel.org/kvmarm/20260330100633.2817076-1-weilin.chang@arm.com/

Wei-Lin Chang (1):
  KVM: arm64: nv: Avoid full shadow s2 unmap

 arch/arm64/include/asm/kvm_host.h   |   4 +
 arch/arm64/include/asm/kvm_nested.h |   4 +
 arch/arm64/kvm/mmu.c                |  30 ++++--
 arch/arm64/kvm/nested.c             | 147 +++++++++++++++++++++++++++-
 4 files changed, 177 insertions(+), 8 deletions(-)

-- 
2.43.0

