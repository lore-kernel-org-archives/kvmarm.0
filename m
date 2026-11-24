Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795559352;
	b=N4R4o5tYuogawXPecl+DPczqZzOLo81k3liXhtKowgQxde9uuXWCtVi/8W12YEkymDsZ
	 ktax/Hr1tpwyUbfA0Z8IpCzaMdIKDmHXygy4ewofbAQfVdEUfiUA9sZxEUu/EQYzMuMEd
	 OgawgbDfegBqAK8u38dkh7nOUf9xK6XE5KIRLGs6lS8Uo3Sh8GO1XoYS8wCRPdSmu12hF
	 9Uf7j29kPoTbSIIv4NZB0XHlln/sPtwuFn5uQ/36MFWu7VY8HAFh9UUKlW9hzB52QqUIl
	 RehsGIB1WGXD0G2NNBPPxjEF0vNaJP+DwdAUQVjLMiSjYWms2cSJiTJf4VFcIE0XTDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795559352;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WkLgW+c6Vs03pawnWwBT2nJkyF8m6BmAQ32Lw7TCuco=;
	b=NEWZJ7pLAeWsh7b2o9rYVIcEbUeMKFnqaDG99rV4lgcqCVbbMAsH6cg0ALbxzBgbbbCc
	 GLFoGfyMF5BmmitvNeU/6TB3+SqTsC/XXEmy3tN9VGcpuHSXOOKOpndiIfrM/arkJ5mGf
	 4btxqZ4BzRCQ0EUNxCQhdF2EuY0VeD5ThFu272tp+SNv8Slnyl9dXpcaOE5Ip7r5+oGoE
	 dPWubAlx3aBEmhqV04TdX5D20ivBZ86cNWHZo3haalgY9ROPx8QeqMf6+qWLWyB4TKCz8
	 laXB0hxd+cMmCMfTyjqfYuTUUchw2IowwetVOhcahcMse5tF85R9BysS29vmmjE3m3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2vpPnrm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDC5606A31E;
	Tue, 24 Nov 2026 22:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2vpPnrm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D111F000C4;
	Tue, 24 Nov 2026 22:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795559351;
	bh=WkLgW+c6Vs03pawnWwBT2nJkyF8m6BmAQ32Lw7TCuco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o2vpPnrmCxtOS8P4HVMlKGd/mwISEMkCQRNhDBmEksIcnnp4Ig8q/vKSsvXIk1N92
	 gq2c8oMJW97kGIf8vTTNEC55YbRTgmE7EsPpgpY71ZmAA5mN8Im31aoxF+g+0Xa31D
	 ZMUIEhm/KJpYM3iJNv1PGvI3m00mxPUsr0hb4bqC1xgPIj9rETcK42HhQD3QgK15JB
	 l5WF86ZE2CQA6vbKe/1b5JS5s+x8Mx4l0NjHrFs1PJxyJPr0D6K5RAacpwY8hJvI/X
	 XD/wFKxYwcO9mEch31+86IlVIegcSheoZKzm0XYpj+SApYC3/dKZp+64j9frnHmoq2
	 UTnxdnXBiZKLw==
Date: Tue, 24 Nov 2026 14:29:09 -0800
From: Oliver Upton <oupton@kernel.org>
To: Nathan Chen <nathanc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Tom Matthias <tmatthias@nvidia.com>,
	Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Julian Miller <julianmiller@nvidia.com>
Subject: Re: [RFC PATCH 0/6] KVM: arm64: nv: Grow the shadow S2 MMU pool on
 demand
Message-ID: <awYPtXVeY1NYeTla@kernel.org>
References: <20261124211218.2751086-1-nathanc@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124211218.2751086-1-nathanc@nvidia.com>

Hi Nathan,

On Tue, Nov 24, 2026 at 01:12:12PM -0800, Nathan Chen wrote:
> A nested-capable VM gets 2 shadow stage-2 MMUs per vcpu. Once the guest
> hypervisor runs more nested VMs than that, nearly every nested context
> switch recycles a live MMU and spikes host CPU usage.
> 
> This series lets KVM grow the shadow MMU pool on demand when the pool
> is too small, up to a host-wide VMID budget. It also parks grown MMUs
> on a guest TLBI ALLE1 and when a guest range invalidation leaves them
> empty, in order to return unused capacity.

Thanks for taking a look at the problem. There's no argument that we
need to do something, the existing MMU allocation policy was good enough
for doing nested development and would get replaced eventually.

With that said, I feel rather strongly that we should not invest further
in the MMU array because it is quite inflexible. On top of that we need
an actual eviction policy that selects cold MMUs as victims instead of
the current round robin approach. I don't think you need to do anything
special on the invalidation side with a good eviction policy.

I think this is what we need:

 - A VM-wide hashtable for storing stage-2 MMUs, keyed off of
   {VTCR_EL2, VTTBR_EL2, HCR_EL2.VM} to align with how we handle TLB
   match at stage-2. The hashtable can be dimensioned based on a
   configurable VM limit for shadow stage-2 MMUs.

 - A state tracking mechanism for victim selection. An LRU list seems
   like a reasonable starting point.

 - RCU replacement of the evicted MMU. I need to think about it a bit
   more but you should be able to reuse the PGD in the new MMU context
   as well since we know that no vCPU holds a reference on the victim.
   That ought to be the goal anyway.

That should allow us to dynamically allocate MMUs while also improving
upon the current behavior for constrained MMU allocations.

Thanks,
Oliver
