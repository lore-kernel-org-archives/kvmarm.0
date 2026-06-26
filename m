Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED6C3590C3
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782495342; cv=none; b=LchH2pY9TmK4a+Hhf5utXETuK8II9qOAI+gWD9ISz8kMdlfzkUCu59RulHAy9x8/uSJUkpHtGjMr8XKnt4Wc0s/fn+0YU/obYcm1qMOegvEbsydbyUE9zC+yxCHrqRgVGV/cmDaKBS6H9vleIzdfFXnHMQ/tfPWUEFKs2jXqR5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782495342; c=relaxed/simple;
	bh=Yn7Vok+U6O7xwyDE0u+0ptXdTK11cXJnX5dsDn2+4P8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CjRX0ca27rNO39ni04sA1vK1IE/R6RK3T+39nVof1orMvoNwHHIl7lcGP7098L8rr1RM1wBywIvpbq8madeW7K5vpCCaOEhMTXAVPYpC4GXCNxVlD8EHTif0w+A3VgthqfDedVoDUrr4SoXu5rXuPt+xBH304i95TzLmZxjef0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTIp9/H2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTIp9/H2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415551F000E9;
	Fri, 26 Jun 2026 17:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782495341;
	bh=qQrybMvC0tbnbb4oDDO0xN+0Uu1k06cgnDZWPa27Q88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bTIp9/H2uiALt2x27+4iuv/1cFroW1RlQcxxBJWiFPkd6J1hGpixXjLP2/MLcgDrE
	 3VdFJO7szMvp5JAIb3dJiHKuTMuZvmYE+n83P8t2raV3HJC7N2uO5rUItKflBPaIPu
	 ZhtTA27VYKDmUp0d+kw5eRP7sQho0c00HjDqb+8OqQXKVoRGTK+zgE48lEW6LJ9wik
	 Xg90cpjX7FEFw5XHguQnYlFMDdX9G4TLwQ4WB6/4z9VgwF3wveEceveH4odMH+0lNG
	 NbOWZ8iCazIOWJ3VJ5J3eOGy8Vo2xfL1Si7k1dm/d41b0/zmXLdgYz6RxNgogbM3gK
	 JXpmtkDbvVVjA==
Date: Fri, 26 Jun 2026 10:35:40 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 13/22] KVM: arm64: Set dirty state at stage-1
Message-ID: <aj64bOopE9WJoWBX@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-14-oupton@kernel.org>
 <aj6fj8fEonBQphZM@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj6fj8fEonBQphZM@LeoBrasDK>

On Fri, Jun 26, 2026 at 04:49:36PM +0100, Leonardo Bras wrote:
> On Tue, Jun 23, 2026 at 11:41:52AM -0700, Oliver Upton wrote:
> > Mark the descriptor as dirty if the permissions are sufficient to grant
> > write access. Note that compute_s1_direct_permissions() already
> > considers the DBM bit as writable.
> 
> IIUC the idea here is to avoid having a write fault when we first write to 
> that page. Is that correct?
> 
> When we have HAFDBS the fault does not happen, and it gets marked from 
> writeable-clean -> writeable-dirty by HAFDBS mechanism, which is cheap as 
> it happens to be a write to the pgtable when memory is first written to.
> 
> On the other hand, when we clean the dirty-bits for the first time, we 
> have to issue a write for every page that have been dirtied, in sequence.
> 
> An alternative would be not marking every page as dirty at first, in 
> exchange of possibly having a faster first clean pass.
> What do you think about it?

As Marc mentioned on the cover letter, this is unrelated to host dirty
tracking. I'm implementing HAFDBS as part of our pseudo-TLB refill for
nested. We need to mark translations as dirty in the nested S2 before
filling the shadow S2 with something that allows writes.

Thanks,
Oliver
