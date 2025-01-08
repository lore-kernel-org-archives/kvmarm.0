Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B4B1F8EFC
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 12:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736338201; cv=none; b=j608aaSUF+cMhgVz/TT8GO0P5nuM73iA2hIh9Ixr/h0RDbTBH631sfBuB4NFNupmB6L+kQ2UCt5F7NCUpjdHmjeG2Ys4lK68d0rHBtiYHy32i3tMtUQCObG5g6LjMPNpjevDh/xYWi2fI2Z4dV0iyMZC0MSxYXKyFlVJtfh8p4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736338201; c=relaxed/simple;
	bh=KWZA7FaB/xpUX8wayT/o1VRAfqkCimMwpNRQp+okz14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKeDWtX0HolRo6W8kRk/lS0O3aQXH+x/d20T1Vwy7RhP+5XhSQ8ZrHIwbPlZFmZDo+ZXoGnNeOzcJQ6oih8YV0btvrFdxOqk3UDvKpYtM/Xl3eyDGcMkf6nChWrNLUcARL3I86wy3qGH1S4wALBBqalUtAuly44jhKAzNcaWGqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XniRdT3p; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XniRdT3p"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso45295e9.0
        for <kvmarm@lists.linux.dev>; Wed, 08 Jan 2025 04:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736338198; x=1736942998; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zD5ySs1xMW37elGTxJ0+L9w74VYfTjKcgoS3/XvpUjM=;
        b=XniRdT3pUfGPoQncw0aTwZ/uPnTENEHyFSHd8Oy0wqi3OHzC2Xx9b5JHfECnp390rJ
         7LIGht7dsBKWGXXNlFZarScOhn/UHqJTaBQCjDXuN0QMxG+qIatjfaa8FzadX+x5mU3C
         Nnj5hnbYQD1LH98BHMBVozxadBcNjBC8xE/KAxai+jo4BaqogLXt19+4fIsRxVc3w9MZ
         xvq0nzaID+DOdia33g2Ib7Jf56+qNAgTLUtDHkQcUHCH224AKMuOAyjXt1v6CHF4Sp07
         dHELof5bv5zAq1Ej/0HCKRpLtmi+ewrkXKq3AsbNhCJtF8NJgOLt9ZWlB3bq+b46hx+a
         7Xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736338198; x=1736942998;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zD5ySs1xMW37elGTxJ0+L9w74VYfTjKcgoS3/XvpUjM=;
        b=oLL2Tmm0hN03iR6rhVBBOE3Q7nNNdX9sUFg2FKyl+nxPguPLMIfqXKsJllx7Ft0AuB
         XXAuJeub7B28Xj9HgEVVsfeAgOVTraglZkN98VNGIugMNiYEHqsdb24WwClJCUyQ1oSt
         LlOJDg0clIp4baqJMSAxzf7+6jH6iQg+sCc8CI1/e8wZsEET4EntP1RxxzlvdeLTnTFk
         7a1943XbB5OUGJr81cwk4nyjqxJawSY/296h2WZtbbixX5ldn82MgIxKKal7ej0hJyFF
         3+tX07NpJhJdkvlXue9dhmtOpMnS+naGCKIXIi5L6vYDaT0uqSEE+KWu/Q/mrzLcE53B
         12/g==
X-Forwarded-Encrypted: i=1; AJvYcCWDA4tIY6I42aA+xshiuG30Vc7ABAQW6JTIve97M5TUIGSkNz6DeREUsiLd4KqliHN1qCNVS5g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJqImnp5Uy9Khp/Qrf5fcYqA+zzZeocB1PXNTgz50cOUAlZY06
	uYgu6q2GAa4B9ni4xvSMKxCefUKAnelrY6+oVn2b++jODYZK2wGfp5J39JscjQ==
X-Gm-Gg: ASbGncuxhDFsdanlCI245g7BtgA0qIEMKiNurl0yOzo+98LzHhJ2M5ZrkB/GcB5aSfG
	Ryf9CA2qcu52J/CyOVQxkyDcH07qfBLdyWsYB2qPke8bvGyOWHboVRyjS2Ne2+E0OIiFEeEYBat
	UOZIdDuHByeB/Wtl29UuvH/Vl3zEIiQOgZ/egK2mkJphQMo2OcjbYVFW8ZXI89a36hlauRSwV5E
	scD04J/F7yvkOqcAmieWlp+Orabz5SDaVGDb8JJgfFYicuRw7qUmjeMhAwWgHBTe7f8D9v8Pqtj
	fMgUeG75JZFfTWn8Tfw=
X-Google-Smtp-Source: AGHT+IHhJ6EobpXq+FBb8+2enCf5xWH/XpfK4IJWQk5eGpRgdF7mTVT7Phnp1PzvaY6tLSY06IxIDg==
X-Received: by 2002:a05:600c:3ca1:b0:436:51cf:285b with SMTP id 5b1f17b1804b1-436e20d9970mr964755e9.4.1736338197790;
        Wed, 08 Jan 2025 04:09:57 -0800 (PST)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e40eadsm18948335e9.44.2025.01.08.04.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 04:09:57 -0800 (PST)
Date: Wed, 8 Jan 2025 12:09:53 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, nicolinc@nvidia.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 00/58] KVM: Arm SMMUv3 driver for pKVM
Message-ID: <Z35rEeSVwfZVA9IF@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250102201614.GA26854@ziepe.ca>

On Thu, Jan 02, 2025 at 04:16:14PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 13, 2024 at 07:39:04PM +0000, Mostafa Saleh wrote:
> > Thanks a lot for taking the time to review this, I tried to reply to all
> > points. However I think a main source of confusion was that this is only
> > for the host kernel not guests, with this series guests still have no
> > access to DMA under pKVM. I hope that clarifies some of the points.
> 
> I think I just used different words, I ment the direct guest of pvkm,
> including what you are calling the host kernel.
> 

KVM treats host/guests very differently, so I think the distinction
between both in this context is important as this driver is for the
host only, guests are another story.

> > > The cover letter doesn't explain why someone needs page tables in the
> > > guest at all?
> > 
> > This is not for guests but for the host, the hypervisor needs to
> > establish DMA isolation between the host and the hypervisor/guests.
> 
> Why isn't this done directly in pkvm by setting up IOMMU tables that
> identity map the host/guest's CPU mapping? Why does the host kernel or
> guest kernel need to have page tables?
> 

If we setup identity tables that either means there is no translation
capability for the guest(or host here) or nesting should be used,
which is discussed later in this cover letter.

> > However, guest DMA support is optional and only needed for device
> > passthrough, 
> 
> Why? The CC cases are having the pkvm layer control the translation,
> so when the host spawns a guest the pkvm will setup a contained IOMMU
> translation for that guest as well.
> 
> Don't you also want to protect the guests from the host in this model?
> 

We do protect the guests from the host, in the proposed approach by
preventing mapping memory from guests(or hypervisor) in the IOMMU or
donating memory currently mapped in the IOMMU.
However, at the moment pKVM doesn’t support device passthrough, so
guests don't need IOMMU page tables as they can’t use any device or issue
DMA directly.
I have some patches to support device passthrough in guests + guest
IOMMU page tables, which is not part of this series, as mentioned host
DMA isolation is critical for pKVM model, while guest device passthrough
is an optional feature (but we plan to upstream that later)

> > We can do that for the host also, which is discussed in the v1 cover
> > letter. However, we try to keep feature parity with the normal (VHE)
> > KVM arm64 support, so constraining KVM support to not have IOVA spaces
> > for devices seems too much and impractical on modern systems (phones for
> > example).
> 
> But why? Do you have current use cases on phone where you need to have
> device-specific iommu_domains? What are they? Answering this goes a
> long way to understanding the real performance of a para virt approach.
> 

I don’t think having one domain for all devices fits most cases, SoCs can have
heterogeneous SMMUs, different addresses sizes, coherency...
Also, the basic idea of isolation between devices where some can be
controlled from userspace, or influenced by external entities, which
should be isolated. (we'd want the USB/network devices to have access to
other devices memory for example)
Another example would be accelerators, where they only operate on contiguous
memory and having such large buffers on phones in phyiscal space is almost
impossible.

I don’t think having a single domain is practical (nor it helps in this case).

> > There is no hacking for the arm-smmu-v3 driver, but mostly splitting
> > the driver so it can be re-used + introduction for a separate
> > hypervisor
> 
> I understood splitting some of it so you could share code with the
> pkvm side, but I don't see that it should be connected to the
> host/guest driver. Surely that should be a generic pkvm-iommu driver
> that is arch neutral, like virtio-iommu.
> 

The host driver follows the KVM (nvhe/hvhe) model, where at boot the
kernel (EL1) does a lot of the initialization and then it becomes untrusted
and the hypervisor manages everything after.

Similarly, The driver first probes in EL1 and does many of the complicated
stuff that is not supported at the hypervisor (EL2) as parsing firmware tables.
And ends up populating a simplified description of the SMMU topology.

Then the KVM <-> SMMU interfaces is not arch specific, you can check that
in hyp_main.c or nvhe/iommu.c where there is no reference to SMMU and all
hypercalls are abstracted so other IOMMUs can be supported under pKVM
(That’s the case in Android).

Maybe the driver at EL1 also can be further split to have a standard
part for hypercall interface and an init part which is SMMUv3 specific,
but I’d rather not complicate things until we have other users upstream..

For guest VMs (not part of this series), the interface and the kernel driver
are completely arch agnostic, similarly to virtio-iommu.

> > With pKVM, the host kernel is not trusted, and if compromised it can
> > instrument such attacks to corrupt hypervisor memory, so the hypervisor
> > would lock io-pgtable-arm operations in EL2 to avoid that.
> 
> io-pgtable-arm has a particular set of locking assumptions, the caller
> has to follow it. When pkvm converts the hypercalls for the
> para-virtualization into io-pgtable-arm calls it has to also ensure it
> follows io-pgtable-arm's locking model if it is going to use that as
> its code base. This has nothing to do with the guest or trust, it is
> just implementing concurrency correctly in pkvm..
> 

AFAICT, io-pgtable-arm has a set of assumptions about how it's called,
that’s why it’s lockless as the DMA API should follow those assumptions.
For example you can’t unmap a table and an entry inside the table concurrently,
that can lead to UAF/memory corruption, and this never happens at the moment as
the kernel has no bugs :)

However, pKVM always assumes that the kernel can be malicious, so a bad kernel
can issue such a call breaking those assumptions leading to UAF/memory corruption
inside the hypervisor. Which is not acceptable, so the solution is to use a lock
to prevent such issues from concurrent requests.

> > Yeah, SVA is tricky, I guess for that we would have to use nesting,
> > but tbh, I don’t think it’s a deal breaker for now.
> 
> Again, it depends what your actual use case for translation is inside
> the host/guest environments. It would be good to clearly spell this out..
> There are few drivers that directly manpulate the iommu_domains of a
> device. a few gpus, ath1x wireless, some tegra stuff, "venus". Which
> of those are you targetting?
> 

Not sure I understand this point about manipulating domains.
AFAIK, SVA is not that common, including mobile spaces but I can be wrong,
that’s why it’s not a priority here.

> > > Lots of people have now done this, it is not really so bad. In
> > > exchange you get a full architected feature set, better performance,
> > > and are ready for HW optimizations.
> > 
> > It’s not impossible, it’s just more complicated doing it in the
> > hypervisor which has limited features compared to the kernel + I haven’t
> > seen any open source implementation for that except for Qemu which is in
> > userspace.
> 
> People are doing it in their CC stuff, which is about the same as
> pkvm. I'm not sure if it will be open source, I hope so since it needs
> security auditing..
> 

Yes, as mentioned later I also have a WIP implementation for KVM (which is
open source[1] :)) that I plan to send to the list (maybe in 3-4 months when
ready) as an alternative approach.

> > > > - Add IDENTITY_DOMAIN support, I already have some patches for that, but
> > > >   didn’t want to complicate this series, I can send them separately.
> > > 
> > > This seems kind of pointless to me. If you can tolerate identity (ie
> > > pin all memory) then do nested, and maybe don't even bother with a
> > > guest iommu.
> > 
> > As mentioned, the choice for para-virt was not only to avoid pinning,
> > as this is the host, for IDENTITY_DOMAIN we either share the page table,
> > then we have to deal with lazy mapping (SMMU features, BBM...) or mirror
> > the table in a shadow SMMU only identity page table.
> 
> AFAIK you always have to mirror unless you significantly change how
> the KVM S1 page table stuff is working. The CC people have made those
> changes and won't mirror, so it is doable..
> 

Yes, I agree, AFAIK, the current KVM pgtable code is not ready for shared
page tables with the IOMMU.

> > > My advice for merging would be to start with the pkvm side setting up
> > > a fully pinned S2 and do not have a guest driver. Nesting without
> > > emulating smmuv3. Basically you get protected identity DMA support. I
> > > think that would be a much less sprawling patch series. From there it
> > > would be well positioned to add both smmuv3 emulation and a paravirt
> > > iommu flow.
> > 
> > I am open to any suggestions, but I believe any solution considered for
> > merge, should have enough features to be usable on actual systems (translating
> > IOMMU can be used for example) so either para-virt as this series or full
> > nesting as the PoC above (or maybe both?), which IMO comes down to the
> > trade-off mentioned above.
> 
> IMHO no, you can have a completely usable solution without host/guest
> controlled translation. This is equivilant to a bare metal system with
> no IOMMU HW. This exists and is still broadly useful. The majority of
> cloud VMs out there are in this configuration.
> 
> That is the simplest/smallest thing to start with. Adding host/guest
> controlled translation is a build-on-top excercise that seems to have
> a lot of options and people may end up wanting to do all of them.
> 
> I don't think you need to show that host/guest controlled translation
> is possible to make progress, of course it is possible. Just getting
> to the point where pkvm can own the SMMU HW and provide DMA isolation
> between all of it's direct host/guest is a good step.

My plan was basically:
1) Finish and send nested SMMUv3 as RFC, with more insights about
   performance and complexity trade-offs of both approaches.

2) Discuss next steps for the upstream solution in an upcoming conference
   (like LPC or earlier if possible) and work on upstreaming it.

3) Work on guest device passthrough and IOMMU support.

I am open to gradually upstream this as you mentioned where as a first
step pKVM would establish DMA isolation without translation for host,
that should be enough to have functional pKVM and run protected workloads.

But although that might be usable on some systems, I don’t think that’s
practical in the long term as it limits the amount of HW that can run pKVM.

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/smostafa/android15-6.6-smmu-nesting-wip

Thanks,
Mostafa

> 
> Jason
