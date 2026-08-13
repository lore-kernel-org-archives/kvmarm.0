Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABFC3515C2
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786637366; cv=none; b=iMgZRqyVil2kq0l6di8ZxsfzjmuL4wYnef+cIVn9iCczCOt9iGf94DI02fNbSJPBcKVFWKI0INfVBvJQGvq1lo09VHPXAWv4OnwWm/WSPF8YwPjzuwwGxVo/ZJrRLXx7+g8E5MwCCuN6GwWWKifSchFjNnKvKRZgjHOnBiHjkis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786637366; c=relaxed/simple;
	bh=w0ELszWBGMJXb0VVRoNWZwzpnHUnbxdOH2FQkHXWfls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJtL5vS8HwO5uftCUZ32YS43+UoyMpmb0jY3qP9H9Ov2IOIAuXdKwnyJ9z8xSx6qn6bzU05X3XFPKBeuONVsRb2HyhjSNuFxKY5KqVsa7oh/rpdDWXlj19K8KypxW0D/iCBlP0CklBcv8yo7wj2ifbmGtB2/uC2iN/hA18kCLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bA34YwnO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bA34YwnO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09FE81596;
	Thu, 13 Aug 2026 09:09:06 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EA383F66F;
	Thu, 13 Aug 2026 09:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786637349; bh=w0ELszWBGMJXb0VVRoNWZwzpnHUnbxdOH2FQkHXWfls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bA34YwnO7if1PuJeP3jbH2rR0JQIu6urfwGn3nVRTyJGyNDO/+M8twCJaRopKkJgo
	 UmebfCbiRP4QBsH/gblc2UolCHVWi1SrF/GHV2Mop5szUFPXkokFcyIKMMoPWcSs9o
	 GV8RQ6Y5T7v6rPb7Def9re3E21GeI7JfIHkps1jg=
Date: Thu, 13 Aug 2026 17:09:05 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: David Hildenbrand <david.hildenbrand@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, fuad.tabba@linux.dev
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
Message-ID: <an3sEiQlIuGEjUur@raptor>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com>
 <ak0wSQ1133O7B96D@raptor>
 <ak0ziUcCXUlDdcla@google.com>
 <ak-EKSslAz1uqEtv@J2N7QTR9R3>
 <ak_wC4Q-mQe14DI8@google.com>
 <alDI1b8fC99SG4_a@J2N7QTR9R3>
 <a127176a-1722-460c-aa84-754e1d343f53@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a127176a-1722-460c-aa84-754e1d343f53@arm.com>

Hi Sean, David,

On Mon, Jul 13, 2026 at 04:11:57PM +0200, David Hildenbrand wrote:
> 
> >> That said, odds are good that we'll end up with per-gmem flags to communicate to
> >> guest_memfd whether or not the gmem instance supports page migration (x86's TDX
> >> and SNP in particular require extra consideration).  So if the anticipated use
> >> cases are fine with all-or-nothing "pinning", or with juggling guest_memfd files
> >> in userspace if a more dynamic setup is desired, then you should be ok?
> >>
> >> E.g. if the anticipated use cases are all slice-of-hardware style setups where
> >> the VM will be statically assigned a chunk of memory, then for the most part this
> >> will all Just Work.
> > 
> > Yeah. I agree (with the caveats you mention). Arm folk need to go figure
> > out if it's worthwhile to support with all those caveats.
> 
> Right, disabling migration (once gmem supports it) was also what I discussed
> with Alexandru when that topic comes up.
> 
> How to communicate to gmem that it wants these fixed mappings is a good question.

There's already a proposal for how to do this in the migratable guest_memfd
series [1] - it's a new guest_memfd creation flag that disables migration.

With Sean's comment that he expects swap/reclaim to be fully userspace
driven, I believe that would be enough to guarantee on the _kernel_ side
that SPE will work as intended for a guest.

I'm a slightly concerned though that all of this will work by chance, and
not by design, and in the future the behaviour might change to allow
guest_memfd memory to be unmapped from stage 2 without the VMM or KVM
explicitly allowing it or initiating it.

My understanding from the conversation so far is that the plan for the
future of guest_memfd is to support an option/mode where the memory is
effectively "pinned" at stage 2 (but which allows userspace to explicitly
free/unmap it, of course). Is that correct, or am I being overly optimistic
in my interpretation?

[1] https://lore.kernel.org/all/20260805-shivank-gmem-migrate-v3-4-00d8bdec4e1d@amd.com/

Thanks,
Alex
