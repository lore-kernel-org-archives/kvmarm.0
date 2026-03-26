Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C1405ADA;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539337; cv=none; b=JmLGzMgGwjfW4cYWR4b1m7R9Ryxq4WYPSGe4BHxPLboFyvYIE9i7MCewRMYcJM/M+245s4UXKUEHE4MH6A2njnRI/7WBVhcS7JrbdkmsSrZAYwI8VSmUbmpF5tcJmZco5UQd+VbAgZZZHJwVR0e6hQu/cuMJghM2O5AIOxBdeC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539337; c=relaxed/simple;
	bh=CIJ73nQF0T1lAkqi3KJjDOMxDw1M8UCTUrlvRdpOz1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukrVN0nu79tbtkSHo1qTn219HP39JvTk3wjT9BTklDoYS4q/jntyNqsIH3EYtFY10WUeIhMas0bZDjV4eaCFWP4Tl7LXGb1vvC28IqvMJBaOtaxMx52VQOHUO02DMiqD80c1yAeMAbCCWSyUxPHJAEyPfhGGgX3z1EsARdsSW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6+I9rqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6+I9rqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D27FC19424;
	Thu, 26 Mar 2026 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539337;
	bh=CIJ73nQF0T1lAkqi3KJjDOMxDw1M8UCTUrlvRdpOz1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6+I9rqZphnlbVX/77B6x8RKvZBVgAxsJXKGP+uMYxRRWecLXO4zXOq9N8y+TtMt7
	 zbanrkahe/euqPveNPagmg3JKlZ7SuZoZeckCPS7o35l45Y77JaUskTtnZ1rZz/XfC
	 275FEQcIORlct6WlgLPsUc2b/PKC11oEMlp+kbt5ZJtJGb0LxE297Gvcw7A3qE1MTZ
	 ZExMY6cgo8E+rla1wjgssaeOWJt0n+NaA4SdPvBYuDxYiSruFJvTy5E+QAOJ/FMNwA
	 3uDPUTrvXLKe0TczC2kijrtM/r/LAD/9bsI9jR3lDyJibn5IWcBp7qGC5dvXy+5Rk6
	 OFw4Pwy9CVseA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkB-000000060II-0GHC;
	Thu, 26 Mar 2026 15:35:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 04/15] KVM: arm64: Fix writeable mask for ID_AA64PFR2_EL1
Date: Thu, 26 Mar 2026 15:35:19 +0000
Message-ID: <20260326153530.3981879-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The writeable mask for fields in ID_AA64PFR2_EL1 has been accidentally
inverted, which isn't a very good idea.

Restore the expected polarity.

Fixes: a258a383b9177 ("KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 18e2d2fccedb8..6a96cb7ba9a3c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3304,10 +3304,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
 	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
-		    ~(ID_AA64PFR2_EL1_FPMR |
-		      ID_AA64PFR2_EL1_MTEFAR |
-		      ID_AA64PFR2_EL1_MTESTOREONLY |
-		      ID_AA64PFR2_EL1_GCIE)),
+		    (ID_AA64PFR2_EL1_FPMR		|
+		     ID_AA64PFR2_EL1_MTEFAR		|
+		     ID_AA64PFR2_EL1_MTESTOREONLY	|
+		     ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
-- 
2.47.3

