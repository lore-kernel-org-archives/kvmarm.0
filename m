Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955611EA87
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719248871; cv=none; b=RYsatxU/iRdPmT4Ra8jGtnv97G2/5wz2GihiBMAmC+rN3W96yMDSCORU9fI1J7K0RacdWIuaF/0Fhqih5j41UR5ZL9+66nFqeKnq66p35wqfUHR/4/aqR1rVZbc1qKmoh8mO2bILpirg5jRJ9RSiEjA3kTaooPx0bTGF0HDDQBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719248871; c=relaxed/simple;
	bh=VBXelmwPq3wiF7qBgmMcTKUFkHrEePFIDi7+d6fY3pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKjB5UUAgXMDa2rNVp5iOBeEqahQo9BY5XdkEa/HhZc/HK7r6CKr4GuL4he3fvBvnh9i0AF06xBYkQYgdOPsxfsxx32rmudrA84R9HLoCuuXdZhDJAX7m+/AjzQeWOuj4oXridBiMFYZ7DZRCwCv+FTX41GZLYzFLsGP4gD2nGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=LgsHr8pU; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="LgsHr8pU"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6b4fc5c2f08so20210876d6.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 10:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1719248868; x=1719853668; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J81bFInz01FlzzPQYJp5kazzCytEH5/Aa6xJ3+wKyd8=;
        b=LgsHr8pU3zIvkahe3aAU079Amq3rUZL2G0JCQ0uhFBMzuApJiIZk87p1vgzvxiPqHb
         WxsveGQ+cwj71yFIwSBfzIk3iKg9+h41LSvLioL0frLnIMp/tD5xDy5bYHcOu4mSxHkS
         sZ3oMi5yx7iWW1sW7TWMnO+Lvel6qbBG/S1LGnkWo78fRVHoiJfdI7LZpiR5JNG1Xe6s
         SrUX4MBHuM+l1E2bkL1G3NBcQ+GiJCBteyJWiRS8oFdEuvdIZdrVEZyOzECB+7DqIWQD
         oop0suCeL0eTQt+/inkb32UOs/u8+Bc77iIRYDeN/2to6eI9cPefZz/0sZuuOvjr+vt6
         4c3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719248868; x=1719853668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J81bFInz01FlzzPQYJp5kazzCytEH5/Aa6xJ3+wKyd8=;
        b=eNvemn2xVGQXlpgzft//536WnRVEVsxauAf9EGsHzVnPijqBdg4eRlAgdusQfOke2I
         6TnqwdTNnFUK2eQwdRtHzLkP1NM8du0bOG2uIzqSy7iArfhnA3TlyGXS4pRJV+94Jv5X
         sI4YqaLUZR3sSCHh+HGrfMNBKV8BlR3YxoBxumutUVbsFuGSZTLLoBUnrZ94WWLveWsk
         cfMvApSSaDe3T1+LJ4m57YhoDt7iNHbh8UdwIeuGX+lk22PmONRQYFC3rAlovGuF73Tr
         ftcjbMLgFDNTXjWQul88LPFJlxTnyut3mbDHwz3bQljfeAsffspjZ+WQSVJrYaD6KtVQ
         c7YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW+oLsE25uUIZ090Cz/Atwy+wWAdiBV29PK5tsknSiIj/rIoOwi2OV5ok83A22f6Dl5JugxjkRHeBAJx64Wi06ExvVh7+V
X-Gm-Message-State: AOJu0YxlT3QCD3mRxMK08xQ54rAzkdRvjEWKffOldDwDiieUlFhk6j7m
	7dJPu1j+OkJkoY45dcz/L9ml3petp0nP93uH+qZmX9ac2w8uaeAnbxOsjDqg6e0=
X-Google-Smtp-Source: AGHT+IGj656WBafkzOO9TKsI0+a1XWDecmfY7v2QgrUfabIgZc4iU1vVl0Nmh/XQQztbNobrJQYoDQ==
X-Received: by 2002:ad4:4091:0:b0:6b0:7427:875d with SMTP id 6a1803df08f44-6b53bbb7278mr54410546d6.28.1719248868430;
        Mon, 24 Jun 2024 10:07:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b51ed6bc86sm36240656d6.59.2024.06.24.10.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 10:07:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sLnAR-006N93-DC;
	Mon, 24 Jun 2024 14:07:47 -0300
Date: Mon, 24 Jun 2024 14:07:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Message-ID: <20240624170747.GA1515249@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca>
 <ZnmkbOfWBJHrO2sx@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnmkbOfWBJHrO2sx@google.com>

On Mon, Jun 24, 2024 at 09:53:00AM -0700, Sean Christopherson wrote:
> > Associating the KVM with the entire iommufd is a big hammer, is this
> > what we want to do?
> > 
> > I know it has to be linked to domain allocation and the coming
> > "viommu" object, and it is already linked to VFIO.
> > 
> > It means we support one KVM per iommufd (which doesn't seem
> > unreasonable, but also the first time we've had such a limitation)
> 
> And if KVM+iommufd come as pairs, wouldn't iommufd_ctx_set_kvm() need to reject
> attempts to bind devices associated with different KVMs, as opposed to silently
> ignoring that case?  E.g. something like the below?  Or is there magic elsewhere
> in the stack that prevents such a scenario?

Yes, it would need things like that

But I think based on other discussions we are likely to tie to the KVM
to the coming IOMMUFD VIOMMU object, and the KVM will probably be
provided at object creation time to avoid this issue.

> > Sean would you be OK with this approach considering your other series
> > to try to make more of this private?
> 
> Sorry, I completely missed this.
> 
> If kvm_pinned_vmid_{get,put}() are implemented directly by KVM ARM, then I don't
> have any immediate concerns, as KVM ARM is a long, long way from being able to
> isolate KVM from the core kernel.  

I think that is a reasonable thing, I also don't really see VMID as
being general. We will have to figure out how to ensure that the KVM
FD we got is an ARM KVM FD..

> That said, I find the on-demand pinning to be very odd.  IIUC, if KVM runs out
> of pinnable VMIDs, attaching a device to the KVM+iommu will fail.  Failing an
> iommufd operation because of a (potentially transient) KVM resource issue is
> rather unpleasant.

It is kind of subtle, but the only thing that will consume VMIDs is
IOMMUFD operations that are working with nested translation but not
providing KVMs. This is a pretty small blast radius - ie a specific
qemu will fail to start - that I think we can tolerate it.

More normal iommu operation will not require VMIDs so things like
driver attaching/etc is fine.

> And assuming that pinnable VMIDs are a somewhat scarce resource, it wouldn't
> suprise me if someone wanted to add cgroup integration, e.g. similar to the
> misc cgroup that's used to manage SEV(-ES) ASIDs on KVM AMD (IIUC, an SEV ASID
> is analagous to an ARM VMID).

Yeah, but if someone is using such a cgroup then I expect they will
also have an up to date VMM that doesn't trigger this VMID allocation
in the first place...
 
> Rather than on-demand pinning, would it make sense to have KVM provide an ioctl()
> (or capability, or VM type) to let userspace pin a VM's VMID?  That would allow
> for a much saner failure mode, and I suspect would be cleaner in general for iommufd.

The point of this mechanism is to support using this iommufd feature
without a KVM at all. We could instead prevent this directly 100% of
the time, but it means that HW with this BTM capability would not run
the legacy VMMs at all, so I'm not that keen on it..

When a KVM is present then the iommu needs to adopt the VMID of KVM,
and that should have a mechanism to ensure the VMID is valid so long
as the IOMMU is using it (eg because the KVM FD is open)

Jason
