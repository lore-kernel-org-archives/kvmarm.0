Received: from out-169.mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C484453A55
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842639; cv=none; b=QMo33Q0fltnHAU84WgP67DFhrXmYfhEXQoSDd8e3dtOYmVwGd+wI5odd8TSMuWYFzxGiNKtS6bTSSZsEroaSr7mnq7yDVHfTajC5P8mjdAewuao9E6vdupOzgO/UcPDhfc2i/NJWNdKgxNNRc/NH8ozpq/V5/zNUKxT3Tq7fDt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842639; c=relaxed/simple;
	bh=/iCvHcbpKF86s8mUijJ9mtfUoT/0j522f9t+I2F3pQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t1VMJOd2ICUMuSweUIGymAjrgrjOXrolcwJJV95Jy36mH9FbLwiH1KjjOwwFJjb7rp28yhs/1/SFpegcA/c2kegeKWDDGdIZJNQ8T5/HcJrhSN8HMdxGSljicTyEOmDBZVahfqgLV6zOX+ZIgl0rKm5kvFi8sX0uP0KK3lJJVQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QNCoG8yk; arc=none smtp.client-ip=95.215.58.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QNCoG8yk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785842633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bVKtopwMrqzEnOyVedKGwt1g22ev9g5F8tMkWzZJze8=;
	b=QNCoG8yklFuiDeil1YTbf6EhTSPhfpC0uz2qzmE7+FGvUqf+AelqpV4jWMT8NaGw4TxTte
	K1pr8tii3dDTgXh1WA3TuVcM6VQTbvcw3aLCH/KPm3qrCNEp3XlJWMGk63BXY1jC/qVXbD
	YRgRULEdi4gZNsyd9/YAHgaKP+YRzvk=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	alexandru.elisei@arm.com,
	vdonnefort@google.com,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	ardb@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	tabba@google.com,
	fuad.tabba@linux.dev
Subject: [PATCH v3 01/11] tracing: Include linux/types.h in trace_remote_event.h
Date: Tue,  4 Aug 2026 12:23:07 +0100
Message-Id: <20260804112317.1937387-2-fuad.tabba@linux.dev>
In-Reply-To: <20260804112317.1937387-1-fuad.tabba@linux.dev>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

trace_remote_event.h uses bool without including linux/types.h, so a
translation unit that includes it ahead of anything else that pulls
types.h in fails to build, as with nvhe/trace.h at EL2.

Fixes: 072529158e60 ("tracing: Add events to trace remotes")
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 include/linux/trace_remote_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/trace_remote_event.h b/include/linux/trace_remote_event.h
index c8ae1e1f5e721..e4cc2d4497bcf 100644
--- a/include/linux/trace_remote_event.h
+++ b/include/linux/trace_remote_event.h
@@ -3,6 +3,8 @@
 #ifndef _LINUX_TRACE_REMOTE_EVENTS_H
 #define _LINUX_TRACE_REMOTE_EVENTS_H
 
+#include <linux/types.h>
+
 struct trace_remote;
 struct trace_event_fields;
 struct trace_seq;
-- 
2.39.5

