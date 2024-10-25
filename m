Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5875D214416
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880670; cv=none; b=TGMeSPSxxLQfImgcXT+ymz1irD6Cp2rs7PCsgHWhbeJ79tO3yMZYsdN5gQU/pMXtRZWeBgycNGKqiAeLC/HYeGaVCRxre3Cj9INp6JrX+1m34kd/yn7Z3SCKnU/+6RkrIK6oWqNT/us35I+MxlndtwtQSoWhZQwZrO8yTV5tYoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880670; c=relaxed/simple;
	bh=WnSYByWaIFbInwg4nT4ofApbDtPsbrFsPtiK9NnqSqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+ndcJX6Vx2z3SlLOYair0pOAInXyFqIGM4Mk98e67e/0AEjlgiaRUD3HTMEfJ7NwQ8WxX6ZAZ6Db3Buu2KC08hOmXC6xIWfm77GXG+anDDrAfpzedeH/SwpNVZfTX9JWvSMm1Ow2pf8rhI82hwOakIttgCQCrnUnUafK1lO46o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jSZuZMk5; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jSZuZMk5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WjjCMEH326B4LIDtFwwuu6AngDXjHoyjb9Jg0/u5tag=;
	b=jSZuZMk5cy4cNE8GXAQNT/7vHsZAh7Dm7WBue7XiC5Q1fMP5x9QZoGdUFmWvcnEJD1WfzC
	jPKx4TBmEhEr8J0ktcwf1DZM+rqXuj8j6sjWP9T29K8OJ7FqbZFWmR1RKfkiNOWgjhuYh7
	l1PGly1+mmLdAZrKdvlfVV5H8gDfuyU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 09/18] KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
Date: Fri, 25 Oct 2024 18:23:44 +0000
Message-ID: <20241025182354.3364124-10-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

TPM and TPMCR trap bits also affect Host EL0. How fun.

Mark these two trap bits as such and take advantage of the new
infrastructure for dealing w/ EL0 traps.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index db3149379a4d..f9594296d69c 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -304,13 +304,15 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPMCR,
 		.mask		= MDCR_EL2_TPMCR,
-		.behaviour	= BEHAVE_FORWARD_RW,
+		.behaviour	= BEHAVE_FORWARD_RW |
+				  BEHAVE_IN_HOST_EL0,
 	},
 	[CGT_MDCR_TPM] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPM,
 		.mask		= MDCR_EL2_TPM,
-		.behaviour	= BEHAVE_FORWARD_RW,
+		.behaviour	= BEHAVE_FORWARD_RW |
+				  BEHAVE_IN_HOST_EL0,
 	},
 	[CGT_MDCR_TDE] = {
 		.index		= MDCR_EL2,
-- 
2.47.0.163.g1226f6d8fa-goog

