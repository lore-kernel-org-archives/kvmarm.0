Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB25B34D4DE;
	Fri,  7 Aug 2026 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786120242; cv=none; b=KKLlqmeP+ocROJhUYuLy+V03vH96bnhIVhvXBrwOiea3oJ4XUJmIXRJBC8FDaLj/C7a320xbyHMHKiVAMRQ6yLYFN/rq+casnQGJdIYN0ZZGXkH3YxM398cujEsxY/JZ57eDaA/xhIj4bkD3APdygiRplfoOJmgnU2UACE0+/Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786120242; c=relaxed/simple;
	bh=OH04tUzDFy64dZ7wiOVpeMo/Wv4N0HTFixL+yCI3sf4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d/NdCXw7sHCt68STB7YGr7s7D4fdGEHJXXBD4YPm+4/m/s1aRTwXqITgdnsokyPmZ71N4R48lDHQX8BtGOfxGOz9rj0dPiMUsj0tClvfO7BIaj7c+fKzsjvD3nUoZvm/xOmy0fqrXb0apv/JtOLeLxzdIEEJStMkAbc1E2uFgsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjdUlF2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjdUlF2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3971F000E9;
	Fri,  7 Aug 2026 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786120241;
	bh=2yZMbgINLLom3XGpASv3dM7VehBuy7Mm5nN98L9zTe0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PjdUlF2JQR865CLWVYUHajAttZCIPg0NUWCtjW95rceusGiT1K4l6EMnHnlY6WU9b
	 a9XAFMXk7gvPjRlQCDu6VHsU0ILSAkpmJgACk2z5zirGNU+9wLkaA9yX5SDCe9zf59
	 Vnwatt2WAItUleneNo+kxcA8/ZApoEQUaih5fo0yNnHf/ApK4VGw94h4LVzLMSYPG+
	 xOMCzoKgPKOxVg2Lz96fXN3DDr+aPaZ0gzeGS9p9EYao/LQiKlkZ38coaNHXrEnmZB
	 eusggCJDXaAOmMOzZ/8pCKH6ooHA/ucSd53IwKAtQPiWvq3VR6N5aX7M796yOGWnXF
	 IcNagnioMhG+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 34/49] KVM: arm64: gic-v5: Add VGICv5 IST
 save/restore UAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807111159.429128-35-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-35-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:30:40 +0000
Message-Id: <20260807163041.2A3971F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete implementation: UAPI definitions added without corres=
ponding kernel backend
--

--- Patch [34]: [PATCH v5 34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/re=
store UAPI ---
commit db4f69bf4672970c99891b1c1bd9652c4ebfb88a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
   =20
This commit introduces KVM_DEV_ARM_VGIC_GRP_IST as a VGICv5 device attribute
group to transfer SPI and LPI IST state between KVM and userspace. It defin=
es
struct kvm_vgic_v5_ist as a descriptor for the IST buffers.

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 710a0d267347d..9998252ea8ec8 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -423,6 +423,15 @@ enum {
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
>  #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
>  #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
> +#define KVM_DEV_ARM_VGIC_GRP_IST	11
> +
> +struct kvm_vgic_v5_ist {
> +	__u64	spi_ist_addr;
> +	__u64	spi_ist_size;
> +	__u64	lpi_ist_addr;
> +	__u64	lpi_ist_size;
> +};

[Severity: Medium]
Are the backend ioctl handlers for this new UAPI missing from this patch?

The commit message notes this is used to transfer state between KVM and
userspace, but it looks like only the header definitions are present.

Without the backend code, userspace attempting to use KVM_DEV_ARM_VGIC_GRP_=
IST
will receive an error.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D34
