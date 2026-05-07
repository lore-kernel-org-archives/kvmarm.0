Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ABF41B344;
	Thu,  7 May 2026 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778168559; cv=none; b=CGVZiFrKzDjJQlIqteT1NnMUj5eEPTgE3sdzjA6OeH9R24+xDB44Ms3GBw7nrYf/puFqr/aTO6rH4uz/omIq0LxLa8fNHvpGtiKdbf/kTckZdA3Y6utO6IGnq36AQ/h0rUHBROgklzUcRPzk1U7gPhpa3rmYjAAjga8X4ftfHHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778168559; c=relaxed/simple;
	bh=l1ZPnnUQo3LA7hrPEfFbmz90OUYfRkfGIapw7V4O47Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hi6lHDOaLiUz1hYfxUEXyf4rMuh4666hnEDO1WotFwihBDUjuSN2o+xVA0mVTKNTgg+MMt8FqNn8D/CXEjzrGqfVWrAy+FJb1jL4xvaGiSsUqVv8eiwijUqtbAxg1MyMBO8YGyDj+i9o7h50XyrTjgQZwTH+ASpBUw4vZZwgCks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IyOMHArE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyOMHArE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAEDC2BCB2;
	Thu,  7 May 2026 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778168558;
	bh=l1ZPnnUQo3LA7hrPEfFbmz90OUYfRkfGIapw7V4O47Y=;
	h=From:To:Cc:Subject:Date:From;
	b=IyOMHArEmgi0Q5vGh1Du3NDsI2BpGYwYQjALrYGiVjrX+0vCKu09jJ0vFfepHcjo/
	 xDn90EmBuObaJoFsF9RF/vvl0RY+jG97lmNVMaU+XM56t8NzM4UEa6Y+tg/Epr+Tif
	 0qyBNhy8eKUSpu26ge9xIi/GlL7fESAHcWZekUS1Q/SrXtKgy+Y7IAlaXqpZfudix0
	 avkfhEESCpbR6+BNj5UswHve3fUXzMSu+At1soFld57tG8iNa2gq3jJ7wAE5iwufU8
	 KGlR1ALBLD/o5RvphbioZvPjmuZLsvN3gLvOwIrkY2cq8Fm1Pnq1C6wI396s/Vw6Ps
	 IKsOcUDc29bXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wL0s0-000000001gn-216s;
	Thu, 07 May 2026 15:42:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Sebastian Ott <sebott@redhat.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.1, take #2
Date: Thu,  7 May 2026 16:42:21 +0100
Message-ID: <20260507154221.2905554-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, tabba@google.com, james.morse@arm.com, lpieralisi@kernel.org, mark.rutland@arm.com, smostafa@google.com, oupton@kernel.org, sebott@redhat.com, seiden@linux.ibm.com, sudeep.holla@kernel.org, vdonnefort@google.com, weilin.chang@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the second set of KVM/arm64 fixes for 7.1. Nothing too horrible
this time, aside from an ARM erratum workaround that has little impact
on KVM, but relies on some firmware dealing with the problem. Bleh.

The rest is a small collection of bug fixes, mostly affecting the MMU
(permission fault handling with guest_memfd, 52bit VA with NV), and a
small set of AI-enhanced fixes from Fuad. I guess I'll have to get
used to that.

And last but not least, Steffen joins the merry band of KVM/arm64
reviewers in preparation of s390 and arm64 being joined at the hip...

Please pull,

	M.

The following changes since commit 7fd2df204f342fc17d1a0bfcd474b24232fb0f32:

  Linux 7.1-rc2 (2026-05-03 14:21:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-fixes-7.1-2

for you to fetch changes up to effc0a39b8e0f30670fe24f51e44329d4324e566:

  KVM: arm64: Pre-check vcpu memcache for host->guest donate (2026-05-07 14:12:42 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 7.1, take #2

- Add the pKVM side of the workaround for ARM's erratum 4193714, provided
  that the EL3 firmware does its part of the job. KVM will refuse to
  initialise otherwise.

- Correctly handle 52bit VAs for guest EL2 stage-1 translations when
  running under NV with E2H==0.

- Correctly deal with permission faults in guest_memfd memslots.

- Fix the steal-time selftest after the infrastructure was reworked.

- Make sure the host cannot pass a non-sensical clock update to the
  EL2 tracing infrastructure.

- Appoint Steffen Eiden as a reviewer in anticipation of the KVM/s390
  ability to run arm64 guests, which will inevitably lead to arm64
  code being directly used on s390.

- Make sure that EL2 is configured with both exception entry and exit
  being Context Synchronization Events.

- Handle the current vcpu being NULL on EL2 panic.

- Fix the selftest_vcpu memcache being empty at the point of donation or
  sharing.

- Check that the memcache has enough capacity before engaging on the
  share/donate path.

- Fix __deactivate_fgt() to use its parameter rather than a variable
  in the macro context.

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Handle permission faults with guest_memfd

Fuad Tabba (6):
      KVM: arm64: Make EL2 exception entry and exit context-synchronization events
      KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
      KVM: arm64: Fix __deactivate_fgt macro parameter typo
      KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
      KVM: arm64: Pre-check vcpu memcache for host->guest share
      KVM: arm64: Pre-check vcpu memcache for host->guest donate

James Morse (1):
      KVM: arm64: Work around C1-Pro erratum 4193714 for protected guests

Mostafa Saleh (1):
      KVM: arm64: Remove potential UB on nvhe tracing clock update

Sebastian Ott (1):
      KVM: selftests: arm64: Fix steal_time test after UAPI refactoring

Steffen Eiden (1):
      MAINTAINERS: Add Steffen as reviewer for KVM/arm64

Wei-Lin Chang (1):
      KVM: arm64: nv: Consider the DS bit when translating TCR_EL2

 MAINTAINERS                              |  1 +
 arch/arm64/include/asm/kvm_nested.h      |  1 +
 arch/arm64/include/asm/sysreg.h          |  2 +-
 arch/arm64/kvm/arm.c                     | 21 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h  |  2 +-
 arch/arm64/kvm/hyp/nvhe/clock.c          |  3 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 47 +++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c           | 16 ++++++++++-
 arch/arm64/kvm/hyp/vhe/switch.c          |  3 +-
 arch/arm64/kvm/mmu.c                     | 29 ++++++++++++++------
 include/linux/arm-smccc.h                |  6 ++++
 tools/testing/selftests/kvm/steal_time.c |  2 ++
 12 files changed, 120 insertions(+), 13 deletions(-)
