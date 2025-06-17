Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B62862E2654
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167464; cv=none; b=Upd86CGvGg7SKkXKUHk0eDx2lgmBtXMk19xUw5yBuQptWsDgYp/nti5IOifnqCfFCO6GNOAJlAOf1zfTIzgnf8Vl97tfkJa5LU50h2b120WYMBjy0XRp4R4zsoDYgPlzbEFLWJlKH9UvR03SRbvy65kzSS5fwJadM+4/e/OPIH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167464; c=relaxed/simple;
	bh=dVYySzy8m0DA/oA8nYipY7v8dxrjKXovPoNEsnKU7lQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IJvmLOhAaU/d0cR1IXPpbY7BO3ewuPTLzGvvn6SVuLHf5QwJlt7oE6pjsNY2WST5iyWxiHj8WerKvVb5qFRQY6TRQd3l9rya2imEc4q8Fs5njoJ/02lXuvtB9/6UnbwzOG5j0QnBtHH/PENI4pT0ooc49jZ7AKIhB5KOPd6Ja54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A0901596;
	Tue, 17 Jun 2025 06:37:21 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 50D3E3F673;
	Tue, 17 Jun 2025 06:37:40 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	stable@vger.kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 5/7] KVM: arm64: Remove ad-hoc CPTR manipulation from kvm_hyp_handle_fpsimd()
Date: Tue, 17 Jun 2025 14:37:16 +0100
Message-Id: <20250617133718.4014181-6-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250617133718.4014181-1-mark.rutland@arm.com>
References: <20250617133718.4014181-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hyp code FPSIMD/SVE/SME trap handling logic has some rather messy
open-coded manipulation of CPTR/CPACR. This is benign for non-nested
guests, but broken for nested guests, as the guest hypervisor's CPTR
configuration is not taken into account.

Consider the case where L0 provides FPSIMD+SVE to an L1 guest
hypervisor, and the L1 guest hypervisor only provides FPSIMD to an L2
guest (with L1 configuring CPTR/CPACR to trap SVE usage from L2). If the
L2 guest triggers an FPSIMD trap to the L0 hypervisor,
kvm_hyp_handle_fpsimd() will see that the vCPU supports FPSIMD+SVE, and
will configure CPTR/CPACR to NOT trap FPSIMD+SVE before returning to the
L2 guest. Consequently the L2 guest would be able to manipulate SVE
state even though the L1 hypervisor had configured CPTR/CPACR to forbid
this.

Clean this up, and fix the nested virt issue by always using
__deactivate_cptr_traps() and __activate_cptr_traps() to manage the CPTR
traps. This removes the need for the ad-hoc fixup in
kvm_hyp_save_fpsimd_host(), and ensures that any guest hypervisor
configuration of CPTR/CPACR is taken into account.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9b025276fcc8e..ce001a2b6421c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -617,11 +617,6 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 	 */
 	if (system_supports_sve()) {
 		__hyp_sve_save_host();
-
-		/* Re-enable SVE traps if not supported for the guest vcpu. */
-		if (!vcpu_has_sve(vcpu))
-			cpacr_clear_set(CPACR_EL1_ZEN, 0);
-
 	} else {
 		__fpsimd_save_state(host_data_ptr(host_ctxt.fp_regs));
 	}
@@ -672,10 +667,7 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Valid trap.  Switch the context: */
 
 	/* First disable enough traps to allow us to update the registers */
-	if (sve_guest || (is_protected_kvm_enabled() && system_supports_sve()))
-		cpacr_clear_set(0, CPACR_EL1_FPEN | CPACR_EL1_ZEN);
-	else
-		cpacr_clear_set(0, CPACR_EL1_FPEN);
+	__deactivate_cptr_traps(vcpu);
 	isb();
 
 	/* Write out the host state if it's in the registers */
@@ -697,6 +689,13 @@ static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	*host_data_ptr(fp_owner) = FP_STATE_GUEST_OWNED;
 
+	/*
+	 * Re-enable traps necessary for the current state of the guest, e.g.
+	 * those enabled by a guest hypervisor. The ERET to the guest will
+	 * provide the necessary context synchronization.
+	 */
+	__activate_cptr_traps(vcpu);
+
 	return true;
 }
 
-- 
2.30.2

