Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD85B70819
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767790; cv=none; b=E3HfcgnbExyotbcoNc3ww/iRRO1X3cn6z38D5Jw/4/RgZ8iFmRygyd3ExH9hBE4LF4rhWLdo86pKAOC5P+oWfNpsREE7XngbhbDCTm0MiACqOfSM6O0SMHNDwlbVLlMqdPqurGvQauRNUqHaMeSq4/b563ejYCVgNFt+2Io3cNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767790; c=relaxed/simple;
	bh=8Mcfi0WnE+0hciNMB3spz22lf2rIzvCwopZv2rFXgdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hAjEtOGmixu8oEd/bZ8t6uaU2OwoTcOTPpBuOnbeGtqil+2jRinpnaX4x/JeD/jjlRG6SiEO/RTRw5q2bivhXTXZx+/FVDSMEm3nBUpnhCuyiFjVEu54UUqpeDcQQWc/DgieiEhKUmatguen9C8sdHOQvPHPQW3GSnTSxSySqNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y1Q67JP0; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y1Q67JP0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F/r+Op2VkYMFfyWTwdNGdEUeRbYFIi6CFfELq/9SyBY=;
	b=Y1Q67JP0bIClBuwtKn3cycdgb6ueyq0kLa+8lDdGT+51H9ask5jbpSjm4riGX5RGqY1BhQ
	efT5G1JBn+Iq2CIAOtvenT+TyBDN2NHIvPmibuhumT5kBAHcDW2JXWOqK5NMtOnxmY9o7a
	xNdCYt9nv9Z/rDU9u3KbUG+l5u/txlM=
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
Subject: [PATCH v3 01/16] KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
Date: Mon,  9 Dec 2024 10:09:11 -0800
Message-Id: <20241209180926.2161373-2-oliver.upton@linux.dev>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
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

