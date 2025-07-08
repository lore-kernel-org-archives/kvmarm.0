Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4701F91C8
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995719; cv=none; b=LoqKFiXz5OfMGfi62HNzAmMVa1bSqXV6qRxGPlau0ZQF1SPTm1ySy9sV1/CxfZYJn3fTwcKIjWQGKvO0Eh7ULTG+/scwfPW1WekKOCEHbQmnPbZLxs1Zh9W2Q6We07oQpADpIuJfrNWfLR+mvuyASc6J6YQJukWfzyQGcKRxtoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995719; c=relaxed/simple;
	bh=4EziiCRg99ex59rTQ6I6rhyC3nLnc6xgaQz0DOGNaZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dRcPRW5CMQ9vaVnEez2EPqrIY750+GtAuGDyZLuXzP7CsBsrVFxHwr1VERZ9vqh2QNLpEFV+RWzJ7+j3zNybDXrq5iJc06ieMIhzFi8WFuwECXJm8brs06CYqVqkHERlGYvVlvir/zCAt3E0AILKKbkQNQ73zEiyzKlWPzoRecA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RsME8MUv; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RsME8MUv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vifwD5btFqI83AZ2qPZHTusTENid6rl/qV33JB0ouo8=;
	b=RsME8MUvUn5coMhRw3SeDo1dTnsk3v8UbBUdWpVNnkUNDz2Vyy0RuM13l6og5Sg2jxInuE
	igqxxHapVHIvxs8iPo677BXtGa4M/fyqcIs4q+oFJISrIQeJhpAc8soIeWZmY/yuY9PbZG
	J7DHxVBeG/xB+FTbcWN5IZIGeCZZ71k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 20/27] KVM: arm64: nv: Enable vSErrors when HCRX_EL2.TMEA is set
Date: Tue,  8 Jul 2025 10:25:25 -0700
Message-Id: <20250708172532.1699409-21-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Per R_CDCKC, vSErrors are enabled if HCRX_EL2.TMEA is set, regardless of
HCR_EL2.AMO.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 71ecdc20523e..fa8a08a1ccd5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -259,7 +259,11 @@ static inline bool is_nested_ctxt(struct kvm_vcpu *vcpu)
 
 static inline bool vserror_state_is_nested(struct kvm_vcpu *vcpu)
 {
-	return is_nested_ctxt(vcpu) && vcpu_el2_amo_is_set(vcpu);
+	if (!is_nested_ctxt(vcpu))
+		return false;
+
+	return vcpu_el2_amo_is_set(vcpu) ||
+	       (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA);
 }
 
 /*
-- 
2.39.5

