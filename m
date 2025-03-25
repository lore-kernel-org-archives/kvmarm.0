Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493F41FAC51;
	Tue, 25 Mar 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928586; cv=none; b=FJVcoByYjpZjCM8AwWTHx/PnZBqoEtqTdHL8vCTNQSYNzWdTvwbe8yh77R9fdQe1KnDN4C30kErKGkXmpr3gbg9KejQhVQN6wYUW6IZv2t5fC90/TuAmVLHVOKFTdGOsOhwWkEONgcLynPusoCU1+Yt+IL4WoiZBtXmFJEltIP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928586; c=relaxed/simple;
	bh=X5eRhBQLAggts9ERTWvr9rKEs2alPOTSWgD7OqqZIN8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VVbFNDRg43krN6CoxqIVi+O+svwoa0b1M1t/Q34nl/Cb5YsyqHdn/j7btk1pLG2VLcjRx2RbG/1dLnBwhtV6feCBU80FUT23S7sqicz0bi8B1tk/LrmPwO0VOqUR4IJla/s1ktzVov16fni0bN3Tg9TBkxB089fQCCrWcA02YLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Odzualcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Odzualcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20812C4CEED;
	Tue, 25 Mar 2025 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928585;
	bh=X5eRhBQLAggts9ERTWvr9rKEs2alPOTSWgD7OqqZIN8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Odzualcxu/qX7u8PpzHKzqSmdt2x2SbNJefG/Q/K0ZqA8E06uTRVfGKX24tzd02sr
	 yl9nenkN+SPgf71jDsqe/FP7sMKIoLTyosNc8rmDj+MZmmJxi5ezwSxGSxVhuIo2PC
	 ZChr/b5kIbWgFpqYEOfJ0cI8qMpYrQMYF+iCWeJof6xwZk/zx+JJEjpzQvkXjXhyEr
	 orEGfkkbB3PLO5ty4tJN2ww/KcDFoD1WblJHk9hXPLz8gPAfI8o+U6Ed9ojeQBdjFH
	 eM6gpEGxzvzSsxikrxWEerYEFmDtTfBxiSFE7igXsdE9UWSr6d01OT/DkjzmS60AV8
	 HGyJKB41rxQJw==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 25 Mar 2025 18:48:21 +0000
Subject: [PATCH 6.1 07/12] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.ZEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250325-stable-sve-6-1-v1-7-83259d427d84@kernel.org>
References: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
In-Reply-To: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3634; i=broonie@kernel.org;
 h=from:subject:message-id; bh=C/AXsrfE3hDPJKqhIkQ1xaGMTu2EikC8eGqDGNKSWKI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn4vqrsF4AEeGTms53DWRq+132vria4s0fh51zggoX
 R/R94PWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+L6qwAKCRAk1otyXVSH0LgSB/
 4qWD69N3mAaQCA9Z4f120o/aQUF6nk0yYQnor/+nrwgIUuqzoh1mVDLeAIEN6+jFCJWOQGVNB3KxDp
 NvkR95EUYqO+CvOKH3r3KHt1/psRcF2AtN5i3wSvdDvkua/AjBxrELcvibBgCkeLOXvHs6e6ce9dQ9
 mKL+QKaPzdjG0gEhpWJwTJ3GPMVxzmjNYwKx33BA8nZjFGyb5IzEhizRDC1VqO5UktNLFy/G/tjM9o
 CNO/+2e1JypF/Vy+XsQqVzULqZLMzD34hWXw01P8GSWmQyhATnSGc1GOM/AKIPZUpAm8qftdUnmL3n
 2hE0hkzCAwbVzAjP5k3cvPGuLICGbT
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

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
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/fpsimd.c           | 16 ----------------
 2 files changed, 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7f187ac24e5d37369ef0af4154fdb17890f28798..181e49120e0c4027aa52dd389de13f9ce5cd7b57 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -556,8 +556,6 @@ struct kvm_vcpu_arch {
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
-/* SVE enabled for host EL0 */
-#define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
 /* SME enabled for EL0 */
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ee7c59f96451fcb217957c9fdbbd76046393bef3..8d073a37c266db3dc2726c6a0bb39c7e2586f53f 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -88,10 +88,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	fpsimd_save_and_flush_cpu_state();
 	vcpu->arch.fp_state = FP_STATE_FREE;
 
-	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
-	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
-
 	/*
 	 * We don't currently support SME guests but if we leave
 	 * things in streaming mode then when the guest starts running
@@ -193,18 +189,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		}
 
 		fpsimd_save_and_flush_cpu_state();
-	} else if (has_vhe() && system_supports_sve()) {
-		/*
-		 * The FPSIMD/SVE state in the CPU has not been touched, and we
-		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been
-		 * reset to CPACR_EL1_DEFAULT by the Hyp code, disabling SVE
-		 * for EL0.  To avoid spurious traps, restore the trap state
-		 * seen by kvm_arch_vcpu_load_fp():
-		 */
-		if (vcpu_get_flag(vcpu, HOST_SVE_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
-		else
-			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
 	local_irq_restore(flags);

-- 
2.39.5

