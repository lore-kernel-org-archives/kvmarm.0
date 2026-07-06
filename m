Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ABF42464E
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 18:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361586; cv=none; b=pv6xAhmXZqECxy2mp5Kjr3OAS76LmMjzaPPjuzHYQLKbMzGN8m6kyxlNMtG0GLvmGbyZ89nHH7BvXnkrhioCIuevyh8yx61VYvo7y5YN89Mz3Ou9kn73+LbiNDjaNWDBAGmLnJYunB5S0BZc8/V1kFZeDa8TLto4CYmwnkL0WNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361586; c=relaxed/simple;
	bh=Fu6zgjdxVJPSVEBkSaL3/cmL0QSQYT9HraRsKNCAyus=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bqv9qDUC5EEp9hcNKEa940FlosAQgghM/2gJcEUl19W2X7mpcamo1nW/8tWx8IwiMg8aKmre10n1tLWqzRQrc/uas5ns3NJzv+MSTkPf+vzfQ3rhUkeOT5baizq060v7ZH9qXxeAl9WL+ByVriprjW1bxc4qdF9Z/CDcomC1hvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=borAcBB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="borAcBB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE57B1F000E9;
	Mon,  6 Jul 2026 18:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783361585;
	bh=RXXYUVU3XxvjDdy0gHxs3X/J/uBNeKj7EIdHny2Htbs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=borAcBB2d0YBBZinJeNkpf7wWwz4SEf0At8bSQ4uuDBoreRFei9zrbCqsixBszNhE
	 BuL7iWRXkP3DBrGJ0M4KydDcNEVxOvIELnvm3PzbNpcqh2nOrzLrc3AAtMH+s4LuyO
	 RZYns9WJxp5006zfL9anIVx/Epyn0Q7eOUY2zI1fBkD5D2SAt6T2ebuG9M7f124qU+
	 f4SP7oo1U7ibUA6uukBV0tpX6FBUzhf2zeb90/JssnNhIXu9ZfoAH38vXrd4fhLiE8
	 H3/OWapJ4gNwrhPAuW2ShCQyrMC6DaaxfRoSQOWew4QNouWRfFRI6CLBYXencT0BL/
	 t9tyqI/3FpZwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/18] KVM: arm64: Add a shrinker for pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260706175415.2604046-12-vdonnefort@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-12-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 18:13:03 +0000
Message-Id: <20260706181304.DE57B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The pKVM memory shrinker is registered before pKVM is finalized, e=
xposing 'pKVM-finalised-only' hypercalls to early execution which triggers =
a WARN_ON and potential boot panic.
--

commit 32c5640182999493c354bd3285732dfbfa3fd23d
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add a shrinker for pKVM

Integrate the pKVM memory reclaim interface with the host's memory
management subsystem. This allows the host to automatically recover unused
memory fom the hypervisor's heap allocator when the host is under memory
pressure.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

[ ... ]

> @@ -2713,6 +2715,18 @@ static void pkvm_hyp_init_ptrauth(void)
>  	}
>  }
> =20
> +static unsigned long
> +pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +	return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
> +}
> +
> +static unsigned long
> +pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +	return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
> +}
> +

[ ... ]

> @@ -2883,6 +2897,16 @@ static int __init init_hyp_mode(void)
>  			kvm_err("Failed to init hyp memory protection\n");
>  			goto out_err;
>  		}
> +
> +		pkvm_shrinker =3D shrinker_alloc(0, "pkvm");
> +		if (pkvm_shrinker) {
> +			pkvm_shrinker->count_objects =3D pkvm_shrinker_count;
> +			pkvm_shrinker->scan_objects =3D pkvm_shrinker_scan;
> +			shrinker_register(pkvm_shrinker);
> +		} else {
> +			kvm_err("Failed to register shrinker for pKVM\n");
> +		}
> +
>  	}
> =20
>  	return 0;

[Severity: High]
Could registering the shrinker here expose pKVM-finalised-only hypercalls
to early execution?

Since init_hyp_mode() runs at device_initcall, the shrinker becomes globally
visible before pKVM is finalized at device_initcall_sync in finalize_pkvm().

If memory pressure triggers the shrinker in this window,
pkvm_shrinker_count() and pkvm_shrinker_scan() will invoke reclaim
hypercalls. Because pKVM is not yet finalized, the EL2 handler will reject
hypercalls beyond __KVM_HOST_SMCCC_FUNC_PKVM_ONLY with
SMCCC_RET_NOT_SUPPORTED.

Will this failure cause the host-side kvm_call_hyp_nvhe macro to trigger a
WARN_ON, potentially panicking the host if panic_on_warn is set?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706175415.2604=
046-1-vdonnefort@google.com?part=3D11
