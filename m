Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7AD41684A
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 09:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786527776; cv=none; b=Lm48YrKkyFmKRGcrd0WT1iTcgHYNezTHvZ6dX/t6Et4tx9K60WnXc6K9Ng9XQU5vgxKfyjmWrp9nPJcCfscTEEjZBQZBgiPvo4KYc+8QqdRoLcFgHZCUOguV8EkDFZPCVdAOaxcuWdapYqh29NI/IbhQFEGKA0u4hkyW5ZVsAjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786527776; c=relaxed/simple;
	bh=TWIx30sQ2XIiCJN5oInxN1eYSUaNHzZF/7kx70htilc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MI/6T+VxFxfOY7cEb15lbqf5x9gOmpasmNHc4YMZsGkWJiX2I6dga55EaPKnUFwdTZT3D/Hj/6UWicit9bv7Rz3WgkaaTpr6hykktPZ1ZCnQGn7ySBmNAcPQ5KwYrNMg9CssDKquCFxHcKg5Dtvq+ki1RlvCnjckY24eukwvhM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V8rQHImN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V8rQHImN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F69F1596;
	Wed, 12 Aug 2026 02:42:50 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B74A03F632;
	Wed, 12 Aug 2026 02:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786527774; bh=TWIx30sQ2XIiCJN5oInxN1eYSUaNHzZF/7kx70htilc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V8rQHImNyNAzejdLBSghKJJtyP98JyGNFZAaclJgQJX4RU6fdfS2KryNs33viqr2F
	 XQje0saWr6PrHVv39YXDAKLHVPXX4bNANey2IJxbw0sXCRaSm+y1tzJjYEtIzKyjYo
	 XQxiGkhteJciKjIwzdtfB12Wmc1C3H00f2wNuhLI=
Date: Wed, 12 Aug 2026 10:42:50 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	david.hildenbrand@arm.com, mark.rutland@arm.com,
	ackerleytng@google.com
Subject: Re: [PATCH v2] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <anxAGkdyPYXBlS00@raptor>
References: <20260714160411.302386-1-alexandru.elisei@arm.com>
 <amPCdAswlk24Xilf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amPCdAswlk24Xilf@google.com>

Hi Sean,

(Sorry for the silence, was on holiday)

On Fri, Jul 24, 2026 at 12:52:20PM -0700, Sean Christopherson wrote:
> On Tue, Jul 14, 2026, Alexandru Elisei wrote:
> > +	 * TODO: Skip gmem-only memslots on mmu_notifier events entirely, once
> > +	 * gfn_to_pfn_cache is also wired up to directly pull from guest_memfd.
> 
> So it turns out we need to solve a very related problem[*], thanks to commit
> b9220d32799a ("KVM: x86/xen: allow shared_info to be mapped by fixed HVA"),
> which as it says, allows populating gfn_to_pfn_cache directly with an HVA, i.e.
> without a memslot.
> 
> My not-yet-tested solution for that mess is to give gfn_to_pfn_cache its own
> invalidation sequence, at which point there shouldn't be a need to process
> gmem-only memslots just for gfn_to_pfn_cache, because it will already be equipped
> to handle memslot-less invalidation.
> 
> Given how simple this change *should* be, I'm going to put this patch on the
> backburner for now, and then assuming my proposed change actually works, I'll
> grab your original change (or more likely, re-post it as the last patch in the
> series weans gfn_to_pfn_cache off mmu_invalidate_seq).

By "original change" I assume you mean the RFC patch [1], where I skip the
memslot entirely in handle_hva_range(), which would make sense since the
problem you are solving involves cache entries without a memslot.

[1] https://lore.kernel.org/kvm/20260615155244.183044-1-alexandru.elisei@arm.com/

> 
> It'll probably take me a few weeks to circle back to this, as I finally crawled
> out from underneath a pile of urgent and am just now getting back into review
> mode, but this is fairly high on my todo list, so with luck we might still squeeze
> this into 7.3.

Sounds great to me, thank you for your time and patience!

Alex

> 
> [*] https://lore.kernel.org/all/aj2hi-NcqUUCaoQF@google.com
