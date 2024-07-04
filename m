Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89619143735;
	Thu,  4 Jul 2024 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720114133; cv=none; b=RgTYnKmgsenuj4iY493qL6SemNkF7JkPpar8cSkPE605uZyBEqyUc8oHpUMybDFjERKAD/38O3gZXbsf2z82kqI4thERbmCGu9JicfUprbCJZemRzfkK3xUMHA6RVNIAAjy9hMpzFpT9a/O7m6di4XclGwXI8j1LcsMu4EFG7u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720114133; c=relaxed/simple;
	bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZvHUmVgLMkf/ghrJSqHQqW8CPCIep04+aAIUCK6/ysqHcWidxwYL21gxMpn1zJ3se1XV0c02Pl0ZGfuk/5PQM7pKjdGWiy8had2hMC9jVLJUSyFwi6IsG7sWBuW+NV2au1Jjp6KawlHk9tKC/sL3igObp8out9bu3OSyNTZmyZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdbRJJWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdbRJJWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03404C3277B;
	Thu,  4 Jul 2024 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720114133;
	bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mdbRJJWNI3puu1GsTOLfV2pPcyaNykIWsTWCr6e0n5Y2AnCeK4s9DBqYztyV37bB5
	 snT99bbjwP1cHpLhWGEBrU4wHCnlC+1UIGpdswRRR9ApdJ5rhhKhKCCGwEKaEjxeyp
	 sJBBeWCLw/OeS0ypjniL37FbhPiYcZQ0C3daC2gArvtebDvgnpxDJqceKNw4CO1grk
	 3P7A+D+aL0HQU5K1nUboJ4AD63ttjuOAIeMLijBPzxPrwrH6ZXBjBobfkZ1iZhvJo/
	 QMkTb03lPPSvZtYbSTBTMsEcL3QLUEwE+zZLP7HbYH22k9WE8TI8RwScCIGHCuPHJP
	 bsQdzpGy+0BcA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 04 Jul 2024 18:28:19 +0100
Subject: [PATCH v4 4/4] KVM: arm64: Avoid underallocating storage for host
 SVE state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-4-b6898ab23dc4@kernel.org>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
In-Reply-To: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=4775; i=broonie@kernel.org;
 h=from:subject:message-id; bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmhtvHDCSA+EttQlp6u8OC+VSsPdbMbLuviJEii2Fx
 wLDUUO6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZobbxwAKCRAk1otyXVSH0PEKB/
 wOC1IK9P4GkK90oUkckWHzEkGJPWOOsRwz45z1vG80m4sdxRY460N9KXqa0ipgM1ZDM5LNeC6W8rqd
 AG/hKa0gwkek8KryyQwSjPgxgRwubySNIm8wPTfVDYzTpp9HvG6RbC3v10Pkn/TVk5W5m3rSrhnAkC
 ebpYBoo3zSb6hAWrXRinY58Y9SHLSE8nhvdr/1fZmt11mzDNyi3pPCl2apLjnCGzUUGzUEVTkkSEMB
 ASAM4qgJ3Hc5v1oFq5ViDOLCOxvgBQhaNXSoi3k6XaVJ0zvTu8n5/vuAgQqM5HexsVnBtBo/GBXzVt
 ZhQArw3MgRAKl9N9pa1NaP+q3hDtK1
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

