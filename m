Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA9B28E11
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 14:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC38BC433B6;
	Thu, 14 Sep 2023 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694702901;
	bh=elTaVfoRjBAQ+RlyBd8HEpdgL87y4NjXRY4zEkFLP1A=;
	h=From:To:Cc:Subject:Date:From;
	b=TW6Bym8Oh7v/18JtJe1Xo1GeJcM/NCNKRtV6UTvMcKZUB53s0atl+kO/tVpcN1OEa
	 RZQfCpdY5U8mdymgvBzDLhOLwamo1tzsKEgRRj5729G3kSoWTCn1aoJFRzmYu1HgEz
	 Yz7y6b8ADrybcFFw8o3HQHmNyVEfHwVBUpnGCMCK7c5I6vXOtqXzl5emY80kzglrQ+
	 MqK7hNnIvL5U/Eltu0Kvj3iU9Dsd25SyKwHNSoWDgNN/rOnoAwAWVF0b0i1MERn1ZA
	 i200P8K+SLDQTqb/cqpf3Jb1Z8zMUn4WluPdESBbSonmrvzd8yYBoc3BMz93Y96hwB
	 Etr0lOC2GMj2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qgndi-00Cx4Y-8z;
	Thu, 14 Sep 2023 15:48:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.6, take #1
Date: Thu, 14 Sep 2023 15:48:02 +0100
Message-Id: <20230914144802.1637804-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ben.horgan@arm.com, jean-philippe@linaro.org, m.szyprowski@samsung.com, philmd@linaro.org, vdonnefort@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the first set of fixes for 6.6, addressing two regressions: use
of uninitialised memory as a VA to map the GICv2 CPU interface at EL2
stage-1, and a SMCCC fix covering the use of the SVE hint.

Please pull.,

	M.

The following changes since commit 0bb80ecc33a8fb5a682236443c1e740d5c917d1d:

  Linux 6.6-rc1 (2023-09-10 16:28:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.6-1

for you to fetch changes up to 373beef00f7d781a000b12c31fb17a5a9c25969c:

  KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID (2023-09-12 13:07:37 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.6, take #1

- Fix EL2 Stage-1 MMIO mappings where a random address was used

- Fix SMCCC function number comparison when the SVE hint is set

----------------------------------------------------------------
Jean-Philippe Brucker (1):
      KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID

Marc Zyngier (1):
      KVM: arm64: Properly return allocated EL2 VA from hyp_alloc_private_va_range()

 arch/arm64/include/asm/kvm_hyp.h      | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/ffa.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 3 +--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S    | 1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 8 ++++++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c  | 3 +--
 arch/arm64/kvm/mmu.c                  | 3 +++
 include/linux/arm-smccc.h             | 2 ++
 8 files changed, 16 insertions(+), 8 deletions(-)
