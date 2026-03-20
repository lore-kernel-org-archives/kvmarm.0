Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA0938237C;
	Fri, 20 Mar 2026 09:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773999717; cv=none; b=Ttjcds0kIOq+q06egTZzlQbVVu1kiw/Dg/dUsWPuRQaRdMDaGPi2iomg7+NY1IgxSt03u7sVAavCsNFJkIIvst4H5LuLU80RTWa2ynAFabimog+IGNJdPruRrtUYOorUjHKvP5o+NAaZFLHYMY9ebMWZrAQEOI5Wb1KypJTDOM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773999717; c=relaxed/simple;
	bh=soIqa4dzdt6xuh4ZUR/8xPfEZyQ1j13Pr9d2gnaHB40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TQjUj3sUVqRNiUiO9jSbOyAHhRkvluE5BeUEYiDPjZgZwRBODuYNx0EIAWwR7F0JCAlTMJK1Uxp5NTIkxYQav1WNMtT1F6YWnL38mTHPoes2GxddcdAFJ4VTPKn4DRDBRT31YW+b5ha49sgY7ik6p4NjPHjJQU2lF9/eXZteCOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sj6ciDui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sj6ciDui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F8CC2BC9E;
	Fri, 20 Mar 2026 09:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773999716;
	bh=soIqa4dzdt6xuh4ZUR/8xPfEZyQ1j13Pr9d2gnaHB40=;
	h=From:To:Cc:Subject:Date:From;
	b=sj6ciDui8CjDNSMD0/3hKM++txW1In4032U7a9Gzn/bDGyOjNKMCgRU3D+5g05h39
	 Wfymiq4JtDGYnblfss7lcCAlHbeYj3CQ2Cm/LtqjX3Os73oQj3a/V9SJwaRqWPRD2U
	 o4mWtVUONEKgc0MWCiPcV0sGPy9G1CkmcV6MNQ6nlDbEEd7ZsD/YV7qcefAC91Zn/8
	 WndxrHnvWRMPhAvRJr7+6qn7cdrDPAo8EoxCqEfSVpQWrtY+kX2Kk9R3Hb/dLVXtQl
	 Y8/TTr8eiaokutz4dJxgbOi4IrcPbmaLCcCSdq3x+zh4J6tng3pCtu7lf6pfrWqzIj
	 eWZ9H5XLp3reQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w3WMc-00000003xdR-1ILK;
	Fri, 20 Mar 2026 09:41:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.0, take #4
Date: Fri, 20 Mar 2026 09:41:51 +0000
Message-ID: <20260320094151.2541661-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, joey.gouly@arm.com, suzuki.poulose@arm.com, zenghui.yu@linux.dev, oupton@kernel.org, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Another week, another set of fixes. This time, another two fixes,
mostly observable with nested virt. The first one results in a vcpu
coming out of reset potentially skipping the first instruction at its
initial PC. The second one is a classic example of pointer arithmetic
going wrong in our address translation emulation, setting the access
bit in semi-random places. Both are stable candidates.

Please pull,

	M.

The following changes since commit a79f7b4aeb8e7562cd6dbf9c223e2c2a04b1a85f:

  KVM: arm64: pkvm: Don't reprobe for ICH_VTR_EL2.TDS on CPU hotplug (2026-03-10 09:48:45 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.0-4

for you to fetch changes up to 0496acc42fb51eee040b5170cec05cec41385540:

  KVM: arm64: Fix the descriptor address in __kvm_at_swap_desc() (2026-03-17 13:40:00 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 7.0, take #4

- Clear the pending exception state from a vcpu coming out of
  reset, as it could otherwise affect the first instruction
  executed in the guest.

- Fix the address translation emulation icode to set the Hardware
  Access bit on the correct PTE instead of some other location.

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Discard PC update state on vcpu reset

Zenghui Yu (Huawei) (1):
      KVM: arm64: Fix the descriptor address in __kvm_at_swap_desc()

 arch/arm64/kvm/at.c    |  2 +-
 arch/arm64/kvm/reset.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)
