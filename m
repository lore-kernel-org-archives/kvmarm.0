Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27F146582
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506360; cv=none; b=tjMO75DPZo8TLKVjhPkjtJCKZFTqBYqRgW7y8GGiXM/YVvU5S4zwiTT+cM5eOjJYTiOSkzPxDyj4sMkW2LwNZbazPEu3NhBDiPptOcqSfnAv6RjZKCmVp1FGQC9RFvQIegizT/mSK1ZUr3ubILmQcXfwNIHF7/cHhnpp+tzuJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506360; c=relaxed/simple;
	bh=G9+RYxAFA/FJOBMWD/iuYRQjJ3+UABCuHbLX2dHhEeo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nJBCXNLWchHkiu3EV9Q7k0N3tVzs25u1ROfu9bkRapKBm9Cng/OWem9iO3NSlDRTm/WT6xZOBkFwXWrKDb9y06FUqtPDWKLHWGV9UjdDqHFfS9RAfK8Y74w67+9XpV/XR5OrnnMFrRGZa3BqLmW7apLWQ/dtwhH1P2KoHPleNFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEUSHHYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEUSHHYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83D7C4AF08;
	Tue,  4 Jun 2024 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717506359;
	bh=G9+RYxAFA/FJOBMWD/iuYRQjJ3+UABCuHbLX2dHhEeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEUSHHYYs3XCTsetJoEv7av+D730xRT1Gnyak/mIy0NA/xCwlFIhDh5wZLnVFXZyR
	 no12BTtjQPRBuN3VwcjrHEtr80dYZXwkfnx4YnFJrU3obXJoG+vP53aCCmqq6L6Zah
	 AKu0NmtUXfSFKfSkFkz+F2JRSoghRBpL34IaX16qv6QJnljeazgrne4nw9DRJ7t+ed
	 vcG+/lBJ55WKhWGoECMJcz19FX6uJtLt1rVmGOgMTJ4f6lTIXNobHpIuZInyfBTtCA
	 TMAFSSDFDNP6Jk4dm/t88ELRqDFfdNzeq+Cgtk/Lt9y88/meYSeet/OboaIjbBH4Lj
	 FcdajbiS5yvVw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sETrR-000ZSS-Je;
	Tue, 04 Jun 2024 14:05:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 1/4] KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
Date: Tue,  4 Jun 2024 14:05:50 +0100
Message-Id: <20240604130553.199981-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240604130553.199981-1-maz@kernel.org>
References: <20240604130553.199981-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We are missing the propagation of CPTR_EL2.{TCPAC,TTA} into
the CPACR format. Make sure we preserve these bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5d55f76254c3..07cf6c64f0d0 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -32,7 +32,7 @@ static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
 
 static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
 {
-	u64 cpacr_el1 = 0;
+	u64 cpacr_el1 = CPACR_ELx_RES1;
 
 	if (cptr_el2 & CPTR_EL2_TTA)
 		cpacr_el1 |= CPACR_ELx_TTA;
@@ -41,6 +41,8 @@ static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
 	if (!(cptr_el2 & CPTR_EL2_TZ))
 		cpacr_el1 |= CPACR_ELx_ZEN;
 
+	cpacr_el1 |= cptr_el2 & (CPTR_EL2_TCPAC | CPTR_EL2_TAM);
+
 	return cpacr_el1;
 }
 
-- 
2.39.2

