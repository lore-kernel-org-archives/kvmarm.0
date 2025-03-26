Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553CE24CEE1;
	Wed, 26 Mar 2025 18:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743012145; cv=none; b=dZdCrSFrapc2BWUMURiq1msN7SfpI0eMMFbTTyn5q7k+QzRjYylAs10Iv31WHu+rfquxpa4IFhvRX7PjeEgjSwZd2e0ezSzC2SA6qWck02JfCAOJktDhzEq4wNY7QEZyR0nNPtGbJwv4nq6ftoGMggW42fBDNl78G112bhnDa5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743012145; c=relaxed/simple;
	bh=k8k8tgCAZbed6quGFSWS3FiDb3hamN2ebexnotY7V1A=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hy3mdFlC6Z1l8Ah6RhOhhCdUX9N3IC3QJu0UWfWpbbAWNwPRT90947JMOl4Qepw7EyAgTV8E1PD8cfuj41Gm4y4H11jummNlkZyrgVGiWOY3PxCkMppphj1REoJ6xYZGpcol59VnPsIZn2u+nkAGnyd3AJpcKt6ElV9/i583KKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEfAQ7h1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEfAQ7h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818CDC4CEE2;
	Wed, 26 Mar 2025 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743012144;
	bh=k8k8tgCAZbed6quGFSWS3FiDb3hamN2ebexnotY7V1A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lEfAQ7h1jREVeaeYNMtbEH7rFvcHCZkck7zd6vOki3iX0BoKT+BmoAZF3es89Zq5w
	 2cJZyg2vASNPa/guJM0lseb7TZveOEUMVW6lAb/uaX4hyb2WahJm/qGBohfbBo4SaS
	 Q5p5nEW+wHLyBz9m1ypBuQcD62+qeUDS9VavKLoSTuqEeRnPutsnj3Fp+8RJQkDbId
	 OiSkwXluYNZlYchTgCGnvOqIDp1+rGqqYhJ+GJci9IImLxLoNodZ7geTITj3bscNwX
	 DRIllMGEAl5PuswF5C8xHxAC+HyZpNcIvyp6jTPKzW38rnS2F+NoDXzmvLCRQKjw6Q
	 UjthYoA47DetQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1txV54-00HOK2-3x;
	Wed, 26 Mar 2025 18:02:22 +0000
Date: Wed, 26 Mar 2025 18:02:21 +0000
Message-ID: <86wmcbllg2.wl-maz@kernel.org>
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
In-Reply-To: <Z-QnBcE1TKPChQay@google.com>
References: <Z9nJ42PllG8a7AY7@linux.dev>
	<20250318230909.GD9311@nvidia.com>
	<Z9pryQwy2iwa2bpJ@linux.dev>
	<20250319170429.GK9311@nvidia.com>
	<Z9sItt8BIgvbBY8M@arm.com>
	<20250319192246.GQ9311@nvidia.com>
	<Z9s7r2JocpoM_t-m@arm.com>
	<SA1PR12MB7199C7BD48EB39F536DD34DBB0A62@SA1PR12MB7199.namprd12.prod.outlook.com>
	<Z-QU7qJOf8sEA5R8@google.com>
	<86y0wrlrxt.wl-maz@kernel.org>
	<Z-QnBcE1TKPChQay@google.com>
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

On Wed, 26 Mar 2025 16:10:45 +0000,
Sean Christopherson <seanjc@google.com> wrote:
> 
> On Wed, Mar 26, 2025, Marc Zyngier wrote:
> > On Wed, 26 Mar 2025 14:53:34 +0000,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Wed, Mar 26, 2025, Ankit Agrawal wrote:
> > > > > On Wed, Mar 19, 2025 at 04:22:46PM -0300, Jason Gunthorpe wrote:
> > > > > > On Wed, Mar 19, 2025 at 06:11:02PM +0000, Catalin Marinas wrote:
> > > > > > > On Wed, Mar 19, 2025 at 02:04:29PM -0300, Jason Gunthorpe wrote:
> > > > > > > > On Wed, Mar 19, 2025 at 12:01:29AM -0700, Oliver Upton wrote:
> > > > > > > > > You have a very good point that KVM is broken for cacheable PFNMAP'd
> > > > > > > > > crap since we demote to something non-cacheable, and maybe that
> > > > > > > > > deserves fixing first. Hopefully nobody notices that we've taken away
> > > > > > > > > the toys...
> > > > > > > >
> > > > > > > > Fixing it is either faulting all access attempts or mapping it
> > > > > > > > cachable to the S2 (as this series is trying to do)..
> > > > > > >
> > > > > > > As I replied earlier, it might be worth doing both - fault on !FWB
> > > > > > > hardware (or rather reject the memslot creation), cacheable S2
> > > > > > > otherwise.
> > > > > >
> > > > > > I have no objection, Ankit are you able to make a failure patch?
> > > > >
> > > > > I'd wait until the KVM maintainers have their say.
> > > > > 
> > > > 
> > > > Maz, Oliver any thoughts on this? Can we conclude to create this failure
> > > > patch in memslot creation?
> > > 
> > > That's not sufficient.  As pointed out multiple times in this thread, any checks
> > > done at memslot creation are best effort "courtesies" provided to userspace to
> > > avoid terminating running VMs when the memory is faulted in.
> > > 
> > > I.e. checking at memslot creation is optional, checking at fault-in/mapping is
> > > not.
> > > 
> > > With that in place, I don't see any need for a memslot flag.  IIUC, without FWB,
> > > cacheable pfn-mapped memory is broken and needs to be disallowed.  But with FWB,
> > > KVM can simply honor the cacheability based on the VMA.  Neither of those requires
> > 
> > Remind me how this work with stuff such as guestmemfd, which, by
> > definition, doesn't have a userspace mapping?
> 
> Definitely not through a memslot flag.  The cacheability would be a property of
> the guest_memfd inode, similar to how it's a property of the underlying device
> in this case.

It's *not* a property of the device. It's a property of the mapping.

> I don't entirely see what guest_memfd has to do with this.

You were the one mentioning sampling the cacheability via the VMA. As
far as I understand guestmemfd, there is no VMA to speak of.

> One of the big
> advantages of guest_memfd is that KVM has complete control over the lifecycle of
> the memory.  IIUC, the issue with !FWB hosts is that KVM can't guarantee there
> are valid host mappings when memory is unmapped from the guest, and so can't do
> the necessary maintenance.  I agree with Jason's earlier statement that that's a
> solvable kernel flaw.
>
> For guest_memfd, KVM already does maintenance operations when memory is reclaimed,
> for both SNP and TDX.  I don't think ARM's cacheability stuff would require any
> new functionality in guest_memfd.

I don't know how you reconcile the lack of host mapping and cache
maintenance. The latter cannot take place without the former.

> 
> > > a memslot flag.  A KVM capability to enumerate FWB support would be nice though,
> > > e.g. so userspace can assert and bail early without ever hitting an
> > > ioctl error.
> > 
> > It's not "nice". It's mandatory. And FWB is definitely *not* something
> > we want to expose as such.
> 
> I agree a capability is mandatory if we're adding a memslot flag, but I don't
> think it's mandatory if this is all handled through kernel plumbing.

It is mandatory, full stop. Otherwise, userspace is able to migrate a
VM from an FWB host to a non-FWB one, start the VM, blow up on the
first page fault. That's not an acceptable outcome.

> 
> > > If we want to support existing setups that happen to work by dumb luck or careful
> > > configuration, then that should probably be an admin decision to support the
> > > "unsafe" behavior, i.e. an off-by-default KVM module param, not a memslot flag.
> > 
> > No. That's not how we handle an ABI issue. VM migration, with and
> > without FWB, can happen in both direction, and must have clear
> > semantics. So NAK to a kernel parameter.
> > 
> > If I have a VM with a device mapped as *device* on FWB host, I must be
> > able to migrate it to non-FWB host, and back. A device mapped as
> > *cacheable* can only be migrated between FWB-capable hosts.
> 
> But I thought the whole problem is that mapping this fancy memory as device is
> unsafe on non-FWB hosts?  If it's safe, then why does KVM needs to reject anything
> in the first place?

I don't know where you got that idea. This is all about what memory
type is exposed to a guest:

- with FWB, no need for CMOs, so cacheable memory is allowed if the
  device supports it (i.e. it actually exposes memory), and device
  otherwise.

- without FWB, CMOs are required, and we don't have a host mapping for
  these pages. As a fallback, the mapping is device only, as this
  doesn't require any CMO by definition.

There is no notion of "safety" here.

> > Importantly, it is *userspace* that is in charge of deciding how the
> > device is mapped at S2. And the memslot flag is the correct
> > abstraction for that.
>  
> I strongly disagree.  Whatever owns the underlying physical memory is in charge,
> not userspace.  For memory that's backed by a VMA, userspace can influence the
> behavior through mmap(), mprotect(), etc., but ultimately KVM needs to pull state
> from mm/, via the VMA.  Or in the guest_memfd case, from guest_memfd.

I don't buy that. Userspace needs to know the semantics of the memory
it gives to the guest. Or at least discover that the same device
plugged into to different hosts will have different behaviours. Just
letting things rip is not an acceptable outcome.

> I have no objection to adding KVM uAPI to let userspace add _restrictions_, e.g.
> to disallow mapping memory as writable even if the VMA is writable.  But IMO,
> adding a memslot flag to control cacheability isn't purely substractive.

I don't see how that solves the problem at hand: given the presence or
absence of FWB, allow userspace to discover as early as possible what
behaviour a piece of memory provided by a device will have, and
control it to handle migration.

	M.

-- 
Without deviation from the norm, progress is not possible.
