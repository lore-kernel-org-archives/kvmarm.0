Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51AC2113
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 08:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B32C433D2;
	Thu, 13 Apr 2023 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681373690;
	bh=hoKygbPOL58I+YlWlRe195xdYNCWVBya3lVdmeUY5ok=;
	h=From:To:Cc:Subject:Date:From;
	b=HhNMsD7r0RmlyqIM3GARmEas2zRJLln65AaS8Tm0urK2jYOnLhPSv9ugPdS8fj5Ln
	 fFl811ythOvewVTkyKKB2WXHFaMy12xBI6jOyEA6AZhqhLuYB6vYiWgbOp/aT5goTE
	 iRWLVFP7JeznsZGfX7FmXnnLRHhb5J87LHLenyPsycJDka++QWWEWHdMRZDQ0GMr+Y
	 xhpua5HPDQmz6cPCuPIAT8TgpqXQ0+j0g93UKzpWPN77cIWBPC7zFkSq3peCjW0K+g
	 1lSjUYJ89TCx7wEAVq+NRzSKzPJCVaczjou9EgOM1HmsOIgXX7rl6fgZmx2lqn4Agm
	 3dpG3fC2zraxg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pms6S-0082qd-4H;
	Thu, 13 Apr 2023 09:14:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v3 0/5] KVM: arm64: Synchronise speculative page table walks on translation regime change
Date: Thu, 13 Apr 2023 09:14:36 +0100
Message-Id: <20230413081441.165134-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It recently became apparent that the way we switch our EL1&0
translation regime is not entirely fool proof.

On taking an exception from EL1&0 to EL2(&0), the page table walker is
allowed to carry on with speculative walks started from EL1&0 while
running at EL2 (see R_LFHQG). Given that the PTW may be actively using
the EL1&0 system registers, the only safe way to deal with it is to
issue a DSB before changing any of it.

We already did the right thing for SPE and TRBE, but ignored the PTW
for unknown reasons (probably because the architecture wasn't crystal
clear at the time).

This requires a bit of surgery in the nvhe code, though most of these
patches are comments so that my future self can understand the purpose
of these barriers. The VHE code is largely unaffected, thanks to the
DSB in the context switch.

The last patch isn't directly related, but a superfluous ISB was
spotted while working on this series.

- From v2 [2]

  - Give an option to the nVHE TLBI code to still issue non-shareable
    DSBs, as there are pending patches making use of it.

  - Collected Oliver's RBs, with thanks.

- From v1 [1]

  - Upgraded TLBIs' dsb(ishst) to dsb(ish) to cover the PTW's required
    barrier (thanks to Oliver for spotting the issue)

  - Split the nVHE patch into 3 distinct patches for ease of
    reviewing.

  - Brought the extra ISB patch into this series despite having been
    previously posted separately.

[1] https://lore.kernel.org/r/20230330100419.1436629-1-maz@kernel.org
[2] https://lore.kernel.org/r/20230408160427.10672-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
  KVM: arm64: nvhe: Synchronise with page table walker on TLBI
  KVM: arm64: pkvm: Document the side effects of
    kvm_flush_dcache_to_poc()
  KVM: arm64: vhe: Synchronise with page table walker on MMU update
  KVM: arm64: vhe: Drop extra isb() on guest exit

 arch/arm64/kvm/hyp/nvhe/debug-sr.c    |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  7 +++++
 arch/arm64/kvm/hyp/nvhe/switch.c      | 18 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c         | 38 ++++++++++++++++++++-------
 arch/arm64/kvm/hyp/vhe/switch.c       |  7 +++--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c    | 12 +++++++++
 6 files changed, 69 insertions(+), 15 deletions(-)

-- 
2.34.1

