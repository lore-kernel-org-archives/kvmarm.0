Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C272C182;
	Fri, 21 Mar 2025 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516308; cv=none; b=L/oAXYX6dCsD0+bLYmQpE7dwyqP/UN+XeUqbCmGU/ZaDYBMPbU7UCUGdiRS8rJ0tfUfUrll03qMgVCfJiGLA0PqLnKWO/zArOgnp22gyUjJiHQdouPwwZvaUgnQyHOAhk3uvZW+/fFJMGjyB9rXMDhzmFhxXPPYgOsRq8/S7xeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516308; c=relaxed/simple;
	bh=CFBkZ3D3qqKor5Kj9cL5tM3zTXoy9Y0nRxvtgtnhaUQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XhwonRDPqi2cf2jTjCl5VoVQnrW0zOuNsdi8pdd62Zz36yd6H9HLs0VUjtvuXTBdASFp5NMYkcjgtf0AEG4+9n9GTRPsM7cRnc7e8J3KzwKedinxlFs6+gKxIPKka858aB4XThC8Vbt3vkb/lkZLvLWbrSeobSGkWeSfN96SXUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pIVATjvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pIVATjvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AE3C4CEDD;
	Fri, 21 Mar 2025 00:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516308;
	bh=CFBkZ3D3qqKor5Kj9cL5tM3zTXoy9Y0nRxvtgtnhaUQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pIVATjvSPxV7eaF1uh1SB3g2F3VirR4rPbKKUZnzb+gD8uIISrkYKbRDHG6ujaOv0
	 Coqp+rN5bUMGgY4EEAdIoXSt3qkvcZ82q3TLLdsmlG8DgJhNrGs7D53PwxiAtO8Ss1
	 e0sU24+C3MRPDkz7YZo1m6A9x6rZpmIBPj8G+UGacbTSCKnaAhjJgMVrCW9xl1Te6F
	 Gv1UHwVhr6Tp2Q8KxQeZ++thAAHOb1LumHpZc7sCQLnGisiw8be1WmdWJbYG6mbzgh
	 PtX7nNY2KZAIy5L5VMwIwSjxhPUg+QsenQp2Gr8n8HkwOueDkDxQEfZl6B46HVr+F2
	 E9kb27/LopShA==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:16:04 +0000
Subject: [PATCH 6.6 4/8] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.ZEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250321-stable-sve-6-6-v1-4-0b3a6a14ea53@kernel.org>
References: <20250321-stable-sve-6-6-v1-0-0b3a6a14ea53@kernel.org>
In-Reply-To: <20250321-stable-sve-6-6-v1-0-0b3a6a14ea53@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3631; i=broonie@kernel.org;
 h=from:subject:message-id; bh=bEhjaWWeo3MZO4hv+4A0+U6DdeP5Zvjor/41KIDmUy4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3LA9h7iGC6z3d780UO9FNjZjJlZmARitK1wAo5KK
 CyUCMcmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9ywPQAKCRAk1otyXVSH0CueCA
 CCr8ZNxeoYBGooYidPdc4468iwsk8Q3DIHQHwgFNO/Wa9FS57xkTpMSZFsBJEhksiGasBeDTcQMOQV
 YfDj4w8ImQclIvmXq/WPHewaesljGxLjGaHGCapiX5XpVeXJTuHvG5IP/2/dK2WKPcUTsoxZ0f7wm7
 awdhgw+iZA/ntG3LSKmP7LP83HyzQ1CE6xyBu/r/NVW0zgv5tr22bRdd2qKKivuK0SPsdUKS8RUjDl
 mW4suwnCmYV56lizBnBYD0+AX5hYR/KuDL8KDBFUUYOnjCAgohQIBS7Tzz762mKkOTVUrqfqygl8VZ
 xr8T/jywDbQDXm7I7bOj3HMe0KnvVN
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
index 3891963d42e00c8f999886dc5d7322bbacbc6c7f..9c1056d6f6859522dcee4b8c4e4804a7abac93d5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -717,8 +717,6 @@ struct kvm_vcpu_arch {
 /* vcpu running in HYP context */
 #define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
 
-/* SVE enabled for host EL0 */
-#define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
 /* SME enabled for EL0 */
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 7c36d2a7aa3196056f76acfe8f9c41763ed67d9d..f1fe7abbcb83393e7c3402405bb7b1fdbf6024ff 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -88,10 +88,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	fpsimd_save_and_flush_cpu_state();
 	vcpu->arch.fp_state = FP_STATE_FREE;
 
-	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
-	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
-
 	if (system_supports_sme()) {
 		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
@@ -189,18 +185,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		}
 
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

-- 
2.39.5

