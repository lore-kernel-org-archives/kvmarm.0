Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF9C40D588
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 10:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783680263; cv=none; b=M2ZorIz7/vOMvQCWU8gL7CR+65NU4KlQ11aqnsIQcdx0Bci7eRKqNIRKbz/gom13oV2ZQNQkEl9Buz/TLmTAbVUblbaWFikm9PYpJ9GAGWvExzNRpQGXOziYUA5wVIlR5oFiOyqUZ8vCFJ+YHsaq5cvQvOAsx7IAz1VLwHqbczg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783680263; c=relaxed/simple;
	bh=8Cx8untwN/qp2iJnkWjwQ3VQrhGq5Urk0jCglcMue34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LgUOhZ40EHURT4iADNyz7fnWLtmmm30JpDSv4iiFe1d2KiH0x4Tto8nFRYwtyml/bKWiSKnRkzKg0xGWZ2jle2gelbGVUT3J0n8kaVnU3Dj45NbxNpwFYg/cqXU/V8DmioiGcfOmlQAgO3ggrjNo4REc9Nej/KbG2N2u6tDAF4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mLfdPwvS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mLfdPwvS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87C091E7D;
	Fri, 10 Jul 2026 03:44:15 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 058183F66F;
	Fri, 10 Jul 2026 03:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783680259; bh=8Cx8untwN/qp2iJnkWjwQ3VQrhGq5Urk0jCglcMue34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLfdPwvSDhrSyU6GwZeSZO+Uv39kY/Tl12drVJXc/D2jqFNEh4KsnIUA0qMfJdEmN
	 PNSH1a2j7hfgZw2vAVz2270PtcdqX/Dqa3TCMqCn+5IS9DgMDq/o24Bq7RLnCLA8OH
	 o+IXMHjWNLdLKE0zoclOvkQBt/GXPCvmdPSjBBUM=
Date: Fri, 10 Jul 2026 11:44:15 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, david.hildenbrand@arm.com, maz@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, fuad.tabba@linux.dev, mark.rutland@arm.com
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
Message-ID: <alDM_yikef16lC5h@raptor>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com>
 <ak0wSQ1133O7B96D@raptor>
 <alAFmiAsNf6Xm49_@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alAFmiAsNf6Xm49_@kernel.org>

Hi Oliver,

On Thu, Jul 09, 2026 at 01:33:30PM -0700, Oliver Upton wrote:
> On Tue, Jul 07, 2026 at 05:58:49PM +0100, Alexandru Elisei wrote:
> > Hi Sean,
> > 
> > On Mon, Jul 06, 2026 at 05:56:12PM -0700, Sean Christopherson wrote:
> > > On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> > > > The memory represented by guest_memfd-only memslots
> > > > (kvm_memslot_is_gmem_only() is true) is shared with userspace, which can
> > > > freely mmap it and access it. The only thing that is preventing dirty page
> > > > logging for such memslots is that KVM doesn't allow slots backed by
> > > > guest_memfd to have their flags changed; they can only be created and
> > > > deleted.
> > > 
> > > Please (publicly) document *why*  you want to add dirty-logging support.  It's
> > > all but impossible to review new uAPI without knowing the use case.
> > 
> > Of course, my mistake, I was so deep in this that I didn't realise that
> > there might be different perspectives.
> > 
> > My thinking was that since guest_memfd created with GUEST_MEMFD_FLAG_MMAP +
> > GUEST_MEMFD_FLAG_INIT_SHARED is extremely similar from a userspace point of
> > view to using an anonymous file (created with memfd_create()), that
> > supporting dirty page logging and migration would be a natural next step
> > and would expand the usefulness of guest_memfd. It has nothing to do with
> > confidential compute.
> > 
> > As to why I'm working on it now, it's because of an arm64 feature that
> > requires that memory remains mapped at stage 2, called Statistical
> > Profiling Extension (SPE), similar to Intel's PEBS or AMD's IBS. Exposing
> > the feature to a guest requires that memory remains mapped at stage 2
> > outside of userspace explicitely unmapping it, and guest_memfd, with the
> > patch to ignore the MMU notifiers [1], has this property.  I wanted to
> > expand the functionality of guest_memfd to support migration of virtual
> > machines when that arm64 feature is exposed to guests.
> 
> Can you please expand a bit on how you actually expect dirty tracking to
> work with SPE? Taking write permission faults seem to be at odds with
> "thou shalt not fault".

For the initial posting on the mailing list, my approach was to keep things
as simple as possible: allow memory to be made read-only and then have the
host map the memory as writable at stage 2 when SPE reports a permission
fault, if the buffer happens to be enabled while dirty page logging is also
enabled. Of course, that means that the quality of the profiling data might
be degraded. I was planning to point this out, to start a discussion about
it, but we can talk about it now.

Another approach that builds on that, which I have prototyped locally, is
to have a VCPU exit to userspace when/if the buffer is enabled and there is
at least one memslot with dirty page logging enabled (with a specific
hardware_exit_reason) and then let userspace decide what to do: resume the
VCPU and live with the blackout window, or keep the VCPU stopped, and the
guest gets non-degraded profiling data as the expense of the VCPU making
progress. My hope is that if migration is fast enough, the VCPU not running
for (possibly) the entire duration of the migration process won't be
noticeable, but I might be naive in thinking that.

> 
> Seems to me like you'd need hardware dirty state and the "noabort"
> flavor of BBML2 to actually get things down to page mappings. Oh, and an
> SPE implementation that actually respects write permissions... Is there
> even an implementation out there where the stars align?

According to the Neoverse v3 errata document (MP168), r0p0 is affected,
r0p1 is not affected. A quick google search revealed that Microsoft's
Cobalt 200 CPU is based on Neoverse v3, same for the Arm AGI CPU. Wikipedia
also says that Graviton 5 is based on Neoverse v3. Don't know the exact
revision though, for either of them.

I was planning to add a kernel parameter that permits SPE on the affected
parts, so people who trust their guests* can still use it from a VM. I
don't think migration would be possible in this case because SPE bypasses
the read-only permission at stage 2, and the host would not know to mark
that memory as dirty (for dirty page logging).

* Ignoring migration, guest_memfd is always mapped as writable at stage 2,
so a guest would have to point the buffer at memory that KVM represents
with a KVM_MEM_READONLY memslot, like the CFI flash device used by EDK2.

> 
> Fixing rotten architecture would be a more appropriate starting point :-/

I like to think that the architecture is constantly improving :)

Thanks,
Alex
