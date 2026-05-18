Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8093E16AD;
	Mon, 18 May 2026 08:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779094343; cv=none; b=Lq85pMFexOqwd0S5uko1PcWtbQ2YyCz+SMpgjnIcA3G5pjW0Uci8GZtAYW2S4N8CGpvs7sIrgW0GAzortQG0uT8NJnkkoviIV4jOW4uDm5cpgWxpB17FlcLswRejqQ4TeICsuWajZttmH0AB2GtK6NVU3W5y1KpIZkK419u9R/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779094343; c=relaxed/simple;
	bh=EICJi/aaT88j8x8W/lvgeuwIQy7Ne1BVx13M96VG7Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/IKYy0WTO8PylR1//lNtTN40Q3zQfpFLJLn1leU+mqPxpgfoxXl+PuNea20VKrPCxdU2/FC5w1qkScfZL6NjX+cVIc901Unhhbu+fpvJyokcGdRa2spTx8ECzivUC9Ig4v7NtW4Sb/L2tf14bD7Z3we8YFkMT4OUQH5JiA2NPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPrnimec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPrnimec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D594C2BCB7;
	Mon, 18 May 2026 08:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779094342;
	bh=EICJi/aaT88j8x8W/lvgeuwIQy7Ne1BVx13M96VG7Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lPrnimecxFQILkNqI4FqV1PHtkcjPiTdr3K5Vg34uVYhioVLvTl5/hHempssR7oaV
	 VlqFIWG/vHomjU+jGHMbx4SWlrwEDnmqARe06BCkDuyXRECVVSgCC5NI7R9xAhFpny
	 lbfWcDjkiOSLqUO4JFuW6hnV0xZYUGa7NbaqntRKMZ+Knalg/gSzeVkjY7BOqJdV1b
	 UvvTr3hHtVxIaBjDpPY+oKwUDbB3rWYAwJfEoqC9XSR5xdv8sapTXK//2TBFtrXRJk
	 Hyo49HId1R8SZ57h61cV/6LsaYbac5y08N2d3xMLYlI8olS0EGZI8x7BYRuX8iFq3p
	 m4PJdH5LxnEng==
Date: Mon, 18 May 2026 09:52:16 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Introduce S2 walker SKIP return
 options
Message-ID: <agrTQMw4QJX6HGrm@willie-the-truck>
References: <20260515195904.2466381-1-leo.bras@arm.com>
 <20260515195904.2466381-2-leo.bras@arm.com>
 <agq-RyKhBy4CIThm@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agq-RyKhBy4CIThm@kernel.org>

On Mon, May 18, 2026 at 12:22:47AM -0700, Oliver Upton wrote:
> On Fri, May 15, 2026 at 08:59:02PM +0100, Leonardo Bras wrote:
> > Introduce S2 walker return values:
> > - SKIP_CHILDREN: skip walking the children of the current node
> > - SKIP_SIBLINGS: skip waling the siblings of the current node
> > 
> > Also, modify __kvm_pgtable_visit() to fulfil the hing on above return
> > values. Current walkers should not be impacted
> 
> I'd rather see something based around new walk flags than introducing an
> entirely new mechanic around return values.
> 
> e.g. you could split the LEAF flag into separate flags for blocks v.
> pages:
> 
> 	KVM_PGTABLE_WALK_PAGE,
> 	KVM_PGTABLE_WALK_BLOCK,
> 	KVM_PGTABLE_WALK_LEAF	= KVM_PGTABLE_WALK_PAGE |
> 				  KVM_PGTABLE_WALK_BLOCK,
> 
> and then let __kvm_pgtable_visit() decide how to steer the walk. You may
> need some special handling to get the address arithmetic right when
> skipping over a table of page descriptors.

I was wondering along similar lines, but maybe it would be useful just
to pass a maximum level to the walker logic? That feels like the most
general case without complicating the existing logic.

Will
