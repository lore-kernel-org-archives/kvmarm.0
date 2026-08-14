Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5564847044B
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786722996; cv=none; b=P2kDPcIDC3OSXQHVi5XAqDnXVXChQQRs01CxbD/RJaZEZkQZvXCfoMT5pysA4F4VJCxHEakFPhV1cKhlMmkecHSptrHvzH3cdYh5TgTenya6VpxOp/mFPm10Nd6fnORvqGCbwxC431Gf26WFRAMstp3OOHrAnzpp6CyjURuTdoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786722996; c=relaxed/simple;
	bh=pO1uh/eAx9qjSA5hHMp+NLotsULWAPq29vo2yi7PFas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1U5aRdnjx4AI/O2Ayna7N7V55ZS/A2sPWjMIfdEPtSSv9bUF0hEEpABHvb35c376V74/+PbuEdugqeb6+x5al9vkUHNPFUr3FoN8WG1DKYEnCdqAYmYbUcATGLTbhkXgRZqWPegrRxdcuQs0YjEBiB+QPoDVVbieXFGf/m4KG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=h/o/biFI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="h/o/biFI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CFFE1595;
	Fri, 14 Aug 2026 08:56:29 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42E153F66F;
	Fri, 14 Aug 2026 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786722993; bh=pO1uh/eAx9qjSA5hHMp+NLotsULWAPq29vo2yi7PFas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h/o/biFIBD78FA1J2iS8+bWrZRzOkrUBl5UuAYCq2nCvblz/SUPTEgQDLgbtgMlO+
	 m0ZhgWt/nGypSWosGJ0pwf0g0zYhNIE5Ri0pcl32rQjlroW7CZg87N7cCtJSxDli6T
	 vkJasPOPiQAPCiC3nCirdy3uU7k+kbVTYlQ2Y0to=
Date: Fri, 14 Aug 2026 16:56:28 +0100
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
Message-ID: <an86rPn4P2dRO1RB@raptor>
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

Hi Sean,

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

If guest_memfd picks up support for another feature that might lead to
memory being unmapped from stage 2 without userspace initiating it, would
you be ok with that feature being gated by another guest_memfd flag?

I get the feeling we're all on the same page, that guest_memfd will support
a mode where memory isn't unmapped from stage 2, and right now the
discussion is more about how that will be implemented.

Thanks,
Alex

> > 
> > Does that explanation makes sense? I don't know the exact mechanism to do that,
> > but that's just my high-level thinking.
> 
> Yes, I'm supportive of KVM expressing to guest_memfd that page migration isn't
> supported by the VM.  I'm only objecting to expressing that memory must stay
> mapped in S2, because guest_memfd doesn't care *why* page migration is or isn't
> supported/allowed by a particular VM.
