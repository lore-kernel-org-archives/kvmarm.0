Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B8543846B
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791457007; cv=none; b=MRYBkkthhgXK5hJU6pk96Ipqs7vvDvGARl5Ep6idYRmLHCW49NOtGRKMUhZbnqEA7X0Ka5qnkAILREFEbKtFWjJAE5MH+V2mKsiALjKzJA7RrbSKd10Q0c3FyOUgXlFF0zx6ESM4NuuuHe7hM4B+9CbA7TwXfhNd66etnUOAYkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791457007; c=relaxed/simple;
	bh=RhE6pqdKOcQAUT78ZXVDwF4d/KdMjHMfldq+BxdKaEM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eVCwr/KTYx/+snnFc+ToYwzSV68y22jkfusC4BNqB0dH+Taq1ZOaNr7d5r8mR8Uk0HQJ0I9E/iUZ4KfBL9BTDGJVyw7hFYwKYX22CMaUz2ntHIRvS5SPDqZ3mSpr944hkhx6Y6bLWbmamIj6zTkLohmioF4F8ypNPV3kqLMJ61k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Er1OBMiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Er1OBMiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB80E1F000FF;
	Thu,  8 Oct 2026 10:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791457006;
	bh=BjKXW7uFi0WvnfmRNiFxw4trsjsURpA7mnAthL473Lo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Er1OBMiUY0NInf0l0SRK/Dvn1o366fJeA5dkA9R4ISQTGy43X6SYG/UePJU6QCE5F
	 6b4ffe7hlbk/eHP4XbRLISeFwjr4kzRh4hTcNcFhIy5bwdbYoTflblmg3Cbd51nT+Y
	 2w5HBM8N6/N6pVnJmbjTVqn1FhSO7IOVqFt18U2g9bYDSQM8+fq64cOQ/jetpr+Wqp
	 bYFvrEtnXYmt9ntP6U7mhGt1jtacYj+P/XMb6OXSkHn8rzaeIILzCuLgJ6tSUahMRy
	 T4WmIiGtvD0hK82YLU4Qjvs4JbxBjlbe9caU01Oqyu7UkBxCG71NInKBSq4kRkbSFY
	 UJinu8WIPGcBg==
Message-ID: <sashiko-outbox-164063@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 2/2] KVM: arm64: Fix bpages backing allocation size
 in hyp_trace
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261008104212.3134550-3-vdonnefort@google.com>
References: <20261008104212.3134550-1-vdonnefort@google.com>
 <20261008104212.3134550-3-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 10:56:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] tracing: Integer overflow in trace buffer size calculation bypasses=
 capacity check
--

commit 652836a529b433a8c0e0cb4f4308fa9b9556763d
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Fix bpages backing allocation size in hyp_trace

This commit updates the trace buffer backing allocation in hyp_trace to
calculate the required number of pages using
__calc_nr_pages_ring_buffer_desc(). This appropriately accounts for the
buffer page header and relies on trace_buffer_desc_size() for validation.

> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 26fc13c164589..b9404496f9775 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
[ ... ]
> @@ -157,7 +157,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(stru=
ct hyp_trace_buffer *trace_
>  		return 0;
>  	}
> =20
> -	nr_bpages =3D (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
> +	nr_bpages =3D __calc_nr_pages_ring_buffer_desc(size);

[Severity: Low]
Does this calculation overflow if size is near SIZE_MAX?

Looking at __calc_nr_pages_ring_buffer_desc() in include/linux/ring_buffer.=
h:

static inline unsigned long __calc_nr_pages_ring_buffer_desc(size_t size)
{
        /* Takes into account the reader page */
        return max(DIV_ROUND_UP(size, PAGE_SIZE - BUF_PAGE_HDR_SIZE), 2UL) =
+ 1;
}

If size is extremely large, the DIV_ROUND_UP macro wraps around, causing the
function to erroneously return a very small page count (e.g. 0 wrapping to 3
pages).

The commit message notes there is no need to validate nr_bpages again becau=
se
it was validated by trace_buffer_desc_size(), but could this overflow bypass
that check?

Looking at trace_buffer_desc_size() in include/linux/ring_buffer.h:

        /* Capped by ring_buffer_desc::nr_page_va */
        if (nr_pages > UINT_MAX)
                return SIZE_MAX;

Because the wrapped nr_pages is small, this capacity check would be
circumvented, bypassing the intended -E2BIG rejection. Downstream consumers
like hyp_trace_buffer_alloc_bpages_backing(), trace_remote_alloc_buffer(),
and __tracing_load() would then operate safely on this truncated page count.
This results in a silent failure where the kernel allocates a tiny function=
al
trace buffer instead of returning an error for the impossibly large
allocation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008104212.3134=
550-1-vdonnefort@google.com?part=3D2
