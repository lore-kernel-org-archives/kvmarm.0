Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B2B407CD0
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539038; cv=pass; b=pqiw+oOZA9gTzbcHTk27JupZpb8FWaQP4SvZjaJyQVcD6eaxxlFER52gZnO5lAeb3kOx20eeJxGmeKDg5xEKaXYcbpKWRBBWwNR58k4T65m8nlNmpUAV/7QYupfOmFqFuz2gTk8nF9N3taBYI1RWjaTfcO3TK4eniSX4ScEKk00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539038; c=relaxed/simple;
	bh=I37MB9QFZWg/iySQ+8norqI1EgSDbMtxgGAg8twF0Ug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KhooCsVSK3dDCrgDgKv51wQhYdRmstktMQG+8x75TmNMNZ3Oz9DpCSPQXHvM9/C6Mx+fpkGYO57As21hRpGWfySMY9QsumPJb3G1YUCT3KTlrqQsrOZDyRUi1InPK7VJXKCf67/h2s/xaWPgEBwqK1o2xhL1d2jxVJw75WytuKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RxNy/CQ7; arc=pass smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RxNy/CQ7"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-137eb0d76beso2996494c88.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 08:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781539036; cv=none;
        d=google.com; s=arc-20240605;
        b=ODGkMMKDZWmQqo6RBJp+vzdF+p0tYgRGoTGPzUpZatYzldRwKOixooweuqz/LjaNAu
         lMYJ0s2GLUba3anG4TujulWlGJ9K3+m3qvV616Nk5K0Vk+QfMReQB9FMGe2A9El8HY5L
         NJYjGo9qE+jeZr02p3RyZbuaCTX2mjtLP7y4D3u94uqmbOMSWtAU+bBZ8imJ/I3SQYq+
         gN9t6m+sYM4UQwLKgdRtBn7T30HBI8I9XcodxSvqG1+RwDDOJcp3TRql4ta8kUnosS/0
         lmNxEb/QMe3Ren/en2OOYqoEcH3qOl8DJsW5lJI2SQMpbalYtrM5gU9Mg798JSVLM1FS
         YNCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n14dIJ5dht73f40pb4IMJ7S3kt8QyoHAMkgZkWPngd4=;
        fh=KCCu9uifthWqwsq0oNUyxVqhQwjpzBXwV/UWSfPj8RU=;
        b=WMuHLEPbTeYv5sGzw8+wkgzkabW3HaI5IRl1sEu3Qin97RnJ+QZazME0HoDKKsgjeE
         //7Mm4AnV26nZBgcTTvz7wdvlPcj+Rlm+9FOa94qN3G95Hs1SIr4AXpiloZxEr5QB9ZJ
         Ag6NzCigcow3eUO6/DD1b6s1Rahcs3bQFmZRI4dCP8Hi1avP3xCq4+HdENR1zfjFCCnh
         uWNUVHPNaI2yZoQ1sLOgUOdqGh62GYT5PcqDNLjtJ4DE41tYQAw4kTmAAKFeEJa3GIO4
         pAF7HFfcYQbzFRrm2b6beMYuaBOtFWs2daDZvmXcEa3Tw7PnBeUM08mi4pOlf0rmlvj4
         y/uQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781539036; x=1782143836; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n14dIJ5dht73f40pb4IMJ7S3kt8QyoHAMkgZkWPngd4=;
        b=RxNy/CQ7nzg4Ipwd76Midf4r/WKM2/sd/p1RJ06bqyWCMTFESz/U3HyuQKJ/g1ZmmA
         hSd2dHdGnKn7yrU14NweSxyRBuEXZKJnkReGUtkXgFS12iugYUwV3IH8oh9EFZqtMPTB
         OksWC7yu0feFxlZMjxbCOYTzA4AUsrgrV0zlmh5whozOyryHMpSGZ/HXuFUGVD/1CtCj
         bgRtTSnjMC4k7QEQ5ltdk0r8lSCsNsCm7A76mWy5RLEAWRSyAWoSbCvRij+1LBKZwMlb
         +gTd2gMi6oENQ9T4+DDDb0UeiMZTmGOEMNXEcm+EIB6Upvd+4UjJ2K0mrSsv/5oNKXvf
         amHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781539036; x=1782143836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n14dIJ5dht73f40pb4IMJ7S3kt8QyoHAMkgZkWPngd4=;
        b=fvZxr1uc209C/W7pGMrtnzmh8kzBdBsOkIqxtqM/8bbe6CroG2bCOKBA4CMx9ufOQK
         7n12Tz8BF35TvF/ZA/5R930FznJJ2Jia9CWcHa1oZl7nEbZ1kQf6YrDIr4sCqMaLv1pf
         cR0afVcIK3bhdktSNaGDlg/Y5zcuDBJF9UZfqrDeISCJzUSB6O7KmrT8pUWQi89fEzwt
         xQtiToWg9kbGoL4EiAo/LnumRcOg3gECEQIP6/x8wNLtpTDTkOnUuzJcFPgQpuus3RTZ
         7GMZQmwi4ihHAYQy2onGTRIaSqNWX1nAGgdVQxPemM3kA87S4rjSuSOUms2FVbV1jQWm
         Aq4Q==
X-Forwarded-Encrypted: i=1; AFNElJ9Od9hL7UcSY2zHzLaWXX3isfP//i+ihKtFA49cCuJTPpbXD0FUM/PHM4QOGfuqW5TcgD9kTLU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBO64diLiZYakc91FHb5wIHZ5QZfnEZzmole4eo9xIeB02sjUO
	7PtqzPhBppxBzsI4J+RzqiRxIhX1J/FymV4ASQENJDKZrMtc+CLlZytpmBKMT+4YG3FVHVrq573
	eusdUNtKCyHqbX2iXFk7CtDe5WI4UMR3us/yKZHYN
X-Gm-Gg: Acq92OE1Kl+mGRm5Fe8griXnUKP+O1RLKJJtiM29K7LeiSkcJ8jEuuw6nSHsDyrs+lg
	NRvakiCiy998VmOR8xW1n7jB0o1R8hJaJAlyHq5rlEW4rRjKWO1BCT7zVabYEZeLHdnvptCNoNf
	Gw5WY6wR1KYOp6DI7AccAF07wYs6/34zHn6wolBSA5ANgp9BdDX/HY+W8bCGeZrmPuGTZ9IJwMc
	nqXudS3ra6k6s3rku5VxCqXKxe0tWJlFG2CZhUb+8pWU/ujoCKgwYkiqk3GzG9M4W3jdZ4LdKpc
	3PQZslk=
X-Received: by 2002:a05:7022:4a7:b0:12a:6abf:ab1c with SMTP id
 a92af1059eb24-139857e5543mr28154c88.11.1781539035442; Mon, 15 Jun 2026
 08:57:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260613002031.745413-10-seanjc@google.com> <20260613003501.DD5951F000E9@smtp.kernel.org>
In-Reply-To: <20260613003501.DD5951F000E9@smtp.kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 15 Jun 2026 08:56:48 -0700
X-Gm-Features: AVVi8CekucRmafRLaV5f36SS8Dg8ifzasU0WhAhm20QRKJwpK2-KPAIj-ny6Jk8
Message-ID: <CALzav=fsuDxGViwyFmhR1RmQKugR_tcj70gmq-492thdxJTDPg@mail.gmail.com>
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
To: sashiko-reviews@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2026 at 5:35=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Medium] probe_iommu_type() incorrectly probes the /dev/vfio directory =
instead of the /dev/vfio/vfio legacy container character device, bypassing =
the framework's intended skip behavior for unprivileged users.
> - [Medium] vfio_setup_msi() hardcodes the device's DMA region IOVA to 0, =
which can cause IOMMU mapping failures on platforms that reserve or restric=
t IOVA 0.
> --
>
> commit 2bdd8160743775c8d18e4004e72e7ff0898fbd70
> Author: David Matlack <dmatlack@google.com>
>
> KVM: selftests: Add VFIO device support to eventfd IRQ test
>
> This commit extends the eventfd IRQ test to support triggering interrupts
> using a VFIO device instead of manually signaling the eventfd. It also
> probes for IOMMUFD vs legacy VFIO availability.
>
> Link: https://lore.kernel.org/all/20260602222941.3133236-1-jrhilke%40goog=
le.com [1]
>
> > diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/sel=
ftests/kvm/irq_test.c
> > index 9f8895b898214..6888be54ee4a9 100644
> > --- a/tools/testing/selftests/kvm/irq_test.c
> > +++ b/tools/testing/selftests/kvm/irq_test.c
> [ ... ]
> > @@ -55,6 +58,36 @@ static void *vcpu_thread_main(void *arg)
> >       return NULL;
> >  }
> >
> > +static int vfio_setup_msi(struct vfio_pci_device *device)
> > +{
> > +     const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> > +     const int prot =3D PROT_READ | PROT_WRITE;
> > +     struct dma_region *region;
> > +
> > +     /* A driver is required to generate an MSI. */
> > +     TEST_REQUIRE(device->driver.ops);
> > +
> > +     /* Set up a DMA-able region for the driver to use. */
> > +     region =3D &device->driver.region;
> > +     region->iova =3D 0;
>
> [Severity: Medium]
> Does hardcoding the DMA region's IOVA to 0 cause IOMMU mapping failures o=
n
> platforms that reserve or restrict IOVA 0?
>
> If IOVA 0 is unsupported, it seems like iommu_map() will fail and trigger=
 a
> test assertion crash instead of running.

This is probably fine for now given the test is only for x86_64. But
if you are going to send a v8 you can use the VFIO selftests
iova_allocator to fix this, instead of hard-coding.

>
> > +     region->size =3D SZ_2M;
> > +     region->vaddr =3D kvm_mmap(region->size, prot, flags, -1);
> > +     TEST_ASSERT(region->vaddr !=3D MAP_FAILED, "mmap() failed\n");
> > +     iommu_map(device->iommu, region);
> > +
> > +     vfio_pci_driver_init(device);
> > +     return device->driver.msi;
> > +}
> [ ... ]
> > @@ -74,11 +107,29 @@ static void kvm_route_msi(struct kvm_vm *vm, u32 g=
si, struct kvm_vcpu *vcpu,
> >       vm_ioctl(vm, KVM_SET_GSI_ROUTING, &routing.header);
> >  }
> >
> > +static const char *probe_iommu_type(void)
> > +{
> > +     int io_fd;
> > +
> > +     io_fd =3D open("/dev/iommu", O_RDONLY);
> > +     if (io_fd >=3D 0) {
> > +             close(io_fd);
> > +             return MODE_IOMMUFD;
> > +     }
> > +
> > +     io_fd =3D __open_path_or_exit("/dev/vfio", O_RDONLY,
>
> [Severity: Medium]
> Because /dev/vfio is a directory, will this open() call succeed for any u=
ser
> with read and execute permissions to the directory, bypassing the intende=
d skip
> behavior?
>
> Should this probe the /dev/vfio/vfio legacy container character device in=
stead
> so the test can skip gracefully for unprivileged users rather than crashi=
ng
> later in iommu_init() due to lack of device permissions?

I agree with Sashiko here.

>
> > +                                 "Is VFIO (or IOMMUFD) loaded and enab=
led?");
> > +     close(io_fd);
> > +     return MODE_VFIO_TYPE1_IOMMU;
> > +}
> > +
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613002031.74=
5413-1-seanjc@google.com?part=3D9
>
