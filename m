Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73172E6131
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995550; cv=none; b=r4o9Ts5xCFym1NDRq9cXnU5Ou/KevfGkwX/FJDS+XYy1FohSd4Wxkxr/6hbiFlxpvZETIoMa323j7s9cMPH/8OuZvXdIf/M/yRRBkfEeHoalq2dr5YpnM3AGWQ/FpV0fvHahFMQlkDP2O7V+KUMpjm035XtsKoCodhF1pKWqBMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995550; c=relaxed/simple;
	bh=XYlcXBD/5fKs69wn28qAVbZ3a87bHsNrKcjPRVSFIi8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TgGWYnIS6cTBbhAnrZGP5l+g2llEHTC+HnJzvRIKxxA5voov3AE7sv2jtqMA4aKX2eZfbaiM1iAtOLTbqQkP2/H8ELWYmRf0qRMoVc1+83KzQWD/aJrtpfZdkVsGQydx5HGbbWzZF+2KFUePyiwL0xZxuobrnDkDDIqVOY2gQ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nuZBQE86; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nuZBQE86"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q9NT4Qv4Sw15efEy4KJoPxcdCtGvI/D2ECJYpMNbzJc=;
	b=nuZBQE86KZ9mvwHO7Ebo+Dx4beAf5nkbck+gylAW15h0TUf3zDyTOeqVKCHoIZ+CX+nsWL
	/BYuafFZTBzA+fo0bdM9q0qhxteI8Nh55S1ODz1+K5v/VE0VBOJKRvK12BXNMdXhXUGbgr
	Y8PY59bSj/Ob/ZhEY4M3ecC859FXLwc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 02/27] arm64: Detect FEAT_DoubleFault2
Date: Tue,  8 Jul 2025 10:25:07 -0700
Message-Id: <20250708172532.1699409-3-oliver.upton@linux.dev>
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

KVM will soon support FEAT_DoubleFault2. Add a descriptor for the
corresponding ID register field.

Reviewed-by: Marc Zyngier <maz@kernel.org>
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

