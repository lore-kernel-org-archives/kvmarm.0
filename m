Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA470306D26;
	Fri,  3 Jul 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783097264; cv=none; b=DD8g/L0nJs4FFgiZVXFGZ59MkcmK+hJz+ojWJhiobTWmv0nBjYeOLZyUTYK/8neVMniRGQx4r5A3fvWyYlJhCahrxvSVgr1qHaq6XgimCRf3omVliTvhSPNeBgQBIonkSKsMjo/NL/wcbVvJM3pBycsXFzb/qk+RmT9YZxp2ZiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783097264; c=relaxed/simple;
	bh=+V2ZhveggoD/M7y6AqVgE1WcO/aAhrrYLpIyz+OXq9g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Oi6j9K8h7KnX5d4TCpsZ/hPL2B9aEVzOu/fzqipAcrLp+SbFEBu2AjwnghvuxmoAt+YvtrtnCehxS8bdXyHentfpneRhelzDvpq53pXLrX2CNwu/sij9p3rJfCM5KDBvlzBQUyHNleUzPeo9nwxoCwtrJxwYTN8Pxa8q+iKvQSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dc6pE48H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dc6pE48H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3840F1F000E9;
	Fri,  3 Jul 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783097263;
	bh=18k8qEdp1ZomnKeNEJECyCo/mk/gNxNcg18TI5sCfaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dc6pE48HI48O9d0Z/5nsaF1jJgt96JaWjTJPehE8QxBuxqAiE/u+RFXMs3lAweQNC
	 Jpr5s9xcrKTDg1e8dehjfCD5JuPRm+iJEWSQyLYGyB3B64foWCBRXgiPTWwgPGbmdr
	 3NeDXfZhnYByuOt+pfOuUB9PzIpdEcCOJcqr9kXCIRCNtFbnikpd1X+38FfJ5B2pDK
	 O2/Gk910mOqnx1hixsFpAu4/Wr18zDFwQEgxu3q8zfyA5rU1x20KYHIw/imWu/Cwh3
	 HLvSiGVNmSdcG0hWH6uFrdp/UdDEkKvRXDTE2l9cOn4EFa+l1MDGZMhnXw970dGAbV
	 89DB7uPxyZoCQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 22/40] KVM: arm64: gic-v5: Register the IRS IODEV
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-23-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-23-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:47:42 +0000
Message-Id: <20260703164743.3840F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unbounded user-controlled value for GICv5 `nr_spis` allows up to ~=
33.5 million SPIs, leading to massive `kcalloc`/`kzalloc` calls and trigger=
ing page allocator warnings (`WARN_ON_ONCE`).
--

commit ad66c0c7246443f87335c5d107b9fc733ca72c6b
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Register the IRS IODEV

This patch registers the GICv5 IRS IODEV as part of vgic_map_resources. It
also allows userspace to configure the address of the emulated IRS and set
the number of SPIs handled by the GICv5 implementation.

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> index 90be99443df3b..2bf1930902b8e 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
[ ... ]
> @@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *=
dev,
[ ... ]
> +		} else {
> +			/*
> +			 * GICv5 reports a number of SPIs, not a total number of
> +			 * interrupts. Require a multiple of 32 SPIs.
> +			 */
> +			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
> +			    val > FIELD_MAX(GICV5_IRS_IDR5_SPI_RANGE) ||
> +			    (val & 31))
> +				return -EINVAL;

[Severity: High]
Does this allow an unprivileged userspace process to trigger massive
memory allocations and a kernel warning?

The validation here limits val to the 25-bit hardware maximum (around 33.5
million SPIs) rather than a smaller software-defined limit like
VGIC_MAX_RESERVED.

Later, when kvm_vgic_v5_irs_init() is called, it allocates the array:

	dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
			     GFP_KERNEL_ACCOUNT);

This could request over 4GB of physically contiguous memory. Similarly,
vgic_v5_alloc_linear_ist() does a kzalloc based on nr_spis, which could
request up to 256MB.

Since these allocations far exceed KMALLOC_MAX_SIZE and do not use
__GFP_NOWARN or kvcalloc(), would they unconditionally trigger a WARN_ON_ON=
CE
in the page allocator, allowing a host-side denial of service?

> +
> +			mutex_lock(&dev->kvm->arch.config_lock);
> +			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
> +				ret =3D -EBUSY;
> +			else
> +				dev->kvm->arch.vgic.nr_spis =3D val;
> +			mutex_unlock(&dev->kvm->arch.config_lock);
> +		}
> =20
>  		return ret;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D22
