Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D559E4973A7
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456170; cv=none; b=JZgc1yHC1vNDw39WSGCKFKc9cvg0iCMI61LjdJ7y7QsOXh22YFTQNAT6PKIHMRm1rUd0NUJWXR2gJ/HpFsElnAYQD4uIAXRx5iFyR7bvTZjQi1k6WQTz/Wq+ggBEcX1x3ErkQG2tl1vJq5EMbOMJ8IVFdgTdhE2kxBvXnUFk2rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456170; c=relaxed/simple;
	bh=/xcJ2+8lWGMc37QVAznzR6c4fUY/FLvesrfH+DiP29g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kopqWKXyXON+mtORkMa/TMyT8Nzb/AnV67rZ/8OUmDBulRZnpvT/L0a3qoaLhK2ck/sVv3aTJdv1FuHgMAi2qM7fyxJ57xvJsGtqSlvzMXXPOPy6OYNAixbqSU1h9FUsAdsS/ACtNF3HRxTDVX+LmQmR01HL8FDS2OrZj8BqHZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KcPQ2sEW; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KcPQ2sEW"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a17e77c5b1so16593255e9.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 03:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791456167; x=1792060967; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VM97xwYT1dB0ZgvNb7fOqgAZXGtuRGu0qA+yv/6pRZc=;
        b=KcPQ2sEWB4GXiPgAIr+7cf+NEXo6oQ1YrkiMP8sWOgLiBHhWDra/Zzv4C9laYYOxMV
         qP0d8DcRHBnSlMCCovlPOTIJeW2ETix93SsWqpyLO3O95IrXiPS5dh7ghzDVmXcN/N2A
         S00Yf8lqhl3Wre8gyVKDEl0AMCSSieToFd+Vlrw0mNgLtezJXMF6pJzT7Ju+SlNReONt
         bbqZfX9KZcybk5ZE7lqIcxcOQjdzYOOanD10gNv3HfUG4wUx+q8gLTsFMevk0zqKZEba
         NNjhDSr6ystcbTJJemJzuPXEu8LS8rxZSx76bEQk8rirgpSDrN7Le5jftppdxZ9jrVMb
         M3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791456167; x=1792060967;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VM97xwYT1dB0ZgvNb7fOqgAZXGtuRGu0qA+yv/6pRZc=;
        b=SYBg4hLhVh7Bz42HtJK9+nxr8Hwa9Yx3ES7Fkrj8pjO9YCEo+gDtNmhqW16/AFISNh
         RyVCO5V1yl/MDjT6k/IkRvwKBcwvYo+vAY/d7aMUHG6W6AxQNzyq5cwXR/Ab17bJWls+
         ftz+5AwgP11YYPJpxzg8AN+9rREzZofEoM6o9T2hv6UADY0srL6VWlt7T5fwjnFAbEVd
         eROvgpnUQ5P1/+/MGoP2d75kvXiAyAehCBgWNojPLN6fdpi+yn75+GJ2UmU5savYN6LD
         bvZ3dGhDRtKT4cZEZXahlx8oVcRezW8uVV9ipWfNbzhhdW2X6uXxfekf/jDrW/ZVyK9O
         kDaw==
X-Forwarded-Encrypted: i=1; AKwUvBxKFUCbMMn99LO8nh3cVv6YCH/n7Pyz6qEcsRcIJA2/sObu8DXhsjMGo/A/vqCdFkYBl1g4g14=@lists.linux.dev
X-Gm-Message-State: AFuF++ln0gTbwF2oP1Clg3yrUtlYqOG7a+eDh+wXdEfI7cqtGR57gYcA
	vYcQLCyWabW3uaDq6o/ejvtItIHNNWjFnYlu4e5wIqEihY79vY864na1hlUQL1HWx3dZpA+WKlj
	aY26copDIpISBcxRlBryG0w==
X-Received: from wmpd9.prod.google.com ([2002:a05:600c:4c09:b0:4a0:13a7:83c6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:64c6:b0:49f:cbf1:e765 with SMTP id 5b1f17b1804b1-4a18008688cmr90980165e9.0.1791456167102;
 Thu, 08 Oct 2026 03:42:47 -0700 (PDT)
Date: Thu,  8 Oct 2026 11:42:12 +0100
In-Reply-To: <20261008104212.3134550-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261008104212.3134550-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.360.g66cac248cb-goog
Message-ID: <20261008104212.3134550-3-vdonnefort@google.com>
Subject: [PATCH v1 2/2] KVM: arm64: Fix bpages backing allocation size in hyp_trace
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

hyp_trace_buffer_alloc_bpages_backing() computes nr_bpages as
(PAGE_ALIGN(size) / PAGE_SIZE) + 1, whereas trace_remote_alloc_buffer()
takes into account the buffer page header.

Align the bpages backing allocation by using
__calc_nr_pages_ring_buffer_desc(). There's no need to validate
nr_bpages again, it has been before with trace_buffer_desc_size().

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp_trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 26fc13c16458..b9404496f977 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -146,8 +146,8 @@ static void __unshare_page(unsigned long va)
 
 static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_buffer, size_t size)
 {
+	unsigned long nr_bpages;
 	size_t backing_size;
-	int nr_bpages;
 	void *start;
 	int ret;
 
@@ -157,7 +157,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 		return 0;
 	}
 
-	nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
+	nr_bpages = __calc_nr_pages_ring_buffer_desc(size);
 	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
 				  num_possible_cpus());
 
-- 
2.56.0.360.g66cac248cb-goog

