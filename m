Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B4A449B0C;
	Fri,  4 Sep 2026 10:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517729; cv=none; b=qJkTj+pFE+1pNOPLpWvHNyfe5GdORjEPQclWUInw6yPodhM9qHAVvHYGv+Rbgpbkd0iIWKl5t8x40iXgUEyuqReZlAVX9ekwMjuCC8Dpm4F05iATIJQVc0aTZ1lzgsTb5Zt7Ix4dLrzAwVlHFeRoJbgtfFFBPc0Se3alvZPwGx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517729; c=relaxed/simple;
	bh=yWTFTbyCD2ZbTDtZtPVjYhpiVB5RoJTV6RTzQNDXhn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVVhe+pbXmcMpGxjgEd0+U7kQVHXD79A0W/pd7vZmsJu03YJ8gZ/V097tutcbQb+nOLpglG5gUOuXXl8aE9hB8ieI7vlQXAu6wLO9zGXkXiYcRiGcbZQIdOVmm5orG4Xy/AkOQmqdcm2BSaKMwXIOGthy+ebE2WG5S2ida+3hO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KpIzOkyQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KpIzOkyQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 082A0153B;
	Fri,  4 Sep 2026 03:28:43 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.1.34.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC5143F673;
	Fri,  4 Sep 2026 03:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788517726; bh=yWTFTbyCD2ZbTDtZtPVjYhpiVB5RoJTV6RTzQNDXhn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KpIzOkyQ+QnufWQpGim6KXXRX2l/4Az3H/34r5LLUJ4DIhaB4PM5+293HJQWL4Z6r
	 3vmKplbwl+ywuVA7E0B4oQmK99EQIs+QFmVEFatAhLptOHGUVUFkSld8TJ9rsnXv6Q
	 v580Ry3OeQsWod3Jvm1Moark6NIYtyD3De8+Qeoo=
Date: Fri, 4 Sep 2026 11:28:41 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>, linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v7 16/28] KVM: arm64: Add SPE system registers to
 VCPU context
Message-ID: <apqdWR9Eyry6bBU7@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-17-alexandru.elisei@arm.com>
 <20260903163250.3F3531F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903163250.3F3531F00A3D@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:32:49PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] WARN_ON_ONCE is incorrectly called with a string literal instead of a boolean condition.
> --
> 
> commit aa1092f112d707ae630c6edfaa06e1cf58da7524
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: Add SPE system registers to VCPU context
> 
> This commit adds SPE registers to the VCPU context. It only traps the buffer
> registers, allowing KVM to track the buffer enabled state for dirty page
> logging and to sanitise writes to PMBLIMITR_EL1 based on exposed VM features.
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> > index 4426d614a9e0b..6a00a44c73edf 100644
> > --- a/arch/arm64/kvm/spe.c
> > +++ b/arch/arm64/kvm/spe.c
> 
> [ ... ]
> 
> > @@ -82,6 +83,34 @@ void kvm_spe_destroy_vm(struct kvm *kvm)
> >  	module_put(spe_pmu->pmu.module);
> >  }
> >  
> > +bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
> > +{
> > +	switch (reg) {
> > +	case PMBLIMITR_EL1:
> > +	case PMBSR_EL1:
> > +	case PMBPTR_EL1:
> > +		__vcpu_assign_sys_reg(vcpu, reg, val);
> > +		break;
> > +	default:
> > +		WARN_ON_ONCE("unexpected trap");
> 
> [Severity: Low]
> Does this macro call miss a boolean condition? The WARN_ON_ONCE macro
> expects a boolean expression, but it is being passed a string literal here.
> While this functionally evaluates to true because the string decays into a
> non-null pointer, could this be considered an API misuse? Perhaps this
> should use WARN_ONCE(1, "unexpected trap") or WARN_ON_ONCE(1) instead when
> an unexpected trapped SPE register access falls through to the default case
> in kvm_spe_write_sysreg().
> 
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
> > +{
> > +	switch (reg) {
> > +	case PMBLIMITR_EL1:
> > +	case PMBSR_EL1:
> > +	case PMBPTR_EL1:
> > +		return __vcpu_sys_reg(vcpu, reg);
> > +	default:
> > +		WARN_ON_ONCE("unexpected trap");
> 
> [Severity: Low]
> Similarly, should this use WARN_ONCE(1, "unexpected trap") instead of
> passing a string literal directly into WARN_ON_ONCE when an unexpected
> trapped read falls through to the default case in kvm_spe_read_sysreg()?

Yeah, that's right, I'll fix both instances of the misuse of the macro.

Thanks,
Alex

> 
> > +		return 0;
> > +	}
> > +}
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=16
