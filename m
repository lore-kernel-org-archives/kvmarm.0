Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FCC13AA2E;
	Tue, 25 Mar 2025 11:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742902236; cv=none; b=gXgOkDJ4g4st+soCR9erzdCfTvmQ18utz3R16r6Y9Fkw15f8FXYxnPRvhdgYxbYlnq8kupGZCm1ZyCz7dAvGGeYpHpuXbgD5LSp+8sUrE+shHgjbE9mUJVoiBi4MUdEILoA363SEUQo64nag7EXavQALvPfAPkzOm+g7tM49pMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742902236; c=relaxed/simple;
	bh=svxE9d4fPdiow20B9GTk84FAT9EgcWECPw7A2j8U/Cg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=tMXJ4hDIvpB+udhsqnuzrvGhOSoup0V62UQXjj0el79RD8mTiaBWmOvpeIk1Ieq83emSsi6zNYFu07UDw6I8VSE1r6JZh7TqEKSdZr4FiRs8uo5tiQrSlJiH9d9DN8WEBKM0fQ0rcq3TFODynT8iD0mt+Z7GNwsa1S+78EP0hes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZ2yyLZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZ2yyLZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BE0C4CEE4;
	Tue, 25 Mar 2025 11:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742902236;
	bh=svxE9d4fPdiow20B9GTk84FAT9EgcWECPw7A2j8U/Cg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=rZ2yyLZheGJfLNcxP8GY3mbdqwQ9nQHO/fiZqODWRAUUZ7hPSNzdbvHP/N65a38RY
	 Zp9+mtTClH5jYEL9lMoLlYUKOQLArHN+bu8JwYWrVQSdIpe6ub+JQn+p6WfUdeVU6z
	 QNU744x4p+JBWMC/yTMLc9SXZnY3on2JlCE6PLZg=
Subject: Patch "KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state" has been added to the 6.6-stable tree
To: broonie@kernel.org,catalin.marinas@arm.com,eauger@redhat.com,eric.auger@redhat.com,fweimer@redhat.com,gregkh@linuxfoundation.org,james.morse@arm.com,jeremy.linton@arm.com,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,maz@kernel.org,oliver.upton@linux.dev,pbonzini@redhat.com,suzuki.poulose@arm.com,tabba@google.com,wilco.dijkstra@arm.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 25 Mar 2025 07:28:56 -0400
In-Reply-To: <20250321-stable-sve-6-6-v1-2-0b3a6a14ea53@kernel.org>
Message-ID: <2025032556-jingling-scope-be6f@gregkh>
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

    KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-unconditionally-save-flush-host-fpsimd-sve-sme-state.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-125720-greg=kroah.com@vger.kernel.org Thu Mar 20 20:18:53 2025
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:16:02 +0000
Subject: KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,  James Morse <james.morse@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,  Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,  linux-kernel@vger.kernel.org, stable@vger.kernel.org,  Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,  Eric Auger <eauger@redhat.com>, Wilco Dijkstra <wilco.dijkstra@arm.com>,  Eric Auger <eric.auger@redhat.com>, Florian Weimer <fweimer@redhat.com>,  Fuad Tabba <tabba@google.com>, Jeremy Linton <jeremy.linton@arm.com>,  Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20250321-stable-sve-6-6-v1-2-0b3a6a14ea53@kernel.org>

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit fbc7e61195e23f744814e78524b73b59faa54ab4 ]

There are several problems with the way hyp code lazily saves the host's
FPSIMD/SVE state, including:

* Host SVE being discarded unexpectedly due to inconsistent
  configuration of TIF_SVE and CPACR_ELx.ZEN. This has been seen to
  result in QEMU crashes where SVE is used by memmove(), as reported by
  Eric Auger:

  https://issues.redhat.com/browse/RHEL-68997

* Host SVE state is discarded *after* modification by ptrace, which was an
  unintentional ptrace ABI change introduced with lazy discarding of SVE state.

* The host FPMR value can be discarded when running a non-protected VM,
  where FPMR support is not exposed to a VM, and that VM uses
  FPSIMD/SVE. In these cases the hyp code does not save the host's FPMR
  before unbinding the host's FPSIMD/SVE/SME state, leaving a stale
  value in memory.

Avoid these by eagerly saving and "flushing" the host's FPSIMD/SVE/SME
state when loading a vCPU such that KVM does not need to save any of the
host's FPSIMD/SVE/SME state. For clarity, fpsimd_kvm_prepare() is
removed and the necessary call to fpsimd_save_and_flush_cpu_state() is
placed in kvm_arch_vcpu_load_fp(). As 'fpsimd_state' and 'fpmr_ptr'
should not be used, they are set to NULL; all uses of these will be
removed in subsequent patches.

Historical problems go back at least as far as v5.17, e.g. erroneous
assumptions about TIF_SVE being clear in commit:

  8383741ab2e773a9 ("KVM: arm64: Get rid of host SVE tracking/saving")

... and so this eager save+flush probably needs to be backported to ALL
stable trees.

Fixes: 93ae6b01bafee8fa ("KVM: arm64: Discard any SVE state when entering KVM guests")
Fixes: 8c845e2731041f0f ("arm64/sve: Leave SVE enabled on syscall if we don't context switch")
Fixes: ef3be86021c3bdf3 ("KVM: arm64: Add save/restore support for FPMR")
Reported-by: Eric Auger <eauger@redhat.com>
Reported-by: Wilco Dijkstra <wilco.dijkstra@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Tested-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-2-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ Mark: Handle vcpu/host flag conflict ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |   25 -------------------------
 arch/arm64/kvm/fpsimd.c    |   31 ++++++++-----------------------
 2 files changed, 8 insertions(+), 48 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1708,31 +1708,6 @@ void fpsimd_signal_preserve_current_stat
 }
 
 /*
- * Called by KVM when entering the guest.
- */
-void fpsimd_kvm_prepare(void)
-{
-	if (!system_supports_sve())
-		return;
-
-	/*
-	 * KVM does not save host SVE state since we can only enter
-	 * the guest from a syscall so the ABI means that only the
-	 * non-saved SVE state needs to be saved.  If we have left
-	 * SVE enabled for performance reasons then update the task
-	 * state to be FPSIMD only.
-	 */
-	get_cpu_fpsimd_context();
-
-	if (test_and_clear_thread_flag(TIF_SVE)) {
-		sve_to_fpsimd(current);
-		current->thread.fp_type = FP_STATE_FPSIMD;
-	}
-
-	put_cpu_fpsimd_context();
-}
-
-/*
  * Associate current's FPSIMD context with this cpu
  * The caller must have ownership of the cpu FPSIMD context before calling
  * this function.
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -79,14 +79,16 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
 	if (!system_supports_fpsimd())
 		return;
 
-	fpsimd_kvm_prepare();
-
 	/*
-	 * We will check TIF_FOREIGN_FPSTATE just before entering the
-	 * guest in kvm_arch_vcpu_ctxflush_fp() and override this to
-	 * FP_STATE_FREE if the flag set.
+	 * Ensure that any host FPSIMD/SVE/SME state is saved and unbound such
+	 * that the host kernel is responsible for restoring this state upon
+	 * return to userspace, and the hyp code doesn't need to save anything.
+	 *
+	 * When the host may use SME, fpsimd_save_and_flush_cpu_state() ensures
+	 * that PSTATE.{SM,ZA} == {0,0}.
 	 */
-	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
+	fpsimd_save_and_flush_cpu_state();
+	vcpu->arch.fp_state = FP_STATE_FREE;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
@@ -96,23 +98,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
 		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
 			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
-
-		/*
-		 * If PSTATE.SM is enabled then save any pending FP
-		 * state and disable PSTATE.SM. If we leave PSTATE.SM
-		 * enabled and the guest does not enable SME via
-		 * CPACR_EL1.SMEN then operations that should be valid
-		 * may generate SME traps from EL1 to EL1 which we
-		 * can't intercept and which would confuse the guest.
-		 *
-		 * Do the same for PSTATE.ZA in the case where there
-		 * is state in the registers which has not already
-		 * been saved, this is very unlikely to happen.
-		 */
-		if (read_sysreg_s(SYS_SVCR) & (SVCR_SM_MASK | SVCR_ZA_MASK)) {
-			vcpu->arch.fp_state = FP_STATE_FREE;
-			fpsimd_save_and_flush_cpu_state();
-		}
 	}
 }
 


Patches currently in stable-queue which might be from broonie@kernel.org are

queue-6.6/kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
queue-6.6/regulator-check-that-dummy-regulator-has-been-probed-before-using-it.patch
queue-6.6/kvm-arm64-eagerly-switch-zcr_el-1-2.patch
queue-6.6/kvm-arm64-mark-some-header-functions-as-inline.patch
queue-6.6/kvm-arm64-remove-host-fpsimd-saving-for-non-protected-kvm.patch
queue-6.6/regulator-dummy-force-synchronous-probing.patch
queue-6.6/kvm-arm64-refactor-exit-handlers.patch
queue-6.6/kvm-arm64-unconditionally-save-flush-host-fpsimd-sve-sme-state.patch
queue-6.6/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.smen.patch
queue-6.6/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.zen.patch
