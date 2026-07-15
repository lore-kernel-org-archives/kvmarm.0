Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780A83B7B6E
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113811; cv=none; b=p4hGluwZFijk7Ico4HC3IIs25fElXWSLePcQfjUa0Bv+3iGL/aYPh9WHYguGPW7y2BqOWCPoueLtTe4T9u9Z5SyvKGgjsGU5wRiJpg/2zgHQpnZ9kosrddu/ZV4MzLZN4Yd2qfE5iXE7cvlIpTAd0Usdlfi40M+G4VWkz5yJhLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113811; c=relaxed/simple;
	bh=oc/9yimWKaqbky8RYITzlYH7zAmq7n0aqeYpxvpJFLY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TsYDFT8dpI4K7Ko6NdFBNr1VIPok12eoUNqhD1F0dPRoUrk3ZhHoVnKfKZBXzf+9pkkCKAHfGqx/LBV+IPI3yxdokf8FAnIbRzcny4PPhDzLwfNxzch3SypZxgAhJvsTh82GjQjjfMNPFa4KgSvBqOhLwmiAlRo3loQ8dtzoMIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VL1gTxlA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VL1gTxlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D811F000E9;
	Wed, 15 Jul 2026 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784113810;
	bh=tiTuYRN5lTHy77oimWuN4UTZRurEJsiyUI1peno5VKc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VL1gTxlAm/TtORifFIZZtpWBZnAjHowhYiRFJTNtSRzLJqCBPX4qp3eUr3s0JoPHR
	 mr4VXME1KhEQqKo6SdAu05Z2N4rerCXRsSW310gglI3e0nQ5/9C8IjRiCOWboteqvG
	 aRzhF5r5IXPZm2uEEuNGRIWhdCj3AIlTfObyYVwbCoIS7x7hnuVpA0utcvK21CXSnA
	 nkP1uL1JALR4XdkxAZlGOms3iO4TszY6wXX/h67C38BdPiWbuR+bLz/P8nkNhyR/rn
	 nETwKvKkpf1Lq4PGDrNq32+aVNCjGGy/BHvAB37rLdTpujraVorgEHyw08bTalTl0r
	 AXpZzYmoWAyHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/2] KVM: arm64: vgic: Mitigate potential LPI
 registration failure
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260715105137.3973823-5-clopez@suse.de>
References: <20260715105137.3973823-3-clopez@suse.de>
 <20260715105137.3973823-5-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 11:10:09 +0000
Message-Id: <20260715111009.C5D811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Silent guest failure due to unhandled -ENOMEM from __xa_store() du=
ring LPI registration.
--

--- Patch [2]: [PATCH v6 2/2] KVM: arm64: vgic: Mitigate potential LPI regi=
stration failure ---
commit 9b522d02e94ea5f2dfcbdf1fe73fdeacbe285ee9
Author: Carlos L=C3=B3pez <clopez@suse.de>
KVM: arm64: vgic: Mitigate potential LPI registration failure

This commit changes vgic_add_lpi() to pass GFP_NOWAIT | __GFP_ACCOUNT to
__xa_store() when adding a new LPI. This mitigates a race condition where t=
he
xarray entry might have been freed between xa_reserve_irq() and __xa_store(=
).
However, if the GFP_NOWAIT allocation fails, it still returns an error.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 2240bdf20c926..b59e0e0e1e821 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -121,7 +121,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm,=
 u32 intid,
>  		 * from the deferred release path, pending cleanup by
>  		 * vgic_release_deleted_lpis(). Evict and free it if present.
>  		 */
> -		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq, 0);
> +		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq,
> +				    GFP_NOWAIT | __GFP_ACCOUNT);
>  		ret =3D xa_err(oldirq);
>  		if (ret) {
>  			xa_unlock_irqrestore(&dist->lpi_xa, flags);

[Severity: High]
This is a pre-existing issue, but does this error path lead to a silent
guest failure?

If the GFP_NOWAIT allocation fails due to host memory pressure,
__xa_store() returns -ENOMEM which is propagated back:

vgic_add_lpi() {
        oldirq =3D __xa_store(..., GFP_NOWAIT | __GFP_ACCOUNT);
        ret =3D xa_err(oldirq);
        if (ret) {
                xa_unlock_irqrestore(&dist->lpi_xa, flags);
                kfree(irq);
                return ERR_PTR(ret);
        ...
}

Since vgic_its_process_commands() ignores the return value of
vgic_its_handle_command(), the guest's ITS MAPTI command is silently
dropped and the device interrupts are permanently lost.

Could this be handled by dropping the lock, performing a blocking
xa_reserve_irq() with GFP_KERNEL_ACCOUNT, and retrying the insertion
instead of returning the allocation error?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715105137.3973=
823-3-clopez@suse.de?part=3D2
