Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EDE43A7FE
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 16:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564066; cv=none; b=ACEFTRfzjX+QsZBvvhMJQ6Tn8z9w3hsWk8zdCyATCT04B9J3V4Mdn62Vbki1l5SkC5PmlaR/+0Duchz4kQnojJTfoT2DUd69nSbwKFp0QARkRIR8DuNFgUcG1llTAw+w7GYwcswyCY3518/ACyrFQda1SNpY/aIdk6sFS7S9Oy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564066; c=relaxed/simple;
	bh=jSCVMW2FAPB0qVwJZoqT13IK6K0E9kxxHOKEgtv2V20=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U0f6ClbXzLurqI7RJvZKKb5IsULVK/jbJiw9u+83WsrYhpbHrF2mfwUxe1lMwhE3vaFh1odVPp9ySayexmmriqeog9CkPx6+/4oxs7g4ZCGvUbzPvkB6q1LqYtqvfoTsDOARptPgVgpXk2tXxHqTZ82Zmdwo5JBjI9GB5ysNL88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z7BfzI45; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z7BfzI45"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784564048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3zIKmZROYh74nqCSv6sg/c+Cjz0XlrnkYv/gMVvWs5g=;
	b=Z7BfzI45SyIIjCifTWZFRl69fF0oXedsowC4+zlSeN41852ATp2ILM4Syg9wpryJZbbVmm
	3xE4orm4inUitbpuRfwKY8rO0l0F3ibxz/rW5Ff6gZBVbTEviu0S5qoFQUJJh8i3Jblo4P
	RLhfWmD/gFMxoXxCh3k0S1vM5W+dKyg=
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
Subject: [PATCH v1 04/11] KVM: arm64: nVHE: Use NULL to reset the trace buffer backing pointer
Date: Mon, 20 Jul 2026 17:13:36 +0100
Message-Id: <20260720161343.1367007-5-fuad.tabba@linux.dev>
In-Reply-To: <20260720161343.1367007-1-fuad.tabba@linux.dev>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bpages_backing_start is a pointer; resetting it to plain 0 triggers a
sparse warning.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index e7e150ab265ff..177fe3d8fbb13 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -93,7 +93,7 @@ static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffer *trace
 
 	__release_host_mem(start, size);
 
-	trace_buffer->bpages_backing_start = 0;
+	trace_buffer->bpages_backing_start = NULL;
 	trace_buffer->bpages_backing_size = 0;
 }
 
-- 
2.39.5

