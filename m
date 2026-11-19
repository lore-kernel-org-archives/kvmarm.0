Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101907;
	b=zvtCbxAEGM94njn/YitmhfZcefykzx9k5lhi13KFIIpOjysMWmyjh3qFnrkmT4qflViV
	 PoP4npzdjaJV/HrkilPsnHaazE1b+rjqJb4TEEd1XnkmPhkMC+agsZ68KGGLUyCJf+dXP
	 v7eYO7a4cAoewDdHWQW5ugCBFHhKR5iHJ2MoVX5uQdRXWzJJ5rrAZl6U0VD9vE2r+G6Ww
	 z7/c8gBUAgQ4rFklDLJ9yGP1PrzVGVbmgSoSTbT5uezCncrAxva+3b81v+zdp7tiUn+9b
	 RUCt2XDBBVTciCL4zZ/8gQf14B/OxK3bNgJOJLGINwTA6VJmrcWo5FnLRAm6q+K5RDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101907;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=TzGcuigoI99vvi0jTQ+1RRJQmDFrEo3B9K0Tz4FddVk=;
	b=CuPkwCy6rlBkp69DXoMjcc57/8mjBsG6zkloS0qUVP/5oJcsx6e4uU4EpvDfHQiGzKeV
	 x2kqg+eeiHjZP2UlLfdLVlvqLCjNyRlMaQFbzPToVvXn547OWgR50SiyFK0wy87urR3XM
	 zcj89yOnGrfk+nwLnko4xIwAjMnFxGlrqSOSGpeJ+V74s7rSblkeNRO7cb3KiKLvIvKpu
	 qtpYVEhxt2OFXNDBfWUmeu7HC+AD/kEg8OIZvoHWNRPQMa39vRd48KkMNZ/zDeVBme8RJ
	 hJcweGrkKnSxNDyo/TwbRzFQJUtCsuKgUz4zb4VcuUbXN+H4WqNaVIPD5ZdGIOLQTxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=gdzLmp43;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD177606A326
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 15:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD177606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=gdzLmp43
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1F9E1575;
	Thu, 19 Nov 2026 07:25:02 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D21CF3F882;
	Thu, 19 Nov 2026 07:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795101905; bh=20Got6VdPfVmaxBzBWWAavwva4RwxbMx3KZwEJiJ824=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdzLmp43XvH+kJPQchdfhLTMJqirL8CBgjtxwKYi7l/ramVMHn6NSMLJfaly9tzSf
	 Cl+PFRxAZhUPxh4qDNrDQj3x9sth7j4F/chNGBKYyRQxw2RUPNPr/zAf0WheBktyGr
	 lIQb0Mx/kOyw5+gHP/GM1f5rkZPo+lXU42cbDWIA=
Date: Thu, 19 Nov 2026 15:24:59 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: Re: [RFC PATCH v7 00/28] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <av8Uy763VmZPA4RR@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <auy-TwnMbIn-r2xl@gremlin>
 <au29ACRXFEOXaWPV@raptor>
 <avs9oxfRNGiIi8an@gremlin>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avs9oxfRNGiIi8an@gremlin>

Hi Lorenzo,

On Mon, Nov 16, 2026 at 05:51:25PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 06, 2026 at 11:41:52AM +0000, Alexandru Elisei wrote:
> > Hi Lorenzo,
> >
> > On Thu, Nov 05, 2026 at 05:47:45PM +0000, Lorenzo Stoakes (ARM) wrote:
[..]
> > > 3. The entire VM needs to be pre-faulted, but who should do it? - I do
> > >    think that relying on userland to do this is a little iffy. So I wonder
> >
> > There's plenty of iffiness that userspace already handles when it comes to
> > virtual machines.
> 
> Yup, does seem to be a fair bit of implicit assumptions of sanity :)
> 
> >
> > Or, how Oliver put it [1] (regarding migration, but it fits):
> >
> > 'My take is that there's no amount of idiot-proofing we can do in KVM to prevent
> > the VMM from messing this up somehow'.
> 
> Haha, right.
> 
> I guess fine to require userland to set things up like that, and can always add
> an option to have it automatically set up for them in future as a nice-to-have.
> 
> I want to separate out the gmem bit though, replying below:
> 
> >
> > [1] https://lore.kernel.org/kvm/alE3jRLtYeq-WesA@kernel.org/
> >
> > >    whether it might be possible to, on SPE first run, prefault the ranges
> > >    there, and make that a condition of using it? Relatedly, KVM could
> > >    reject non-guest_memfd memslots for an SPE VM rather than trusting
> > >    userspace there too.
> >
> > I'm not sure that's the best idea. Mainly two reasons:
> >
> > 1. KVM will be imposing the condition that *all* writable memslots be backed by
> > guest_memfd, and *all* memory backing these memslots be pre-faulted and
> > effectively pinned.
> 
> I mean this really is a requirement for SPE to work at all, since the guest is

Broadly speaking, yes. The requirement is that when running in a VM, the
buffer shouldn't encounter faults that wouldn't happen when running on
baremetal. This translates into when the guest attempts to write a record
to memory that is valid and writable from the guest's point of view, there
shouldn't be any faults due to that memory not being mapped at stage 2.

The only reasonable way for KVM to achieve this with the current
architecture is to map at stage 2 all the memory that the SPE buffer might
be expected to use.

> effectively deciding which memory is being used for SPE (I think it's perf AUX
> memory right?)

Yes, it's from the AUX buffer, and in the current version of Linux, perf
core hands it over to the SPE driver to program the buffer with.

> 
> I think given that it's guest-designated _and_ the guest has no idea which parts
> of memory are 'SPE safe' and 'SPE unsafe', this is a requirement.

KVM's job, broadly speaking, is to virtualize the architecture. KVM doesn't
get to decide what guest is running, that is all on the host userspace.
Host userspace can run a version of Linux much older than the host, or much
newer. Host userspace can run another operation system (Windows, FreeBSD,
etc), or something that is not a conventional operating system at all (like
kvm-unit-tests). Host userspace is also responsible for configuring the
guest VM, and describing the virtualized hardware to the guest.

Can you guarantee that such a guest, that doesn't know which memory is safe
for SPE, doesn't exist and will never exist?

Because without that guarantee, my point is that userspace is in the best
position to know what a guest can, and cannot do, and I think it's best to
let userspace decide which memslots to pre-fault.

I guess this all sounds theoretical and quite thin. So, an example, though
a rather hand-wavy one: add a new command line parameter in Linux that
works somewhat similar to hugetlb_cma, but for aux buffer allocations, and
use it to describe a slice of guest physical memory which will be used by
the SPE buffer. KVM will be none the wiser about all of this, because it's
the host userspace that decides what operating system to run inside a VM
and how command line parameters are supplied to the guest OS. With this
approach, host userspace can decide to create a separate memslot to
describe this guest memory, use guest_memfd as the memory provider for the
memslot, and pre-fault this memslot only, not the other memslots that
describe system memory.

> 
> >
> > There are use cases for writable memslots to describe guest memory that won't be
> > used by SPE. First thing that comes to mind would be paravirtualized interfaces
> > between host userspace and the guest. For example, pvtime - kvmtool creates a
> > RAM memslot for pvtime (i.e, non-read-only memslot), and it looks to me that
> > qemu does the same (but my knowledge of qemu is severely limited, so I might be
> > completely wrong).
> 
> I don't think any of this is disallowed by the gmem requirement.

It's not, but why should all of the virtual machine managers that have
these paravirtualized interfaces, interfaces that have worked just fine
until now, be required to modify them just so they can enable SPE?

Or have I misunderstood what you are proposing?

> 
> >
> > Then there's also the possibility that a guest might want to assign a slice of
> > RAM for use by SPE, to avoid pre-faulting and pinning the entire VM memory. In
> > this case, userspace will want to have *only* the memslot describing that slice
> > pre-faulted and pinned, and not the rest of system memory.
> 
> As above, there's just no way for userspace to know which bits of memory are SPE
> safe and which are not. So I don't think this works.

As above, I disagree :P.

> 
> >
> > 2. Perfomance - userspace can pre-fault in parallel, KVM cannot easily do that.
> >
> > arm64 now has support for KVM_PRE_FAULT_MEMORY, I say let's use that :)
> 
> :) right.
> 
> OK, so maybe the right path then is to keep the prefaulting with userspace, but
> I really do think we have to have KVM reject a writable non-gmem memslot once
> SPE is enabled for the VM (and reject enabling SPE if one already exists).
> 
> That should be relatively straightforward and avoids at least the most broken
> userland mistakes.

I understand where you're coming from, and I do agree that KVM should do
something if userspace doesn't pre-fault guest memory. But I think we have
different opinions about what exactly KVM should do in this case.

I had a chat with Mark Rutland about patch #26 from this series ("KVM:
arm64: Map memory on a SPE stage 2 fault"), and he suggested something that
I find very appealing, which I think solves this problem: when SPE reports
a stage 2 fault, instead of KVM mapping the memory at stage 2 and trying to
pretend like it never happened, KVM_RUN returns to userspace with an error
describing the fault.

If the stage 2 fault was caused by a bug in KVM, then this lets userspace
know that something is wrong with KVM and SPE might be unreliable.

If the fault was caused by a bug in the virtual machine manager (by not
pre-faulting the memory, or because it punched a hole in the guest_memfd
file, or something else) then userspace will know that something is wrong
with the virtual machine manager.

It might even be on purpose - for example, host userspace wasn't sure that
the guest will use SPE and didn't want to pay the cost of pinning the
memory upfront. Now that the guest has started using SPE, userspace can
pre-fault that memory.

In all cases, userspace will be in the best position to take corrective
measures - resume (and possibly log the error to be investigated later),
kill the VM, or anything else in between.

I really like this idea. Thoughts?

> 
> >
> > >
> > > 4. Dirty page logging - patch 27/28 relies on series [1] being landed,
> > >    which is also an RFC, and allows migration of SPE VMs. So we need to
> > >    decide - do we want this migration? Additionally, I think it's
> > >    reasonable to, if we want it, send both [1] and patch 27/28 as a follow
> > >    up separate from the v1 non-RFC of the series.
> >
> > For background, I started this conversation in the LOG_DIRTY_PAGES support for
> > guest_memfd series [2]. Oliver had some concerns, but he didn't follow up on my
> > explanations, so I decided to send migration support as part of SPE so people
> > can have a more complete picture of how everything fits together.
> >
> > I would be very happy to get basic support for SPE merged in KVM, and, if we
> > decide it's useful, migration implemented as a follow up, as that involves
> > landing dirty page logging support for guest_memfd.
> 
> Ack, thanks, let's treat that as a follow-up then, I think best thing here is
> definitely to focus on getting the fundamental bits in for SPE first.
> 
> >
> > [2] https://lore.kernel.org/kvm/alAFmiAsNf6Xm49_@kernel.org/
> >
> > >
> > > 5. Errata handling - the default already disallows SPE on the affected
> > >    silicon, which seems right. I wonder whether kvm-arm.ignore_spe_errata
> > >    should exist at all though, other than in some sort of debug mode.
> >
> > It is intended as a debug/development option, to be used only when the VMs are
> > trusted. As to why it's there, it's there because without it, SPE would be
> > disabled on all the machines that I have access to, and I suspect systems not
> > affected are few and rare between.
> 
> Ack ok that clarifies that :) let's then clearly mark that as such
> e.g. 'debug/development only, trusted VMs only' in the documentation, and
> tainting the kernel if it's enabled, I think, would be sensible.

Agreed, this needs better documentation :)

Thanks,
Alex
