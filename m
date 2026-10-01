Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B97551DDE7
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864970; cv=none; b=JxFVYhlqS3XTrwkdHcb7sqm/cwa5WkiPLlsQ0IdWF3hj6era8sIDzb/fx9gWVnbQw7M47xoBwBd8rlSAg1d4U2+2Ysttor1TQXUQccslxTLLfdO1DM9sWoKySNa7t0JE3rA26VqT3eBhGyidlpm6dsGUsfvLbDQKFhIMf0j+4HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864970; c=relaxed/simple;
	bh=LwXvY5HRCTLYY9VxNwUg9ypvtDfYkpk5Cwjbg4DIJZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rZbe0ixBMwLfAtw6L6vA98Oar5KPCLM8pf8mzmQyVsD1JY6jimeLneh2BvjwnediOGEOn3G88rI66KjOwHiaNICFhaFNG9+RNPJ+QMpLTV0LVhLfq/ySUfYtZeH8feluT7vhGE9T15B/r5pfAvjQEgXk+cT7lFUlkL8sBsBgx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W5o846n8; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W5o846n8"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e65bee41aso28524255e9.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864957; x=1791469757; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dqp/F5X9LxA0C33JNKoqHu3o/kFJHNN5vqXjhS8yNm8=;
        b=W5o846n8uqSlJ6C9XYd6Y7lhnUscYHkLo4kosC3wfCeMrq9ly8kVajRTuzZFx/QOBx
         f6sBtbG82KZloWB80QtyHvXANYjPY9HlJmKs/skrbgekVN3V7XLVJpzR/tCh9SLy85xF
         0QwwIFl2idDETU6Cwhz8jUUfhrh/5pkvHks6RkAtdkDEYjD3KN7oyNffnbHr5gA2Gjw9
         Ujvg/WPfofbIktDumSbSq8P/0b+RSbvky14te/UUboegxfObgegG/45T32GsXlrZmW5n
         +5AwK+vvlR8E3JDtKDei6HIljWHUnB9C3ojDN8KhhlYUJcJ28KcQ2BmbAwd2C7AZpOE4
         EAnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864957; x=1791469757;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dqp/F5X9LxA0C33JNKoqHu3o/kFJHNN5vqXjhS8yNm8=;
        b=gCNQDqrXHH7mPa0mR0E5HcCVMwmPc28W2i1rs6ZxidU5EnFtvL5cwaulFGArqhnirH
         AHbuiJ9e4QL8vsiWHqGkZOzrL9oANHePTINpT+fHYvlgzart0vaP4ykxfuwtydMNMWnC
         D0edoURfR5EikzkpSdVxfH+K+MoK0L0HSjFnB4EqR1WfXYrNAVFaOfvrQvRATeb3wM4x
         ZpBzLI21awPvrL0VXCA5dIEd0UEPgmVg/jeWM/A96nrHJsriHVlvDnLDE+IAAbHUd3VB
         Rh8UvIYVpbz9y4wlOoagpoV73FD0Anox49hLT1dZmyARTGtQ5CKwVVD6N30i1Co3ZYC+
         6tKg==
X-Forwarded-Encrypted: i=1; AKwUvByJrNU6YEkiHSRfSDrAep6T25ToXVB6A636FCyyfz6qU1GojadTBPM7IdsPYQQcf9t5F57f9Mc=@lists.linux.dev
X-Gm-Message-State: AFuF++mpvRNvfmrnh8Ai1VUgT3rA6HjIzrpcfIN4SnKFXXMxjVrupTK/
	CXll8qFHqiQaDfCy3fGPNTrdLRGlcSyvTYsjICLMbP06tn6zIWYxWKPYnVidVqjw+z+bGljhxz7
	u++EFrl3IcIapQ6fagpICqA==
X-Received: from wmmj23.prod.google.com ([2002:a05:600c:4057:b0:4a0:ff:4fee])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:c313:0:b0:49e:6865:904e with SMTP id 5b1f17b1804b1-4a01eb0c24bmr39706405e9.12.1790864956984;
 Thu, 01 Oct 2026 07:29:16 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:47 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-17-vdonnefort@google.com>
Subject: [PATCH v6 16/18] KVM: arm64: Reject hyp trace descriptors with fewer
 CPUs than hyp_nr_cpus
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

While a trace descriptor with fewer CPUs than hyp_nr_cpus currently
causes no functional issue, such a configuration is invalid and would
cause the hypervisor to skip ring buffer initialization when allocating
backing pages in EL2.

Enforce nr_cpus == hyp_nr_cpus during trace descriptor validation to
guarantee that every possible CPU has a valid ring buffer descriptor.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 47680a949f61..e9e584694506 100644
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
2.56.0.rc1.315.gc6ed9934b7-goog

