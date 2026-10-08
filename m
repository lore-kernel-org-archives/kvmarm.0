Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC036B932
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 20:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791491317; cv=none; b=hJPhuFuafFR8dkDcg+66I+O4kJ1IcN+XtECjGXZC5Od5W3hPMS8nBCh6nBuR99YvzvDgioz9/l2UPM5fLzBZZ1E5jFdPjcG6tybwaXOw2jNbIb6XvcXk+M9odZt6EUUygli42V0h3eP6WxSltNF+WktnEe+GEfa6RntppM5P4RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791491317; c=relaxed/simple;
	bh=mNvOB+KGOLoyZmuXxuqz2CLFBYOvXKUFcOmLZj7MOYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdC73PUCODKbuIzVxaaBSi7r8Xby5EwHEejam2h3dX8nBpWXpQfhNXGLzCHLDoLM/NrmRJsdw570Orn063M2cOW7QomtoRQWp6NWI64YrW/vLHwKpKf3vNTVNZBY++J+E3E17tnSX6jl1QULf+qt537ie6EaBo/zinjWCrv4P+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1WnOMAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1WnOMAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B8D1F000FF;
	Thu,  8 Oct 2026 20:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791491315;
	bh=AXqdN5NM/wlg2F8eFqzzica7nKQ60DQkM32wCrMgOZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P1WnOMAzhX0r0p+dRbQm5BeoFyfpcd3NetZ23g75J+5tUE1LIbd/YHCWDvGgCLu6N
	 aG9Aa9SVdpmPs6FlZ9wGBTsAb6Zn+ywHdgimkOcCc3CWfTitu7olMeRlHNptNgu3E4
	 EejlmpRyIMyaQBw8iKqJog0witsYLYjMjhvd0tQKHeEGdxOQO49izGp8nO6XqUNcPi
	 M/k+AuanHknCantAAJUaqzb0o7OJwMtl1sV8WzsEeljdv0Pz7N2Xw2CJCIouqpI2Pp
	 wWl2j2Ah6juGjj2KsaObFAt5EA2mBKpED6pwg4qx4tWX+cV/fF9VksSVXl9I+lOJ6M
	 UdzIbVXDQOZLw==
Date: Thu, 8 Oct 2026 13:28:30 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: Re: [PATCH v2 0/7] KVM: arm64: vgic-v3: Make LPI disabling robust
 (and more)
Message-ID: <asf87i2RDh-WksL-@kernel.org>
References: <20260929093548.3598547-1-maz@kernel.org>
 <CA+EHjTybnn2jgVKxCO0WXdGXWJ-=2p4k98CHfh3CrhJopvPDFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTybnn2jgVKxCO0WXdGXWJ-=2p4k98CHfh3CrhJopvPDFQ@mail.gmail.com>

Hi Fuad,

On Thu, Oct 08, 2026 at 07:15:46PM +0100, Fuad Tabba wrote:
> Hi Marc,
> 
> On Tue, 29 Sep 2026 10:35:41 +0100, Marc Zyngier <maz@kernel.org> wrote:
> [...]
> > Address the two issues in one go, by actively taking a refcount on all
> > IRQs referenced by last_lr_irq, and making sure that disabling LPIs
> > force all vcpus to be paused, making it safe.
> 
> I'm triaging Sashiko's pre-existing bug database, and I ran into
> something that I think this series doesn't cover.
> 
> vgic_its_inject_cached_translation() doesn't check vgic_lpis_enabled()
> (the slow path, vgic_its_resolve_lpi(), does), and pausing the vCPUs
> doesn't stop an MSI coming in through irqfd or KVM_SIGNAL_MSI. So an
> MSI that hits the translation cache between vgic_flush_pending_lpis()
> and vgic_its_invalidate_all_caches() can still end up on the ap_list
> of a vCPU whose LPIs are being disabled, after the flush.
> 
> Could the cached path check vgic_lpis_enabled() on the target vCPU, or
> am I missing something?

Hmm, since there's no parent lock between disabling LPIs and translation
cache fills I believe there's still a chance for this to race. We could
have vgic_target_oracle() return NULL if LPIs are disabled at the
redistributor, then the rest of the AP list machinery will "just work"
for injections that slip between the cracks.

If only Arm went a bit further than "strongly recommends" on migrating
LPIs _before_ flipping the bit...

Thanks,
Oliver
