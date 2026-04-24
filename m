Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0695D2D131D;
	Fri, 24 Apr 2026 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777043704; cv=none; b=r5BYuiObnwoi8wkk0UMj7u5GbRk0iTpRlHXZZOMaH5KfE91y9xMFImGrQm+kKf+o9QdnaRPrwVdH2H/somv3r8pLXVxkUNOkNBuzaityYIqgTgAVvH357c9T9BUlWCuY+bFLtsTtFw9WpoT9Dr8ZlRL7K7zKIv++yLaw3M6Qp+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777043704; c=relaxed/simple;
	bh=g9K5mfNblRY0b8MrHwI5cfWeLShbsP+DXXMV5iplhIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NvMooC+hWCYkOb4EaxyEdl4x/XGyiUU5eRzyi1SyoFaPwmsVK/50xc+k7dNtto4riVUNNc8y0bhRzI9hBhLKg+oC3tlhPcx/XaO3p/8Ru1p42cLIH1YFVgwguKvgja9LAsPQKjWiMyqQkx2DjetgV5RmRzjyJX13KSE/acMeAOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixejiLbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixejiLbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834ECC19425;
	Fri, 24 Apr 2026 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777043703;
	bh=g9K5mfNblRY0b8MrHwI5cfWeLShbsP+DXXMV5iplhIU=;
	h=From:To:Cc:Subject:Date:From;
	b=ixejiLbCe6paehrBYEgux/SsbNRd7z0hbwWE3TgN2pwgIIvCNGNdeIfJ9tK+Y95ru
	 oYaLVhKd6Wllz358gOUojfmSejLRJaq+8q2GtBDJSqIF4nk6OZJQ6/BVQd4QkqyQ96
	 ldDaQq40R4xj6QDnnWHhlWhEi+PQXPRroBHYyyNn7s2jUbQIiXAOVO4qK0/Go7MVOq
	 Nd+KX3P0gBE2ckpNniPIZJwnRslVs5KS8h36Bqe/8HtCpLmeKF7CHLG5lMGjkQpd9m
	 Yd6X1/oKxy3NNdUCBIkWsAma9wwIRyxwe5tYXqGw3H+nihQkZTNnMm67JWCEGkV81Y
	 2fsMq98wGr6EA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wGIFA-0000000EPWA-2PuZ;
	Fri, 24 Apr 2026 15:15:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ben Simner <ben.simner@cl.cam.ac.uk>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Fuad Tabba <tabba@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.1, take #1
Date: Fri, 24 Apr 2026 16:14:43 +0100
Message-ID: <20260424151443.750077-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ben.simner@cl.cam.ac.uk, dwmw@amazon.co.uk, tabba@google.com, qperret@google.com, sebastianene@google.com, vdonnefort@google.com, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

This is the first drop of KVM/arm64 fixes for 7.1. Nothing really
major so far, but a rather wide range of fixes for idreg handling,
long standing regressions, SMCCC compliance and more. Add a few
cleanups to the fix, and that's about it. As usual, gory details in
the tag below.

Please pull,

	M.

The following changes since commit 94b4ae79ebb42a8a6f2124b4d4b033b15a98e4f9:

  Merge branch kvm-arm64/misc-7.1 into kvmarm-master/next (2026-04-08 12:26:11 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.1-1

for you to fetch changes up to 4ce98bf0865c349e7026ad9c14f48da264920953:

  KVM: arm64: Wake-up from WFI when iqrchip is in userspace (2026-04-24 12:03:57 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 7.1, take #1

- Allow tracing for non-pKVM, which was accidentally disabled when
  the series was merged

- Rationalise the way the pKVM hypercall ranges are defined by using
  the same mechanism as already used for the vcpu_sysreg enum

- Enforce that SMCCC function numbers relayed by the pKVM proxy are
  actually compliant with the specification

- Fix a couple of feature to idreg mappings which resulted in the
  wrong sanitisation being applied

- Fix the GICD_IIDR revision number field that could never been
  written correctly by userspace

- Make kvm_vcpu_initialized() correctly use its parameter instead
  of relying on the surrounding context

- Enforce correct ordering in __pkvm_init_vcpu(), plugging a
  potential pin leak at the same time

- Move __pkvm_init_finalise() to a less dangerous spot, avoiding
  future problems

- Restore functional userspace irqchip support after a four year
  breakage (last functional kernel was 5.18...). This is obviously
  ripe for garbage collection.

- ... and the usual lot of spelling fixes

----------------------------------------------------------------
David Woodhouse (1):
      KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value

Fuad Tabba (5):
      KVM: arm64: Fix FEAT_Debugv8p9 to check DebugVer, not PMUVer
      KVM: arm64: Fix typo in feature check comments
      KVM: arm64: Fix FEAT_SPE_FnE to use PMSIDR_EL1.FnE, not PMSVer
      KVM: arm64: Fix kvm_vcpu_initialized() macro parameter
      KVM: arm64: Fix pin leak and publication ordering in __pkvm_init_vcpu()

Marc Zyngier (2):
      KVM: arm64: pkvm: Adopt MARKER() to define host hypercall ranges
      KVM: arm64: Wake-up from WFI when iqrchip is in userspace

Quentin Perret (1):
      KVM: arm64: Fix initialisation order in __pkvm_init_finalise()

Sebastian Ene (1):
      KVM: arm64: Reject non compliant SMCCC function calls in pKVM

Vincent Donnefort (1):
      KVM: arm64: Re-allow hyp tracing HVCs for [nh]VHE

 arch/arm64/include/asm/kvm_asm.h   | 28 ++++++++++++++++++----------
 arch/arm64/include/asm/kvm_host.h  |  5 +----
 arch/arm64/kvm/arm.c               |  4 ++++
 arch/arm64/kvm/config.c            | 23 ++++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 30 +++++++++++++++++-------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 38 +++++++++++++++++++++++++-------------
 arch/arm64/kvm/hyp/nvhe/setup.c    |  6 +++---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
 9 files changed, 86 insertions(+), 52 deletions(-)
