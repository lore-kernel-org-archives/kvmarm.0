Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DD93FB074
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816804; cv=none; b=poFpyLyAKTUgNWDCUDo8Byy+J0JY2RNNeHQlWlz0yOrZ+6Asy6EDURy3gBtRcCyeILf0GXzaGJDHsHoA6ZjJRU7oXymA/N1ySFQ6PlzPFWpAq2QVA4N40+SodIhtTUkZAUYoNjVl+mHiJYjJf5RmzeCg8s37QxVYbVhATZZOxsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816804; c=relaxed/simple;
	bh=WqnnvaMHoE5lR0gpqfeVthVuGerkbMqkaseyMI8fX74=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KVlOlugI6GbKHqcRKJTULInX6F+mbV+RrvKjXSjZ6paM4PnI3hD4CXfvhrEeUSXb9bumKwGsbiCYSaWWocPyc+hxFJNh4ApE8/sERkYbOJSfE5QkvzAKnMVe9xhORb4gWnrjFLoBunJEfL3Fg/s9OiY3o9Yqh947w6+AsB3jQA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9os/UZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9os/UZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51B51F000E9;
	Tue, 30 Jun 2026 10:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816796;
	bh=TtRwF33keShh6nY5OKPg9LN7EGLCxg8s7b/r69hO7/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L9os/UZv1PzDIW9Mqxtat+zUyu4PkaMoqQive27d77wWHb4knztNrXeCmjC3J8Lz/
	 XOZOAqndl6SN3axqnDDWY1v4AZmJMRGtFbq8lb/WIkj1SHfQzzgvtq5PpaqFIu08+C
	 01xDAkCrncQ35c4a60KbHYIvGOUVd2KQlN/crAAW7tPapz+h3FTPog3Id0cii4XsBs
	 /cSvU5PdQlcvhzuDGC+Wo2gdG4eWGI64wE0Dky2aW76VzQp3bN1YS8gzJepjH8y4iX
	 PjNiEZrctrwht4Yix0uSKLB82YpEx8VA1AQ+TIk8TPOlRnXjDTWXiTngAp3NQER07W
	 ReW3tAywxrnrw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/6] KVM: arm64: Fix bounds checking in
 do_ffa_mem_reclaim()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260630102058.3219867-5-sebastianene@google.com>
References: <20260630102058.3219867-2-sebastianene@google.com>
 <20260630102058.3219867-5-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 10:53:15 +0000
Message-Id: <20260630105315.D51B51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch introduces a spurious `ffa_rx_release(res)` call on an=
 error path, resulting in a double release of the FF-A RX buffer.
--

commit 027ec78db7562e036e73ee20428d8aa5b545f58b
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()

This commit splits the bounds checking for FF-A memory reclaim descriptors
into two parts. It first verifies the fixed portion fits before accessing
the descriptor, and then checks if the variable array size fits to prevent
out-of-bounds memory accesses.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178a..2d211661952e3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -636,11 +636,17 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2=
_regs *res,
>  		ffa_rx_release(res);
>  	}
> =20
> +	reg =3D (void *)buf + offset;
> +	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
> +		ret =3D FFA_RET_ABORTED;
> +		ffa_rx_release(res);

[Severity: Medium]
Will this result in a double release of the FF-A RX buffer?

Looking at do_ffa_mem_reclaim() in arch/arm64/kvm/hyp/nvhe/ffa.c,
ffa_rx_release() is called unconditionally before the fragment loop starts,
and then again at the end of each iteration of the loop.

When the code reaches this new bounds check after the loop, the RX buffer
has already been released. Calling ffa_rx_release() again on this error
path sends a spurious FFA_RX_RELEASE SMC to the SPMD when the hypervisor
does not own the buffer.

Could this violate the FF-A protocol state machine and cause the SPMD to
return an error or panic?

> +		goto out_unlock;
> +	}
> +
>  	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
>  	if (res->a0 !=3D FFA_SUCCESS)
>  		goto out_unlock;
> =20
> -	reg =3D (void *)buf + offset;
>  	/* If the SPMD was happy, then we should be too. */
>  	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
>  					reg->addr_range_cnt));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630102058.3219=
867-2-sebastianene@google.com?part=3D3
