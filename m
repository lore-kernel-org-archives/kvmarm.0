Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC26FD0
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC11C4339B;
	Thu, 16 Feb 2023 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676557309;
	bh=PIgKpAOv7CdOk3XI8N/fI6LgE9z/MAE9kl5fG7CCq9k=;
	h=From:To:Cc:Subject:Date:From;
	b=LD7E+5mPXyD8eAkRvRlmMWRpeX34fzxjC9/n3yBa8NIrpWH2y51YR62hsYTNX+R6b
	 ZpFt2jWbF5EJomkJSAjAdHOUeAAgLetuux9xG7zdC8lYHfguT8geluSc+ypiMtqNce
	 HcNNkTMIY2Ej5yukRG+4gHZNsofVlMLP3gK/hw6HlmTv2T78uMSEFhzLX43Smj3hUN
	 VWMeHoLa84P8Xf6gW40so0TF0KIKq3gm9kJ1xt1rsa9siSOGcH7POscroTh8fQ5FaB
	 BlK5ji8uIhwXXX5TWMVxkpKZpiyqlnrRkXI8I8/YVCQF9nlaSYy5qwjHba0JMnTJcy
	 N6M+0n02S0DjA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pSf8t-00AuwB-5S;
	Thu, 16 Feb 2023 14:21:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	dwmw2@infradead.org
Subject: [PATCH 00/16] KVM: arm64: Rework timer offsetting for fun and profit
Date: Thu, 16 Feb 2023 14:21:07 +0000
Message-Id: <20230216142123.2638675-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series aims at satisfying multiple goals:

- allow a VMM to atomically restore a timer offset for a whole VM
  instead of updating the offset each time a vcpu get its counter
  written

- allow a VMM to save/restore the physical timer context, something
  that we cannot do at the moment due to the lack of offsetting

- provide a framework that is suitable for NV support, where we get
  both global and per timer, per vcpu offsetting

We fix a couple of issues along the way, both from a stylistic and
correctness perspective. This results in a new per VM KVM API that
allows a pair of global offsets to be set at any point in time,
overriding the timer counter writeback.

This has been moderately tested with nVHE, VHE and NV. I do not have
access to CNTPOFF-aware HW, so the jury is still out on that one. Note
that the NV patches in this series are here to give a perspective on
how this gets used.

I've updated the arch_timer selftest to allow offsets to be provided
from the command line, but the arch_test is pretty flimsy and tends to
fail with an error==EINTR, even without this series. Something to
investigate.

Note that this is at best 6.4 material. I have a branch stashed at [1]
and based on kvmarm/next.

Thanks,

	M.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/timer-vm-offsets

Marc Zyngier (16):
  arm64: Add CNTPOFF_EL2 register definition
  arm64: Add HAS_ECV_CNTPOFF capability
  kvm: arm64: Expose {un,}lock_all_vcpus() to the reset of KVM
  KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for
    fractional ns
  KVM: arm64: timers: Convert per-vcpu virtual offset to a global value
  KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
  KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
  KVM: arm64: timers: Allow userspace to set the counter offsets
  KVM: arm64: timers: Allow save/restoring of the physical timer
  KVM: arm64: timers: Rationalise per-vcpu timer init
  KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
  KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
  KVM: arm64: nv: timers: Support hyp timer emulation
  KVM: arm64: selftests: Add physical timer registers to the sysreg list
  KVM: arm64: selftests: Augment existing timer test to handle variable
    offsets
  KVM: arm64: selftests: Deal with spurious timer interrupts

 Documentation/virt/kvm/api.rst                |  47 ++
 arch/arm64/include/asm/kvm_host.h             |  14 +
 arch/arm64/include/uapi/asm/kvm.h             |  15 +
 arch/arm64/kernel/cpufeature.c                |  11 +
 arch/arm64/kvm/arch_timer.c                   | 443 ++++++++++++++----
 arch/arm64/kvm/arm.c                          |  47 ++
 arch/arm64/kvm/guest.c                        |  29 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  18 +-
 arch/arm64/kvm/hypercalls.c                   |   2 +-
 arch/arm64/kvm/trace_arm.h                    |   6 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  38 --
 arch/arm64/kvm/vgic/vgic.c                    |  15 +
 arch/arm64/kvm/vgic/vgic.h                    |   3 -
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |   4 +
 include/clocksource/arm_arch_timer.h          |   1 +
 include/kvm/arm_arch_timer.h                  |  32 +-
 include/kvm/arm_vgic.h                        |   1 +
 include/uapi/linux/kvm.h                      |   3 +
 .../selftests/kvm/aarch64/arch_timer.c        |  26 +-
 .../selftests/kvm/aarch64/get-reg-list.c      |   5 +-
 21 files changed, 603 insertions(+), 158 deletions(-)

-- 
2.34.1

