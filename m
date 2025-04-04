Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60E1F4639;
	Fri,  4 Apr 2025 13:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773282; cv=none; b=ZMnLIaxXl1nmF1wnqa0GHEg82iI53nhILePSIj2yH1NXA7ka7C/D5oJrVHV8BZxUnXpOaAOsYZulz0kqxlPx3mI3M4PiFaFX0k7b93OPusWjyj4ml/bWbMG9IMIfwiYwtG8CN/I+aHE0fn2D3cisVXZglOOFiiNVy7LVILtlIUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773282; c=relaxed/simple;
	bh=gE0XAPC5xRIsrVRqtYwEurWonEuJgmlbRj3tf9r2YFI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nYxhx0ggHI1fCIvastQq/u7ICiXZyLIA8ltYPt1RLCVMz4+0euBvcT3OZOrZ7KY68nZzgk4wZI032ImpvtKvGBmuz0ZNQrbbrUxgLxe7vqGGqJuCg0NQYPQYB9gDYNMKhRauZoTc02WBprMZcQ7JOnbBbrIBHUeBxxWPsIq0c0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ucQ1ICaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ucQ1ICaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1FCC4CEDD;
	Fri,  4 Apr 2025 13:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773281;
	bh=gE0XAPC5xRIsrVRqtYwEurWonEuJgmlbRj3tf9r2YFI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ucQ1ICaRHd7WxG0dtdzfRhZnWwyG4OJGzlJXfS1Fcsc3mK7XXKb4gWb9G54RXWvZl
	 7IW91HRsd/WnY0pz29n6ezHp2jDfyZj1ZdDNqDcyNWYUR2pbyLNdpigebRprje4h++
	 2P2eo5U5Af3QN2qi5ubfDg2qKv9aPd+NjJObS6DkDg2vvK9QAaG3MQQMawCnwPM7EH
	 4sB2IP5tGT6evV5FTDJrDLwdz80zgK2mSgMC1ptgOscDis7GsSIL65XnuSAKm8HRaC
	 QLwGLE88oUwY2gfZEVoCDP6ZZXm0OD9tGwmNRwezv7XFZKeFgxTpZyTXlpdRAgz7zk
	 pQS0mJqBW/RZg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:43 +0100
Subject: [PATCH RESEND 6.1 10/12] KVM: arm64: Mark some header functions as
 inline
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250404-stable-sve-6-1-v1-10-cd5c9eb52d49@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5137; i=broonie@kernel.org;
 h=from:subject:message-id; bh=NPzS2yHg70Md7RpLQT7qBsX+2t7KHuaHc4LWCgMeJxQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn7941q8jm1F/JMP8Kljt9xSO+rSFf0+cqCzUX+6fc
 z6GeocqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+/eNQAKCRAk1otyXVSH0BqiB/
 9/3qGxB+r+hiitO6PkxAbHUJm6y4pJYq6aNk2F8qtNhnZoFZODmkBVLMjVire6e4RKVvbK6vDJ6nRL
 I92sJKStfc87pU3gxOZZXq5F8zV1rxdUhL/py0lS+A29FGVWduHN7BR/TqvP0pICTpYYYJErBI9LGl
 8FF1l5v9SeEtL59YoyqixNM8eRzEK3wDQy9zbq8PAm78cvvqAXYG+OaBARpNsYNbicI8qNGOe2ZmK9
 lx/V95Ia3qSrCW0PByClPXGQxJ8US9QDXUjW3JIGc4RFqrG/7WwLP0H1/R9/aiG4RXoLfRKnmaj7ZB
 k7cAGO/FuuqleFIdQHBt9ld+QuOI/x
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit f9dd00de1e53a47763dfad601635d18542c3836d ]

The shared hyp switch header has a number of static functions which
might not be used by all files that include the header, and when unused
they will provoke compiler warnings, e.g.

| In file included from arch/arm64/kvm/hyp/nvhe/hyp-main.c:8:
| ./arch/arm64/kvm/hyp/include/hyp/switch.h:703:13: warning: 'kvm_hyp_handle_dabt_low' defined but not used [-Wunused-function]
|   703 | static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
|       |             ^~~~~~~~~~~~~~~~~~~~~~~
| ./arch/arm64/kvm/hyp/include/hyp/switch.h:682:13: warning: 'kvm_hyp_handle_cp15_32' defined but not used [-Wunused-function]
|   682 | static bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
|       |             ^~~~~~~~~~~~~~~~~~~~~~
| ./arch/arm64/kvm/hyp/include/hyp/switch.h:662:13: warning: 'kvm_hyp_handle_sysreg' defined but not used [-Wunused-function]
|   662 | static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
|       |             ^~~~~~~~~~~~~~~~~~~~~
| ./arch/arm64/kvm/hyp/include/hyp/switch.h:458:13: warning: 'kvm_hyp_handle_fpsimd' defined but not used [-Wunused-function]
|   458 | static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
|       |             ^~~~~~~~~~~~~~~~~~~~~
| ./arch/arm64/kvm/hyp/include/hyp/switch.h:329:13: warning: 'kvm_hyp_handle_mops' defined but not used [-Wunused-function]
|   329 | static bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
|       |             ^~~~~~~~~~~~~~~~~~~

Mark these functions as 'inline' to suppress this warning. This
shouldn't result in any functional change.

At the same time, avoid the use of __alias() in the header and alias
kvm_hyp_handle_iabt_low() and kvm_hyp_handle_watchpt_low() to
kvm_hyp_handle_memory_fault() using CPP, matching the style in the rest
of the kernel. For consistency, kvm_hyp_handle_memory_fault() is also
marked as 'inline'.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-8-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 379adbb9d8f2..0db90cb47308 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -173,7 +173,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
  * If FP/SIMD is not implemented, handle the trap and inject an undefined
  * instruction exception to the guest. Similarly for trapped SVE accesses.
  */
-static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	bool sve_guest;
 	u8 esr_ec;
@@ -331,7 +331,7 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
-static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    handle_tx2_tvm(vcpu))
@@ -347,7 +347,7 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
 	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
@@ -356,19 +356,18 @@ static bool kvm_hyp_handle_cp15_32(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_memory_fault(struct kvm_vcpu *vcpu,
+					       u64 *exit_code)
 {
 	if (!__populate_fault_info(vcpu))
 		return true;
 
 	return false;
 }
-static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
-	__alias(kvm_hyp_handle_memory_fault);
-static bool kvm_hyp_handle_watchpt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
-	__alias(kvm_hyp_handle_memory_fault);
+#define kvm_hyp_handle_iabt_low		kvm_hyp_handle_memory_fault
+#define kvm_hyp_handle_watchpt_low	kvm_hyp_handle_memory_fault
 
-static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_memory_fault(vcpu, exit_code))
 		return true;

-- 
2.39.5

