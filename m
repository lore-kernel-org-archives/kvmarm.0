Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4C87E
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 11:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7529C433D7;
	Tue,  1 Nov 2022 11:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667302373;
	bh=EXiQns829Bb67vu73AHZikkySIerml1s5ANE5SA/IJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ccbuzk5Xo8BZwshELphkIahA+UnJ2H/gM6sY3GFtdq7NTh0OM3gNPVhT6mfLFQ30D
	 +PwxTIgUVsbebYBi7z/DJpaMSNRNs9fxcrAJ1z9//1ZjbRzfbIN60aHL7rBPJhTkcf
	 ePylI87Sza2fwLZYIqAjt9oSpUCKAcDGhpNcLaSzBkCe39RHi6zrMgDb9YBAN5kYHD
	 Lpuh6W06Ca/4OToodZejEp6zlgz32oMBe1xH7vlj/3g0owbKtKpKAujXj0bnzA2rfw
	 C46rwrWZyNbe4L3fKf5SYw/2ehgzSUiTjb96XY2uvwppvB4eqIXKWyRBpuUYgtrTIq
	 8A6GLKFuOjnyg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: arm64: Trap access to SMPRI_EL1 and TPIDR2 in VHE mode
Date: Tue,  1 Nov 2022 11:27:15 +0000
Message-Id: <20221101112716.52035-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221101112716.52035-1-broonie@kernel.org>
References: <20221101112716.52035-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2209; i=broonie@kernel.org; h=from:subject; bh=EXiQns829Bb67vu73AHZikkySIerml1s5ANE5SA/IJY=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjYQKTYCLd7B0hpUD75o7ncz+2/v0Ro/MQ5Hg62/y0 0R/SkkOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2ECkwAKCRAk1otyXVSH0CdJB/ oDhMpQeRtJTk88BQUWd3a+CoABO4t6/hme/Ni263gfWTSMfTVjkSkHZFcmMZaf3tWYqOjLkG2dG94r PXLI/ZpbqsxuSenyteUZku89PCTQ6IWB/fghyZ0W+hAgFPdQ0xE/H1TFIqHdfgnrbGRf3IzWs1sQB6 P7K85txCnj9y6GzEfgL6uyERr2AUGOpjUriVH2PwVecsNS1yTmTTfSjQ7ghcbzEPKFlZak+afrrbzc mpqqFjQD/JUq3oBVykgXSCRJjxfIAx/+0ctTRvQmAwbDad9iUWvYn8YvL/xa0IcDByPpQ1+cJgfOX/ Vv861B3S6vu2DhaDSRvM4NOOrHU1yH
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

On systems with SME access to the SMPRI_EL1 priority management register is
controlled by the nSMPRI_EL1 fine grained trap and TPIDR2_EL0 is controlled
by nTPIDR2_EL0. We manage these traps in nVHE mode but do not do so when in
VHE mode, add the required management.

Without this these registers could be used as side channels where implemented.

Fixes: 861262ab8627 ("KVM: arm64: Handle SME host state when running guests")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/hyp/vhe/switch.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7acb87eaa092..9dac3a1a85f7 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -63,10 +63,20 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-	if (cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME)) {
 		write_sysreg(read_sysreg(sctlr_el2) & ~SCTLR_ELx_ENTP2,
 			     sctlr_el2);
 
+		sysreg_clear_set_s(SYS_HFGRTR_EL2,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
+				   0);
+		sysreg_clear_set_s(SYS_HFGWTR_EL2,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
+				   0);
+	}
+
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
@@ -88,9 +98,21 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
-	if (cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME)) {
+		/*
+		 * Enable access to SMPRI_EL1 - we don't need to
+		 * control nTPIDR2_EL0 in VHE mode.
+		 */
+		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
+		sysreg_clear_set_s(SYS_HFGWTR_EL2, 0,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
+
 		write_sysreg(read_sysreg(sctlr_el2) | SCTLR_ELx_ENTP2,
 			     sctlr_el2);
+	}
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 
-- 
2.30.2

