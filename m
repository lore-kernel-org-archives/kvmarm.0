Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A852989B5;
	Tue, 23 Jun 2026 15:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782228867; cv=none; b=HkXHkeyQ+uHbdrYhzNXt8tuBf5NFyi1FrbbBKWmSbck3ZIjtk+2QjbiqJXzEBkt5S3IP+qdhPxmEmLPADmgZkYj8kU/Wuins17+1D+zc187fnueTHYJFUccGo6KKqve2Q3rVb751XiCNBBi3PnomJ7VMODLaPWatY9kij+xcYEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782228867; c=relaxed/simple;
	bh=gIRk8/dH/9Ok6wjDcROHkcQpcE8Yu5r0x3PZ6G8ETtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJCSy2cvadEG5kKfUTmhD25n4iTUeLdro9aCWlYsEh/dhlDm5Qj7f+Y6kSeu161eNynj/02jVjgzzZTeO9gYOMQe7Fd2vV60lv7nW8K3Ti8YMEcClCdZaTnbSDcPmg8FYiC/YoSDF/rlgGlKcd535FIlYnjCcaDKV3seZDDKnGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGJn1MwZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGJn1MwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767AE1F000E9;
	Tue, 23 Jun 2026 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782228866;
	bh=hh19RcFafqH8E5G1C/9wZeGvWAsVfyorShZjgXnSJqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HGJn1MwZ0aOfDpzane+Lm4pfTOUoOxnSbYzfLhj5C+VkexYKLAhlg0JkfzweFbXiB
	 R0wrgENhHyxBCZHvJsFA1ISoKmVELTKsSnvnCSXWQSYzXGczsSL4rMdJTY9mnOYdS6
	 mMuYyQ+jSt2qB4jQHbpkQLOpaQ7UcEdoefUDJN4/pjQCXRT4A4a5O4J1DcTRbg2g7E
	 w0cbdxe3vK9HKNw1xLkPIsVqT3QtV/kXFHJKCksEGJMEXRiaUqdRBUYLobv8oXUATc
	 LecM7WxALehRAx7Z51kCfMWIhrQAD1Xh60qzAOpWzKVJkeNtxHVR/AbIJGH/HhbfQ1
	 iFG6liCj2QnEA==
Date: Tue, 23 Jun 2026 16:34:21 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 4/4] arm64: Add support for protected VMs
Message-ID: <ajqnfXfp-fCf9jGF@willie-the-truck>
References: <20260619115415.5475-1-will@kernel.org>
 <20260619115415.5475-5-will@kernel.org>
 <CA+EHjTww=aY50itZBv=jUA6VeFNxgzyPkz2bktmW_ua1UdGmbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTww=aY50itZBv=jUA6VeFNxgzyPkz2bktmW_ua1UdGmbQ@mail.gmail.com>

Hi Fuad,

On Fri, Jun 19, 2026 at 02:49:11PM +0100, Fuad Tabba wrote:
> Hi Will,
> 
> On Fri, 19 Jun 2026 at 12:54, Will Deacon <will@kernel.org> wrote:
> >
> > Introduce a new '--protected' parameter which requests the creation of
> > a protected VM type from the kernel. In addition, a reserved DMA region
> > is advertised in the device-tree and VIRTIO_F_ACCESS_PLATFORM is
> > advertised so that virtio transfers can be bounced through a shared
> > memory window.
> >
> > Signed-off-by: Will Deacon <will@kernel.org>
> 
> Two nits below, otherwise:
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Thanks. I'll spin a v2 to address your comments, so I won't add these
for this patch just yet.

> > diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
> > index 60c2d40..8a0a460 100644
> > --- a/arm64/include/kvm/fdt-arch.h
> > +++ b/arm64/include/kvm/fdt-arch.h
> > @@ -1,6 +1,14 @@
> >  #ifndef ARM__FDT_H
> >  #define ARM__FDT_H
> >
> > -enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_MAX};
> > +enum phandles {
> > +       PHANDLE_RESERVED = 0,
> > +       PHANDLE_GIC,
> > +       PHANDLE_MSI,
> > +       PHANDLE_DMA,
> > +       PHANDLES_MAX
> > +};
> > +
> > +void generate_dma_region_prop(void *fdt);
> >
> >  #endif /* ARM__FDT_H */
> > diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
> > index a50e6a4..e7dd526 100644
> > --- a/arm64/include/kvm/kvm-arch.h
> > +++ b/arm64/include/kvm/kvm-arch.h
> > @@ -87,6 +87,8 @@
> >
> >  #define MAX_PAGE_SIZE  SZ_64K
> >
> > +/* Size of DMA region for bouncing when running a protected guest */
> > +#define DMA_MEM_REGION_SIZE    SZ_32M
> 
> Worth scaling with guest RAM, or making it overridable for DMA-heavy guests?

It's a bit difficult to know how much to allocate here. It's some
function of the number of devices, but then it also depends on dynamic
properties such as virtqueue sizes. It shouldn't really be related to
the amount of guest RAM or the DMA throughput.

The number of devices isn't readily known, but even if I did something
horrible like enumerate them from the arch code, I'd then still need a
magic number to multiply that by. I think that making it overridable
would give the user of kvmtool the same headache.

For now, I think I'll add a check to fail if the guest has been
explicitly provisioned with less memory than the bounce buffer (diff
below) but I'll leave anything more advanced for the future if/when we
know what the problems are with a constant size for the pool.


diff --git a/arm64/kvm.c b/arm64/kvm.c
index b899ebd..fb0b98d 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -469,6 +469,12 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
                pr_warning("--e2h0 requires --nested, ignoring");
 
        if (kvm->cfg.arch.protected) {
+               if (kvm->cfg.ram_size &&
+                   kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
+                       die("RAM size (0x%llx) smaller than DMA bounce region (0x%x)",
+                           kvm->cfg.ram_size, DMA_MEM_REGION_SIZE);
+               }
+
                if (kvm->cfg.virtio_transport == VIRTIO_MMIO_LEGACY ||
                    kvm->cfg.virtio_transport == VIRTIO_PCI_LEGACY) {
                        die("Protected VMs require a modern virtio transport");

> > @@ -485,6 +499,7 @@ int kvm__get_vm_type(struct kvm *kvm)
> >  {
> >         unsigned int ipa_bits, max_ipa_bits;
> >         unsigned long max_ipa;
> > +       int type;
> >
> >         /* If we're running on an old kernel, use 0 as the VM type */
> >         max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
> > @@ -500,7 +515,10 @@ int kvm__get_vm_type(struct kvm *kvm)
> >         if (ipa_bits > max_ipa_bits)
> >                 die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
> >
> > -       return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
> > +       type = KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
> > +       if (kvm->cfg.arch.protected)
> > +               type |= KVM_VM_TYPE_ARM_PROTECTED;
> > +       return type;
> >  }
> 
> The "old kernel" path above returns type 0, so --protected is dropped there
> silently. die() rather than downgrade a protection request without a word?

Well spotted, I'd missed the early return. I think I'll set the type to
PROTECTED early, then we'll get a failure from the CREATE_VM ioctl() if
protected VMs are not supported.

Will
