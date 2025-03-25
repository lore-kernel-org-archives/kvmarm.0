Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303D11FA166;
	Tue, 25 Mar 2025 18:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928595; cv=none; b=Cx+5+AmIXD3pl807iEn8nUyqL2qrby7yGxn/BguX5fQEmINMQGXt4kpUHPTAb1Gv+lmY9Kh0n7rgBIlXefxpp+y0bmAST00Fw2NpJfvh5IpqsviWMHmGs5DC3Bap6b7BIST2UlbMjiyO/YrGwR/p3yA0JQaqGW34RtLa6vjkk0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928595; c=relaxed/simple;
	bh=PAInbWCkPhVyvHW1OyT0/R1QKc+euJxNKjQemtpbrMQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Teb+nlg9036Yy7ynjAk0ZdPb+32BiULL5+PQmBjUw0sXOOz+U+rPtr/J+gOw9iSPS4g0rygRP8q2OUELyGRvhd/K6r0ROmun6m6akZm9wcGYeDEZ/rZ3I8PRbvJdrkGLsV0ZK5pSt6f6Gvx27r/h0DZX2KXPw829O8g512jWRXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Is7im98O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Is7im98O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153C9C4CEEE;
	Tue, 25 Mar 2025 18:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928594;
	bh=PAInbWCkPhVyvHW1OyT0/R1QKc+euJxNKjQemtpbrMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Is7im98OJdqY2pVDG4/myE+QiI3nWnFzfg6pLkBQTHDddUlZryPF2v5DgjC7WA60/
	 hX9S8j/FWEhO8tZGbRruL46jkT6bscQt6Cfcmbo7lR1WmdyLsBpHLXfea1Y0aXkElj
	 OWOr7iv8D0z08l11oaYoAku2Z9EvC7dciq7yZ5wAp9GSSEKLh/ACSMia7EZdAfVi8R
	 Ja/C6sUw3stxbfoqfwS8Eb+SJve1yrUFwvJMlrl/r8DYS53g84/ZsrIB3Cc/fhXvdx
	 tMafBuA0hVpVCIH5cH3oO7S67XJ5lfLT7b30KSqEeVKbg0i2nQdX79afDIzZ5+z3I3
	 FGDFHHuLD5I8g==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 25 Mar 2025 18:48:24 +0000
Subject: [PATCH 6.1 10/12] KVM: arm64: Mark some header functions as inline
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250325-stable-sve-6-1-v1-10-83259d427d84@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5193; i=broonie@kernel.org;
 h=from:subject:message-id; bh=F4L70t0EqFujsaivp0SuExIsVoApJaBgJGOrvRXakj8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn4vqtMBoqqD5Sv0NsNbf/jm3399W3dXWhYS+PeLSJ
 xx/7D/6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+L6rQAKCRAk1otyXVSH0JpOB/
 9Zx6xwLpQQIN7NJ3Ca4GScfoi84yTQr3CEfBpufEaa3Zu0NVSPwHWxbMnr4+mbeRuA9yCE/U1FMZlq
 EWpTHKespx812NQCLcElAw3o06xZcdDoK6T5DujxPxrJ7bZQVASx1JjhH78OTi0sNNEkbnBYxcpAxa
 FouSUBW4N9u9PkjUwVwtjSEKxqqQM+gHDfo9qLAiKm/EKbu5tgEItR11yVwEe3J1PKXE1+lBlw+xal
 lcOlFVchlYup1y0lz1/5CxpSgG5Vmi0L5XAFUGgDLQkzcXTuEnecT1ub4mm67LV5Pa4TStmjZpWeAn
 WOhIJLNdLLbHcdV7Zp3JDYdOnUI82d
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
index 379adbb9d8f2002599c2c135f936efaacab760a3..0db90cb47308453caafa214c3ee337ce990a76e2 100644
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

