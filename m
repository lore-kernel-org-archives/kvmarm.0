Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935EE1C3C
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 10:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457BBC4339B;
	Thu, 30 Mar 2023 10:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680170670;
	bh=9P7LkQLEWlJTRm6xqtW1xlMAqA5p/B8OqoSHBTb8hIM=;
	h=From:To:Cc:Subject:Date:From;
	b=B6AYk+kSbeM0du1oo6Z9QHG75LZLVn9Msm04oSJ9q2oVaaDpkHOmNk6viLKxvLYfK
	 ZGRocDCBUI1rfEZ0UKJpcj2rOOms0hMn74jmQ72XWHS3ZHYQUWn9SaYzOIT4jKsPU2
	 ZEXgXJJ025BRG3Z4X5+9oM0jyJr6ntNJprlM9f8fkWVQTKvx3H7jQpDGIFSvnBD/be
	 dc5N+Sh1D5t7UlunvG4oUzPXF3N53taksJ/mMWsaugsAT/wR7HC6DiqSszIRNOZXkR
	 vImVZHQnr+e/0yOv55LJUaxzIhB1Imm6Wo42eT/L/5PqxkFBmi9Ismu0Fmto2JW6Jo
	 wVoa+oXTPBBqw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1php8t-004K66-Sm;
	Thu, 30 Mar 2023 11:04:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Synchronise speculative page table walks on translation regime change
Date: Thu, 30 Mar 2023 11:04:17 +0100
Message-Id: <20230330100419.1436629-1-maz@kernel.org>
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

Marc Zyngier (2):
  KVM: arm64: nvhe: Synchronise with page table walker on MMU update
  KVM: arm64: vhe: Synchronise with page table walker on MMU update

 arch/arm64/kvm/hyp/nvhe/debug-sr.c    |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c      | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c         |  7 +++++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c    | 12 ++++++++++++
 5 files changed, 44 insertions(+), 2 deletions(-)

-- 
2.34.1

