Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D074A242D70
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 15:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278016; cv=none; b=JHPjlqForuOWQhi3lLwMhGEGMxyYFMQlvysBOubluLH5cKKrWB+iwIlfRde/KBbr8Yej4KYdPMn4HmVd/5NlYqm3SawMrqRtkS5okvW3yxIEIXdlpntFKhEWa51u+nuT3LwYReID101l8szWcUdCkmH8AZpHK1UCYGjy04j/Bz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278016; c=relaxed/simple;
	bh=Hv3zAbS8DeLMrQDrPh89cAimDkr9XNvit+xdTh3RoWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RlTCvnBrYbT4lu2PmkNh0wkYynG0MrTb+vPTWljMlcFW9pGCCGFz73Sh5bwygyMR4HoMLYKOctoKQz4/XQbXDPnKMR6kAuSax7SLn6COJPtzkKhqd8W4y14kH+ZpSlYUMUCi/Sj0pGITymNaku2xHoVeH+55Io2igSy6fOhnWfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNdHEjiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNdHEjiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CB2C2BC9E;
	Mon, 23 Mar 2026 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774278016;
	bh=Hv3zAbS8DeLMrQDrPh89cAimDkr9XNvit+xdTh3RoWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nNdHEjiH4fJldE6ROcEUbFfZ/8o4o/PbBAg79CJYMBezd9MApZMfyHLKMsZeJBjC5
	 caClkZxB4r3aJixckNrChXGwRsYb4oLgv7JWkNP/L/RbS88nwRUmuG5Yqco0HmSvuq
	 1vDt1eWOU3h2dQ+ENhu6aMw+2V2lwUYw84LnvRMtUO6NaMh/C4L/v1kgTmOqoa9/59
	 4m+Ias2QxYpnF63YN7mJjO54WU9JJ69CLFprmJyEas83nDu5jt5V4waXoJ7BnpWHGq
	 jNOPScYypraXrpEE/8RNXMVuijUX6xBUCJw3y3EeyoJAM9wkT2fX+KwHl4g5ysDlD0
	 PPcv880wANmig==
Date: Mon, 23 Mar 2026 15:00:10 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 30/36] KVM: arm64: Allow userspace to create protected
 VMs when pKVM is enabled
Message-ID: <acFVeqB2P0rKqvBu@willie-the-truck>
References: <20260305144351.17071-1-will@kernel.org>
 <20260305144351.17071-31-will@kernel.org>
 <865x6q63fu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865x6q63fu.wl-maz@kernel.org>

On Fri, Mar 20, 2026 at 01:22:29PM +0000, Marc Zyngier wrote:
> On Thu, 05 Mar 2026 14:43:43 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > Introduce a new VM type for KVM/arm64 to allow userspace to request the
> > creation of a "protected VM" when the host has booted with pKVM enabled.
> > 
> > For now, this depends on CONFIG_EXPERT and results in a taint on first
> > use as many aspects of a protected VM are not yet protected!
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h |  2 +-
> >  arch/arm64/kvm/Kconfig            | 10 ++++++++++
> >  arch/arm64/kvm/arm.c              |  8 +++++++-
> >  arch/arm64/kvm/mmu.c              |  3 ---
> >  arch/arm64/kvm/pkvm.c             | 11 ++++++++++-
> >  include/uapi/linux/kvm.h          |  5 +++++
> >  6 files changed, 33 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index 7041e398fb4c..2954b311128c 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -17,7 +17,7 @@
> >  
> >  #define HYP_MEMBLOCK_REGIONS 128
> >  
> > -int pkvm_init_host_vm(struct kvm *kvm);
> > +int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
> >  int pkvm_create_hyp_vm(struct kvm *kvm);
> >  bool pkvm_hyp_vm_is_created(struct kvm *kvm);
> >  void pkvm_destroy_hyp_vm(struct kvm *kvm);
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 7d1f22fd490b..e71f7fb6e89a 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -82,4 +82,14 @@ config PTDUMP_STAGE2_DEBUGFS
> >  
> >  	  If in doubt, say N.
> >  
> > +config PROTECTED_VM_UAPI
> > +	bool "Expose protected VMs to userspace (experimental)"
> > +	depends on KVM && EXPERT
> > +	help
> > +	  Say Y here to enable experimental (i.e. in development)
> > +	  support for creating protected virtual machines using KVM's
> > +	  KVM_CREATE_VM ioctl() when booted with pKVM enabled.
> > +
> > +	  Unless you are a KVM developer, say N.
> > +
> 
> Let me once more express my lack of appetite for config options.
> Protected more is already gated by a command-line option, and requires
> active buy-in from the user.
> 
> Nested support is in the same "not quite finished" state, and yet
> isn't hidden behind a configuration symbol.
> 
> Taint the kernel if you want, but I'd rather we don't add extra config
> options for this. Documenting the "experimental" aspect of upstream
> pKVM should be enough.

Since I _do_ expect the user ABI to evolve (probably becoming stricter)
as we introduce additional protection to parts of the protected VM
state, I just went for the full shebang: CONFIG option, cmdline option
and taint.

I tend to agree that having *all* of that is overkill, so if you're
happy for me to drop the CONFIG option, despite the user ABI not being
stable, then I'm fine with that.

Will
