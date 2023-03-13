Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347F02569
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 12:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF98C433EF;
	Mon, 13 Mar 2023 12:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678711733;
	bh=g6yb8GvD3irdlfI34ql5z839cXy3jBJCyu0RSfj+GLs=;
	h=From:To:Cc:Subject:Date:From;
	b=HX1/TPAbuAt8dfQ6Yps740CppFDk8/06mDG7BUFZyYtn+SQPvyiC34+c0xiCbwWiJ
	 cwfJhtGliQdEAc/eQy9mwxJQGueZwNePY4dnzNn014AMi1P1kwtNDik9uvbwjW3mGv
	 tUaVpL4on2/O+Q9E8CFWAC3lmwSAFwFa9aNXJ9DFUUICuH6iD9r7AmWykl4+ODOCOz
	 Tyn5t5NeBE3Xw5tqMnWVuhFK3OeuW6K+g6qtEx8z2fgDeNCHDG6kPa5GlF2heDdRad
	 pkJVPQ/maSuDL7XvhtQIQcofL9YCXkU/LHyw23ZBYTwSbCi9PRqVCZbH11gPXAeIcN
	 Pa6dFux94T6uw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pbhbf-00HEdE-F2;
	Mon, 13 Mar 2023 12:48:51 +0000
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
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	dwmw2@infradead.org
Subject: [PATCH v2 00/19] KVM: arm64: Rework timer offsetting for fun and profit
Date: Mon, 13 Mar 2023 12:48:18 +0000
Message-Id: <20230313124837.2264882-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
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
allows a global offset to be set at any point in time, overriding both
of the timer counter writebacks.

We also take this opportunity to rework the way IRQs are mapped to
timers, something that was always a bit dodgy.

This has been moderately tested with nVHE, VHE and NV. I do not have
access to CNTPOFF-aware HW, so the jury is still out on that one. Note
that the NV patches in this series are here to give a perspective on
how this gets used.

Note that patch #1 is already on its way upstream as it fixes a bunch
of related issues... Also note that the UAPI has changed from the
initial revision.

I've updated the arch_timer selftest to allow an offset to be provided
from the command line, and fixed a couple of glaring issues along the
way. Colton reported some other issues with this test, but I cannot
reproduce them here, making me think this might be related to CNTPOFF
(but again, I don't have such HW at hand).

Note that this is at best 6.4 material. I have a branch stashed at [0]
and based on 6.3-rc1, as well as a minimal example of the use of the
API at [2] based on kvmtool.

Thanks,

	M.

* From v1 [1]:

  - Switched from a dual offset to a single one which gets applied to
    both virtual and physical counters. Which means that NV doesn't
    behave oddly anymore by ignoring the virtual offset.

  - Some cosmetic repainting of the UAPI symbols

  - Added patches to rework the IRQ mapping to timers

  - Patch #1 on its way to Paolo

  - Rebased on 6.3-rc1

[0] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/timer-vm-offsets
[1] https://lore.kernel.org/r/20230216142123.2638675-1-maz@kernel.org
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/commit/?h=zero-offset&id=3b1253073ee57c0d92baf7b214362829b487b8d5

Marc Zyngier (19):
  KVM: arm64: timers: Convert per-vcpu virtual offset to a global value
  KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for
    fractional ns
  arm64: Add CNTPOFF_EL2 register definition
  arm64: Add HAS_ECV_CNTPOFF capability
  KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
  KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
  KVM: arm64: Expose {un,}lock_all_vcpus() to the reset of KVM
  KVM: arm64: timers: Allow userspace to set the global counter offset
  KVM: arm64: timers: Allow save/restoring of the physical timer
  KVM: arm64: timers: Rationalise per-vcpu timer init
  KVM: arm64: timers: Abstract per-timer IRQ access
  KVM: arm64: timers: Move the timer IRQs into arch_timer_vm_data
  KVM: arm64: Abstract the number of valid timers per vcpu
  KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
  KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
  KVM: arm64: nv: timers: Support hyp timer emulation
  KVM: arm64: selftests: Add physical timer registers to the sysreg list
  KVM: arm64: selftests: Augment existing timer test to handle variable
    offset
  KVM: arm64: selftests: Deal with spurious timer interrupts

 Documentation/virt/kvm/api.rst                |  38 ++
 arch/arm64/include/asm/kvm_host.h             |  16 +
 arch/arm64/include/asm/sysreg.h               |   1 +
 arch/arm64/include/uapi/asm/kvm.h             |  11 +
 arch/arm64/kernel/cpufeature.c                |  11 +
 arch/arm64/kvm/arch_timer.c                   | 560 +++++++++++++-----
 arch/arm64/kvm/arm.c                          |  49 ++
 arch/arm64/kvm/guest.c                        |  29 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  18 +-
 arch/arm64/kvm/hypercalls.c                   |   4 +-
 arch/arm64/kvm/sys_regs.c                     |   7 +
 arch/arm64/kvm/trace_arm.h                    |   6 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  38 --
 arch/arm64/kvm/vgic/vgic.c                    |  15 +
 arch/arm64/kvm/vgic/vgic.h                    |   3 -
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |   4 +
 include/clocksource/arm_arch_timer.h          |   1 +
 include/kvm/arm_arch_timer.h                  |  51 +-
 include/kvm/arm_vgic.h                        |   1 +
 include/uapi/linux/kvm.h                      |   3 +
 .../selftests/kvm/aarch64/arch_timer.c        |  56 +-
 .../selftests/kvm/aarch64/get-reg-list.c      |   5 +-
 23 files changed, 700 insertions(+), 228 deletions(-)

-- 
2.34.1

