Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63304121B
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954741; cv=none; b=P553brirhzlrjvoeCfLgvKNh0LHC34DEdECSQ8UE/ETEqbixOYY8BJnD0guDBvWTdtv60exT1z1Kwbbwacs9sjUrB65ia04yOEp+hvdXWa9AX5pFdxYZNxS6mj8NFIyzgjrK3qqmn0AqlwqkDr+NaR5zpW+jp4w3ru++6coPuw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954741; c=relaxed/simple;
	bh=KiJ+/0eME2/lUnM/3lPl1YaRW/3imnVqjBt+IRapV0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PyDwVMck49AW7/3VZXKRGaPVbQEYu8fAI5A7eWZWfrIQUItd6eiT7BZkQ/m/57uMmm5Fe0uAZPIY/jmIHYEQPIBqdJaK42EJU5e5Hza18hbIB26M5JkIZiW8xDhHxc+Fw0MXCRz/xHw4nXJnrMZdFQ2gaKsuLWWAi2OlnAjftUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emB2M/8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emB2M/8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFEFC433B1;
	Mon, 22 Jan 2024 20:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954741;
	bh=KiJ+/0eME2/lUnM/3lPl1YaRW/3imnVqjBt+IRapV0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emB2M/8CiDtAgmNcod2qHE2/4ykC5KZdKtLYYOYuW8Gfj1Xt1oOXQ5ZYEvQlz+cDg
	 O3GiMOsng/8ULx0nk4SsqDdkrFhZTYO1yfjiJQ33sjjFOuDGyZdcb0m/tYs1cqd68S
	 XGsPcub71WEKeA+6xq9ne7LaqZcMpDi/+ceE4I/fWEvxCZrwc9/vZxFweLZ2kh3wLy
	 P0AKNoqXI6P0JOEUjMBlqbCqnHv+jU8QnSZsSlgn7U0ROERcKvttWth1r1+aulkLvG
	 EkhDYv/2+dp7wsSQSetvcFT5T/cKLbU6ZBKmV8GbLyDSdJBhkjaCffqiJXi09WarA8
	 ihGV9z9MxMlVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l1-00DjkQ-KG;
	Mon, 22 Jan 2024 20:18:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 21/25] KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
Date: Mon, 22 Jan 2024 20:18:48 +0000
Message-Id: <20240122201852.262057-22-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Outer Shareable and Range TLBI instructions shouldn't be made available
to the guest if they are not advertised. Use FGU to disable those,
and set HCR_EL2.TLBIOS in the case the host doesn't have FGT.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a62efd8a2959..3c939ea4a28f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3949,6 +3949,9 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&kvm->arch.config_lock);
 
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
+
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
 
@@ -3961,6 +3964,32 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
 				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
 
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
+						HFGITR_EL2_TLBIRVALE1OS	|
+						HFGITR_EL2_TLBIRVAAE1OS	|
+						HFGITR_EL2_TLBIRVAE1OS	|
+						HFGITR_EL2_TLBIVAALE1OS	|
+						HFGITR_EL2_TLBIVALE1OS	|
+						HFGITR_EL2_TLBIVAAE1OS	|
+						HFGITR_EL2_TLBIASIDE1OS	|
+						HFGITR_EL2_TLBIVAE1OS	|
+						HFGITR_EL2_TLBIVMALLE1OS);
+
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1	|
+						HFGITR_EL2_TLBIRVALE1	|
+						HFGITR_EL2_TLBIRVAAE1	|
+						HFGITR_EL2_TLBIRVAE1	|
+						HFGITR_EL2_TLBIRVAALE1IS|
+						HFGITR_EL2_TLBIRVALE1IS	|
+						HFGITR_EL2_TLBIRVAAE1IS	|
+						HFGITR_EL2_TLBIRVAE1IS	|
+						HFGITR_EL2_TLBIRVAALE1OS|
+						HFGITR_EL2_TLBIRVALE1OS	|
+						HFGITR_EL2_TLBIRVAAE1OS	|
+						HFGITR_EL2_TLBIRVAE1OS);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2

