Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567772C9C
	for <kvmarm@lists.linux.dev>; Thu, 13 Oct 2022 13:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143B6C433D6;
	Thu, 13 Oct 2022 13:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1665667719;
	bh=7qXYLfXPY0mId4qeNUYUUP+ocY1lWzzGimuibv53pf8=;
	h=From:To:Cc:Subject:Date:From;
	b=QvN6AmRAzltS5HKUQE0RXOLnSQb7prK5hOldTl9Ue51CAVa3AXFgUbeRlzkbf2FEj
	 FTdrupsmEW426bZ6oKCYzW9cKqjC/ZrfqPUS6y5Zff3+GmUrvDCY5AaxWtC6ufFxA/
	 hMd/DBSY3MdKoweB8FZcV//s02sQgwRaJ78xbEVGdEKw4Vs14S8g83mB8sPkzpxlNr
	 hG2bgsMM8B7tjcvp3KnGibybQ7SJxFNxeVRlkNve+SkdxvkC1gV5HiRrEUe30+1uru
	 3bOtwLqu1nnxnxtZw8Q13q0qSrWxVrzIhDXtcmQwN1/Cctrldga+f3BfJAk7SjYhYu
	 Xquq7TnLCkDzQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1oiyGK-00GJJF-RC;
	Thu, 13 Oct 2022 14:28:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	<kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.1, take #1
Date: Thu, 13 Oct 2022 14:28:30 +0100
Message-ID: <20221013132830.1304947-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, gshan@redhat.com, oliver.upton@linux.dev, qperret@google.com, vdonnefort@google.com, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221013132830.yVd_ukl_Fecyqnbnof6mJhGfxm5bpE1BAhFU1gxuWmc@z>

Paolo,

Here's the first set of fixes for 6.1. The most interesting bit is
Oliver's fix limiting the S2 invalidation batch size the the largest
block mapping, solving (at least for now) the RCU stall problems we
have been seeing for a while. We may have to find another solution
when (and if) we decide to allow 4TB mapping at S2...

The rest is a set of minor selftest fixes as well as enabling stack
protection and profiling in the VHE code.

Please pull,

       M.

The following changes since commit b302ca52ba8235ff0e18c0fa1fa92b51784aef6a:

  Merge branch kvm-arm64/misc-6.1 into kvmarm-master/next (2022-10-01 10:19:36 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.1-1

for you to fetch changes up to 05c2224d4b049406b0545a10be05280ff4b8ba0a:

  KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test (2022-10-13 11:46:51 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.1, take #1

- Fix for stage-2 invalidation holding the VM MMU lock
  for too long by limiting the walk to the largest
  block mapping size

- Enable stack protection and branch profiling for VHE

- Two selftest fixes

----------------------------------------------------------------
Gavin Shan (1):
      KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test

Oliver Upton (2):
      KVM: arm64: Work out supported block level at compile time
      KVM: arm64: Limit stage2_apply_range() batch size to largest block

Vincent Donnefort (1):
      KVM: arm64: Enable stack protection and branch profiling for VHE

Zenghui Yu (1):
      KVM: arm64: selftests: Fix multiple versions of GIC creation

 arch/arm64/include/asm/kvm_pgtable.h                 | 18 +++++++++++++-----
 arch/arm64/include/asm/stage2_pgtable.h              | 20 --------------------
 arch/arm64/kvm/hyp/Makefile                          |  5 +----
 arch/arm64/kvm/hyp/nvhe/Makefile                     |  3 +++
 arch/arm64/kvm/mmu.c                                 |  9 ++++++++-
 tools/testing/selftests/kvm/aarch64/vgic_init.c      |  4 ++--
 .../selftests/kvm/memslot_modification_stress_test.c |  2 +-
 7 files changed, 28 insertions(+), 33 deletions(-)
