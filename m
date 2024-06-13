Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3A313BACC
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 20:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309935; cv=none; b=Q6kq7mf+DkY3c3a/hqPK8vzQFtfYzSVVdnea1mYSqADuwXXya2bMbXJ/6ABfNShW9EgITjYK9jWk9SKxTh1nRFHARp4boklj3+qI3y3wKZ26EptW60oDHaU5+43XG/rPskTyOn44twv/Y6GUCB8AGGs+Sv8i7S7SEuRWLcSnC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309935; c=relaxed/simple;
	bh=ihFaMi6WQNgH48l13IynStPbXs/LWIw3NN6DqhY75xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmIsiyg+JmRkOilY+xFqof4AC8QuGkwCK9eJ0pbM9H0KCyZgIRpmINzYLbvGlPSua4Ot6C3+PckuqXTESEoOjnaGjPGs9hm1WGAHV7v36ddLZfop0s5jzCwzEMiQFa8ecj83mV6nZgPRkRPfVCMVjOdqpIEai2AzgeOTRBZKC4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J+QOKHCi; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J+QOKHCi"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9IAEsEALUp8gmASGuBU+lym9PJaTuQFivahYfUQddw8=;
	b=J+QOKHCikHMWBQZKAsPktNZCuOJ/HiXlTXbSqtSM5mynq+R481KHB+j2X2vDIvvwAn1pfO
	q4wlp8vl+e9k6l6mS+064DjRiVAAtgrCTCaC5iRJvDh/5C9BSP1vhBAW4v6gzRuoh7zcAP
	h1TTceYpVlxkeMuSe5RY0rzU/jESvTs=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 12/15] KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
Date: Thu, 13 Jun 2024 20:17:53 +0000
Message-ID: <20240613201756.3258227-13-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

We are missing the propagation of CPTR_EL2.{TCPAC,TTA} into
the CPACR format. Make sure we preserve these bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
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
2.45.2.627.g7a2c4fd464-goog

