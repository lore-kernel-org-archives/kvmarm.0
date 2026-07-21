Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8189A35F5E1
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 07:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784620225; cv=none; b=qFG6IB+Wem5CgBYX2FM8yZdllWO6GK5Ai083cFdqr0EFqyUu2saIp0UkLZ3KjK5qtbCnhxHbMKYB3mqJlwJt0DiZuWwMyIuNPp+j6O0AG08Wf4NMnz+9C5kIMAM24e/Rl2/q9sR0kZAto6W8tmohpr6n39hlq3qHlxbSSBiGtWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784620225; c=relaxed/simple;
	bh=deGNNB6rK7ANxLX4tQ3c+zB7PKf1KNwbxVxIUKfEOmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qkhDMjQlXVIelwzMOGn/CySv5zzXCmpamQXRQVY7KvH2SIp8c7FWmCIx3pweftrKyFWZdFneOQSM2SLxza7TNqEpkEjdd2+DhjXdw6zZtG5+a+3JQV1GwA6KLHQgR+a2iLC4gS4Zazp1tlS5QGauLX/FxnN6QUKw+8jAI41MzLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bp6ynHX2; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bp6ynHX2"
X-Forwarded-Encrypted: i=1; AHgh+RrAUQp3ZujbeLe6FpNxj5j2Yy4PoDC5axiLSAe3wSB6lkJAXIp8ZF+8FVjURvL200iWaOuprAw=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784620221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qIU0wcim3JRNROEXJcT4sf8FGesHdbjBdUO8HtD3Om8=;
	b=Bp6ynHX2ew8YuOsxCmxzJ9gh8xDvilyKKBEr6mkBT/9z7QPLEDNcx1G0V6XuPYiLdDFKE5
	OyWv+ouqeVzy1ws73xxgX3UEDHoXsCM45RI3PKs54n8TR3v5rxJHZ0WxTA0G78ssHtQw9y
	B/RjlU+pyUc82SK7S3CWxjuw06I3Ieo=
X-Gm-Message-State: AOJu0Yz2EM5Q21cVT4xfepOu8hlQNn/xPQdpbQ9ughdlBHMzWtrnRLKm
	XjWbO6eUPrT3Apyru4ibGfqAnrzfxaXQLNGWeWB+Gb8+0XqALENhtH+UrrOJANeoV8Sl0HRLzRr
	Xc3coEVsQ9BhNsTxfZO6PKwvhkr6QR2PE3JBiRXUz
X-Received: by 2002:a05:622a:d1:b0:51c:9ad:d76 with SMTP id
 d75a77b69052e-526025cbcdcmr10716751cf.19.1784620203936; Tue, 21 Jul 2026
 00:50:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720203529.1276355-1-smostafa@google.com>
In-Reply-To: <20260720203529.1276355-1-smostafa@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 21 Jul 2026 08:49:26 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw+BypEvWRccxqsSGR+btEX58nCUC2ypuSjw04Qo3nN=A@mail.gmail.com>
X-Gm-Features: AUfX_myIwZifnR9KPL23lN9BM9f3hza67nmMok8FJ5ITuX-6AqaL4_b_GXQ0JsY
Message-ID: <CA+EHjTw+BypEvWRccxqsSGR+btEX58nCUC2ypuSjw04Qo3nN=A@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Optimize protected mode and FWB
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, 
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 21:35, Mostafa Saleh <smostafa@google.com> wrote:
>
> KVM opportunistically enables FWB if supported by the system for guest
> VMs, which allows it to elude cache maintenance for data as they are
> forced to be cacheable from stage-2.
> In that case, __clean_dcache_guest_page() will immediately return.
> However in protected mode, before calling __clean_dcache_guest_page()
> it loops over the range and fix_map/unmap it, issuing TLB
> invalidations, dsb() and isb() unnecessarily.
>
> This can be optimized by returning early if FWB is supported,
> kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
> functions issue dsb() for the unmap path.
>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 4e329e39a695..6e9229106a25 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -261,6 +261,10 @@ static void __apply_guest_page(void *va, size_t size,
>
>  static void clean_dcache_guest_page(void *va, size_t size)
>  {
> +       /* See __clean_dcache_guest_page() */

This looks good to me. One comment: this file also has
hyp_poison_page(), which deliberately avoids
__clean_dcache_guest_page() because the FWB elision would be wrong
there (it even notes "Prefer kvm_flush_dcache_to_poc() over
__clean_dcache_guest_page()"). Given the two opposite treatments in
the same file, could this comment say why eliding is safe here, e.g.
that the consumer is the guest via the FWB-forced stage-2? It would
save the next reader (if they're anything like me) from reconciling
the two.

That fuller comment could also replace "See
__clean_dcache_guest_page()", which mostly just points back at the
function passed in the __apply_guest_page() call below.

With that fixed:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> +       if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +               return;
> +
>         __apply_guest_page(va, size, __clean_dcache_guest_page);
>  }
>
> --
> 2.55.0.229.g6434b31f56-goog
>
