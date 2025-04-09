Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261CB1D5160
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214483; cv=none; b=PImFcrpjcQojAugNGg2vPIwfAsyZfzT3maZDHqAkY+JS2j8LVeBmHOkfqsOER5wZjo3e3umGhvWdHrAZazRST/JXoU7Az3Lwzjxquz1vqExzJiFMyB8h6WGtSh/JHU2Ax7cdQsLyxVDfkR5iir8hIBdOjHZHMb7qiYLyz8dEzpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214483; c=relaxed/simple;
	bh=8mEdxvOC5T+jehc1hdND2pdEUIdwpcqKS0/iY/34BZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XYarP2Yj/L9zjFA94gRg1rXVn5sSVj1oRRh7akxqJ81AMP0SUSDOKqbEHtBuxpaIdWLhoBWNfrh01TJ7lPkz8VEWEL7cfutgxOlXPRPOh8cuU03as/DKC+uqv4+dByHeykGtMVhk+x8KZrpTBC8r1XBB4ERNkkZMHs3I//ySBcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tbWfuTFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tbWfuTFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B9AC4CEE8;
	Wed,  9 Apr 2025 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214483;
	bh=8mEdxvOC5T+jehc1hdND2pdEUIdwpcqKS0/iY/34BZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbWfuTFT99xv6dy2IOfih3K2bOu/CSuaV96aTfpFZU+bGshZwqU7pu76gXrmO4RXH
	 bQslf8dJbkbNzI9vaOVfz0SZMZNnsPRxLl1MAFuVmaPa+Rq/X30aTX+BEAV/qLnLhc
	 NfMTFQpGOZG4RgogeABhJfRhP57nKI5qyxfpLklyAOjFcuoRVU2rzsckUbHa000nOy
	 W5HNCJVjgt/BINfJWk4rjh71LHTv/UzJJTUAMgtUpzUmRRX81YMF2sQxtIa1ir6FpL
	 xT1EKtTj0vbhtnRHY7yi/12sGr2EY/ZDgT9H1gr93z5O69+XCGug3PYj/e52JcekvH
	 uawdQb6y7/biA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u2Xrd-003vQT-15;
	Wed, 09 Apr 2025 17:01:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 5/6] KVM: arm64: Handle out-of-bound write to HDCR_EL2.HPMN
Date: Wed,  9 Apr 2025 17:01:05 +0100
Message-Id: <20250409160106.6445-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250409160106.6445-1-maz@kernel.org>
References: <20250409160106.6445-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We don't really pay attention to what gets written to MDCR_EL2.HPMN,
and funky guests could play ugly games on us.

Restrict what gets written there, and limit the number of counters
to what the PMU is allowed to have.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 00b5396492d51..e53b8f82ca7f8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2571,17 +2571,33 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
-	u64 old = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	if (!p->is_write) {
+		p->regval = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	} else {
+		u64 hpmn = FIELD_GET(MDCR_EL2_HPMN, p->regval);
+		u64 old = __vcpu_sys_reg(vcpu, MDCR_EL2);
+		u64 val = p->regval;
 
-	if (!access_rw(vcpu, p, r))
-		return false;
+		/*
+		 * If HPMN is out of bounds, limit it to what we actually
+		 * support. This matches the UNKNOWN definition of the field
+		 * in that case, and keeps the emulation simple. Sort of.
+		 */
+		if (hpmn > vcpu->kvm->arch.pmcr_n) {
+			hpmn = vcpu->kvm->arch.pmcr_n;
+			u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
+		}
 
-	/*
-	 * Request a reload of the PMU to enable/disable the counters affected
-	 * by HPME.
-	 */
-	if ((old ^ __vcpu_sys_reg(vcpu, MDCR_EL2)) & MDCR_EL2_HPME)
-		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+		vcpu_write_sys_reg(vcpu, val, r->reg);
+
+		/*
+		 * Request a reload of the PMU to enable/disable the
+		 * counters affected by HPME.
+		 */
+
+		if ((old ^ __vcpu_sys_reg(vcpu, MDCR_EL2)) & MDCR_EL2_HPME)
+			kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+	}
 
 	return true;
 }
-- 
2.39.2

