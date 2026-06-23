Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62623126CA
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 16:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232713; cv=none; b=tv86SWPMr2TyP3uIs9zi5D4IqS6SzoleGCTIPmXkeMGQxZbaegKYx1NNLt5mQ8cUfbejbxOim9MUHo5zBqPYd1g9vNnRb3/b5uKjELRCyCXjBlnQVXvXDPIn+qhnk08Y7uzuT6h8SdP7MAdPiaIQJXR6CawS2e8bdm6EFukb/wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232713; c=relaxed/simple;
	bh=n+qriYgrqouj+1c4+SmQndBvyfOULEtCNKjdtvVakd8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+/b3IQzJqDfqZw/mTPC/ZfEQFgP//i2jrEaVQyiI2hf2CbWiD5o1AFIPw1JXoFmNKKD1XDPP3HzKufv9bDCnMpXeNSCttsnnvA5zoO5GG7mLTLpZDfy+Afqi8OSQCvhzLT94twE5VtRNSc9ekM9ih2hN9pB/jVVBOdJEkdLayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eYClMzfK; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eYClMzfK"
X-Forwarded-Encrypted: i=1; AFNElJ9tPCxj5+yCJI40lKx/Kuhx4XlYw1gEQEDE2C6r/aP381k+oAwC6yYS1fUn9ephCCDPogO2BxU=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782232708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MaKIQxli5kPHwVQOPiqDqjLzAzG60m9mmazbfzG2D20=;
	b=eYClMzfK81HR9A6RZ0aw6lrfxKm3dCUxakK9fvXN/ZbcfBcCwFPTZVhyLCdXCk06yze5NE
	WLzhSlWoiN78D9BFCGH3ItH9DdDhbrE/EJ/gUNNgdKmwC1iNP+wJ5MKFMp+LQt2gOOMno9
	Nj86jyzrU6pFzZlf7U7kDC0MQ1m58NI=
X-Gm-Message-State: AOJu0YypvmwYhojoTbsFdIF98fXY3X5+fe3Y4lJjgKhycAvBDwsZDsVO
	BxsCIlYf5pniYz8gzOwqpBvFmlvsb7gTUemYVjIWQUJhyNLz0TO5E7dbiKIltFarx2qLb0Eeajl
	//EfP0Xjm6YO5xMAgdheDiramXW2XJlxvaUCFXXn6
X-Received: by 2002:a05:622a:4cc6:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-51a53d74f1amr9976461cf.5.1782232705412; Tue, 23 Jun 2026
 09:38:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619115415.5475-1-will@kernel.org> <20260619115415.5475-5-will@kernel.org>
 <CA+EHjTww=aY50itZBv=jUA6VeFNxgzyPkz2bktmW_ua1UdGmbQ@mail.gmail.com> <ajqnfXfp-fCf9jGF@willie-the-truck>
In-Reply-To: <ajqnfXfp-fCf9jGF@willie-the-truck>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 23 Jun 2026 17:37:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw1oBemFxUGH7wwDjpawtE=c_NXwcW+ajhBGuJEMtJwgg@mail.gmail.com>
X-Gm-Features: AVVi8CdUdVL8WSwfnz1RfLwWIOes2zLYG8PflnglHXK8QeTVlq4VVXuytBLisEk
Message-ID: <CA+EHjTw1oBemFxUGH7wwDjpawtE=c_NXwcW+ajhBGuJEMtJwgg@mail.gmail.com>
Subject: Re: [PATCH kvmtool 4/4] arm64: Add support for protected VMs
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 23 Jun 2026 at 16:34, Will Deacon <will@kernel.org> wrote:
>
> Hi Fuad,
>
> On Fri, Jun 19, 2026 at 02:49:11PM +0100, Fuad Tabba wrote:
> > Hi Will,
> >
> > On Fri, 19 Jun 2026 at 12:54, Will Deacon <will@kernel.org> wrote:
> > >
> > > Introduce a new '--protected' parameter which requests the creation of
> > > a protected VM type from the kernel. In addition, a reserved DMA region
> > > is advertised in the device-tree and VIRTIO_F_ACCESS_PLATFORM is
> > > advertised so that virtio transfers can be bounced through a shared
> > > memory window.
> > >
> > > Signed-off-by: Will Deacon <will@kernel.org>
> >
> > Two nits below, otherwise:
> >
> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
>
> Thanks. I'll spin a v2 to address your comments, so I won't add these
> for this patch just yet.
>
> > > diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
> > > index 60c2d40..8a0a460 100644
> > > --- a/arm64/include/kvm/fdt-arch.h
> > > +++ b/arm64/include/kvm/fdt-arch.h
> > > @@ -1,6 +1,14 @@
> > >  #ifndef ARM__FDT_H
> > >  #define ARM__FDT_H
> > >
> > > -enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_MAX};
> > > +enum phandles {
> > > +       PHANDLE_RESERVED = 0,
> > > +       PHANDLE_GIC,
> > > +       PHANDLE_MSI,
> > > +       PHANDLE_DMA,
> > > +       PHANDLES_MAX
> > > +};
> > > +
> > > +void generate_dma_region_prop(void *fdt);
> > >
> > >  #endif /* ARM__FDT_H */
> > > diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
> > > index a50e6a4..e7dd526 100644
> > > --- a/arm64/include/kvm/kvm-arch.h
> > > +++ b/arm64/include/kvm/kvm-arch.h
> > > @@ -87,6 +87,8 @@
> > >
> > >  #define MAX_PAGE_SIZE  SZ_64K
> > >
> > > +/* Size of DMA region for bouncing when running a protected guest */
> > > +#define DMA_MEM_REGION_SIZE    SZ_32M
> >
> > Worth scaling with guest RAM, or making it overridable for DMA-heavy guests?
>
> It's a bit difficult to know how much to allocate here. It's some
> function of the number of devices, but then it also depends on dynamic
> properties such as virtqueue sizes. It shouldn't really be related to
> the amount of guest RAM or the DMA throughput.
>
> The number of devices isn't readily known, but even if I did something
> horrible like enumerate them from the arch code, I'd then still need a
> magic number to multiply that by. I think that making it overridable
> would give the user of kvmtool the same headache.
>
> For now, I think I'll add a check to fail if the guest has been
> explicitly provisioned with less memory than the bounce buffer (diff
> below) but I'll leave anything more advanced for the future if/when we
> know what the problems are with a constant size for the pool.

Sounds good to me.

>
>
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index b899ebd..fb0b98d 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -469,6 +469,12 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
>                 pr_warning("--e2h0 requires --nested, ignoring");
>
>         if (kvm->cfg.arch.protected) {
> +               if (kvm->cfg.ram_size &&
> +                   kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
> +                       die("RAM size (0x%llx) smaller than DMA bounce region (0x%x)",
> +                           kvm->cfg.ram_size, DMA_MEM_REGION_SIZE);
> +               }
> +
>                 if (kvm->cfg.virtio_transport == VIRTIO_MMIO_LEGACY ||
>                     kvm->cfg.virtio_transport == VIRTIO_PCI_LEGACY) {
>                         die("Protected VMs require a modern virtio transport");
>
> > > @@ -485,6 +499,7 @@ int kvm__get_vm_type(struct kvm *kvm)
> > >  {
> > >         unsigned int ipa_bits, max_ipa_bits;
> > >         unsigned long max_ipa;
> > > +       int type;
> > >
> > >         /* If we're running on an old kernel, use 0 as the VM type */
> > >         max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
> > > @@ -500,7 +515,10 @@ int kvm__get_vm_type(struct kvm *kvm)
> > >         if (ipa_bits > max_ipa_bits)
> > >                 die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
> > >
> > > -       return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
> > > +       type = KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
> > > +       if (kvm->cfg.arch.protected)
> > > +               type |= KVM_VM_TYPE_ARM_PROTECTED;
> > > +       return type;
> > >  }
> >
> > The "old kernel" path above returns type 0, so --protected is dropped there
> > silently. die() rather than downgrade a protection request without a word?
>
> Well spotted, I'd missed the early return. I think I'll set the type to
> PROTECTED early, then we'll get a failure from the CREATE_VM ioctl() if
> protected VMs are not supported.

Better than what I suggested.

Thanks!
/fuad

>
> Will
