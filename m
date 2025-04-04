Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112E51F099F;
	Fri,  4 Apr 2025 13:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773272; cv=none; b=CO0e8sjQ+MzOuU1wbd2o4Q++Jn0XEsyCPPZ0jzp7REHf5BZrcZM0hrzJvws5PaAhZV0cpSz/L+WKyYZGzgOJB6l+Ii6TwcLXasgseYwnPbcp6uxdohSDRb4secnENabid/kajymceMiXr9vx8D3mGvqteXtVT54mwbZGm8qoL2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773272; c=relaxed/simple;
	bh=W0sT2qa3mBNAZifs1J2a+WxYpChdTdPcLwJokOzpIEo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Uf/zZr9yGQQZwEyauywyNteN+9ibHm1ol+HhiOq0iNCKl+fHZtcA/kCqMaHvejwlDv+MwW+ovCPQw5PtnMZmO60ogFB4rBnr0pnj7wowm24jrwhsaLy4a48peeBW6StE6TjbcOvVAZ+HnJsSgMo5kpIaNI7/fXnd+utFDvv8LoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pw8M9lZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pw8M9lZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769E5C4CEDD;
	Fri,  4 Apr 2025 13:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773271;
	bh=W0sT2qa3mBNAZifs1J2a+WxYpChdTdPcLwJokOzpIEo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pw8M9lZVHewkcycpEec0qodr6bP7fZ/zpiF+ev1kIP9W0et2umUOU/NamJEWH6jOR
	 e2R/N6BU4ISebVmQ9OjT8dUp19S4HM767oOSTjB642m16MecYN1WmL5IXweluivbZE
	 t9kvI/0oLh0NZCYPKT1HNWpvQ3B2vOBiZKriZZtvN+FmtQX8dD3/sHF5r14Hp/8UTN
	 KzoL27azh4h/fUYnH6VdvMpxaKOQuvnD+wf768hfU4zngKbXtzp4RvEI2jueEzldH/
	 u2ymiSMI1D41BjwVWaR7c4UdwbOzT+6mYraZLqPFTSahCPRTCTYRaPaBUG7h/M/gud
	 wzxTC6ggGDFFg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:40 +0100
Subject: [PATCH RESEND 6.1 07/12] KVM: arm64: Remove VHE host restore of
 CPACR_EL1.ZEN
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250404-stable-sve-6-1-v1-7-cd5c9eb52d49@kernel.org>
References: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
In-Reply-To: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3522; i=broonie@kernel.org;
 h=from:subject:message-id; bh=J/OoE8FnpyEkhPOOs7+baEyK/IhjSZTlC9a6+usk3TM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn794yD8xqXui9XonlLAg4gJEZgDxzTnNyUs2dj7fe
 Io10iKuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+/eMgAKCRAk1otyXVSH0IOYB/
 sElUgNXACyCnoLY6IviOFiPWXT9uW1TDEK0HC/H/xKkC3NQt859TCHOq1e4s+ADhr4E89tALf0MOSQ
 N+kmSHjvkUqiTru0aJOxW31XWEHmyzzoF0hwEJtQ7ZAMhNMoooIYIg+ck/bQOTXEW8Io67yZ/AK6Mn
 IeyFmrtpp/ETP79o0ZYOcoNbqMmjPBMIcHauVuL0KcmvEOLIQ9kXCQ9TonoLCIl5s9qUwOUz8CMVFs
 xWd8KmJx2xhphMpj5v9R9vf66LmZpyKdbhJhm0j4n7BMa8KoOVFV9bYKr/y4BKar0DRik2hpyMSp15
 ayyZUWeErJkGv7KATAcuZWIY+VqAB6
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
index 7f187ac24e5d..181e49120e0c 100644
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
index ee7c59f96451..8d073a37c266 100644
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

