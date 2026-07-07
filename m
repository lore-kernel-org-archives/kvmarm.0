Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE5241D4E7
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443767; cv=none; b=CYjQa4+S51oIPycAeQAn8XIF2zHcfvm1s4RV9cQMj/Xmr6EUJ1QvLefkYTYvdlVK8RVNa9yzkVC239xBeVO+281T72scYXCkCdHB602/UQqFEmJJhHvLogcwjE3PCEvvnf8RgXTIaIdRMFNWiraurXneiGwrcgTMDa4qKHulq2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443767; c=relaxed/simple;
	bh=mooGi4W7PfwMsu+13nnhPKAct/cD24PebXBdgqopi6Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V7Jdu/+bmm6OXcRgU+D4OwMUY0Vv/rHxW/Jc9QK7gL7xNUNtpRgDsLhgnwt8sEhHMTKQDAdnqlmKSN/c24tJH9o4P/UVy7RECQphLVBKrtPkvHTSmoycUIEN1P6wjngVX2SzvSWr2oxzDFkE57IP/HJEReHmWclZ8daG8CcYMqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdu0KYuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdu0KYuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3967E1F000E9;
	Tue,  7 Jul 2026 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783443765;
	bh=kg104i9BXcqw93uOf1mEWs4tmOHOJkhXETjJvG8sB/U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kdu0KYuLqsGhMmHSi62UW/Wezhr+C+KdyuKywdH6mpNpf8DFqXVa62xz435xT+hlK
	 oaLbk7hxTEgA1MZv+rVi7L3zJbaPTGSQGTYTKkk6tDtSOcJdik8VNyGwFBJQRKrW9Q
	 jIdTRXDdQncuOCacf530We5gRQZqmVSSmdk/BEBpS94q5KTgHPK+he7Ee2pEs3PuYd
	 2LlziVzf/LqNq4k1f+d3gof9pj/CKEJM8wJtZLY611YD0qRWd4hwSC++X4m4XqpWko
	 RUAlHuLQmJkMKSrumwMtI62oa5dtyxLwcIUFnLr7UctR2iEYqPdE8dmhqK59offxri
	 8+Vt2XN4igrPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix potential leak in
 hyp_trace_buffer_alloc_bpages_backing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260707165029.3410701-1-vdonnefort@google.com>
References: <20260707165029.3410701-1-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 17:02:44 +0000
Message-Id: <20260707170245.3967E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] trace_remote_alloc_buffer leaks page allocations on the error path=
 if a per-CPU ring buffer allocation fails.
--

--- Patch [1]: [PATCH] KVM: arm64: Fix potential leak in hyp_trace_buffer_a=
lloc_bpages_backing ---
commit 21f10293a05c7439f7a1d1be691e92ef2d36331a
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing

In the very unlikely event of a failure in __map_hyp, the allocated
backing pages are leaked in hyp_trace_buffer_alloc_bpages_backing(). Fix
this by freeing the pages on error.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932c..5fbbfd40376f7 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -160,6 +160,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(stru=
ct hyp_trace_buffer *trace_
>  	int nr_bpages =3D (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
>  	size_t backing_size;
>  	void *start;
> +	int ret;
> =20
>  	backing_size =3D PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpag=
es *
>  				  num_possible_cpus());
> @@ -171,7 +172,11 @@ static int hyp_trace_buffer_alloc_bpages_backing(str=
uct hyp_trace_buffer *trace_
>  	trace_buffer->desc->bpages_backing_start =3D (unsigned long)start;
>  	trace_buffer->desc->bpages_backing_size =3D backing_size;
> =20
> -	return __map_hyp(start, backing_size);
> +	ret =3D __map_hyp(start, backing_size);
> +	if (ret)
> +		free_pages_exact(start, backing_size);
> +
> +	return ret;
>  }

[Severity: High]
This is a pre-existing issue, but since this patch fixes a memory leak in t=
he=20
trace buffer allocation, I noticed a potential leak in a related error path.

In kernel/trace/trace_remote.c:trace_remote_alloc_buffer(), if an allocation
fails, the code jumps to the err label:

	rb_desc->meta_va =3D (unsigned long)__get_free_page(GFP_KERNEL);
	if (!rb_desc->meta_va)
		goto err;

	for (id =3D 0; id < nr_pages; id++) {
		rb_desc->page_va[id] =3D (unsigned long)__get_free_page(GFP_KERNEL);
		if (!rb_desc->page_va[id])
			goto err;

		rb_desc->nr_page_va++;
	}
	desc->nr_cpus++;

Because desc->nr_cpus is only incremented after all pages for the current C=
PU
are allocated, any successfully allocated pages for the failing CPU are left
out of the count.

When the error path calls trace_remote_free_buffer(), it iterates based on
desc->nr_cpus:

	for_each_ring_buffer_desc(rb_desc, cpu, desc) {
		unsigned int id;

		free_page(rb_desc->meta_va);

		for (id =3D 0; id < rb_desc->nr_page_va; id++)
			free_page(rb_desc->page_va[id]);
	}

Does this skip the partially initialized ring buffer for the failing CPU an=
d=20
leak its allocated pages?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707165029.3410=
701-1-vdonnefort@google.com?part=3D1
