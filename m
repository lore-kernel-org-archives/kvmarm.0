Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E566C435ABB
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 18:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361999; cv=none; b=mllF7FzXLLPT64V5oiyYooKjLCcVoiy9l5GCk6uwEHe2k6vq5kDb2cXcUMTdsqT8Xth0VyMgwjlz4uEJlTGDXpzLRvgWhE65SfuOUNdAUZSHYuyjDsthcc2sW7omWRl3HGLiPCjirs/LbXHAq5T7CUQNUFpZeqYKzbx+xIuKX3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361999; c=relaxed/simple;
	bh=fbg+goeFPWO+MHAL21YyzlFNak9IMxUe4dwXAoeDiMQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D9jgJuiv4+l/qpXzYxiOwzoInpMxpaBAh+Zg1z2afGBzV2cyqGqX1rsMQ32pMYUJlnvi2k/eoK9PX6sf/2mL6SXigHXRxgYANTjv2yosdaovgF/uzhNhJGLqC8+07ET9xOZAB/EYTVnVOC3Q4bIit8v86Wqdxa+hXskmtvESp5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NOgO/m8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NOgO/m8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D01A1F000E9;
	Mon,  6 Jul 2026 18:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783361997;
	bh=MH/gTzt1w9RGQnSw0MWn8dHzX0W5TfuDpw92yt2E9vw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NOgO/m8t81P/Q6xrGQ7Md0YLRSPYrfxFDBCF+sqMf8rmtcujgDgmGzWaS9oQq3BNX
	 ypxO1pjWROFOTX+HlffHDe1YXa/FRjPm4e2IAHxR3tWHQzA/7gU24+qmWSCsEd7QHJ
	 1NoZ4LZHFEURGGy/mXY/LDeshmRPF/ESwTW2Fz496fARmIPFRoBjNwn97eIQ8VeUXJ
	 YObbNHjWuau3ZZHD0g12ArZaZ8CGrAPd54+zOM86slh3JkMtDSUhT0t60UIZHWPskl
	 UR7HkSoaPNrQq9FbfcOC5Z2h+tepxEc5a8XtkfuAqS4OFb6N1FhGxCmxWF73UyvqIg
	 Oa2IGoDIhxnjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/18] KVM: arm64: Alloc simple_buffer_page using
 pKVM hyp allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260706175415.2604046-19-vdonnefort@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-19-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 18:19:56 +0000
Message-Id: <20260706181957.4D01A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing validation of host-supplied `nr_page_va` causes EL2 memory=
 leak and host infinite loop.
--

commit 20e38c941fd5614b7d02825f2350aeac0276e149
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
   =20
This patch transitions the allocation of the simple_ring_buffer structures
from the host to the hypervisor in protected mode using the new pKVM heap
allocator. It uses pkvm_call_hyp_req() to handle potential top-up requests
during allocation.

> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/tr=
ace.c
> index 6e716295247ad..bcfe06bba29bb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c

[ ... ]

> @@ -62,18 +63,34 @@ static void __release_host_mem(void *start, u64 size)
>  	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(start), size >> PAGE_SHI=
FT));
>  }
> =20
> -static int hyp_trace_buffer_load_bpage_backing(struct hyp_trace_buffer *=
trace_buffer,
> -					       struct hyp_trace_desc *desc)
> +static int hyp_trace_buffer_alloc_bpages(struct hyp_trace_buffer *trace_=
buffer,
> +					 struct hyp_trace_desc *desc)
>  {
> -	void *start =3D (void *)kern_hyp_va(desc->bpages_backing_start);
> -	size_t size =3D desc->bpages_backing_size;
> +	void *start;
> +	size_t size;
>  	int ret;
> =20
> -	ret =3D __admit_host_mem(start, size);
> -	if (ret)
> -		return ret;
> +	if (is_protected_kvm_enabled()) {
> +		struct ring_buffer_desc *rb_desc;
> +		int cpu;
> +
> +		size =3D 0;
> +		for_each_ring_buffer_desc(rb_desc, cpu, &desc->trace_buffer_desc)
> +			size +=3D rb_desc->nr_page_va * sizeof(struct simple_buffer_page);
> +
> +		start =3D hyp_alloc(size);

[Severity: High]
Is there a missing bounds check on the host-supplied nr_page_va here?

If the host sets nr_page_va to 0 for all CPUs, size will be 0, but
hyp_alloc(0) will still succeed by allocating MIN_ALLOC_SIZE.

> +		if (!start)
> +			return hyp_alloc_errno();
> +	} else {
> +		start =3D (void *)kern_hyp_va(desc->bpages_backing_start);
> +		size =3D desc->bpages_backing_size;
> =20
> -	memset(start, 0, size);
> +		ret =3D __admit_host_mem(start, size);
> +		if (ret)
> +			return ret;
> +
> +		memset(start, 0, size);
> +	}

[ ... ]

> @@ -81,7 +98,7 @@ static int hyp_trace_buffer_load_bpage_backing(struct h=
yp_trace_buffer *trace_bu
>  	return 0;
>  }
> =20
> -static void hyp_trace_buffer_unload_bpage_backing(struct hyp_trace_buffe=
r *trace_buffer)
> +static void hyp_trace_buffer_free_bpages(struct hyp_trace_buffer *trace_=
buffer)
>  {
>  	void *start =3D trace_buffer->bpages_backing_start;
>  	size_t size =3D trace_buffer->bpages_backing_size;
> @@ -89,9 +106,12 @@ static void hyp_trace_buffer_unload_bpage_backing(str=
uct hyp_trace_buffer *trace
>  	if (!size)
>  		return;

[Severity: High]
Will this early return permanently leak the memory allocated above?

If size evaluated to 0 during allocation, simple_ring_buffer_init_mm()
fails with -EINVAL and triggers this cleanup path. Since size is 0, this
returns early without calling hyp_free(), leaking the MIN_ALLOC_SIZE chunk
in the EL2 heap.

Could exhausting the EL2 heap this way cause a subsequent 0-page topup
request back to the host, resulting in an infinite loop in the host CPU's
pkvm_call_hyp_req() macro?

> -	memset(start, 0, size);
> -
> -	__release_host_mem(start, size);
> +	if (is_protected_kvm_enabled()) {
> +		hyp_free(start);
> +	} else {
> +		memset(start, 0, size);
> +		__release_host_mem(start, size);
> +	}
> =20
>  	trace_buffer->bpages_backing_start =3D 0;
>  	trace_buffer->bpages_backing_size =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706175415.2604=
046-1-vdonnefort@google.com?part=3D18
