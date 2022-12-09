Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E58A5B
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 16:45:11 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 343FB23A;
	Fri,  9 Dec 2022 08:45:18 -0800 (PST)
Received: from e126815.warwick.arm.com (e126815.arm.com [10.32.32.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AE9E23F73D;
	Fri,  9 Dec 2022 08:45:09 -0800 (PST)
From: James Clark <james.clark@arm.com>
To: kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Date: Fri,  9 Dec 2022 16:44:45 +0000
Message-ID: <20221209164446.1972014-1-james.clark@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221209164445.IU6GmLbhybYYaxSJ3POkJVI2E-q_L1wLcEkcVlzmZ9U@z>

Hi,

We noticed qemu failing to run because of an assert on our CI. I don't see the issue anymore with
this fix.

Applies to kvmarm/next (753d734f3f34)

Thanks

James Clark (1):
  KVM: arm64: PMU: Fix PMCR_EL0 reset value

 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.25.1

