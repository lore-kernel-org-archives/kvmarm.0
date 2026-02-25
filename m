Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C931A2C0B
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 03:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991495; cv=none; b=LiTvZR5IipbH2/FTPOdE0TqBfo3DohZ3ERI6RG/2Z7ejmijm1YBp4WlL7Uv05HRNZmUmKNfF/L5r82cAEpGJvefvN9TwTKLEWG3y1NPGSF3/MrCqfMG8DyaAqjDgWciJBjxMYDaZCUhrRzODFKAj9POAy6elVPrLqgEnkiSx20M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991495; c=relaxed/simple;
	bh=YqZ+a/U970z5ISNf24OAIt0os6GEweMqka6DgV3p/yw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X6znc944gv7kaKh0eyvR3DhC7SoSbxSbsMb5Yl9qxSrlPQGDVrnxtnn4r514ULz/MpEwDqtc7SLrIqAjMsSkedf/YxGcTfFHkzXGaId/EkkTzGhwPvA4ZA7UYqH7wEZSCc3da0qtiR9fdFUTgR3XGS1Ygv1MgGco5rksUttVqvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7AAC165C;
	Tue, 24 Feb 2026 19:51:26 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4F3413F7BD;
	Tue, 24 Feb 2026 19:51:31 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 0/2] arm64/mm: Drop TTBR_CNP_BIT and TTBR_ASID_MASK
Date: Wed, 25 Feb 2026 03:51:23 +0000
Message-Id: <20260225035125.1159907-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Directly use existing tools sysreg format field macros TTBRx_EL1_CNP_BIT/
TTBRx_EL1_ASID_MASK, while also dropping off now redundant custom macros
TTBR_CNP_BIT and TTBR_ASID_MASK. With this change in place, there are no
more TTBR_EL1 register based custom macros left in the tree.

This was discussed and suggested earlier.

https://lore.kernel.org/linux-arm-kernel/aRb8ezhQd0c0jp9G@J2N7QTR9R3/

Series applies on v7.0-rc1.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev

Anshuman Khandual (2):
  arm64/mm: Directly use TTBRx_EL1_ASID_MASK
  arm64/mm: Directly use TTBRx_EL1_CnP

 arch/arm64/include/asm/asm-uaccess.h   | 2 +-
 arch/arm64/include/asm/mmu.h           | 1 -
 arch/arm64/include/asm/mmu_context.h   | 2 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 2 --
 arch/arm64/include/asm/uaccess.h       | 6 +++---
 arch/arm64/kernel/entry.S              | 2 +-
 arch/arm64/kernel/mte.c                | 4 ++--
 arch/arm64/kvm/at.c                    | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S     | 4 ++--
 arch/arm64/kvm/nested.c                | 4 ++--
 arch/arm64/mm/context.c                | 8 ++++----
 arch/arm64/mm/mmu.c                    | 2 +-
 12 files changed, 18 insertions(+), 21 deletions(-)

-- 
2.30.2

