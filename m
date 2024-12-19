Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE111C07CB
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648095; cv=none; b=cZHGQyYx2xESFQXxrcluw7He4bnY2GMc2Sa9KYkon8TdxYWHoYiJUQhdulaCDHuVT1vGOJDdcj61uVHrllECPP26M2MmQ6X1vmsdnH8qTWWNhNhoNthfV7Zu3299vhUtqqijjKrpQdc7hc2OB0lWdOcF3VtcGIw5TGKliWNZirw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648095; c=relaxed/simple;
	bh=KEXDSgM3+sAnVH9daSjyFBjeJFWlEHom6ji/PdrSvkc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O7Do1Cnjn21kDrv3A/JZsLT2pTlyj857+lOw8Tpzx8jvJrvzeHnaIJ2cFp5lifFQlRYPKCDxZBKtqjA0m71sYH11n1cov9JPxjNVQoxTSgqbELHkbl1iZP5CUTAhk/COweP0wSpUrx5Bmo/FDKiPrs1D2rvLNqHuhwZb4tBlv9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iCuz5Iip; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iCuz5Iip"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rw/7QkxHRuG58i3dfQLjZjd4zf7jg5qIGdfbep4Rcio=;
	b=iCuz5Iipr/cfQ+R9wxGyqZQ161FLVw9/oGqY4jmrTrFobefOy9ylujFQ0h3R/geNj16fwS
	BDpXyD41LxpXsU93GP+8j80S1krZ97U50v6ohT60rfmno/QubegL/xG218WPNgmfuSovVF
	o1V07X9YI7dKJG8UyO8DwLx8ywW9VNk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 01/19] KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
Date: Thu, 19 Dec 2024 14:40:58 -0800
Message-Id: <20241219224116.3941496-2-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nothing is using this macro, get rid of it.

Tested-by: James Clark <james.clark@linaro.org>
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

