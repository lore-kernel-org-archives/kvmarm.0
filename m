Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC41212B2B
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115006; cv=none; b=YvNFUUVXmw5J1QzhFUnRiqUOvFmZLvjwy9CrKSbjLF8gilDU6psRe01i85JLQwdPE8ty1Q/d5XYQjEP5V1KL6KJVnpJxiOUR0dugefb/6HBQN2AWLYzDzyorYk3HegOSo8ujH6hCN0vo6yRAZuTp0ZbwpoTuQ5ZGM6xV6z6U9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115006; c=relaxed/simple;
	bh=tF9TahPlMgVsYs5zjzCYsXtWy1Gp7AkLcDy2+pB7Few=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fvw3v0Z+SCrMMVb92gw+CC2qbrKwEJbGDgFuU5y5mo6f/Lw/F6JBzfbtJLpxC3W4kBUG+e68AfQm7j0zS3Egc22TVhpvmXIMxiKsL7L9p/sP/o1Kk9jcpvjLhlir/jFbchjd7npXpyR5BbV/C3pc2Bo+afMOLgnUYhcY8z2RaA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=td3vOwfV; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="td3vOwfV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GFAnKhc4yf2E2u4ctGxCsmUgwQr7Bf+8RKETio4sSlI=;
	b=td3vOwfVMKYxOBITclQprGR0uyhC5+b7+wipebzr7JxoADXoUzYHqXWndzTWxvHVBbPgDP
	jo41YoommSAMKfamhP6VqgfJxk3ascpdiXFkkFE9g+ggtD13nR9woScxgDSYkC7FE6/E2C
	F68cDBBRw/AnPn293EuvdesdgdX8brA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 02/27] arm64: Detect FEAT_DoubleFault2
Date: Mon, 16 Jun 2025 16:02:43 -0700
Message-Id: <20250616230308.1192565-3-oliver.upton@linux.dev>
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

KVM will soon support FEAT_DoubleFault2. Add a descriptor for the
corresponding ID register field.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b85be598cb17..72ccf9ed4d05 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -303,6 +303,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_DF2_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_GCS),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_GCS_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_frac_SHIFT, 4, 0),
-- 
2.39.5

