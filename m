Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D968A3BFE2D
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040942; cv=none; b=SktbJZ4JWQWo/ZV82tJSAvKLed4KVw7lAU3fxYWMPyZ1joPIpAwl8sMHv1YppyTcVeHOuaeVHma/xl0rVNmAU3PLVmiXo/tzj4XvE00FS2hc83a10soI9xTt43AjvwpB7ohRrCE8kv872oVQnTSLQ1thMN5NPrMnyhEMQqFikpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040942; c=relaxed/simple;
	bh=MUGRfB4oYWG7DyZuMYskkLphXSNYgZFTg2+9PYuk/K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8MFrCGXpSyXlbduDwLEO+J7U+E1PcYVs9pWRfU/LcXac4NP62N+gtqSaiywBL+S6TiuA45z8M1n+2rqaII5CNABkol04Opaiwha2tuYJl1/nMjM93PjhNC4MQkktV40zc8iJtn0PvUuBk/Z8dBZnRdsZhTM9VSyTGySp0gl2NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T6tTNy3J; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6tTNy3J"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772040939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VY0eOcbP10xypHAaHBqk13P+uVcLzRh1cwtoBu1zlLg=;
	b=T6tTNy3J0NKZ3vVtfsZaNmJ3RWluFB+MVGvDgb63KduKHnw56dW5iFn4tJuihx1rmd6/OV
	hBRZrSxFr4yjZJGd4AofiyEpHb6vQkp82KPkGqCDKJI4NB8Al+7IVpCEEjPVQSkxQpzrKV
	5ayRPePmoODkK4hJ5K9IeRqfpza+8mQ=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: nv: Check S2 limits based on implemented PA size
Date: Thu, 26 Feb 2026 01:35:13 +0800
Message-ID: <20260225173515.20490-2-zenghui.yu@linux.dev>
In-Reply-To: <20260225173515.20490-1-zenghui.yu@linux.dev>
References: <20260225173515.20490-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

check_base_s2_limits() checks the validity of SL0 and inputsize against
ia_size (inputsize again!) but the pseudocode from DDI0487 G.a
AArch64.TranslationTableWalk() says that we should check against the
implemented PA size.

We would otherwise fail to walk S2 with a valid configuration. E.g.,
granule size = 4KB, inputsize = 40 bits, initial lookup level = 0 (no
concatenation) on a system with 48 bits PA range supported is allowed by
architecture.

Fix it by obtaining PA size by kvm_get_pa_bits(). Note that
kvm_get_pa_bits() returns the fixed limit now and should eventually reflect
the per VM PARange (one day!). Given that the configured PARange should not
be greater that kvm_ipa_limit, it at least fixes the problem described
above.

While at it, inject a level 0 translation fault to guest if
check_base_s2_limits() fails, as per the pseudocode.

Fixes: 61e30b9eef7f ("KVM: arm64: nv: Implement nested Stage-2 page table walk logic")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/kvm/nested.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 620126d1f0dc..44ed3915b961 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -152,31 +152,31 @@ static int get_ia_size(struct s2_walk_info *wi)
 	return 64 - wi->t0sz;
 }
 
-static int check_base_s2_limits(struct s2_walk_info *wi,
+static int check_base_s2_limits(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 				int level, int input_size, int stride)
 {
-	int start_size, ia_size;
+	int start_size, pa_max;
 
-	ia_size = get_ia_size(wi);
+	pa_max = kvm_get_pa_bits(vcpu->kvm);
 
 	/* Check translation limits */
 	switch (BIT(wi->pgshift)) {
 	case SZ_64K:
-		if (level == 0 || (level == 1 && ia_size <= 42))
+		if (level == 0 || (level == 1 && pa_max <= 42))
 			return -EFAULT;
 		break;
 	case SZ_16K:
-		if (level == 0 || (level == 1 && ia_size <= 40))
+		if (level == 0 || (level == 1 && pa_max <= 40))
 			return -EFAULT;
 		break;
 	case SZ_4K:
-		if (level < 0 || (level == 0 && ia_size <= 42))
+		if (level < 0 || (level == 0 && pa_max <= 42))
 			return -EFAULT;
 		break;
 	}
 
 	/* Check input size limits */
-	if (input_size > ia_size)
+	if (input_size > pa_max)
 		return -EFAULT;
 
 	/* Check number of entries in starting level table */
@@ -269,9 +269,11 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 	if (input_size > 48 || input_size < 25)
 		return -EFAULT;
 
-	ret = check_base_s2_limits(wi, level, input_size, stride);
-	if (WARN_ON(ret))
+	ret = check_base_s2_limits(vcpu, wi, level, input_size, stride);
+	if (WARN_ON(ret)) {
+		out->esr = compute_fsc(0, ESR_ELx_FSC_FAULT);
 		return ret;
+	}
 
 	base_lower_bound = 3 + input_size - ((3 - level) * stride +
 			   wi->pgshift);
-- 
2.53.0

