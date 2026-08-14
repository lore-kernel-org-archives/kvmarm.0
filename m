Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92370364043
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724767; cv=none; b=AZoXt30d0vC2yFzlnkmV48JORDoqKMtbmS+iE7bgttuNB7ZPBF6k6G7DfaQxEQRsikkKNfMaUzfeMiqW1JgS6ukUrOiLFJkPP2m+V2qeD6vbpy0qWCZb5tmK5bV+4tPhOIzciWHze/lhUCN6aN0LbwQZuyj88V2iwYyrwMEBBqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724767; c=relaxed/simple;
	bh=MTPBOHQFJvYtb+AHcGvBZoYpVjfEnZJvBa0lWB+9N4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COUSpz7vFmaW/sMyJhPz1Tgcl7eDncm9kApj/SysJTaqYNXeoUy7OmMExKRla0yzSjFyLNmS+VqxdVZvEqmxAQYMzNrlGBFuNO8btdwbf5VhJStMs+F6XPIEng8gAJMRVHj2ulRiXX3uUc8SGcG2j7EaX/qTb4gSoVf0/RDzG/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DWgoTJHq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DWgoTJHq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 175141596;
	Fri, 14 Aug 2026 09:26:01 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC3FF3F632;
	Fri, 14 Aug 2026 09:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786724765; bh=MTPBOHQFJvYtb+AHcGvBZoYpVjfEnZJvBa0lWB+9N4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DWgoTJHqOCjad3GIisdj3ANJUPRHIZpHgG+PT2LH+0PtFsBB96Dx1ZWBk/dLSVIz+
	 lWRVVd6FJRFZeOnqUQYcjh+8S6wGBxgK1yknbk6JSYoFK6km4YAdjMZ7aIaOXQKrjf
	 JFfOrlqAtKTXo1ga4xKDGaXnVaQRHXeH2UegfyMA=
Date: Fri, 14 Aug 2026 17:26:00 +0100
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
Message-ID: <an9BmCMFP2iok-0t@raptor>
References: <ak_wC4Q-mQe14DI8@google.com>
 <alDI1b8fC99SG4_a@J2N7QTR9R3>
 <a127176a-1722-460c-aa84-754e1d343f53@arm.com>
 <an3sEiQlIuGEjUur@raptor>
 <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com>
 <an5UJ4S_P1LUFmzD@google.com>
 <487aa57c-72ad-453b-971d-ca24a8380429@arm.com>
 <an8SOvLybeilzCEU@google.com>
 <an86rPn4P2dRO1RB@raptor>
 <an88nuw0FKT87a-W@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an88nuw0FKT87a-W@google.com>

Hi,

On Fri, Aug 14, 2026 at 09:04:46AM -0700, Sean Christopherson wrote:
> On Fri, Aug 14, 2026, Alexandru Elisei wrote:
> > On Fri, Aug 14, 2026 at 06:03:54AM -0700, Sean Christopherson wrote:
> > > > That would be in contrast to user space having to guess that page migration on
> > > > the current hardware with the current guest_memfd implementation does not
> > > > support page migration, to then disable exactly that.
> > 
> > If guest_memfd picks up support for another feature that might lead to
> > memory being unmapped from stage 2 without userspace initiating it, would
> > you be ok with that feature being gated by another guest_memfd flag?
> 
> Yes, absolutely.  FWIW, if I get my way and reclaim is driven by userspace, then
> hopefully such a feature never comes along.  But if guest_memfd does gain some
> feature that triggers invalidations, then yeah, at the very least it would need
> to have some knowledge of whether or not the associated VM supports said feature.
> 
> > I get the feeling we're all on the same page, that guest_memfd will support
> > a mode where memory isn't unmapped from stage 2, and right now the
> > discussion is more about how that will be implemented.
> 
> Ya.

That's great, thanks for confirming.

Alex
