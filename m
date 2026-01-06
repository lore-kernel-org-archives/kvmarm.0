Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60EAF33F364
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721045; cv=none; b=CWCynIJezU8OnwBa8fPKrLgd1XuA7S97KF3AzFTx1vC9aSWBxOoahJnLyIixNW2i/bISyuTsHQLRK7tbGhU5wkjVdXsh0JHcXROJJLW1VWJuzDTqxUcUgPSTDPb95MB8O+sT1ksICu+/j1x5Guivypg0JiSqZTkBCMJeHGIiR3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721045; c=relaxed/simple;
	bh=UJA4QjCR/YDANi+F01AmG3MEZACSzWDyU6SYzpsh9Bw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q3ZVHB1Bshvr+H1/Bbfh8Y2mtMHoyTtn8/F3IQ3zkrwIeiumvnclx4nIyEVOrzk2uYSKsuIGGfm5GMAhlcExDI8q+RoBz0kLOHNfgOaithlie+oSqjy/Y1xcwnkk3b6ASMd2HdCTnmZbO4jTa8kuqQMwdjhynBmXPIqepg7PNa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1C301595;
	Tue,  6 Jan 2026 09:37:15 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 209E63F5A1;
	Tue,  6 Jan 2026 09:37:20 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 1/3] KVM: arm64: Fix comment in fpsimd_lazy_switch_to_host()
Date: Tue,  6 Jan 2026 17:37:05 +0000
Message-Id: <20260106173707.3292074-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260106173707.3292074-1-mark.rutland@arm.com>
References: <20260106173707.3292074-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comment in fpsimd_lazy_switch_to_host() erroneously says guest traps
for FPSIMD/SVE/SME are disabled by fpsimd_lazy_switch_to_guest(). In
reality, the traps are disabled by __activate_cptr_traps(), and
fpsimd_lazy_switch_to_guest() only manipulates the SVE vector length.

This was mistake; I accidentally copy+pasted the wrong function name in
commit:

  59419f10045b ("KVM: arm64: Eagerly switch ZCR_EL{1,2}")

Fix the comment.

Fixes: 59419f10045b ("KVM: arm64: Eagerly switch ZCR_EL{1,2}")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c5d5e5b86eaf0..8dce3da85da35 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -495,7 +495,7 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 	/*
 	 * When the guest owns the FP regs, we know that guest+hyp traps for
 	 * any FPSIMD/SVE/SME features exposed to the guest have been disabled
-	 * by either fpsimd_lazy_switch_to_guest() or kvm_hyp_handle_fpsimd()
+	 * by either __activate_cptr_traps() or kvm_hyp_handle_fpsimd()
 	 * prior to __guest_entry(). As __guest_entry() guarantees a context
 	 * synchronization event, we don't need an ISB here to avoid taking
 	 * traps for anything that was exposed to the guest.
-- 
2.30.2

