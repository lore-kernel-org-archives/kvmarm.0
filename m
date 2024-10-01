Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6029E1C2DA3;
	Tue,  1 Oct 2024 11:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782284; cv=none; b=U69XjM+iu/kFHd/Rq86FVl0JIQ2B/9PLuC7d4WLvqGvTunGJwUJL9609NvuwlYqG5Plft7bruzL7gWAquOfTEcKk6HDlCIgRfFDI1p0x92zcj3glVpxtgIXy+ZDpffc0Kw+wpbeaUgFS4MM4iFFcPV7pahzkMrWuE01ykf+eNT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782284; c=relaxed/simple;
	bh=3H3rN27/T4dSvW1Uedlxa4dx04M+fhPbfJn2xQeiUto=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gs8UwUZASqBmtOKCunf4TWzehwN6URiI6qG7dxUN0ytxQNaqPiBlpbMVPLcackwwCkWMPaXkCs/e6TRvcph9sW/KfZvK4A3Zqp39zZq4e3omi+y8N6L84v/y1MvxdLV2z7LZRSqleowj/4k2DIBMx5gpxABpoHMGYlhvenPPSjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ev0zcnej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ev0zcnej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065F8C4CECD;
	Tue,  1 Oct 2024 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782284;
	bh=3H3rN27/T4dSvW1Uedlxa4dx04M+fhPbfJn2xQeiUto=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ev0zcnejLlg4untSFDKPs0uu9yRjLpeF29NXm6Fyn2yh3/+5F6eKQ+i/efPs3+p7m
	 Ms97pZVloGyzj0h7PgGqWHkpDCdU2MDWFiWnNyBAlGYlbBbgkT8of9E3yp0dHCzQjc
	 FG49kMw6VnsY+KD8+Bu2FZAUZQFnS/gitVh92IdizoZi2bkwMrboc7ogwwjzfbrFq/
	 itKBJbxfIL3lh2wVsGkt/RfR3TrVW5P6/hfsI6PJHU46H27qv9ZFa4NUTB/rCpWR1l
	 qJewLv3219nczc442IMtmEliB4fnOxgEqrFnASQNOgAQaA24w9cHZVlGiF76UuT7fU
	 RsaaVHjOy2elA==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Oct 2024 12:29:09 +0100
Subject: [PATCH v7 4/4] KVM: arm64: Avoid underallocating storage for host
 SVE state
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-4-7b0171a36695@kernel.org>
References: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
In-Reply-To: <20241001-kvm-arm64-fix-pkvm-sve-vl-v7-0-7b0171a36695@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=openpgp-sha256; l=4775; i=broonie@kernel.org;
 h=from:subject:message-id; bh=3H3rN27/T4dSvW1Uedlxa4dx04M+fhPbfJn2xQeiUto=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBm+91+bqwK4f/pJu2CGuxMaixni9UrdS9SNp0K0H+g
 BdW8tDmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZvvdfgAKCRAk1otyXVSH0O8MB/
 9PffATY1K7tJ1hlmtmShlhAHdohSC3qAnH0uEWLq5dujSFDSuS8JMjvRLtBWwAApYUjohwazjqUMGr
 S6MQmMdtfoV58SR9WNsybgfttZz3/uUpVu8hWjJLRHIKm7drRnIjuhK2oerBmf4UaS6EmeiZ816hvb
 qV4L4r53Jp/fm1zDfziPzD8Vu5vCb5UwJ7HOmd7vAhyehJ4jkNnLG/kF63IHnl/hDaw2po5EjH/fCp
 oNaK0u1sYxpx592tHvJj/Orl/hKz2D7Wtuu6M199308Qhe+CKvn4rLBNdxudXs0uEG5R1ot344mBT2
 y5b51UB7U5839ImBX7zF9B/CbsLJlo
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
index 329619c6fa96..612a5adc2dbf 100644
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
index 6b074f4d48b2..19f3ae9f05a9 100644
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
index 48adcd005079..234372bef85c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -99,8 +99,8 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
 	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
-	/* Limit guest vector length to the maximum supported by the host.  */
-	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
+	/* Limit guest vector length to the maximum supported by any CPU.  */
+	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_cpu_vl);
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 187a5f4d56c0..770d66491b76 100644
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
index 0b0ae5ae7bc2..6c87d01514ff 100644
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

