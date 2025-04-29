Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B6521A43B;
	Tue, 29 Apr 2025 16:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745942608; cv=none; b=EMHOaUhB0DAU/s/NuzCOQGW1sFZlD+y3xLWO1yJV22S0jygl87HW5n8A9QEdHeRtfP+xffkxt4dD/zVfRmMX496BTcNbB4JJvsdWsaGKHoSUCiYy03fexjkUY4d+RJT/fzZBgiDm2sf0AZRZw7/tD3gJ+OwyofJWy7769FGGkA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745942608; c=relaxed/simple;
	bh=5YaC2lcbO17IOdpWKRroIk4Ix6jjFeXEWRnyqsFLqTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UvrjSQQfhuI/ZeWHzuc5fZdINuq/we//rivu5F2BpVje6t4CdAv41oJR6fJAXAhshssEHj0XyOdTpFvesFmqehyXJKCJj/dT2Kv/CQHjDcuxKWX24F7tvry6DRznGWXy1TDz1XHWtcyMkeBzorOAgEDIpAxYuF1jNMFjq9idhhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0850DC4CEE3;
	Tue, 29 Apr 2025 16:03:20 +0000 (UTC)
Date: Tue, 29 Apr 2025 17:03:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
Message-ID: <aBD4RsUZp-BmcLwC@arm.com>
References: <20250422170324.GB1645809@nvidia.com>
 <aAgJ8g8Gbb06quSM@linux.dev>
 <20250422233556.GB1648741@nvidia.com>
 <aAjEsIwhYQpkphrW@arm.com>
 <20250423120243.GD1648741@nvidia.com>
 <aAjci3rddHt_R_x3@arm.com>
 <20250423130323.GE1648741@nvidia.com>
 <SA1PR12MB71996988916E1FB15149DD13B0802@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aBDTpu_ACoXAPoE2@arm.com>
 <20250429141437.GC2260709@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429141437.GC2260709@nvidia.com>

On Tue, Apr 29, 2025 at 11:14:37AM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 29, 2025 at 02:27:02PM +0100, Catalin Marinas wrote:
> > BTW, we should reject exec mappings as well (they probably fail for S1
> > VFIO since set_pte_at() will try to do cache maintenance).
> 
> To be clear the S2 should leave the mapping as execute allowed
> though. Only the VM knows how it will use this memory and VM's do
> actually execute out of the cachable PFNMAP VMA today. The VM will set
> any execute deny/allow on its S1 table according to how it uses the
> memory.

If S2 is executable, wouldn't KVM try to invalidate the I-cache and it
won't have an alias to do this? Unless it doesn't end up in
stage2_map_walker_try_leaf() or the walk has been flagged as skipping
the CMO.

-- 
Catalin
