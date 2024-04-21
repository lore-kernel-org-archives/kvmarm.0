Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDADD1E53A
	for <kvmarm@lists.linux.dev>; Sun, 21 Apr 2024 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713733122; cv=none; b=oSgZ/egskee+avX3+vngtgztY6Y8viORFHDYszObF3DGTadW44MkjQujFHJLMohHUPLzHZ4NtX/W7lRlPfnY5QI6oIfu8z/oWo14O83EvmGYVjsyORWh2BHUDETacNLv5fwBKR+qYZY6dBwI/rJJwUPHbtvT7II8OyZVrouZ0to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713733122; c=relaxed/simple;
	bh=+3CIpl4YnkA8zwzAJWsFg2tR9OM6eSwiY0kzTAFzX4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgnbxFfaNYKFxpkIHDAK+CWwJq7fb2ppRzj7SUOnddGxt6iEg5i553wgN7CG2YI7tQNcfKHvwBBdrpwrGKh6U0wc5/R80/xIuAuYYZ7qhc6H50ykd5ZEmRioESLA38yrREbhgIxlKqjhZEZ7JkRlm8tY6VG9rI+5HypOu4FkY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xVSuZDdZ; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xVSuZDdZ"
Date: Sun, 21 Apr 2024 13:58:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713733117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X0aUEwivu6293zpDnaZx73j3M0TA94kYuxukYi2QIHM=;
	b=xVSuZDdZcJX8woGo/KZk45E60cCj8YBhxBzBqtk7i3EvmhMAX0jai3O1WGyNjQvqTm1/Pc
	fRCvmlBnx8HTHVd0wK++NqdWNXDQPS+oKK0xBeS/XwrtJuVWrBOWAMAlZO9fuDkvyBToT1
	mmhUVqEaqqFpGGi/i9UMfXUoe7SSslA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 09/19] KVM: arm64: vgic-its: Maintain a translation
 cache per ITS
Message-ID: <ZiV99z13_i9jOVxE@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
 <20240419223842.951452-10-oliver.upton@linux.dev>
 <86mspnqa8e.wl-maz@kernel.org>
 <ZiVG3JoK1Soe6Eqj@linux.dev>
 <87ttjuqyzo.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttjuqyzo.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 21, 2024 at 08:47:39PM +0100, Marc Zyngier wrote:
> On Sun, 21 Apr 2024 18:03:24 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > > Does it mean we could drop this check? And even relax the locking?
> > 
> > I don't think so, a race still exists. For example, Userspace could issue
> > concurrent calls to KVM_SIGNAL_MSI for the same device / event.
> 
> Really? When injecting an MSI, either you hit in the cache or you
> don't. If you don't, you translate the hard way, then try to fit the
> translation in the cache. If if you have a concurrent MSI being
> signalled, whoever wins the "reserve" game wins, and it is "their"
> translation that will make it into the cache.

My understanding of xa_reserve() is that it does nothing and returns 0
if an entry already exists at @index, and only returns an error if an
underlying memory allocation failed. But that could be wrong :)

> At this stage, the locking becomes irrelevant for the purpose of
> avoiding concurrent filling of the cache, because reserving serves as
> a proxy for the store.

The xa_lock() actually isn't relevant either way, as this gets called
under the its_lock. The race arises from vgic_its_check_cache() reading
the translation cache outside of any lock, and one of the threads
winning the race to take the its_lock for the slow path.

xa_reserve() would still succeed on the losing thread (based on my above
assumption) and either needs to re-check the cache or fix the reference
count of whatever entry got evicted.

-- 
Thanks,
Oliver
