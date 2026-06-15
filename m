Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208B419F11B
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 18:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546727; cv=none; b=I6zwlM2x0kOhBMLP8wZI1icnoMro8kqvYDyNi+ekKWuNs8S13SBL8N2zIyirZ00k/0/2xvY4wPW1/glOl1iVPBYnNVL5SNvAlQT5mtBgV29bEx44INfIPc2cJtwRk1EqgO68yeYUxcVYIW3U8sSEzENkiXUa/vvQAploqBrKTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546727; c=relaxed/simple;
	bh=Q3hBpHkHVTB3fUN57F2KIk6HWmyph+J7Wwq6o4RRYZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LIn0zM4OqlJH4AHh6fZTILup1pA7LPFuOFc19l1yBkzLTWzGipswu066Dc2QmAFhprChxI5S2dJDVFniL3An23B756JubRrz20ZoCENqNL9EtcDcBetXqcABZniA2bqg/cSIOMnem7kuLMMq3FHlGGELsyRaR/fd6aDdateeuqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fFdroDCj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fFdroDCj"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c85a2c0b56fso3505029a12.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 11:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781546725; x=1782151525; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=horNH4nAIVX35HLRYM5nbtwV0BBsxMhLrFNMxatw39I=;
        b=fFdroDCj2vzTvZaCcZrIooYsFyb8+pil9uuF137PItPwHvZpZK7qcSLizoMJWOg6JU
         xoD9VSfYW53cp22eU4FCoqCD6ZuO9/hx5hAENlat9BNXNKgSLp6GNw+YX6/TbsGhHjzT
         bdQ7QrgPvUgkXAFqX1ESeRgSghSYh7QwSMh8fcuiGw6OPaE7Z4Dl3OSZXlnf/Rn/FsXC
         CyvwzqkwzRxLzrw1qxVZYUxW1JiuVOEHeVootULLcrOUCUDidIpOYbKIU0pWLYhtNe09
         Tcbyab6VKKm6JBt0+yP73AF7FxbSnnlU0CAKIggS5kvH+XLqNQyYXLG2raqysfHCKqt4
         GDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781546725; x=1782151525;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=horNH4nAIVX35HLRYM5nbtwV0BBsxMhLrFNMxatw39I=;
        b=Kr6S+ytaXWFdO/4eC7iZsO4i/I1Ra02sTITNUadDvL5W/uxpe69ePgyVC6/DYYZquM
         d8bmcpfEgyUvAZMst3MR25TlMsAledH+fBt+VwW2zRpVJAYbRRWI9DId5iliKQTjjNIh
         r9nK03mlXLVceBXZkTOjmlBN/v0G09ELrSIL2eMgFADzmzXubJH6vUU3/9CUm0jtdru+
         iA8gn8+EC07M5Ow20B/QZHSabLVK7hR8yMRT6q3t3vpYCIucdGpCyrm3kGj5GAcTmhuF
         X8yH5l7y4j2feA9uU1/rQ8S95kX2rZXwd7HPa4qWIgP2QBvWAaGpEqCLqCIDjjafZnM2
         BQOw==
X-Forwarded-Encrypted: i=1; AFNElJ8NpH+hv5WLd1BqM3SIqSbPzHPQXyynAmY0W6U+TyFoHxas+100IUrZi9Z/Cg2wFVRE3poqkiE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOLK3ZhmflQg/Fwj4ql9ilFV6nZ0MJG709ETi0bpdueZtZAVH0
	CDV9EuG/Y75PSPsmOWjZYaMvdYnSZuXnNMVA2HYqhHiQiEEbBu1lzcmB1qYNG0NkknSrk+LOdd5
	WqcbbHA==
X-Received: from pgbcs12.prod.google.com ([2002:a05:6a02:418c:b0:c85:61bf:d142])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:438c:b0:398:7256:3c0
 with SMTP id adf61e73a8af0-3b7e47407ddmr231387637.13.1781546725252; Mon, 15
 Jun 2026 11:05:25 -0700 (PDT)
Date: Mon, 15 Jun 2026 11:05:24 -0700
In-Reply-To: <CALzav=fsuDxGViwyFmhR1RmQKugR_tcj70gmq-492thdxJTDPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-10-seanjc@google.com> <20260613003501.DD5951F000E9@smtp.kernel.org>
 <CALzav=fsuDxGViwyFmhR1RmQKugR_tcj70gmq-492thdxJTDPg@mail.gmail.com>
Message-ID: <ajA-5IQ3R5ZO1rSi@google.com>
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026, David Matlack wrote:
> On Fri, Jun 12, 2026 at 5:35=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> > > diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/s=
elftests/kvm/irq_test.c
> > > index 9f8895b898214..6888be54ee4a9 100644
> > > --- a/tools/testing/selftests/kvm/irq_test.c
> > > +++ b/tools/testing/selftests/kvm/irq_test.c
> > [ ... ]
> > > @@ -55,6 +58,36 @@ static void *vcpu_thread_main(void *arg)
> > >       return NULL;
> > >  }
> > >
> > > +static int vfio_setup_msi(struct vfio_pci_device *device)
> > > +{
> > > +     const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> > > +     const int prot =3D PROT_READ | PROT_WRITE;
> > > +     struct dma_region *region;
> > > +
> > > +     /* A driver is required to generate an MSI. */
> > > +     TEST_REQUIRE(device->driver.ops);
> > > +
> > > +     /* Set up a DMA-able region for the driver to use. */
> > > +     region =3D &device->driver.region;
> > > +     region->iova =3D 0;
> >
> > [Severity: Medium]
> > Does hardcoding the DMA region's IOVA to 0 cause IOMMU mapping failures=
 on
> > platforms that reserve or restrict IOVA 0?
> >
> > If IOVA 0 is unsupported, it seems like iommu_map() will fail and trigg=
er a
> > test assertion crash instead of running.
>=20
> This is probably fine for now given the test is only for x86_64. But
> if you are going to send a v8 you can use the VFIO selftests
> iova_allocator to fix this, instead of hard-coding.

I'm confused, why is this test setting up a DMA-able region in the first pl=
ace?
