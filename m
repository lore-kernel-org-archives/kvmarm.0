Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4282817BB32
	for <kvmarm@lists.linux.dev>; Fri, 15 Nov 2024 22:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731710989; cv=none; b=kaBlMGkQeW+8N4xZSRfI6giiKGi5uFJO2hU5b1C3d/sTBa+ustyqinNKIWyh93QYXx9qUFUPa2dNLITsSTq3UILScAvvoKhucO0ykDeXPECh43nSba80mgQ52oq2nhLTshq/17CO21ct7ty9Z8d9cZ+VB0fbd/KMuw8LfwoFA0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731710989; c=relaxed/simple;
	bh=8Mcfi0WnE+0hciNMB3spz22lf2rIzvCwopZv2rFXgdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SGuZhhdNjumULniWY4LUcBsbEdI10ENMVu1WlUKXP6jCHT3yu7bSQKKHhaVLi2CavxxF/bKr5smtGaTeleZ5uBlpgIZE3G72WZOhJvAV+yFXsdXS0e5sAN8HcOwqOW0VTeXF+BUGrXPmR6Pgl/Jil8XfS2kXWRa2fu4BcU5+I5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kZhNCNF1; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kZhNCNF1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731710985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F/r+Op2VkYMFfyWTwdNGdEUeRbYFIi6CFfELq/9SyBY=;
	b=kZhNCNF1EsUv5h9HskTm7pvO+qwihnrfcsTuNRBgSV0HNvh0qo+7IzSTOq1TgkpCWwONcP
	rpI5fhCqhd+341OdX6znmb6K/ybMBzC63SDq/eqfB+Hlt6Be+o0m0wg8Jn1olNCEg/orPI
	O+1qvXma6P7qD6bw/O10ovR0MJ7ecm0=
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
Subject: [PATCH v2 01/16] KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
Date: Fri, 15 Nov 2024 14:49:09 -0800
Message-Id: <20241115224924.2132364-2-oliver.upton@linux.dev>
In-Reply-To: <20241115224924.2132364-1-oliver.upton@linux.dev>
References: <20241115224924.2132364-1-oliver.upton@linux.dev>
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

