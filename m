Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF573E8684;
	Fri, 24 Jul 2026 11:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892093; cv=none; b=k0Idz3owJKxqMkwClfK1Fh07AZWVcV0k8aMyntXOUARi5RfKHXJgwjBBB4XCUAULrjeml2tErsCHyuDDhndVWbGz8pqB9cwSuMuHfKoDIH0+IPIpUdngj6gCRVjQDHuLJ2jzE3nA6GDRH1bMWHWWEjPywqEKdNU3VLtl/Lt3c0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892093; c=relaxed/simple;
	bh=2CoWUN0uhqE625SUIXnAn7bS5/D5MZm8BdcNxq17plE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aTkA4P5b01ioJd5Q5+BjdG8tvFlUba+xG7K65Q7ki23Zo7z7bC1ELz78mc6Usn6zPbs1Z2c/rj9Bx8gnmZPTrZR3I7FsBsj3T4isgq3NYU7+GFS8HRXgEQF6YmoO9bqPRlXEyjGDWMmDv6e0+zOn1psES2vAQIxN3HQDN47rFtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuxDQvq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuxDQvq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0D81F000E9;
	Fri, 24 Jul 2026 11:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892088;
	bh=Nhyv8WU8sjX9mZaIHSe7KvYWqbzeWDOrV3b06bGUqaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MuxDQvq+nO6nbwRdjtiDodKTXWEflp6xsyW2hhJWRxb+mlN55EFO9wEXpKibCE49I
	 nyBCmKE1lWnJySpx6qWXbDtaxkjyLWG7k0Nc2nv6H0FO0o3rHBgKriDVfNS9LG70kD
	 aLWAhlWbnAHKtn/V6GDXnYGIFeIAX5ET7lqNDnetsJOCWsQMQ4QJ5NSuggsoTN00UT
	 lx6bBT4aWrR5H8LyrghJB/X56Kt0A7mtK7VbRA+bFEN/ptwSvNW8k6Jj+5Pl/z5St5
	 nvRYE+DH3qI+obrz3T2m4Ad7jiSrVKjbd9UzNGxr6OW3omfIndTEWGr2w/Ben0YUPS
	 dQVW8UAiA0WCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/48] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-2-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-2-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:21:27 +0000
Message-Id: <20260724112128.3A0D81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Exposing a latent memory leak of `gic_kvm_info` in KVM's initial=
ization error path when a required maintenance IRQ is absent on GICv5 legac=
y-capable systems.
--

--- Patch [1]: [PATCH v4 01/48] irqchip/gic-v5: Allow KVM setup without a m=
aintenance IRQ ---
commit 4a1c6e5108caaddf8c492f48ac4cb4568ab60c52
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

irqchip/gic-v5: Allow KVM setup without a maintenance IRQ

This commit modifies the GICv5 initialization to no longer reject KVM setup
solely due to a missing maintenance interrupt. Instead, it delegates this
validation to KVM by passing a specific configuration flag based on legacy
support capabilities.

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index e9d1795235a66..c04523a438cee 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -1143,10 +1143,18 @@ static void __init gic_of_setup_kvm_info(struct d=
evice_node *node)
>  	/* GIC Virtual CPU interface maintenance interrupt */
>  	gic_v5_kvm_info.no_maint_irq_mask =3D false;
>  	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
> -	if (!gic_v5_kvm_info.maint_irq) {
> -		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt=
\n");
> -		return;
> -	}
> +
> +	/*
> +	 * We require an MI if we have legacy support, but don't, otherwise.
> +	 * Given that there's an existing flag to convey that an MI isn't
> +	 * needed, we (ab)use it to tell KVM that the MI isn't needed if we
> +	 * don't support legacy.
> +	 *
> +	 * The check for ARM64_HAS_GICV5_LEGACY explicitly doesn't use
> +	 * cpus_have_final_cap() here as we run too early.
> +	 */
> +	if (!cpus_have_cap(ARM64_HAS_GICV5_LEGACY) && !gic_v5_kvm_info.maint_ir=
q)
> +		gic_v5_kvm_info.no_maint_irq_mask =3D true;
> =20
>  	vgic_set_kvm_info(&gic_v5_kvm_info);

[Severity: Medium]
By removing the early return here, does this expose a memory leak in KVM's
initialization error path?

If a system has ARM64_HAS_GICV5_LEGACY support but the maintenance interrupt
is missing, we now pass no_maint_irq_mask =3D false and maint_irq =3D 0 to
vgic_set_kvm_info() in drivers/irqchip/irq-gic-v5.c:gic_of_setup_kvm_info().

When this configuration reaches KVM:

arch/arm64/kvm/vgic/vgic-init.c:kvm_vgic_hyp_init() {
    ...
    if (has_mask && !gic_kvm_info->maint_irq) {
        kvm_err("No vgic maintenance irq\n");
        return -ENXIO;
    }
    ...
}

It looks like kvm_vgic_hyp_init() returns -ENXIO without freeing the
dynamically allocated gic_kvm_info structure, causing a memory leak.

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D1
