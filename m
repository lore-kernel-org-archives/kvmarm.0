Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35FA3B995F
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684120; cv=none; b=Ob+miw6wobSJCG/vF4128hqQe58SttAhoh6h9z4RATso7B7rUJktymlrMChzlrK/DfFGHJ+crMoa0MUAC3WPCCcOGrBX+4fi0ymyvEP+hrBDiq6CfsueYY+Ogu4m4YOFCo8QVziwFeb6aue1vyB8XMowWzjq7Vi1vRtOy1lD6hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684120; c=relaxed/simple;
	bh=m4Q6kgr3NMircAkxJm/cFCYSiBMIkObPLd5YqaZlJO4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cvDQXn37YER3zMdWt7oLWYiCsmVN5HQX1E4QMP2sbT+I0acCG56ByGZvzLWx2AzSm10CLEnXJpzduK3PVxGfG5DG8nvUnALy31gjXgnpW79lnsnue01GHq28nzDJ2yWwkYamyGB74GMUNcnyuOJg10HmB57ucvQ3WXWuje45vCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SZYzPsw7; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SZYzPsw7"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c15f0aea084so74116766b.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 04:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783684103; x=1784288903; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pO49h6zt1CtwH6yZzZiqbOv4e+R2v5hOGdBf1CKP83k=;
        b=SZYzPsw7P5HmaFcQm/Vujl36U0gapOANXDF7kEb+NOsM2OORXOwcYAj6ghh7OHxFnz
         mHaSiujx8xpMhSsZw2SxYgr0Ir0r0qxS8TJRhzKuDVtS6HzEfnevv8+fXOFaqI+hq+OZ
         EmVTew3vz6sORdqOpJ4RW4DieBrNdJdgcGMOisOVLk7ULH0Xs3mU7kCOWzc5adP9EGCQ
         kckjA2Il5OB4glLK7QC0uWyAM4rAYiOYs2pDfb50bq0AfCiQtmcBE9QDdnurYzFWLzDu
         053Eq7wrZzGAlOjxwjWU7wObTtN6STNip9D+7YHD7o1W/B7Qv4WqdD/9LalpA67QQsk5
         YGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783684103; x=1784288903;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pO49h6zt1CtwH6yZzZiqbOv4e+R2v5hOGdBf1CKP83k=;
        b=RyNiMqGacf6adsKCgIWfeOtV7C81FY+n6yZibEoZWNBb4RNYODuchOhZTAFSuiT6RD
         hT9uDerZ3/OlV8iEjNEsAfE6S6n/E9IlRJWrPRJgK5/r/TZQ3BiizDPdLckoUVPL5Vlc
         m0cZo+G0VwcUoMJ1p+8V4n6jdPr6uZHgD3KqMAk8DOkuRku6RR6iNXY3LRfF/RVZ1qlg
         nZ8eDdvrZwub6iULjRh4qIabr4Fw2nCVqK9wp/3jxzLrckvJhz2oNFZPuaXbzXkSMuJO
         iApHab8B1brnkxqWKvE5dhz6eR9sbvs1N8RTvwt3UZAGLr/MSVvTR5jF6nNPjDJzvvRf
         7NFA==
X-Forwarded-Encrypted: i=1; AHgh+RrQVxLLj9jtpsK++l10aTSmTBMgoLLfvtViaKp2O+N55a3eAQhX4QeA+3E4IZW8XtIpQu/RAJw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNkXxSFZaQRuHxP1aqRWuerEX4h1XEtkdLe1Yttc3/DCJOh96P
	OAB0GhQIQcNAPNv0p6Zsdbmxl6pEL4LLqbe3bSgdB5eY0+D8bsFMRiMZ4d99wEq1HLArg4HEXDw
	rT476aq1+QYhR7w2GphM7Fw==
X-Received: from edwl20.prod.google.com ([2002:a05:6402:1254:b0:69a:a01c:ff1e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:146a:b0:698:5f35:a8e0 with SMTP id 4fb4d7f45d1cf-69ab445385emr4571488a12.6.1783684102743;
 Fri, 10 Jul 2026 04:48:22 -0700 (PDT)
Date: Fri, 10 Jul 2026 12:48:18 +0100
In-Reply-To: <20260710114819.2689386-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260710114819.2689386-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710114819.2689386-2-vdonnefort@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Sashiko <sashiko-bot@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

In the very unlikely event of a failure in __map_hyp, the allocated
backing pages are leaked in hyp_trace_buffer_alloc_bpages_backing(). Fix
this by freeing the pages on error.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932..a7237aca6898 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -160,6 +160,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
 	size_t backing_size;
 	void *start;
+	int ret;
 
 	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
 				  num_possible_cpus());
@@ -168,10 +169,16 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 	if (!start)
 		return -ENOMEM;
 
+	ret = __map_hyp(start, backing_size);
+	if (ret) {
+		free_pages_exact(start, backing_size);
+		return ret;
+	}
+
 	trace_buffer->desc->bpages_backing_start = (unsigned long)start;
 	trace_buffer->desc->bpages_backing_size = backing_size;
 
-	return __map_hyp(start, backing_size);
+	return ret;
 }
 
 static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
-- 
2.55.0.795.g602f6c329a-goog

