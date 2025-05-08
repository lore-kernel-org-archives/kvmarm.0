Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BDCF1ADFE4
	for <kvmarm@lists.linux.dev>; Thu,  8 May 2025 09:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746696426; cv=none; b=MJ/JsxmAMLF2g3IVbdF7CXcgnfyJFKvR8Pqzu6PE000V/ANd3m0G13jgJu71D9Y4+4DtHQdNMNXg8Pp8md967iHVc8xCBU74AwqI4WoqaSl+361qyAD+5tgLqJp+aSZMaqf7kYOumUdy0n4GypFNLsZQ9gqpVg298AjZyWKQjJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746696426; c=relaxed/simple;
	bh=jBTnTuDF1nWzonOW4Z/l4TDLFMG9KRzfXwLS8AsJUWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJJLuVFOHrzA3LbpR6Qs7vQ2cz1F3YS96l6GYKbDuxoVX9DJ5VmymAbHAJ6c4GdaN+tsYTiIDYdiTyeAHiioWAdDLph7+FmekQt7a85RAMk/XbiJBWfg6h70oCsNC88pJWBCirk6zD7g6Pw99m3TBPdKk5VKtCSlDOVbW7gko0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 506D2106F;
	Thu,  8 May 2025 02:26:54 -0700 (PDT)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BD493F673;
	Thu,  8 May 2025 02:27:02 -0700 (PDT)
Date: Thu, 8 May 2025 10:26:59 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Per Larsen <perl@immunant.com>, armellel@google.com, arve@android.com,
	Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
	kernel-team@android.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	qperret@google.com, sebastianene@google.com, will@kernel.org,
	yuzenghui@huawei.com, Per Larsen <perlarsen@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Restrict FF-A host version renegotiation
Message-ID: <20250508-spectral-sage-whippet-4f7ac2@sudeepholla>
References: <CA+AY4XcaJa1_U3qXQUBj4wZJYc9hKmRX8FTNeDvV2auEnC_WrA@mail.gmail.com>
 <86r017h00e.wl-maz@kernel.org>
 <aBnNXyJn818ZEKOS@google.com>
 <8634dfh47q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8634dfh47q.wl-maz@kernel.org>

(just adding some additional info not particularly impacting the $subject
 change implementation)

On Thu, May 08, 2025 at 09:55:05AM +0100, Marc Zyngier wrote:
> On Tue, 06 May 2025 10:29:41 +0100,
> Per Larsen <perl@immunant.com> wrote:
> > 

[...]

> > Asssuming we drop this patch from the series and apply the rest, the
> > hypervisor and host can negotiate FF-A 1.2. If the host then calls
> > FFA_VERSION a second time to request FF-A 1.1, the hypervisor would
> > return version 1.2 (without this patch).
> 
> Why would it do that? Once a particular version has been negotiated, I
> expect to be immutable.
> 

Not suggesting that we need to support this, but it is technically possible
today by loading FF-A as a module—first inserting and removing a module with
v1.2 support, then loading one with v1.1 support. It can ever throw error
as not supported to keep it simple.

> > Per the spec, that means the
> > host is can use the compatibility rules (DEN0077A Sec 13.2.1) to go
> > ahead and use FF-A 1.1 (every function in 1.A must work in a compatible
> > way in 1.B if B>A).
> 
> I don't interpret this as "you can switch between versions" after the
> initial negotiation.
> 

Agreed.

> > However, the hypervisor negotiated version stays at 1.2 so it will use
> > SMCCC 1.2 for 64-bit interfaces. The host has no way of knowing this and
> > might as well assume that the hypervisor was implemented to fall back to
> > SMCCC 1.1 in this particular case. 
> > 
> > I don't even know that the host will ever try to renegotiate as it is
> > explicitly not allowed by the FF-A spec. There is no way for the
> > hypervisor to say, "stay at the negotiated version" so we must return
> > NOT_SUPPORTED. 
> 
> If it is not allowed, why should we do *anything*? And if the host is
> broken, let's fix the host rather than adding pointless validation
> code to EL2.
> 

Agreed, it is *not yet" allowed. There were some thoughts for a different
use-case IIUC, need to check the status. IIRC, it was bootloader vs OS
where bootloader like UEFI might negotiate one version(usually older) and
then OS comes and request newer version. To support such a setup, we do
need some additional support in the spec and the current latest v1.2 is not
sufficient.

-- 
Regards,
Sudeep
