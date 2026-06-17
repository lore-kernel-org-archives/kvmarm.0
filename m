Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140B3395AEC
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704209; cv=none; b=iEMjIzX1MFW3/Y9UrzgmNK0z/jabjqQzmHjlBIoYKZiSK4XXq+3fgdN+lN7mGYYHLu7Lp7tvWDYcbjutgFgUr+1Jd8wZIPfTJYP3m45mZA/nDyjUqg0WPsah9O4WaZC0WhvHX4zT//TS8wIJHOGM53YOrxULHA+ndzjdbTZVogU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704209; c=relaxed/simple;
	bh=jOeGVluIMYFU5wOg6PZwoo9TatEfuCmwJ4EkBdADezg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUboP9Dmvpezq6eMXenf43pBAs0pvYROQHkNEvCx8XH+HaCgGqcGFEjTw2AfLgilID27TknKmcTzoR1IKjYcwjlm0Uww7+rmF08RWBMOgesoA7r8Uhfgvl4YSXchWx4w1UEYovDg97bTU6BqFs/FE3uNAb7PRwnz9C0y5g9ScR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Uq5uWtm9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Uq5uWtm9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95685483F;
	Wed, 17 Jun 2026 06:50:02 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 886A43F915;
	Wed, 17 Jun 2026 06:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781704207; bh=jOeGVluIMYFU5wOg6PZwoo9TatEfuCmwJ4EkBdADezg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uq5uWtm9iOp/iSpOhftP1Nnq7YyxsViDYfnDSj35KuhUX6KMNKGGfJPkymSFHB2qZ
	 AvXTZ2KqoHG6TyXD2i3l4lYrVhRQlYU/ljGcc+o/sUY8mx6BqdMH+jc/keHMJZSFiq
	 Nvrji5blS1Eisk9dC+/YKSJyQf8FZur0DSOtO8y0=
Date: Wed, 17 Jun 2026 14:50:03 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: David Hildenbrand <david.hildenbrand@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	seanjc@google.com, mark.rutland@arm.com
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <ajKmC3d07a6xdOiB@raptor>
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <42323088-c06e-42e2-b095-136062a8d27c@arm.com>
 <ajKf41Fgy_jKBAMI@raptor>
 <3b1cda8e-96d2-4b66-9916-caef7762209e@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b1cda8e-96d2-4b66-9916-caef7762209e@arm.com>

Hi David,

On Wed, Jun 17, 2026 at 03:41:41PM +0200, David Hildenbrand wrote:
> On 6/17/26 15:23, Alexandru Elisei wrote:
> > Hi David,
> > 
> > On Mon, Jun 15, 2026 at 09:07:50PM +0200, David Hildenbrand wrote:
> >> On 6/15/26 17:52, Alexandru Elisei wrote:
> >>> For guest_memfd-only memslots (kvm_memslot_is_gmem_only() is true), the
> >>> memory provider for the virtual machine is the guest_memfd file, not the
> >>> userspace mapping. Faults are resolved using the guest_memfd page cache,
> >>> and the permissions for the secondary MMU mapping depends exclusively on
> >>> the memslot (i.e, if the memslot is read-only). How userspace happens to
> >>> have the memory mmaped at fault time, or even if the memory is mapped at
> >>> all into userspace, is not taken into consideration.
> >>>
> >>> guest_memfd memory is not evictable, is not movable and there's no backing
> >>> storage. Once memory is allocated for an offset in guest_memfd file, the
> >>> offset will not change, and that memory is not freed unless userspace
> >>> explicitly punches a hole in the file. As a result, memory reclaim, page
> >>> migration, page aging and dirty page tracking for the userspace mapping
> >>> serve little purpose.
> >>
> >> I don't think any of that is relevant for the patch at hand?
> >>
> >> The thing is: invalidation (truncation, later migration, for any other reason)
> >> is driven through guest_memfd notifications, not through unrelated page tables.
> >>
> >> If we don't lookup pages for the KVM MMU through the page table, then there is
> >> also no need for MMU notifiers. It's all guest_memfd only.
> >>
> >> Or am I missing something?
> > 
> > My thinking was that, because guest_memfd is not evictable, there is no need to
> > do page ageing, which would require that secondary MMU mappings be made old.
> 
> Not really.
> 
> The KVM MMU did not obtain the folios through the page tables, but directly
> through guest_memfd. Any aging would, therefore, have to be done through
> guest_memfd.
> 
> Which we don't support and don't want to support :)
> 
> That we happen to have a matching user space range that maps the guest_memfd is
> just coincidence from a KVM MMU point of view.
> 
> > 
> > The invalidate callbacks are also used when userspace memory is marked read-only
> > for dirty state tracking. I was trying to explaing that, since there is no
> > backing for the guest_memfd file, host doesn't need to keep track of dirty state
> > for the memory, and ignoring the invalidate callbacks is correct for all cases.
> > 
> > I can drop the paragraph entirely, if you think that would make the commit
> > message clearer.
> 
> I think the real motivation is:
> 
> "Mappings in the secondary MMU were established by obtaining folios from
> guest_memfd directly, not by looking the folios up through the page tables
> through GUP. Consequently, there is no relationship between the page tables and
> the secondary MMU: MMU notifiers do not apply."

That's much better than my version, thanks!

Alex
