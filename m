Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B98388E72
	for <kvmarm@lists.linux.dev>; Sun, 10 May 2026 14:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424865; cv=none; b=sMBAOjoNF7qtyTqa1Bpz9bIDaA7Q4Vn15+EKPKQGzPQWLxiZGCJXdKQr6v+cjTdC51+mnJiEMH1VSur37Bt9DznurSmDawEhLMq06t6Bfin7yf6KlrH0JG13M+p/g0BVjcgDjvbwGJQViCLtZH+JM8e/NCleG4LvAeY0c2ol7vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424865; c=relaxed/simple;
	bh=VYxBiY24h03tiLKCKU1MSqB/0xqzgQWJIyjoe5z/fSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bLlVCjHYA6A1egZGMUaXGUgQiPjiHtV+8K1FUbSrTtJsxwqSTgS+6QiB5WTRxOiZe8RqWlO1H807VP5jL3hksQaBM+mV1/xC4Z3TJVj31bPAskDQpCLXH1XJrQk/zZ8XhqNpKT0Eb+Yt0ggl8B94HM64YCHn1zQcO96poOY0r1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Rka61JTu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Rka61JTu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E135F1D13;
	Sun, 10 May 2026 07:54:09 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C80E23F836;
	Sun, 10 May 2026 07:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778424855; bh=VYxBiY24h03tiLKCKU1MSqB/0xqzgQWJIyjoe5z/fSg=;
	h=From:To:Cc:Subject:Date:From;
	b=Rka61JTu1CsueQ86DnzZVem2PUA3yQTxo1jUnXzPgfs4eezOnsefjvySxeydpwHSq
	 4aTW8AOA+15xe3RLfifA8WoYpIwwMsr3fZvJXH2dnkQmECVFpQcIFoEza6ABOT2dx4
	 VTcO2j8J3EfBQR3uCZtLiZ5S0GL1oaYiUKeFHwgM=
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
Subject: [PATCH v3 0/5] KVM: arm64: nv: Implement nested stage-2 reverse map
Date: Sun, 10 May 2026 15:53:33 +0100
Message-ID: <20260510145338.322962-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v3 of optimizing the shadow s2 mmu unmapping during MMU
notifiers.

Two new preparatory patches are added, one reduces a hole in kvm_s2_mmu
and another refactors the code a bit during s2 faults. Other changes are
listed below.

* Changes from v2 [1]:

  - Removed "polluted" teminology.

  - Use xa_{mk, to}_value() when storing and retriving values from maple
    trees.

  - Avoid using the 63rd bit in maple tree values so that xa_{mk, to}_value()
    does not lose us a bit.

  - Added reverse map removal during TLBI handling.

  - Other suggested refactorings.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260411125024.3735989-1-weilin.chang@arm.com/

Wei-Lin Chang (5):
  KVM: arm64: Use a variable for the canonical GPA in kvm_s2_fault_map()
  KVM: arm64: Move shadow_pt_debugfs_dentry to reduce holes in
    kvm_s2_mmu
  KVM: arm64: nv: Avoid full shadow s2 unmap
  KVM: arm64: nv: Remove reverse map entries during TLBI handling
  KVM: arm64: nv: Create nested IPA direct map to speed up reverse map
    removal

 arch/arm64/include/asm/kvm_host.h   |  17 +-
 arch/arm64/include/asm/kvm_nested.h |   6 +
 arch/arm64/kvm/mmu.c                |  43 +++--
 arch/arm64/kvm/nested.c             | 238 +++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c           |   3 +
 5 files changed, 290 insertions(+), 17 deletions(-)

-- 
2.43.0

