Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C0119994B;
	Wed, 21 Aug 2024 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724246048; cv=none; b=fjFBI0QpJNUd0kpy6EOoc+laSc2YrH+SV3JZh0bAqEtf65UsBHkqeIN8KcKoesSrcW6O7l4E0VnGAnt2iLecxmBAtQZY1vErHou722o88Qn0L0DH0wttoVmgYpSV1Ckh+PyNsxCtVYDKdh48fi/WTTdRl+de1RPl1Wdw1JbU8ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724246048; c=relaxed/simple;
	bh=MuP5Cq46nVjdRD00fJkyIdDWf1YqCyxnb9KmrwxPUec=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iKRO7hpbzM7J/jKW2TLm5i3oa25IUHUjJgIN1oliNrrOI77CmPJQ1EVuYpqiTffPwwZolL4PFX+tnyGGusGZ96yv0e0+ymaxow93DzMfbPWEhXpjzMiVDboK0tmsC1SJfUYhzMgnLDx/jXCI8XK2LqnJCJGAlAL8FLQrgif/H2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmyuntaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmyuntaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750E9C4AF09;
	Wed, 21 Aug 2024 13:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724246048;
	bh=MuP5Cq46nVjdRD00fJkyIdDWf1YqCyxnb9KmrwxPUec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qmyuntaqQ5VbPdNVZl1IPKluOumiawAgga4Vj1MLoX/WmeAp5vqK7+Rdgl0g9Tm6g
	 nujptz48lbK19X4dOwlWKkhppQ41UOnzODAOzr0DyYhMIfVaIAvpG1/e7y7oIl4ljU
	 n7UMwY6ZwbysBxkG4pJz4ZyHWMjgzba1lVooWT5M5rRQkVhOpj+5t3BNlaud7xejs2
	 Q2mZE6xIfWU+AT4zSBsfaxKztra0BDLeNaya0wsebwiz5diSXHLMzXTmNCZjsB3oHt
	 ++WbQAt2o9WwEINigA7uQn20yqrEBAXfyEpvnE7UDN5VKyEDgV3RT6A91Yu5u57O8w
	 u4TMFvZdklE8A==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 21 Aug 2024 14:07:16 +0100
Subject: [PATCH 2/2] KVM: arm64: Hide S1PIE registers from userspace when
 disabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240821-kvm-arm64-hide-pie-regs-v1-2-08cb3c79cb57@kernel.org>
References: <20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org>
In-Reply-To: <20240821-kvm-arm64-hide-pie-regs-v1-0-08cb3c79cb57@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=2579; i=broonie@kernel.org;
 h=from:subject:message-id; bh=MuP5Cq46nVjdRD00fJkyIdDWf1YqCyxnb9KmrwxPUec=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmxegTt/16CUX8uktq5Mws9/y16UtY/d/Sra3QZeOV
 uWTrYYGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZsXoEwAKCRAk1otyXVSH0BEMB/
 477h1LbMjJFCyWMayEQuxLp9WrscihPQv91dEogOzcG5/ah1bBLr2yUiwz1sXaUNwMmIDJFzMITGrL
 5rrVG/tu9JHy4L6iEUucBZ07AIX5x7aTHHcIDR2zog/A28TMsMES1zLM3lj2M+iISqPp1u1HABaUJE
 ngVgnnUmgIdZDNJAZvl4+Q7LGVAXgdTFFTwMo7DTB/72c9IJQBVujtXaTahfM5hvpy+mHK7SvRv1ic
 2I4EkR25rKPyKajXGpHTnUlgUpn/ITq2C28XNWB6yDwNQMuH7jYo3Ha8CRAXegO8ZSI8eOkDBNRWUZ
 ZAL1ffEiefDV/3IG4i/0y9F7mKtLlN
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When the guest does not support S1PIE we should not allow any access
to the system registers it adds in order to ensure that we do not create
spurious issues with guest migration. Add a visibility operation for these
registers.

Fixes: 86f9de9db178 ("KVM: arm64: Save/restore PIE registers")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 17 ++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 47675ef13676..38bfa6e10ba5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1476,4 +1476,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_tcr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
 
+#define kvm_has_s1pie(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index aab689ea8992..73daa33a43b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2264,6 +2264,15 @@ static unsigned int tcr2_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int s1pie_visibility(const struct kvm_vcpu *vcpu,
+				     const struct sys_reg_desc *rd)
+{
+	if (kvm_has_s1pie(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2500,8 +2509,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
-	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1 },
-	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1 },
+	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1,
+	  .visibility = s1pie_visibility },
+	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1,
+	  .visibility = s1pie_visibility },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
 	{ SYS_DESC(SYS_LORSA_EL1), trap_loregion },
@@ -4610,7 +4621,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+	if (!kvm_has_s1pie(kvm))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
 

-- 
2.39.2

