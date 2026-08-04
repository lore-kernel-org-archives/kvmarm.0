Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E634657D8
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 11:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842648; cv=none; b=CSsgwtgWLiRKBvviwOGwSCed3BRXDu8ZvleRjrl67XKX7ggSYk1/LcCEswBYBkk+p6j9Z01ecZVaVdmToF9xK1alA63hgZ8LyQVYTrA/Te8Aa7u0UjEZ53ud/KcfbCheSKflIqqWQRTz4Toziua+nGHZcjW0PKOtkkcnmOT9oKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842648; c=relaxed/simple;
	bh=CpskfQyNSuQnKK28n7Fb63ydz6/PMV/vlQveuN/a3ec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kexl7V7injHmFNeScsOEsPc/kIs2/fRMSu7qFUznhKhkbXaGCF109Y7Crd285c/qLFyIl6rwskIbGZEBs4ZKQSYTlUnCCdpeiCIGWJJR/MJtzuT06adinemGPLDG7MZHLhxV8iUg/gOAs5j9vz93UNfQ82oKD6URPKVb2YAlYCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KdaBFFXv; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KdaBFFXv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785842644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5F+MIK/Sq7LP625lI93wSHp0p+82BAhT+VDlBkJm/w=;
	b=KdaBFFXvGDH6zK/2v7gtmrXtMtF1PrvEIUV3jGVkj/gX/sc7fxdLTzZmvme2RYlSfMuxBG
	ujFitJdjD68JMcxxyMmN7nJLMJUrzvgEqRTeZ+WtSwnGJfkFQfSI8zWIApquGrl2kNJlXk
	30xcB/RT/++rCv+XHYUHSSrlcpVlcrg=
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
Subject: [PATCH v3 04/11] KVM: arm64: nVHE: Use NULL to reset the trace buffer backing pointer
Date: Tue,  4 Aug 2026 12:23:10 +0100
Message-Id: <20260804112317.1937387-5-fuad.tabba@linux.dev>
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

bpages_backing_start is a pointer; resetting it to plain 0 triggers a
sparse warning.

No functional change intended.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
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

