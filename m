Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360A44207F;
	Fri, 21 Mar 2025 00:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742515858; cv=none; b=GEx+Gzc6cOi+K9X6mm9diajt/FixSTiMV4KgRlmUsjj+IYmXev6z0Dv0bY9xIfpaJooj799EsIMJu2FkzBO3P2NI71JFxaP1+XGQZtIx4/tp7NcNwdmIrhQKuQtOuirkRDPM6YePaCCWQLNLwar1g0rTi1cSpE6J3rHtMltVu1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742515858; c=relaxed/simple;
	bh=bw43+XI1pckdNtniIOtil4SJwIekSgoH7HvyZXHg1qA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ArlvapWxZgwBHhilydoRQ+/f/0cR8PLg7Zr00o3jb2t3khoapbQniJahj+sCd5zFPcswFggwDkYeN5xXI4dtp9Xa6TWiuDqvD+pjmGQWllT4ZM8Q3HJzv+ghpYlZJ5CSPh88UqBYxJ3hazMfUq1tte3eTBwZLOqHcLBIgaeGPsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wob2BTQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wob2BTQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71B7C4CEE3;
	Fri, 21 Mar 2025 00:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742515857;
	bh=bw43+XI1pckdNtniIOtil4SJwIekSgoH7HvyZXHg1qA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wob2BTQkjk8R9W8rECTaBsKdvGyJjN4nK04fI4ADtYnwa9XR+3DrbjeobSoXeW1Ra
	 CgOwCYp3gSMSWCLnxbMZH6nCPwj3d2U1LZF8IMNHQuowpunRIhsTwRWRyQK7xcMaNj
	 c3xR3JYmIom+gtdNhP0i4cGRIZN2i6NbKpk6vghcOX23QTvfs8o8EKOSLIMW4cLKwy
	 rwDGKZB5cbiilfmFGvjG8CcnxC6R18kM2SWQGKHYjpBoLgqFt2tQJtIWozi2k008Cq
	 f6coRyLgdfI0cgPEWqxEDjh5Ag7+cOA2Sj/IRrAYs909PTDZA7y4uB1f1AnaewNL0g
	 +zAZDKua5Ci1Q==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:10:14 +0000
Subject: [PATCH 6.13 v2 5/8] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.SMEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250321-stable-sve-6-13-v2-5-3150e3370c40@kernel.org>
References: <20250321-stable-sve-6-13-v2-0-3150e3370c40@kernel.org>
In-Reply-To: <20250321-stable-sve-6-13-v2-0-3150e3370c40@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=4631; i=broonie@kernel.org;
 h=from:subject:message-id; bh=KPO0pMf/f4hzNo7O+4ORc0iTjEcZ2saBRPtDAXpQPO0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3K53NCIK+0T7a4DKTLLE6v2Zr7zVILM3BfHegMg0
 I94VU4OJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9yudwAKCRAk1otyXVSH0DN7B/
 9Cap64hoWGEJL5wQP32lxgKtJDP/KaNywIK/Ync5h5ozwPtfpnS+dZzasAxRCZbGTOJ3w2Hc7c1qbk
 XJn6MtPgDcun0m5NGKk+kkBZkppxswoNY+loI6A3qKx/25hBGa0NasXteSbjihPYZ/zVWF/A+s1qNH
 9eqEemritFtDfEQf8YL9FqxTHC8hag9urGaUVLDb5sRQjTNpyYaqlX6pWoQU4LqgPWYhuPhYq3aDjB
 2K/6P9t2EGNjsg9kTw0hFn9T/DVC/ect6towvxX+9B+bbdWrAgXtSkfx3wLYPxu/1tahTea/f+PdVT
 luZMLU6avvPrVmRGxnTGOYsFYGwf5Z
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
 arch/arm64/kvm/fpsimd.c           | 21 ---------------------
 2 files changed, 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe25d411d3d8efbe19d5ffba8ea23bf98eb06c38..06e3cfc9a73b8c95712580b13b926b6471a16be7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -902,8 +902,6 @@ struct kvm_vcpu_arch {
 /* Save TRBE context if active  */
 #define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
-/* SME enabled for EL0 */
-#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 /* WFIT instruction trapped */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 4127abfd319c2c683d2281efa52a6abe5fac67ee..f64724197958e0d8a4ec17deb1f9826ce3625eb7 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -65,12 +65,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	fpsimd_save_and_flush_cpu_state();
 	*host_data_ptr(fp_owner) = FP_STATE_FREE;
 
-	if (system_supports_sme()) {
-		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
-		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
-			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
-	}
-
 	/*
 	 * If normal guests gain SME support, maintain this behavior for pKVM
 	 * guests, which don't support SME.
@@ -141,21 +135,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	/*
-	 * If we have VHE then the Hyp code will reset CPACR_EL1 to
-	 * the default value and we need to reenable SME.
-	 */
-	if (has_vhe() && system_supports_sme()) {
-		/* Also restore EL0 state seen on entry */
-		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_SMEN);
-		else
-			sysreg_clear_set(CPACR_EL1,
-					 CPACR_EL1_SMEN_EL0EN,
-					 CPACR_EL1_SMEN_EL1EN);
-		isb();
-	}
-
 	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu)) {
 			u64 zcr = read_sysreg_el1(SYS_ZCR);

-- 
2.39.5

