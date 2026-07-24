Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A4F36F8EF;
	Fri, 24 Jul 2026 11:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892834; cv=none; b=gjUnflhkMdgLKR043w9F0nlSGeF4tYal3MVBXwp0SqQGNc82rGqWCaxbj76rSwKM0o4ysNjYCHUrSH4m7wvb1FNKNLoarGe862UWPscsPp+GZB5jO60IvuRWAyTW8PbmUmWnBwNg1nOOKE+y8y15aXRYM6bpMPokuk0lt0aSUg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892834; c=relaxed/simple;
	bh=WPEPom+yd39XgGmhYXOwa7g6jgl850zuYpTff68ulvc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cveuTIg48D7rJ8cmDjssquyGo6BXSji6X4hNSpxUJNDlJImRHbUPr3Lgw2/emEfcGV7NOp5e65/zPkt2d7Pjz84eLbUHZ8bta0ljW1P/rGyrk1yVDyVXxeGLoMjU/9Db9B1QSLgkTX6oOmt6CDHs72xQu777Ub0dvuCYjBhfpVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U57lhxS9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U57lhxS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5791F000E9;
	Fri, 24 Jul 2026 11:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892829;
	bh=90JbWg9PG1QqWL3tGHtJLkj0OlC78XfkmHlacIrOkJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U57lhxS9KXsTPDPdj3Fi4YMbqAvj7Qb1MDArjIMn86XmNKHaOYlvgIuHt7Syb2uS5
	 kBf5IOZdYs4rr0uLF7SM8EApsLMaLWv9Fi7WNPJqUFrYNTlMfykSBAbE0xIrJkFwP7
	 alcw/4qD59PG0iZ/s15MzUM+4KV11SzsAsVhQJt9jxrysqP7QRIN2nLNkCPl5uKNsc
	 27xYB1HeEUlyN9sv41skifZhNV6m2hrLhw+IR3cnHxVSwg91QvVVkTF9iJa4SPz4/y
	 DgAz772/A6HrpFcRTfaU5fGNb3yEA6csQZT6wMiLBGJwndUo4YK/buaN86//3rLMmH
	 nQZrcuYqRzJhw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 22/48] KVM: arm64: gic-v5: Register the IRS IODEV
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260724104819.1296803-23-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-23-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:33:48 +0000
Message-Id: <20260724113349.0E5791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] GICv5 SPIs cannot be retrieved because vgic_get_irq() explicitly r=
ejects non-private GICv5 IRQs, rendering the newly activated IRS SPI config=
uration broken.
- [High] Allowing userspace to configure up to 65,536 GICv5 SPIs triggers a=
 large contiguous memory allocation via kcalloc, which can deterministicall=
y fail and cause kernel warnings, resulting in a host-side DoS.
--

--- Patch [22]: [PATCH v4 22/48] KVM: arm64: gic-v5: Register the IRS IODEV=
 ---
commit d0f49503c9e90ab6ab9f71cb5ba22d59c564bcd8
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
KVM: arm64: gic-v5: Register the IRS IODEV

Now that we have an emulated IRS, it needs to be registered, which ensures =
that
guest accesses to the MMIO regions handled by the device are handled
appropriately in KVM. As part of this change, expose setting the address of
the emulated IRS via KVM_VGIC_V5_ADDR_TYPE_IRS to userspace. Also allow
userspace to set the number of SPIs handled by the emulated GICv5
implementation.

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> index 90be99443df3b..8c2c6886af4e3 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c

[ ... ]

> @@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *=
dev,
>  		if (get_user(val, uaddr))
>  			return -EFAULT;
> =20
> -		/*
> -		 * We require:
> -		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
> -		 * - at most 1024 interrupts
> -		 * - a multiple of 32 interrupts
> -		 */
> -		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
> -		    val > VGIC_MAX_RESERVED ||
> -		    (val & 31))
> -			return -EINVAL;
> +		if (!vgic_is_v5(dev->kvm)) {

[ ... ]

> +		} else {
> +			/*
> +			 * GICv5 reports a number of SPIs, not a total number of
> +			 * interrupts. Require a multiple of 32 SPIs.
> +			 */
> +			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
> +			    val > VGIC_V5_MAX_NR_SPIS ||
> +			    (val & 31))
> +				return -EINVAL;

[Severity: High]
Does allowing userspace to set nr_spis up to VGIC_V5_MAX_NR_SPIS (65536) ri=
sk
triggering a host-side allocation warning or failure?

If userspace sets nr_spis to the maximum, KVM will eventually call kcalloc()
for the SPIs:

arch/arm64/kvm/vgic/vgic-irs-v5.c:kvm_vgic_v5_irs_init() {
    ...
	dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
			     GFP_KERNEL_ACCOUNT);
    ...
}

Since sizeof(struct vgic_irq) is over 100 bytes, this requires a physically
contiguous allocation of roughly 7MB. This exceeds the typical KMALLOC_MAX_=
SIZE
of 4MB, which would cause the allocation to deterministically fail and
potentially trigger a kernel warning or panic (if panic_on_warn is set),
allowing an unprivileged user to cause a host-side denial of service.

> +
> +			mutex_lock(&dev->kvm->arch.config_lock);
> +			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
> +				ret =3D -EBUSY;
> +			else
> +				dev->kvm->arch.vgic.nr_spis =3D val;

[Severity: High]
Are we able to retrieve these GICv5 SPIs once they are configured here?

Currently, vgic_get_irq() explicitly rejects non-private GICv5 IRQs:

arch/arm64/kvm/vgic/vgic.c:vgic_get_irq() {
    ...
	/* Non-private IRQs are not yet implemented for GICv5 */
	if (vgic_is_v5(kvm))
		return NULL;
    ...
}

This means that when the guest accesses the IRS MMIO interface for SPIs, the
handler (e.g., vgic_v5_mmio_write_irs_spi) will fail to retrieve the SPI
structure and silently abort. Will this leave GICv5 SPIs unconfigurable?

> +			mutex_unlock(&dev->kvm->arch.config_lock);
> +		}
> =20
>  		return ret;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D22
