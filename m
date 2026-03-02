Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2790F379EF2
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 06:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772433891; cv=none; b=ldQVbTOOyvQzVoEZq5H3YXCIVgcv+xpt/09Xvz1sHOu1ZqzVfu//Ohgil3naLULd8THusgonAH5HadJSMkRbkslEd6Mfqo8AZfk64SmGALIKYqg4bfpFpukWQnByFuWBE+a5XZTq6cFWbkZQeOe/l4jkrkNxD5Ak/KDvuQtCQUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772433891; c=relaxed/simple;
	bh=bF3erUaOF4LCmXWWyk7VDBZ8iv2BUPz19DALGsfvSHo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EKsQ9sDczmAoh39J1TdD4U+Nsa4z6mBqoghqeSGx7nSN6XpzPnN2CSR0NptveUZL42T46gVJ4gJK+vQ/RKKbY3dMjsYMXMstbSO7xOxIXNOCZFKKIRxsCMp1jz0gW7V2m5HS7VTGsg+Teb3l9IejfWF3ubZBwSCSFqaQFWxJ1rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 193CE14BF;
	Sun,  1 Mar 2026 22:44:41 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A14733F7BD;
	Sun,  1 Mar 2026 22:44:45 -0800 (PST)
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
Subject: [PATCH V2 0/2] arm64/mm: Drop TTBR_CNP_BIT and TTBR_ASID_MASK
Date: Mon,  2 Mar 2026 06:44:35 +0000
Message-Id: <20260302064437.2791034-1-anshuman.khandual@arm.com>
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

This series applies on v7.0-rc2.

Changes in V2:

- Used FIELD_PREP() in update_saved_ttbr0() per Marc
- Dropped KVM TTBR_ASID_MASK changes as they are already merged upstream
  via commit 54e367cb94d6 ("KVM: arm64: Deduplicate ASID retrieval code")

Changes in V1:

https://lore.kernel.org/all/20260225035157.1159962-1-anshuman.khandual@arm.com/

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
 arch/arm64/include/asm/mmu_context.h   | 3 ++-
 arch/arm64/include/asm/pgtable-hwdef.h | 2 --
 arch/arm64/include/asm/uaccess.h       | 6 +++---
 arch/arm64/kernel/entry.S              | 2 +-
 arch/arm64/kernel/mte.c                | 4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S     | 4 ++--
 arch/arm64/mm/context.c                | 8 ++++----
 arch/arm64/mm/mmu.c                    | 2 +-
 10 files changed, 16 insertions(+), 18 deletions(-)

-- 
2.30.2

