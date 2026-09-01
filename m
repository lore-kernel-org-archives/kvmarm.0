Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992302E7F20
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251730; cv=none; b=ljkRKI1DRyaJmtO05O/aMuiqkPwYxjII4Te774H48QgcQGRAvFY0IlavWMfSpCcp0jhLmU8R4rhhUPmYRgGMSq51YSHbY2Wpn3zlH6jgxtUk5M+VZcTFvj3fFgb4SSGdJvc5eJ/FrpgfbW1Kbygj2FcDmHC3BIZm6gChUEqh79o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251730; c=relaxed/simple;
	bh=U5uQ6YXT4zbHnH43DfEfe3uY4FDtefjLTooqeYRN7Lk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aZL2L/Wel1cGBE7s+re6vdcYjrvYXFWnEGdhm5w/ebqcxIN3pRjYsw/zAI14eBhstdfr5d/m5fsB1jh6oYpzuc1ckmEFY9DC3LNm/lCQSpJs0BGKYhOAu/zzZU+fbheiJFrh2/n+uFCKKvHHOmQYx1EMW2zwlrJuT1ParSS+F2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WS/pi6kz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WS/pi6kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48CF1F000E9;
	Tue,  1 Sep 2026 08:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788251729;
	bh=OLWtjh8biX9v/BwOxQGt2q/O0HDO2FJkWqzTs1su8i8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WS/pi6kzBWfX1soxgErpYzXUw0AsJOMk1ePudSZtL5mibGp646zFLcRjZJQ4W40B+
	 6XtZYd4bbSlRonw7W9XB4jqpN3cMUMNkkEnmRfiS0nhjqN/Ku9QY99vaFEJpgO8xhi
	 aUshKQeK5TU5baQDhqmapMXC02XHfZKZwFkVqAGsaeDogaSs0xtBk5Qj4CGBKvtMFN
	 OS1g+Ti/V5RTAGfVGtbehThkviL49vFVaCmh69Evle4tAagQkynP6X4mlFq/28HsCS
	 6fM21kG7sEBnlmrtfjyUl+1QZ4vtWzufEuYVe17AnHqbkJDNb9a6FwZydClRBn4vdy
	 KjqLU/Ze1pugw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 18/18] KVM: arm64: Alloc simple_buffer_page using
 pKVM hyp allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901080941.997769-19-vdonnefort@google.com>
References: <20260901080941.997769-1-vdonnefort@google.com>
 <20260901080941.997769-19-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 08:35:28 +0000
Message-Id: <20260901083528.D48CF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Infinite top-up loop in host due to uncoalescable order-0 donation=
s for high-order `hyp_alloc()`.
--

commit a1f4f52ea836afa69ba85406471c09d62a9b1b7e
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator

In protected mode, transition the allocation of the simple_ring_buffer
structures from the host to the hypervisor using the new pKVM heap
allocator.

> diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/tr=
ace.c
> index e34f9133e5d97..45322dec6201b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/trace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/trace.c
> @@ -62,18 +63,34 @@ static void __release_host_mem(void *start, u64 size)
[ ... ]
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
> +		if (!start)
> +			return hyp_alloc_errno();

[Severity: High]
When allocating the trace buffer pages in hyp_trace_buffer_alloc_bpages(),
size is calculated by summing the required pages for all CPUs. For a larger
trace buffer, this size easily exceeds a single page.

If hyp_alloc() fails to find a high-order contiguous block, it returns
-ENOMEM. The host intercepts this via pkvm_call_hyp_req(), donates the
requested number of pages, and retries the hypercall.

However, host-donated pages are inserted at order 0 and are not coalesced.
Because they are not coalesced, they cannot satisfy the high-order contiguo=
us
allocation required by hyp_alloc(size).

Can this cause the hypercall to repeatedly fail with -ENOMEM, causing the
host to loop indefinitely inside pkvm_call_hyp_req() and hang the system?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901080941.9977=
69-1-vdonnefort@google.com?part=3D18
