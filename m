Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8C5471272
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786726716; cv=none; b=kZmD1wBy0BWL4DihvDxFlO+c6EylCJMHhl94bT3yh0MXxnbs497PyqkwVfhZwZ0z6/q79A1NAkGaMEU8GOBC3V+EzcPE22PVkZzdXJGng0/U3mylv6uo4gPsbgw7ZfoKKALoe/BcjrTtPB0Sk7CCFw1pWoghYHQKArX8sFetpv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786726716; c=relaxed/simple;
	bh=uBllJ/kQ24Mxwc6aiM69olWJy5qFzkEa5b9PK//GgIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9xLZa4iXAdHecx/qFINMIHpM6cDJwtXB/DrtvL+0r/DhxxjAYNkYSOXJN1Thxq0NKNpQXZa6frBhVESksEdmPXeX+C8xJEsIrXNZzIn2CLS2pmVxoJIqd3A65s855CLOyXvH4nZicfiD9H0c5CUMpEcinRxfcHkzv8xc6bG07g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mfRdwd/U; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mfRdwd/U"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C0AB1596;
	Fri, 14 Aug 2026 09:58:30 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3EA93F632;
	Fri, 14 Aug 2026 09:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786726713; bh=uBllJ/kQ24Mxwc6aiM69olWJy5qFzkEa5b9PK//GgIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mfRdwd/UvqFh9+V93kh2ouAmmKKGikyurMG1NoN0DOeCELs0Uhk8AGUhZ8KxNZYS5
	 P8r9ARNTgRz8q4re45FPgr+v1iwq0wgBSqd1Wi+k5lIvZTCK5zHP8PtUxwtizBw+1S
	 V27T4NZ2Qbw72uJNefKwKwVh4c4R+JX1dX/9Sl4E=
Date: Fri, 14 Aug 2026 17:58:29 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david.hildenbrand@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, fuad.tabba@linux.dev
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
Message-ID: <an9JNUln8dKaidQc@raptor>
References: <ak0ziUcCXUlDdcla@google.com>
 <ak-EKSslAz1uqEtv@J2N7QTR9R3>
 <ak_wC4Q-mQe14DI8@google.com>
 <alDI1b8fC99SG4_a@J2N7QTR9R3>
 <a127176a-1722-460c-aa84-754e1d343f53@arm.com>
 <an3sEiQlIuGEjUur@raptor>
 <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com>
 <an5UJ4S_P1LUFmzD@google.com>
 <487aa57c-72ad-453b-971d-ca24a8380429@arm.com>
 <an8SOvLybeilzCEU@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an8SOvLybeilzCEU@google.com>

Hi,

On Fri, Aug 14, 2026 at 06:03:54AM -0700, Sean Christopherson wrote:
> On Fri, Aug 14, 2026, David Hildenbrand wrote:
> > We have a hardware feature that requires pages to always be mapped into S2. Some
> > things I had in mind:
> > 
> > 1) Page migration would not be a problem as long as hardware could be paused
> >    while migrating (e.g., kick all vCPUs). I doubt someone would implement that
> >    right now,  but you could consider it an implementation detail that page
> >    migration cannot be supported right now.
> > 
> > 2) Newer hardware could mitigate this problem, allowing the feature to support
> >    pages temporarily being unmapped from S2.
> > 
> > 3) Disallowing page migration is really just one implication of "pages must
> >    always be mapped into S2".
> > 
> > So what we really want is "if feature X is enabled and hardware requires it,
> > always keep pages mapped into S2, which currently implies that page migration
> > cannot be supported."
> > 
> > Which isn't all that different to "if a confidential VM is run on current TDX
> > hardware, always keep pages mapped into S2, which currently implies that page
> > migration cannot be supported."
> > 
> > So I was wondering whether the flow could be:
> > 
> > User space enabled CPU feature for VM -> KVM knows that current hardware
> > requires for that CPU feature to have S2 always mapped -> KVM tells guest_memfd
> > that S2 must be always mapped / disables page migration.
> 
> I'm a-ok with adding a flag to guest_memfd to communicate whether or not page
> migration is allowed, because guest_memfd needs to actively support page migration.
> 
> I'm not ok adding a flag telling guest_memfd that memory must always be mapped
> in S2, because guest_memfd doesn't care.  E.g. KVM doesn't yet support page
> migration for SNP, but SNP tracks page ownership in an out-of-band table and so
> KVM can map/unmap all guest memory from S2 at will.
> 
> > That would be in contrast to user space having to guess that page migration on
> > the current hardware with the current guest_memfd implementation does not
> > support page migration, to then disable exactly that.
> > 
> > Does that explanation makes sense? I don't know the exact mechanism to do that,
> > but that's just my high-level thinking.
> 
> Yes, I'm supportive of KVM expressing to guest_memfd that page migration isn't
> supported by the VM.  I'm only objecting to expressing that memory must stay
> mapped in S2, because guest_memfd doesn't care *why* page migration is or isn't
> supported/allowed by a particular VM.

My naive contribution is this idea I had:

1. Userspace queries support in KVM for feature xyz by checking the
capability KVM_CAP_xyz.

2. Userspace knows that for feature xyz to work correctly, it is required
that memory remains mapped at stage 2.

3. Userspace creates a guest_memfd instance with the right combination of
flags set and _unset_ for feature xyz to work correctly - i.e, to keep
memory mapped at stage 2.

For this to work, new guest_memfd features that might lead to memory being
unmapped are enabled via a flag, and KVM keeps memory mapped at stage 2 by
default, to maintain compatibility with an userspace not updated for the
new features/flags.

Thanks,
Alex
