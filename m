Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBF936495B
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779119767; cv=none; b=uky+4Sd7F3EOsVbSNXxnInyXNs2BWwBqQs7Cjswxj3bJ4Kypzc3ICU3CIdfD0xYsSSqDeIGa7VPRVMzwfULFnftcaYfN9/YWTUhRKc8eIpv/zeJWCoQi7wT3SnOdhG1ZQQXvU0HyK+/f66YeGrWFDLN7Z9rj8OEvZl8enC1/v3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779119767; c=relaxed/simple;
	bh=dpZik2/Jd8VdAFvr0/z5S0PoQjKxn1keu6UZtFpwAJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N07nrZfzO2bzGvAcT0ekAt1O0tfmyeUnsaxl3G+qeUqFWFVzu5zb8uF25OpcRVENPruzLGMJfxGMpYWWhO7mkbj7VvwUdGcWvkEuC7rDHZ2yj57bte6DK23o3QE7Fkv4fO88+zvrbOYrl05Rtw8/otnAKHhsg0pRIm70dyT8fi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOWUIdFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOWUIdFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F903C2BCB7;
	Mon, 18 May 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779119762;
	bh=dpZik2/Jd8VdAFvr0/z5S0PoQjKxn1keu6UZtFpwAJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOWUIdFa5gfNcdVH9/pGSoGCEtls2XDpW+SgbCLZ0XVxKzAWSgIsZWe6sirm11gp8
	 eG0HhcCFmVlorjyxBU8sSWzS9FEDX8mRfPYbpTRo1sQg8WgXeY058dPZPOrvsxGw2c
	 Uhtw6ITIyuCdw5doFGvxUSv5GqPKLqFsGZ9CRHYI2iLsczIjf9jVUYISGLb0GFIura
	 DDRz6zBXRQsiODY7kbOrtL7eTXCz8UTadPhDuYR9AgS9K8Uxo/KWxdAx9bAUjt5vir
	 8mmyyc/ccYv9mU9noEpRTVVbBzlG1KXSdjKzuK8mao1AEK7euNrDjGMuiANPLWoKdx
	 mY/WmSXqMXEPw==
Date: Mon, 18 May 2026 16:55:57 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Don't populate TPIDR_EL2 in finalise_el2()
Message-ID: <ags2ja9HW41_GKls@willie-the-truck>
References: <20260518153127.6078-1-will@kernel.org>
 <86y0hgwwul.wl-maz@kernel.org>
 <86wlx0wwro.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wlx0wwro.wl-maz@kernel.org>

On Mon, May 18, 2026 at 04:41:15PM +0100, Marc Zyngier wrote:
> On Mon, 18 May 2026 16:39:30 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Mon, 18 May 2026 16:31:26 +0100,
> > Will Deacon <will@kernel.org> wrote:
> > > 
> > > Currently, it is not necessary for __finalise_el2() to configure
> > > TPIDR_EL2:
> > > 
> > > * The hyp stub code does not consume the value of TPIDR_EL2.
> > > 
> > > * On the boot cpu, TPIDR_EL1 is used for the percpu offset until the
> > >   ARM64_HAS_VIRT_HOST_EXTN cpucap is detected and boot alternatives
> > >   are patched. Before boot alternatives are patched,
> > >   cpu_copy_el2regs() will copy TPIDR_EL1 into TPIDR_EL2. It is not
> > >   necessary for __finalise_el2() to initialise TPIDR_EL2 before this.
> > > 
> > > * Secondary CPUs are brought up after boot alternatives have been
> > >   patched, and __secondary_switched() will initialize TPIDR_EL2 in
> > >   'init_cpu_task', after finalise_el2() calls __finalise_el2()
> > > 
> > > * KVM hyp code which may consume TPIDR_EL2 is brought up after all
> > >   secondaries have been booted, once TPIDR_El2 has been configured on
> > >   all CPUs.
> > > 
> > > Remove the redundant initialisation from __finalise_el2().
> > > 
> > > Cc: Oliver Upton <oupton@kernel.org>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > 
> > Reviewed-by: Marc Zyngier <maz@kernel.org>
> 
> Ah, realised too late you intended for this to go via the KVM tree.
> 
> I'll queue that for 7.2.

Thanks, Marc!

Will
