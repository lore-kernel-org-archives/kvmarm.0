Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B65A39C
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 05:23:30 +0000 (UTC)
Date: Wed, 7 Jun 2023 05:23:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686115408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Aj/XbFSOUfLahtXChuiRjMB9iC5cvqz6gn2we+qXTA=;
	b=KMWHPoG57mhrVuLDKkoTgUuppTYntt2BMk50y4c750zlw9pLka1wI1/5N5x/8fTQYzfnc2
	jglD6sF/KmBDb3JM83vAMYBJaAr4s8yCTk6UDmTiyGKGPEb266hdxehpx9QgSQjddmvati
	7zoudwJ/7qb/l6ZLXFynvLdqSm4livo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, maz@kernel.org,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Fix a circular locking issue
Message-ID: <ZIAUTD9Og0ccyzrv@linux.dev>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
 <20230518100914.2837292-2-jean-philippe@linaro.org>
 <20230606221525.GA2269598@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606221525.GA2269598@dev-arch.thelio-3990X>
X-Migadu-Flow: FLOW_OUT

Nathan,

First and foremost, thanks for testing this.

On Tue, Jun 06, 2023 at 03:15:25PM -0700, Nathan Chancellor wrote:
> My apologies if this has been addressed or reported somewhere, I did a
> search of lore.kernel.org and browsed the kvmarm archives and did not
> see anything.

This is news to me, but even if it had already been reported there's
nothing wrong with bumping the issue. Makes it hard for us to bury our
heads in the sand :)

> After this change landed in 6.4-rc5 as commit 59112e9c390b
> ("KVM: arm64: vgic: Fix a circular locking issue"), my QEMU Fedora VM on
> my SolidRun Honeycomb fails to get to GRUB.

[...]

> I built a kernel with CONFIG_PROVE_LOCKING=y but I do not see any splats
> while this is occurring. Additionally, neither my Raspberry Pi 4 or my
> Ampere Altra system have any issues, so it is possible this could be a
> platform specific problem. I am more than happy to provide any
> additional information and test kernels and patches to help get to the
> bottom of this. My kernel configuration is attached.

I was unable to reproduce the issues you're seeing on 6.4-rc5, but I
don't have any different machines from you available atm. Based on
your description it sounds like your VM was able to do _something_
since it sounds like a few escape codes got out over serial...
I'm wondering if you're getting wedged somewhere on a VGIC MMIO access.

We don't have a precise tracepoint for VGIC accesses, but kvm:kvm_mmio
should do the trick. So, given that you're the lucky winner at
reproducing this bug right now, do you mind collecting a dump from that
tracepoint and sharing the access that happens before your VM gets
wedged?

Curious if Marc has any additional insight, since (unsurprisingly) he
has a lot more experience in dealing with the GIC than I. In the
meantime I'll stare at the locking flows and see if anything stands
out.

-- 
Thanks,
Oliver
