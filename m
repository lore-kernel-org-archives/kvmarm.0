Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CE82FE26
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 23:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R8N+dwXM"
Date: Thu, 16 Nov 2023 15:22:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700176949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ql19/OGj64AFFaCoG3rNb0IvzQY8kBjJxvcnLCSOPkE=;
	b=R8N+dwXMjjEbQXwnXgnMViFOkdYDxySMg7onZbQpLj/tOmnHLechypeTzAq+V0LetrVLWJ
	WA5CT9AJKg+AwMhnccXO7mdC0rgkOjk+G+5eyWGxMT2HDH7UMds2PWp178gFqUDSq6S4z2
	pFHr6VXLWTQNKBE3e33gvmO+YXukj8g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Jianyong Wu <jianyong.wu@arm.com>, maz@kernel.org, james.morse@arm.com,
	will@kernel.org, salil.mehta@huawei.com, suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, justin.he@arm.com
Subject: Re: [PATCH] arm64/kvm: Introduce feature extension for SMCCC filter
Message-ID: <ZVakIv5mw6YUlHms@thinky-boi>
References: <20231116114152.912344-1-jianyong.wu@arm.com>
 <ZVZoKlWrjV1L3CBo@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVZoKlWrjV1L3CBo@shell.armlinux.org.uk>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 16, 2023 at 07:06:18PM +0000, Russell King (Oracle) wrote:
> On Thu, Nov 16, 2023 at 11:41:52AM +0000, Jianyong Wu wrote:
> > 821d935c87b introduces support for userspace SMCCC filtering, but lack
> > of a way to tell userspace if we have this feature. Add a corresponding
> > feature extension can resolve this issue.
> > 
> > For example, the incoming feature Vcpu Hotplug needs the SMCCC filter.
> > As there is no way to check this feature, VMM will run into error when
> > it calls this feature on an old kernel. It's bad for backward compatible.
> 
> Can't you just attempt to use the SMCCC filtering, and if it errors out
> with the appropriate error code, decide that SMCCC filtering is not
> available?

That would also work, as we return ENXIO for the unsupported ioctl.

> That's how most things like kernel syscalls work - if they're not
> implemented they return -ENOSYS. glibc can detect that and use a
> fallback.

I generally agree, but KVM has gone in the other direction of providing
auxiliary interfaces for discovering new UAPI. ENXIO has been slightly
overloaded to imply that a given ioctl is non-existent or otherwise
unsupported due to some dynamic configuration.

Is it ideal? Of course not. With that said userspace may as well use the
preferred / documented discoverability mechanism. And in Jianyong's case
the KVM documentation is rather unambiguous (for once) about how you
discover device attributes.

https://docs.kernel.org/virt/kvm/api.html#kvm-has-device-attr

-- 
Thanks,
Oliver
