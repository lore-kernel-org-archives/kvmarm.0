Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E73D337BBD
	for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776009; cv=none; b=EQxbHrd4dC6QV8yF3optdH+W9Ic74Dss0qMkuMWFw4p/BC77skF6EsLoEXkBg0HCPuXP3hORiJZ6BkVDwo7cf0e8WmTVfiSX2BQAJgRR+s/OArx4TMjhdpC/zfCAJK5H4IIZN9i9hubrIk6uHrWbMBqW/XqDqg4d4QtILCkvasY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776009; c=relaxed/simple;
	bh=xPixFivSXxIGA9cHru4zTbT+HGgOGywNZHdXxJstkvY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JFlhPOkH4CfHji2xq0eFLz41O3yN9pG+lIwo3g2MHc5NVMYUO7x6ZVhakKkoWd66jQxGO7ljH9+qirXqp68sAFRoevB0GM+YyiyTUt3giaz1gRzy/f40t3TOSaZtST4scF6EYrkpcuh5cAjWpCFXkvghZd8g3axexGGW4EzXrBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z+Q4WIBx; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z+Q4WIBx"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fdb2b0cb8so7204215e9.0
        for <kvmarm@lists.linux.dev>; Thu, 14 May 2026 09:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778776006; x=1779380806; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ux+Fp2F2XUWVJAPCM114RJU332LaQ6InmYZIpXtQURc=;
        b=Z+Q4WIBxPmKqkIiJlThNxJibu4VyvI7loi8rsp14C+fUe5eSB7lXsOK4uoLwMrWG21
         U+3LPrZYhCZiS7SXeueEZWTxnRLrmoXR7wrDZbVntiRZWymUJJo7WhcwUSpEfjzozqxX
         WMlHDBiFAQn788a5TTr4tPDfm+uO1tZHkjowDhXKrPSA6gG5al3YFunYrO+4IeGo62EP
         gn1o6l8K7PJ8dJZlOFHS1k1HwkAJYeLY/0ws2p6Kp6RY+rfdBL8bAzSuoD3gSD5UgBPh
         vKXS71k76XJeLXU/QjPjkFTVbVCY3KUpx/s62FprtnIsK+Zv40jJuPtJSxKYwK3sfLAo
         /XGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778776006; x=1779380806;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ux+Fp2F2XUWVJAPCM114RJU332LaQ6InmYZIpXtQURc=;
        b=j1CF0qRSqRU9BLTedjphI7+voAkVbny1wYwAHW9bXH7mPSbScggtDhnjPqdw2M73nX
         5v2XMIll3oiaUYdnh6aRU4tMl7rgeQDe6Ik/VQOf7/6flH1c2fZ3w0AFieIs4rPKqlQO
         NwdTMz4+yHvza9eycS0pn1ep7dviCgvsLff/CrJuSGXXhMzsn0OnzePJ4iUfyzjwVNLw
         Z2x8oeiJNTw3tTcY+Ha8USzm9CPRWOoPhsV54ZYCq3rII1awyxOJpg5UpGpPvhKCjMI2
         k785BNWwd3w0RGDqwtFleozmaVT7GWFxe4oWEPxKxNnHgSR9g/OX6n0mTDn+HXf7UWXj
         ZXUA==
X-Forwarded-Encrypted: i=1; AFNElJ/TB365ipTlpg8z7C+c23ivk+9ai2+g58RJdNDcqFBMLgP8Rhfs4Dv0dzDFGcRCYrdQkDEVap8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/qQvFFaaT0xi5c25OZlhhhS7nQS9A5LoyiEL/5b+90KQdTLGC
	+XG0MLc+Z7oQz+ttF+PJo+cTW92YbzhRLjg6fE0JD8koGsacL5mSykzf2stR/Qkvt4RdbREe6ZA
	t0AS8hTx7Ji9OZbaiEv7e8Q==
X-Received: from wmim16.prod.google.com ([2002:a7b:cb90:0:b0:48a:5d27:4655])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b18:b0:48f:e230:1d14 with SMTP id 5b1f17b1804b1-48fe632a187mr1001865e9.33.1778776006117;
 Thu, 14 May 2026 09:26:46 -0700 (PDT)
Date: Thu, 14 May 2026 17:26:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260514162624.3477857-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

pKVM must validate the host-provided tracing buffer descriptor.
However, if an error is found, the hypervisor would just return 0 to the
host. Fix the return value on validation failure.

While at it, rename the function to hyp_trace_desc_is_valid() and skip
validation for the nVHE mode as we trust host-provided data in that
case.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index a6ca27b18e15..e7e150ab265f 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -164,13 +164,16 @@ static int hyp_trace_buffer_load(struct hyp_trace_buffer *trace_buffer,
 	return ret;
 }
 
-static bool hyp_trace_desc_validate(struct hyp_trace_desc *desc, size_t desc_size)
+static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_size)
 {
 	struct ring_buffer_desc *rb_desc;
 	unsigned int cpu;
 	size_t nr_bpages;
 	void *desc_end;
 
+	if (!is_protected_kvm_enabled())
+		return true;
+
 	/*
 	 * Both desc_size and bpages_backing_size are untrusted host-provided
 	 * values. We rely on __pkvm_host_donate_hyp() to enforce their validity.
@@ -212,8 +215,10 @@ int __tracing_load(unsigned long desc_hva, size_t desc_size)
 	if (ret)
 		return ret;
 
-	if (!hyp_trace_desc_validate(desc, desc_size))
+	if (!hyp_trace_desc_is_valid(desc, desc_size)) {
+		ret = -EINVAL;
 		goto err_release_desc;
+	}
 
 	hyp_spin_lock(&trace_buffer.lock);
 

base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.54.0.563.g4f69b47b94-goog

