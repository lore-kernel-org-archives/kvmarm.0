Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB86D290D9B;
	Fri,  9 May 2025 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746794866; cv=none; b=oJdkskxKbbWbIUQJ3u9GeGxkJl5gyJb9XsU0SqORu6tR1sEuWYGM+YrkdRxdCY4vgbpNKRhjij9Z5S1q/SPKjSPKu7TJ8yZpYmy8oQnFHzEh+H19AFThrxE609YOXyjsn9VKNh/eWS+d7q2q57+2izV6SojjWjIUXOY4pCa+DN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746794866; c=relaxed/simple;
	bh=Sgl4dmv2d30oYMAuM3YMqPWMtQeY4TyzuoWF79Ce3xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfIz1b5ogauPk3lYyeCqTAFZ/319zmdG7Pgq742+YxHN+5JDMNAwTIPApevij7564wOFtSsDRcT/XzgEmvPPgQlNp4d1lzAO2wNf7RG/JobUAt1Ptf7oAD40m9eXEDxrwFlJcfuSVEvHCcEsGvun88rO7R9EgFqtmHT+azBOKhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4DBC4CEEF;
	Fri,  9 May 2025 12:47:38 +0000 (UTC)
Date: Fri, 9 May 2025 13:47:36 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"sebastianene@google.com" <sebastianene@google.com>,
	"coltonlewis@google.com" <coltonlewis@google.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"gshan@redhat.com" <gshan@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>,
	"tabba@google.com" <tabba@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <aB35aOZzdKZKMOht@arm.com>
References: <aAjci3rddHt_R_x3@arm.com>
 <20250423130323.GE1648741@nvidia.com>
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aBDTpu_ACoXAPoE2@arm.com>
 <20250429141437.GC2260709@nvidia.com>
 <aBD4RsUZp-BmcLwC@arm.com>
 <20250429164430.GD2260709@nvidia.com>
 <aBEV5gxYoDFct9PC@arm.com>
 <20250429181926.GE2260709@nvidia.com>
 <SA1PR12MB71992BC382DA4ED506100590B088A@SA1PR12MB7199.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR12MB71992BC382DA4ED506100590B088A@SA1PR12MB7199.namprd12.prod.outlook.com>

On Wed, May 07, 2025 at 03:26:05PM +0000, Ankit Agrawal wrote:
> >> Unless FWB implies CTR_EL0.DIC (AFAIK, it doesn't) we may be
> >> restricting some CPUs.
> >
> > Yes, it will further narrow the CPUs down.
> > 
> > However, we just did this discussion for BBML2 + SMMUv3 SVA. I think
> > the same argument holds. If someone is crazy enough to build a CPU
> > with CXLish support and uses an old core without DIC, IDC and S2FWB
> > then they are going to have a bunch of work to fix the SW to support
> > it. Right now we know of no system that exists like this..
> >
> > Jason
> 
> Catalin, do you agree if I can go ahead and add the check for
> ARM64_HAS_CACHE_DIC?

As long as we don't leave out some hardware that has FWB but not DIC,
that's fine by me.

-- 
Catalin
