Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02670367B61;
	Wed, 12 Aug 2026 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562026; cv=none; b=pz3mhHeFaa0qako4jxoZMWMTHiztNWQDSf3Gw9AjsykQitxJOB6FCczRfDsB0Ed8I5Q7KhqHRxHEeMTcMS37/rP0eBUJTi1+P2lG6HySnPUPmFlpgcqeiqHvPejg78czzathzH7nR8i9ipzMk6uDn2jOCxL/SGPoSRyf4JKUxjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562026; c=relaxed/simple;
	bh=wSi/99XjArN++UhPE9NaBrT+6u8rBmN9KqmNIxOU7XE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E84UqivgZ62jxWSltQYn98Ezvxu1g/Zy/jqENSrFDgxl/YAmVWDhs6p8+NIiLUpKLjckvZzVHkzwZH69zXBjJsgovJJUtaLvahmkh2IockSsh2X1Sh/LqDFwumoEp0vInbCZDWVwvvUikGAiwtTxOtTyAj/OCgb6r2T1m1gyQgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IiFfxikp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IiFfxikp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F511F000E9;
	Wed, 12 Aug 2026 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562024;
	bh=y86oK2zYrdgU0xxao6mL6Zr3fu/XTvCfKrGB9e9fDHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IiFfxikpCt6ALpFfbMbdJZCa5CI05OxY1thjIqppQKEiSzuEdjb6OrlIJ6rG/YrNE
	 Izfiyl5g06OzVmFAmbg47/lwJ8u9G3795YyGmtrXD8pi4aKw4b9FIsSgJQA8BcnH3z
	 yHLJct5GhFwyNt6dKk5qiFEpCGns5Lwzdfwc9F2WFHZDQE1IJrZR82DUwxYSzkHYlD
	 41WhemgZGSAS+1GwQ8raMAsK0G4D6UZLKYP195bdSUu6m832oBL1M0y4C5AwIe6t1Q
	 qs1WhGxkPPWppxeSqD0vvV6g9Du71YH98Kvqvyq1Ug3hBXKxrTfoK5clc3UWv1OwQK
	 BoDbXW+vMWT4w==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:08 +0100
Subject: [PATCH v19 09/14] KVM: arm64: Allow GCS to be enabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-9-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1947; i=broonie@kernel.org;
 h=from:subject:message-id; bh=wSi/99XjArN++UhPE9NaBrT+6u8rBmN9KqmNIxOU7XE=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhqyaowdZm51VxftY1otdalLYpJWtPeOf9er3Qj6aPK/15
 zhOT+nvZDRmYWDkYpAVU2RZ+yxjVXq4xNb5j+a/ghnEygQyhYGLUwAm0lDJ/j+2V+WFek/TlelL
 As4eDOldxL1vx6nOo/dELqa7zWqeX/zjdUDDDD0rCetvtpEn2Xr4dEJmaj6pfnysvyZ5cwKzSEe
 ZlcZb1c9y0n9mn7j03y1NKdVc2lZ/n6vOuxeFRzTUPylGP+kxVpziovkvu3DnwjLGBnGHZVY+RU
 XpF3/keFqE6F760le9RDmw/lo6ozqDtRLjx0UsQS+tWle2z5X5Yqq85lnz78dbcuSmLForNGX7F
 +O6Z6Yse/fOX1rPujdKYmKNU/blf8sPqn853CQik6JUph//6+nnn7H+TLzhO3cLfZgod7zh2Fkx
 z/TdkkGi573F9G2NL/0PqnofXV1cY7tWM23FkX8Weh87AA==
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
index bd1d5b778b9c..5630c3987926 100644
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

