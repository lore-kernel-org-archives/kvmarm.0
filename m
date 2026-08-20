Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472F240B6C9
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 13:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230985; cv=none; b=V6yAZHPe8iji2v8vh8CDMcPUmj//TFyJWwpGcY/GK/V2NFBKBPXXvs/Mnfam1GlTCfuAn82PBECz3rGhQMYRNpwd7E/WTEakgm/42olJQ6MkLdKN3mEE+sZRqx+pFnRYNjUkmwfJcncxqVetOcrfCZURFROW5XK1ZYyOIW2DA6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230985; c=relaxed/simple;
	bh=dNV3Q3JpC65eJpVXxHd/KsDZPhjr9RfMrU19vt1JI3o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sm/Ax1bEUGgYp1t7qW81A31zuvrsYC7IWwUSuhtm7LZCzquXlacc62bDcu7Ffc9IG9KyvJ6IZHDgGxSH2W/h9zS9LhdSlhedvAq1G4hWyCQWmedpjlHNawfcb2qfd/uWAFYBS+sVwI4fZSvaO/b3ec4WkuaYMQM7YwaOWu5En1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gquh5VHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gquh5VHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89531F000E9;
	Thu, 20 Aug 2026 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787230983;
	bh=LYQ8zTylZdAgrZi2fHYlDqflIjLUeBpSE9F90fZbMFs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gquh5VHDlDV3S0/hLgyhvW0C5NkOiu3tlNym+KC+Aiv4nAy9Bl0Czz3kGwJfJipKS
	 gtrE4WMaqnK7nI/nCtJXCUW/SxbkhXVfSBP4eXq+y1p/u41M8OpARsqN6DLzeLBrzS
	 rVjctcIsSt+p6ru+NK3V79XZTTCQfrxF4b9XUlkgnt3ewa2mryVzY72vNf1ObXNjH8
	 9C2QMhtvUOa+4YZXOB3R0LFS0S41WEHeLBHwtm5kHAEeLTP2Z60CZQbfG6kMP/tX+y
	 DGXFCQ7c8SdhbrhwHIcVrfg/+DPpnuB4/6gRuX55GEf3+W0zqqbynYB6AvJi5pd2lG
	 aNOEf3zhhFWIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs()
 allocated on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260820125053.2951078-3-fuad.tabba@linux.dev>
References: <20260820125053.2951078-1-fuad.tabba@linux.dev>
 <20260820125053.2951078-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 20 Aug 2026 13:03:02 +0000
Message-Id: <20260820130302.E89531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] vgic_v4_init() truncates its_vm.nr_vpes on vgic_v4_request_vpe_irq=
() failure, causing a resource leak of previously allocated VPE IRQs and SG=
Is during teardown.
--

--- Patch [2]: [PATCH 2/3] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs(=
) allocated on failure ---
commit 09380ca1832d1b65e5229cfbb8e1f8ab95b65846
Author: Fuad Tabba <fuad.tabba@linux.dev>

irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure

This commit fixes a resource leak in its_alloc_vcpu_irqs() where SGI
domains and vPE irqs were not properly freed if the allocation loop
failed midway.

> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 754839e409f88..f707a3cb281aa 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c

[ ... ]

> @@ -189,11 +191,14 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
>  		vm->vpes[i]->irq =3D vpe_base_irq + i;
>  		ret =3D its_alloc_vcpu_sgis(vm->vpes[i], i);
>  		if (ret)
> -			goto err;
> +			goto err_free_irqs;
>  	}
> =20
>  	return 0;
> =20
> +err_free_irqs:
> +	its_free_sgi_irqs(vm);
> +	irq_domain_free_irqs(vpe_base_irq, vm->nr_vpes);
>  err:

[Severity: High]
This is a pre-existing issue, but does the teardown path in
its_free_vcpu_irqs() fully clean up resources if its_vm.nr_vpes gets
truncated?

If vgic_v4_init() in arch/arm64/kvm/vgic/vgic-v4.c fails to request an IRQ
via vgic_v4_request_vpe_irq(), it explicitly truncates nr_vpes to avoid
calling free_irq() on unrequested IRQs:

arch/arm64/kvm/vgic/vgic-v4.c:vgic_v4_init() {
    ...
    /* Trick: adjust the number of vpes so we know how many to nuke on tear=
down... */
    dist->its_vm.nr_vpes =3D i;
    break;
    ...
}

When cleanup subsequently calls its_free_vcpu_irqs(), it relies on this
truncated nr_vpes value:

drivers/irqchip/irq-gic-v4.c:its_free_vcpu_irqs() {
    ...
    its_free_sgi_irqs(vm);
    irq_domain_free_irqs(vm->vpes[0]->irq, vm->nr_vpes);
    ...
}

Will this sequence leave the previously allocated IRQ domains, fwnodes, and
SGI domains orphaned for the vCPUs beyond the failure index, since they are
no longer tracked by the truncated nr_vpes count?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260820125053.2951=
078-1-fuad.tabba@linux.dev?part=3D2
