Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328803C9892
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684977; cv=none; b=Z3dCAw1r8k8VKMzJU4U9NVXVrsX7FwFhh3LyXlaThehkSGUVldmD3XmRpjSvXK+3t/KZwa5JqTClJBbtICJPDS2ErqiWugFFKc7EybupZh0YLpcjanlxeYuyQ8a2Ye9sxO1bxknJhOB/PDqPzt+WvH2J2gNUl7UehDEhQUhTYyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684977; c=relaxed/simple;
	bh=xClzyOWOJhoX6+r8PQAkqHink2EcNt3rRNNgyEXXjtA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bDB0Ln8RzcpjLM9F2hvPzkAvrdorCQWhaBCIs/bHWHaVcEgyE2NheyJaLg+Sj8Wg/HU20/pT+37U0s8AsLMilrzXZEQV6btQDAaKEr387o4lPYdmJyKlLWmEvpxrVMJfftDlx9rLrN357/UL26w5RL/95KyhXW7kRfHMm/GPJuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtblzklq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtblzklq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883B01F000E9;
	Fri, 10 Jul 2026 12:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783684975;
	bh=VUGaw2HdYkqCRIb6GPXkrr2phGIBb3oiZh6LVBOwwOk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dtblzklqlXxULBjkS7ZK8JL+xgraBtQTnW4RXq2B0GFH7BxEXqG9TsBjatCOJiklq
	 BU6BdrqpUxjSJmXplnCizloVRAPSDfE849Y2+T1iprUNtCoB0N6PZL9kHW7dGueFsl
	 Z97yICHhNlUJ/XI7cuprGihunOM1Sqe/1tb7JM4+zbyITcFpdmsryfYUeorG+1+P6X
	 QdREOztErjoVDRPYUs6lx2HWv8Qf19mfcrfMDizL36dQ+oPbtHqvAm3F+X0ZUgnr2d
	 JCaZC7GFvMQeZ9BJ2u4NrGto7V1kLavczLHJeEaFzz+zaG3UTDSY/+PvZi4meGFF6A
	 FArRrX7PD4d6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: Fix hyp_trace_desc allocation size
 in hyp_trace_load()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260710114819.2689386-3-vdonnefort@google.com>
References: <20260710114819.2689386-1-vdonnefort@google.com>
 <20260710114819.2689386-3-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 12:02:54 +0000
Message-Id: <20260710120255.883B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Incorrect bounds calculation due to pointer arithmetic on stru=
ct pointers leads to bounds check bypass and critical TOCTOU vulnerability.
--

--- Patch [2]: [PATCH v2 2/2] KVM: arm64: Fix hyp_trace_desc allocation siz=
e in hyp_trace_load() ---
commit 6dde5b05614b22025af630cb338d61676ac3c7d8
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()

The footprint calculated for struct hyp_trace_desc sizes only
trace_buffer_desc and do not take into account the other fields. It
worked so far thanks to the follow-up PAGE_ALIGN().

> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index a7237aca68989..22437c5e1e7bc 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
[ ... ]
> @@ -262,7 +266,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsig=
ned long size, void *priv)
>  	if (ret)
>  		goto err_free_desc;
> =20
> -	ret =3D trace_remote_alloc_buffer(&desc->trace_buffer_desc, desc_size, =
size,
> +	ret =3D trace_remote_alloc_buffer(&desc->trace_buffer_desc, tb_desc_siz=
e, size,
>  					cpu_possible_mask);

[Severity: Critical]
This is a pre-existing issue, but does the bounds check in
trace_remote_alloc_buffer() calculate desc_end correctly?

In kernel/trace/trace_remote.c:trace_remote_alloc_buffer(), desc_end is
calculated as:

	void *desc_end =3D desc + desc_size;

Since desc is a typed pointer (struct trace_buffer_desc *), this pointer
arithmetic scales desc_size by sizeof(struct trace_buffer_desc), inflating
the bounds check and bypassing the intended protection.

A similar issue appears to exist in arch/arm64/kvm/hyp/nvhe/trace.c inside
hyp_trace_desc_is_valid(), where pointer arithmetic scales desc_size by
sizeof(struct hyp_trace_desc). This could potentially allow EL2 to read
un-donated host memory, opening a TOCTOU vulnerability if the host modifies
bounds after the validation check.

Should these pointers be cast to a byte-sized type like (void *) or (u8 *)
before adding the size?

>  	if (ret)
>  		goto err_free_backing;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710114819.2689=
386-1-vdonnefort@google.com?part=3D2
