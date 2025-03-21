Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CCB13C914;
	Fri, 21 Mar 2025 00:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516311; cv=none; b=oqSqw5rYIM6UmfCEIhr2DAm5uK1R6ayhsFRWAatTTjT+R0ZKWEUq5VXEQY5z4pn0vMqjadjYgV0Ep4zQz8RG9tVPvLV+Cma0392WdSqrupOaiRgsF+AyyYQoi4OHSZH6AHXgShmNhRXR9zd+/0FJ0o9QCzuiF6XuMUEs0TzH07M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516311; c=relaxed/simple;
	bh=ZqZu/OIKLFWaTlZe8i8EThKet2GXAnjLMbBwEC506ms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ROukrnGJhEYUWnpeBZ0guux0NFGfEnJF5W1Yh3cgAOGAwowIvF7Af8HT8Xgv4aJ9F59sSXWG6PDZHMSokZOGu3WEjRZvolBwHpEI/wT10BbenJTpVTfyY1/CaOv3Dx4TOlH+KwSvPL8cmSPe/OpBC+WExQ+QfPz4Y/avrrbdAO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFJ/BWWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFJ/BWWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607DBC4CEEA;
	Fri, 21 Mar 2025 00:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516310;
	bh=ZqZu/OIKLFWaTlZe8i8EThKet2GXAnjLMbBwEC506ms=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BFJ/BWWtUsZOaVEr/IxKaarSBg4XbMl8SlTMKBYvTx2PBaCZfGKeG+gxJgpbN+rDU
	 ZsJAUce7wJ1LLDfUlX6hBsaoUVuVGLKEGLoLLjsZecEIF+4TWCkHolEO9Fe6QtAV7c
	 7JarArWBWvJFPG3KXeBlkIaiUW8cefUiwodowrf7jOzYd25zNXbE2OH2bXa7G/Q1gh
	 gdsmYsjuT8FJ5RB5A2TDm3AC8Fd4Pmie5+72ZKVwmoaMQXHJ/wxpfnX7bfZgRO6Pb4
	 ke20UF0F2v0BqHq/iBXU7WbeVTvP2I3TJgFmRqpe35xxk23wRiBsadCjtHltkvI/cy
	 ca6YYGLXckBXQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:16:05 +0000
Subject: [PATCH 6.6 5/8] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.SMEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250321-stable-sve-6-6-v1-5-0b3a6a14ea53@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4610; i=broonie@kernel.org;
 h=from:subject:message-id; bh=KPoLYPWBSzZcnvIISNKfbhEVULIfJGkJjRCo5GPoRtE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3LA9pLOeOCWXk9Bbg48Gc9v306SXIZRAlw1DjtCr
 WLkRbLyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9ywPQAKCRAk1otyXVSH0KgXB/
 9ZLaJiuCyWeNYOKY8BZOaoZ6dmEqQ0N45Y5Xzgtr/vTR8M44uNGSe2zyltCQQBuwo5psuyWo76ouL6
 1kW7Onpbr+xcgreb0/VaNkPKnDorCSYBYpQQ/8om2dXaWJUkirAqiyLO97exbHaEvtxjOtkf+OyxWA
 26Nf2+zg/RDq+v46eh2SjmaE+0rV1DQjugqFW0FoPR5jzM1GpVT2QVUzPQYoCH1GLRgIsP519oRMck
 2t96jxJwPB43jw18VD23fGh/Svvav5xmTVcZocGRwdxINY4v9rsxsF0hw0dCF1QYmIaZYTR8C2n9OA
 D8k23BSRQx7ezSkYx8z5aafCr/LAKy
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 407a99c4654e8ea65393f412c421a55cac539f5b ]

When KVM is in VHE mode, the host kernel tries to save and restore the
configuration of CPACR_EL1.SMEN (i.e. CPTR_EL2.SMEN when HCR_EL2.E2H=1)
across kvm_arch_vcpu_load_fp() and kvm_arch_vcpu_put_fp(), since the
configuration may be clobbered by hyp when running a vCPU. This logic
has historically been broken, and is currently redundant.

This logic was originally introduced in commit:

  861262ab86270206 ("KVM: arm64: Handle SME host state when running guests")

At the time, the VHE hyp code would reset CPTR_EL2.SMEN to 0b00 when
returning to the host, trapping host access to SME state. Unfortunately,
this was unsafe as the host could take a softirq before calling
kvm_arch_vcpu_put_fp(), and if a softirq handler were to use kernel mode
NEON the resulting attempt to save the live FPSIMD/SVE/SME state would
result in a fatal trap.

That issue was limited to VHE mode. For nVHE/hVHE modes, KVM always
saved/restored the host kernel's CPACR_EL1 value, and configured
CPTR_EL2.TSM to 0b0, ensuring that host usage of SME would not be
trapped.

The issue above was incidentally fixed by commit:

  375110ab51dec5dc ("KVM: arm64: Fix resetting SME trap values on reset for (h)VHE")

That commit changed the VHE hyp code to configure CPTR_EL2.SMEN to 0b01
when returning to the host, permitting host kernel usage of SME,
avoiding the issue described above. At the time, this was not identified
as a fix for commit 861262ab86270206.

Now that the host eagerly saves and unbinds its own FPSIMD/SVE/SME
state, there's no need to save/restore the state of the EL0 SME trap.
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
Link: https://lore.kernel.org/r/20250210195226.1215254-5-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[Update for rework of flags storage -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/fpsimd.c           | 23 -----------------------
 2 files changed, 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9c1056d6f6859522dcee4b8c4e4804a7abac93d5..27c53b603d693d1cfe8d81f94a59d3afb665be8e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -717,8 +717,6 @@ struct kvm_vcpu_arch {
 /* vcpu running in HYP context */
 #define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
 
-/* SME enabled for EL0 */
-#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 /* WFIT instruction trapped */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index f1fe7abbcb83393e7c3402405bb7b1fdbf6024ff..0492a1fc718130934f8bada836fe42bea6db7abb 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -87,12 +87,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 */
 	fpsimd_save_and_flush_cpu_state();
 	vcpu->arch.fp_state = FP_STATE_FREE;
-
-	if (system_supports_sme()) {
-		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
-		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
-			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
-	}
 }
 
 /*
@@ -157,23 +151,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	/*
-	 * If we have VHE then the Hyp code will reset CPACR_EL1 to
-	 * the default value and we need to reenable SME.
-	 */
-	if (has_vhe() && system_supports_sme()) {
-		/* Also restore EL0 state seen on entry */
-		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0,
-					 CPACR_EL1_SMEN_EL0EN |
-					 CPACR_EL1_SMEN_EL1EN);
-		else
-			sysreg_clear_set(CPACR_EL1,
-					 CPACR_EL1_SMEN_EL0EN,
-					 CPACR_EL1_SMEN_EL1EN);
-		isb();
-	}
-
 	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);

-- 
2.39.5

