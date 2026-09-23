Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155004E77EF
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183285; cv=none; b=Ys7tLCSDFLFmfHdlI/4m3Az0xmM56xc3/7yUcMh0jgEnkrfo8Wkj2gDVqXVmjTlefFFHkB5TiD6sP9lm1LKM/5rHOPHoNLDCeOHMMozPSXn9iAqx/tCCREMJddWVx/dOx6+7HBYs6kuQI7siOjDaW5pKY+fRTPKrwrYApiJ/K/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183285; c=relaxed/simple;
	bh=cNl6b6j0ZD9iEUUf0B0ghdkeaT66llrYIqOEGQey0qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elTIDraMjLN7yBUvgETfnQXzzj7KiRnksS1XabaG5r0Kx1NtcPmGa0xfUk9lGf4gSDUxOBq4m8PLgNyanazxBvSCFNVA3mBMAynf/p9yQcJ2yTDEYG0gJiQNcdMCh8L0FgZ+DMXjfrkFC/xHlSc8Zyx47W1HXoNQZjYcpyFoHn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SVZi0vuM; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SVZi0vuM"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49e65a8f70eso1235e9.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 10:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790183282; x=1790788082; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+sWyggwBV1D9IUYjZa6aLkPXJtAz+OTvh2XpzdjOSmY=;
        b=SVZi0vuMGx3BobVbLY8KLjNIzeFZzkiDkQQ+U1RzSVfJYUw6ERltw4dgxeKC48W98r
         Fjn+60ltX3rIrID+u3JOExY8oCIxQTPu8izWMyWmsHZaqi7q92DSVOeTbwm1V5E2ipU1
         O+PpPJUZHS24SkWOfEWfrETxL8BsfrE7jCtUiR/fhDOTXFXV+cEMUP3ju8pvA/A8PO14
         r+bU83eiycbgPQpqhZi/Pf50w04hfqGl7x1UNsevurqNJPJSmNIi7gl30jHACOFlIJtF
         gioo7BD1dyGwCyP/6MmcoXu85x4poEa24MUsGdK/R0FvYrKpzTovp1wHCMFQWqYOzb6e
         eaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790183282; x=1790788082;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+sWyggwBV1D9IUYjZa6aLkPXJtAz+OTvh2XpzdjOSmY=;
        b=aEayJVIEi7ZdvgUpE0V8Ci+px0GfNaIiUgN2H5ueJqu5JH9bRUgBT3Fxs8fiFQZvhD
         H4DB7PDqqERTAxrvIQpXaw3eDcqlqEj/wI/o6gFhtTX1/3DX0qEpjv7EcrHMtHntiGl0
         RodJKOWNYyr1UKHWWgJUHpDIfow/GkWgUKM/AjeMquH/k+OR39TM4BxSlTHNLAl3sw4d
         rKo90L3FY010zTIOHdt2auWMA2VJ51/tr/0AIBM4FQjqi9lkR+WB3mNfmsjCWEdv3Jdr
         +0mQJtqN6tEDd1EMPmMZtqdTOMaro+GAtHig816Yt4c1UCABPX6g8+JwK7ZAUgPFrAQr
         iIKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzRa1uYWy7AvB/A9w20GUMWtN97GSRbQJw9HtT++4JehQpFNKBRNIV1yVyA2GjM7n0psCuswU=@lists.linux.dev
X-Gm-Message-State: AFuF++ky7OuK5pWX0FI+opa/s7evYNmrU4whuSFsg0G90gc/C6hX3krn
	YYyHjT5u2C21QF5NlpccqR8d+5jDufP/5Dav0Fm8jyrVqHytVXPDu1lRhyc5OoJdRw==
X-Gm-Gg: AYBFou2jGTVfxa64W5Wgw6uaG8w3QYNIY6QstEK4ILf4isyBK0GcmB5GE58dPZ1PXwl
	ISwKfxlyQf54fd3kfxBh4ik2k9MYxkmjOuW++t9C7lGVfz4mwrJBVthLUhFhUY/VXzVJ9StkSam
	rJz9CkSObJvCvkxTS7okbqVlOjcr+qOsOuMxNsr34g0JDQ2t0uU3w4b+/9+zK41hXAD8zLjN+Jo
	HnTHE6hRY98YaDHHGBHh3OobtEIWvharAbwMX5Hf2LLvb/a9YWAxzdNG1Dm3HG7tLPS8Z0rLhBD
	oUFm/5rYBqUMCuFFizXk7QgvfeGw1Kqc+PMTzhNj1EECP/UQok09itrtFrgAgU/xoeRPMwXEgtA
	iDKpEc8EAMe5X55YYT7w3i/OKS9W3cnPcOfCywSUt4ohwXmuSx7dHltouwK+4NrzW+xFKzA0hJG
	fMReMpeldc0pLDLPz98qoKY6Z6zhCB4JYDDIodn5nqxukaye9qY2zK1C93k9TMVBOBvLm1WWGl5
	aKeF6e60ptn2esmSpVSdK4u/L/eEZOEttJr/Ai7
X-Received: by 2002:a05:600c:4e8a:b0:49f:e185:f3ae with SMTP id 5b1f17b1804b1-49fe55e13a1mr140635e9.2.1790183281720;
        Wed, 23 Sep 2026 10:08:01 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5bae53dsm575695e9.4.2026.09.23.10.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:08:00 -0700 (PDT)
Date: Wed, 23 Sep 2026 17:07:54 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <arQHamIHuaUqlJyy@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-12-smostafa@google.com>
 <arMbxX+sqTS3gByB@nvidia.com>
 <arO9hGmEx7c9mZAj@google.com>
 <20260923155507.GJ1540250@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923155507.GJ1540250@ziepe.ca>

On Wed, Sep 23, 2026 at 12:55:07PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 23, 2026 at 11:52:36AM +0000, Mostafa Saleh wrote:
> > I can add more info in the cover letter about the code split. Mainly:
> > - arm-smmu-v3-kvm.c: Is the kernel driver for KVM SMMUv3 (this runs in
> >   EL1 and can use all the kernel functions).
> >   The main job of this driver is for discovery, it doesn't do anything
> >   else in the runtime.
> 
> Maybe call this el1 stub or something like that?
> 
> guest_pkvm_stub.c
> pkvm/hyp.c
> 

It is not really a stub and I was following the convention of
arm-smmu-v3-(iommufd/test/sva) I think for the pkvm/ one it can be:
- pkvm/arm-smmu-v3-pkvm.c
- pkvm/arm-smmu-v3-nested.c
- pkvm/arm-smmu-v3-el2.c
- pkvm/arm-smmu-v3-hyp.c

All of those are fine and for the other one:
- arm-smmu-v3-{pkvm, nested, el2, hyp}-init.c
- arm-smmu-v3-pkvm-el1.c

Anything along this lines, otherwise it's too vague IMHO.

> ?
> 
> > > > +extern struct pkvm_iommu_ops kvm_nvhe_sym(smmu_ops);
> > > > +
> > > > +static size_t				kvm_arm_smmu_count;
> > > > +static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
> > > > +static size_t				kvm_arm_smmu_cur;
> > > 
> > > That spaces/tabs in those two lines look a bit odd..
> > > 
> > 
> > These are tabs to indent the variables, similar cases exist in the
> > SMMUv3 driver, check arm_smmu_cmdq and friends for example.
> 
> Personally I hate this style, it is a huge PITA for maintenance and
> makes diffs bigger than they need to do. I remove it whenever I have
> the chance :)

No strong opinion I can change it.

> 
> > TBH, this is a bit of a hack. The hypervisor can not allocate memory
> > at the runtime. All of the hypervisor memory comes from a carveout
> > allocated at boot (see kvm_hyp_reserve())
> > 
> > So we allocate the worst case for memory mapping with leaf granule. But
> > the hypervisor also need to allocate L2 pointers and the SID space can
> > be massive making the upper limit for this too large.
> > 
> > However, smmu_hyp_pgt_pages() defines the minimum pages required,
> > actual allocation comes from the command line, so it is possible to
> > tune the system without re-compiling the kernel.
> > 
> > Thinking about it now, we can just drop the 500 as this is the lower
> > bound, earlier versions of this series would allocate the carveout
> > based on this size, but it is not needed anymore.
> 
> I see, and you can't scan the ACPI to figure out all the SIDs used at
> this point to get an exact estimation?

I thought about it, but it is complicated to scan the DT/ACPI/platform
bus and I don't think a driver should be doing that; going through each
device with IOMMUs, duplicating existing logic...

And even with that, things as PCI won't be there as they are dynamic.

I think the best way is to remove the 500 as it is hacky, and rely
on the command line option.

> 
> Not being able to manage memory after boot is rather an extreme
> limitation.. But a huge amount of RMM's API complexity comes from its
> granular memory management so I can't really fault that..
> 

Yes, that was one of the main sources of complexity with the
para-virtual approach also.

Thanks,
Mostafa

> Jason
