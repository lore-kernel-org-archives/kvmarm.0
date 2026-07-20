Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7FF3DA5AE
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567745; cv=none; b=VMjTXs2I14J6WBTAx3B3x4qxwivekHcepci5XZYRKUlLxSaAp+cpYn9PQ2Sjk0niK0itsVGDLz3KgNcPNlIdQvCNbWt/WZ4Uze/2uAECbM9alCnlCISLVyk52BUe1kZnx4itg34g+6NlRrJVmhOGhGhwUoFmgUcEjkqJVkyiw5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567745; c=relaxed/simple;
	bh=xCeTGdJ02H0ps4ad9G30OIVgkJ0uqykjyxUnlrAXAPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U0YYLvehMRNh9sCCxjB66B4KefnMR1Cb0ppE1AYi/Dd7UE+HH9J2LjJI4sum9XD+jbj/EQDyvZrWJPUhWf1gxY5G9iEmyT1Ji0Lb+GGUw32qlAs/CiPARHO7DSdS6jqRWSMeNNuCKOkfRQ8rgczUZf60sFkS3fs7aJ7C8NwXSY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6LxOZWS; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6LxOZWS"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49244130073so104171685e9.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567737; x=1785172537; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W0Zj6kQS2ltsRWgAlubGupESY01CYbugFN5c9W4UIJU=;
        b=f6LxOZWSf0d6WgOB2JliFOKGXhrRmV70O3jD51O2IRl7pJB3UPb71KPxcrGQAaoj6V
         ZAnLNL4tgnFLTAqTmobmhZ2XSJjdy7Ia8l7tUJSblk+8u9LeFlciax0fFU4fiXnRiQMt
         p7g+6Xlc4jkfIiMWurS9DIe4CxQU2791RQYYLk9hesqtzbXGp+GDhyZvwBfO2BaMCPx9
         DwSKnGdn+120k2W9zypQezTTM0m0cx6uiccvype7peuF1OcVu0RQG+j83ghwi/ug4T+E
         vu+A6tmpIcMGtX1vCE06rMbWtCz40CqmVnj0m+xmSsQWsKdeaJ3KhEI+JQ9bnw820Pez
         Y3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567737; x=1785172537;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W0Zj6kQS2ltsRWgAlubGupESY01CYbugFN5c9W4UIJU=;
        b=EiaN3QdABbXefRj7icKBY8F3D0Y50D5q6pTf3vqvqgu6XPMDfmvSJM2uUwfpBYeZsU
         HQ/pQF97Uc/RmhqaHu9Oy60axQrMeuGcPleI0G0MKuj9qQRBcCswmo6Tib4Lwp0EZXSk
         upvZnVD/LRULn06+AX+V0GpDoMZnqtQsJnNL2NKMzFmMBVZY9YL+0f8FQs4295GKf6sW
         c29LMLVcl7AZku8rCkuh1ENt/uIUcsDDa3PS/rW4NAW5/2VE2vztR/1hvRHfPnAjMGqY
         AO4q+o0rwF8Xvuqu+s5xvOkJ31cO8EVz2xj9tDS2oMiPXLRTXP0pHDQ1tpBRhASsjwad
         l28w==
X-Forwarded-Encrypted: i=1; AHgh+RqyILoOX3q4kqQWWp9MRwEv2dWdkuYkjMauzggXmABaviK2FYtgXkCelVmHrOVFOpCSQHnnkIQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEPI1U70Z/rvf7GLxYluWtFxJCkVEJuoEisinlshyU5JoEVyw0
	02pzucwXYKSRmR7VcHi2KYOnVEQ6KoT7n34IRygj5nNa0u5tcxnxqe/q/qKRG47rgPHxCgKYpaV
	1Zj8Rxi0cl/xD5ttS1iSNFw==
X-Received: from wmpg41.prod.google.com ([2002:a05:600c:4ca9:b0:495:46dc:fbb2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f96:b0:493:e451:a9e1 with SMTP id 5b1f17b1804b1-4954a3d0ac1mr173593145e9.2.1784567737244;
 Mon, 20 Jul 2026 10:15:37 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:11 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-16-vdonnefort@google.com>
Subject: [PATCH v3 15/17] KVM: arm64: Reject hyp trace descriptors with fewer
 CPUs than hyp_nr_cpus
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

While a trace descriptor with fewer CPUs than hyp_nr_cpus currently
causes no functional issue, such a configuration is invalid and would
cause the hypervisor to skip ring buffer initialization when allocating
backing pages in EL2.

Enforce nr_cpus == hyp_nr_cpus during trace descriptor validation to
guarantee that every possible CPU has a valid ring buffer descriptor.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index e7e150ab265f..6e716295247a 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -181,6 +181,9 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
 	desc_end = (void *)desc + desc_size;
 	nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
 
+	if (desc->trace_buffer_desc.nr_cpus != hyp_nr_cpus)
+		return false;
+
 	for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc) {
 		/* Can we read nr_page_va? */
 		if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
-- 
2.55.0.229.g6434b31f56-goog

