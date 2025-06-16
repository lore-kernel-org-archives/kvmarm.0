Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4265A21FF5E
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115187; cv=none; b=GbpGPsG6c1Sd56+5A61GxZzJK/qFhkovex97rzbJ0ITegUNven0fhBrze+WYFfcgeenv/B8vkXafMs4gnFtJIxcT7lSkReD3rFsIy9Ei4bEznV96cgRH1pRMj9G1QMkJWb4IT+9/jebsBxdIVZ0+mNrE6zhGsjHXGZwA6DqaEW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115187; c=relaxed/simple;
	bh=mytw2TnUF1B+MVR6ODN3GDGVH25dTz7dvQegvyQbOy0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lEx0sNcBQAFYmQGNIjdZdFrO1M3DtpizW+cEiPREASQNYAkztBv2ebPbS2LsK19puBIYJRx4ELMdpr5Bz+rdMABjTZt5KUIeuDbjOJPBpOw3ZeutGj37FdQfhD2nLabHDbFSD1KB7/pi8owf24F7kUDTwPrGyzOmkXDu+vtwBUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tczf2ofN; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tczf2ofN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6bPB+cnlQbNdR5DIy36NI11hrDjaX9RVgaQBSJrvhlw=;
	b=tczf2ofN9yqVE+gEhVovcKYZn8kpi8TY1TGoFwK3zat1th7J9rqu52nGILrhbcQxsJnfZW
	OybZXl71Lq4KzG6UoRDp/7daiNhk7Wl9FW198eMkp7+Ak/kpsjsBVSIufZSmtIW4wbkJoM
	nJJnlPa/HCA9VYKQIRs19a2NP3zbaEw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 20/27] KVM: arm64: nv: Enable vSErrors when HCRX_EL2.TMEA is set
Date: Mon, 16 Jun 2025 16:03:01 -0700
Message-Id: <20250616230308.1192565-21-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
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

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 55ff05c7296d..a3985ebfbd36 100644
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

