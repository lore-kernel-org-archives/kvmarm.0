Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6D7267F59
	for <kvmarm@lists.linux.dev>; Mon, 18 Aug 2025 04:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493099; cv=none; b=AxLrCaRKOfR1awMRqaECsw1HGIO9OF9dv6K8pHE+fb0NOcZ4M6HeAmv882dgLO+2FONkguhmpcAoS5Thm39ICreiMto06UwOtpSZFa2YfKJZnmAL1qUKxyED8V22za6+u6jK/P+FnIuUxxqBO4zMUb5rmTkK+aL75xUUPEc71IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493099; c=relaxed/simple;
	bh=+ZAomHC0EeizW3/iczkaqcDPujZyt42UesNjmJgW+as=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gijvnOT/nSUFkhwNMa91ASjee4rHevXoG73Dx69/w9gt/KnuG5ynlEG0E4C6ddH3+Hq2j7sVIoTXg6C178Bz0LCOzs/NehJSJ22RffPnSv8/Cbi+2q5clJNsUIPeAsF3FVP/E8+7U/LPwvD1XYKc7K1yumePOtgh9l/C5xOYBeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96C631762;
	Sun, 17 Aug 2025 21:58:01 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E67E13F58B;
	Sun, 17 Aug 2025 21:58:06 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] arm64/sysreg: Clean up TCR_XXX field macros
Date: Mon, 18 Aug 2025 10:27:55 +0530
Message-Id: <20250818045759.672408-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently [V]TCR[1|2]_EL[1|2] sysreg field macros are sprinkled across the
arm64 platform code including KVM implementation. Clean these up via adding
required register filed definitions in tools sysreg format and subsequently
doing all necessary replacements. The cleanup does not cause any functional
change.

This applies on v6.17-rc2

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org

Anshuman Khandual (4):
  arm64/sysreg: Update TCR_EL1 register
  arm64/sysreg: Replace TCR_EL1 field macros
  arm64/sysreg: Add TCR_EL2 register
  arm64/sysreg: Add VTCR_EL2 register

 arch/arm64/include/asm/assembler.h         |   6 +-
 arch/arm64/include/asm/cputype.h           |   2 +-
 arch/arm64/include/asm/kvm_arm.h           |  45 +-----
 arch/arm64/include/asm/kvm_nested.h        |   6 +-
 arch/arm64/include/asm/mmu_context.h       |   4 +-
 arch/arm64/include/asm/pgtable-hwdef.h     | 107 ++------------
 arch/arm64/include/asm/pgtable-prot.h      |   2 +-
 arch/arm64/include/asm/sysreg.h            |   4 -
 arch/arm64/kernel/cpufeature.c             |   4 +-
 arch/arm64/kernel/pi/map_kernel.c          |   8 +-
 arch/arm64/kernel/vmcore_info.c            |   2 +-
 arch/arm64/kvm/arm.c                       |   6 +-
 arch/arm64/kvm/at.c                        |  48 +++----
 arch/arm64/kvm/hyp/include/hyp/switch.h    |   2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c           |   2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c              |   2 +-
 arch/arm64/kvm/hyp/pgtable.c               |   6 +-
 arch/arm64/kvm/hyp/vhe/tlb.c               |   2 +-
 arch/arm64/kvm/nested.c                    |  10 +-
 arch/arm64/kvm/pauth.c                     |  12 +-
 arch/arm64/mm/proc.S                       |  29 ++--
 arch/arm64/tools/sysreg                    | 153 +++++++++++++++++++--
 tools/arch/arm64/include/asm/cputype.h     |   2 +-
 24 files changed, 241 insertions(+), 225 deletions(-)

-- 
2.25.1

