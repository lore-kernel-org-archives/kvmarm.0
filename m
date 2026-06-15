Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE713B2FCE
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 20:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781553882; cv=pass; b=jDcAXSaMDLMy1IaMWwvgX7DkRT2I2a6j/eGYEiXxGqwknAdCEZNGZLknlkShMtCDS1hIyk51hrP3YyKxc5LzfJIwZQ3Gx4XelexVZCzy8tu5O1bJTt3U/HfEBvpHw1ZncF9htXaZ+lkgUWhLChvfUBsRkg1ukVtlcgxex9BzmuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781553882; c=relaxed/simple;
	bh=owPIg6ubh/DQddddT9GGtMkMgKnfwbpYGJjt+//AIJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGRKUWTH9UVjxHiKFZgy0BQPNPJor8hyUfFSPkfwX9xqJImR8VlMRHMmYcE6g1iLj6nBADapttUJiN4K4YyZkXe0JiSo37NnZhykt+tsMnTAPJ/jbJZSRAEw3c5rSCVlKktUhljhdBFLPTuVaSAQB6XCs+3ylCy7B8jWd+DItAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IAB88H0e; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAB88H0e"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1384eb94d20so6478952c88.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:04:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781553881; cv=none;
        d=google.com; s=arc-20240605;
        b=P7c9F63o6mLuiyWdHeVeJe9KIsIid9urSbhzc5WFCcVQ/D+a/8MKrGsfb8u3W+kKeq
         uRJXWvRgFUPtIbT5Tlx7nttW06SAG+wYt6sZEQFhCpJRYydMg8PwZVbXvSJWBkbcN+Bj
         AsXXAUk5wuHhCg96tAg2JhSTVCnTgtkvN2goV2htTN7Cd2SpChGN5LBqnJWgkBOoCvIH
         Ubt94p0AF11zlgfcNVRnaMLMPK21EcTiN1roUuAyA+2bN4Hx17jbyZuQA0loG08XNBeF
         oeuADlNc5dT6n1h9E/5AGQqtES5RbHEcQvX3shELU0SBISCafqnX6q3i29IIezID8QZe
         VFog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r3cAuZhgye1IsU1gMrp56etonTXBcaPhEeVfCnENr6Q=;
        fh=6VnQG0D98aJx2Uxi0VCi4K7eSZWjR3nQC7c8z4M4Xws=;
        b=L5ZnOCsm4WzM/UmcCKDNJlwObjAaEAukpsbXw7gEM6Cj4TiyPgyZFZ2THx0Ry+HU8e
         nrXsyBOe+BIPmJpVZT3uUSeLxBOA/xa5Miw3LDrdN4C/Hfq+93chxczI+QNYUB93H6k6
         NnaCXaRrEsVILttqKkqykOovAN983UvuwYXgi79gMG1SP95/lDdOqEAaD5g8JGt7kxyf
         H3z60ONky56vWy2z5ckU9nfuzBeEwvU1tOLmWD70D0I072muOWjR5M4pD4yS+BQpi5JH
         5e+L5sh5dvLqOIZPTZxM5MgVRmSzLcVhoKjo/ZRTuLUh3YIQksqTuUATFPTgjTV3JqI5
         mUTA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781553881; x=1782158681; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r3cAuZhgye1IsU1gMrp56etonTXBcaPhEeVfCnENr6Q=;
        b=IAB88H0ehb+fXLHHwIqgOxMgkM/ODxmjW2F9TLz9qqM/5uEkLfjnzntb6SQQeC9c+x
         s+CAwdtaIQPICSENQrPnd9TY4v+yj6Iq/4BWQ98qrOumqZSjvtYLv5Sdkai282t2Zuj5
         6c9tu1TO5iEijyG3qATpTuQiiQfETPnIiXAZg2OwHufBiSpi4A+HaQN27nZE3aRQR3Re
         STPP5q27F0Tv/vNUAHJvnzml9GmkJ6l70fAkKkYBIMzjqWRidrkLRbIXII/jYjQuNWt2
         mceh3/HefwuVn03KWvfgUXzSa+Q/ts8jAF9BM1iGsruqCJk8YuejVpgDLq3i1mprh+D0
         SBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781553881; x=1782158681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r3cAuZhgye1IsU1gMrp56etonTXBcaPhEeVfCnENr6Q=;
        b=o/Z4UJAOza6l8T9EkIT0F3sb57jPTRXRCYW8739XPcD9kV62n360rCAPBw3LG/AQGm
         dVkxltqUG5dwXtcMJVVfNbZwi1t773zZ2YxSMOEy9fQAW/69neJZWtAUKW15CMR6Kntn
         Osc5rRuc0JqNVhuLjvXMqO2M9vdxQqFqP+dC396yLetMrgRyPkhuwTEdaWRkNeAc0W99
         UhGrV9fdzaNbLzPuxnNVq/lI5mVFEN6Ohe32b4Omupw4EYHPOCw0EjdrlGCmMnq8uJsr
         fIn+P0+/BA96+EGIQrQudaQrzEZP0XVfmRwsLQ3Bh45TZLxK3Qq0D4JM+JwYxlnQ+KtC
         MrIg==
X-Forwarded-Encrypted: i=1; AFNElJ/Ur3n5odw5vTInRNusytwgIryhDTGk2zlx17Y+UsgdVEkmWbtdoA/dMhpJoocKjn0W1xZ2je0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz26lNkfPzFWCCJttNyKjsdLSHr2b1bCdAVupHFfHgSVrrK8W4h
	/LlAH/PTIZLwaKeuTW43EN0bschWvaXJJS2iBemAgmyfK2Sz07izKyC/APFzA434FC9RsX5pR1f
	kNiB/IGDccjuFDiFz0qGwLQAFG4LAy6bvWwWMaG3r
X-Gm-Gg: Acq92OFsO8f1g6SmW4HD0sGk0rK1NNwpO2Wgc9M5sZdl3ly1Jv/yW2X5tMaYuPxZB+n
	rmjkkkBhpDXWtjzqB7Ogy9Qcz5jdly/KZOVE54TevsFlENx3hvp74MI8kOily6C4591L4J+6831
	KG+HMqyZ7FGNUhqEyYTsnqHN6ypFsCAkLQ+dSgaH8vR/on/TeRYfRwrWEfUmgGsNFwgTwH2SzAL
	j58VHVNIZw0j6b9x4yXTF7CavWQ/J5t38L5R5TaJmv4Jf6QWYwl+peZsDQ8U3AopBtOuLXXwn9Y
	+lgCE1QqH3Bqj8kK/A==
X-Received: by 2002:a05:7022:30d:b0:136:d421:9efa with SMTP id
 a92af1059eb24-1386f38f398mr6171219c88.32.1781553879982; Mon, 15 Jun 2026
 13:04:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260613002031.745413-10-seanjc@google.com> <20260613003501.DD5951F000E9@smtp.kernel.org>
 <CALzav=fsuDxGViwyFmhR1RmQKugR_tcj70gmq-492thdxJTDPg@mail.gmail.com>
 <ajA-5IQ3R5ZO1rSi@google.com> <CALzav=fQ5FENWgGNEqQrmb-i_9fWTRhLXj2-jZKC_zjM3Kg6PA@mail.gmail.com>
 <ajBQ3YEAMyKnJWYb@google.com>
In-Reply-To: <ajBQ3YEAMyKnJWYb@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 15 Jun 2026 13:04:13 -0700
X-Gm-Features: AVVi8Cd_8D6rihsAKEHaL9-XhAcm___nO2rBi-Wv8z6QEvOUnZocWEMFIMLJIV4
Message-ID: <CALzav=efwGdF+q1-_kMREvshbYTqWT4P_+U6Vs_brktvWub09g@mail.gmail.com>
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
To: Sean Christopherson <seanjc@google.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 12:22=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Jun 15, 2026, David Matlack wrote:
> > On Mon, Jun 15, 2026 at 11:05=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > On Mon, Jun 15, 2026, David Matlack wrote:
> > > > On Fri, Jun 12, 2026 at 5:35=E2=80=AFPM <sashiko-bot@kernel.org> wr=
ote:
> > > > > > diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/tes=
ting/selftests/kvm/irq_test.c
> > > > > > index 9f8895b898214..6888be54ee4a9 100644
> > > > > > --- a/tools/testing/selftests/kvm/irq_test.c
> > > > > > +++ b/tools/testing/selftests/kvm/irq_test.c
> > > > > [ ... ]
> > > > > > @@ -55,6 +58,36 @@ static void *vcpu_thread_main(void *arg)
> > > > > >       return NULL;
> > > > > >  }
> > > > > >
> > > > > > +static int vfio_setup_msi(struct vfio_pci_device *device)
> > > > > > +{
> > > > > > +     const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> > > > > > +     const int prot =3D PROT_READ | PROT_WRITE;
> > > > > > +     struct dma_region *region;
> > > > > > +
> > > > > > +     /* A driver is required to generate an MSI. */
> > > > > > +     TEST_REQUIRE(device->driver.ops);
> > > > > > +
> > > > > > +     /* Set up a DMA-able region for the driver to use. */
> > > > > > +     region =3D &device->driver.region;
> > > > > > +     region->iova =3D 0;
> > > > >
> > > > > [Severity: Medium]
> > > > > Does hardcoding the DMA region's IOVA to 0 cause IOMMU mapping fa=
ilures on
> > > > > platforms that reserve or restrict IOVA 0?
> > > > >
> > > > > If IOVA 0 is unsupported, it seems like iommu_map() will fail and=
 trigger a
> > > > > test assertion crash instead of running.
> > > >
> > > > This is probably fine for now given the test is only for x86_64. Bu=
t
> > > > if you are going to send a v8 you can use the VFIO selftests
> > > > iova_allocator to fix this, instead of hard-coding.
> > >
> > > I'm confused, why is this test setting up a DMA-able region in the fi=
rst place?
> >
> > There might be some devices with which you can trigger an MSI with
> > pure MMIO. But most devices you need to at least set up some
> > descriptors in memory that describe what action you want the device to
> > take and then use MMIO to poke the device to read the desriptor and
> > perform the action. Reading those descriptors is DMA.
> >
> > For Intel DSA specifically, send_msi() works by telling the device to
> > perform an 8-byte memcpy and send an interrupt when it's done. The
> > driver region contains the descriptor for that memcpy, as well as the
> > 8-byte source/destination buffers the device should use.
>
> Ah, gotcha.  For a comment, how's this look?

That looks great!

>
> diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selft=
ests/kvm/irq_test.c
> index 6888be54ee4a..9a495fdb52f5 100644
> --- a/tools/testing/selftests/kvm/irq_test.c
> +++ b/tools/testing/selftests/kvm/irq_test.c
> @@ -67,7 +67,12 @@ static int vfio_setup_msi(struct vfio_pci_device *devi=
ce)
>         /* A driver is required to generate an MSI. */
>         TEST_REQUIRE(device->driver.ops);
>
> -       /* Set up a DMA-able region for the driver to use. */
> +       /*
> +        * Set up a DMA-able region for the driver to use.   Very few dev=
ices
> +        * provide a way to arbitrarily send interrupts (MSIs), e.g. by w=
riting
> +        * an MMIO register.  Instead, most devices send MSIs when an act=
ion is
> +        * completed, and practically all actions involve DMA of some for=
m.
> +        */
>         region =3D &device->driver.region;
>         region->iova =3D 0;
>         region->size =3D SZ_2M;
