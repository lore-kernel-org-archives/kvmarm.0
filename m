Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E932356DE;
	Tue, 22 Apr 2025 06:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745304250; cv=none; b=c6QaR+ijq8woWAabOAkAFDTOjY8mouNe/yE9dNnSRzFBZkZ0HRjibMRR9DniqlHZpxPMXyIMB4vd8jVENJ/7NRNFXM1ry9tpc0P0odpGfNfAVZS+V0mvO+Vrk6dUlu+csYL4KE4rCyfSkhKDhoPVeGOkT/3YCrrZYzkvrPxO8dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745304250; c=relaxed/simple;
	bh=1F0wWkdUsiH7Eo0z9vaoYfS3KipLh3tHrYHTZGQjOcQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=snIlwvLz1IOr3UPxshvE4klJBId1L/XXJgD4JiqLgjCHLAJ0pe/1e3b0lWJexCJcEsZ+3WGceAUur/6M8ZRQXPgdcFh1YIPAwLB0OVqIFh34BiDDfnojblC26bLzmbz6rXhsTayy7oN+VGOxpQLQWj6XFK1jmxA4PT39jQ+51Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOco4/3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOco4/3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4584FC4CEEA;
	Tue, 22 Apr 2025 06:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745304249;
	bh=1F0wWkdUsiH7Eo0z9vaoYfS3KipLh3tHrYHTZGQjOcQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=AOco4/3g/UFs+1gFLB/rb6ujRNLBcAk+0YCQzqcJF3PwyixTbtZWKoJq81+Vjfklo
	 zjdTDc954Qc+CJL25/q+pVLBjrJ31hlIFakvHtSATwj32oG7cZMub/OuKDhsqEjdd4
	 AKA/sFhVFMdvU0EXTgWDQlQJB+zyg/J9wGWQdjbc=
Subject: Patch "KVM: arm64: Discard any SVE state when entering KVM guests" has been added to the 6.1-stable tree
To: broonie@kernel.org,catalin.marinas@arm.com,gregkh@linuxfoundation.org,james.morse@arm.com,kvmarm@lists.cs.columbia.edu,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,maz@kernel.org,oleg@redhat.com,oliver.upton@linux.dev,suzuki.poulose@arm.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 22 Apr 2025 08:43:54 +0200
In-Reply-To: <20250404-stable-sve-6-1-v1-1-cd5c9eb52d49@kernel.org>
Message-ID: <2025042254-backboard-backing-d5e0@gregkh>
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

    KVM: arm64: Discard any SVE state when entering KVM guests

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-discard-any-sve-state-when-entering-kvm-guests.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-128300-greg=kroah.com@vger.kernel.org Fri Apr  4 15:27:49 2025
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:34 +0100
Subject: KVM: arm64: Discard any SVE state when entering KVM guests
To: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,  James Morse <james.morse@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,  Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,  kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,  Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,  Mark Rutland <mark.rutland@arm.com>
Message-ID: <20250404-stable-sve-6-1-v1-1-cd5c9eb52d49@kernel.org>

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 93ae6b01bafee8fa385aa25ee7ebdb40057f6abe ]

Since 8383741ab2e773a99 (KVM: arm64: Get rid of host SVE tracking/saving)
KVM has not tracked the host SVE state, relying on the fact that we
currently disable SVE whenever we perform a syscall. This may not be true
in future since performance optimisation may result in us keeping SVE
enabled in order to avoid needing to take access traps to reenable it.
Handle this by clearing TIF_SVE and converting the stored task state to
FPSIMD format when preparing to run the guest.  This is done with a new
call fpsimd_kvm_prepare() to keep the direct state manipulation
functions internal to fpsimd.c.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-2-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport to v6.1 ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fpsimd.h |    1 +
 arch/arm64/kernel/fpsimd.c      |   23 +++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c         |    3 ++-
 3 files changed, 26 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -56,6 +56,7 @@ extern void fpsimd_signal_preserve_curre
 extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
+extern void fpsimd_kvm_prepare(void);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1644,6 +1644,29 @@ void fpsimd_signal_preserve_current_stat
 }
 
 /*
+ * Called by KVM when entering the guest.
+ */
+void fpsimd_kvm_prepare(void)
+{
+	if (!system_supports_sve())
+		return;
+
+	/*
+	 * KVM does not save host SVE state since we can only enter
+	 * the guest from a syscall so the ABI means that only the
+	 * non-saved SVE state needs to be saved.  If we have left
+	 * SVE enabled for performance reasons then update the task
+	 * state to be FPSIMD only.
+	 */
+	get_cpu_fpsimd_context();
+
+	if (test_and_clear_thread_flag(TIF_SVE))
+		sve_to_fpsimd(current);
+
+	put_cpu_fpsimd_context();
+}
+
+/*
  * Associate current's FPSIMD context with this cpu
  * The caller must have ownership of the cpu FPSIMD context before calling
  * this function.
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -75,11 +75,12 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(!current->mm);
-	BUG_ON(test_thread_flag(TIF_SVE));
 
 	if (!system_supports_fpsimd())
 		return;
 
+	fpsimd_kvm_prepare();
+
 	vcpu->arch.fp_state = FP_STATE_HOST_OWNED;
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);


Patches currently in stable-queue which might be from broonie@kernel.org are

queue-6.1/kvm-arm64-remove-host-fpsimd-saving-for-non-protected-kvm.patch
queue-6.1/spi-cadence-qspi-fix-probe-on-am62a-lp-sk.patch
queue-6.1/asoc-qdsp6-q6asm-dai-fix-q6asm_dai_compr_set_params-error-path.patch
queue-6.1/asoc-qdsp6-q6apm-dai-fix-capture-pipeline-overruns.patch
queue-6.1/kvm-arm64-mark-some-header-functions-as-inline.patch
queue-6.1/kvm-arm64-eagerly-switch-zcr_el-1-2.patch
queue-6.1/kvm-arm64-unconditionally-save-flush-host-fpsimd-sve-sme-state.patch
queue-6.1/asoc-amd-add-dmi-quirk-for-acp6x-mic-support.patch
queue-6.1/kvm-arm64-refactor-exit-handlers.patch
queue-6.1/asoc-qdsp6-q6apm-dai-set-10-ms-period-and-buffer-alignment.patch
queue-6.1/asoc-codecs-lpass-wsa-macro-fix-vi-feedback-rate.patch
queue-6.1/arm64-fpsimd-track-the-saved-fpsimd-state-type-separately-to-tif_sve.patch
queue-6.1/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.zen.patch
queue-6.1/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.smen.patch
queue-6.1/asoc-fsl_audmix-register-card-device-depends-on-dais.patch
queue-6.1/arm64-fpsimd-have-kvm-explicitly-say-which-fp-registers-to-save.patch
queue-6.1/kvm-arm64-discard-any-sve-state-when-entering-kvm-guests.patch
queue-6.1/arm64-fpsimd-stop-using-tif_sve-to-manage-register-saving-in-kvm.patch
queue-6.1/asoc-codecs-lpass-wsa-macro-fix-logic-of-enabling-vi-channels.patch
queue-6.1/kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
