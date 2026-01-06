Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A28341AD8
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721049; cv=none; b=CObGEAjZzmtuVBV8ixD4AT+umoRpOABIPFK1upoSzNbBFp8CB7oqetUVx6agB1BIMC1hyJuE4ov4KF/W8lyJqivP2uXWFtXbsTnP7iHCj6Py2/krf6rCS6Mew3i5tOReYqreo/OH4KsSS7zKDpg0+7/9iLc0CkpnKPpEvZS5+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721049; c=relaxed/simple;
	bh=FPuKa2PkeKUlTGCelYOFIYuyDbUY4kgkt8fqAjPJSoI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hnnmxz7iXvJQ0VvA9Yf87DkFkIfplwf6TRyPmLeRloZe/LLa+XzUsUHCXgRZ3SOgB51lfJUjjyL2IuTf3QHQno5AFchQX4ZX3EUUsxl5AFCBd3ea6B3mSZq+WASPiRfnVSZRDd6IGiYBZbiM0SJN0dXR4tKdQN2xm1Q1GOa1xXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D67BA497;
	Tue,  6 Jan 2026 09:37:20 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 257753F5A1;
	Tue,  6 Jan 2026 09:37:26 -0800 (PST)
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
Subject: [PATCH 3/3] KVM: arm64: Remove ISB after writing FPEXC32_EL2
Date: Tue,  6 Jan 2026 17:37:07 +0000
Message-Id: <20260106173707.3292074-4-mark.rutland@arm.com>
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

The value of FPEX32_EL2 has no effect on execution in AArch64 state, and
consequently there's no need for an ISB after writing to it in the hyp
code (which executes in AArch64 state). When performing an exception
return to AArch32 state, the exception return will provide the necessary
context synchronization event.

Remove the redundant ISB.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8dce3da85da35..91aa1862349cb 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -59,10 +59,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
 	 * it will cause an exception.
 	 */
-	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd()) {
+	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd())
 		write_sysreg(1 << 30, fpexc32_el2);
-		isb();
-	}
 }
 
 static inline void __activate_cptr_traps_nvhe(struct kvm_vcpu *vcpu)
-- 
2.30.2

