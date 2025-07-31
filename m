Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CC027A12D
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753983904; cv=none; b=uMmWo5RpKId6sQvPjvLvIJudjnBSI/5jJ+/zqT+rFZIvpOIv2UXNR8GOSMmoTdGySTkUep7Uo7FufNT5tjO/D1XpqS2qotkvdKX5Gs1d/0bUJGXI2lBbHybzMvA3S8DydJD3A1yCoYinA6v/QjJzS5tFI1Xk0J9iiVlnLDbxKsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753983904; c=relaxed/simple;
	bh=McEipDWDZ0a4efpZE1Lw4KPrrD4u60yjBO1dH6BPMys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgQBcLSvTHYK3vy8tKXFU7XOsADHG+10xXVRnxwdK4PZoEvwixSokYALeMLxXZ0UjgzBziPGODzcRqlWb4P8d9VRI9TW5iTrVapDQ/48p6ix5/X1cd/5eFb0phJPJLVi2/0N5+AbOaKGQeQjMPwewMUxzlDHDG+ieNoZt3JZP+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fp+PO8hA; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fp+PO8hA"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so6635e9.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 10:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753983900; x=1754588700; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+kfkGzJlve/WLoyPW+HY4jJ87yR9ziLhY0paEWgfM94=;
        b=Fp+PO8hAJEEp25bFCxyoNNL25BbWJ2zBBMpZSragcjuHs5JB3M7VB+KSIFWaRI3g6D
         piT+U/rCBrDfv17AB6d0Q6buYKxgOn6ZMLPrHmiFuoPpV3OmMJpyMzHwCO9wb7/pr9La
         jzKx8wRPMKXvbeT2FglhiM7we61ZlJjuzMMsBFtR+6FwPDAgS8G51GvnnOWucEl8AMaI
         9ibaxEFvosj5ecUoe/JT3xPYNz2GabxZKZEGAvTfXRrciSJHjca8JwpYsl7/WuFJFoSL
         T1o2J+JYpaQymxXMrBO4rRmAq5JtzNp2Hn45Ip96oj/1Wz0uFNh1k2kBofC+OcfC0fCb
         VN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753983900; x=1754588700;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kfkGzJlve/WLoyPW+HY4jJ87yR9ziLhY0paEWgfM94=;
        b=tOajVQjSi4A3JBEkuR7kHlwafVpKvMvRPGDO6pZYOVpRetyGwehv3qWDM5DZx2IObp
         Brd/HnQ2i61qH8cTQ3snixVb41d2mbE2442um32CStj6xnU28anGVkO+ePcMH0VNpgTZ
         fYH4PxKD8OAh29Wj/YoX4MFfD3gczVRMyf2I/PmsZMQpthHIYATQo8oHrgSjbODKA2ZG
         aQDMmJpQ6zEFNOS4Ax/lNSHM8cAvmWM3LnoNe+EmKK1/JU3YbXwF7fFS6BYVLOmbDdqm
         H62hUPx40FReMwbA52qhinMOxfz2FjXi8nH5riVi5IRz7blD8J+JP9xqS/bKlu82W4/N
         cqJg==
X-Forwarded-Encrypted: i=1; AJvYcCWFdes/HzOGpug3k4bfojhWl7bpINGkmHp6aD5opju2JCJwzRAcjD+xghiJ58lyZh7+SY8eugA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2Ldz3d2eMzafPq4lyO/emI6Wl9T9GR6HJIo/gF2wthRK6Evib
	BqoUYJdCKkgI+WVSzstSQ+p2EZse78pW9NL2A87nGpE8FlRW6GApB528uqgaMngi+Q==
X-Gm-Gg: ASbGncsKh+FUeR2kQay/3B6T3is0Oen8QmVFcU3vLUPVxIc1sJv0EWIRGs8uW8K0tIR
	fR//fzyIjJTEYlCR6FzKnGCFLI8EGLdS6zjaViFg2xcGG30X0H7pwuP2UZD4zCjWF7QRjNYIw48
	4DUFvm3g7SfCRUSdsPvVGdzQJ5Um/D99JveP2Idv02Fhsxyc257q5J0/amFX9Elh2AnGowuzt/y
	Xpw7jRrsqbwFA4G1+xOWk0yBHeNsw0FrUlUgrBRpO19vyZNjAjK8FAN/iAuHZPaQafwPlkiHkg8
	I32Vhtg7pU2jnq9Ju0Dxde5Xc1w+PU6EnKTpCfbONZ0OA0grD4Wf9IYxy5LINEajNn7sKYwhUlv
	1cwN19WbRQRtL/SLH4dr/aYwGoUbMLhR325GLN7euko4Q5NQERf1+OZrMm3fbywoLYcl0wBtMAC
	ZA
X-Google-Smtp-Source: AGHT+IG0cqauf8/W+uT6V17ni4XHUoScwT7roD06o9nChNvdBz0aFFnqL9Kizfjs0f2g6AbozeOGQw==
X-Received: by 2002:a05:600d:1a:b0:455:fd3e:4e12 with SMTP id 5b1f17b1804b1-458a8fc9acfmr19755e9.4.1753983899719;
        Thu, 31 Jul 2025 10:44:59 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458981d0b06sm76559425e9.5.2025.07.31.10.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 10:44:59 -0700 (PDT)
Date: Thu, 31 Jul 2025 17:44:55 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <aIurlx5QzEtjpFLd@google.com>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-30-smostafa@google.com>
 <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
 <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250731165757.GZ26511@ziepe.ca>

On Thu, Jul 31, 2025 at 01:57:57PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 31, 2025 at 02:17:17PM +0000, Mostafa Saleh wrote:
> > On Wed, Jul 30, 2025 at 01:47:52PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Jul 30, 2025 at 03:07:14PM +0000, Mostafa Saleh wrote:
> > > > On Wed, Jul 30, 2025 at 11:42:53AM -0300, Jason Gunthorpe wrote:
> > > > > On Mon, Jul 28, 2025 at 05:53:16PM +0000, Mostafa Saleh wrote:
> > > > > > Register the SMMUv3 through IOMMU ops, that only support identity
> > > > > > domains. This allows the driver to know which device are currently used
> > > > > > to properly enable/disable then.
> > > > > > 
> > > > > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > > > > ---
> > > > > >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 92 ++++++++++++++++++-
> > > > > >  1 file changed, 91 insertions(+), 1 deletion(-)
> > > > > 
> > > > > Can you split the new iommu subysstem driver out please? I think I
> > > > > asked this before.
> > > > 
> > > > Sorry, maybe I misunderstood, do you mean split this patch into multiple
> > > > patches or split all KVM SMMUv3 driver out of this series?
> > > 
> > > Yes the latter, the iommu driver introduction is best as its own
> > > series
> > 
> > I thought about that but I was worried the maintainers wouldn't like
> > introducing the infrastructure first in the hypervisor without a user.
> > I am open to split this, but let’s see what they think.
> 
> You can merge both series at the same time

Ok, I can split the last 12 patches which are the SMMUv3 driver, if the
maintainers are ok with that.

> 
> > Makes sense, from the kernel point of view it will be attached to
> > identity/blocking domains, but the hypervisor api is just enable/disable HVC
> > as it doesn’t know what is a domain. If terminology is really a problem,
> > I can make it one hypercall as “set_state” with on/off or identity/blocking
> 
> I would call it set_state with states IDENTITY/BLOCKING. That is
> clear. enable/disable is ambiguous.

Ok, will do that.

> 
> > TBH, I am not sure what hardware does that. So, another option is to fail
> > gracefully if RMR exists (which falls back to the current driver) and then
> > pKVM would run with DMA isolation, which is the status quo.
> 
> iGPUs either access the DRAM through the iommu or they use some OS
> invisible side band channel.
> 
> The ones that use the iommu have this quirk.

I see, I think that can be added later, and these devices can keep using the
current SMMU_V3 driver as it, I can add a check to elide this
registeration this driver if the platform have this quirk so the other
driver can probe the SMMUs after.

> 
> > They are not random, as part of this series the SMMUv3 driver is split
> > where some of the code goes to “arm-smmu-v3-common.c” which is used by
> > both drivers, this reduces a lot of duplication.
> 
> I find it very confusing.
> 
> It made sense to factor some of the code out so that pKVM can have
> it's own smmv3 HW driver, sure.
> 
> But I don't understand why a paravirtualized iommu driver for pKVM has
> any relation to smmuv3. Shouldn't it just be calling some hypercalls
> to set IDENTITY/BLOCKING?

Well it’s not really “paravirtualized” as virtio-iommu, this is an SMMUv3
driver (it uses the same binding a the smmu-v3)
It re-use the same probe code, fw/hw parsing and so on (inside the kernel),
also re-use the same structs to make that possible. The only difference is
that the page tables and STEs are managed by the hypervisor.
In part-2[1] I add event q parsing, which reuses 90% of the irq/evtq,
insert/remove_master logic, otherwise we have to duplicate all of that logic.

So, I think it makes sense to re-use as much logic as possible, as both drivers
are smmu-v3 drivers with one caveat about HW table management

As mentioned in the cover letter, we can also still build nesting on top of
this driver, and I plan to post an RFC for that, once this one is sorted.

[1] https://android-kvm.googlesource.com/linux/+log/refs/heads/for-upstream/pkvm-smmu-v3-part-2


> 
> > I am not sure if we need get_resv_regions, maybe it's useful for sysfs
> > "/sys/kernel/iommu_groups/reserved_regions"? I will double check.
> 
> It is important to get this info from the FW..
>
Yes, I think that should remain.

Thanks,
Mostafa
> Jason
