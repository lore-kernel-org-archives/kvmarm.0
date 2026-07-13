Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCAE4307B3
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783950500; cv=none; b=CgWoO8MxOdOAwbUTOmlh9AQWR1bgUhfdOuoXp4aa+BchGgJjyNNqb6sd7gmyk1u6kJxT8JPio2295je42NRFF68hybSgc7NMjycPme6GaBapG3mWSVxnOadFoB4aKUNsP2hjDSGvueWo2YkPabvKL1O0uppourPwLVrgniquxho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783950500; c=relaxed/simple;
	bh=oI5GkQsfcCtwPh9dQyuxWwDcPHEtAnm1bwD/GTAQD+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UnpBcMwhgDkADkpMrWRdlFzhCi5ATWHoifzzdaGlNHUPwH57K1WFGukO/jYFIP5LleYvotvD1YOiKNOuuAiJ3Qw2/dxwrA0xbXvF0YOjUo/pv40nQdHOs/0n+JkBlIfz/OKRHsbM47AH0EbNoHvyFYQYJrbjTqTKkT+vUZ/pcOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O/7C8yII; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O/7C8yII"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E63F1576;
	Mon, 13 Jul 2026 06:48:13 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D4B73F7B4;
	Mon, 13 Jul 2026 06:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783950497; bh=oI5GkQsfcCtwPh9dQyuxWwDcPHEtAnm1bwD/GTAQD+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O/7C8yIIf5DL/m7ocg3VC8A/gCcqLF3YHaGiHcFwc5yCjyaUSqLKFsNcgjhDIsTZn
	 tmxgLvzMcQhp/kmW0r2ccly3QrJYSAlziAaYMdG+iAUvGTbTIj1c9flpFIF3u2bgM5
	 iguWoSVEfs3wCkFtuGOK14U9iAABMEDXwb9Ic80c=
Date: Mon, 13 Jul 2026 14:48:12 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, david.hildenbrand@arm.com, maz@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, fuad.tabba@linux.dev, mark.rutland@arm.com
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
Message-ID: <alTsnNdpsTY0sKdq@raptor>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com>
 <ak0wSQ1133O7B96D@raptor>
 <alAFmiAsNf6Xm49_@kernel.org>
 <alDM_yikef16lC5h@raptor>
 <alE3jRLtYeq-WesA@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alE3jRLtYeq-WesA@kernel.org>

Hi Oliver,

On Fri, Jul 10, 2026 at 11:18:53AM -0700, Oliver Upton wrote:
> On Fri, Jul 10, 2026 at 11:44:15AM +0100, Alexandru Elisei wrote:
> > Hi Oliver,
> > 
> > On Thu, Jul 09, 2026 at 01:33:30PM -0700, Oliver Upton wrote:
> > > On Tue, Jul 07, 2026 at 05:58:49PM +0100, Alexandru Elisei wrote:
> > > > Hi Sean,
> > > > 
> > > > On Mon, Jul 06, 2026 at 05:56:12PM -0700, Sean Christopherson wrote:
> > > > > On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> > > > > > The memory represented by guest_memfd-only memslots
> > > > > > (kvm_memslot_is_gmem_only() is true) is shared with userspace, which can
> > > > > > freely mmap it and access it. The only thing that is preventing dirty page
> > > > > > logging for such memslots is that KVM doesn't allow slots backed by
> > > > > > guest_memfd to have their flags changed; they can only be created and
> > > > > > deleted.
> > > > > 
> > > > > Please (publicly) document *why*  you want to add dirty-logging support.  It's
> > > > > all but impossible to review new uAPI without knowing the use case.
> > > > 
> > > > Of course, my mistake, I was so deep in this that I didn't realise that
> > > > there might be different perspectives.
> > > > 
> > > > My thinking was that since guest_memfd created with GUEST_MEMFD_FLAG_MMAP +
> > > > GUEST_MEMFD_FLAG_INIT_SHARED is extremely similar from a userspace point of
> > > > view to using an anonymous file (created with memfd_create()), that
> > > > supporting dirty page logging and migration would be a natural next step
> > > > and would expand the usefulness of guest_memfd. It has nothing to do with
> > > > confidential compute.
> > > > 
> > > > As to why I'm working on it now, it's because of an arm64 feature that
> > > > requires that memory remains mapped at stage 2, called Statistical
> > > > Profiling Extension (SPE), similar to Intel's PEBS or AMD's IBS. Exposing
> > > > the feature to a guest requires that memory remains mapped at stage 2
> > > > outside of userspace explicitely unmapping it, and guest_memfd, with the
> > > > patch to ignore the MMU notifiers [1], has this property.  I wanted to
> > > > expand the functionality of guest_memfd to support migration of virtual
> > > > machines when that arm64 feature is exposed to guests.
> > > 
> > > Can you please expand a bit on how you actually expect dirty tracking to
> > > work with SPE? Taking write permission faults seem to be at odds with
> > > "thou shalt not fault".
> > 
> > For the initial posting on the mailing list, my approach was to keep things
> > as simple as possible: allow memory to be made read-only and then have the
> > host map the memory as writable at stage 2 when SPE reports a permission
> > fault, if the buffer happens to be enabled while dirty page logging is also
> > enabled. Of course, that means that the quality of the profiling data might
> > be degraded. I was planning to point this out, to start a discussion about
> > it, but we can talk about it now.
> 
> Understanding how this is going to fit together end-to-end seems
> relevant since you're asking for UAPI guarantees to enable SPE.

Of course. I think it's very useful that we're having this conversation
now, instead of when the patches hit the list, I think I didn't manage to
convey that properly in my reply.

> 
> I agree that degrading the profile isn't that big of a deal but the buffer
> may not even be in a restartable state after taking a fault. Who (KVM /
> VMM) is going to handle rewinding PMBPTR in the case of an incomplete
> record? Blaming userspace is always a good start but at the same time the
> more rules/gotchas there are around the feature the less likely it seems a
> VMM will pick this up.

I totally forgot that SPE might write a partial record following a buffer
management event :/

I don't think KVM should implement a buffer unwinder, and I do agree that
expecting userspace to do it would further reduce the appeal of supporting
SPE in its current form.

> 
> Assuring that there are no KVM-initiated invalidations for guest_memfd
> doesn't seem unreasonable but we need to have an aligned view on how SPE
> will actually be enabled in KVM + VMM first.

This is how I see SPE being implemented:

* The VMM sets the interrupt number and SPE instance when it enables SPE
for a VCPU. Setting the SPE instance is mandatory, similar to the strict
PMU mode that is being proposed; SPE won't have a non-strict mode.

KVM will enforce this.

* The VMM creates the memslots that represent memory for the buffer
using guest_memfd created with GUEST_MEMFD_FLAG_MMAP. Create it with
GUEST_MEMFD_FLAG_INIT_SHARED and it looks a lot like an anonymous file, so
I assume that it doesn't require too many changes in the VMM.  guest_memfd,
with this patch [1], guarantees that memory won't be unmapped unexpectedly
from stage 2.

This will be documented API by KVM; KVM will not enforce it.

* The VMM should pre-map memory at stage 2 before the VM is first run. To
do this, it will use KVM_PRE_FAULT_MEMORY [2].

Same as the guest_memfd part, documented, but not enforced by KVM.

* When it comes to migration, the first step is to allow guest_memfd-backed
memslots to have dirty page logging enabled when the guest_memfd file has
been created with GUEST_MEMFD_FLAG_MMAP; this is what the series is trying
to achieve.

As for the internal KVM bits, it's mostly context switching the registers
and injecting the SPE maintenance interrupt.

[1] https://lore.kernel.org/kvmarm/20260625130902.258331-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/kvmarm/20260612162354.73378-1-jackabt.amazon@gmail.com/

> 
> > Another approach that builds on that, which I have prototyped locally, is
> > to have a VCPU exit to userspace when/if the buffer is enabled and there is
> > at least one memslot with dirty page logging enabled (with a specific
> > hardware_exit_reason) and then let userspace decide what to do: resume the
> > VCPU and live with the blackout window, or keep the VCPU stopped, and the
> > guest gets non-degraded profiling data as the expense of the VCPU making
> > progress.
> 
> My take is that there's no amount of idiot-proofing we can do in KVM to
> prevent the VMM from messing this up somehow. We can just document the
> limitations and let userspace decide to quiesce when dirty logging is
> enabled.

Considering that living with SPE permission faults while migration is
taking place is not possible without userspace implementing a buffer
unwinder, how do you feel about having the VCPUs return to userspace from
KVM_RUN? Do you think that's an acceptable approach and something that
might make migration at least functional?

I'm really not expecting SPE virtualisation to start being widely used, at
least not in the current state of the architecture (requesting that the
entire VM memory is pre-mapped kills most of the use cases), what I'm
hoping for is that SPE will be useful in some limited scenarios, and for
development.

Another option would be to make migration incompatible with SPE, which
means dropping the changes to guest_memfd proposed by this series.

> 
> > My hope is that if migration is fast enough, the VCPU not running
> > for (possibly) the entire duration of the migration process won't be
> > noticeable, but I might be naive in thinking that.
> 
> Err, for a live upgrade of the VMM or kernel, sure. But an actual copyful
> migration going over network could be O(minutes).

0 minutes sounds like a good thing, or am I misunderstanding something?

Thanks,
Alex

> 
> > According to the Neoverse v3 errata document (MP168), r0p0 is affected,
> > r0p1 is not affected. A quick google search revealed that Microsoft's
> > Cobalt 200 CPU is based on Neoverse v3, same for the Arm AGI CPU. Wikipedia
> > also says that Graviton 5 is based on Neoverse v3. Don't know the exact
> > revision though, for either of them.
> > 
> > I was planning to add a kernel parameter that permits SPE on the affected
> > parts, so people who trust their guests* can still use it from a VM. I
> > don't think migration would be possible in this case because SPE bypasses
> > the read-only permission at stage 2, and the host would not know to mark
> > that memory as dirty (for dirty page logging).
> > 
> > * Ignoring migration, guest_memfd is always mapped as writable at stage 2,
> > so a guest would have to point the buffer at memory that KVM represents
> > with a KVM_MEM_READONLY memslot, like the CFI flash device used by EDK2.
> > 
> > > 
> > > Fixing rotten architecture would be a more appropriate starting point :-/
> > 
> > I like to think that the architecture is constantly improving :)
> 
> I'd like to think that too...
> 
> Best,
> Oliver
