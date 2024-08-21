Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442EC16A94F;
	Wed, 21 Aug 2024 23:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724283386; cv=none; b=ZiUgWHfT6iK0YjZM0qYhU5BWnb12i3m7SaQm0o1TeULV8QCM9MPnGTZOEB2yAu9x+Pl8YrL7HBR5cOAQbBLz9upRzWxA75Wgr2X3kmhSZ/etPqRE99iCL8Y+RMFLsEKYr/nfBObEblJ4KHshu1V8ARejPGU9YxxINbAfoqkoe+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724283386; c=relaxed/simple;
	bh=b9JzN3spvWcKQGpRCCgrRJFy7/vr27MdGqrdOp6NEms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MWvkQU5H9qe4klbMjz/pAABvGw0cGNT4f8yOpnl+YljYkRuKm4El0vZm1sQyrkR/vvp42qEnaNRo39uDD8GnGqYMXubCuUbgDE7yN7Shp6YQbxXU7MnrgKQiq/XN80GHGLU/29lh9ZuHaWVzbekjzyu6q/6CwsOTLj1TKwpANgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dq2tt++t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dq2tt++t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF502C32781;
	Wed, 21 Aug 2024 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724283386;
	bh=b9JzN3spvWcKQGpRCCgrRJFy7/vr27MdGqrdOp6NEms=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Dq2tt++tWUppxeQc+fnyL3Jb+OUgXEToC1M4G/g8sM4R/emFtqJP45Ap8BWJIxYR0
	 DcWvsR5C4Bw4nA+OIZV440sH537D9LjvyMEQxnjUvbqg1bkrMNeE3A+MF4Iwh1V3LO
	 niikM4IQHKurNhSf0H97WGMVBC2WfQD6a//yQO0SQ5khGZSqueePLxk1Io61gTP0E+
	 QgTGlp2zm6YXWgUJ9lCNjUFFUoHEJjVF+CdOiueTZwsS1glYacN+quYTYmuWwdSoGB
	 JCQOcH4umwOgPhL+lM7AOrTzcSSClxMdGWUiOJCIaOYYi/lke0H8A70OG6NR1Pp0uw
	 vMgi/oeb8qtyg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 22 Aug 2024 00:35:37 +0100
Subject: [PATCH v2 2/3] KVM: arm64: Hide TCR2_EL1 from userspace when
 disabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240822-kvm-arm64-hide-pie-regs-v2-2-376624fa829c@kernel.org>
References: <20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org>
In-Reply-To: <20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 20240813144738.2048302-1-maz@kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=3081; i=broonie@kernel.org;
 h=from:subject:message-id; bh=b9JzN3spvWcKQGpRCCgrRJFy7/vr27MdGqrdOp6NEms=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmxnnqCSwLUG2jEupZw0pru27MOrYtdiLVk5Ppo6LW
 61ok4LiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZsZ56gAKCRAk1otyXVSH0O7JB/
 4lldS+6iSSLUcMtVy4BnN+HyPylNvRhL2FI795oVu72JrMwQ218IadFn7hHe7Xv2KPgF3A7fdUuYkg
 yB5BtsCRnrpybvmwG+SIxBy8GkvUxBkrSUBqQOPOZKLHtV5GCBbMAtGdhquPaCL1sOBYz2/BXjWOUo
 otuR0T9r5u3luNGXxVjleuyKVDkn+Ibd1caM0mydZEh58I+UN9vCDheNcoDSq7sfWFu0UGsRXxlUHK
 OKHoazQyunC/N1hQ6kRnKTeRHST8uSozu0Rd+xGyPfyke5pjfx7aBz9JaQrk1x8FNpwQqWSb8CE8oK
 9jvT8SYTym5978W6lSJmGDX91jYfHk
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

When the guest does not support FEAT_TCR2 we should not allow any access
to it in order to ensure that we do not create spurious issues with guest
migration. Add a visibility operation for it.

Fixes: fbff56068232 ("KVM: arm64: Save/restore TCR2_EL1")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 29 ++++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ab4c675b491d..7889e5f4009f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1476,4 +1476,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 		(pa + pi + pa3) == 1;					\
 	})
 
+#define kvm_has_tcr2(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1af15140e067..6d5f43781042 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2319,6 +2319,27 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
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
+static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	unsigned int r;
+
+	r = el2_visibility(vcpu, rd);
+	if (r)
+		return r;
+
+	return tcr2_visibility(vcpu, rd);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2503,7 +2524,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
-	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0 },
+	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0,
+	  .visibility = tcr2_visibility },
 
 	PTRAUTH_KEY(APIA),
 	PTRAUTH_KEY(APIB),
@@ -2820,7 +2842,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1),
+	EL2_REG_FILTERED(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1,
+			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
@@ -4626,7 +4649,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
 			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
 
-		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+		if (kvm_has_tcr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 	}
 

-- 
2.39.2

