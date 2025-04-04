Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDECF21147A
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743785583; cv=none; b=HP09Sxz4jzupJ2JfmodeJa59gexzUtIKBfpMA+Sf3spkBhwzQZIGsVC5E1JHy/uBbjdzNlcLwCCYDlBBc6LqLy7Xngbu8sF7MYkUKwGDSLLh+Om8SbCsLMh50vCDXs57gSGMtVfoN2QuMOVU4WdTz6gF3qaYo4WyjwIJKk3rcws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743785583; c=relaxed/simple;
	bh=qh5CKCuhZIJy2V4uu/2qTtRHv/azLp18VBWD84RD4Qw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VI8iku3G3oG2wIXteJZiEcHfvKEp39H5VAs7J90ErYpzzql0lfNH2b0KG3msQrlwHPaWzev6UkgF6Gzfd+pTR3s5e4agPh3oirxHjeX1SwRE35Y8BY4E8+IhWrat9I3CguUU/N9k00FUreNFy0HdprEhfOSi5iQwMxWYuVhT8OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BFkqW3mX; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BFkqW3mX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743785580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J++YesDbz+As4+xmAyp0B2XAif0IeIKXQAOq6lAgobQ=;
	b=BFkqW3mXFPjUVdaNTUDMqf7fb7AlcapSuSm63qMaG3Yo+qZaNgk06m+2whbxu6aaAv1UQl
	9DzKZhy+vv5S1AeFhyEGUlzRKQ+YF3dSgcxNfN1V80cwd/c0bLzuZTpXqqqUlGqlFSISoj
	UttS9M0SijKFHJldeNmVkBSikr3ZiMQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v2 6/9] arm64: Move remaining kvm/* headers
Date: Fri,  4 Apr 2025 09:52:29 -0700
Message-Id: <20250404165233.3205127-7-oliver.upton@linux.dev>
In-Reply-To: <20250404165233.3205127-1-oliver.upton@linux.dev>
References: <20250404165233.3205127-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move the remaining kvm/* headers into the top-level ARM include path.

Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/fdt-arch.h         | 6 ------
 arm/{aarch64 => }/include/kvm/barrier.h    | 0
 arm/include/{arm-common => kvm}/fdt-arch.h | 0
 3 files changed, 6 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 rename arm/{aarch64 => }/include/kvm/barrier.h (100%)
 rename arm/include/{arm-common => kvm}/fdt-arch.h (100%)

diff --git a/arm/aarch64/include/kvm/fdt-arch.h b/arm/aarch64/include/kvm/fdt-arch.h
deleted file mode 100644
index e448bf1..0000000
--- a/arm/aarch64/include/kvm/fdt-arch.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef KVM__KVM_FDT_H
-#define KVM__KVM_FDT_H
-
-#include "arm-common/fdt-arch.h"
-
-#endif /* KVM__KVM_FDT_H */
diff --git a/arm/aarch64/include/kvm/barrier.h b/arm/include/kvm/barrier.h
similarity index 100%
rename from arm/aarch64/include/kvm/barrier.h
rename to arm/include/kvm/barrier.h
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/kvm/fdt-arch.h
similarity index 100%
rename from arm/include/arm-common/fdt-arch.h
rename to arm/include/kvm/fdt-arch.h
-- 
2.39.5

