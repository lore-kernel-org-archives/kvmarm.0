Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A72C28EA62
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333586; cv=none; b=IC8EpMCpD+BHjqd3poJdA1BIOPNZ3sg/W6RbGUAcgT19Lkqj3Z26CFthN6saeLdNJAkDjhVHQhJkoEC6vxf9yt1VP09edsCieGLFSWwXZ1GuSWhbO2lohWwbXQMdQ8GLH8E5al+XdDYC79I4AoYtosEeM8DxtLBdX0Re6g89jIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333586; c=relaxed/simple;
	bh=qT84d97/AkxTKwpR/m+Rfq7YQ6rDibD+K221GdCA8j8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V5s8oE0yT1wt0iFiSyocKbq8/yERSqzjjMdAby26tlyGdIVv2XUbzR/eq4RIEi45EwRxwhuFfTE11W9CmzJ2jLYIEq51/hDOF+t1PzFCAUW1J0TXFgER8AkQ8UwYPA6PxiD4a1Zcj3YjJBUEM94nkbX9ciQzUWIUwOm4vYwwAEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D1y+vTAt; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D1y+vTAt"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736d30d2570so4459720b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 07:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745333584; x=1745938384; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ooGcU85uLmvlzkjhi9UMrJ/GcNbNjtlDBh2b9XJHwJc=;
        b=D1y+vTAtO2h5tAoLPKr44jU16FIXYKTKBiu2RZSMsX1myeXxkulcMXmzNg28JEMGP2
         w+BXgvoceH6MCnucobPh6zMP2lha7XNh+JJ8f5wWaClUxFDfdBP+wcTm4mTpcgOTRmux
         Jct4yDiTt3ELMjxIsZPma3doYhOGNUWJN3gWcCuU9adnq+44ETe6OSU0/QmiOkrzcMOj
         Sm/FWsxFqUJAkZ3W9JWsVbz+Pwc4KglBoGt+OKm7zW6EQfl6/0t/k/wxJqm61KuDnySV
         PWjlh1T07RNsxMgmky2qzvzr8tQovrwXgNZ6s7CVuMpy2ieaUW3gE25D0hvSI5yuMqv/
         HyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745333584; x=1745938384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooGcU85uLmvlzkjhi9UMrJ/GcNbNjtlDBh2b9XJHwJc=;
        b=RZBBW7H+jBR4KlPvjfbdv+y0QYJPbkkY9NnOW4cpnEe0IRLj6dFKSGzjVKReRJNGmd
         GIWRW+p0n4rvN/7H99kvT79KYy4fh+XturNPPuBr8YUCmc15gNuUgWw2dXO5dpo6JByv
         KY5thvgox/nOZoIGbg1bdf21flSXJkkW6a+ha1PxSjG1aUMrjXG6a/FOYHAuQ1cu2QTd
         9U2tsN5LIvD7Y3GbDnSe/oqzyn/qdmZhFHqVOy0wEAyeh5E+6NvboNcoGcQbmEbaslCJ
         opUD8CoZV8J0ymhQMdgm/9uXtxvtNKvUaOOmKTcmvcjOPB98JyXu/Ts9nActoZRU0Eer
         vP0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAcxsjXXQ2Uq3FT0fRm6B/DembuiurWnDMwJHjlR1nRJJOZNj+SpYCZ8UfMxgRF04UsoWfLs4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3B1+ppYo87XfCeCrwAiphFNK66TWixv3oSQCFfnxfVToCTqZy
	AZoHvUXeJh66nmWgatgWkx7fgK97yUl1AKFwKQRowXqhRaMyZn8rLxMdvKgwsH0paKys44Eaj0m
	1Ng==
X-Google-Smtp-Source: AGHT+IEx25gCkpttQgdXEdRCmM9tOpB/Y3lOr09cr6TIRqh2wKfoCLxMxZ/On7rEEuVhXVHqBKJaHk715hw=
X-Received: from pfbfc7.prod.google.com ([2002:a05:6a00:2e07:b0:736:9c55:9272])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:888:b0:736:5544:7ad7
 with SMTP id d2e1a72fcca58-73dc14e8128mr18167922b3a.14.1745333584127; Tue, 22
 Apr 2025 07:53:04 -0700 (PDT)
Date: Tue, 22 Apr 2025 07:53:02 -0700
In-Reply-To: <aAdKCGCuwlUeUXKY@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <86y0wrlrxt.wl-maz@kernel.org> <Z-QnBcE1TKPChQay@google.com>
 <86wmcbllg2.wl-maz@kernel.org> <Z-RGYO3QVj5JNjRB@google.com>
 <20250331145643.GF10839@nvidia.com> <Z_PtKWnMPzwPb4sp@google.com>
 <20250407161540.GG1557073@nvidia.com> <Z_QAxiEWEyMpfLgL@google.com>
 <SA1PR12MB719976799AD7F9FC4407A5A9B0BD2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aAdKCGCuwlUeUXKY@linux.dev>
Message-ID: <aAetTj1U4BWSmqQV@google.com>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"will@kernel.org" <will@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"shahuang@redhat.com" <shahuang@redhat.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>, 
	"david@redhat.com" <david@redhat.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, 
	Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, 
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, 
	Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, 
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Uday Dhoke <udhoke@nvidia.com>, 
	Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, 
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, 
	"sebastianene@google.com" <sebastianene@google.com>, "coltonlewis@google.com" <coltonlewis@google.com>, 
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com" <yi.l.liu@intel.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"gshan@redhat.com" <gshan@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ddutile@redhat.com" <ddutile@redhat.com>, "tabba@google.com" <tabba@google.com>, 
	"qperret@google.com" <qperret@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Oliver Upton wrote:
> Hi,
> 
> On Wed, Apr 16, 2025 at 08:51:05AM +0000, Ankit Agrawal wrote:
> > Hi, summarizing the discussion so far and outlining the next steps. The key points
> > are as follows:
> > 1. KVM cap to expose whether the kernel supports mapping cacheable PFNMAP:
> > If the host doesn't have FWB, then the capability doesn't exist. Jason, Oliver, Caitlin
> > and Sean points that this may not be required as userspace do not have
> > much choice anyways. KVM has to follow the PTEs and userspace cannot ask
> > for something different. However, Marc points that enumerating FWB support
> > would allow userspace to discover the support and prevent live-migration
> > across FWB and non-FWB hosts. Jason suggested that this may still be fine as
> > we have already built in VFIO side protection where a live migration can be
> > attempted and then fail because of late-detected HW incompatibilities.
> > 
> > 2. New memslot flag that VMM passes at memslot registration:
> > Discussion point that this is not necessary and KVM should just follow the
> > VMA pgprot.
> > 
> > 3. Fallback path handling for PFNMAP when the FWB is not set:
> > Discussion points that there shouldn't be any fallback path and the memslot
> > should just fail. i.e. KVM should not allow degrading cachable to non-cachable
> > when it can't do flushing. This is to prevent the potential security issue
> > pointed by Jason (S1 cacheable, S2 noncacheable).
> > 
> > 
> > So AIU, the next step is to send out the updated series with the following patches:
> > 1. Block cacheable PFN map in memslot creation (kvm_arch_prepare_memory_region)
> > and during fault handling (user_mem_abort()).
> 
> Yes, we need to prevent the creation of stage-2 mappings to PFNMAP memory
> that uses cacheable attributes in the host stage-1. I believe we have alignment
> that this is a bugfix.
> 
> > 2. Enable support for cacheable PFN maps if S2FWB is enabled by following
> > the vma pgprot (this patch).
> > 
> > 3. Add and expose the new KVM cap to expose cacheable PFNMAP (set to false
> > for !FWB), pending maintainers' feedback on the necessity of this capability.
> 
> Regarding UAPI: I'm still convinced that we need the VMM to buy in to this
> behavior. And no, it doesn't matter if this is some VFIO-based mapping
> or kernel-managed memory.
> 
> The reality is that userspace is an equal participant in remaining coherent with
> the guest. Whether or not FWB is employed for a particular region of IPA
> space is useful information for userspace deciding what it needs to do to access guest
> memory. Ignoring the Nvidia widget for a second, userspace also needs to know this for
> 'normal', kernel-managed memory so it understands what CMOs may be necessary when (for
> example) doing live migration of the VM.
> 
> So this KVM CAP needs to be paired with a memslot flag.
>
>  - The capability says KVM is able to enforce Write-Back at stage-2
> 
>  - The memslot flag says userspace expects a particular GFN range to guarantee
>    Write-Back semantics. This can be applied to 'normal', kernel-managed memory
>    and PFNMAP thingies that have cacheable attributes at host stage-1.

I am very strongly opposed to adding a memslot flag.  IMO, it sets a terrible
precedent, and I am struggling to understand why a per-VM CAP isn't sufficient
protection for the VMM.

>  - Under no situation do we allow userspace to create non-cacheable mapping at
>    stage-2 for something PFNMAP cacheable at stage-1.
> 
> No matter what, my understanding is that we all agree the driver which provided the
> host stage-1 mapping is the authoritative source for memory attributes compatible
> with a given device. The accompanying UAPI is necessary for the VMM to understand how
> to handle arbitrary cacheable mappings provided to the VM.
> 
> Thanks,
> Oliver
