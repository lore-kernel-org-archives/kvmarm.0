Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1422F233140
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 16:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753894077; cv=none; b=tFjMqJXXcabQp+YWtnk/AeWFVJLq/P//iTYqIXhRIm8dAmJPJOWBYfHrFChNu7pSqi9dBz/EEg6J4RsodYG4EgY686lSJ88pT5yaCHX3MnAUYxeSzh0RdCB0d3tl0Q7jYGQMPdpn8nQtAxauXk7ManhwCgUibVqe2aQA9oOKJGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753894077; c=relaxed/simple;
	bh=TQU2LXyowL1u/WcnoBMklVY1phcyp3eD1046ayEa83k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3+h8/HNucYXwTTRK4qwI+GC1X3Vr4Yt3cjVsoNQZporZsxd8Yee8pbryLOMlixTnr744uVtqzJQueHdIZRwh++JU0TcEwCMLsvMvQI4n8hXTooPnKs6VLc+8tfrTQWh+qbFx3KSpwGPAasGi4dcwTyODsrMFpN3D2zcO4cHmDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TsJFUiFq; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TsJFUiFq"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70748a0e13dso28171426d6.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 09:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753894074; x=1754498874; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QFuG/A3j2Vv1mbEqh/G2TAhE+lxRzm1/wn84++4OCP8=;
        b=TsJFUiFqRJN/Mcg+ZMfkS3T22O89pR5DVmtuBzHG4cO7kqemxfAJ1L+N+PCgTM9+XJ
         /o2hlcJCrPYKF+Juc7//KVMIGy5LhvoR8ysTjokD8tv3O3bNg1j2qfQbduzafN7fG8wp
         XWZCzWy1oXFfUUx73F4s29doKPYbRuCOKY7UKGnp1xpf8Ik7xrHeAg4pojY53QDR/qFs
         +XDcEbDr2VTJ4hKaIBDtp+cYN0tlLqrxFlEHsC7638o00JTHdR/PeUzRWgT+6L+pQq4W
         QNWY1Wgmt0skh4h9HPXEetNGAV1BNcXDsqUNbjFOzsGZSi9pvHBqOHFcFwjjj9sBSisZ
         3+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753894074; x=1754498874;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFuG/A3j2Vv1mbEqh/G2TAhE+lxRzm1/wn84++4OCP8=;
        b=uyzI+qomtX7a1f6IR2IsAPzs4grpG4f48No4U95mtSvQV0qUWJ5K77A16xSAFusoL9
         FzOEwypccI8yrkg0JAKzs74zbhiLa+WmVPBD5W0msck/jbC+VICMxO0jMolQcuNgI4jf
         d7OFcUprKX9lrTR5aSPyfookzyReZbiDKGkwB82evBFCS01x4+yey8ojuMolw8IADQxx
         DFxJ1TgAKr+29weUhTCKFZhnnrmVbncs0hBDZ+IH8m6b+4EP302zt7LT+hrg2t0wG6Lj
         pCfl2oepN0ZCh6egriNqTrlv2gaIJyL2Pr1tMppEuPSIKS8H/HY7aJw1dvHeLh4Krxvi
         ieOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVebVDdxcsRiOaI/RLJ9gesblGgchxRIt6Qb0JewCjdrU9js8P2zIhyswn5BRKReu2TX8gZr4E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwA4/ANa9yEVnDzZ9FUSNtXOfrR1JIdy3kIWjEgPgggqDp3yBFE
	S7SZMRjJuMIenRoxNFIriXvUg42exZwW4l9qN6PLPchCpxPqxaYZ0YBQEMk1YkMi/Zw=
X-Gm-Gg: ASbGnctrDVShy7cvhxBux30IvRIen1/6YgVWh0IuHB2k6RPjKs0GLyyEiiqFsgn57W0
	NtGdiGOA4FAtgUMJqnvkrBcCHk1N3Eg0/bQ/HD0RgTfjx66WJSH9WLu6mknzqH5JnLRbW4ugGX2
	GOdhK8IOOdQwuxK+m6+lrQbydskChzXfWOrH+Bp73G5QEuTx6C1642gn6fuEY+6T/3GZK3h4sZC
	r24pGEO9oVRf670BrobkJClkUHrT0gXZnncjXLJLB1n7WaBCL2oGmku7L4nzzNI9obISWhyzXf1
	KCPD41e6PXjO/4+aG7ZF4GWTcnNE/QClz4Njyp5RO0oQCg01/KgkIFovjwJ0k+OUNNuiJmgrKA+
	ccL4uZjyDvWb9VdlpwmtuSy3mGPFac5whlW9VsPzdit0bQQPxUYpOXq/BksaZOJRTlLOgQKNEqg
	a8AbA=
X-Google-Smtp-Source: AGHT+IEYjgoPB2+hXPaGV5LTcJrEx5auyd7kyK9NRID9fF4xcgzzjcLh06XEPwQDU8NDYLbYj9Li/A==
X-Received: by 2002:a05:6214:624:b0:707:3829:d491 with SMTP id 6a1803df08f44-707669437aamr60902136d6.0.1753894073853;
        Wed, 30 Jul 2025 09:47:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70729c15a84sm61759986d6.48.2025.07.30.09.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 09:47:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uh9y4-00000000SQn-3S3W;
	Wed, 30 Jul 2025 13:47:52 -0300
Date: Wed, 30 Jul 2025 13:47:52 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <20250730164752.GO26511@ziepe.ca>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-30-smostafa@google.com>
 <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIo1ImP7R7VhRpVE@google.com>

On Wed, Jul 30, 2025 at 03:07:14PM +0000, Mostafa Saleh wrote:
> On Wed, Jul 30, 2025 at 11:42:53AM -0300, Jason Gunthorpe wrote:
> > On Mon, Jul 28, 2025 at 05:53:16PM +0000, Mostafa Saleh wrote:
> > > Register the SMMUv3 through IOMMU ops, that only support identity
> > > domains. This allows the driver to know which device are currently used
> > > to properly enable/disable then.
> > > 
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 92 ++++++++++++++++++-
> > >  1 file changed, 91 insertions(+), 1 deletion(-)
> > 
> > Can you split the new iommu subysstem driver out please? I think I
> > asked this before.
> 
> Sorry, maybe I misunderstood, do you mean split this patch into multiple
> patches or split all KVM SMMUv3 driver out of this series?

Yes the latter, the iommu driver introduction is best as its own
series

> >  - Domain attachment looks questionable. Please do not have
> >    attach/detach language at all in the hypervisor facing API.
> 
> I am not sure I understand this one, the hypervisor API has no
> attach/detach APIs?
> We only notify the hypervisor via “enable/disable” hypercalls when
> devices are attached or released (as only IDENTITY DOMAIN is supported)
> so it can enable or disable translation.

Same difference, different words.. We've had trouble with this kind of
ambiguous language.

attach identity
attach blocking

Keep it clean and simple

> >  - Get the ordering and APIs right so replace works. You need this to support RMRs
> 
> I see, we can’t support bypass for security reasons, but we can enable
> the identity map for such devices.

You will have a small issue if the bootup has the pkvm side put the
device into a blocking translation then later switches to an
"identity".

As far as I understand it display scan out buffers have to be
continuously hitlessly mapped. So you want all the transitions from
bootup bypass, pkvm isolation, "identity", etc to continuously
hitlessly map the RMRs containing the buffers.

I think :)

> >  - Use a blocking domain not some unclear detatch idea
> 
> There is not a single detach in this driver, we only support attach and release
> operation, which just goes to the hypervisor as enable/disable
> identity.

'disable' then.

> >  - Use a blocking domain for release
> 
> I see, I can add “blocked_domain” similar to “arm_smmu_blocked_domain”
> which just disables the device translation, I will look into, I am just
> concerned it's more code as this driver only supports a single domain
> type.

Yes, this is the right thing. There should not be operations in the
driver that change the underyling translation that are anything other
than attaching domains. It becomes too hard to maintain.

 
> >  - Use the smmu-v3 approach for the fwspec, don't store things in the drvdata.
> 
> This is using “dev_iommu_fwspec_get” similar to the SMMUv3 driver,
> am I missing something?

Oh I got it confused, you are just calling 

+       .device_group           = arm_smmu_device_group,
+       .of_xlate               = arm_smmu_of_xlate,
+       .get_resv_regions       = arm_smmu_get_resv_regions,

Which is also weird, why does an entirely new driver call 4 random functions
in arm smmu?

Maybe don't, they are all trivial functions, or you don't need
them. For example you don't need MSI_IOVA_BASE if the driver doesn't
support paging.

Jason
