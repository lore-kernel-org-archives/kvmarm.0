Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13CE1A00F0
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719251681; cv=none; b=RJe18zpOPt01TCZ/id00PvgF4iOpITg8pc/fzpBb43OrZxz60Vbtq3PfeovnnJa6mgpBgt0S/KGUyTNcmlyH70bApEHUjt9UJO8N8DXSjfKMTNGH/AsXZGSSGliBosglEW8Jhm4QBGLph1DyQcH2pGi8IqnkmPyvsAq6zyxBIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719251681; c=relaxed/simple;
	bh=B30pVTPga+iyMMk4UJSZ9j5jSzoQ2mPk3rtT9Pp+HgA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T8Y8FAB4tGtSSk157el623HusGcILevLCJ23LRI83QjdAjn0zTRy2e5JznD/V4Ic60Mx5rlqT0wU28VCeeuPtzZsPVfkqogXeUgOKzatSCR4CZRPt11RqTTM+ZF4T643IMbSDZvxJNBTbX7xpsZAKEsWWvVRZh3+DImtiJgJ36Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EvVx6dsg; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EvVx6dsg"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7065df788f7so2063195b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 10:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719251679; x=1719856479; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4EG5IaKeVOdRH+r7l7u/Do+csHa3snfvHiixcdXYGk=;
        b=EvVx6dsgV85WFldogRRMNQ2pNeSCevljWDKK/59npSnvL6l/ex/er+I/u/DKz+0tcS
         U1/KqZS5cnqoS9h+TWIJmbS4rtIW9JWMWaicmdIhtqDnlETkgQCmRTdgrdBvGE/N2BZR
         Z1p/oVetnQrmLJLzuWCLIXQJvu7Cr9y+ZkKTDs0qKTyvY5NB3K2GcsM2cFXllkRBL50q
         oAoOC1ECnrOgI+25jI3lyfUsUawYv3ImWW/ZnZNok+yr3lUFkOa7CC6K8xliSbt9e45N
         akSjtgF4Fu/+6xl4LTOQBYMtENNTfNs1HCvDwbU23lOhdW394u8KD+MPx+ESLHIaSoaM
         LArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719251679; x=1719856479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4EG5IaKeVOdRH+r7l7u/Do+csHa3snfvHiixcdXYGk=;
        b=j9dbnnYwcC6Ka9cbzWIiHUv3CIw9xqzS7noiL7PBaJqliqA1urhMLTJArSx6/fB7/L
         3A7wBW7C0nYKamkbi4uew27hRC+Ut1ica++YFFf/3W4/CFdnVW85UEYkG3TlW3tSffnj
         wSUDSUGZqvbLLQoaAzhw9oqW0M1j1BBaiNBPvXpRB6GcYG1q+H2v2ncE7NljYIAxNZxR
         EfM0XpSGeguiIt+IQfRIxuA8tLHZOKx7CRSJnD9KTgowwinD6GI+cVIlNWk2w1Q/OP1E
         jnJtGcet0AK0A2Oe0VmUt6thVnMqsBTLOL50b4C7iTFEkAwbjTJY7gyEdISbDRDIIJCa
         HVgg==
X-Forwarded-Encrypted: i=1; AJvYcCVeOnrtkMkiqXwosLR8E9tn3UHqPnmOyiOYFZk0rnKfU7/PKP/w2Jei99Wm+DmxFuQToD1tu7eTXI5IpzwwTDOnQddKtGwQ
X-Gm-Message-State: AOJu0YwAMoqiFHpPlQxJmbk/Wtpzch+xopd9vUS/L7ERunPTU2ohHNNk
	tvZNB6CPv9Y9TpQku0qopRlnEGkqW0YafF08t8ZFn0KlMJjSZLC8vSpO38t4j+KMRKubZoPz1vm
	c+A==
X-Google-Smtp-Source: AGHT+IFwvxf3OsuvZYrUndYb77JYUI7kIwbwA1lAt8ypjyKZ5DTVmQAcQPWwexhhQL7MAR18AQ3i9Y8LGS4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:418b:b0:706:2948:a087 with SMTP id
 d2e1a72fcca58-70669f71011mr302391b3a.1.1719251678783; Mon, 24 Jun 2024
 10:54:38 -0700 (PDT)
Date: Mon, 24 Jun 2024 10:54:37 -0700
In-Reply-To: <20240624170747.GA1515249@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca> <ZnmkbOfWBJHrO2sx@google.com> <20240624170747.GA1515249@ziepe.ca>
Message-ID: <Znmy3QPAUIX9SnGx@google.com>
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linuxarm@huawei.com, kevin.tian@intel.com, alex.williamson@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com, 
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 24, 2024, Jason Gunthorpe wrote:
> On Mon, Jun 24, 2024 at 09:53:00AM -0700, Sean Christopherson wrote:
> > If kvm_pinned_vmid_{get,put}() are implemented directly by KVM ARM, then I don't
> > have any immediate concerns, as KVM ARM is a long, long way from being able to
> > isolate KVM from the core kernel.  
> 
> I think that is a reasonable thing, I also don't really see VMID as
> being general. We will have to figure out how to ensure that the KVM
> FD we got is an ARM KVM FD..

Isn't the caller in ARM specific code?  I was assuming kvm_pinned_vmid_{get,put}()
would simply not exist for non-ARM builds.

> > That said, I find the on-demand pinning to be very odd.  IIUC, if KVM runs out
> > of pinnable VMIDs, attaching a device to the KVM+iommu will fail.  Failing an
> > iommufd operation because of a (potentially transient) KVM resource issue is
> > rather unpleasant.
> 
> It is kind of subtle, but the only thing that will consume VMIDs is
> IOMMUFD operations that are working with nested translation but not
> providing KVMs. This is a pretty small blast radius - ie a specific
> qemu will fail to start - that I think we can tolerate it.
> 
> More normal iommu operation will not require VMIDs so things like
> driver attaching/etc is fine.
> 
> > And assuming that pinnable VMIDs are a somewhat scarce resource, it wouldn't
> > suprise me if someone wanted to add cgroup integration, e.g. similar to the
> > misc cgroup that's used to manage SEV(-ES) ASIDs on KVM AMD (IIUC, an SEV ASID
> > is analagous to an ARM VMID).
> 
> Yeah, but if someone is using such a cgroup then I expect they will
> also have an up to date VMM that doesn't trigger this VMID allocation
> in the first place...

I suspect we're talking about two different things.  Either that, or I am really
lost.

> > Rather than on-demand pinning, would it make sense to have KVM provide an ioctl()
> > (or capability, or VM type) to let userspace pin a VM's VMID?  That would allow
> > for a much saner failure mode, and I suspect would be cleaner in general for iommufd.
> 
> The point of this mechanism is to support using this iommufd feature
> without a KVM at all. We could instead prevent this directly 100% of
> the time, but it means that HW with this BTM capability would not run
> the legacy VMMs at all, so I'm not that keen on it..
> 
> When a KVM is present then the iommu needs to adopt the VMID of KVM,
> and that should have a mechanism to ensure the VMID is valid so long
> as the IOMMU is using it (eg because the KVM FD is open)

Right, and that's what I'm referring to as "on-demand pinning".  For the IOMMU
to adopt a KVM VMID, the VMID needs to be pinned (or KVM would need to notify
the IOMMU every time the VMID changed), i.e. every KVM+IOMMU pair pins a VMID
that is managed by KVM.

Hmm, kvm_arm_pinned_vmid_get() doesn't fail, it just falls back to VMID=0.  Which
seems odd.
