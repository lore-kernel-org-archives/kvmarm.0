Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F244683C
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568752; cv=none; b=RJ/imVglgwQsK4QAVK7T0GM+E6WYN+YhEopE6prum2+UB0qJacSTmVROrAscwOfvPQKKXfUTktuGeKQq0Z7mHhksi5OaW9vG9tB8tYptpCHqBhhKV9DVbFEX5UOGRzAwWOB7xUEx9yy01WDPsA+0b1dtXFy50+BTAFkpcVbgS/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568752; c=relaxed/simple;
	bh=M92jNcerw9Qoy4KQ/H60ZRSqinS7AdvXNplK7CWabOY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fN6vRIbR8yTPKKUQDMuH407cqLxffO8G3lqk9QlY6aQ62vWvvQKopzW+1mPYkQKwvZT9yPxPWJ7ZfzR3lw9RE9JoJS95uw26eUBlX1Lyvrx6vaAKwBVWbex+vRkiUfD8dzovlZjGqOuJxEnCSBapk6liwysbr9iqT5XuW6S4uyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ue0CQfmC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ue0CQfmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28411F000E9;
	Mon, 20 Jul 2026 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568744;
	bh=V0g8vf5GjvnnOywgQbylUJcF2V3WRhPvHtcIyaumYKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ue0CQfmCAwXavo+QdU0z2tm8P8xH1/zpiRNA+UVzttXcsFmc1r6GwIHMPffU+Xplv
	 m9rfT5TiidAvEhT+nTxuUWqJeFtKCztD/pJlZdZMMsYSpNs4QIjnUcKu791HIkUw6b
	 e+1KzGGLwhYz59QPyi9fol5SoDi6BVt56AjQF3mFhh/e4/1nIXEqfgJhrohw+6CGyG
	 mmzqnSflAXAobhfLvUnqFEtHSTL4tRrvaPT8Rf19htZ2lGuHu3XkIFIhbIrsfDmw7d
	 DHrmo/N6rgYIh/L28iikqDcvB9j32g3hk/R2wi+aI836G6tbmepJaihhMWwCaBSFGd
	 +na78dcrk4gCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/17] KVM: arm64: Add reclaim interface for the pKVM
 heap alloc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260720171513.1415357-9-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-9-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:32:23 +0000
Message-Id: <20260720173223.A28411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] pkvm_hyp_reclaimable() under-reports the amount of reclaimable m=
emory because it ignores the pages held in the allocator's memcache.
--

--- Patch [8]: [PATCH v3 08/17] KVM: arm64: Add reclaim interface for the p=
KVM heap alloc ---
commit 9ab4026a37c9c906601e81f7a36cbef749980114
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add reclaim interface for the pKVM heap alloc

Introduce a host interface to reclaim donated memory from the pKVM heap
allocator back to the host. It specifically provides two helpers that
will make it easier to create a shrinker for pKVM.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 439b91fc8aecf..346365e76ef2a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -657,6 +657,42 @@ static void handle___pkvm_hyp_topup(struct kvm_cpu_c=
ontext *host_ctxt)
[ ... ]
> +static void handle___pkvm_hyp_reclaimable(struct kvm_cpu_context *host_c=
txt)
> +{
> +	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
> +	unsigned long reclaimable =3D 0;
> +
> +	switch (id) {
> +	case PKVM_TOPUP_HYP_ALLOC:
> +		reclaimable =3D hyp_alloc_reclaimable();

[Severity: Medium]
Does this under-report the amount of reclaimable memory?

When the host calls pkvm_hyp_reclaimable(), it invokes
hyp_allocator_reclaimable() at EL2. This function iterates over the unmapped
chunks but neglects to add allocator->mc.nr_pages (the raw physical pages
sitting unused in the memcache) to the total:

arch/arm64/kvm/hyp/nvhe/alloc.c:hyp_allocator_reclaimable() {
    ...
    chunk =3D allocator->head;
    while (chunk) {
        reclaimable +=3D hyp_allocator_chunk_reclaimable(allocator, chunk,
                                                       NULL, NULL);
        chunk =3D chunk_get_next(chunk);
    }

    return reclaimable;
}

Conversely, hyp_allocator_reclaim() prioritizes returning these memcache
pages to the host first. By omitting them from the reclaimable count here,
the host shrinker might receive an artificially low or zero value.

Does this omission prevent the shrinker from attempting reclamation even wh=
en
memory is fully available?

> +		break;
> +	default:
> +		reclaimable =3D 0;
> +	}
> +
> +	cpu_reg(host_ctxt, 1) =3D reclaimable;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D8
