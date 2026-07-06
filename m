Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06AC3BBFB2
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360484; cv=none; b=k2ug/cOCSFUXEvnO38fDzrEErg/1zsvalXTHV1wSH/y8XFG7KQxiMEnibGTyj70I297glxyx01SM43s/JZB3xDyDnkMU3pagt/98oC1+Wc5ozSYDgnEREuuU0StHsRU+Rl5dmo8gZJ2dRpX76MKAjFD+RVaGCC9Kv3Xop0Rng38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360484; c=relaxed/simple;
	bh=hWr8ux1rxBiPqsrAPkmQOjRdFN6X7GX7jiQalxkKeUY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T9Mo8BogZ16qzXfHm4tOTV9UiZ3FsDz7zHichp4m9bZ6dorehJFs8fYOS+QWxCUj63ZQuEM8EzN+l0Iwfm0BFiQu+DcsiP1gpy2kD0kcmALkJtPRyW5ARZ9xnvzt2fv85GzaNddkjhaMtbgGdkUFWtJ5+QgtITVZkEqY9gyk2hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uh/veDoL; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uh/veDoL"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b21b1fe8so28122915e9.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360481; x=1783965281; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BORF2qb/YzOTRyzZ0zTQ3HANIUsxjeDLfDvy6Tmd+Js=;
        b=uh/veDoLP4JqomEhmFo/aRwKtZj54jN7aQ/XX0ZMxg6ZDV0LOc9q3wiCICf7xy6c7R
         sHzMc0ipjBsklE72maQNPI4/pfUFPt18zC9g10pL6Tax2zlrOKzuKbXKTA/Ic7QDClE/
         Fj/NrPzEj/JIYMKUnLaR14wNzfw8nHHOxW7DxOSOkW6eyrmdxtP/Arf6H8/q6tfjF/43
         abtfxwC9HJyJyV7hTwO24dgu/hXRMg3/PSVYQx61R/iJCxbFWkvWU6iQopH1ZQf1WcR1
         1HtIDRRjZ7/lN31DLArJK2HonKsQVXCSXErPQ8gV4XPZyCh9GzR+QxTrivBaE5zTpsxN
         flOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360481; x=1783965281;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BORF2qb/YzOTRyzZ0zTQ3HANIUsxjeDLfDvy6Tmd+Js=;
        b=h5teptO7sSNCOrnU1sZSwXaN0lZh1R9fCfeki9/XTlgt45xEL0wosUnGH392HKvShP
         WkZq2V+MhDcqr+u8biVWtIUvcQv6RXZrOdPs1vo6zEr6olscGhS8XjufAbuWHNV2jjSp
         SV6+01Ygm/tiNEe5rVxDECiNF4uejW0rmBzNQp3wtglZvgsSEsjAeutp3b8c74ODk0RK
         YZhcFXPyx0ivXUU3sRDbAQrp4t0ZNN9kf9U8lwNLBoPRjT0C04q+YY4sjutRVVJNZYGE
         vWjvEUX7puvsy07Zm6kwmsV+zrvxy/mPPJ/nx4yS4RThxd/e3VdmctZlVs9ZiKZCeEFv
         errg==
X-Forwarded-Encrypted: i=1; AHgh+RrrLiKBqTGVP77Ihf1t9kxPGnkNTo5BpwqY7Lt/oGY9Lx5ThPGWdTDWSmfq0BiKcyc7Q3SJhrQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7IVyzAXdniCsuFN65Imy3RGq8weMhZj5WPns0ZnSJkgFK1Nxz
	SC342hsuShdfJBLdZq/eCrcBO8wtt7h2NWNANn3I39hwmPI0i7qSvxG6uuLs3WTXV9gMkJjqX5b
	imMzP14+Aq4k8tFT0pNcDXw==
X-Received: from wmbb19.prod.google.com ([2002:a05:600c:5893:b0:493:b636:4ee9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6d4d:b0:493:b720:ce11 with SMTP id 5b1f17b1804b1-493df088fddmr14317875e9.31.1783360480767;
 Mon, 06 Jul 2026 10:54:40 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:14 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-18-vdonnefort@google.com>
Subject: [PATCH v2 17/18] KVM: arm64: Reject hyp trace descriptors with fewer
 CPUs than hyp_nr_cpus
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

While a trace descriptor with fewer CPUs than hyp_nr_cpus currently
causes no functional issue, such a configuration is invalid and would
cause the hypervisor to skip ring buffer initialization when allocating
backing pages in EL2.

Enforce nr_cpus == hyp_nr_cpus during trace descriptor validation to
guarantee that every possible CPU has a valid ring buffer descriptor.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

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
2.55.0.rc2.803.g1fd1e6609c-goog

