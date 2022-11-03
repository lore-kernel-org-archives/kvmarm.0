Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155F17488
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 15:05:17 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27D9D1FB;
	Thu,  3 Nov 2022 08:05:20 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FFB13F5A1;
	Thu,  3 Nov 2022 08:05:11 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 0/2] KVM fixes for exotic configurations
Date: Thu,  3 Nov 2022 15:05:05 +0000
Message-ID: <20221103150507.32948-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Message-ID: <20221103150505.5CutDokw9-MMMkaI-CQ_RPH06FHKtvtChzE1qDqmWmw@z>

I've been adding support for FEAT_LPA2 to KVM and as part of that work have been
testing various (84) configurations of HW, host and guest kernels on FVP. This
has thrown up a couple of pre-existing bugs, for which the fixes are provided.

Thanks,
Ryan

Ryan Roberts (2):
  KVM: arm64: Fix kvm init failure when mode!=vhe and VA_BITS=52.
  KVM: arm64: Fix PAR_TO_HPFAR() to work independently of PA_BITS.

 arch/arm64/include/asm/kvm_arm.h |  6 +++++-
 arch/arm64/kvm/arm.c             | 20 +++-----------------
 arch/arm64/kvm/mmu.c             | 28 +++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 19 deletions(-)

--
2.17.1

