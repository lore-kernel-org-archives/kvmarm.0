Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C927D535FCC
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178913; cv=none; b=rQ8qhEee+33HuNmHytkHECpktAS3Uf+xBxxN8ssMU1DlQqFUl41eLYELzxfy8S1bkmPT2D0RbJ4hq2mPSWz3ru+U3ujpIdAT0XYFuVxBWnBH+jh7+lqj9XwYE0NM+IExRYb+fK0fgeBRFyYCj61KE3KnbYGyhA9KvjL8QUweQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178913; c=relaxed/simple;
	bh=b8T/ubLHuLaCB4whaPYyYa1q8z2vcOAafgGggYdRfXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRJ6FfHMmNo1qNnLOaQVZFKPitZkhE5i3A2RXf1VBcigSMjpAj6wq4j9U7Iz5o8wn8oi7zNSDXs9ShojOPx8Q2nKYjfU842O9tej0T+rCVVYeflwBOJT5BgZiIo07rYHd7EYNU4mR08VIDXaCbbss2Y5aVNfkX0FY/ddOzg5fAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Z2WoyxhQ; arc=none smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Z2WoyxhQ"
Received: by mail-vs2-f40.google.com with SMTP id 71dfb90a1353d-5c9b0bdf5b5so486326e0c.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 08:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790178911; x=1790783711; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L2p6lfpmyK6oEUo0D1kSTcomcrX7eHQSl2rXfKoXoeA=;
        b=Z2WoyxhQCENBKMt9/W7B0cJEx0bnHr8DuEgZ16CGk1sfZifAbVz/hOSD2jY+zOYWE0
         luzitrLouQpnKIww/Lq39RLrbNTUV/HDD11DjwIGA/I9bfRktDe0pRjdbjgZkvVbLB/Z
         N02ul/wkwQnXnPX50qY94gYM9jSOaPFEKfk7tmjvGdby4F/uLOAMiAvlpPQOo2j2ZwnH
         fCcR2ToXvfVsGpIUW/ixl37xYHA5PEp3FMaavPpXh3p4uSvww3dJyne+lnpgZ8owoLm4
         cMFz6hxApp6Jl0U+JM+SB81r0Xiq0q7hiRhcBxbZAZI+oha0Wg8Y/HHb51jQh0IXePbK
         SPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178911; x=1790783711;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L2p6lfpmyK6oEUo0D1kSTcomcrX7eHQSl2rXfKoXoeA=;
        b=PNcQe3yfrkCFD2rZo/JsEca//TbNq6L4z3KCglhk150fvJ1pnE1oEIf+PKWkru2B9M
         kWgpEjmK5Qs3O0lXDBuFyNgW0KR3NDc7hF0Qee5xhTMymDirMxOsV2l9m4t5obEoOLO5
         Vyc98m68/a9wJ5pT3ZPdk1AKXbvNpVwhY/0R8cZapgZpMstzr38ivB+fYOyujgBPjMGO
         RsJzqaGaQf6vxJChHNA8fLJnQ1+elU/NTBk4vbqYj/68ecYQ16ekvrTaBJ3oRyybkiLn
         TvB/DQ3+8vdao0GIeRDHsL904rExluSVtWk81FKa3phPz+eFS9kVWa167QvKFdj+y+qH
         W3rA==
X-Forwarded-Encrypted: i=1; AKwUvByn0w8/3OTZ96TRX7bZuu5CEg7b+GBeKt4Pz7M06glDsnV7bqZJM9Uqq4ApMjY3wicI80O6Sdw=@lists.linux.dev
X-Gm-Message-State: AFuF++mgbXFvtxqekEkKixF0sWeqbr/GNw7/50oAoyKprK/+Q1um02SD
	wTlYFbSOww76OMV2TzCitw5Pss8K8BC2qMGAd12GT8bBbPsVPV++1mBUjdrTUS8cf80=
X-Gm-Gg: AYBFou05TndsGX+LcD1WVUyJWxSAUZUFpBurLHfIZ4tZMHatZmMeAKqjkF1CP5nAsXD
	H8eGr8wDFKdY7KIQSf8LncEiDnJBizt8/aphhYe61gTfS+SuBvh5hqG5sAbIXj64TGjVWBQqYrU
	OibAwsRgebtZN1r/OoTARFOhXaZeaNRxMsu1wHlwcP1kV55u/UVcMu3Q/EmRpW4ezT6Bd5kPw0O
	fGu/EkFFobdGggo4MsyBWUUsw2ON7qH4du1zUnzPhrRA6AxD5Y009UMNcMjwCe90UobUy7uiO8p
	sERWhOeRH50+7DiSoCKH2cv2M/YN6HdbN9qk18AP5U+SyVzHFlWcBE5hThk4Hcw3l0V8HgOwbeF
	bSuAGkpavzTR49mlzMhl8uV7DMuYD8QmErCUtaaGpHfN3zdnaRjcu40FOyK73Q8opqA2ua7PekH
	LEVqsO+BEuusuhc9N2uogKvbNG8f5Gt+I7nN5QRXxfs668zBqSY0wUhxM=
X-Received: by 2002:a05:6122:338f:b0:5c9:a60b:e5c8 with SMTP id 71dfb90a1353d-5c9f1666ee8mr3394069e0c.11.1790178910702;
        Wed, 23 Sep 2026 08:55:10 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9f0551688sm3382770e0c.15.2026.09.23.08.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:55:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9PJM-0000000DwH2-043G;
	Wed, 23 Sep 2026 12:55:08 -0300
Date: Wed, 23 Sep 2026 12:55:07 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <20260923155507.GJ1540250@ziepe.ca>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-12-smostafa@google.com>
 <arMbxX+sqTS3gByB@nvidia.com>
 <arO9hGmEx7c9mZAj@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arO9hGmEx7c9mZAj@google.com>

On Wed, Sep 23, 2026 at 11:52:36AM +0000, Mostafa Saleh wrote:
> I can add more info in the cover letter about the code split. Mainly:
> - arm-smmu-v3-kvm.c: Is the kernel driver for KVM SMMUv3 (this runs in
>   EL1 and can use all the kernel functions).
>   The main job of this driver is for discovery, it doesn't do anything
>   else in the runtime.

Maybe call this el1 stub or something like that?

guest_pkvm_stub.c
pkvm/hyp.c

?

> > > +extern struct pkvm_iommu_ops kvm_nvhe_sym(smmu_ops);
> > > +
> > > +static size_t				kvm_arm_smmu_count;
> > > +static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
> > > +static size_t				kvm_arm_smmu_cur;
> > 
> > That spaces/tabs in those two lines look a bit odd..
> > 
> 
> These are tabs to indent the variables, similar cases exist in the
> SMMUv3 driver, check arm_smmu_cmdq and friends for example.

Personally I hate this style, it is a huge PITA for maintenance and
makes diffs bigger than they need to do. I remove it whenever I have
the chance :)

> TBH, this is a bit of a hack. The hypervisor can not allocate memory
> at the runtime. All of the hypervisor memory comes from a carveout
> allocated at boot (see kvm_hyp_reserve())
> 
> So we allocate the worst case for memory mapping with leaf granule. But
> the hypervisor also need to allocate L2 pointers and the SID space can
> be massive making the upper limit for this too large.
> 
> However, smmu_hyp_pgt_pages() defines the minimum pages required,
> actual allocation comes from the command line, so it is possible to
> tune the system without re-compiling the kernel.
> 
> Thinking about it now, we can just drop the 500 as this is the lower
> bound, earlier versions of this series would allocate the carveout
> based on this size, but it is not needed anymore.

I see, and you can't scan the ACPI to figure out all the SIDs used at
this point to get an exact estimation?

Not being able to manage memory after boot is rather an extreme
limitation.. But a huge amount of RMM's API complexity comes from its
granular memory management so I can't really fault that..

Jason
