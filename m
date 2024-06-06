Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB78198841;
	Thu,  6 Jun 2024 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687931; cv=none; b=ItFHUj4YkhajYzswyLixV2Acgn26d5EdqN0wLx2KQ2tW6kacmYEhaQPhQbFbaH+PU4Uh/cSnjOzGGZoZXT1RXpjmAYyYyKLMP/P4VMsQJZQAdWaFNi9iqalDuG2/Gno4cBEh+r0NzqSqlAtGQGaZSImkR2YIBHAj7X62eg2MkHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687931; c=relaxed/simple;
	bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R12ggYLF0Ioyk8S5pscidaTg9+iPTXtxqmihx1qG96jte9nacyTybZ9TXxAdrKeumU2SIshPeH3cJiYRfQ8/EEaOYMLFLItOYNHQPD9usn+uXaFXsi2U2FLZfxMajhWt7krXSMUBNDcKOVO0vRLiK4mRWfYTUiiNaCYyb1VAijU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzVOJ3lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzVOJ3lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAD8C32786;
	Thu,  6 Jun 2024 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717687931;
	bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FzVOJ3lr0INEoHiotznW8SDe8HJ3POVh31xzThqGfrbaYnu8dnMoWcphOGtUdd8j3
	 fGEVK2Uv1kZIjzDdwPAex6g+Ql9BRD+LwJshrYKl3i3jZXUuxsHg5U/XhVB3osR7iQ
	 RX7ifnqYXVtIYg9+u536CHTaf5j6ZKSMnuZG4S4PN+A+FHQCGvQ6kAiuZWuTbaGy6S
	 k+Xt9SCm2S10ktQWQtJZ9IqBtXSZqUVHWLmYGQscqG0ikcZ7phbkQFbqVj1mlHv6Mf
	 CIwrVVw47NMqcj/uqwqnsGjtSFmieEx66sD0HZJ9Ah6h0zdf+aRYcYuZ/HLlS+EbM9
	 vqD6jUEe3Jvkg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 06 Jun 2024 16:21:46 +0100
Subject: [PATCH v2 4/4] KVM: arm64: Avoid underallocating storage for host
 SVE state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-4-c88f4eb4b14b@kernel.org>
References: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
In-Reply-To: <20240606-kvm-arm64-fix-pkvm-sve-vl-v2-0-c88f4eb4b14b@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=4775; i=broonie@kernel.org;
 h=from:subject:message-id; bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhrTEa7mvI+ar1U3OnsL6Nva70cesxpJ3GkoX2WMlhBQubvJj
 qjXrZDRmYWDkYpAVU2RZ+yxjVXq4xNb5j+a/ghnEygQyhYGLUwAmYv6d/RdTYQPTVbuJk9KDhWZwhp
 z/yPjEt+unpW90p8eq6RMcNn5O5p9m6qr2313lRf/bbzuvls0t/tQovtx/i5tsvPn/DVt1Wep1Opbm
 ZUubM8hrGe14vVOg6dW8qVpJCQ//fpz1Vq5LZ+sm3rsVgs7PHoh6aoReimdZxxpoNLX8W9OMkpyYpS
 YqlaZTbitwLd6UmaJ/36hutctiB69pEx/xTO0SsVZ9en3O0yxNsXvG2xldyu6Ilsu+uxie4FX+qDa8
 8tqCY2niga5qwSUbm56waUeaXpC0/8UltC6I+bqu94/lVuk/hEMl13032qnSULPw6t5gkYJbM9SarK
 yLLv3ubG9/YMy6n3f2l08H2Hp1AQ==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

We size the allocation for the host SVE state using the maximum VL
shared by all CPUs in the host.  As observed during review on an
asymmetric system this may be less than the maximum VL supported on some
of the CPUs.  Since the pKVM hypervisor saves and restores the host
state using the maximum VL for the current CPU this may lead to buffer
overflows, fix this by changing pKVM to use the maximum VL for any CPU
to size allocations and limit host configurations.

Fixes: 66d5b53e20a6 ("KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  | 2 +-
 arch/arm64/include/asm/kvm_hyp.h   | 2 +-
 arch/arm64/include/asm/kvm_pkvm.h  | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 2 +-
 arch/arm64/kvm/reset.c             | 6 +++---
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 36b8e97bf49e..a28fae10596f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -76,7 +76,7 @@ static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
-extern unsigned int __ro_after_init kvm_host_sve_max_vl;
+extern unsigned int __ro_after_init kvm_host_sve_max_cpu_vl;
 int __init kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 7510383d78a6..47426df69875 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,6 +144,6 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
-extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
+extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_cpu_vl);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cd56acd9a842..6fc0cf42fca3 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -134,7 +134,7 @@ static inline size_t pkvm_host_sve_state_size(void)
 		return 0;
 
 	return size_add(sizeof(struct cpu_sve_state),
-			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl)));
+			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_cpu_vl)));
 }
 
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index bd8f671e848c..d232775b72c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -90,8 +90,8 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
 	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
-	/* Limit guest vector length to the maximum supported by the host.  */
-	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
+	/* Limit guest vector length to the maximum supported by any CPU.  */
+	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_cpu_vl);
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 95cf18574251..08e825de09d1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -18,7 +18,7 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
-unsigned int kvm_host_sve_max_vl;
+unsigned int kvm_host_sve_max_cpu_vl;
 
 /*
  * Set trap register values based on features in ID_AA64PFR0.
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3fc8ca164dbe..59cccb477cf3 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -32,7 +32,7 @@
 
 /* Maximum phys_shift supported for any VM on this host */
 static u32 __ro_after_init kvm_ipa_limit;
-unsigned int __ro_after_init kvm_host_sve_max_vl;
+unsigned int __ro_after_init kvm_host_sve_max_cpu_vl;
 
 /*
  * ARMv8 Reset Values
@@ -52,8 +52,8 @@ int __init kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl();
-		kvm_host_sve_max_vl = sve_max_vl();
-		kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;
+		kvm_host_sve_max_cpu_vl = sve_max_cpu_vl();
+		kvm_nvhe_sym(kvm_host_sve_max_cpu_vl) = kvm_host_sve_max_cpu_vl;
 
 		/*
 		 * The get_sve_reg()/set_sve_reg() ioctl interface will need

-- 
2.39.2

