Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4B922A7F0
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784573336; cv=none; b=L7M9QoWM5HJW78f8Ji6u+VfM6nmf5pCoyWgFCg+WMlL5URE/SDqoF/Gyhng5wlJ3BjdWtl1JyrXsuVYi6cmh5qLsYEVRgnJKhYp1UBN/SmNKnrHWP86+WIyN5u+H4ChZwNQRVt/xm8YA1zyu54Y1YplHDUBHm1NnEXufdOKM2W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784573336; c=relaxed/simple;
	bh=28l2lYv5DNtF7fZunFbhnOCkES131NjPavDE3ixVpSc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sWvlqZgU3ArSqhkxur1F2bgr9mlMrZNfQS6UnaJsyPjy3pzFfYB6o6NF3kSK+Cddw04aVHCYPmGJCYggs+YMejlzYZIPhbUPyl89RKKftjdASDl0R6lzL59vmGW55GBgh+Wj7L64DRM1gzYHG1Fc+kxueDzLZiPWAvOCJyv/Gdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZflIySSL; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZflIySSL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784573333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qLxO7C/9C4fJ8Duz1IApUTN+y+79YQnEjthyFz5HJ14=;
	b=ZflIySSLxnvigH8ilhtZi50KgPi3pESd6tjWIZ38IRHrevJstSkt/VceSNwsJRU7eD+uGt
	IGggosg6kTtPqhywq1OWa9UMQaexQBaOwLS8ENBT0S+8hIWaoyMSgco3ef3VjJtW8NIBjG
	VEbm3oiB4AfWBHVQRV1VN+7R0xA8ZWs=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: vdonnefort@google.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: [PATCH] KVM: arm64: Stop the hyp trace clock worker on disable
Date: Mon, 20 Jul 2026 19:48:50 +0100
Message-Id: <20260720184850.1826630-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When disabling, hyp_trace_clock_enable() cancels the clock work but then
falls through into the enable path, which re-schedules it and marks the
clock running again, so the worker never stops. Return once the work is
cancelled.

Fixes: b22888917fa41 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260720172923.E4F161F000E9@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp_trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932c..27367843fd211 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -116,6 +116,7 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
 	if (!enable) {
 		cancel_delayed_work_sync(&hyp_clock->work);
 		hyp_clock->running = false;
+		return;
 	}
 
 	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);

base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.39.5

