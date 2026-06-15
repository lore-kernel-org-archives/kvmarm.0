Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E97537997E
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781548363; cv=pass; b=ojDBOqk3+FdwQJbD/0xawJpJanFpKtrsJjVpdCywqLfL7ulLTrI4ytnru/ag5h+dEo+oEZe/edszlc3W7BhG6arIlevFL342KlAslCxy57zk+IQeWdcmL0U6cnUp8dnCOJmycUF/qrnUCHShJw70o6pDriEfCiatBNObY3hQjEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781548363; c=relaxed/simple;
	bh=eUCd4cJRHM4c506P0iJJojFx6MYUj6RH7trS4Dt2rhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N5a68e47nDi9YT6Qs7F2sWvY+4p+UVybP1hzrbMCn4DZAMa6LzVrGP3BPrgGruNW3dN16KnGnPOinaXkhmWpYVJBGm1jG3nHDpqrEHPlIN+c1xZNO7I+1tdehOJiBYj6CQ8BOeIA41I1o9PXKHO223CijvB5EA28hndgngPhXTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XMJTROq/; arc=pass smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XMJTROq/"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-13981833e13so965699c88.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 11:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781548359; cv=none;
        d=google.com; s=arc-20240605;
        b=hVtfxfNfjM10RxJNKHUAmVWj3oA6Fb4zqjMYCrFFYG3oG4Myvgo11cp4CxTORR6oaf
         vGjT9o3tSx7jnGSB1zw6BRMiX/9v8/h/oE8t+QWZfxc0hy/ogfoFtlENbm7CXGMfoQww
         3/29rwfe2CRJy8eLDyq1D8/aCmUhkpR4CLV9bcAtQCTZQBKgqhgIUuAM3ZbhSAOhyuR9
         itfiwW4TN4LFvOHWvKkhaeKSvOEKPCl+kYy7XN0mPlCL0Mzlphv4GsgdG7iBsdngARfm
         K1iyA4VZkKCWaa55jwzCy6HJRWYV2eMwxgJoncctg+QP673FntQMmWlbgycHnVFZb8F8
         idiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u1m9kOyZU75L8F6PL/t68prlNj72GILewPQGDqJwRY8=;
        fh=jQ0RQNF5IzBbpYUfn0dc0q3osGMzkZKcMMOdgEathgY=;
        b=WJYSWma8a+3Hf+H5XuXVNXlK4eo6Z3X3LIvrBjcrfCHJTjiQoaJLB53HhJkyyQJatT
         5NXwrhoWOi1K2zxx37shxKtvcA228tIHs6JKSMNJ1YLQ0zCZ91onBiZC/LQ2FfWf3Q0d
         HiYr38Z8NMO7Rjb9Pw4GtaL7lckToJPUYASD51p5wCle0SxTi6sok3dv5MlmmWmDELy6
         XaHozUNZ+Cs4stzEhnK6mgCsPHayEBH4PjoH9s/HjXA8JnR8vE7gGmSqq1w39bNfxEzV
         vFXaxDQoq7ucrR5TUsHzkaQ3NxdkC+OWbZODUDqwo7XiZnWKcrGbsbTzibrEgBWHmhSD
         RZfw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781548359; x=1782153159; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1m9kOyZU75L8F6PL/t68prlNj72GILewPQGDqJwRY8=;
        b=XMJTROq/Qi0roZvEwxhI3D8d2wZVCkccb4+M3ApkdsJbV4/0dsBEGjfyK2F8vNMbNQ
         b5hyEjdJqLK4LjgM7DbL/mkLjmf41p6NoxmqD4WqefiuajkjHJJYkeQs0tIPmDklckaZ
         5zIoClkEgC9pXD9cN1KZjr5J/H8DCGmjSJtbEOogeJwUn0qN+b9Z8U9NeiN9t9yQmS4I
         aX8tax66/Y7wr7U/tDgooLy+bqrmk6yZC2Z6QMvpEE0vN1l3A76icOio5+0yDHCF1xPz
         lJo57aS6nFJyCVGTISUr5mVfVadunwoXhCscfwkE26zpAGaou60p51JlwKc+vYyn4SqL
         PsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781548359; x=1782153159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u1m9kOyZU75L8F6PL/t68prlNj72GILewPQGDqJwRY8=;
        b=giUa6MFSF6P5656IkeOFF/ohhYfWGnTtut/zEbU1dMv+f4eNcANLLqK+PBjqI1W5G8
         ECCR0k1Eyy5a371GKPhNlx98xlOYrB0Y6ewBpfC8Gl4lsBJPU/9xpstgP/a8Dz7oku/G
         4BRUaz9xgLbkrUozLW8WRiV3dZ02s9Bvtb/Bq+IXsrlPbpYupcbHeR8ghllVCvZWF+I6
         C4vbu53/1aFat0oKOUqjsTj6h/3JZkiu5Xrk4sbTtNWa2CLurkDZfukquA5ujjDSh3aY
         ml3N+YLHNXoRX9ebNu+Uh5hqwaTkBB0zBfBx10tTTcH8N3T4vEm4G4klpgMxEXThTMW5
         gweQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Uek924ZoP38bo4PorSHJUKyjFATj50ruhBsgb4ewRuEp1VsNo8xLbAtmqFyGfzx/XUrd10AI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt6GzSyXUJo/V3gsVpj+jQ7oVLxQzZRcYwS5r0KpvmE7rD2l6x
	0Vj/Z0wrIPsOrFOuSmL/1x3QWpkZCsso5zwYY9FKxHsHko3dBrCTAWgPTcu2PhsnkdRsPr3fFk+
	PEVLj7BoSShilBPz2sGj6ne/0mUPk3YDa6Zaq+1bz
X-Gm-Gg: Acq92OGkG1fN+SwrUPisNz3MYflt5F4bAPOz4OR5Wyg27FqlzdvPKOKE0za93ZT90Dm
	xJ5m5y5rV1uxUGOpcXsfJxCE7o2btIIu2xFMU0JaXIj0evGiWz2Rl5OduJpsiexg6fKvFFzJrsA
	4bXtVCtQDZ5lPQcMkQzFUdQxLoe1l3zJ82NtfFzDqJI1FfVZ2PACDUnYn6npa+E0NVjFU0ArJon
	Z+KlSjgthqE+qOgTKgk/VQgTUCNsRUIS54+V4tHT5ko6yU6DJj2CWVAoal7li78prg3XSR7BmXy
	6FPSbbc=
X-Received: by 2002:a05:7022:b9d:b0:137:977e:628a with SMTP id
 a92af1059eb24-1384bb695b3mr6525813c88.24.1781548357704; Mon, 15 Jun 2026
 11:32:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260613002031.745413-10-seanjc@google.com> <20260613003501.DD5951F000E9@smtp.kernel.org>
 <CALzav=fsuDxGViwyFmhR1RmQKugR_tcj70gmq-492thdxJTDPg@mail.gmail.com> <ajA-5IQ3R5ZO1rSi@google.com>
In-Reply-To: <ajA-5IQ3R5ZO1rSi@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 15 Jun 2026 11:32:11 -0700
X-Gm-Features: AVVi8CeXW89dotygEGvUfQ8kwO0uK3wZRBF_hx_oCn0HZD93ikHved6sUFUl0K0
Message-ID: <CALzav=fQ5FENWgGNEqQrmb-i_9fWTRhLXj2-jZKC_zjM3Kg6PA@mail.gmail.com>
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
To: Sean Christopherson <seanjc@google.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 11:05=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Jun 15, 2026, David Matlack wrote:
> > On Fri, Jun 12, 2026 at 5:35=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> > > > diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing=
/selftests/kvm/irq_test.c
> > > > index 9f8895b898214..6888be54ee4a9 100644
> > > > --- a/tools/testing/selftests/kvm/irq_test.c
> > > > +++ b/tools/testing/selftests/kvm/irq_test.c
> > > [ ... ]
> > > > @@ -55,6 +58,36 @@ static void *vcpu_thread_main(void *arg)
> > > >       return NULL;
> > > >  }
> > > >
> > > > +static int vfio_setup_msi(struct vfio_pci_device *device)
> > > > +{
> > > > +     const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> > > > +     const int prot =3D PROT_READ | PROT_WRITE;
> > > > +     struct dma_region *region;
> > > > +
> > > > +     /* A driver is required to generate an MSI. */
> > > > +     TEST_REQUIRE(device->driver.ops);
> > > > +
> > > > +     /* Set up a DMA-able region for the driver to use. */
> > > > +     region =3D &device->driver.region;
> > > > +     region->iova =3D 0;
> > >
> > > [Severity: Medium]
> > > Does hardcoding the DMA region's IOVA to 0 cause IOMMU mapping failur=
es on
> > > platforms that reserve or restrict IOVA 0?
> > >
> > > If IOVA 0 is unsupported, it seems like iommu_map() will fail and tri=
gger a
> > > test assertion crash instead of running.
> >
> > This is probably fine for now given the test is only for x86_64. But
> > if you are going to send a v8 you can use the VFIO selftests
> > iova_allocator to fix this, instead of hard-coding.
>
> I'm confused, why is this test setting up a DMA-able region in the first =
place?

There might be some devices with which you can trigger an MSI with
pure MMIO. But most devices you need to at least set up some
descriptors in memory that describe what action you want the device to
take and then use MMIO to poke the device to read the desriptor and
perform the action. Reading those descriptors is DMA.

For Intel DSA specifically, send_msi() works by telling the device to
perform an 8-byte memcpy and send an interrupt when it's done. The
driver region contains the descriptor for that memcpy, as well as the
8-byte source/destination buffers the device should use.
