Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BB93546D6;
	Fri, 18 Sep 2026 05:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710852; cv=none; b=MFQamKCSwz/c1NdbimDpydtdte72p6SSNKbw7hzFm/hFH7Oz/zeXLe6vjVCk81GZS/BKZ/hCdA9BDUVV64Z3PrQGad25UQbT50Zegl6G5uOQxlfmDOV8HYNUXWSSLkKKzlNZ1q/PRV+beWzgrtICPlFZ81n993c9UeHSKMQLNsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710852; c=relaxed/simple;
	bh=lmlV7xFHRVTdsb3n+oqHHiehmNTVMleq48/Xf23jFaU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GZhhnoHBxPlpJTXT9nBJPCa8zV/p0iJ9JL7tc+ovbHKwBPsLuBPGPNrmkV5bu3TPdpEYgyCXrVP9twxwaFqwBSPzzT1cUyl2VFXP/5Zo4DUzjQ2yNKzBLF2pLP4jiB/n6nXoE5OL6C/zFUAzY3p2ip4eb8/HRUwdx2H8BpUFyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+FfgJmW; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+FfgJmW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789710851; x=1821246851;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lmlV7xFHRVTdsb3n+oqHHiehmNTVMleq48/Xf23jFaU=;
  b=Z+FfgJmWVX6RtGyFUJtUeeq7kckzlwrPI2+rHGt+l5PuhqauHqEcHnkG
   tUzf7EK2ttIqwcseloRbyljNUMQJmH/Mra898O3p1a/C0dHrUOJ13jzDy
   23ikrb04EHTdCtT94xO9ZbJMNnfQ1clukEvAnzaLJtUbZcLA8xFMqL4TA
   6e0nQlA446SrtHZ0hH3voh2a0DC3pwwtwSjWojwEF1LYWfgv+mYdOC32C
   8ILoaAyNfS3aPHtYDDIPl5m5bB0e5/urfEt1Inqfvb+GtRlhPjK6tdtk9
   Im9ZJ4evNLob7teeLioLxX3zE7BOAc/v9c9PTjzkdYYMqUU8soDsL2F/F
   Q==;
X-CSE-ConnectionGUID: CLt4ALYLS26RcMaEReOh1w==
X-CSE-MsgGUID: vGN24ODUS0yaHGde8srmWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="90326546"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="90326546"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 22:54:10 -0700
X-CSE-ConnectionGUID: KgABx0ZsR3iY4fYq/tVq2Q==
X-CSE-MsgGUID: GZcbDF/7SxSIjyTZ91er0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="2628589"
Received: from unknown (HELO [10.238.1.188]) ([10.238.1.188])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 22:54:05 -0700
Message-ID: <2ba47d98-21b5-40de-9df0-be6676ade064@linux.intel.com>
Date: Fri, 18 Sep 2026 13:54:02 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nicolin Chen <nicolinc@nvidia.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Pranjal Shrivastava <praan@google.com>,
 Robin Murphy <robin.murphy@arm.com>, Samuel Ortiz <sameo@rivosinc.com>,
 Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
To: Jason Gunthorpe <jgg@ziepe.ca>, "Tian, Kevin" <kevin.tian@intel.com>
References: <20260903171704.GK2890729@ziepe.ca> <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca> <yq5atsnyag84.fsf@kernel.org>
 <20260909124628.GH2543240@ziepe.ca>
 <CO1PR11MB4835512E374074A5F4AD0A6C8CBF2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260910124632.GB4083318@ziepe.ca>
 <CO1PR11MB4835FF972283C09D7D683DAE8CBA2@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260915134318.GB3196566@ziepe.ca>
 <CO1PR11MB4835562E7714F368E669D3B48CB92@CO1PR11MB4835.namprd11.prod.outlook.com>
 <20260916123954.GC3196566@ziepe.ca>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20260916123954.GC3196566@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/16/2026 8:39 PM, Jason Gunthorpe wrote:
> On Wed, Sep 16, 2026 at 05:54:57AM +0000, Tian, Kevin wrote:
>>> At least for ARM there is effectively no entanglement with the actual
>>> host iommu driver. The viommu is entirely provided by software in the
>>> RMM world, so it can have its own dedicated driver. In ARM T=1
>>> transactions are alwayus routed to the RMM's iommu and there is no
>>> relation to the host.
>>>
>>> I am interested how Intel works here, but I thought it was similar.
>> Largely yes. Main difference at Intel side is that TDX still relies on the
>> host to initiate iotlb invalidation (upon notification from KVM on S-EPT
>> change). Currently we put this logic in intel-iommu driver but it's more
>> about wrapping invalidation info and passing it to the firmware. Moving
>> it into the tsm driver should be straightforward.
>>
>> Maybe there'll be other subtle connections to host iommu driver but
>> it doesn't sound a hard problem to solve.
> Okay, so I saw the driver posting for basic iommu support, can we try
> to rework that to be split out like Aneesh is doing so everything
> about TDX calls lives in tsm and intel iommu only provides a small API
> surface to exchange whatever details are needed to bootstrap TDX
> module?

Are you referring to this series?

https://lore.kernel.org/linux-iommu/20260915074235.1219183-1-baolu.lu@linux.intel.com/

It initializes the iommu managed by the secure world (the TDX module).

I’m happy to rework it as you suggested by moving most of the TDX-
related code into the tsm driver and leaving the host iommu driver to
provide only the necessary assistance.

Thanks,
baolu
