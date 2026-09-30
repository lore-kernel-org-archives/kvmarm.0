Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C051FCAD;
	Wed, 30 Sep 2026 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804939; cv=none; b=WILXX4PMBzCPEuvKZXRDvbsLBF8qE9bpizaK3kY4vbz4wZdf7Y4YQu617OaNwGKZo79WS7EQrn9Zf/G9cdV+LT+gPr5ADpFwuHTwaUIsxNBggsloBdcVDbfOQaShn67iBD1EhHEm31BFTWnytouBB+6PBLwaKkP50tyTfj1xKAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804939; c=relaxed/simple;
	bh=X1FgS+kMZP9ukBUAVhzrOqr7yryrwOBh9nVXlOvtkDc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c3FCL+bCQtd3bpWyoibI/OYDnT8RrILe2jbVj0L2P6ulUld0ukQAP1191bT9eq6+RL44GY9YYiQj316MrMWymvBVv7BLd0hNXIeT7F9CRmHnVCqyNXTcd268bYTVQzAmJkOmzRN+Ef/eR6wUpOVTe03dYDi6NSAPOmrEZPhsGJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9AZvKsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9AZvKsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BE41F00899;
	Wed, 30 Sep 2026 21:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804937;
	bh=6AoNn9IrRf6+2TK5gl+pKg760w1DAC/vdj1nXqae1ME=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E9AZvKsAKLNfMfxPf9Zy/5oBN2eggb1IM4PHjQv6fNe/uPCOmvKsdE4fZjIK+nSwp
	 VbFtaRYkHSPZsxLmL4sW7Fz739D/vnuraykqz2GebS2jtnZScf8E+6fpNQgSy+CWJN
	 Eb7T+gWoM2Fa8OYpl8/h5q5VPqDmtLkmA31rCd+CHtlFSa3mYvO4h5rPyiBSmi/7R0
	 Nw84k74TePaqhCzj+gp9bZxfSiNG+HvAqQWOug2yoObrmpWjFTO9WUABRgXSKZCjPd
	 BhnvkET0SDdKnAk8eplNTflbcfdbj5uDFNWbycXxpWCSDGbgaFR3QxQf/OsY98PbtA
	 WfLFaATgFc/ag==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:11 +0100
Subject: [PATCH v21 01/15] arm64/gcs: Ensure FGTs for EL1 GCS instructions
 are disabled
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-1-3556644cd927@kernel.org>
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
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1006; i=broonie@kernel.org;
 h=from:subject:message-id; bh=X1FgS+kMZP9ukBUAVhzrOqr7yryrwOBh9nVXlOvtkDc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO07YPOw7wKvBJdXdYYLORf4er5mAip1k2qT
 +5jJaeLhbmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DtAAKCRAk1otyXVSH
 0DwiB/0ec0wcYBdfjSINE9IKRpKNZ9OV/BS1v23AxKqTWwrunVfLuoRMx+jCLv/TY0e5TGlGAyK
 TPE9tF5BcmYAm11arvJ9Ar7BEuSJ089xAiS8uK+GVKmQPzWLJZzs9j56S+PAgswBOanvstwpPYq
 1PtCA/EydqKaGul6afJo6+T3zY+2NFtTEAavaC8Zxe3h169bb86RvEt4PtUs6XKjmyupcHSJkwF
 II6MZlPGOuKaoRQCvSsV7ph/Z+otkwaZ9v5XtgAwSdIUTRCIJOBlMNkvqTMJpqvKeq1rj2CMdH9
 OpE4b8tEmWW+9REjiE4ScnTXWBWEJ3CacDa82zRTB/gNOjVo
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The initial EL2 setup for GCS did not include disabling of EL1 usage of
GCS instructions, also disable these traps.

Fixes: ff5181d8a2a8 ("arm64/gcs: Provide basic EL2 setup to allow GCS usage at EL0 and EL1")
Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index aa8ec9df8024..d308c6e6757d 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -393,6 +393,11 @@
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL1_MASK
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL0_MASK
 
+	/* Disable traps of GCS instructions at EL1 */
+	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK
+
 .Lskip_gce_fgt_\@:
 
 .Lset_fgt_\@:

-- 
2.47.3

