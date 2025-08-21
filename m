Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131CE2EBDC4
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 22:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815991; cv=none; b=u1V/Ox0iBeQ2m7wShHfaDIZyAs3bSYT27yKG/IfGcPagFBTsqLvhVjDREL8MQt023biZx9Y0E+NkuA3Zdc8rnhnXiF6E1PTl6X8gGay+S8e2jhfVtA+QBorBpWrcGU1Q3vH6OlrQuPbPGYdngQ3UT/vQWlGf394g34C7yPCBnhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815991; c=relaxed/simple;
	bh=Be3ClH60P/H1hZLxj5XwyRV0BIbXHp/VxgZ0pSuY03k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B6BvwbDp/Heu+CgYXASKIGeO3+KFqZZvck+CAN1Y51O0kqCIrYmEbmxV63R+xXUd0hXp5FM3rSuJrd7iBR2irqaI4AZRSyZKRsYotuc64uBfVt9z0mheqBIlugxlToZ/Yer0nBqf2TmEthTPTb/rZQQs1qAwM/9Mq/d78AolxTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uf+yKkk0; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uf+yKkk0"
Date: Thu, 21 Aug 2025 15:39:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755815986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D8XicYgOjiTvvGGkoe6RWU7q2u/gG9EiLOqy/Vb5XKI=;
	b=uf+yKkk0lkGd+LdPilwoJoT6fqhHqMP/fkewlLpiiG2lFzUdETqfLTLzi2b+NE41mz1azY
	7Vuef5ZskjXR4AsBJPQaepxaFMN53Pg1JtVAdE28ie1oEpQbgm/e3lDIf6yP1arsITF6y6
	831T4jz9a7i4vLtWE2OkvPeS6koNX2Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	James Houghton <jthoughton@google.com>
Subject: Re: [RFC PATCH 00/16] KVM: arm64: Add "struct kvm_page_fault"
Message-ID: <aKegF0XyrDF1Z5w4@linux.dev>
References: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 21, 2025 at 02:00:26PM -0700, Sean Christopherson wrote:
> Add an arm64 version of "struct kvm_page_fault" to (hopefully) tidy up
> the abort path, and to pave the way for things like KVM Userfault[*] that
> want to consume kvm_page_fault in arch-neutral code.
> 
> This is essentially one giant nop of code shuffling.
> 
> RFC as this is only compile-tested.  I didn't want to spend time testing
> until I got feedback on whether or not y'all are amenable to the general idea.

I appreciate the improved scoping around things like mmap lock, so this
seems like a net-win in terms of readability. Just want to clarify the
way this gets consumed from arch-neutral code and actually read in
detail.

Thanks,
Oliver
