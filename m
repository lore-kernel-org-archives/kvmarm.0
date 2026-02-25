Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38314239099;
	Wed, 25 Feb 2026 20:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772052060; cv=none; b=QgukqlVrkLtZC7bgML42qr8Kx28pWOmuyAJscnZ3nmNE6i9Nd3gTXqgRkfDn4PF5NQm7LZd/hRwMC9OoaY12WG8t9gAcUZ4NFZiKAKFxGZQs+mLxCTNoLYhQZ2b5TyyzicfHAb5FfYwHv8dows6eGBbVkeAzySlbKC+6h+dwmpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772052060; c=relaxed/simple;
	bh=z0Y3De4Uk2isfGH9NA9irLH/p0Xi9/d3jhSxem3V0qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzORIpMfnrJeGj/vRhFFWenbtZfPYHjYtSxCe+tSYl2fSFGoOLcoP/T3VznYlAsiR0ffJJ1AsfoIDNNXLQDuPtH/jxQemelD2zi0iZn1ZUjy0RIDtBB//lqH0nkGvgZewbn2RSsNAx5bEoPZOIYfw6eMuhAmB94RilxqMOeLG9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4EsyawR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4EsyawR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8A2C116D0;
	Wed, 25 Feb 2026 20:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772052059;
	bh=z0Y3De4Uk2isfGH9NA9irLH/p0Xi9/d3jhSxem3V0qU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g4EsyawRbjvuMG24b6o867TcLWDVI5T2q5/PWvvSNtJ+66Jb7JwoxMEJ7wdzjR316
	 TGgEFFfHcKDpYRD4T3RL8IuT+FlFuhkzb994WOV2pDGuT4K3CXvyTvVA4pojOAXgbS
	 va4WC+kD4r+/Tw4SHhbPG9JmEGh83LaefV3Pv1oYTOG2+t4KXnrcSTy3jLodqXrNxb
	 wZgGhyZRJC5q9eNTuCDWHbHU1tdhNEW28KQyQZtdP2ImAJop1xPf/X5aQQvbc949wq
	 V+L/MtAG+K6n5z+tsA/Ls2bLsxZLYBq1aCQ6cNBFJQyC2TrfLeRVkzvZ8XFMiJqDSG
	 fI+fsCmIDNRfw==
Date: Wed, 25 Feb 2026 12:40:59 -0800
From: Kees Cook <kees@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Timothy Hayes <timothy.hayes@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Keir Fraser <keirf@google.com>, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: vgic: Handle const qualifier from
 gic_kvm_info allocation type
Message-ID: <202602251238.9850FCB@keescook>
References: <20260206223022.it.052-kees@kernel.org>
 <177099499992.1792318.9934885934778681296.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177099499992.1792318.9934885934778681296.b4-ty@kernel.org>

On Fri, Feb 13, 2026 at 03:03:24PM +0000, Marc Zyngier wrote:
> On Fri, 06 Feb 2026 14:30:23 -0800, Kees Cook wrote:
> > In preparation for making the kmalloc family of allocators type aware,
> > we need to make sure that the returned type from the allocation matches
> > the type of the variable being assigned. (Before, the allocator would
> > always return "void *", which can be implicitly cast to any pointer type.)
> > 
> > The assigned type is "struct gic_kvm_info", but the returned type,
> > while matching, is const qualified. To get them exactly matching, just
> > use the dereferenced pointer for the sizeof().
> > 
> > [...]
> 
> Applied to fixes, thanks!
> 
> [1/1] KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocation type
>       commit: ee5c38a8d31e5dea52299c43c2ec3213351ab6e1

Just a heads-up that I ended up sending this patch to Linus for -rc1 as
it was a prerequisite for the tree-wide kmalloc_obj refactoring. Sorry
for any merge conflicts this might create for your tree! It is now
commit c732084c891d there.

-- 
Kees Cook
