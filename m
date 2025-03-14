Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267F53597E;
	Fri, 14 Mar 2025 00:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741912546; cv=none; b=C9bVSQNK2T192DHL6EJl+37ASjOmOz7zcJrLxoGrHfM29WYxTqWqY4YAHLHViYxeKTHVE40aGLEiL8qrN97mJ+k/Odf9izy+f3Pi4HLGzorPHsfe4ZkBO1eoL+gi8tNYCdFR2dOUNeDyymt4Bw33BRMWZoYq7bZpgoC7tNaxRzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741912546; c=relaxed/simple;
	bh=4+mYHr6XrwTcEyqTdBUleqRnti7WbSWNsKz630OxK1Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sgGCxt+2bQ/pOQ4gQ71OHhiTFMUy+WMlJbUHCQQhhKjf7W9MiAqK6Aq4rJ2fIJK8N6SuHNrl+LjfmdYXpzhcoAd1ErIDVJVFOGwM6nfnpjIZrzndOhfbPDn8r5xhII/MzXR4tKh/T8hPw6chsBvNHg1Qs57mkZRX9A7914Ytss0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrxKdFZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrxKdFZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90CBC4CEDD;
	Fri, 14 Mar 2025 00:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741912545;
	bh=4+mYHr6XrwTcEyqTdBUleqRnti7WbSWNsKz630OxK1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rrxKdFZqKvTcyDncxV/TtSYVugzseXFWXAmEVnPDNOQDdLavoVRVv0dEfvOoXLPq/
	 3+bnSwyB8ElyB5l/V4yYSpX6bRUsO5fDJv//ER6pYHQO4QnzbtomXc/l86EUKIh3Em
	 o++PCkqxgMF37Zj2u1SOWXhQzz0Q0MszZy9/4LdobltK/J//j+zuECkUCmmJCbYztV
	 YIXmy/WZZJt+rDPt2p3JYJtNmOiGlJbpgR95HxGFPsATlHAE4CZJL3UUA5MCUAr505
	 9/PkIn2Pz4FdFcy5Hii/U5Mdc0jh59qdo6lxSbL1o/ynmDZ4hIV/8mrpg5i6MUO3kN
	 Q5gi6A/SzZxFQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 14 Mar 2025 00:35:16 +0000
Subject: [PATCH 6.12 4/8] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.ZEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250314-stable-sve-6-12-v1-4-ddc16609d9ba@kernel.org>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
In-Reply-To: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3661; i=broonie@kernel.org;
 h=from:subject:message-id; bh=IG25WLsxwjh6t3HKhjHMAeq/c25F13vYeIg5ZhI8+KE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn03nMwHYWPXekYPZtInw5WqLEUbkeLchxCD9rolOf
 FekNG1aJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9N5zAAKCRAk1otyXVSH0JH8B/
 4uvhzEEwUrhCw1hZhx73ltY0sESRwMaZFpCuIxaMnt05Y47SbkbUKLjMP/4AqzQIF7YNgqq7mw4c7M
 rVl4fKS/IGw8Vk+N3bXuyBJlell9CbONJK+KX7Smr+8UBE9a2S9gbFm3sasyig77wMfcnn31nuaRWQ
 vMtlPvMOvUDfYW8BPAQR/o/EqV2/RDXSMFZLfP/OpODVYAwqCywQ9Q452OoQ40UYXSew8Fpa7dgd2r
 yHKVWovPDSmk4C4qLEChLTD37/R1cy/2E/FZhvm8jasA4amUrBMPDcpl0U6petXt/tKbi3P8HA42io
 DtvMqIO5sBHLfUSzuIZRAtVk4FJ4bX
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
index d8802490b25cba65369f03d94627a2624f14b072..1a126fa657fcde3433f37f3aaf464a5b6a5f095d 100644
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
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 2ee6bde85235581d6bc9cba7e578c55875b5d5a1..4127abfd319c2c683d2281efa52a6abe5fac67ee 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -65,10 +65,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	fpsimd_save_and_flush_cpu_state();
 	*host_data_ptr(fp_owner) = FP_STATE_FREE;
 
-	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
-	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu_set_flag(vcpu, HOST_SVE_ENABLED);
-
 	if (system_supports_sme()) {
 		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
@@ -202,18 +198,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
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

-- 
2.39.5

