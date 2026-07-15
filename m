Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE5B327C18
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123714; cv=none; b=KbQs7pvHTHBg2/EAtlxNOx+ZCtzYKEDVZOABiwrR31E/OrpPcuwjB7oJ7G5Nvkml8SSP8a/lG4DtSOt+PMNt2r0kU7gaaltrA66vNyQ/C7ATln6oevFWJ/pRYBqS6w1u20p88UZ6dwOeNiVjG1c4kV0CDBreP9QRaCbABEdngCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123714; c=relaxed/simple;
	bh=nU4+Ia+F8ySPds+A4KMRRKUIChrXooQILgOye+VPLY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bduDBOVaz0TDUi47CQ/g3u8M1VIWqSnI6C9h1B00fBI142jHTHJcvHEcOHYK58yrNONrlfvTbTne2aPpfOcjjMQcFHmmzFPdL1YKBJ2ick9HdjlKGBHNySmaRRJ1/oQfs8HmKU1yA67r9YXJnPIVuOzhPnyUfMfYu+dbyj0DEdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qZFQWzRF; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qZFQWzRF"
X-Forwarded-Encrypted: i=1; AHgh+RqaOR9O4ueW7AGZS99a14g+j0yiEv5I7vJvYdyR51g0Vp8XEo+e/QeH+Z3BwT35aN21qW9dyps=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784123710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NQCGAdkzYKOAr7afTKItocmK3QBZ5Mm5lieH0vuNx0M=;
	b=qZFQWzRF42+UQvdA/0TubE9iCqQQXkOb29JBoCtc03gO0n6OMKhp8AooBT2T0iPqwuJcsV
	Rm9jQevwQauEz9FekYr8s5R8XJSDJy/7b+AmudA+OKESsFZCy2CW7O1/Nm4iDaMpy878Si
	8wkWKEFGn2QGI1Zj4ETDHM4Y9wP6WeE=
X-Gm-Message-State: AOJu0Yx9z4Duv7oiiF/8Qc5cfSsW2o9cILSu/yTDujb77VW3wEEm9ups
	FvwwnROa7unm2YVgRK79iJRDqsW3nFOLV1HaGI8o4rqely7Ooi3BTTsa6gGxDqgk62D5zs1TRik
	Y1ILOOwoN+IEEPwkZLCNMBKMiYyRQLsR9COQcCySS
X-Received: by 2002:a05:622a:c81:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-51d7bd1d949mr27444781cf.16.1784123693155; Wed, 15 Jul 2026
 06:54:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-18-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-18-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 14:54:16 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz2aM=XoefwAxpNrN5e1boBZ8d1uMGuB3dj6gUzML9mHA@mail.gmail.com>
X-Gm-Features: AUfX_mxQJDCiL_XwMIIjQrHo9vj4Q3arYavOYvKrlwTTbMnSrizaInG-eT77Ask
Message-ID: <CA+EHjTz2aM=XoefwAxpNrN5e1boBZ8d1uMGuB3dj6gUzML9mHA@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] KVM: arm64: Reject hyp trace descriptors with
 fewer CPUs than hyp_nr_cpus
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> While a trace descriptor with fewer CPUs than hyp_nr_cpus currently
> causes no functional issue, such a configuration is invalid and would
> cause the hypervisor to skip ring buffer initialization when allocating
> backing pages in EL2.
>
> Enforce nr_cpus == hyp_nr_cpus during trace descriptor validation to
> guarantee that every possible CPU has a valid ring buffer descriptor.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>
> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
> index e7e150ab265f..6e716295247a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -181,6 +181,9 @@ static bool hyp_trace_desc_is_valid(struct hyp_trace_desc *desc, size_t desc_siz
>         desc_end = (void *)desc + desc_size;
>         nr_bpages = desc->bpages_backing_size / sizeof(struct simple_buffer_page);
>
> +       if (desc->trace_buffer_desc.nr_cpus != hyp_nr_cpus)
> +               return false;
> +
>         for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc) {
>                 /* Can we read nr_page_va? */
>                 if ((void *)rb_desc + struct_size(rb_desc, page_va, 0) > desc_end)
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
