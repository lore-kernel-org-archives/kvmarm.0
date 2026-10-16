Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B0B53CA9D;
	Fri, 16 Oct 2026 16:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167756; cv=none; b=iAnRXsUQKREb/RPQvRWeaCmMa2o7U450TagebN8y/bR3JAvLEsgbYUlIQLj8YP557JMz0lS6swyiGx54FIy8DYncmtNBMrdWiXAou28Hi7Bx7XhTQvMwb08WZ9aftrSpzYG91CP5rjWTLUgWQT6TMvticCP9NenltYeM7/J/s1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167756; c=relaxed/simple;
	bh=N7CDpPmjuBkR4eCYFhMftYG1QF8T+YKBIMUN8lGNNp4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=adXo2YfPmYmJcUw3QU2aQxcJxxzvwYor45CbQtnZ3vVyS9l0eufRXOnmETIRCqRf9M5wvpA6D0chNoscMTFRR362nXrh1n693dydLMEl21/VFcV0z8t5Op4kX+Czwhb2iY/6OVuFQaPIhW4rRaVhOsW0EYY89BW+x0M25jsO86I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ns6rTSm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ns6rTSm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52AD1F000C4;
	Fri, 16 Oct 2026 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167752;
	bh=Tao72hQpRVs4xXH4ElYuL4ln990JVJrRPCNVTW+vRnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ns6rTSm0xuHuTaF7Y7UvCGIcei4wjO397dBjNDLQTnmOiRrFxOyYdbrzY+skkAop7
	 pO/ZCEZ/Gv6bJQXGXDS1OBUOZzwPeYVAbhPVbAxQAfEyvVv7bCZ/zrFQ4fDWpUqSco
	 hoyCWxXl8JkQqpxfjm9tCa8IgqcgnQoz6Xpd11ZpmbUadEcZwaG9Mxt9Iwox2710HA
	 JCCPcbIm7nAf+Fgss9GVdzaoIvxCHOo+DwwGbnstZSri8zzjj/WAFCY4GniODCkCSt
	 guRphv+2aH3g1Z6gwPmUkfRsaWZYZx1i082YS1ETjIwFrCz0Ps45u+UgqTT/dMMT0T
	 eYaqt469rzWuw==
Message-ID: <sashiko-outbox-174629@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/16] irqchip/gic-v5: Enable direct injection in ITS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-12-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-12-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:22:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] irqchip/gic-v5: Racy ITS MMIO invalidation sequence
- [High] irqchip/gic-v5: missing event drain in set_vcpu_affinity causes cr=
oss-VM interrupt
--

commit 4f462ff132c79e74a3a82cf356a72402e7a44799
Author: Sascha Bischoff <sascha.bischoff@arm.com>

irqchip/gic-v5: Enable direct injection in ITS

This commit introduces an irq_chip callback to allow KVM to install and rem=
ove
virtual translations for direct interrupt injection. It replaces a host ITTE
with a virtual translation and disables lazy masking while the interrupt is
forwarded.

> diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v=
5-its.c
> index 28e39b065de0e..7de40a7cff403 100644
> --- a/drivers/irqchip/irq-gic-v5-its.c
> +++ b/drivers/irqchip/irq-gic-v5-its.c
[ ... ]
> @@ -723,6 +765,95 @@ static void gicv5_its_compose_msi_msg(struct irq_dat=
a *d, struct msi_msg *msg)
>  	msi_msg_set_addr(irq_data_get_msi_desc(d), msg, addr);
>  }
> =20
> +#ifdef CONFIG_KVM
> +static int gicv5_its_set_vcpu_affinity(struct irq_data *d, void *int_dat=
a)
> +{
[ ... ]
> +invalidate:
> +	/* Make the change ITS-visible */
> +	dsb(st);
> +	ret =3D gicv5_its_itt_cache_inv(its, dev_id, event_id);

[Severity: High]
Does this new KVM callback expose the gicv5_its_itt_cache_inv() sequence
to concurrent execution?

This callback appears to only be serialized by the per-IRQ lock, but
gicv5_its_itt_cache_inv() writes to the global shared ITS MMIO registers:

drivers/irqchip/irq-gic-v5-its.c:gicv5_its_itt_cache_inv() {
    ...
    its_writeq_relaxed(its, didr, GICV5_ITS_DIDR);
    its_writel_relaxed(its, eidr, GICV5_ITS_EIDR);
    its_writel_relaxed(its, eventr, GICV5_ITS_INV_EVENTR);

    return gicv5_its_cache_sync(its);
}

Without an ITS-wide spinlock, concurrent configuration of different IRQs/vC=
PUs
from the same or different guests could freely interleave their MMIO writes=
 on
the shared physical ITS.=20

Could this result in the ITS hardware receiving corrupted invalidation comm=
ands
(e.g. invalidating the wrong device/event while leaving another stale), lea=
ding
to dropped or misrouted interrupts?


[Severity: High]
Are in-flight events drained here when direct injection is disabled?

When disabling direct injection (where data is NULL), the ITTE is updated to
the host LPI and the ITS cache is invalidated. However, there is no call to
gicv5_its_syncr() or gicv5_irs_syncr() to drain accepted events before
returning.

If KVM subsequently tears down the VM and reuses the VM ID for a new guest,
could an in-flight event reach the IRS and be injected into the new VM's IST
using the old translation?=20

Disabling forwarding would likely need to drain events before returning to
safely reuse the resources.

> +	if (ret) {
> +		/* Keep a failed restoration distinguishable from a clean host ITTE. */
> +		if (!data)
> +			irqd_set_forwarded_to_vcpu(d);
> +		return ret;
> +	}
> +
> +	if (data)
> +		irqd_set_forwarded_to_vcpu(d);
> +	else
> +		irqd_clr_forwarded_to_vcpu(d);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_KVM */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D11
