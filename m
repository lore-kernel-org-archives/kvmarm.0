Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF664C85
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 03:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749699361; cv=none; b=fBj3/4hRJLwMGKamzsb+Neewd32d91jlFp5wtBlOz3ndPMidzEI+/I3ZoHun3QsVxaDGFjLKd0/G1pVvyZ+P4OA1bYlGLweGv8F6ma9vp2X5J8WI2kWr2tP1p8q3LUwEPoIrflYJxVrYrCxUN2ztoEsIDberclHglUohQ3uwz3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749699361; c=relaxed/simple;
	bh=hg41offbANxNsL7WuavyurwzolxddoUsGldDeN/NTrw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SkoaUjjuqziNqk2O9wxybBez/boeXlJXOnY+uFbiHNzMB9DZF+Wl0PIyLqGrdHE5mX6ZRUV+9KHzwiQV04QTN5/btkXYYBF6hprthj/aXfR1AAaSnWwI7j8KKTQuSq7S4ysVPQuaYGpCEi4YHcxgFoH0WWnLKE3NFcIq3t6EVn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D21B11595;
	Wed, 11 Jun 2025 20:35:37 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1DE1B3F66E;
	Wed, 11 Jun 2025 20:35:53 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH V4 0/2] arm64/debug: Drop redundant DBG_MDSCR_* macros
Date: Thu, 12 Jun 2025 09:05:45 +0530
Message-Id: <20250612033547.480952-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MDSCR_EL1 has already been defined in tools sysreg format and hence can be
used in all debug monitor related call paths. Subsequently all DBG_MDSCR_*
macros become redundant and hence can be dropped off completely. While here
convert all variables handling MDSCR_EL1 register as u64 which reflects its
true width as well.

This series applies on v6.16-rc1

Changes in V4:

- Updated the commit message in [PATCH 1/2] explainig rationale for changing
  mdscr variable as u64 per Mark

Changes in V3:

https://lore.kernel.org/all/20250610053128.4118784-1-anshuman.khandual@arm.com/

- Split out the self test changes into a separate patch per Mark
- Added RB tag from Ada

Changes in V2:

https://lore.kernel.org/all/20250508044752.234543-1-anshuman.khandual@arm.com/

- Changed reg, val width to u64 in cortex_a76_erratum_1463225_svc_handler() per Ada
- Changed mdscr register width to uint64_t in enable_monitor_debug_exceptions() and
  install_ss() per Ada
    
Changes in V1:

https://lore.kernel.org/all/20250417105253.3188976-1-anshuman.khandual@arm.com/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org

Anshuman Khandual (2):
  arm64/debug: Drop redundant DBG_MDSCR_* macros
  KVM: selftests: Change MDSCR_EL1 register holding variables as uint64_t

 arch/arm64/include/asm/assembler.h            |  4 ++--
 arch/arm64/include/asm/debug-monitors.h       |  6 -----
 arch/arm64/kernel/debug-monitors.c            | 22 +++++++++----------
 arch/arm64/kernel/entry-common.c              |  4 ++--
 .../selftests/kvm/arm64/debug-exceptions.c    |  4 ++--
 5 files changed, 17 insertions(+), 23 deletions(-)

-- 
2.25.1

