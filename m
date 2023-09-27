Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5501F922
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 09:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C63C433C8;
	Wed, 27 Sep 2023 09:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695805758;
	bh=C9ocmaLeJ5OV2/exh6Fmx96swKIGVo7eqxyWmcVY69k=;
	h=From:To:Cc:Subject:Date:From;
	b=f7IS6WDEAZ7yEDG09Ffg4Z3cYuPSPKL1PD/kAf7Awod/zSeXp2o/h149LrpDokqPQ
	 PD06JhtGcKwgoPQYiwN6L7GRsfdRv59MUWM8HUqb9PHguKEXfmC1t+GB14+TKO8PVj
	 jogDvv/I8JQUj/5j/0M14fjjctCzllPiQYH7V3SATYuQfitZG35485TTtyDS10Xs3T
	 P+fIRquDzVizuNB9T+jtEp00XCyu/EWn2Vz8RHs+UHYWZPrIivesKzQ6dfk9ZRA8dD
	 unWc0espMvtjQC57aDyrnIqZlz1bpTcql9PRegYV2oFpN1ylkt4mLQ1i5zBOJocbNA
	 10LdwlKBVLvlw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qlQXk-00GaLb-3Q;
	Wed, 27 Sep 2023 10:09:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 00/11] KVM: arm64: Accelerate lookup of vcpus by MPIDR values (and other fixes)
Date: Wed, 27 Sep 2023 10:09:00 +0100
Message-Id: <20230927090911.3355209-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is a follow-up on [2], which addresses both the O(n) SGI injection
issue, and cleans up a number of embarassing bugs steaming form the
vcpuid/vcpu_idx confusion.

See the changelog below for details.

Oliver, assuming that you haven't changed your mind and that
nobody shouts, feel free to queue this in -next.

* From v2 [2]:
  - Killed a number of online_vcpus comparisons, which didn't make
    much sense (Zenghui)
  - Added missing commit logs (oops)
  - Fixed some comments
  - Collected RBs, with thanks

* From v1 [1]:
  - Added a bunch of patches fixing the vcpu_id[x] ambiguity
  - Added a documentation update spelling out some extra ordering requirements
  - Collected RBs/TBs, with thanks

[1] https://lore.kernel.org/r/20230907100931.1186690-1-maz@kernel.org
[2] https://lore.kernel.org/r/20230920181731.2232453-1-maz@kernel.org

Marc Zyngier (11):
  KVM: arm64: vgic: Make kvm_vgic_inject_irq() take a vcpu pointer
  KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
  KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
  KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
  KVM: arm64: vgic: Use vcpu_idx for the debug information
  KVM: arm64: Use vcpu_idx for invalidation tracking
  KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
  KVM: arm64: Build MPIDR to vcpu index cache at runtime
  KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is
    available
  KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
  KVM: arm64: Clarify the ordering requirements for vcpu/RD creation

 .../virt/kvm/devices/arm-vgic-v3.rst          |   7 +
 arch/arm64/include/asm/kvm_emulate.h          |   2 +-
 arch/arm64/include/asm/kvm_host.h             |  28 ++++
 arch/arm64/kvm/arch_timer.c                   |   2 +-
 arch/arm64/kvm/arm.c                          |  93 +++++++++--
 arch/arm64/kvm/pmu-emul.c                     |   2 +-
 arch/arm64/kvm/vgic/vgic-debug.c              |   6 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   2 +-
 arch/arm64/kvm/vgic/vgic-its.c                |  49 +++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   8 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 150 +++++++-----------
 arch/arm64/kvm/vgic/vgic.c                    |  12 +-
 include/kvm/arm_vgic.h                        |   4 +-
 13 files changed, 212 insertions(+), 153 deletions(-)

-- 
2.34.1

