Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DDD271443
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787235227; cv=none; b=rx1V5KPfbpfpIxoXAxye7ZD1+WK5fvnia4StysZiQ/CEJhP6Qnr5IlJBzA7LJfCCgy2qHmR81/vZqGlkT0lpnHdXeiX2mwZi9/XrvOhIFi7S+jhz6jG75X9ZvUzTFX64Nfwki+dRPeKvR/6ajUmEgVp31Qr5Oe9lX3L+bwr+8do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787235227; c=relaxed/simple;
	bh=/I2WaGo2nAOXO4n4LbukrKrZ9QkEc8zRDEEn89KjNCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VkU7MZJyHK3ufZr6NLu8fKidSTdGKGioSv94XYTGyivj7OHROjsWURj66wDYDBjTWrr55/XmHf7hxqzvz+hHucHsRnaGLfYWaDtIqnckeTOe6FtRIhCYo30il/DtBRFpRu2ZY50bytnVBaSCIm/fmRnUIUD1IKq0KgtPKJ8a/1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rzELSdmw; arc=none smtp.client-ip=91.218.175.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rzELSdmw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/I2WaGo2nAOXO4n4LbukrKrZ9QkEc8zRDEEn89KjNCM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787235222; v=1; x=1787840022;
 b=rzELSdmwyHShl18XM3sM14Y6/hkOv3bP5BUt+ydsjKZ9rfhGC1ZpoqJOU0hy75cBJg7v223u
 L0+mfj0+CUeyvV71wSf6WPf1s+lHK8Ea0V79TqjqMDPsUJXtWvkbw/AmvELsA8P0XXxBD+GO8Yu
 FQMMyrlCQnOH44eAak2iRJ9g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f47.google.com (209.85.167.47)
	by smtp.migadu.com with ESMTPS id a5e03baa157cb848;
	Thu, 20 Aug 2026 14:13:42 +0000
X-Mizu-Trace-ID: a5e03baa157cb848
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so11064e87.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 07:13:38 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywzevbir1eHZvbrXEJ0a28TCRwXcV7ittTBiBfjnZFIS2tmy5Ai
	7g6QHJA1Cp7hnOCCtLqCXlEQfaaTVE5UqwE9vE9Xl8pgjHK8cdfO4MJodNcqXQDno8bjKWELIy7
	XEsQ8w6/rScSzjZz9MecO3MnUIxQhxOTTw6ptZkVX
X-Received: by 2002:a05:6512:1044:b0:5b1:571f:715f with SMTP id
 2adb3069b0e04-5b47dd8842dmr247207e87.3.1787235217676; Thu, 20 Aug 2026
 07:13:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260820125053.2951078-1-fuad.tabba@linux.dev>
 <20260820125053.2951078-3-fuad.tabba@linux.dev> <20260820130302.E89531F000E9@smtp.kernel.org>
In-Reply-To: <20260820130302.E89531F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 20 Aug 2026 15:13:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzBRdtjWZSuAS1LZTouRZfP4F9Y=Ht1xN1f_kOzwNto0A@mail.gmail.com>
X-Gm-Features: AcwNN1XQRj8A7CoqHpb1D6TwxDMQ11ZVchz6u7GyIA7RR0c5V2K-tLNtaCsxaMI
Message-ID: <CA+EHjTzBRdtjWZSuAS1LZTouRZfP4F9Y=Ht1xN1f_kOzwNto0A@mail.gmail.com>
Subject: Re: [PATCH 2/3] irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs()
 allocated on failure
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Aug 2026 at 14:03, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] vgic_v4_init() truncates its_vm.nr_vpes on vgic_v4_request_vpe_i=
rq() failure, causing a resource leak of previously allocated VPE IRQs and =
SGIs during teardown.

https://lore.kernel.org/all/CA+EHjTzf4C6bdwTGWNN1HeapFWEFWm-AJtxi5gQKHekRS2=
n8Aw@mail.gmail.com/

/fuad

> --
>
> --- Patch [2]: [PATCH 2/3] irqchip/gic-v4: Unwind what its_alloc_vcpu_irq=
s() allocated on failure ---
> commit 09380ca1832d1b65e5229cfbb8e1f8ab95b65846
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
>
> This commit fixes a resource leak in its_alloc_vcpu_irqs() where SGI
> domains and vPE irqs were not properly freed if the allocation loop
> failed midway.
>
> > diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.=
c
> > index 754839e409f88..f707a3cb281aa 100644
> > --- a/drivers/irqchip/irq-gic-v4.c
> > +++ b/drivers/irqchip/irq-gic-v4.c
>
> [ ... ]
>
> > @@ -189,11 +191,14 @@ int its_alloc_vcpu_irqs(struct its_vm *vm)
> >               vm->vpes[i]->irq =3D vpe_base_irq + i;
> >               ret =3D its_alloc_vcpu_sgis(vm->vpes[i], i);
> >               if (ret)
> > -                     goto err;
> > +                     goto err_free_irqs;
> >       }
> >
> >       return 0;
> >
> > +err_free_irqs:
> > +     its_free_sgi_irqs(vm);
> > +     irq_domain_free_irqs(vpe_base_irq, vm->nr_vpes);
> >  err:
>
> [Severity: High]
> This is a pre-existing issue, but does the teardown path in
> its_free_vcpu_irqs() fully clean up resources if its_vm.nr_vpes gets
> truncated?
>
> If vgic_v4_init() in arch/arm64/kvm/vgic/vgic-v4.c fails to request an IR=
Q
> via vgic_v4_request_vpe_irq(), it explicitly truncates nr_vpes to avoid
> calling free_irq() on unrequested IRQs:
>
> arch/arm64/kvm/vgic/vgic-v4.c:vgic_v4_init() {
>     ...
>     /* Trick: adjust the number of vpes so we know how many to nuke on te=
ardown... */
>     dist->its_vm.nr_vpes =3D i;
>     break;
>     ...
> }
>
> When cleanup subsequently calls its_free_vcpu_irqs(), it relies on this
> truncated nr_vpes value:
>
> drivers/irqchip/irq-gic-v4.c:its_free_vcpu_irqs() {
>     ...
>     its_free_sgi_irqs(vm);
>     irq_domain_free_irqs(vm->vpes[0]->irq, vm->nr_vpes);
>     ...
> }
>
> Will this sequence leave the previously allocated IRQ domains, fwnodes, a=
nd
> SGI domains orphaned for the vCPUs beyond the failure index, since they a=
re
> no longer tracked by the truncated nr_vpes count?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260820125053.29=
51078-1-fuad.tabba@linux.dev?part=3D2
