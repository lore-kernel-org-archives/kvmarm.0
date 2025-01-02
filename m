Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E351B6D0E
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 20:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735848980; cv=none; b=tcajYC/5FWW1XZ0doGmA2LJyJlVyLFrbi2Srbd6zpuDdVYDV8/i14ISTZlDnH/seYrQSM6KsDsm3Wp8dK1iA+Wj2Xp4e6LRJSeYCJJNUVLZhebkppx0CB4jN29Z707fq2+NOzvDAZ3tUYm5hTxQcu8ryY0RaCkJowYVzXxgsFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735848980; c=relaxed/simple;
	bh=6imrvA7m2bLgskAmwgyelcGonntWzninOVyv9RcVvYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhNAv3nFcovH5Tfj9yyasAtmY7jTI0h2kX+AjSkrCWkMwQ+yXqlVx0gZFTigIp/2syGrjque4A9kejzChJXWgqeLE6osurPzLItU1miHXoiSEXk+bFQut9OACSklbYEW/ABKc36rV81eGICyWfPE38RA2bi+g5TdnhVxaVfMGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=UeejrMj3; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="UeejrMj3"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6dcd4f1aaccso41016856d6.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Jan 2025 12:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1735848976; x=1736453776; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e2a4dqMVLYy1RoN4xN8k6L4FT1iFqHXekN0TayfuDGM=;
        b=UeejrMj3kQmD4YNbqfIIhXn2V7HXOkJd4Yape3U8+V/inkA5BnN9vcxhzFzohTq0jj
         DynR2tSKjANh4aSki2B0qCKjslnrdYTahmNsG9Ak3189QKjBUSiFF1jWo4ZYj7oJEmqM
         DWj4/naBkZl8JoytH4gRQzWd5cm1IWxTufB17wESYJnC8b9uFuXYh/yh4yQLy1ERu0R5
         n8kUF5jhaHvpjjpivCuK6RLaZGwSK79rNSVhVX3k4vUwkhLllhdzDQhP3Iagekc/E19v
         Cj1qypcyYw+PUyRI2Vkds7KBarJlIF6Kfm0seRP2jlvTbgODbe+0Ri0Dj1pu1g86Ch11
         ACvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735848976; x=1736453776;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e2a4dqMVLYy1RoN4xN8k6L4FT1iFqHXekN0TayfuDGM=;
        b=TOhAIiBqB5ziQ+uOaIaAdA18+6R3zHXkexoEJQKjD0jgnU4n/VKgs5K6JEm6tPBiEb
         +8AaO/opvmCG6GYx6oOrgkcGAre9VtIhNsYyVhEpOBYnzVyStTDa3cT6BpE1tOIr4Q6d
         ekpF4GS4J8VDQu823u3ZcyFGtxsB2/SDVDtR/jrcNn0ukMc0hw5jt9iuY4XS4MpzxzUp
         naf5YaUZsz0ep/0yBwY5uvFwcQcQsd0iSY3gaWyqydLINALYkoDeuPlijvFCYjbXxrZ1
         VI0iYhPmIM09mLogtgWiHXWZkt7bqsrNOQpEMoZAI4mfiE4uVh90iv6DnKr/QAbg6Yoe
         yKjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwz9iuTKg6XsMxmBfcWd8QO3LT7qYwYrgHgF5fLspWLE3g58uG5EqwRCkoFcRUl8J/dfUzmc8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZs+4bSWUCfP4clA61ochfuZDKdZtD4qHz3hzDm7H4ab2yb/w7
	V532Bj35yMXi0f98d1BZbPjLW29HvmhX9VCNa/5E3LDD+JKe+8pgCPzS1QY7kxA=
X-Gm-Gg: ASbGncv2Ns0raLHOondd+cWY5mbDnS8FDr2lL8LZ8CoegCaXmWdC29ATE1wGFHAB9Np
	yoOF/NdfD+YAzqVlJR6VAGyJCUzW5Z+RqhMbBIJ6vcDyUSm9UoxLX/JWTvx8WW5Fv4huzNw+CNo
	IGXmuTGUtBMVy8OJB6OY/aaAATOuD+Tu1g2ZGfhlsDosCQSWYxw9zBO6lpie0ZvhYaNQ0zOc7eK
	/RhIilgSwLLlduUZaYV7sV77XKwKsv3+diYzXf84VTPs1HvHxe6cTIFNCbjwKutmmX4Mce1vlbM
	jpGWCwbHIOhK3dN6dpTCXJ7A6T5pew==
X-Google-Smtp-Source: AGHT+IG1lsiTAkszVzWv4dKENAN1XpNcbgLjo9B5AvUmLgMSUNBzBN1F+M1fOLMzRfxQBJioY5NWAg==
X-Received: by 2002:a05:6214:27e8:b0:6d4:1662:348c with SMTP id 6a1803df08f44-6dd233383f0mr669824266d6.17.1735848976076;
        Thu, 02 Jan 2025 12:16:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ddc5a56c40sm1904426d6.32.2025.01.02.12.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 12:16:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tTRc6-00000000MEA-1FCS;
	Thu, 02 Jan 2025 16:16:14 -0400
Date: Thu, 2 Jan 2025 16:16:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, nicolinc@nvidia.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 00/58] KVM: Arm SMMUv3 driver for pKVM
Message-ID: <20250102201614.GA26854@ziepe.ca>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z1yNWI9lBNIZg6Le@google.com>

On Fri, Dec 13, 2024 at 07:39:04PM +0000, Mostafa Saleh wrote:
> Thanks a lot for taking the time to review this, I tried to reply to all
> points. However I think a main source of confusion was that this is only
> for the host kernel not guests, with this series guests still have no
> access to DMA under pKVM. I hope that clarifies some of the points.

I think I just used different words, I ment the direct guest of pvkm,
including what you are calling the host kernel.

> > The cover letter doesn't explain why someone needs page tables in the
> > guest at all?
> 
> This is not for guests but for the host, the hypervisor needs to
> establish DMA isolation between the host and the hypervisor/guests.

Why isn't this done directly in pkvm by setting up IOMMU tables that
identity map the host/guest's CPU mapping? Why does the host kernel or
guest kernel need to have page tables?

> However, guest DMA support is optional and only needed for device
> passthrough, 

Why? The CC cases are having the pkvm layer control the translation,
so when the host spawns a guest the pkvm will setup a contained IOMMU
translation for that guest as well.

Don't you also want to protect the guests from the host in this model?

> We can do that for the host also, which is discussed in the v1 cover
> letter. However, we try to keep feature parity with the normal (VHE)
> KVM arm64 support, so constraining KVM support to not have IOVA spaces
> for devices seems too much and impractical on modern systems (phones for
> example).

But why? Do you have current use cases on phone where you need to have
device-specific iommu_domains? What are they? Answering this goes a
long way to understanding the real performance of a para virt approach.

> There is no hacking for the arm-smmu-v3 driver, but mostly splitting
> the driver so it can be re-used + introduction for a separate
> hypervisor

I understood splitting some of it so you could share code with the
pkvm side, but I don't see that it should be connected to the
host/guest driver. Surely that should be a generic pkvm-iommu driver
that is arch neutral, like virtio-iommu.

> With pKVM, the host kernel is not trusted, and if compromised it can
> instrument such attacks to corrupt hypervisor memory, so the hypervisor
> would lock io-pgtable-arm operations in EL2 to avoid that.

io-pgtable-arm has a particular set of locking assumptions, the caller
has to follow it. When pkvm converts the hypercalls for the
para-virtualization into io-pgtable-arm calls it has to also ensure it
follows io-pgtable-arm's locking model if it is going to use that as
its code base. This has nothing to do with the guest or trust, it is
just implementing concurrency correctly in pkvm..

> Yeah, SVA is tricky, I guess for that we would have to use nesting,
> but tbh, I don’t think it’s a deal breaker for now.

Again, it depends what your actual use case for translation is inside
the host/guest environments. It would be good to clearly spell this out..
There are few drivers that directly manpulate the iommu_domains of a
device. a few gpus, ath1x wireless, some tegra stuff, "venus". Which
of those are you targetting?

> > Lots of people have now done this, it is not really so bad. In
> > exchange you get a full architected feature set, better performance,
> > and are ready for HW optimizations.
> 
> It’s not impossible, it’s just more complicated doing it in the
> hypervisor which has limited features compared to the kernel + I haven’t
> seen any open source implementation for that except for Qemu which is in
> userspace.

People are doing it in their CC stuff, which is about the same as
pkvm. I'm not sure if it will be open source, I hope so since it needs
security auditing..

> > > - Add IDENTITY_DOMAIN support, I already have some patches for that, but
> > >   didn’t want to complicate this series, I can send them separately.
> > 
> > This seems kind of pointless to me. If you can tolerate identity (ie
> > pin all memory) then do nested, and maybe don't even bother with a
> > guest iommu.
> 
> As mentioned, the choice for para-virt was not only to avoid pinning,
> as this is the host, for IDENTITY_DOMAIN we either share the page table,
> then we have to deal with lazy mapping (SMMU features, BBM...) or mirror
> the table in a shadow SMMU only identity page table.

AFAIK you always have to mirror unless you significantly change how
the KVM S1 page table stuff is working. The CC people have made those
changes and won't mirror, so it is doable..

> > My advice for merging would be to start with the pkvm side setting up
> > a fully pinned S2 and do not have a guest driver. Nesting without
> > emulating smmuv3. Basically you get protected identity DMA support. I
> > think that would be a much less sprawling patch series. From there it
> > would be well positioned to add both smmuv3 emulation and a paravirt
> > iommu flow.
> 
> I am open to any suggestions, but I believe any solution considered for
> merge, should have enough features to be usable on actual systems (translating
> IOMMU can be used for example) so either para-virt as this series or full
> nesting as the PoC above (or maybe both?), which IMO comes down to the
> trade-off mentioned above.

IMHO no, you can have a completely usable solution without host/guest
controlled translation. This is equivilant to a bare metal system with
no IOMMU HW. This exists and is still broadly useful. The majority of
cloud VMs out there are in this configuration.

That is the simplest/smallest thing to start with. Adding host/guest
controlled translation is a build-on-top excercise that seems to have
a lot of options and people may end up wanting to do all of them.

I don't think you need to show that host/guest controlled translation
is possible to make progress, of course it is possible. Just getting
to the point where pkvm can own the SMMU HW and provide DMA isolation
between all of it's direct host/guest is a good step.

Jason
