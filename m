Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1083053160C;
	Wed, 30 Sep 2026 21:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804969; cv=none; b=U/nv5z0hlUEZKFlrUtBBIQCZt2Aqyf8DITpj+d4gHZi+VG6bMBcyqai77G5wGVtgpr28foHbvn+1GRLYnKFnMG2ZsS49qF5lvGNrShgZ0V73PYOq1R/n6debZnGFP1SO7KY3MMrmBQF8/GjSX1kAdrbFGypjR5dMuP6Wttbtcvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804969; c=relaxed/simple;
	bh=cxKp4O4LsyzanVWYD2N6RiRBPKov/JqWLVenhRBtLog=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pTi3BcDfgDLUaOHZJsWWR6kBXPogQB8A6n9fr+ULf35YkYF1tYZtwY/MRGEm8ON7ydYYNPmM+1B3W0q/Nnch0wmHIQuNWPdTq2G9rcyJEBmxJmvEnITCwnoQ64mg54VxGM3NKrNznD3JZFXHbZ/zuzUjDXZax5xFXNx134xkLBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dx0DIGYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dx0DIGYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682BE1F0089C;
	Wed, 30 Sep 2026 21:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804967;
	bh=Xaz3/wrMiOTvQ7QsDHrniOTAXkJk6SVO21zvEdLnW0w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Dx0DIGYHPOdAtusPWS4FBsCBp6nY9oJ88O/CumZSKDpPF6NEhxcvtyRyN3LKoGEii
	 69myaNErotNg/Bm3bc0mVoosPIXtQb1nVlf09Y5dDceBbdAp4K6zm5pQ4MeQBezf7q
	 KvWFjvP7xUbAZ6WrDYlKdz1toLMcAuIoee7dUi9mOXOriWeP1TdYQ2XoUeZsBn5MxD
	 Qb1Qu+E87xD3yFg4or2Ttn8FeuWVCpXRDQrShhVZzmYgn6I/5KKd/T83dWqIUMKio9
	 L3hhtHxztxbHnnFWUbp9gfuMKFsI71yGvvl6yl04OVNQyqSlas/Q1EgHqHFsDX2Bpe
	 va8eYv6lmV4yg==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:19 +0100
Subject: [PATCH v21 09/15] KVM: arm64: Allow GCS to be enabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-9-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1994; i=broonie@kernel.org;
 h=from:subject:message-id; bh=cxKp4O4LsyzanVWYD2N6RiRBPKov/JqWLVenhRBtLog=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO63IkXqiM/IhBYdRfO72ei7V5hYPpACCZEa
 fR+7tMCUmuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DugAKCRAk1otyXVSH
 0CfMB/9rJWt2FEC2Wgl6uPd/R/OwAnUa9YAFAEzvxGfIpus/WSp7NVVDOIpRPLbxlYT3No3biSp
 A7pbNnOkQ6EyOZkvkGWeDcG4LPsWobB8uIHQRNEllwcMqRHvwRczEPouhH0dv+VwRwf26XhBmj8
 nn9+3wFsL5PyUqtTDhvji/YRAXCBEGfc7J18UC9m1mHdcBiLUbA/MQzr1EWu1rXDs1TfF7p+8HV
 5Rv1oqAsVnC06TzHg75xh0few7IZxo1+PaxoQXkx0+M0gPDnof1+/k8JTDHs5Hf8qRTrmruKgTJ
 p9NXWzdxHSjPDkGrXoYkZlFxGo8gfWGUKJR6soO/iM3WKTvr
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Now that required functionality for GCS is in place expose
ID_AA64PFR1_EL1.GCS, allowing guests to be given the feature.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/nested.c   | 3 +--
 arch/arm64/kvm/sys_regs.c | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 3c4fc566eafc..f62d9ab7f31c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1702,11 +1702,10 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
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
index faecf4657ec5..5de4ba1bef6b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2193,10 +2193,12 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
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
@@ -3444,7 +3446,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				     ~(ID_AA64PFR1_EL1_PFAR |
 				       ID_AA64PFR1_EL1_MTEX |
 				       ID_AA64PFR1_EL1_THE |
-				       ID_AA64PFR1_EL1_GCS |
 				       ID_AA64PFR1_EL1_MTE_frac |
 				       ID_AA64PFR1_EL1_NMI |
 				       ID_AA64PFR1_EL1_RNDR_trap |

-- 
2.47.3

