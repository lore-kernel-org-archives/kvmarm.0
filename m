Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A93837B018;
	Mon,  3 Aug 2026 23:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798858; cv=none; b=U7U8b+IZPqO6p+/SoZaR770Eh50mSzVy6rlOzSVgObqAF6WKqxmZoYDi5L6/vbFdAfvCjIWnB+TINuCdNI0IBSI4pANfX2K0B2yIolX5+5Q/J+S0JBQsCX2FD1/vdq2DqIuHLt9v5i3vz1M6tO861zB7K1oYJ6kl0aiOucRxPKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798858; c=relaxed/simple;
	bh=dGLgMnL9rflDIiQQE2mOvvL9pjSbxiXR3AQhq+zRFdw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q7AJpe5R3V6LIFGdRAdwRnSUu2mQUU/XKdajM9+16AOHWAmeZHpvOPG38qWF4AQNizHcHSjlrLafYuhNo3Sam0aTjh6xm+fu2hl+fq2Ub7FEveMcydUOffCFHcHsS3+fHO7o+jiZDqBexkOcY5yQ+wEDtv8cFHL0WABpk7gWPJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAUzCKQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAUzCKQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C8D1F00A3F;
	Mon,  3 Aug 2026 23:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798853;
	bh=7mM87d/BoLbN1zST8PJ6yEoztt2FRLeT4zLZWlzYzGU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GAUzCKQjZ5MZGK/l0iGJgyz/COLP5hl7OLokCPCjZje6VV26oRlQNKiauP9IlDft4
	 5t5zdvYReDngCQMXm1t1eNkjYTUQBOS75/4y04/rPlrTh8qHDMokrkBx780Wb8kuV6
	 hUNHGB/ZfUlosla48JLUzboGnST7g7Sxs1EV2iNZetCfS5nfGHW79VS5pMeT6XoMb/
	 CEcXQK0JcLSuFk7mYkNNKTJSRDBYXO4donlFKe0e4AZRPYFnKXCTFjz5+Xe1ishRj+
	 y/EYZt8CnpcNK+NLGoWx45gX/vxLaXqNQvidut1isr2gBs2bsUDR3Dq+cpFNkqhpNH
	 6n5wcnc+bmqng==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:54 +0100
Subject: [PATCH v18 09/14] KVM: arm64: Allow GCS to be enabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-9-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1947; i=broonie@kernel.org;
 h=from:subject:message-id; bh=dGLgMnL9rflDIiQQE2mOvvL9pjSbxiXR3AQhq+zRFdw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCgVvZNHyYxP4KJ4G+VRTHyOsbEWGi733jeZ
 tApPHusGYiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgoAAKCRAk1otyXVSH
 0BIXB/4g8Ff7bixNT03EVmFn3AcdNaHHjiNBBBkQDDwNvAYtlNyOWyhdqt/mfXOt2qrjx/pIqiT
 DFtC/GRGSIdQaAIwu7Ye9O+mYYb7rM09du+nqaJz7milCp0tRJK02XzHzXgn7rJzq1/VnTG/bxr
 nKICnMHW88MKZnUb1R7CKcYQ/aB+CoS0fZO0YNNW0zbadzcM4mlrxdbE1NHPmXpg8Z0MAPdaj9E
 Th0al2S1FF7yqJSk1TpOgFc7WbNq5+tpqdz9aSETTyqAG8a9ZOATjnDpxQ7VBDnQ5Nj+zb2Qzai
 DKYI/VbhUcPfc+vwAoek1veecPrthAh8398wF7N0GWwPnWaT
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Now that required functionality for GCS is in place expose
ID_AA64PFR1_EL1.GCS, allowing guests to be given the feature.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/nested.c   | 3 +--
 arch/arm64/kvm/sys_regs.c | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43..e588820b1be7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1632,11 +1632,10 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR1_EL1:
-		/* Only support BTI, SSBS, CSV2_frac */
+		/* Only support GCS, BTI, SSBS, CSV2_frac */
 		val &= ~(ID_AA64PFR1_EL1_PFAR		|
 			 ID_AA64PFR1_EL1_MTEX		|
 			 ID_AA64PFR1_EL1_THE		|
-			 ID_AA64PFR1_EL1_GCS		|
 			 ID_AA64PFR1_EL1_MTE_frac	|
 			 ID_AA64PFR1_EL1_NMI		|
 			 ID_AA64PFR1_EL1_SME		|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 387c14a33524..7105f42a63ae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2109,10 +2109,12 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
 	      SYS_FIELD_GET(ID_AA64PFR0_EL1, RAS, pfr0) == ID_AA64PFR0_EL1_RAS_IMP))
 		val &= ~ID_AA64PFR1_EL1_RAS_frac;
 
+	if (!system_supports_gcs())
+		val &= ~ID_AA64PFR1_EL1_GCS;
+
 	val &= ~ID_AA64PFR1_EL1_SME;
 	val &= ~ID_AA64PFR1_EL1_RNDR_trap;
 	val &= ~ID_AA64PFR1_EL1_NMI;
-	val &= ~ID_AA64PFR1_EL1_GCS;
 	val &= ~ID_AA64PFR1_EL1_THE;
 	val &= ~ID_AA64PFR1_EL1_MTEX;
 	val &= ~ID_AA64PFR1_EL1_PFAR;
@@ -3350,7 +3352,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				     ~(ID_AA64PFR1_EL1_PFAR |
 				       ID_AA64PFR1_EL1_MTEX |
 				       ID_AA64PFR1_EL1_THE |
-				       ID_AA64PFR1_EL1_GCS |
 				       ID_AA64PFR1_EL1_MTE_frac |
 				       ID_AA64PFR1_EL1_NMI |
 				       ID_AA64PFR1_EL1_RNDR_trap |

-- 
2.47.3

