Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A93414A0F;
	Thu, 16 Jul 2026 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210988; cv=none; b=Ky5HllDoWMzS2gP+MMl/ScjBzd/PESxbeL56N8WT8jfFE1QGY8BA5nbpcXA5GbkfHf+6iifWsiSYHXKMUO3dhxSoaGL3BYbp9E15O2DgxiSBaKmm9A57xhKntoLUmHrVABIsBmYT6b1qitec+eewGFEqCP6/nKW65tRCvCgBZUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210988; c=relaxed/simple;
	bh=0fsmmTzgenUR+5YOqQSwOsxr1Lsokr6a1izso3JUfpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZQyvFK0cpnpqg/IW3wzTh0VMPm0LizenIzfxdnhCLfd5B+YT6wWxYEhioQf2xZ4LbFldb5d2vSrB/Y9GNIJHlMBMReL23O0KKdqaTTFTspg8YoFvEZssC9UQHbIzLxIysd5hR/TDWupgAqYabo/FtUJrcVgoLNHndb7pORC6Dmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZG8QCc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZG8QCc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DBB1F000E9;
	Thu, 16 Jul 2026 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784210987;
	bh=+iYNuLp5VhcQdIy1TVPO+FLdBIO/tWINeA+UpAktb2A=;
	h=From:To:Cc:Subject:Date;
	b=PZG8QCc0uwLOLItOHe7+zEKqOKQYFyR95so64L9tjATCmBKwMQ9344QclINBDLTIb
	 xnfxguyUcONdeMh4hZvVzrX4TeRbPNZq/sXhv3mNqz5vDE7TeyxMe8nLRoTRlaOL+8
	 thgDUFpWGbhWGdNm9JecuxlRg6SlDvXwHAkBwhEHx/Rl9QcfXjfx5WjE+iRXp43si1
	 ESUgmGIol3hu3OGyuzU1ucJZppdS0pH28Usk0XGyt9SzWQe6Y7/JAFZSwe+kbfizoy
	 ewHx6NgiJfGFdH25RBINYCqlygFitW0WQnC6xvKvMFKWx9N1I534SrUr34aFBsBqRH
	 545CugVEK9U2A==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC PATCH 0/5] KVM: arm64: Use TTBR1_EL2 for hVHE runtime mappings
Date: Thu, 16 Jul 2026 19:39:31 +0530
Message-ID: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hVHE currently disables TTBR1_EL2 and places both the identity mapping
and the hyp runtime mappings in TTBR0_EL2. As a result, it continues to
use the legacy nVHE virtual-address layout even though hVHE uses the
EL2&0 translation regime and can retain canonical kernel-image addresses.

This series moves the hVHE runtime mappings to TTBR1_EL2 and reserves
TTBR0_EL2 for the identity mapping used during MMU and page-table
transitions. Conventional VHE is unaffected, and nVHE continues to use
the existing TTBR0-only layout, including when protected mode is enabled.

The existing code does not consistently distinguish kernel-image symbols
from linear-map addresses because both currently use the same EL2
address transformation. The first four patches make this distinction
explicit by:

  - adding helpers for kernel-image symbol addresses;
  - splitting the hyp mapping APIs by address type;
  - providing separate symbol and linear VA-to-PA conversions; and
  - clarifying the private hyp VA allocation terminology.

The final patch implements the TTBR1 layout. Hyp symbols retain their
linked kernel-image VAs, while pools, per-CPU regions, SVE state and shared
memory continue to use linear-map addresses. A separate TTBR0 page table
contains the idmap, and both roots are installed during initial EL2 setup
and pKVM finalization.

The resulting layouts are:

  nVHE:
    TTBR0_EL2: idmap and runtime mappings
    TTBR1_EL2: unused

  hVHE:
    TTBR0_EL2: idmap
    TTBR1_EL2: runtime mappings

Cc: Marc Zyngier <maz@kernel.org> 
Cc: Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>

Aneesh Kumar K.V (Arm) (5):
  KVM: arm64: Make hyp symbol address conversion explicit
  KVM: arm64: Split hyp mapping APIs by address type
  KVM: arm64: Split hyp VA-to-PA conversion by address type
  KVM: arm64: Rename the hyp private VA allocation base
  KVM: arm64: Use TTBR1_EL2 for hVHE runtime mappings

 arch/arm64/include/asm/kvm_asm.h         |  13 +--
 arch/arm64/include/asm/kvm_host.h        |   2 +
 arch/arm64/include/asm/kvm_hyp.h         |   4 +-
 arch/arm64/include/asm/kvm_mmu.h         |  89 ++++++++++++++--
 arch/arm64/include/asm/kvm_pgtable.h     |  27 +++++
 arch/arm64/include/asm/kvm_pkvm.h        |   3 +
 arch/arm64/kernel/asm-offsets.c          |   5 +-
 arch/arm64/kvm/arm.c                     |  92 +++++++++-------
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  13 +--
 arch/arm64/kvm/hyp/include/nvhe/mm.h     |   9 +-
 arch/arm64/kvm/hyp/nvhe/early_alloc.c    |   1 +
 arch/arm64/kvm/hyp/nvhe/events.c         |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S           |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S       |  29 ++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    |  30 +++---
 arch/arm64/kvm/hyp/nvhe/mm.c             | 110 +++++++++++++------
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     |  12 +--
 arch/arm64/kvm/hyp/nvhe/setup.c          |  55 +++++++---
 arch/arm64/kvm/hyp/pgtable.c             |  62 ++++++++++-
 arch/arm64/kvm/hyp_trace.c               |   2 +-
 arch/arm64/kvm/mmu.c                     | 128 ++++++++++++++++-------
 arch/arm64/kvm/pkvm.c                    |   3 +
 arch/arm64/kvm/va_layout.c               |  32 +++++-
 23 files changed, 546 insertions(+), 181 deletions(-)


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.43.0

