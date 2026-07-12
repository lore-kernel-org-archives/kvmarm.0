Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB997CA52
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871837; cv=none; b=VztIbJ3hbokQuMF8dlklvzNv7UdF8UxLkgcHETQ9LX+eCzt+Teh+4aCT5LKQO+xU0YX4M4tiFKBzTnBp4HmzZWTGNSJl68KF/AxrXUUhW6Huxf+U7gY44FPrMK/f129y7tr6VRGNTmKp7Qj8obixhoYk7jw+ebno71k/iXlMNrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871837; c=relaxed/simple;
	bh=HtXD3FmX4vZinU5trQGSkj+YRWjgUwGkjyktEEEf3hw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dtR6/5UwHc5Xg67lRRBom6FCxDo/WHgq8hFpXwzX6LmGYh8Uc0Gy6sRnjIb8Hx5wbSkolHR6X0Lanl1bSomnooDuJ9x9A4p5kTjY/pZfX8MNo0ygjgrrDTcxvxuVOD0/8kA+hTHrLUiOVfapx9VdwkyteCgoQ0YK5cBrv43oGAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eTN8Sy3K; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eTN8Sy3K"
X-Forwarded-Encrypted: i=1; AHgh+RqD8ukQU0J23pdBy6MROx53CJ2mybkBuRyAEctSVUY/eDLno2aHjejAywi3Xql1a48hvQXdo44=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783871832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0jLcdFtl7R6Tfa/ki2sHb7vZqexvF1gWmIdn1yVC0L4=;
	b=eTN8Sy3KjUaFgx5dlbvenSlG4c7hlVS004GZw2bix+lx3IZgDxWxzTDSKkVBKEtNIN6CsD
	IHuIF5bqjjKaX9yMSqtZE0UJRFMloQmT87OXpXBAQrBc0HD3obSoBp5JwlUN/bXpT5GN3a
	yY+E1PRPM8bjFs+h1TzvjWu6OA6U42Y=
X-Gm-Message-State: AOJu0YxIsm2KSdeKUEphlN1nNrYnry63oPWh6338LmUIn8mjGz24lhvl
	Su35yRAWi+O4T9321SuAiAJ/TJFA+ogHg4KSNR6K+TcdFakgqEv/pmZD/DPUQjQux5OUCkICxKh
	zAO5EQvny/1RcUZxIXdyYR2QRjO9v3t/3IWOif7NK
X-Received: by 2002:ac8:7fce:0:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-51cbe223323mr11181191cf.8.1783871819977; Sun, 12 Jul 2026
 08:56:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260710114819.2689386-1-vdonnefort@google.com> <20260710114819.2689386-3-vdonnefort@google.com>
In-Reply-To: <20260710114819.2689386-3-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 12 Jul 2026 16:56:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwAEhgDLPrpRdSyMYdV5zbt1T2LB=hKxb4PG4JB7XWHUg@mail.gmail.com>
X-Gm-Features: AUfX_mz6PtwEXTIM6AD8HjcL_CT8j8sTWbGf_r1fC3QNf5VdqNLl-GNqWThuFk8
Message-ID: <CA+EHjTwAEhgDLPrpRdSyMYdV5zbt1T2LB=hKxb4PG4JB7XWHUg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Fri, 10 Jul 2026 at 12:48, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> The footprint calculated for struct hyp_trace_desc sizes only
> trace_buffer_desc and do not take into account the other fields. It
> worked so far thanks to the follow-up PAGE_ALIGN().
>
> Fix the descriptor size and while at it, enforce an overflow check after
> PAGE_ALIGN().
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Applied both patches on v7.2-rc2 and confirmed
arch/arm64/kvm/hyp_trace.c compiles (CONFIG_NVHE_EL2_TRACING=y).
Booted protected and non-protected VMs. To exercise hyp_trace_load()
directly I enabled the hypervisor trace remote via tracefs
(remotes/hypervisor/tracing_on) at the default 7KiB and reloaded at
512KiB, so the reworked desc_size/tb_desc_size split and the
alloc/map/share/__tracing_load path all ran fine.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

>
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index a7237aca6898..22437c5e1e7b 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -235,18 +235,22 @@ static int hyp_trace_buffer_share_hyp(struct hyp_trace_buffer *trace_buffer)
>  static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
>  {
>         struct hyp_trace_buffer *trace_buffer = priv;
> +       size_t desc_size, tb_desc_size;
>         struct hyp_trace_desc *desc;
> -       size_t desc_size;
>         int ret;
>
>         if (WARN_ON(trace_buffer->desc))
>                 return ERR_PTR(-EINVAL);
>
> -       desc_size = trace_buffer_desc_size(size, num_possible_cpus());
> +       tb_desc_size = trace_buffer_desc_size(size, num_possible_cpus());
> +       desc_size = size_add(tb_desc_size, offsetof(struct hyp_trace_desc, trace_buffer_desc));
>         if (desc_size == SIZE_MAX)
>                 return ERR_PTR(-E2BIG);
>
>         desc_size = PAGE_ALIGN(desc_size);
> +       if (!desc_size)
> +               return ERR_PTR(-E2BIG);
> +
>         desc = (struct hyp_trace_desc *)alloc_pages_exact(desc_size, GFP_KERNEL);
>         if (!desc)
>                 return ERR_PTR(-ENOMEM);
> @@ -262,7 +266,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
>         if (ret)
>                 goto err_free_desc;
>
> -       ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, desc_size, size,
> +       ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, tb_desc_size, size,
>                                         cpu_possible_mask);
>         if (ret)
>                 goto err_free_backing;
> --
> 2.55.0.795.g602f6c329a-goog
>
