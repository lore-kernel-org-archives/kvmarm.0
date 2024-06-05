Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06A713791C;
	Wed,  5 Jun 2024 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717588215; cv=none; b=eFFg/7qbVhU8yBQVimXWlNGalT14z4/KvGR0uhoUjkg3eeHuDsD2JoKuX2fnIPmfR7VbGKG00+D7ZRqAfvBTkJa26sQruB+xQg2wvCdPeVPaAnXwQcwYX0LinoSquxN/lAGhnFVW6f+bcS20poM8XIP53TtCuc+hgZl2kG+BUFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717588215; c=relaxed/simple;
	bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dilUVyDmKS/u7J+un8PhmewZ3mT+wxs1q+jsO8OKTzeAVPQdZVlDRdxbLoIWWdBFtbwJr6tJ3T4orDZDyXZrkG+CxJUpFgd/IioWurLEyK+TDiCulOIgXG6vosS3sX55dG6HVyojV04QCFmn+Q5OcVSfdFkeWXhk4yzzM788+cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAlnpnZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAlnpnZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445BEC4AF08;
	Wed,  5 Jun 2024 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717588215;
	bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LAlnpnZYLXMLUpTvG3MQVyE+K6rpEEFqw4vUwMUmPLD5xDfHwoSWshyluK3r9vLSi
	 Pkm44HYBiFqaMrp7zVwDhsImoH0ogYo56Quk5PxLqo0wbmwHuUgNCNg4pTBVsNHNV6
	 nn76CiUxAiOa2D8tyHhG9HR3rLSNCvToPBwiTWCYN+BTdfHKk76Jslemkq3As8asPJ
	 UN2UzbEgOlPfgJorsQQrZktTxjFQ7lOVcdpwMwscEcBOWIHo6mqfIBYX+yDsj7TI3O
	 IiG4zT7SSzpv2LSo3tIRcShRBwZaLncdu2Mi1iZBO7YzThWu3m1spjTroRC0m8qO60
	 sBneQuG06drFg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 05 Jun 2024 12:41:30 +0100
Subject: [PATCH 4/4] KVM: arm64: Avoid underallocating storage for host SVE
 state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-4-680d6b43b4c1@kernel.org>
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
In-Reply-To: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.14-dev-d4707
X-Developer-Signature: v=1; a=openpgp-sha256; l=4775; i=broonie@kernel.org;
 h=from:subject:message-id; bh=I+qiD9f7AIjkeTzE7i3sCyRtTk9/3BCUmNFuB2K/uis=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmYFDpNLP6xsTXnP4x+K63OmWAJYiakPHrQkrNYpo1
 ZXtEslWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZmBQ6QAKCRAk1otyXVSH0K9cB/
 49BkO45ApDn9aeWm8mUJ7CZsd+CKe1eEiMHrx3B2uFlNMFMa2p6dYhjR3kVwQJBgSKZNTsBSvfQW/b
 lTwH0VLX38XW3mnZDcisC9jPnwSe1OXSdaBnrR/DUTEgYr0AHHg3TGVcRFlGADgEBFxK1NUz1M5A/v
 EtS9jcxTuzkrKolSa7nRDIPjICi0nC1riWydKf5Gy4O9vVWybhQKBoG7cQx+4AmvwkISFmxvU+Kqz6
 dE58oIqi3KKMKri4kd7H3KWfrX8FI8zcdV/J+NsVvhZ06HCMP1oFWVxun2qOoHHYxlPhxFgVeCcLSk
 K0XMNgb6L16jUyGCpHiZSmMb3F/z9m
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

