Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4000119ABA7;
	Wed, 21 Aug 2024 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724246044; cv=none; b=WFgfAgX5ePIrhOZgs+1WASmeLAnb3DRJUUPnOqnxXjGG0E5kNNOkGzQeoyJQualDIIJM/gH4Dgb86/b+spgQvK6pvMfIvU3OEDNmGSg40p4bpJ8uwFGlF7YrqmUMG0syi7JzlfKXQAk8stDw4qSWUcxT4f2iZenvLtpeDpP2YZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724246044; c=relaxed/simple;
	bh=M3wnl3jeTEg6L1w31RHY/MPoAWBin2H0UAgATL+YXoE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aZlz6fkrf1zm59uk6ARgF5qYjtKDwG0mi/oE8EJL/E/2sARz8v+DDS1rezfZIB3jQDI98TtI3yswkCp9GWXMuADvHaJGOSJkZXb/rrIH5SWMMdCMXQr3nHweB37Yzr36zZnLfote0hNR15n90wOp2jPj3tP7bKTOYlox2ywT6fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=firFY7yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="firFY7yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B25C4AF0E;
	Wed, 21 Aug 2024 13:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724246043;
	bh=M3wnl3jeTEg6L1w31RHY/MPoAWBin2H0UAgATL+YXoE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=firFY7yb7+k7SGiD0Ub994Yzx9o1Q11JayR9UgvsL/iGO4SDxQg9hqKVLswu4+J5a
	 whAgqr2eQ6FEMijDVgn7SyP6Fbw3+dpEmqAujNZSbawMwUqDoB48i4NY/7wKkZXp45
	 FqCRPsLaBvMWTJKAn2NnNJ3QgTcOewmBJ1xE6sw7Or+/0LuNMl/Jc90oyChoTmyp78
	 IubGuhQlVMxuaBcforpPgsSsx3dan0IazpmpP6tFiLCRHVqP1w0IYgK5qiZOYIflvK
	 n1XTQ8qRgpDn2SlAHZMSATuewB1k9ICUocsgcOII+UbStHjhQqZDRPu3Ajrn6SmnmN
	 XpceiD2h52CkA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 21 Aug 2024 14:07:15 +0100
Subject: [PATCH 1/2] KVM: arm64: Hide TCR2_EL1 from userspace when disabled
 for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240821-kvm-arm64-hide-pie-regs-v1-1-08cb3c79cb57@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2343; i=broonie@kernel.org;
 h=from:subject:message-id; bh=M3wnl3jeTEg6L1w31RHY/MPoAWBin2H0UAgATL+YXoE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmxegSl4TBd1DBRROnEjY3E/Ss1czRmyPxJkdzee5u
 mpahOMiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZsXoEgAKCRAk1otyXVSH0HXIB/
 94XRxZnxjGI4jLo8qddjEBeQa4tzBEc0DhyJSLV34BmzxlngzGpW3xupdzqNtLJIg4ywynbsmdeAhz
 4JXM6f5zRV2RpIdFLH+Emermg0IKeilTP5uGm+SJYAtxG20iVIyrn0SlffDiuR9F1Y4uAIVb7+6Ywx
 39jbfYWknUXpAChT3rKFC07mz+HyWB2zkraGtmyrO6irv/sPF64RD/eg60QHguUgRUb6/xSRaHdE2k
 Fz56JpZIbbtL8yjhF6hEsKx8SUThkreUX07bgJpcDl+Sg9QaRokL9l/HINnbODRXHgfZDU1FI5jGMN
 oMV2xflGm7czJpYPdMJwvNUxg7kXVA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When the guest does not support FEAT_TCR2 we should not allow any access
to it in order to ensure that we do not create spurious issues with guest
migration. Add a visibility operation for it.

Fixes: fbff56068232 ("KVM: arm64: Save/restore TCR2_EL1")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 14 ++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..47675ef13676 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1473,4 +1473,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 		(pa + pi + pa3) == 1;					\
 	})
 
+#define kvm_has_tcr2(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..aab689ea8992 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2255,6 +2255,15 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static unsigned int tcr2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	if (kvm_has_tcr2(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2438,7 +2447,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
-	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0 },
+	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0,
+	  .visibility = tcr2_visibility },
 
 	PTRAUTH_KEY(APIA),
 	PTRAUTH_KEY(APIB),
@@ -4558,7 +4568,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
 			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
 
-		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+		if (kvm_has_tcr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 	}
 

-- 
2.39.2

