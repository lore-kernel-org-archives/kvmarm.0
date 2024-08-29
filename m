Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919C323A9
	for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 00:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724892496; cv=none; b=rGFs/i7Ct8s/GoyzwwdeQzxUotqDQoZIZdwRdxdVGpqMU7C5oF3CvS5cX4ArdvO64c9qvzdq6upYj0QadTemYSw62v+YqEq1NM5UXgjnLoZ1hYzLnC+NJv/flS+Ylq1KiWD4S7LVxjqz/S/u6NMBwQPxdMdGuXXeDJzgIf02hME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724892496; c=relaxed/simple;
	bh=QqSuPRUy9Z8k65jDYu74y1tnd9YHR0HHTjML0qxIqIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpR4iojWekJBnKOjTSdTc2MPi44JoFiBNiZTtPs77VZT9KxuWBop+RAvF814qqslAEhQvtq87jfaUAeVUI5cgONfJTvuOfw3mDCVD4zJ6lVutrKHjtnPogLJhJ/hFPCwGeN4JRe+jFXpazLanYYCD8N7fOAvpIfZJXiHw8xBKrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B/HwdnXk; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B/HwdnXk"
Date: Thu, 29 Aug 2024 00:48:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724892491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUT6VucVLQZ/G6zrZsweR/i/y1YmIh/YabO7/ru4g0M=;
	b=B/HwdnXkHGwa9sw7c+lK0aatbPfe+xLycympQuw/gButV9bytRFDwHIqM5vOk3QjHsIbn9
	/c45mFcrq3+2TppO9utVm9hxl9Q2eDApAoXkjB7pn56HNAE3vxAc5ofkiV/jJp249QTXbQ
	MOKPj0tz1eoZ4kfdFGHj1OrDFFR4nR8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no
 GICv3 is presented to the guest
Message-ID: <Zs_FR0nMRCbASi_k@linux.dev>
References: <20240827152517.3909653-1-maz@kernel.org>
 <20240827152517.3909653-6-maz@kernel.org>
 <fa2ea6cf-0ee9-4208-8526-3426a78895a8@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa2ea6cf-0ee9-4208-8526-3426a78895a8@sirena.org.uk>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 29, 2024 at 12:22:52AM +0100, Mark Brown wrote:
> On Tue, Aug 27, 2024 at 04:25:11PM +0100, Marc Zyngier wrote:
> > In order to be consistent, we shouldn't advertise a GICv3 when none
> > is actually usable by the guest.
> > 
> > Wipe the feature when these conditions apply, and allow the field
> > to be written from userspace.
> > 
> > This now allows us to rewrite the kvm_has_gicv3 helper() in terms
> > of kvm_has_feat(), given that it is always evaluated at runtime.
> 
> This patch, which is in -next, is causing the set_id_regs tests to fail
> on a variety of platforms including synquacer (it looks to be everything
> with GICv3 which wouldn't be surprising but I didn't confirm):

Mind taking this for a spin? Seems to do the trick on my end.

https://lore.kernel.org/kvmarm/20240829004622.3058639-1-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
