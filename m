Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49EF13BBFCB
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 22:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992431; cv=none; b=tkVCCeaoALx6yOLaFmIsJfmeykrvKZJfWCZh3NhonGbXXiZDyaWG4jr0CHcYFqoOwqdnHm3BJKhZRw90hvcZgNgSn6k4ewdC5Q2e5hOEpN05LennNGk71wRjF4yIYqzDR1IuKHoQPgDaC2GJ/p0QRALW4koq2VUTp5pGDRekwIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992431; c=relaxed/simple;
	bh=q9kAgCxhMvuZTxSbAknymQbFZup+7wlN//P0jig0Xr4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YbpHv5TOoO8y2js88sH6D4iR6kgnwd7NwfBScJjDwWotG24/xlWzY+imx/XUpYwdD2XuFmYACMk8xJkYrpTG0Bp1NcRh49auyPv2EGbTCgg0hhO3KDhEbDwHnlbn/lISPbis27EQdTc3Q/0ajTJTvkt3XqyOUnjmmDNtesfXDqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qkD8voS/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qkD8voS/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0136D1570;
	Wed,  9 Sep 2026 15:20:26 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97AEC3F7D8;
	Wed,  9 Sep 2026 15:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788992429; bh=q9kAgCxhMvuZTxSbAknymQbFZup+7wlN//P0jig0Xr4=;
	h=From:To:Cc:Subject:Date:From;
	b=qkD8voS/gaiT/+ejytMcIDdMoVUHsl870wkg3D8x/s9Dkta/l3otQcUCEDJrtvnn6
	 1otCPjM+IQmliaXJOrwvSanm2vOi3SISch1nfUGyv4fOJec0EiZDeYOmDjOLQSpkJJ
	 2IByXCG9Baoqxjn0KONUgq1tGbt5Tkub8mWoing4=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v1 0/3] KVM: arm64: Properly advertise !FEAT_LPA2 for NV
Date: Wed,  9 Sep 2026 23:20:12 +0100
Message-ID: <20260909222015.3046432-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Previously for NV FEAT_LPA2 is accidentally exposed to the guest at
stage-1 if hardware supports it. Stage-2 is correctly sanitised out in
ID_AA64MMFR0_EL1 but not stage-1. This is wrong on two fronts:

- There is not FEAT_LPA2 support for NV yet.
- It is non-architectural to advertise different FEAT_LPA2 support in
  stage-1 and stage-2.

This series first removes FEAT_LPA2 from TGRAN4, TGRAN16 for NV, to
present a !FEAT_LPA2 system. Then guest TCR_EL2 sanitisation is added,
to make the DS bit RES0 for NV guests. Note that this sanitisation
can't cover all cases, as we don't trap VHE L1 accesses to the vCPU's
TCR_EL2 via TCR_EL1.

TCR_EL2 sanitisation differs slightly from the AARCHMRS, please see the
commits for details.

For testing I booted a 4K 52-bit nVHE L1 and checked:
1. It is using 48-bit VAs in stage-1.
2. Writing 1 to TCR_EL2.DS and reading it back reads 0.

Series based on v7.3-rc2.

Thanks!

Wei-Lin Chang (3):
  KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1
  arm64: sysreg: Add TCR_EL2 to sysreg infrastructure
  KVM: arm64: Convert TCR_EL2 to config-driven sanitisation

 arch/arm64/include/asm/kvm_arm.h  |  13 ----
 arch/arm64/include/asm/kvm_host.h |   2 +-
 arch/arm64/include/asm/sysreg.h   |   1 -
 arch/arm64/kvm/config.c           | 113 +++++++++++++++++++++++++++
 arch/arm64/kvm/nested.c           |  17 ++++
 arch/arm64/tools/sysreg           | 125 ++++++++++++++++++++++++++++++
 6 files changed, 256 insertions(+), 15 deletions(-)

-- 
2.43.0

