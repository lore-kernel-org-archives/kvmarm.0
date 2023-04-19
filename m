Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034503C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F927C433D2;
	Wed, 19 Apr 2023 12:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906857;
	bh=rA2NVapRKVq6pSok9jZ56EUOGF6qa9D2K7nw8bxw+2A=;
	h=From:To:Cc:Subject:Date:From;
	b=IUqJ66fIBJVaPCLgPI9gL+4XqGCMiFkFJLs0jM2whm1zUdbX2kxHfEZopPKzFICwj
	 vKSIoGbzuLvlKKk9b14lVs+UFvdvpbLdZITf5fDyYUQkPP5CjbeIz9SDXp0aFp1qxm
	 LrSSPs2amlnXT8TeTp2hCYBmURqLnei2KhCX57to29yXD19UbEXptPV/UjCGIEkjHo
	 661Y9OkPurOI+N9DzYRHzhE1alUh+dZp92ebZ8CKIzItfL7WH5LgfleFHMdyonPx9r
	 0rorGjLiJbHFtJNjQ7ryQIcWswsDCQoQLFgNR4TQDmskQubW0DyHiFhh/NVK0b5crL
	 lXjcKUQLSTBYA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: [PATCH v2 00/10] KVM: arm64: FF-A proxy for pKVM
Date: Wed, 19 Apr 2023 13:20:41 +0100
Message-Id: <20230419122051.1341-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is the second version of the pKVM FF-A proxy patches that were
originally posted by Quentin a while back:

	https://lore.kernel.org/r/20221116170335.2341003-1-qperret@google.com

As described in the original cover letter, these patches provide a
mechanism for pKVM to intercept memory being shared between the host
and Trustzone in order to prevent "confused deputy" attacks where the
host can ask Trustzone to access protected guest pages.

Changes since v1 include:

  * Remove double negatives by inverting ffa_call_unsupported() into
    ffa_call_supported()

  * Re-order patch series so that FFA_FEATURES doesn't advertise
    unimplemented functions during bisection

  * Rework patches to introduce function switch case by case

  * Dropped the first two changes as they have been merged upstream

  * Dropped stray "ANDROID:" prefix from the final patch

Thanks to Oliver for his comments on the initial posting.

Patches based on -rc7 and also pushed here:

git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git kvm/ffa-proxy

Cheers,

Will

Cc: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Sebastian Ene <sebastianene@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev
Cc: kernel-team@android.com

--->8	  

Fuad Tabba (1):
  KVM: arm64: Handle FFA_FEATURES call from the host

Quentin Perret (1):
  KVM: arm64: pkvm: Add support for fragmented FF-A descriptors

Will Deacon (8):
  KVM: arm64: Block unsafe FF-A calls from the host
  KVM: arm64: Probe FF-A version and host/hyp partition ID during init
  KVM: arm64: Allocate pages for hypervisor FF-A mailboxes
  KVM: arm64: Handle FFA_RXTX_MAP and FFA_RXTX_UNMAP calls from the host
  KVM: arm64: Add FF-A helpers to share/unshare memory with secure world
  KVM: arm64: Handle FFA_MEM_SHARE calls from the host
  KVM: arm64: Handle FFA_MEM_RECLAIM calls from the host
  KVM: arm64: Handle FFA_MEM_LEND calls from the host

 arch/arm64/include/asm/kvm_host.h             |   1 +
 arch/arm64/include/asm/kvm_pkvm.h             |  21 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/hyp/include/nvhe/ffa.h         |  17 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   3 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 | 745 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   3 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  68 ++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  11 +
 arch/arm64/kvm/pkvm.c                         |   1 +
 include/linux/arm_ffa.h                       |   8 +
 12 files changed, 880 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/ffa.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ffa.c

-- 
2.40.0.634.g4ca3ef3211-goog

