Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0703FF883;
	Mon, 29 Jun 2026 11:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733745; cv=none; b=j5fdJKxJ9uMcfiTWhX6P1BlXXHp6WEZZkC4otaMdgNl9pCDNWTQJYGzcU1mdqjILkF8uq44KKMxuIoLqLY1Uda5KY8ahHjix1rMk5ZlyR6j6BR+U0KlHpHuyoLgahPHS0dLPEexLSWx59Tkr9ZXoGUlbJFBQ8eNmokfze+Rl+kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733745; c=relaxed/simple;
	bh=rk2sg7cfPY3T2EbXRZeU4yB6uSy278aELsTB2jnUL5w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dTMTnuP485ARCyuwJGKMqyiFxhwJNzD0gNvE4We4p0mXyVj/NcnX5MerIOiCUtc0Chur7dxQ/uZIn0hAg9mgnlXr56pJTIV+CaKAHerTUKgC6Zz6TDDKXF0mes7PzM40iiPWhY6EbeOIkfWZRyDU2do5oc42Gdp3V+wGwvvmaac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GI4Sx9cp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GI4Sx9cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701E81F000E9;
	Mon, 29 Jun 2026 11:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733744;
	bh=ew8vzXrsx3LkA9D9r0eiybLVeDwx/lKWoCfq0vZsbHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GI4Sx9cpkh67Ym/JGcFyrmz4dShf9V+cMuIJpFeaz60xPxgSzHukVnho5+Up6eyDK
	 mswjMYiAiuNh1shbxCFQHZo1u3GOKTc+e7R5bBS3M0QdXYL3f13+YCdBsf4ywU8mDC
	 pV/88pMG4GbYVadl/72bjCloAZjXWt2reXnc/dZGZ70xmPJOLE0LwMO6J+qTU9lQSg
	 Sxl8lG5q8M6G+Wnk6CxFxMOMjgBaIBFpmWI4s3AQ61IiECDRIAGnQVlNesLGecBYwv
	 QXY2yjx3XLIpkPoI0d4jP7xiCgS7zIyz710xVqvDvOighPQ2IGjuSVnQPqjZkT1PiV
	 2jbj3DCm5lJIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/13] kvm/dirty_ring: Add arch-generic interface for
 hw-accelerated dirty-ring cleaning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260629111820.1873540-12-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-12-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:49:03 +0000
Message-Id: <20260629114904.701E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Hardware-accelerated dirty ring reset completely bypasses the re=
set tracepoint.
--

commit 8d48fca1a0a1a0e2a8d66dd93d79ffc96e524e83
Author: Leonardo Bras <leo.bras@arm.com>

kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cl=
eaning

This commit introduces kvm_arch_dirty_ring_clear() to allow architectures
to implement hardware-accelerated dirty-ring routines. It adds a call to
this new function in kvm_dirty_ring_reset(), which will fall back to the
software version if the hardware version is not implemented or fails.

[ ... ]

> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 42de1a511037a..fe4e7da6cc4a6 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -133,6 +134,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_=
dirty_ring *ring,
>  	 */
>  	lockdep_assert_held(&kvm->slots_lock);
> =20
> +	if (kvm_arch_dirty_ring_clear(kvm, ring, nr_entries_reset) >=3D 0)
> +		return 0;

[Severity: Medium]
Does this early return bypass the trace_kvm_dirty_ring_reset() tracepoint
at the bottom of the function?

When hardware-accelerated dirty ring cleaning succeeds, returning early here
skips the tracepoint entirely. This could break observability tools and
scripts that rely on this tracepoint to monitor KVM dirty ring resets.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D11
