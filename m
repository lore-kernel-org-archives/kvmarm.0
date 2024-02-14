Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CBA53800
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916717; cv=none; b=tfWUbMvNdVS4Z7eE4jDuZ4Ca3cC9yC4qj9YmpX4gL/gfaMvVSpzs1EHtczZdfpsV7Se7K3E1Ir3ORPTb7n4e1ujsA0dneC8ezNIM5RaeRlvhwbm/1i7HyHoIuWeHNwGUaBBpYea43ElbzdWnr/LWrj1RyTUii67jJhRo295gDSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916717; c=relaxed/simple;
	bh=me/i8VvbW5YzSr9GKD5k6gAEkthuwdTWsJ1/VjL8978=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gRSeS1nyJw9hPclKuEj/qJV9p9vayzJ7NOuZxYVrWCPb6oTxODqRVBR/ZiWpneK8DsFiKYo8GurIotsONnTGT7Ff8A6hjmmFBzOxqz3V6DREgAWtJ3Wx2jRHFkWyB/2GDeT03jYn06Sk0IhJGvzyNlAu0/UBo3TO0XgOeFZ5gv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7gJYr30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7gJYr30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21A7C43399;
	Wed, 14 Feb 2024 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916716;
	bh=me/i8VvbW5YzSr9GKD5k6gAEkthuwdTWsJ1/VjL8978=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7gJYr30IvwgVsbvEMPMJVBmPKV9eu9J6N1QE3V67r6DeFjwnFAxbSi0vwQwXHXc6
	 VCMHJ002Xcy9FsCTxqT5xGW7Lh+2QBp7IO7+73VYQFD114YAKJtvoVkhVpwJM3dC82
	 yOUjm4kEWI+FeyKU4jkSNv8ZRh8BdA102X78yivj3XNunBOSytCheCrxg4CEUYiAv4
	 LQk/PU/xX5BmrmpgPE9jhgP1ZLvOWSyN7rr4D+4JSPvvFtFXM162rR6mIDRMWwUAq3
	 rZM4uY2GZLkGQBg2TdWZhVniKee05EeCKXC+v+x0ANcO1OBvwzQN9AvCjZWjG1WFV8
	 D9wbFMyDw1sGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9n-00394l-0r;
	Wed, 14 Feb 2024 13:18:35 +0000
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
Subject: [PATCH v4 21/26] KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
Date: Wed, 14 Feb 2024 13:18:22 +0000
Message-Id: <20240214131827.2856277-22-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
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
and set HCR_EL2.TLBIOS in the case the host doesn't have FGT. Note
that in that later case, we cannot efficiently disable TLBI Range
instructions, as this would require to trap all TLBIs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 39e7c7f74717..f07ee7c89822 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3948,6 +3948,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&kvm->arch.config_lock);
 
+	/*
+	 * In the absence of FGT, we cannot independently trap TLBI
+	 * Range instructions. This isn't great, but trapping all
+	 * TLBIs would be far worse. Live with it...
+	 */
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
+
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
 
@@ -3960,6 +3968,32 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
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

