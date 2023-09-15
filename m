Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D6610785
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 12:49:44 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC3501FB;
	Fri, 15 Sep 2023 05:50:19 -0700 (PDT)
Received: from e126864.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B99A93F5A1;
	Fri, 15 Sep 2023 05:49:39 -0700 (PDT)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm64: Support for Arm v8.8 memcpy instructions in KVM guests
Date: Fri, 15 Sep 2023 13:48:37 +0100
Message-Id: <20230915124840.474888-1-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series adds support for using the new Arm memory copy instructions in KVM
guests.  A previous series [1] added support for using the instructions in
userspace applications.  Similarly to that series, the main thing to note here
is the handling for when a memcpy is stopped and continued on a different type
of CPU. See patch #2 for details.

As background, the Armv8.8 extension adds new instructions to perform memcpy(),
memset() and memmove() operations in hardware (FEAT_MOPS).  The aim is to avoid
having many different performance-optimal memcpy implementations in software
(tailored to CPU model and copy size) and the overhead of selecting between
them.  The new instructions are intended to be at least as fast as any
alternative instruction sequence.

The series has been tested on the Arm FVP.

Thanks,
Kristina

[1] https://lore.kernel.org/all/20230509142235.3284028-1-kristina.martsenko@arm.com/


Kristina Martsenko (3):
  KVM: arm64: Configure HCRX_EL2 dynamically
  KVM: arm64: Add handler for MOPS exceptions
  KVM: arm64: Expose MOPS instructions to guests

 arch/arm64/include/asm/kvm_emulate.h          | 10 ++++
 arch/arm64/include/asm/kvm_host.h             |  1 +
 arch/arm64/include/asm/traps.h                | 54 ++++++++++++++++++-
 arch/arm64/kernel/traps.c                     | 48 +----------------
 arch/arm64/kvm/arm.c                          |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 19 ++++++-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  1 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  2 +
 arch/arm64/kvm/hyp/vhe/switch.c               |  1 +
 arch/arm64/kvm/sys_regs.c                     |  1 -
 12 files changed, 90 insertions(+), 52 deletions(-)


base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.25.1

