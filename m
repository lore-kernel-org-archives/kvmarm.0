Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FD1302750;
	Thu, 26 Feb 2026 10:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772103070; cv=none; b=ItdXLPyFHr6x3KbTRsLQFQtAPWvOxbEu4mqzbPzF4mLYVZsSoBNE3rDowVIHRb2mXqOnyNvx2ScAln6TYaswW2HW6/R821sCYQ/kJPU9n9alPZlSyObIKdOrr06dHpiXeOsZL/sj82T8OJttW1liDD/oHm8cK9isf9DbNy124yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772103070; c=relaxed/simple;
	bh=c2H9Qi49m5+C4KxTW0j8/WB4GcymfvOF1Dx3C8KYFFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SJ8e9T9sIuH/GsrVD+OR0SHQbWjpcjzU7FyigCsVzWxCkJYCESaD+lBRME4hx5sd+562JNIG9NRKrF8Jt5MfZNtVPaxTM1yn9rkhwVePAc4H1WryN5orDQI/IPMVKvn4pHqEY0rNIySyrQVJWVV7H/ahANNQxQlo8iNMQGgUJ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eq0N/CcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eq0N/CcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C381FC2BC9E;
	Thu, 26 Feb 2026 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772103069;
	bh=c2H9Qi49m5+C4KxTW0j8/WB4GcymfvOF1Dx3C8KYFFs=;
	h=From:To:Cc:Subject:Date:From;
	b=Eq0N/CcVRqyeonDZJrXv9xf3VwFC3Mrxsw0GwBo1up49FgA9c+Wv+Vdo0yenwTCM/
	 c7lUFm8KvlVKebR1w3mheBfxkQ+C9gadmCPvyhJg1KzY+CsACuJjyd7xR90llaFNnW
	 o/YRAfhqXTXF44ytY4W/xynrOigplzqcDObe8xIgASJc02kex8sdfkwLnrungkIk2A
	 tuVUBLKBur7cE+h9zRtE+6vzLKx+SHiEr3KtUyfiw2pKnDxyZIWXBNlqdjaQ0Si8aZ
	 3WTxHdG3WZH9tK/MeC7b1jMxRBLovlNNY1XF+8XHWq7eJByIZ/D3EU5SZUUHppwGEN
	 T6rX32Xvv4jIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vvYxX-0000000E12u-3VQk;
	Thu, 26 Feb 2026 10:51:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Kees Cook <kees@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.0, take #1
Date: Thu, 26 Feb 2026 10:50:47 +0000
Message-ID: <20260226105048.28066-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, tabba@google.com, joey.gouly@arm.com, jonathan.cameron@huawei.com, kees@kernel.org, broonie@kernel.org, sascha.bischoff@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the first set of KVM/arm64 fixes for 7.0. Most of it affects
pKVM (feature set, MMU), but we also have a GICv5 fix and a couple of
small cleanups. Details in the tag below.

Note that there is a very minor conflict with Linus' tree due to Kees'
patch having been applied to both trees. Whatever is in Linus' tree is
the right thing.

Please pull,

	M.

The following changes since commit 6316366129d2885fae07c2774f4b7ae0a45fb55d:

  Merge branch kvm-arm64/misc-6.20 into kvmarm-master/next (2026-02-05 09:17:58 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.0-1

for you to fetch changes up to 54e367cb94d6bef941bbc1132d9959dc73bd4b6f:

  KVM: arm64: Deduplicate ASID retrieval code (2026-02-25 12:19:33 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 7.0, take #1

- Make sure we don't leak any S1POE state from guest to guest when
  the feature is supported on the HW, but not enabled on the host

- Propagate the ID registers from the host into non-protected VMs
  managed by pKVM, ensuring that the guest sees the intended feature set

- Drop double kern_hyp_va() from unpin_host_sve_state(), which could
  bite us if we were to change kern_hyp_va() to not being idempotent

- Don't leak stage-2 mappings in protected mode

- Correctly align the faulting address when dealing with single page
  stage-2 mappings for PAGE_SIZE > 4kB

- Fix detection of virtualisation-capable GICv5 IRS, due to the
  maintainer being obviously fat fingered...

- Remove duplication of code retrieving the ASID for the purpose of
  S1 PT handling

- Fix slightly abusive const-ification in vgic_set_kvm_info()

----------------------------------------------------------------
Fuad Tabba (5):
      KVM: arm64: Hide S1POE from guests when not supported by the host
      KVM: arm64: Optimise away S1POE handling when not supported by host
      KVM: arm64: Fix ID register initialization for non-protected pKVM guests
      KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
      KVM: arm64: Revert accidental drop of kvm_uninit_stage2_mmu() for non-NV VMs

Kees Cook (1):
      KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocation type

Marc Zyngier (2):
      KVM: arm64: Fix protected mode handling of pages larger than 4kB
      KVM: arm64: Deduplicate ASID retrieval code

Sascha Bischoff (1):
      irqchip/gic-v5: Fix inversion of IRS_IDR0.virt flag

 arch/arm64/include/asm/kvm_host.h   |  3 +-
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/at.c                 | 27 ++--------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c      | 37 ++++++++++++++++++++--
 arch/arm64/kvm/mmu.c                | 12 +++----
 arch/arm64/kvm/nested.c             | 63 ++++++++++++++++++-------------------
 arch/arm64/kvm/sys_regs.c           |  3 ++
 arch/arm64/kvm/vgic/vgic-init.c     |  2 +-
 drivers/irqchip/irq-gic-v5-irs.c    |  2 +-
 9 files changed, 81 insertions(+), 70 deletions(-)
