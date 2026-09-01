Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785B837C0F6;
	Tue,  1 Sep 2026 21:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299477; cv=none; b=QMzO+pC2f9NKM96d5yaWThK6d3J6Tr7abadAvyKiPpFA40PIvpZq4fcUVnVbkG2VNtmxzumCG64sbgtiwzA335TGguILFhKajC9eGuIA2i2j4pVi2eL9oJKaz5qmMyYwuuetqpAxri1B7bzofFxGVhqYR+8AhKES+WBR6ISD5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299477; c=relaxed/simple;
	bh=d3SxEv6RjSY+xiyxMK7Zi+tIruIS+RbgPdYjX8k0TSU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G+XI6MY2X0QeBQ+doZSIkxsb37hZ23JPIOMbj4fZxa+vCEdK9dER1aiRMheHqIBNEwMzEJciS1PODDakaE9VoMme72KmIHCsrgfTpPxIjvtpT2eU+CbB+JEuiE9ABsou+FyxWEWywKWXqzcRFYC+hmi7hlyC/0Ku18mQnJ659yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oh6qO9xX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oh6qO9xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4731F00A3D;
	Tue,  1 Sep 2026 21:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788299476;
	bh=kyh12vLSEfb1JF7lQC/qy5BquW9r8pj96hLZDvx4BW8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Oh6qO9xXikF9ABcqX1Z6Wzetl7Pw09t7uf8Vr2MXZc877Vch84HUh07Q6yDBzmmXx
	 hdnSLHQ4KSVxn+PLMCEsa+XJ+cfAp4vxVHhWzdJxuuTZfmZ9RoHcqOGrcPPrc2pPPP
	 ugXd/r4P6RDyrhiNdHzvjK+c6ujSGvNXtyVSrfgMckaq/7MMaqp53JzRVlEneZnQed
	 sAtpLuqsILLNScAd5Vu18YUVPq15sKBTLma/fp4MrMg7j4CwgswbLLOGu0vENLdz4z
	 lBmmCPPCZIFxCn1lNqs+aclZLw28lh7zXShd6DGrVFZ3VgPCxjRNtrZIRuGQvQT0MA
	 sxSWW8Wlkm2AQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 22:47:09 +0100
Subject: [PATCH v20 11/14] KVM: selftests: arm64: Add GCS to set_id_regs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-arm64-gcs-v20-11-f31750bdfadb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=987; i=broonie@kernel.org;
 h=from:subject:message-id; bh=d3SxEv6RjSY+xiyxMK7Zi+tIruIS+RbgPdYjX8k0TSU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBql0ile6y9IO6whC6xpi+oS4hBxrk51YhD+JwGo
 bxQJVnl5W+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapdIpQAKCRAk1otyXVSH
 0KhKB/97CmnH6U9bJtP2Mm28nFOfYooeNFvRGvFyuo5tp3UZest+BV+9oPUvc0BIX6un3pRpFd3
 VfPIcW0YCn6rulXH3lKsQctM4zDKNEodrdn2KM015lmcrdS5U1u+gcqN3xP6LuwxxZAdUGaalyC
 lIW9GB5nOV2DiujzdzxkmhjThpX+8rrwbJtZmpEjlZH8O+ltbMmOyOn7NcGuedzaA49vYvviBkW
 PDhHqTGLgGZbzpKtTgOxFCKX+TAPkq2ptxIbD7QEZDfKF9NFi4ea8QJtYeNG3bU+wYTBi2rsl/f
 hsjb/FP8n87EAAW+92sGNqZpeeUCQvB0g/FzhIKxNyo9Z+T2
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Now that GCS is configurable via the ID registers update set_id_regs to
cover ID_AA64PFR1_EL1.GCS.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df5..34e59fbbbe89 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -154,6 +154,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 
 static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, GCS, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),

-- 
2.47.3

