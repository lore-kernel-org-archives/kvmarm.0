Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D903859FD
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 10:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783679200; cv=none; b=Oa1gmfd1pxCrOc/Wqh0HvF1DTtsxPtyVf49gHazhbIMO7aT+lBvrCaN7Hvg5gpWukpcq7RuZ/Ho5MMVcMw3chTzjoVn3BLZTI781tYI3hNCijsRsFdyMiUWtbUxSf4XKQgxtgAEVTZPAhDUMjwGgNiQJaHZfXbIku2iN1l/KNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783679200; c=relaxed/simple;
	bh=Y2Q0Wnp+woBWIJ3LMki04DMU5S2ZDmbmlghNOolDQGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5VGVuH/Np51zIE0q6aYQOfUvwhaSiKtFcSon+J1VbhLCCPrwztYvkscoOSOo+ZhzizlhqT7C1URFX2Wuez7I03UpAVQ/DH9hxFrf5gT6BykHl4YpEHZBzO1Xydf8PxodPvdiywP3d1W5GHDzeT6pIFx3eEC4FC2NVm+cDACAXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f5JBwnvk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f5JBwnvk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3224C1D15;
	Fri, 10 Jul 2026 03:26:33 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1B2A3F66F;
	Fri, 10 Jul 2026 03:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783679197; bh=Y2Q0Wnp+woBWIJ3LMki04DMU5S2ZDmbmlghNOolDQGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f5JBwnvkMbfBzfJGuvFh8C1CFlY1Uf9qXvwM+YjG5+xhOFF/mJ+sAQjCNdC5ajd4n
	 oxbOeTDhE7HkAhwCJ7kazZBMSTyEmhtrIdsP7QN81SJ1RVAWhtB5+o4cfYMYh8RgbH
	 m31spkmTMgkXf5OVddLVf3wA3SKDV7hTUkI/dIKc=
Date: Fri, 10 Jul 2026 11:26:29 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, david.hildenbrand@arm.com, maz@kernel.org,
	oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
Message-ID: <alDI1b8fC99SG4_a@J2N7QTR9R3>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com>
 <ak0wSQ1133O7B96D@raptor>
 <ak0ziUcCXUlDdcla@google.com>
 <ak-EKSslAz1uqEtv@J2N7QTR9R3>
 <ak_wC4Q-mQe14DI8@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak_wC4Q-mQe14DI8@google.com>

Hi Sean,

On Thu, Jul 09, 2026 at 12:01:31PM -0700, Sean Christopherson wrote:
> On Thu, Jul 09, 2026, Mark Rutland wrote:
> The key thing for SPE is that any pages that the SPE HW is using must
> > have a valid writeable end-to-end (VA to real PA) mapping at all times
> > while the guest is running (and while the host drains buffers). If that
> > requirement is violated, even transiently, then data is lost and the
> > guest will see an unexpected fault reported by SPE.
> 
> Well, at least it doesn't crash the host :-D

Indeed! :)

> > If there's any reason we might (transiently) unmap a leaf entry (or
> > entire sub-tree) from the stage-2 tables, or might (transiently) remove
> > write permission, then we can't guarantee SPE will work correctly from
> > the guest's PoV.
> > 
> > Obviously we can't guarantee that for regular memslots backed by
> > userspace memory, hence we were hoping we could rely on guest_memfd.
> > 
> > Am I right to understand that we expect (in future) to do things with
> > guest_memfd that could violate that? If so (and if we're not happy to
> > have some options to say "always keep this pinned end-to-end no matter
> > what"), 
> 
> Yes?  Page migration is the main one that I think will be problematic for arm64,
> *unless* CPUs that support SPE don't require break-before-make (no idea if there
> are even plans to ever drop the BBM rules).  Because with page migration, unless
> KVM temporarily jails all vCPUs in the host while swizzling stage-2 PTEs, there
> will be a small window of time where the memory isn't mapped.

At a high level, if page migration (or any other changes to live stage-2
table entries) will be a thing for guest_memfd, then us Arm folk have to
go and work through the implications of that.

For contemporary HW with SPE, break-before-make will be required in at
least some cases. So unless we have some way to suppress migration, then
SPE virtualization on contemporary hardware is largely dead.

Going forwards, I believe that the intent is that future CPUs will
require BBM in fewer cases, but I suspect it won't disapear entirely.

> I mention page migration because I expect swap/reclaim to be fully userspace
> driven, i.e. if userspace crashes/corrupts the guest, the answer will be "well
> don't do that". 

Ah. I had assumed that if we'd consider kernel-driver migration of
guest_memfd memory, we'd also consider kernel-driven swapping of
guest_memfd memory.

I'm happy in principle with userspace being responsible for avoiding
anything problematic that is userspace-driven.

> But (at least some forms of) page migration will likely be
> kernel-driven, e.g. to compact movable memory for THP.  And I really don't want
> to give arch code the ability to hard-pin specific ranges of memory.
> 
> That said, odds are good that we'll end up with per-gmem flags to communicate to
> guest_memfd whether or not the gmem instance supports page migration (x86's TDX
> and SNP in particular require extra consideration).  So if the anticipated use
> cases are fine with all-or-nothing "pinning", or with juggling guest_memfd files
> in userspace if a more dynamic setup is desired, then you should be ok?
>
> E.g. if the anticipated use cases are all slice-of-hardware style setups where
> the VM will be statically assigned a chunk of memory, then for the most part this
> will all Just Work.

Yeah. I agree (with the caveats you mention). Arm folk need to go figure
out if it's worthwhile to support with all those caveats.

> > then I think that means that in practice we cannot virtualize
> > SPE correctly, and Alexandru and I need to go back to our architects.
> > 
> > > And at some point guest_memfd may support userspace-driven swap, but I
> > > suppose we can cross that bridge when we come to it.
> > 
> > Unfortunately, I think we need to figure out now whether it would be
> > acceptable to suppress that (or making it mutually exclusive with SPE),
> > if only to decide whether or not we continue trying to virtualize SPE.
> 
> Eh, as above, if userspace pulls a stupid and kills the guest, that's their
> problem.  Just make sure the host isn't at risk :-)

:)

FWIW, I agree from the host kernel side!

My concern is that if userspace VMM folk don't want to enforce that (or
want to but find it hard to handle correctly), then practically speaking
we're back to "SPE doesn't work", and from the guest kernel side there's
nothing we can do. As one of the SPE driver maintainers, I don't want to
be in a position where folk will shout at me because some VMM made a
mistake, and where I can't do anything to remedy the situation.

Hence, even if it's userspace's responsibility, we *might* want some way
for userspace to tell the kernel "please don't let me mess up this
specific requirement".

Thanks,
Mark.
