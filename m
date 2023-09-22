Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED25A1F183
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 11:26:03 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A15D8DA7;
	Fri, 22 Sep 2023 04:26:39 -0700 (PDT)
Received: from e126864.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5D903F5A1;
	Fri, 22 Sep 2023 04:25:59 -0700 (PDT)
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
Subject: [PATCH v2 0/2] KVM: arm64: Support for Arm v8.8 memcpy instructions in KVM guests
Date: Fri, 22 Sep 2023 12:25:06 +0100
Message-Id: <20230922112508.1774352-1-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v2 of the series to allow using the new Arm memory copy instructions
in KVM guests. See v1 for more information [1].

Changes in v2:
 - Dropped HCRX_EL2 vcpu field
 - Rebased onto v6.6-rc2

Thanks,
Kristina

[1] https://lore.kernel.org/kvmarm/20230915124840.474888-1-kristina.martsenko@arm.com/

Kristina Martsenko (2):
  KVM: arm64: Add handler for MOPS exceptions
  KVM: arm64: Expose MOPS instructions to guests

 arch/arm64/include/asm/kvm_arm.h              |  4 +-
 arch/arm64/include/asm/traps.h                | 54 ++++++++++++++++++-
 arch/arm64/kernel/traps.c                     | 48 +----------------
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 17 ++++++
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  3 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |  2 +
 arch/arm64/kvm/hyp/vhe/switch.c               |  1 +
 arch/arm64/kvm/sys_regs.c                     |  1 -
 8 files changed, 78 insertions(+), 52 deletions(-)


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.25.1

