Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18026305695;
	Fri,  3 Jul 2026 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095848; cv=none; b=jvzgConTX3EqBmg4knfkzUFHFVfkjuuewQnlwcHy3gRuZPL0Slzv/6d1+9Uzh3gttp+f5yroVoKvWRxfIVyv70PKCgLmgiwjR8EBuyMfkzfeopCphbGYDND6HuyfKq6+vD60XSGuCMGl15BCsMZfBgoKoaVlh2ufEVTJydfaiOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095848; c=relaxed/simple;
	bh=H+TJxE8SIlIVblBOUJ7fSTmlYSnDy4rIghdENN/jZaE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A7oRXj6LRKvtlRab4yPESsmXm8JsMpy1GgEwotRQEhHM2XJy/WjsIAP307LmnirKwhlDwKNTjDK08tT/8hzTtOfYj/qi45ex2VsaUQF/T5D78RXT/a9aa11qtUvJfMcKE8hnf6W7TwxQifpLiQcEOW1zCiYvlDuyyl/T2wfY8KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inr7zvbv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inr7zvbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564F81F000E9;
	Fri,  3 Jul 2026 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783095846;
	bh=pAwQBh0wPa2jaUMcASk8vm+93hWra8UVKVAwNWsTRbg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=inr7zvbvyMzzOEq2KXpiLVWMuJSBlO/vly4Pum6YQ7lSvCHzI43p9F6IMxRoc/oyw
	 KGka9mDUwcGbIrVzOf/FYJ5wShw47C6M700L+rPfdeASQDTJU0PEQc5gS36u1m1AxH
	 47Gt9+4+TTAoW+sTnzMgRSOMREgDgoIrQ+Ocou2QtmekROFjv5963xDMBo+DdeI8n4
	 eZeHEbju/SsPRKq3kXTznAplclcmJMEheKyRZXfXs/jWabMzmchbWC5QOYFM5mTvGx
	 QmFoAswzgA/WCQHaVfEtOfpreQAGNIMkaOEWErtHAMToNcGDgwMobAOa8wrnbt1qAj
	 uVd8gWQYW793g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/40] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-3-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-3-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:24:05 +0000
Message-Id: <20260703162406.564F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Failing to initialize an IRS leaves dangling pointers in the `per_=
cpu_irs_data` array, causing a Use-After-Free on subsequent accesses.
--

commit 2e4c81aa47ab5216dcd3371d3e6ff357cb0a76e6
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

irqchip/gic-v5: Provide OF IRS config frame attrs to KVM

This commit passes a pointer to an IRS config frame to KVM so it can intera=
ct
with the host IRS directly. It adds a new function to retrieve the chip data
and populates the gic_v5_kvm_info structure with the IRS base address and
coherency flag.

> diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v=
5-irs.c
> index f3fce0b1e25d9..607e066821b52 100644
> --- a/drivers/irqchip/irq-gic-v5-irs.c
> +++ b/drivers/irqchip/irq-gic-v5-irs.c
[ ... ]
> @@ -50,6 +48,11 @@ static void irs_writeq_relaxed(struct gicv5_irs_chip_d=
ata *irs_data,
>  	writeq_relaxed(val, irs_data->irs_base + reg_offset);
>  }
> =20
> +struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void)
> +{
> +	return per_cpu(per_cpu_irs_data, 0);

[Severity: High]
This isn't a bug introduced by this patch, but can accessing per_cpu_irs_da=
ta
here result in a use-after-free?

If an IRS fails initialization (for example, due to missing LPI support
checked in gicv5_irs_init()), the driver frees irs_data on the error path
in gicv5_irs_of_init():

    kfree(irs_data);

However, gicv5_irs_of_init_affinity() has already populated per_cpu_irs_data
for the associated CPUs prior to the failure:

    per_cpu(per_cpu_irs_data, cpu) =3D irs_data;

If another IRS on the system initializes successfully, gicv5_irs_of_probe()
succeeds. When the CPUs associated with the failed IRS start up,
gicv5_starting_cpu() invokes gicv5_irs_register_cpu(), which unconditionally
dereferences the dangling pointer from per_cpu_irs_data:

    irs_writel_relaxed(irs_data, selr, GICV5_IRS_PE_SELR);

Since this patch exposes per_cpu_irs_data to KVM, KVM could also receive and
dereference this dangling pointer. Does the error path need to clear the
per-CPU pointers before freeing irs_data?

> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D2
