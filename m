Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A86763E9
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707389683; cv=none; b=LcH2zYMGpYCLPiQcyGXrva46gEbss0tRw0vHwReQT+y+M9Lb/jAaVn50kKTUmkKZm9ctmeg7a+5OeFR3gff71g/cK+Y/U0wCV/6FksXi/Jj1gAbcKBLw2ZshCI1oNk72JSgoZJF9wHFI0EoTIbXuAemb0DvXappsPl7bRm4brj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707389683; c=relaxed/simple;
	bh=DvAFQ30+5/tBHEVtE6RGsbDv5MxHBEfi43rZitKeLr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ktd0JwdTNPNtnXfIJ4JmqydTXQCGBFoVJtZC4p0hpfn9TA/2ik7Aa/5suFfO5/vvTx7KI+aoBohQaNHxbn5Eg3xRk6/z5Rxgrr2FTmvUoZ3SLDB9KzxMbBc51xbTLfPxigak0Mi5BD5U6ItWKT6ZAktP9wuyX6eQ14eS6IFNaRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A36501515;
	Thu,  8 Feb 2024 02:55:21 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 265013F762;
	Thu,  8 Feb 2024 02:54:38 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v1 2/2] KVM: arm64: removed unused kern_hyp_va asm macro
Date: Thu,  8 Feb 2024 10:54:22 +0000
Message-Id: <20240208105422.3444159-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240208105422.3444159-1-joey.gouly@arm.com>
References: <20240208105422.3444159-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The last usage of this macro was removed in:
    commit 5dc33bd199ca ("KVM: arm64: nVHE: Pass pointers consistently to hyp-init")

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_mmu.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d248a7ae627a..961d4431654b 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -53,27 +53,6 @@
 
 #include <asm/alternative.h>
 
-/*
- * Convert a kernel VA into a HYP VA.
- * reg: VA to be converted.
- *
- * The actual code generation takes place in kvm_update_va_mask, and
- * the instructions below are only there to reserve the space and
- * perform the register allocation (kvm_update_va_mask uses the
- * specific registers encoded in the instructions).
- */
-.macro kern_hyp_va	reg
-#ifndef __KVM_VHE_HYPERVISOR__
-alternative_cb ARM64_ALWAYS_SYSTEM, kvm_update_va_mask
-	and     \reg, \reg, #1		/* mask with va_mask */
-	ror	\reg, \reg, #1		/* rotate to the first tag bit */
-	add	\reg, \reg, #0		/* insert the low 12 bits of the tag */
-	add	\reg, \reg, #0, lsl 12	/* insert the top 12 bits of the tag */
-	ror	\reg, \reg, #63		/* rotate back */
-alternative_cb_end
-#endif
-.endm
-
 /*
  * Convert a hypervisor VA to a PA
  * reg: hypervisor address to be converted in place
-- 
2.25.1

