Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5562E3594F;
	Fri, 21 Mar 2025 00:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516021; cv=none; b=Po1GiAQ9cp96gSKgVNboakNyQsxwIUGwS3bFoibaYw+jb33Mt21uqDkXiUsz3rjyYTTc4JeLfuEjXh+SPgMWg+GFeOVBrvvGNmVMiX4+9xKPZe+gMrD+GqpnTSQeQK5cGZn7nFlBMgezyd2Wymqbk/MiEd67qCkwo4f1heqozIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516021; c=relaxed/simple;
	bh=4+mYHr6XrwTcEyqTdBUleqRnti7WbSWNsKz630OxK1Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZHbJ6f6zSDSgL77EeLIXC8JtY/GKK+4CyWs5oUEu747bPzUM17yoecqR79GqtZJDUbJOXEIpzJZB0RDcf93HM5W5dzuq62i+V6X1FUoYfOe9p2V7kNHykOWgGunC3zSnEwQ2qf6HpdqygMq6OB0bROg15DmWPMeAwydo0Rbz4MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUqoFkwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUqoFkwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD67C4CEEA;
	Fri, 21 Mar 2025 00:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516021;
	bh=4+mYHr6XrwTcEyqTdBUleqRnti7WbSWNsKz630OxK1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qUqoFkwPtJKV1nNAsfEoSOjAK0Mu92A/YhMajLmr2OQKgAgdVtSsLjPi8b7V6Xv7C
	 FN570WpyKRVWVhraGNpdIwINXl+Y6QrA1EsQ452+OC7OhIh2HoHygma7mzgDKUXWCs
	 2DXE9JRWR07PavInjYlhCvrRHtQh98mg5CeJzJV5v/IX6NHWAtXP0JFTZkU0mGhDsZ
	 YiKfa2bZ7hjtFsMxIGZiGeAeFbujFuSFvb5HxZyAHZ+Hln+2F/rD4Zceo5OqkV7DQi
	 0e+enLjxw+spZ4Pmy2btQOQl7KjENCS13ATmi6Ysju/deNIrU0uR9n7Ara9P7eovz+
	 agFI0RXepoesQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Mar 2025 00:13:00 +0000
Subject: [PATCH 6.12 v2 4/8] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.ZEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250321-stable-sve-6-12-v2-4-417ca2278d18@kernel.org>
References: <20250321-stable-sve-6-12-v2-0-417ca2278d18@kernel.org>
In-Reply-To: <20250321-stable-sve-6-12-v2-0-417ca2278d18@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn3K8gaiSB2ODiSSpQdOlTSeteE0rnfj6LBVH7SVNq
 iakd6LuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ9yvIAAKCRAk1otyXVSH0NpWB/
 44M16CBvchiG+Rp8njF7R9zpiUBPT2XnopdzSTZRIndVwGB2oA6rEkrtTwZQej+g+Uw0wSJ7VyxJn9
 zwa8OAb8/Xz/bMcvJcRxe5qtvLAVtdkzTZkgKEYNXZutJ+BVOcnvRtotKLlHgCDH6zB4X4WdFuwqdF
 p9oj6iT3wNBbc1Hf9kyowKg2hcWmscL6Qv3HMiykjY1sVkqR4yM9Lt29P04nsfcglC4zx85uYi73dU
 FnjjET4r0Hh+QC9A3deG8NjJS7DoqCCL9SxezzPZV7YVrIyS8vtQ9HSK0dI3N7FSFziiYtGFNG0mvE
 Iiy8NnmLn1suoIF5kgQHGmv8PgPcnd
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

