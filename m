Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6475E3ED5C9
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 11:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783596083; cv=none; b=CbxY+z2jfcYa6GFp5m081EoInxip/Ta8X0fzMIuP/O+2JwZyZnEGO4DETPmHT36QeZO3lsd4qwKcGjhx34VZ5Clx/Pa8M8eoTD5YafqJG9EZEEBr3eH56bBZioVJmNsxM8SftGcAvwAGaJL+5+yh7HVMkrPIwxsqWq80Xc88Nac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783596083; c=relaxed/simple;
	bh=x0zF6RctJI2oj7xqS+CM8W2IeGPyRQGsTPlFyL7qVzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bv6w8DaRzehXF3EEGFDjVqZX1h9P3J1WMqI82e4Vj4K8QLDleuZFwqXsIUFezU0vTPcOfps6dUvV+oGrFrwYIGd9t4znS1FTD3EazfeuQboIoZZY/A6a+Eg1uwcDcy/MqJklYJiM++nVvrHhxSOJTFZc3AFgrfjlSUj9CveaPR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pAFjneuX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pAFjneuX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 886223570;
	Thu,  9 Jul 2026 04:21:17 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 905A13FE53;
	Thu,  9 Jul 2026 04:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783596081; bh=x0zF6RctJI2oj7xqS+CM8W2IeGPyRQGsTPlFyL7qVzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pAFjneuXOC/mavJU+ZBHx7MCX1JeT+brvnQARglyOslkF0b1wfoUruD1+BnxskyVQ
	 18dvl+2MhIxfu/l3yG33GjyTV7RNrF1LAV/t7RlafgV+TYmDrrmGzeMTGHpjZ3qRij
	 6IRASP294x/i0/g1b0co+eA7BLkRyeCX3mbpoZZ4=
Date: Thu, 9 Jul 2026 12:21:13 +0100
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
Message-ID: <ak-EKSslAz1uqEtv@J2N7QTR9R3>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com>
 <ak0wSQ1133O7B96D@raptor>
 <ak0ziUcCXUlDdcla@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak0ziUcCXUlDdcla@google.com>

Hi Sean,

Ignoring dirty page logging for the moment, I think you've raised a much
bigger concern.

I've dumped a bit more context below, with a couple of high-level
questions. The important thing for Alexandru and I is whether core folk
are willing to consider some mechanism to ensure that guest PAs are
pinned writeable and never fault (even transiently).

On Tue, Jul 07, 2026 at 10:12:41AM -0700, Sean Christopherson wrote:
> On Tue, Jul 07, 2026, Alexandru Elisei wrote:
> > On Mon, Jul 06, 2026 at 05:56:12PM -0700, Sean Christopherson wrote:
> > > On Thu, Jul 02, 2026, Alexandru Elisei wrote:

> > > Please (publicly) document *why*  you want to add dirty-logging support.  It's
> > > all but impossible to review new uAPI without knowing the use case.

> > As to why I'm working on it now, it's because of an arm64 feature that
> > requires that memory remains mapped at stage 2, called Statistical
> > Profiling Extension (SPE), similar to Intel's PEBS or AMD's IBS. Exposing
> > the feature to a guest requires that memory remains mapped at stage 2
> > outside of userspace explicitely unmapping it, and guest_memfd, with the
> > patch to ignore the MMU notifiers [1], has this property.  I wanted to
> > expand the functionality of guest_memfd to support migration of virtual
> > machines when that arm64 feature is exposed to guests.
> 
> I'm all for adding dirty logging support for guest_memfd, but for SPE I don't
> think relying on guest_memfd always being mapped is a good idea.  guest_memfd
> is "pinned" purely because adding support for page migration is (very) low
> priority for SNP, TDX, and pKVM.  guest_memfd page migration might play nice
> with SPE?  Probably depends on whether KVM is forced to do break-before-make?

The key thing for SPE is that any pages that the SPE HW is using must
have a valid writeable end-to-end (VA to real PA) mapping at all times
while the guest is running (and while the host drains buffers). If that
requirement is violated, even transiently, then data is lost and the
guest will see an unexpected fault reported by SPE.

If there's any reason we might (transiently) unmap a leaf entry (or
entire sub-tree) from the stage-2 tables, or might (transiently) remove
write permission, then we can't guarantee SPE will work correctly from
the guest's PoV.

Obviously we can't guarantee that for regular memslots backed by
userspace memory, hence we were hoping we could rely on guest_memfd.

Am I right to understand that we expect (in future) to do things with
guest_memfd that could violate that? If so (and if we're not happy to
have some options to say "always keep this pinned end-to-end no matter
what"), then I think that means that in practice we cannot virtualize
SPE correctly, and Alexandru and I need to go back to our architects.

> And at some point guest_memfd may support userspace-driven swap, but I
> suppose we can cross that bridge when we come to it.

Unfortunately, I think we need to figure out now whether it would be
acceptable to suppress that (or making it mutually exclusive with SPE),
if only to decide whether or not we continue trying to virtualize SPE.

We don't need to figure out all the details; just whether or not that
broad approach would be acceptable, or whether we have to give up on SPE
virtualization.

> From a uABI perspective, forcing userspace to use guest_memfd to get access to
> something like SPE isn't ideal.  While I have aspirations of using guest_memfd
> much more broadly, I don't know that banking on guest_memfd replacing "everything"
> is a winning strategy.

I agree this isn't ideal, and we're certainly not expecting that this is
suitable for all users. We're just trying to get as much functionality
as we practically can with today's SPE hardware.

Thanks,
Mark.
