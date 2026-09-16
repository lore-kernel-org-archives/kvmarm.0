Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC744AA3EA
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 12:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789562399; cv=none; b=sdjXhXYds4Gwi6U6DJQX4y2rRLnM3nTYpRNQHPm6Pn/+BtyNPEpSMTO7fMsK60cMh37QNIoNGqJvu8f/yzbIDJcq0h9jDqfuPdZxYWYnaxE7LuPbvigfmYB2iTDTX5YZZ2qM4jeGO7nJbuHW1H8uJFZqhA9ihbqYY0QWEEid6Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789562399; c=relaxed/simple;
	bh=gGoqbGDprEWmwT1B9MSHH6QmD1IQdF3fmGx24ee3Hik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGvQI+4zHkJfUJO+OIx1D0L75c5Snf10OA94mXKwZF/1sTn28tb/Bi/C1eQas8kgLD12IiG3+Dn4CqsMOotRq3/OUHRxB7XtESGrugETy4gpsvqUPoRmsKDVVJvQf3dYqKZMcrZQmm4L7M1CL+yFEWEoBbMtiRzM88OHrv3CL/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ew0rFzY2; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ew0rFzY2"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910ca5aa8so82483285a.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 05:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1789562396; x=1790167196; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TUDIe9gR+rSLhhhfLCdbqdanDu9FYyFLld3nExrjk8M=;
        b=Ew0rFzY2yPpAyieFUY5/UITv7hamDUOXY4wn69E/spfZLpbXAA1K5jdZkAS7yVnGcA
         fhMruDWBgYb0bK78QKZ1w0qDBiH+Of76vLL0HqxLQEofrV9zZtPD9UquxQMbQVrIonfu
         1zhADcNyju+WYvtZKKw+fyXiILcfDGgIas+trqg2RuwfUAIqjFvidMD0shUPlpI3M6zL
         GlxtQuIMLWjlmhau+fsVAXacZNB2qhhum1yfPwil64VuvqhidwE3J3d5+8Bi4a9lrD7n
         5B1IHmiPxxLVMQRWwPNq80xJzyPzGDSo9qNlnj/dMCxpB+vydimCAz5MMWg99ZBzN7a/
         RksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789562396; x=1790167196;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TUDIe9gR+rSLhhhfLCdbqdanDu9FYyFLld3nExrjk8M=;
        b=ZQBjXMT0hKt8l9Srg8GKA/Hx4CCgKXpiKckl+bFEgJgx4oDNiIyinQPyVfgMSLciWa
         xgBoGcelgLHlBQSJP6nNWGwAxu42KTq+1OlXf6/VNmhfpkJteNsTeVOUSyIkN2s+0SH6
         Y3RNtaBkEWVcnTuw3BMx/nAbMF7N7ynxSKO1qVnRr+5SromP1hbQXOY23W0ZEOXYozzn
         2V3RFWpSy3cKXsin5Ej3qWepqWNr9FtsFuYEaZZRY3Sf6zDkm+vD4WCYOkSbnIyEyY5S
         eyyZG6MECT3gigY/qwItjYMNVl0yj6FyIRQLBIbAlrslo9v/Gt4fd1kErioBwm3xkEFE
         f0VA==
X-Forwarded-Encrypted: i=1; AKwUvBzoIY5y0OCvDZXIZ5SHD+mTjEPru67rGh5hJv0nqeBkSfHQoA9HEU7gWf63Xg/H/O1JmimkEIk=@lists.linux.dev
X-Gm-Message-State: AFuF++lXpXDtyAAK74/FoQ7i0OHjqAyrVW0DtC376NV+7QvwcCrQ2FUu
	xnFyMsnb4wuL4NwzCUdoI8xeipXL6XjfS6fRaJGSlQrd3dt9u8SDxXM57HlS7NnnhNU=
X-Gm-Gg: AYBFou3Zxw1KV/3v1N4Yy/t/40zJm5TbVpH0MukMGV9mzFF1dgn1LaBaio4ubD0ULaf
	sVrZ18CFBV5u7c/VrhR3IazU+PKz8+WHpeaAVfyYLJ2CZ5JWiu/pqTADAKHMlD15fNeIG7XH1Y2
	jKzvypVP6H42xUHnuTjElV3ZINJ6cwte6fhnIFdeiHVXedXEqABOA93gmqEumdaoRUzDr9+aDxl
	nbEffymKRFnLm/QlYYpiVb721fKzVMivWJmp7P86+cfs4Aer4gYF5/sX1y7KXQsKd1dVBwv9DVy
	aCoiMWUututkIs33x8uzuoZYsxMeEirS6RbDbd2FIh+vdfL6KEf0bv4YCfDWK4NvT2e83tEvvAt
	hyldHsC3UPCaS2cp4ktrPfOvC3sapV/XexWawnPLqOHS1ajGNFhZpCh4qXD/vErMU0xj2zzWzRM
	4kFZZrAYlEq+1Z+/rFg+aZ0izrl1kZ4T0NJ+7Vf5EDs2NmYroZdu4mlwYux3GWvTjH8P+BKV75H
	hOW8PQHYBnCJABvk6z4lCE83fSywsUzAiQ0WDiO+yho5vBA/CNkYpXL2xy7vDQ2ZmA=
X-Received: by 2002:a05:620a:4542:b0:93a:1540:a75d with SMTP id af79cd13be357-93bb78f1ddfmr339230785a.37.1789562395834;
        Wed, 16 Sep 2026 05:39:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b780cfdd7sm206826385a.6.2026.09.16.05.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 05:39:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x6ova-000000098HD-0Q4W;
	Wed, 16 Sep 2026 09:39:54 -0300
Date: Wed, 16 Sep 2026 09:39:54 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260916123954.GC3196566@ziepe.ca>
References: <20260903171704.GK2890729@ziepe.ca>
 <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca>
 <yq5atsnyag84.fsf@kernel.org>
 <20260909124628.GH2543240@ziepe.ca>
 <CO1PR11MB4835512E374074A5F4AD0A6C8CBF2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260910124632.GB4083318@ziepe.ca>
 <CO1PR11MB4835FF972283C09D7D683DAE8CBA2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260915134318.GB3196566@ziepe.ca>
 <CO1PR11MB4835562E7714F368E669D3B48CB92@CO1PR11MB4835.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4835562E7714F368E669D3B48CB92@CO1PR11MB4835.namprd11.prod.outlook.com>

On Wed, Sep 16, 2026 at 05:54:57AM +0000, Tian, Kevin wrote:
> > At least for ARM there is effectively no entanglement with the actual
> > host iommu driver. The viommu is entirely provided by software in the
> > RMM world, so it can have its own dedicated driver. In ARM T=1
> > transactions are alwayus routed to the RMM's iommu and there is no
> > relation to the host.
> > 
> > I am interested how Intel works here, but I thought it was similar.
> 
> Largely yes. Main difference at Intel side is that TDX still relies on the
> host to initiate iotlb invalidation (upon notification from KVM on S-EPT
> change). Currently we put this logic in intel-iommu driver but it's more
> about wrapping invalidation info and passing it to the firmware. Moving
> it into the tsm driver should be straightforward.
> 
> Maybe there'll be other subtle connections to host iommu driver but
> it doesn't sound a hard problem to solve.

Okay, so I saw the driver posting for basic iommu support, can we try
to rework that to be split out like Aneesh is doing so everything
about TDX calls lives in tsm and intel iommu only provides a small API
surface to exchange whatever details are needed to bootstrap TDX
module?

> > AMD is different and I suspect AMD will have to continue to use the
> > viommu from the AMD iommu driver, but I am not sure.
> 
> ARM/Intel may support guest viommu in the future. 

ARM supports guest viommu today, it is in the public spec. Secure
guest vSMMU is entirely handled inside the RMM and has no connection
to the host iommu driver. It is a <100 line ++ on top of Aneesh's
work, Nicolin posted a draft at one point in those threads.

I anticipate a future intel guest T=1 viommu should be the same.

Thus I expect Intel/ARM to have two viommus, one that handles the T=1
stream owned by the TSM driver and implemented entirely by calling
TDX/RMM.

One that handles the T=0 stream owned by the iommu driver - and it
already exists.

> So AMD's case is a good reference. 

I think, AMD is completely different. I keep forgetting thier thing,
but IIRC they have a secure DTE but instead of having the secure word
control the translation it controls the RMP and you end up using the
host's translation for T=1 traffic. This is fundamentally different
from how Intel and ARM are doing it where the actually IOVA translate
is under the control of the secure world.

Both Intel and ARM put the S-EPT into the iommu HW directly.

So, I expect Intel to have an API similar to ARM. When you create the
TSM viommu you tell it if the TDX module should create a secure guest
visible VT-d emulation. TDX module has to perform the entire emulation
because it must be trusted. Existing viommu ops should cover the
remaining to register pdevices as vdevices, provide the vBDF and so
on.

> > How/when the tsm driver links this to a arch specific "bind/unbind"
> > operation is more up to that driver, but I would expect what is
> > thought of as "bind" should be the affiliation of the device's T=1
> > stream with the viommu and the target VM. It should not be sensitive
> > to the TDISP state.
> 
> Not sure about this part.
> 
> Each arch has its own definition about the binding flow (about 'how'),
> but sharing a common step by sending TDISP message to transit the
> TDI into the CONFIG_LOCKED state upon guest request (i.e. 'when').

Sure, the LOCKED command can be relayed from the guest, but that
shouldn't be called BIND. locked/unlock/run/err is taking a iommufd
vdev that is already affiliated with the VM to a specific TDISP state

> According to the TDISP spec, memory reads/writes with T bit set is
> accepted only when the TDI is in RUN state (except MSI/MSI-X writes
> are allowed with T bit set in LOCKED but I don't think any arch supports
> it yet).

Sure

> So your definition of 'bind' essentially affiliate it to the RUN state?

No, it is informing the secure world that a physical PCI function is
now a virtual PCI function, is a TDI, and is in a certain VM.

Outside virtual hotplug this is a permanent action when the VM is
created.

> > That is not prohibited, the TSM driver could do some auto
> > "bind/unbind" whatever that means triggered by ops or tdisp state
> > changing under the covers. But this cannot leak out as some kind of
> > asynchronous vdev destruction.
> 
> Maybe it'd be clearer using an example e.g. ARM to clarify the
> suggested split. Or wait for Aneesh's next version...

In ARM:

BIND is RMI_VDEV_CREATE it links a physical device to a virtual
device in a realm.

RMI_VSMMU_CREATE can attach a vSMMU to the realm and there is some way
to link the VDEV And the VSMMU together

Some sequence of RMI_VDEV_COMMUNICATE, RMI_VDEV_LOCK, RMI_VDEV_UNLOCK
and a few others manipulate the UNLOCKED/LOCKED/RUN/ERR TDISP state of
the VDEV.

I assume TDX has the same general shape, I don't know how you could
implement this in a radically different way?

So iommufd viommu create calls RMI_VSMMU_CREATE
   iommufd vdev create calls RMI_VDEV_CREATE
   iommufd viommu op ioctl calls the COMMUNICATE/LOCK/UNLOCK

Jason
