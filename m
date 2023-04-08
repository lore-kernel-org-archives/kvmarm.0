Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245E1FA5
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130CAC433EF;
	Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680969891;
	bh=hg6RAAZhvGMSBawM1bRD92ygWbXnuqMRwmQvdQ5mTXI=;
	h=From:To:Cc:Subject:Date:From;
	b=rTcL4AgtAZN3Yq0wz1zoYB2LKHpQKfgckOYmxGMmClE1S9fk5I4rOqeGL+irW5tY9
	 4g7k6hvj6MTWP8CHYFEOpcXxrTV0sOQ94h7g0YIAddG6FwjfCb/uSRUFtngTq0+xL1
	 uNc7Lw2eWOgmQucET6ZuKgsDh9Efy5n3fn0Td7g9WdqlHPk3qUJ/RnmfyMeIsBeL9n
	 Wn5VetwmX7moDuYgb2bFDPC6BxBd+1IjcIcH7lCIRbC7vOaJSjA5aBsa/d46v/wlh1
	 2n2GrO0xP/StzVXp2jYabTXh16o7MB6FzbtGJgTJhrsWq4iXMD/B5if7z6ZRe3N7cT
	 HbgJjg3KS4KoA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1plB3Y-006wc5-Md;
	Sat, 08 Apr 2023 17:04:48 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 0/5] KVM: arm64: Synchronise speculative page table walks on translation regime change
Date: Sat,  8 Apr 2023 17:04:22 +0100
Message-Id: <20230408160427.10672-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org
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

- From v1 [1]

  - Upgraded TLBIs' dsb(ishst) to dsb(ish) to cover the PTW's required
    barrier (thanks to Oliver for spotting the issue)

  - Split the nVHE patch into 3 distinct patches for ease of
    reviewing.

  - Brought the extra ISB patch into this series despite having been
    previously posted separately.

[1] https://lore.kernel.org/r/ZC75v6kEe06omSc6@linux.dev

Marc Zyngier (5):
  KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
  KVM: arm64: nvhe: Synchronise with page table walker on TLBI
  KVM: arm64: pkvm: Document the side effects of
    kvm_flush_dcache_to_poc()
  KVM: arm64: vhe: Synchronise with page table walker on MMU update
  KVM: arm64: vhe: Drop extra isb() on guest exit

 arch/arm64/kvm/hyp/nvhe/debug-sr.c    |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c      | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c         | 24 +++++++++++++++++++-----
 arch/arm64/kvm/hyp/vhe/switch.c       |  7 +++----
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c    | 12 ++++++++++++
 6 files changed, 59 insertions(+), 11 deletions(-)

-- 
2.34.1

