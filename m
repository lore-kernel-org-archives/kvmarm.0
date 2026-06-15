Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D1438550E
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781551328; cv=none; b=Xi4/TFX+c9AYf1hIUTIYTXU9vFnetvhYgANXS3Z2dstKaJiD5IEUgdUa6qiGctVYI47vnl/ygM4ZxFRLME0gANUCUUrdDlgEXw+rkIVe5wEhZeNv5mV/jowjDUIthSqWariMRD5OSrx696JFLVPq9qKPiHctm4IRQp1RZFojlJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781551328; c=relaxed/simple;
	bh=5i4d8xUU0LEBZ0Fk0Xp0weKyNN/NHRZWQOsmriTvg+E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oekbfK/dXR1uKPSr7mIbV9ZB97kfl6qCxQl4sCODaS9K9mH1bJZ9AbKh2S2xkLunRF2FPfQG/8bjlZrUQUSsYEzBe/3bn1c/N38U8D2mVhIMQ7yLd8ov3kXzhonPrXsJm8/eJbL9i9N01zTeFTQcgUKLYv4LPICyJt3HE1yO2Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hbYpsWbz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hbYpsWbz"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bd04e4fe3dso94954795ad.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 12:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781551326; x=1782156126; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7k10tUfFaZEAStRGxgcvcSPRJkvCTKPLLnET1wYWZI=;
        b=hbYpsWbzJaC5HFLRsTYbkF5IkLcuQJjtdaF2bTbBM09RQgnwI6XYT6eQdQQmoY4Rv5
         mf+pnqlMB2NN6q1xrjvJ8D0fVzhmiTkZXs8wZdvdWUzFfflPf1e0+K9jju+fntiAjPB0
         jMrW9xTVGCdG7bVCh9svPQdlqQ+2xL1tbKaNL2yOeIR0mkKOiuXVokqW3MtTMbA0rm1m
         e1Z4WcuQVVAJU8a/Lv6Rvj/z4a50UaDP3IYiWnmU8eHUy4N7SzsGpV1tqNWLLYdgjHP2
         upSGHvcBjjtjEX2juyCXugNouC03WMOJ8ZwmxRQpc1fmZ0935bHtZSSc+S/C81HQyQtG
         gAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781551326; x=1782156126;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y7k10tUfFaZEAStRGxgcvcSPRJkvCTKPLLnET1wYWZI=;
        b=sjAysN3SZV10aDSwDHXY6GH7i+9udDl8k9o+YKyLCvnOX31KmT0avQ65KohKQcRooK
         J2q+G0VHR/H8GwwR6VIIctvtOuHwibJjir0jAF2XNde28229904f+VsQcxKqMAxVbQaY
         F+cV6CDe6RDcuzszwfxo7ZpZnpa9IFIympkqoqGj9yJ7wIr7DMx2z+zvetJW5AHKbJV5
         AYSNPA0Xmc7zunkr9F5T7DPVfuc3u1ZfWgRHQnAhepMDJ+NSIQQj3m096CdSn9G5g75C
         5GL2J8xK5R5KwwLIGBBiDS6X34hf/jNPmei9+qOcJ9GK6cqgTqRBytqi3PniqiQb6aiL
         ZCeQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WV0//+T+6bx/dj9sAHCPsz4TwKPoA8K56jj0/+4hV+5NkGsrgEhK30PQk2m+CBE9XVGStwFE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxS/Oy2/3l8K7iA91JY5deMRSEawetvunwsgUhF4grE82pTjVTs
	7SoM71A6xmOWh8NR/V9QJH3oBh1iqBo4Wf78xllTJf4oqdjzT/weBBnOw+PBZMBGy1XYoYIb0D/
	3IFZokQ==
X-Received: from pllj1.prod.google.com ([2002:a17:902:7581:b0:2c2:daa2:d34f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1252:b0:2c1:42d2:40a
 with SMTP id d9443c01a7336-2c69a0f5275mr5247775ad.9.1781551326051; Mon, 15
 Jun 2026 12:22:06 -0700 (PDT)
Date: Mon, 15 Jun 2026 12:22:05 -0700
In-Reply-To: <CALzav=fQ5FENWgGNEqQrmb-i_9fWTRhLXj2-jZKC_zjM3Kg6PA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-10-seanjc@google.com> <20260613003501.DD5951F000E9@smtp.kernel.org>
 <CALzav=fsuDxGViwyFmhR1RmQKugR_tcj70gmq-492thdxJTDPg@mail.gmail.com>
 <ajA-5IQ3R5ZO1rSi@google.com> <CALzav=fQ5FENWgGNEqQrmb-i_9fWTRhLXj2-jZKC_zjM3Kg6PA@mail.gmail.com>
Message-ID: <ajBQ3YEAMyKnJWYb@google.com>
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026, David Matlack wrote:
> On Mon, Jun 15, 2026 at 11:05=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Mon, Jun 15, 2026, David Matlack wrote:
> > > On Fri, Jun 12, 2026 at 5:35=E2=80=AFPM <sashiko-bot@kernel.org> wrot=
e:
> > > > > diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testi=
ng/selftests/kvm/irq_test.c
> > > > > index 9f8895b898214..6888be54ee4a9 100644
> > > > > --- a/tools/testing/selftests/kvm/irq_test.c
> > > > > +++ b/tools/testing/selftests/kvm/irq_test.c
> > > > [ ... ]
> > > > > @@ -55,6 +58,36 @@ static void *vcpu_thread_main(void *arg)
> > > > >       return NULL;
> > > > >  }
> > > > >
> > > > > +static int vfio_setup_msi(struct vfio_pci_device *device)
> > > > > +{
> > > > > +     const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> > > > > +     const int prot =3D PROT_READ | PROT_WRITE;
> > > > > +     struct dma_region *region;
> > > > > +
> > > > > +     /* A driver is required to generate an MSI. */
> > > > > +     TEST_REQUIRE(device->driver.ops);
> > > > > +
> > > > > +     /* Set up a DMA-able region for the driver to use. */
> > > > > +     region =3D &device->driver.region;
> > > > > +     region->iova =3D 0;
> > > >
> > > > [Severity: Medium]
> > > > Does hardcoding the DMA region's IOVA to 0 cause IOMMU mapping fail=
ures on
> > > > platforms that reserve or restrict IOVA 0?
> > > >
> > > > If IOVA 0 is unsupported, it seems like iommu_map() will fail and t=
rigger a
> > > > test assertion crash instead of running.
> > >
> > > This is probably fine for now given the test is only for x86_64. But
> > > if you are going to send a v8 you can use the VFIO selftests
> > > iova_allocator to fix this, instead of hard-coding.
> >
> > I'm confused, why is this test setting up a DMA-able region in the firs=
t place?
>=20
> There might be some devices with which you can trigger an MSI with
> pure MMIO. But most devices you need to at least set up some
> descriptors in memory that describe what action you want the device to
> take and then use MMIO to poke the device to read the desriptor and
> perform the action. Reading those descriptors is DMA.
>=20
> For Intel DSA specifically, send_msi() works by telling the device to
> perform an 8-byte memcpy and send an interrupt when it's done. The
> driver region contains the descriptor for that memcpy, as well as the
> 8-byte source/destination buffers the device should use.

Ah, gotcha.  For a comment, how's this look?

diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftes=
ts/kvm/irq_test.c
index 6888be54ee4a..9a495fdb52f5 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -67,7 +67,12 @@ static int vfio_setup_msi(struct vfio_pci_device *device=
)
        /* A driver is required to generate an MSI. */
        TEST_REQUIRE(device->driver.ops);
=20
-       /* Set up a DMA-able region for the driver to use. */
+       /*
+        * Set up a DMA-able region for the driver to use.   Very few devic=
es
+        * provide a way to arbitrarily send interrupts (MSIs), e.g. by wri=
ting
+        * an MMIO register.  Instead, most devices send MSIs when an actio=
n is
+        * completed, and practically all actions involve DMA of some form.
+        */
        region =3D &device->driver.region;
        region->iova =3D 0;
        region->size =3D SZ_2M;
