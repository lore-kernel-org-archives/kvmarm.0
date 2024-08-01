Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A29616C695
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722527688; cv=none; b=uadqv7M84P4KcuUSQpv23POCetqIPm0bC3SPCo9TqByqaxVsoIRf/4Me7/DUM0hIYrAEYUwDmO+60Xg8TnXU8AyBd+nbXryaNDNJq0GlcdjG3ZZEGAe3VmkmJvjrjUScdBaAMUoavazh2cWyzQM7iKudsQMEmxsVkbQv578ekXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722527688; c=relaxed/simple;
	bh=3K7h6kqYrpVVi3yJIDa/MfHmTk3MeT2DYdT5sel9lyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hm4dUcpBaEGnKo1FYTcANB+f3UF2P4veDMFuXwCoFNQbEUvCqAlUFe8sLdJCn5gWC2vGvKKftDkq/+gtDbFSW+eIWs4yMdHx/au1wNCTz+MsnzzeaCi9hBauXvX3QaD2+hYbWM5gtiQkoV3Lr+2dLeg7uB8BdNGlx6+o34RFca0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB88115A1;
	Thu,  1 Aug 2024 08:55:11 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33D933F5A1;
	Thu,  1 Aug 2024 08:54:43 -0700 (PDT)
Date: Thu, 1 Aug 2024 16:54:41 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, aneesh.kumar@linux.ibm.com, bp@alien8.de,
	broonie@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, dave.hansen@linux.intel.com,
	hpa@zytor.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, szabolcs.nagy@arm.com,
	tglx@linutronix.de, will@kernel.org, x86@kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 18/29] arm64: add POE signal support
Message-ID: <20240801155441.GB841837@e124191.cambridge.arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-19-joey.gouly@arm.com>
 <ZqJ2knGETfS4nfEA@e133380.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqJ2knGETfS4nfEA@e133380.arm.com>

On Thu, Jul 25, 2024 at 05:00:18PM +0100, Dave Martin wrote:
> Hi,
> 
> On Fri, May 03, 2024 at 02:01:36PM +0100, Joey Gouly wrote:
> > Add PKEY support to signals, by saving and restoring POR_EL0 from the stackframe.
> > 
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > Acked-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
> > ---
> >  arch/arm64/include/uapi/asm/sigcontext.h |  7 ++++
> >  arch/arm64/kernel/signal.c               | 52 ++++++++++++++++++++++++
> >  2 files changed, 59 insertions(+)
> > 
> > diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
> > index 8a45b7a411e0..e4cba8a6c9a2 100644
> > --- a/arch/arm64/include/uapi/asm/sigcontext.h
> > +++ b/arch/arm64/include/uapi/asm/sigcontext.h
> 
> [...]
> 
> > @@ -980,6 +1013,13 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user,
> >  			return err;
> >  	}
> >  
> > +	if (system_supports_poe()) {
> > +		err = sigframe_alloc(user, &user->poe_offset,
> > +				     sizeof(struct poe_context));
> > +		if (err)
> > +			return err;
> > +	}
> > +
> >  	return sigframe_alloc_end(user);
> >  }
> >  
> > @@ -1020,6 +1060,15 @@ static int setup_sigframe(struct rt_sigframe_user_layout *user,
> >  		__put_user_error(current->thread.fault_code, &esr_ctx->esr, err);
> >  	}
> >  
> > +	if (system_supports_poe() && err == 0 && user->poe_offset) {
> > +		struct poe_context __user *poe_ctx =
> > +			apply_user_offset(user, user->poe_offset);
> > +
> > +		__put_user_error(POE_MAGIC, &poe_ctx->head.magic, err);
> > +		__put_user_error(sizeof(*poe_ctx), &poe_ctx->head.size, err);
> > +		__put_user_error(read_sysreg_s(SYS_POR_EL0), &poe_ctx->por_el0, err);
> > +	}
> > +
> 
> Does the AArch64 procedure call standard say anything about whether
> POR_EL0 is caller-saved?

I asked about this, and it doesn't say anything and they don't plan on it,
since it's very application specific.

> 
> <bikeshed>
> 
> In theory we could skip saving this register if it is already
> POR_EL0_INIT (which it often will be), and if the signal handler is not
> supposed to modify and leave the modified value in the register when
> returning.
> 
> The complexity of the additional check my be a bit pointless though,
> and the the handler might theoretically want to change the interrupted
> code's POR_EL0 explicitly, which would be complicated if POE_MAGIC is
> sometimes there and sometimes not.
> 
> </bikeshed>
> 
I think trying to skip/optimise something here would be more effort than any
possible benefits!

Thanks,
Joey
