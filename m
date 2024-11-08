Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D501C4608
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104687; cv=none; b=nNXfVvIR1HEGt4BeV3tI3KAKna7aEhY9N6vfzRswZD7c7ageRw+T33hL8+eJco7jCygfx5HbgsHY+kRGpV9czX73kCyu/K4E6/8ziYCu189ItJBfwY3f5sTURZ8KBAEHVKDRHVPB/Qxj0+eoaOucC/xrae82V/T93HvAJ1H1bZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104687; c=relaxed/simple;
	bh=8Mcfi0WnE+0hciNMB3spz22lf2rIzvCwopZv2rFXgdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U26EGNLl0F02FoHmb3oauDHyGBumAjbpaeA7SkrsTzMAwhWiM1bS6cnV/TbIWAZtEdsAFBddDU4cTFPooigSMkzqphSz+T6zPN52etnQBna1bu4vfljOmrPPt754Jlsrc69Hgq8lmqy5Sl6uNumpGG7NAgqRvL2BS/jiUUhxYTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k0iEpRnx; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k0iEpRnx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F/r+Op2VkYMFfyWTwdNGdEUeRbYFIi6CFfELq/9SyBY=;
	b=k0iEpRnx1LO43L2mt9+WH9u6C3lz+JDftV/Va0PP5Ut0kAttOryXefc3EpsujFI9U0659r
	vIvLKvgSwtNC+krk1nr2bXCLU84UaJlusnTjvMVCXiXqdUhFb9e5COCZXSGG95jfzzZi25
	4tLVB4aUcrxncQOd1ZVsgpdrasBARc8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 01/15] KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
Date: Fri,  8 Nov 2024 14:24:05 -0800
Message-Id: <20241108222418.1677420-2-oliver.upton@linux.dev>
In-Reply-To: <20241108222418.1677420-1-oliver.upton@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nothing is using this macro, get rid of it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/debug.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index ce8886122ed3..587e9eb4372e 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -16,11 +16,6 @@
 
 #include "trace.h"
 
-/* These are the bits of MDSCR_EL1 we may manipulate */
-#define MDSCR_EL1_DEBUG_MASK	(DBG_MDSCR_SS | \
-				DBG_MDSCR_KDE | \
-				DBG_MDSCR_MDE)
-
 static DEFINE_PER_CPU(u64, mdcr_el2);
 
 /*
-- 
2.39.5

