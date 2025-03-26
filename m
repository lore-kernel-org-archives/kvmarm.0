Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709591F754E;
	Wed, 26 Mar 2025 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743003731; cv=none; b=sLCCpEBdGjmR5FzrGG+zJLypQOTvixlMGYIfRlMaWzQkGXM0cRReEpICkbOHkGE73yVikoohRJWS1L0XL+V6+S+QmxjkSvLloxkiK6cfqgnAcocbC72lM/LvH+KtjDf1TVtMDxXdqN6UaQ2GYX9XqI5fI3lhvcaOAUm4uB8CJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743003731; c=relaxed/simple;
	bh=ib4x6OcF6rnhMi00OM/dZg1cf6CcAyobXf3DKclgFn4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBa5Cfv6FbNFOulJh8uv82BTp7LrBzRhUvw1VlNaCX66HUm+0ggTRRBcDvV8yBOPi1kf+fXhqaSwzSlvZgueoj9hSSWc739RnTrejQHfPF6Llh3qVAmmrLkRxGw9f72uCBMgFsEAD3nI6ArMITAAPQKxMo8UI5M+b/+pniTl7Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RA5zcMMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RA5zcMMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D642CC4CEE2;
	Wed, 26 Mar 2025 15:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743003730;
	bh=ib4x6OcF6rnhMi00OM/dZg1cf6CcAyobXf3DKclgFn4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RA5zcMMKSAFp+Sh6oqJ3dX3rcY2FQARSZe3fzCcqx+YdXwmJmltd36L5z7JEyWNRR
	 E1/gMw7VlL8gsmHWk5QCI6PGRpNZjS3qFdHQHMUBdpDaHSsLuWDFP6EerC0UVnoWeK
	 wr6AAiI/4UmBiQoanAekZkm8TDlqBpx/4JsKMhV5WmhZMsp96eytxyPxSIwArlgJY2
	 YjPQSnooP5f/O2oqjwAES11D0byOrlNKYrtGVn38ABjZzU9v4UbGEZn1pU52t5JuPp
	 sPOlEHMZpz+0i6kRj/w81AwnuupB/SHLgAkC6aHYwRjl1tgl4zQOMVRlPPZ+XRe/qU
	 KDo82i7zupSoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1txStM-00HLiv-1l;
	Wed, 26 Mar 2025 15:42:08 +0000
Date: Wed, 26 Mar 2025 15:42:06 +0000
Message-ID: <86y0wrlrxt.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"david@redhat.com" <david@redhat.com>,
	Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>,
	Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Dan Williams <danw@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	Uday Dhoke <udhoke@nvidia.com>,
	Dheeraj Nigam <dnigam@nvidia.com>,
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
Subject: Re: [PATCH v3 1/1] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
In-Reply-To: <Z-QU7qJOf8sEA5R8@google.com>
References: <86wmcmn0dp.wl-maz@kernel.org>
	<20250318125527.GP9311@nvidia.com>
	<Z9nJ42PllG8a7AY7@linux.dev>
	<20250318230909.GD9311@nvidia.com>
	<Z9pryQwy2iwa2bpJ@linux.dev>
	<20250319170429.GK9311@nvidia.com>
	<Z9sItt8BIgvbBY8M@arm.com>
	<20250319192246.GQ9311@nvidia.com>
	<Z9s7r2JocpoM_t-m@arm.com>
	<SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
	<Z-QU7qJOf8sEA5R8@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.4
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: seanjc@google.com, ankita@nvidia.com, catalin.marinas@arm.com, jgg@nvidia.com, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org, david@redhat.com, aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com, coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org, ddutile@redhat.com, tabba@google.com, qperret@google.com, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 26 Mar 2025 14:53:34 +0000,
Sean Christopherson <seanjc@google.com> wrote:
> 
> On Wed, Mar 26, 2025, Ankit Agrawal wrote:
> > > On Wed, Mar 19, 2025 at 04:22:46PM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Mar 19, 2025 at 06:11:02PM +0000, Catalin Marinas wrote:
> > > > > On Wed, Mar 19, 2025 at 02:04:29PM -0300, Jason Gunthorpe wrote:
> > > > > > On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:
> > > > > > > You have a very good point that KVM is broken for cacheable PFNMAP'd
> > > > > > > crap since we demote to something non-cacheable, and maybe that
> > > > > > > deserves fixing first. Hopefully nobody notices that we've taken away
> > > > > > > the toys...
> > > > > >
> > > > > > Fixing it is either faulting all access attempts or mapping it
> > > > > > cachable to the S2 (as this series is trying to do)..
> > > > >
> > > > > As I replied earlier, it might be worth doing both - fault on !FWB
> > > > > hardware (or rather reject the memslot creation), cacheable S2
> > > > > otherwise.
> > > >
> > > > I have no objection, Ankit are you able to make a failure patch?
> > >
> > > I'd wait until the KVM maintainers have their say.
> > > 
> > 
> > Maz, Oliver any thoughts on this? Can we conclude to create this failure
> > patch in memslot creation?
> 
> That's not sufficient.  As pointed out multiple times in this thread, any checks
> done at memslot creation are best effort "courtesies" provided to userspace to
> avoid terminating running VMs when the memory is faulted in.
> 
> I.e. checking at memslot creation is optional, checking at fault-in/mapping is
> not.
> 
> With that in place, I don't see any need for a memslot flag.  IIUC, without FWB,
> cacheable pfn-mapped memory is broken and needs to be disallowed.  But with FWB,
> KVM can simply honor the cacheability based on the VMA.  Neither of those requires

Remind me how this work with stuff such as guestmemfd, which, by
definition, doesn't have a userspace mapping?

> a memslot flag.  A KVM capability to enumerate FWB support would be nice though,
> e.g. so userspace can assert and bail early without ever hitting an
> ioctl error.

It's not "nice". It's mandatory. And FWB is definitely *not* something
we want to expose as such.

> 
> If we want to support existing setups that happen to work by dumb luck or careful
> configuration, then that should probably be an admin decision to support the
> "unsafe" behavior, i.e. an off-by-default KVM module param, not a memslot flag.

No. That's not how we handle an ABI issue. VM migration, with and
without FWB, can happen in both direction, and must have clear
semantics. So NAK to a kernel parameter.

If I have a VM with a device mapped as *device* on FWB host, I must be
able to migrate it to non-FWB host, and back. A device mapped as
*cacheable* can only be migrated between FWB-capable hosts.

Importantly, it is *userspace* that is in charge of deciding how the
device is mapped at S2. And the memslot flag is the correct
abstraction for that.

	M.

-- 
Without deviation from the norm, progress is not possible.
