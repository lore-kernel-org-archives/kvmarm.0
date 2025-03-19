Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201618D63E;
	Wed, 19 Mar 2025 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742407447; cv=none; b=CMa6b3XD3SFyX8/BjNo5s4aAwmGX8190cxsMhfxp5i9rkaM6Ri0Fx685xcF5cxUp9H3QsrBF5QUwVBa5Q5ZUOJOODOfY1Pul1Ueb8MdqyWZCqqqVzFnCQbxW5oN8TNcvaMbmqkxXdmOKNV8m8Idb0aWmkeh1F6k6X6mXeWD9mao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742407447; c=relaxed/simple;
	bh=fCefeQ3q3l7xgH7lRPp3lIYPNhNLIQJnhm+V5ZlhCKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8n3udgDw3cmG/RJTc0Q/t0DK7ECEnMGRzcUG7nzYacoYsYUhCdKU6nwbmz/bFvri6Tp9BfU1GFerVP+dYjbDtWSH8TcEuLuxt16QZRHo5tMATo7OQ0/UdnpOVsWEMJvge+ZCLreQVnH9lfuetKeFhNYJAxXnc+1zZujWFK/mGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB44C4CEE4;
	Wed, 19 Mar 2025 18:03:59 +0000 (UTC)
Date: Wed, 19 Mar 2025 18:03:57 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
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
	"seanjc@google.com" <seanjc@google.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <Z9sHDbBgoMt7M-vc@arm.com>
References: <86r033olwv.wl-maz@kernel.org>
 <SA1PR12MB7199500A3683B15A64B663D6B0D12@SA1PR12MB7199.namprd12.prod.outlook.com>
 <87tt7y7j6r.wl-maz@kernel.org>
 <SA1PR12MB7199B320DAE42A8D7038A78EB0D32@SA1PR12MB7199.namprd12.prod.outlook.com>
 <8634fcnh0n.wl-maz@kernel.org>
 <Z9h98RhunemcFhhz@arm.com>
 <86wmcmn0dp.wl-maz@kernel.org>
 <20250318125527.GP9311@nvidia.com>
 <Z9nJH38Em9XEx3U7@arm.com>
 <20250318231736.GE9311@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318231736.GE9311@nvidia.com>

On Tue, Mar 18, 2025 at 08:17:36PM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 18, 2025 at 07:27:27PM +0000, Catalin Marinas wrote:
> > Thinking some more about a KVM capability that the VMM can check, I'm
> > not sure what it can do with this. The VMM simply maps something from a
> > device and cannot probe the cacheability 
> 
> KVM is mirroring the MM's PTEs to the S2's PTEs.
> 
> You can think about this differently - KVM currently has a little bug
> where the MM's PTE's can say cachable but KVM will mirror it to a S2
> PTE that is forced non-cachable. KVM will not do any cache flushing to
> make this safe.
> 
> Fundamentally that discrepancy is what is being addressed
> here. Cachable PTEs in the MM should be mirrored to cachable PTEs in
> the S2.

If we treat this as a bug (and I agree it's a potential problem if we
assign devices to the guest that have cacheable VMM mappings), the first
step would be to reject such memory slots, report some error to the VMM.
I don't think it's worth attempting to do any cache maintenance to sync
the aliases.

Subsequently, this can be allowed with on FWB-capable hardware. Whether
we want to expose such capability to the VMM, I guess it's harmless but
I doubt the VMM would do anything with it since it doesn't know the
device mapping attributes anyway.

-- 
Catalin
