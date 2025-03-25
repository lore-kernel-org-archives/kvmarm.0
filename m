Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB8E13AA2E;
	Tue, 25 Mar 2025 11:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742902231; cv=none; b=bkuTO4Ba3sFmvXcBH2k6H/Fqx7w/ZeBDJvPAspelepI+SXd4RPT4zPnFf07OJLWCjC9ZHY6aP/IzD2tP5HJXnBDs3ZNl9tkGS4zag6HE6/SXcuHQYt9YISy3VfIvnJDXnazIcv/HkrgvwALhv9LtYACzXYbl4g8j8hRtbDISw60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742902231; c=relaxed/simple;
	bh=bW5pq7nRDARYHxsUJPciapbMKvnHI6897yo2Pn8WucE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=DOOWG7JuGrHALEqUL6yqivcRJhvzwto/5B6DtmhzQIv+y9TS9xTlR1elXUIQ9ARp6eqjOzT2bBN0fe/Mebcl8QZifPLVKi//EVUT7daalKaKsCV5KTm/f5OmpfXUpDSIVF+vEhglfaGcrBdy0h50wdjWbqoFm32at3VpWe/IfmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhYxyk2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhYxyk2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D36CC4CEE4;
	Tue, 25 Mar 2025 11:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742902230;
	bh=bW5pq7nRDARYHxsUJPciapbMKvnHI6897yo2Pn8WucE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=RhYxyk2Vhd8slEi/vkRdp1buodTxIbMqG+g1M/SxXRtQ99e4SRTtS3jDg/HFmpmAh
	 SbQlYlXk008V/oKUQ98p/tAcgtxakEEwlLf02hMvTrS+WvATN1sQgFAQjjUxND5+qU
	 BPeQ8WzQOngIoE9YjcXaSWpugE+8wvPBSifC7Ayk=
Subject: Patch "KVM: arm64: Remove host FPSIMD saving for non-protected KVM" has been added to the 6.6-stable tree
To: broonie@kernel.org,catalin.marinas@arm.com,gregkh@linuxfoundation.org,james.morse@arm.com,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,maz@kernel.org,oliver.upton@linux.dev,suzuki.poulose@arm.com,tabba@google.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 25 Mar 2025 07:28:56 -0400
In-Reply-To: <20250321-stable-sve-6-6-v1-3-0b3a6a14ea53@kernel.org>
Message-ID: <2025032556-quizzical-epilogue-bf3b@gregkh>
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

    KVM: arm64: Remove host FPSIMD saving for non-protected KVM

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm64-remove-host-fpsimd-saving-for-non-protected-kvm.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-125721-greg=kroah.com@vger.kernel.org Thu Mar 20 20:20:22 2025
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:16:03 +0000
Subject: KVM: arm64: Remove host FPSIMD saving for non-protected KVM
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,  James Morse <james.morse@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,  Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,  linux-kernel@vger.kernel.org, stable@vger.kernel.org,  Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,  Fuad Tabba <tabba@google.com>
Message-ID: <20250321-stable-sve-6-6-v1-3-0b3a6a14ea53@kernel.org>

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8eca7f6d5100b6997df4f532090bc3f7e0203bef ]

Now that the host eagerly saves its own FPSIMD/SVE/SME state,
non-protected KVM never needs to save the host FPSIMD/SVE/SME state,
and the code to do this is never used. Protected KVM still needs to
save/restore the host FPSIMD/SVE state to avoid leaking guest state to
the host (and to avoid revealing to the host whether the guest used
FPSIMD/SVE/SME), and that code needs to be retained.

Remove the unused code and data structures.

To avoid the need for a stub copy of kvm_hyp_save_fpsimd_host() in the
VHE hyp code, the nVHE/hVHE version is moved into the shared switch
header, where it is only invoked when KVM is in protected mode.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-3-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h       |    1 -
 arch/arm64/kvm/fpsimd.c                 |    2 --
 arch/arm64/kvm/hyp/include/hyp/switch.h |    4 ----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |    1 -
 4 files changed, 8 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -535,7 +535,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 	struct task_struct *parent_task;
 
 	struct {
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -49,8 +49,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_
 	if (ret)
 		return ret;
 
-	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
-
 	/*
 	 * We need to keep current's task_struct pinned until its data has been
 	 * unshared with the hypervisor to make sure it is not re-used by the
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -321,10 +321,6 @@ static bool kvm_hyp_handle_fpsimd(struct
 	}
 	isb();
 
-	/* Write out the host state if it's in the registers */
-	if (vcpu->arch.fp_state == FP_STATE_HOST_OWNED)
-		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
-
 	/* Restore the guest state */
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -41,7 +41,6 @@ static void flush_hyp_vcpu(struct pkvm_h
 	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
 
 	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
-	hyp_vcpu->vcpu.arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;
 
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 


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
