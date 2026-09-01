Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B2036CDE8;
	Tue,  1 Sep 2026 21:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299471; cv=none; b=XR6y2Jkn+/7ZhG5qweGmxOl4rwWX2FTrZ4EpWeHCMjEXeh9X/9zv5swoN4VF+fVO8guYlwh+sgbKUFTEfylUQVDHOcElw/wNcCCDW0V43FDV9yc47QVc6RtLv5B5u3jXZb/+t6GSOeZCkUw1BPue0qoiLOY03QnhsItpserZNYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299471; c=relaxed/simple;
	bh=sVwijteYWmwsPHrOhzgNw/h8bxNw24CK78k3J1PaD0o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SC09gLC6K8N3y8S7UUB655dYN9BQyCPWGtAXmsypVlHbUq2WR0Bfzlqsqr7xdmk2CfvRsgKCBtSrm4I7ofsdzwWmvzoXx0KaLWGGUWBWXjmwAcWVtnDeZr9LsV6IUalOxknvTo/c5tXJ7PRKKasYVRmpV+U9u0yiYKebu48u2ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFMG19SV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFMG19SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72931F00A3A;
	Tue,  1 Sep 2026 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788299468;
	bh=Ntvmp5tAW0Lnf6CadWCmQQjHOUTBR9lOMJLkhDreaUU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eFMG19SV03NMaVFnpDeSPY1ZW0q60Rl/wv6m5fW5GccSqDsqXGLKo2cVdLqGYjKmX
	 p0PPrUrnmkrdxpzW78Tx2nj3Ee7JvbVekHcEuPZHGqao4szXnvpxgjfaAFU209UrE7
	 PK/uZ5rmth1UPLXcKdNZgLndOdtKWy6wYC3OAfbg1KSORa2k/LngOEvNrfIRPm8Cgk
	 AOpiItwOxoha4tNdBzIWI+WZ/FsaQ/zq5tf2vENHHkCaiT8MX0raEv/BV/nZLod8b0
	 D1ngQr5DVsDG6gnGzRJOsy0gGJgQ0Ze0A+/W13sJlFiguCXRrByb3CDnWpUbN/RqB8
	 6Pw3XWBEY+EHg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 22:47:07 +0100
Subject: [PATCH v20 09/14] KVM: arm64: Allow GCS to be enabled for guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-arm64-gcs-v20-9-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1947; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sVwijteYWmwsPHrOhzgNw/h8bxNw24CK78k3J1PaD0o=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBql0ijTOOgU+g5ib2qdw5i9m5Up1vp0bgOidFbt
 N7sgbGHYNeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapdIowAKCRAk1otyXVSH
 0D71B/9cf0Tr9O/jvhvol2aAHSpSGqkbgy5qn1+oWqbQ4Gr2Q8DUJj38IvXWXLZVU8+mD9f0BzI
 RtT9nnduQBP9zjkO0Xxjf2lFL5sbJ63eu12X6ZfULwyCASUzTxOB4VRzEGLcvtshRdpMuT6+biJ
 3m+VMjNbqpucJqLCszqSimSggsuxOQfPGRjG9j1VGfpSH4onTKf/XLJBhSIhv7+UeD7YAm1WwaT
 LMWdOt2tkZHP1u003Em5G86ogV5SkGYzZgZwwboiYBQYJGxdKle9Jw2XVPL+9Tp1+Y8hJkR7nZi
 6UsaFzTADQQoNB+2II6Dyf4v8uTDYWTiy9eotFc+bsA97CDa
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
index 17123f0b6dab..a9dea85b6192 100644
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
index 1f80c26a9839..fb2c9fd42e24 100644
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

