Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2463E1736
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779367591; cv=none; b=uvt3DoVqpLONO0YclK4duABhRZWzs4mCsKX8iZ204qrXrF252gxbX8qdeDwDHztbYs9ndUma1jIHB+rfoGPF07csiBCInQ5ykHiFbWafI69JOarRXUb3vPBb+MeqiP1zxErJ8czHObfQp6uf+frJbszKWDQltip6sueWtubj3dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779367591; c=relaxed/simple;
	bh=QxWRNGJytR/ajbJxPpAo8WBH0Xqitv0xkN+vJgifFGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d/59mMwEDeJi5R2RAcWdv2IodRYI0g5NnNgPucZIp7bia95kulcAnaJQI1oBZHGrPTh0YLlKZI4jM8/RxuKogbipGXmuExeJQcoDE4zzI2IOy6oajqxY+7T9HrNQM1m3FFfK1S5AfOLQL6QD1GR5uOFEw/TOdbuLWggq4Q0A344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vxESKEh8; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vxESKEh8"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48feb8b9acfso36503645e9.3
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 05:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779367587; x=1779972387; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bI4WpBRjlid2+/WXIKxiW5XZsp3GH+F1NkxeLmro1lk=;
        b=vxESKEh8UFEysnVLr5Jlwl/UorOQLKaX2y8Rw3EYcUi9l+IRbKs/1u/qIQTABpfmMk
         ZbyQOpLWgxlmOpyQKbCuzN57mBnMZV8kUyHjfg1In+RyaYuTKHydhRmRlkp/i1U0McNT
         m33NHDVqX+/gXlKDXoCbGlLtQRMznqScNrYeZ+JxKgt+UKJr0ZCrHUie7MYA2CM4jWPT
         vGnhrq6GiRqBvi+JFc09CpBTTt3zHSuKE0Krht+I2FEZ+VhF50IkhDo1hDPmgM7mf8sH
         OdKbC5ZVOSNbDYTbI91XzBtNNDsE19otM6aYLkzSA9a6rkCmJTjs4j5tOYiZqnM0bnrf
         0HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779367587; x=1779972387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bI4WpBRjlid2+/WXIKxiW5XZsp3GH+F1NkxeLmro1lk=;
        b=AyFsmbNXwvdD8ElY1nJJ/ejwzVEmkHIH2mfZ3Eczj0EKHmvri4J2KQhTPrv+cQ8t8c
         9m45WKACvpFUxptCGOAG8YW4jrfXkePZdy7HLrNO2K13Zng4UH8V2BbcA9N0mrivflqJ
         +MmcyEBte2NSQpvnkg0p2He9iDmtvQXinCdPtOlbH2fj5HOBFFrrwdUccAxaulMVwHoU
         xPAPagYR+ow1MW1xXyUH26c0nX0Fk7sOks11Lbh1ONF6JzE14a3oE0yCH2DdVwrj8LD4
         0i94Sah7vJSRLy4UUyOiBdlMT7Fh3Jyq2j87hI6+vTvwLkHMJB6WAZg77+D/3tpgRHm5
         HO2A==
X-Forwarded-Encrypted: i=1; AFNElJ82sDA7w8NIMsWqnbUrCTeLchFJmTfuD0QX/2THnJkwpq49nfA2gWocygRqIqEJfi6GVMeZ7Yo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaiYjXBtIjo1uxG4S7q4nTCKgSofFpuXs/6Jzji1ItkiFL6ZFx
	mpkzU3RErTvL3KPdaBHbxLzJONxXhD109QhezZufqQmGWGMUWFFPetNamTccIevPLaeDAD8WPCP
	xlB9kCbWgxUMe7D1ytmm6Zg==
X-Received: from wmqo22.prod.google.com ([2002:a05:600c:4fd6:b0:48e:5bb9:e1a4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3545:b0:48a:54a6:b29f with SMTP id 5b1f17b1804b1-490360a87admr35403785e9.17.1779367586712;
 Thu, 21 May 2026 05:46:26 -0700 (PDT)
Date: Thu, 21 May 2026 13:46:13 +0100
In-Reply-To: <20260521124613.911067-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521124613.911067-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521124613.911067-4-vdonnefort@google.com>
Subject: [PATCH v2 3/3] KVM: arm64: Fix memory leak in hyp_trace_unload()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

During trace remote loading, hyp_trace_load() allocates the descriptor
pages but fails to store the allocated size in trace_buffer->desc_size.
As a result, when unloading the trace buffer, hyp_trace_unload() calls
free_pages_exact() with a size of 0 which fails to free the memory.

Fix this by updating the descriptor size in trace_buffer->desc_size.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 8595f9bdb3dc..c4b3ee552131 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -249,6 +249,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 		goto err_free_desc;
 
 	trace_buffer->desc = desc;
+	trace_buffer->desc_size = desc_size;
 
 	ret = hyp_trace_buffer_alloc_bpages_backing(trace_buffer, size);
 	if (ret)
@@ -298,6 +299,7 @@ static void hyp_trace_unload(struct trace_buffer_desc *desc, void *priv)
 	hyp_trace_buffer_free_bpages_backing(trace_buffer);
 	free_pages_exact(trace_buffer->desc, trace_buffer->desc_size);
 	trace_buffer->desc = NULL;
+	trace_buffer->desc_size = 0;
 }
 
 static int hyp_trace_enable_tracing(bool enable, void *priv)
-- 
2.54.0.746.g67dd491aae-goog

