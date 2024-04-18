Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE9054BE4
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713418706; cv=none; b=BXKZntBWN0SWBRs9K2mNNfSlgNjEmYeYqWIZ2t6+uZRiF7vMKw7wS2PfpUKxQOBUvdSi1ZFv7L5V0cvP6MoLwdPWZgR69KCUMMoaBVGZsDGT5Qn8jXhpSnO+SPqGLQ7MB0xx+zmiO923tpO3ccsRBJs5e4ZMSo/W0Jki2A+IAlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713418706; c=relaxed/simple;
	bh=gDSXEJclSLPUkmucAi4YvSV5HLcUGxSq8okWA1JWTHw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A1J18NhI28oT4m6VUYqFHP7wC9oh1xuQ16PTASmLSD7bpjcZYGiIW5V1th3dxAlCUqZFNBOjdzPE7j12iM59I3cOvHvVdKtf7JLEDyTgD9SZvyHaPUmDc9zHSS5++ZMyXHElE/3SPrbrLnJ9eURjO8+ZyEyBVb46A7K2pkwapI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51CE4339;
	Wed, 17 Apr 2024 22:38:46 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.60.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 042623F792;
	Wed, 17 Apr 2024 22:38:13 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] arm64: Drop ID_AA64PFR0_EL1_ELx_[64BIT_ONLY|32BIT_64BIT]
Date: Thu, 18 Apr 2024 11:08:02 +0530
Message-Id: <20240418053804.2573071-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series replaces custom macros usage for ID_AA64PFR0_EL1_ELx_64BIT_ONLY
and ID_AA64PFR0_EL1_ELx_32BIT_64BIT fields, thus finally just dropping them
off completely. This series applies on v6.9-rc4.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org

Anshuman Khandual (2):
  KVM: arm64: Replace custom macros with fields from ID_AA64PFR0_EL1
  arm64/cpufeature: Replace custom macros with fields from ID_AA64PFR0_EL1

 arch/arm64/include/asm/cpufeature.h            | 4 ++--
 arch/arm64/include/asm/sysreg.h                | 4 ----
 arch/arm64/kernel/cpufeature.c                 | 4 ++--
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 8 ++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 ++--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             | 2 +-
 6 files changed, 11 insertions(+), 15 deletions(-)

-- 
2.25.1

