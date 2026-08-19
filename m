Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A13233944;
	Wed, 19 Aug 2026 22:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787180083; cv=none; b=hURBoFw20udrrZavoYByfTLtHMP3wagWXWRuBhJOZ2xLyTMNUoMa9rJFHQfWM1ZRJmk1Y+0LXfca3CCxKuWz0fNGuKJX8ZY5nYXsWOmPNHJXbSMeM+OXZ7a95RwGOSCSaUJFEWjw/W3/TOMVFrbeyPhcKXh576BNC7CApH1KCWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787180083; c=relaxed/simple;
	bh=Yq3IKx/7nurkaIA2MRhsvrsM9ZQZhCt5Gx/t4hPrzVU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j3mN96sa34EgjrL2Mn5lKAFNw9ec6OgOhcdYZ7baz626vBliPgbcl0frRbsVLOjVtJTpv0GnnOuitYJ5X4y7CHy6VDmh3RqAHiSLmE4m6dm53YUxtq2iVqGm9oaUcIGGFPb2V+u0driLrtwBpE3FrwogVQmmHs3FgPNFGWhWuvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Drbup+/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Drbup+/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CEF1F000E9;
	Wed, 19 Aug 2026 22:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787180081;
	bh=LWAuEH29e41CYBLgUPl4LeYHT7m+xP52aCGfSN7AIfg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Drbup+/xnb9JnLI9jnb8GnbtbbBbj+WL91wkUVbn6PkNddezr65WJfXwKsit9yCoo
	 Ct+TyqYDzT3hox7Z2XCI6rYQ0Ghv9rhQMHBNFOPtWI5HYKTrPvmFrwfeb8DBqVPYap
	 Yn6VC0Wp+KFl93QaWGjbeMZ74ce6er660f0HOGV3CIPU05xZCWT9zIBN8fgieRzbWs
	 l13IpLml13ChaFOGhbF+TRrOAs1kDBPRqYJps9tcIUZDpYs0RDWljyjf3nMWlmzWbZ
	 8xIsgUiJtoQ+eWWXlIv+zdQAQaumAo8Fsv2o5Gnz5VNF8L3rvCc294iNKKQOh3X8vy
	 EkD3SX8Eyvuvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/5] KVM: arm64: vgic-v3: Undo assignment on iodev
 registration failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260819224229.82948-2-kmehltretter@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
 <20260819224229.82948-2-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 22:54:40 +0000
Message-Id: <20260819225441.33CEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete rollback in `vgic_register_all_redist_iodevs` fails to =
clear `base_addr`, permanently breaking rolled-back vCPUs on retry.
--

--- Patch [1]: [PATCH v2 1/5] KVM: arm64: vgic-v3: Undo assignment on iodev=
 registration failure ---
commit 1ddcb102c04536e66942920259e184122195f9ff
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: vgic-v3: Undo assignment on iodev registration failure

This commit introduces vgic_unassign_redist_iodev() to clear rdreg and base=
_addr
when kvm_io_bus_register_dev() fails during redistributor iodev registratio=
n.
This prevents reusing a slot that remains assigned to a vCPU and fixes the
state leak for the current failing vCPU.

> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index 5913a20d83019..c75caadbd1d3c 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -766,6 +766,18 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_=
device *dev)
[ ... ]
> @@ -818,16 +830,17 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcp=
u)
[ ... ]
>  	ret =3D kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
>  				      2 * SZ_64K, &rd_dev->dev);
>  	if (ret)
> -		return ret;
> +		vgic_unassign_redist_iodev(vcpu);

[Severity: High]
This is a pre-existing issue, but does the rollback loop in
vgic_register_all_redist_iodevs() also need to use this new unassign helper?

If vgic_register_redist_iodev() fails, the rollback loop in
vgic_register_all_redist_iodevs() handles previously processed vCPUs by cal=
ling
vgic_unregister_redist_iodev():

arch/arm64/kvm/vgic/vgic-mmio-v3.c:vgic_register_all_redist_iodevs() {
    ...
	if (ret) {
		/* The current c failed, so iterate over the previous ones. */
		int i;

		for (i =3D 0; i < c; i++) {
			vcpu =3D kvm_get_vcpu(kvm, i);
			vgic_unregister_redist_iodev(vcpu);
		}
	}
    ...
}

Because vgic_unregister_redist_iodev() only unregisters the bus device, it
does not clear base_addr or reset rdreg. These rolled-back vCPUs remain
assigned but are removed from the MMIO bus.

If userspace retries the ioctl, vgic_register_redist_iodev() will see that
base_addr is no longer VGIC_ADDR_UNDEF and skip registration.

Will this leave the guest permanently missing MMIO mappings for those
earlier vCPUs, breaking guest execution?

> =20
> -	/* Protected by slots_lock */
> -	rdreg->free_index++;
> -	return 0;
> +	return ret;
> =20
>  out_unlock:
>  	mutex_unlock(&kvm->arch.config_lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819224229.8294=
8-1-kmehltretter@gmail.com?part=3D1
