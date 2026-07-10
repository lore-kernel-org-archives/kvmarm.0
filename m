Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18FE41DEC9
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684127; cv=none; b=GvsGfGDh8lFD3j63KTopUeItQXUGIqqpUeF9hfJtqZVD6r+pIr+KXBJ9PV+MvO28ZZcJWnj1JxrzlHB1chl2KGYDNftvosoDHDMrZ4xyojTqQqL+udq7lehB0mY0zL/NwFa6QTbkvemgPKdbkSXJC6sq2q/mb8CQZbjVk216KJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684127; c=relaxed/simple;
	bh=vYXmGI06je3zRZlAH9gDHwZ5uORpEGz6/KvNZL1fpQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UhUiM8zyLiNO6UPXup/bZbCGgEL7waJLyJfMvXqLon7XU085cEUgodqhf2nSSvTJ4aJ3q4Z5H0nRxzmahkABY9CI0BH4zro+DxiC3ZndP79hM0qeTOiJIe3DhEToxqSam3vOjaNG+OeyPdJCZQaUQtdxEYxIe0XpByYoYI+KVxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VUi/WbtT; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VUi/WbtT"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c158e733fd6so93342866b.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 04:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783684104; x=1784288904; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HmF3lcAHkLWWFtDMYlM3Z+U5SlAtuG3HZzps1Mb+VH4=;
        b=VUi/WbtTMph434vK3nCNFO8DDSJCy6FLOcTDHKBZD8jCanj2eenYoWzFtGMf/Db4MS
         VFRR7DP1DRmxEP4EaT13SxTz3UiuE/uymqbkldnSzpf1TrZwH+clAakoLrGlFochx7Rn
         OVKowIds78ebQFiR5C6cxCGlZpRu0QLox67wXp8OTnn+eCAcZ5LtaUsGgw3NZpV4d6st
         OVppf9t/jnzpmWciKIcQhZkViV9f3jUgXY6OwOlo+WO27PF3SFnjo7wzDVcul+ko9mTV
         yF8yHjsjVF/eLlGfBbRJoD3VHhM97aw0/rn3LjsvEfRh17169Va0AWVfmB6z6DM5KgNX
         XIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783684104; x=1784288904;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HmF3lcAHkLWWFtDMYlM3Z+U5SlAtuG3HZzps1Mb+VH4=;
        b=K+mAFZ6ezMFtIRMlilHBvuXOkzJHWsfebiwsSNtcF0r++9mgKrsfgykjXz1ZZIUQRR
         dA/ZQoP8aUPhApkcaK4v5s8jU6cUybojNnfS6gubyFzVMT9SgbegKFBLeJ6SmhT1LviR
         Z4eH9DWt4ye/54XaJixz57Z/v6ny7y90/CshMN0Sp6bWvp10GXeT8VY3LH1wspZ6c1fE
         NREy9paWdVZ20XymBs9JN7pltCzZCLHosWnm+Wk9AyADypNUluX4dJRj5hyzx8ggtQaO
         M7HCUv3cIzadtMbNAJzZ51bgL7dRhkgDZB3YFMTl+CS0NQjFuLSIVypk/o0bCjNyw/KX
         fV2A==
X-Forwarded-Encrypted: i=1; AHgh+Rq6afn+474hubDLSo17gtAn11dXMu/Rnsgl51sM3a+pzsbT6Oozw6D0Do0AyR55/qZ7ofonB+k=@lists.linux.dev
X-Gm-Message-State: AOJu0YymrgB0CX6AqgezCs8ZX20RwW5NrqhP/Sy3HRNEJMD4+FLEM3Ke
	nWsX+TiVyp4xUmXMiNYz4Q8eipLXXrbrtBZv+W8Q6EKzInSc8260LAUQxUOPzdqSYwoBeRIXEVU
	Z/Y5G5umhwr83AEEOSQQPCQ==
X-Received: from ejeck4-n2.prod.google.com ([2002:a17:907:e1c4:20b0:c12:e3a1:5d4d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:2b58:b0:c12:5e3d:4023 with SMTP id a640c23a62f3a-c15ce014b0amr372554666b.10.1783684103855;
 Fri, 10 Jul 2026 04:48:23 -0700 (PDT)
Date: Fri, 10 Jul 2026 12:48:19 +0100
In-Reply-To: <20260710114819.2689386-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260710114819.2689386-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710114819.2689386-3-vdonnefort@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

The footprint calculated for struct hyp_trace_desc sizes only
trace_buffer_desc and do not take into account the other fields. It
worked so far thanks to the follow-up PAGE_ALIGN().

Fix the descriptor size and while at it, enforce an overflow check after
PAGE_ALIGN().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index a7237aca6898..22437c5e1e7b 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -235,18 +235,22 @@ static int hyp_trace_buffer_share_hyp(struct hyp_trace_buffer *trace_buffer)
 static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 {
 	struct hyp_trace_buffer *trace_buffer = priv;
+	size_t desc_size, tb_desc_size;
 	struct hyp_trace_desc *desc;
-	size_t desc_size;
 	int ret;
 
 	if (WARN_ON(trace_buffer->desc))
 		return ERR_PTR(-EINVAL);
 
-	desc_size = trace_buffer_desc_size(size, num_possible_cpus());
+	tb_desc_size = trace_buffer_desc_size(size, num_possible_cpus());
+	desc_size = size_add(tb_desc_size, offsetof(struct hyp_trace_desc, trace_buffer_desc));
 	if (desc_size == SIZE_MAX)
 		return ERR_PTR(-E2BIG);
 
 	desc_size = PAGE_ALIGN(desc_size);
+	if (!desc_size)
+		return ERR_PTR(-E2BIG);
+
 	desc = (struct hyp_trace_desc *)alloc_pages_exact(desc_size, GFP_KERNEL);
 	if (!desc)
 		return ERR_PTR(-ENOMEM);
@@ -262,7 +266,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 	if (ret)
 		goto err_free_desc;
 
-	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, desc_size, size,
+	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, tb_desc_size, size,
 					cpu_possible_mask);
 	if (ret)
 		goto err_free_backing;
-- 
2.55.0.795.g602f6c329a-goog

