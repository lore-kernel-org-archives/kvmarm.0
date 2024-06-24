Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C1D182B2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719252111; cv=none; b=tEIlQnqLBb6JsQeBlbikEOTq9R6PWbVeHBPdYHhCIv/xA8268NGrxhiHZcM3zkECO5eu8yJQ4+kv7bhjfs17D56JUXiMN7aDH9E/kJiydPkoytbqQZ99iQSPEgvra7bjXjfoxLukoMxoL0V0DLOf5Y1tcb9/vc1wURf81DJqusI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719252111; c=relaxed/simple;
	bh=0QfYm5G2PMJ151JSZ4jd9cAwVFEHD63u1C6BNE/WPXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cugXx2iW2bW5pLZaYLkwNRB2l/2QiIn1bdFBXt0fDBQsiPTtPIaesp3hNFBbjrMwuQ6hSHp7BfM261sos05WJaR7D/Etxwgs35cVQiDobKDQ0hyFFfvaOPQsudFIwDRq8yhi1JO0ycZF6HYaViV8tPulQFGuY8L4LLh7Sb1E4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=n6EOMev5; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="n6EOMev5"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-795a4fde8bfso284270685a.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1719252109; x=1719856909; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GmIpeWOMkuaph7Wse1udylidw2f4E1g5R0L3+pEMmh8=;
        b=n6EOMev50vgJ0ARY8GHFvKRL5abQZze6Qpkbnv1kyNJfWJfCuIKEqm1x0/a8an1FgV
         8BehEzGi0eMBeswnydErO7kjGTY90KS3r0FyDiRgRSCkofSM5g7XKLuGurnvK2zTXtdA
         9UE50gF5FaK9DEgEn9Wx/eYOJaQ8apP8a7r1glxl7kZAjuqchx2NLHqnuCY6o5S9ZFTT
         XLjYG6NWfoHOMtpXlWfPKnOFnmEjpDnBniEUddHXUiPAPtHshtVTkvVjsn1gKyS1ysRb
         MrxvO7XLFnLjdOmwXkShjjOCQFNckQeRBSkzDxeXSZeo3Vr+G2ifB/Mit+fX2CMYfep+
         D8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719252109; x=1719856909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmIpeWOMkuaph7Wse1udylidw2f4E1g5R0L3+pEMmh8=;
        b=XFqeWoURUZBqXAjQc5ioDelWgdHXj1oDQRCp6H6wgpkUUxu27zJpZgkYcVP9zOa3CU
         yfzf5gbQgPadQ8DcW38ik3VwUWth7IyYFn11DkxU674On02P5+GI4HqZo/BWIWafwhkC
         PXnmCxvHNRRSeva4oOoNumM0cBpmY6lkhOSTvUrdpNt1Vtyt2WLmzyBy1VcXF+PIl6yW
         bdmGoan2ddQ7GnYgmub0vGPGx88CIyyf1K56IfGdEc5w3bODbpeHiHaSEdbjgbvsbHgT
         Bg5cLBx3vORfQKR9A0qhzFsW5u6w44IQSGdnIV8OKKDOEz461fT/LZ27EbDYhTIdBAMW
         Qcow==
X-Forwarded-Encrypted: i=1; AJvYcCVHDOS7sOpX0k8Z1+gljDP0fu/EXdqH2b06qs3Rsb2BMowANKoudN6HXhXjlIfczuqbD4bThXZnz4+qkpfoVchLBGWNBvC4
X-Gm-Message-State: AOJu0YySPvZfk5mskoX1618dfEFV4tqWzXmRMb8JWNaCiqGOoAnV3z1l
	xRHLCM180e32LJKjKtwNe3mn+nOL58VPQPQgCp96CcVPnHQK1m2biA6cUF9c6q0=
X-Google-Smtp-Source: AGHT+IFj+SWlMU3kAFGeffbqDksRzMPhWzPlC1lsJ2MKYmQSrom/5Zzv8Cda2KE+V/MbrIeLa8IiIQ==
X-Received: by 2002:a05:620a:470b:b0:795:58f1:7808 with SMTP id af79cd13be357-79be6e507d3mr640899185a.22.1719252109417;
        Mon, 24 Jun 2024 11:01:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79bcf465449sm328401485a.98.2024.06.24.11.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 11:01:48 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sLo0i-006Y8Q-D1;
	Mon, 24 Jun 2024 15:01:48 -0300
Date: Mon, 24 Jun 2024 15:01:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Message-ID: <20240624180148.GV791043@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca>
 <ZnmkbOfWBJHrO2sx@google.com>
 <20240624170747.GA1515249@ziepe.ca>
 <Znmy3QPAUIX9SnGx@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Znmy3QPAUIX9SnGx@google.com>

On Mon, Jun 24, 2024 at 10:54:37AM -0700, Sean Christopherson wrote:
> > > And assuming that pinnable VMIDs are a somewhat scarce resource, it wouldn't
> > > suprise me if someone wanted to add cgroup integration, e.g. similar to the
> > > misc cgroup that's used to manage SEV(-ES) ASIDs on KVM AMD (IIUC, an SEV ASID
> > > is analagous to an ARM VMID).
> > 
> > Yeah, but if someone is using such a cgroup then I expect they will
> > also have an up to date VMM that doesn't trigger this VMID allocation
> > in the first place...
> 
> I suspect we're talking about two different things.  Either that, or I am really
> lost.

I mean KVM will have already allocated and charged the cgroup for it's
use of the VMID. The IOMMU side just has to match it, no second
allocation of a VMID.

We wouldn't charge a cgroup for iommu and kvm sharing the same vmid.

> > When a KVM is present then the iommu needs to adopt the VMID of KVM,
> > and that should have a mechanism to ensure the VMID is valid so long
> > as the IOMMU is using it (eg because the KVM FD is open)
> 
> Right, and that's what I'm referring to as "on-demand pinning".  For the IOMMU
> to adopt a KVM VMID, the VMID needs to be pinned (or KVM would need to notify
> the IOMMU every time the VMID changed), i.e. every KVM+IOMMU pair pins a VMID
> that is managed by KVM.

Ok, right, yes, the expectation is that KVM allocates a VMID at some
point and it stays fixed for the life of that kvm.

If KVM can change VMID on the fly then that is a further complication
:\

> Hmm, kvm_arm_pinned_vmid_get() doesn't fail, it just falls back to VMID=0.  Which
> seems odd.

I had the impression the KVM always had a fixed VMID, but I don't
really know.

Jason
