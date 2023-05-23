Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994E01E52D
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 10:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA34C433EF;
	Tue, 23 May 2023 10:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684837114;
	bh=QpvcCky08LZ7m2ESjkii8rm59GSyQ3gaOmbK/Q+UTLc=;
	h=From:To:Cc:Subject:Date:From;
	b=p2kyKCeA+1H9SUF0OO0Vq5O0yBRQPnRmyx8m8Dgnahgqf+RV6pkpLkeAL2cFdDnHE
	 Bk/l+oShre6ry8GhvxDjU71vq4v6i6CQZcHKWxnZ8tHm6Y/HnNDDMzWsTug/q9nqqZ
	 MD8aobuFzvCb3UXtQCJxkIC6JM6KcTfDTpLQdFF9weRfG328vjC6CNNBRSWaiQekTK
	 vU8Jc2+jQWPbDcZip0VpJ1swZcGLoAtjoBPbQ7tOw3m7mNmENmpCPXKmM/U+J+0U+S
	 R427jZ5r51/KstKLJRhEOcpNrWA3kFzFuADaHmN4Y/NScDjK3nt+WJxscyxxJmfeeJ
	 KUl/W0BKtAuVw==
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
Subject: [PATCH v3 00/10] KVM: arm64: FF-A proxy for pKVM
Date: Tue, 23 May 2023 11:18:17 +0100
Message-Id: <20230523101828.7328-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is version three of the pKVM FF-A proxy series previously posted
here:

v1: https://lore.kernel.org/r/20221116170335.2341003-1-qperret@google.com
v2: https://lore.kernel.org/r/20230419122051.1341-1-will@kernel.org

Changes since v2 include:

  * Rename 'spmd_' functions per suggestion from Oliver
  * Add some more comments
  * Rebase onto 6.4-rc3

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
 arch/arm64/kvm/hyp/nvhe/ffa.c                 | 762 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   3 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  68 ++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  11 +
 arch/arm64/kvm/pkvm.c                         |   1 +
 include/linux/arm_ffa.h                       |   8 +
 12 files changed, 897 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/ffa.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ffa.c

-- 
2.40.1.698.g37aff9b760-goog

