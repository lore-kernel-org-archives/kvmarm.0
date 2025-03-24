Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C9D191F60;
	Mon, 24 Mar 2025 19:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742842842; cv=none; b=sFczt7G0ZM5beGfZ5iU0m4UmaILk4rU0IBD8MD1thhY1z2vjA2Ti90yNzskr3CTL0yeft+HFl7YSVYwIObl73RR5rgefovD7pRSajOuBuSRoqK83VuAu1i6wHxZWqt/mtuR89yGR5e/lm56Fb5dU7gaSDXpSPFO4ZNoo/nCAutk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742842842; c=relaxed/simple;
	bh=J2S+Lv5BWjXt0yK/pyBR8FIhxgiGWlr1lgLVl1VE8bM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=IL/cdayYlhQRNSpBwkDzBJUuSTl1YhkI86qf1vvdneW2cDF89smuU2XrLYvKLE6H/9SaPLCUPqnWmp/L1iKbNFNlIQxSnJkhh3R8zAvWOaRboquyEe7cnPO93fdt/EwsoVDMCbcObT7aI68tVjGczKR4bV3jDzges9mIVj0gqNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05HgBDQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05HgBDQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63592C4CEE4;
	Mon, 24 Mar 2025 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742842842;
	bh=J2S+Lv5BWjXt0yK/pyBR8FIhxgiGWlr1lgLVl1VE8bM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=05HgBDQeslUIUY/vJ1dLJYwJvx06M1BHpFtq2SPcG/JnnDUcnGl/yLWXUtKX/1Dq9
	 g1g9z3zdTkWAEi7bHcAah0n21MBlcXw3NJ/9XbnZBhG8X87UqWBrvbyOWGtRQ2GNGQ
	 FRBXjdmjTUmC0KF5ahknL4R3K/xUOU6gynRK2RiU=
Subject: Patch "KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN" has been added to the 6.12-stable tree
To: broonie@kernel.org,catalin.marinas@arm.com,gregkh@linuxfoundation.org,joey.gouly@arm.com,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,maz@kernel.org,oliver.upton@linux.dev,suzuki.poulose@arm.com,tabba@google.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 24 Mar 2025 11:59:05 -0700
In-Reply-To: <20250321-stable-sve-6-12-v2-4-417ca2278d18@kernel.org>
Message-ID: <2025032405-dizzy-promotion-0062@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.zen.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From broonie@kernel.org Thu Mar 20 17:13:41 2025
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:13:00 +0000
Subject: KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,  Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,  Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,  linux-kernel@vger.kernel.org, stable@vger.kernel.org,  Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,  Fuad Tabba <tabba@google.com>
Message-ID: <20250321-stable-sve-6-12-v2-4-417ca2278d18@kernel.org>

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 459f059be702056d91537b99a129994aa6ccdd35 ]

When KVM is in VHE mode, the host kernel tries to save and restore the
configuration of CPACR_EL1.ZEN (i.e. CPTR_EL2.ZEN when HCR_EL2.E2H=1)
across kvm_arch_vcpu_load_fp() and kvm_arch_vcpu_put_fp(), since the
configuration may be clobbered by hyp when running a vCPU. This logic is
currently redundant.

The VHE hyp code unconditionally configures CPTR_EL2.ZEN to 0b01 when
returning to the host, permitting host kernel usage of SVE.

Now that the host eagerly saves and unbinds its own FPSIMD/SVE/SME
state, there's no need to save/restore the state of the EL0 SVE trap.
The kernel can safely save/restore state without trapping, as described
above, and will restore userspace state (including trap controls) before
returning to userspace.

Remove the redundant logic.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-4-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[Rework for refactoring of where the flags are stored -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    2 --
 arch/arm64/kvm/fpsimd.c           |   16 ----------------
 2 files changed, 18 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -891,8 +891,6 @@ struct kvm_vcpu_arch {
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
-/* SVE enabled for host EL0 */
-#define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
 /* SME enabled for EL0 */
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -65,10 +65,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
 	fpsimd_save_and_flush_cpu_state();
 	*host_data_ptr(fp_owner) = FP_STATE_FREE;
 
-	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
-	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
-
 	if (system_supports_sme()) {
 		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
@@ -202,18 +198,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcp
 		 * when needed.
 		 */
 		fpsimd_save_and_flush_cpu_state();
-	} else if (has_vhe() && system_supports_sve()) {
-		/*
-		 * The FPSIMD/SVE state in the CPU has not been touched, and we
-		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been
-		 * reset by kvm_reset_cptr_el2() in the Hyp code, disabling SVE
-		 * for EL0.  To avoid spurious traps, restore the trap state
-		 * seen by kvm_arch_vcpu_load_fp():
-		 */
-		if (vcpu_get_flag(vcpu, HOST_SVE_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
-		else
-			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
 	local_irq_restore(flags);


Patches currently in stable-queue which might be from broonie@kernel.org are

queue-6.12/kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
queue-6.12/regulator-check-that-dummy-regulator-has-been-probed-before-using-it.patch
queue-6.12/kvm-arm64-eagerly-switch-zcr_el-1-2.patch
queue-6.12/kvm-arm64-mark-some-header-functions-as-inline.patch
queue-6.12/kvm-arm64-remove-host-fpsimd-saving-for-non-protected-kvm.patch
queue-6.12/regulator-dummy-force-synchronous-probing.patch
queue-6.12/kvm-arm64-refactor-exit-handlers.patch
queue-6.12/kvm-arm64-unconditionally-save-flush-host-fpsimd-sve-sme-state.patch
queue-6.12/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.smen.patch
queue-6.12/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.zen.patch
