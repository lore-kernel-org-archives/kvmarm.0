Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCACE440631
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 13:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787231177; cv=none; b=Vg24yUSxSte1jcGW48rmHAWviGDBCIhlDO8jbekd503qls8dpQFhsac/8Qk5d9Kt8I6rn4m9fVvTF1xEq1sLd6wiln1cNnMokLZzzXlfGW4rQRtY8efpV+6Y9eqbctiw23WiP/+bDnF/OdenLDtyFQbxLdJU7GYPIi55WOoO8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787231177; c=relaxed/simple;
	bh=+T4YmKEc1858Sz7YZkYMjWMfIDgXIvzs/LJBxvJJiyo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YjNnLndkRqOk87Yff4QQKxWg4n3P42AbVkBb5nIsc6fKdIbhMbPWeldWDTbqBF54+Beg6INNiea2aPw1HMx0uyEKT3qLqpsindCGxtjD3p6C5aXH7Sc1NjI4X1UILV64hvUQLrTuzRN3GmJ344Y4AyYuIxNxZ+0TOw4dLlNYNy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9A9tsps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9A9tsps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7241F000E9;
	Thu, 20 Aug 2026 13:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787231176;
	bh=PPVlpU+A5P1gA9Qy7SYxiX0pPfLH9Gn9m3z7xlt5/Gs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l9A9tspsFSKzzOAhDg9/SO+LF+Yk38EsUCVaGphJCi+dMtrF2H7SbP9JczQ3ZTYbe
	 UwXKXxDWt4wPtuBGfGLg1BFydxi+si5bBrw7HusyVTprsIFLFi9O12e2WKtUdT28BZ
	 fT7r8cxYxzLOUV1M4OpxG9em8ypytJOFuJvR5ysi1q9FvzJGrsqKZRSw9zzQTZUD3x
	 vOYjvCKNmBLvdPqdS5TcFzZFjcdUKBwrpE5SbB3uDcsLITNgbHY2bjvVQXimx7LAlu
	 /Ury88lrhYr4x4gvWa6jMVds1+SH/miOrMAWZky+OAR1YeAKgEvBbvRI6TLFrMFwQ/
	 JdTXsTZWL9Ejg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] irqchip/gic-v4: Clear the domain and fwnode
 pointers after freeing them
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260820125053.2951078-2-fuad.tabba@linux.dev>
References: <20260820125053.2951078-1-fuad.tabba@linux.dev>
 <20260820125053.2951078-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 20 Aug 2026 13:06:15 +0000
Message-Id: <20260820130616.1A7241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but there is a massi=
ve leak of IRQ descriptors and domains, leading to a Use-After-Free, caused=
 by KVM truncating `vm->nr_vpes` in `vgic_v4_init()`.
--

--- Patch [1]: [PATCH 1/3] irqchip/gic-v4: Clear the domain and fwnode poin=
ters after freeing them ---
commit c349510ce4924473f4dc4c6ff4ff6a9d4b983dd5
Author: Fuad Tabba <fuad.tabba@linux.dev>

irqchip/gic-v4: Clear the domain and fwnode pointers after freeing them

The GICv4 allocation and teardown paths free their irq domains and
fwnodes but leave the pointers set, and the allocation error paths test
those pointers before removing them. struct its_vm and struct its_vpe
are embedded in KVM's per-VM and per-vCPU state, so nothing re-zeroes
them between two attempts.

> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 8455b4a5fbb0d..754839e409f88 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
[ ... ]
> @@ -224,6 +234,8 @@ void its_free_vcpu_irqs(struct its_vm *vm)
>  	irq_domain_free_irqs(vm->vpes[0]->irq, vm->nr_vpes);
>  	irq_domain_remove(vm->domain);
>  	irq_domain_free_fwnode(vm->fwnode);
> +	vm->domain =3D NULL;
> +	vm->fwnode =3D NULL;
>  }

[Severity: High]
This is a pre-existing issue, but does this function permanently leak IRQs
and SGI domains?

In arch/arm64/kvm/vgic/vgic-v4.c:vgic_v4_init(), KVM intentionally truncates
dist->its_vm.nr_vpes upon failure to allocate VPE IRQs:

    dist->its_vm.nr_vpes =3D i;

This limits the teardown loop in vgic_v4_teardown(), which later calls
its_free_vcpu_irqs() with the fatally truncated nr_vpes value.

Because its_free_vcpu_irqs() relies on vm->nr_vpes to free the IRQ hierarchy
and SGI domains originally allocated for all VCPUs, the truncation causes a
partial free.

Furthermore, the parent IRQ domain is forcefully removed while still having
active IRQ mappings. Could this lead to a Use-After-Free of the domain memo=
ry
when those orphaned IRQ descriptors are accessed (e.g. via /proc/interrupts=
)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260820125053.2951=
078-1-fuad.tabba@linux.dev?part=3D1
