Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3084648640E;
	Tue, 22 Sep 2026 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100785; cv=none; b=ZzJ0J48DCUbXQQZSt8ZSmiNvmt0nTSuNGF6IMzfd6RoYbA/Hyis5myzayJ6zDJaoVao9EM6RNZ/gvmk94tDCNkgfJvcioB7T1AbZnMCAJnZIhx7Cq7ZTQDxjXszwGw6xbwE3O1jEtqNZR4hfp9ddzeHczacT+drDzuHBexaTMqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100785; c=relaxed/simple;
	bh=0ZZoTTvBclLSkUaE6pJ6RJ5I4n4escQFucYderbNDyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEyVJXoyrvAoHj7t7kCD0WnGPTd/hwFHk20A5001RAz+hWj9Nidqw0bY3SxeZlHKwP4i6eTO/j2i0Go0r7aPWZkYMRqwDb0T/8KTM2JorafRaCtdigUzLHxp4VPgGlQAx/Kc7tQ6WW7vrDSq8s8KL1LrMexLhY5S2Me/kUT8H+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEnsGW0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEnsGW0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B2B1F000FF;
	Tue, 22 Sep 2026 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100784;
	bh=CkCRLFxPHHGYCNcpfamPUAWq4+0JQ01hkaddMI1o5c0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aEnsGW0yAgw4LKhTybjTtlcqCi/fZB3g6qFJkA4kXBn1yUrqJyBxJzpOQAX/hUpUC
	 ZAJRHQspZybQ7ZzGv/GdWpa2tvJfCUTqAC6ZZJp/oV8xUtiBjvLpc//89ADZF4TvpI
	 KQJ0T16D3hJwV88PhMcUfsnhEI/h1wCQSFRTSgW1dbeVA01Med4Y3Nc6OxkLy5dG+B
	 b5OLTCoae+BMC/IHCa84m4y3H7c7P9/vo8dU6t5VAFYf0w4SQjsv04OJ3Tbbmo7HP+
	 poTO7r99P8IjzoEM2qzkAmuXldgPsljt/60qH78l2y/OYoQ5EN+3spVB92F1wcveIk
	 k5NgQ9ESfR2bg==
Date: Tue, 22 Sep 2026 11:13:02 -0700
From: Oliver Upton <oupton@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Jack Thomson <jackabt@amazon.com>,
	Jack Thomson <jackabt.amazon@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Leo Soares Passos <Leo.Bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 02/14] arm64: Add ESR fault helpers
Message-ID: <arLFLp6keTbFmXMB@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-2-787bd3bc7e3f@kernel.org>
 <arK0N7H1w-pcixba@kernel.org>
 <arK8ZnBSFwmjizuk@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arK8ZnBSFwmjizuk@gremlin>

On Tue, Sep 22, 2026 at 06:45:43PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 22, 2026 at 10:00:39AM -0700, Oliver Upton wrote:
> > On Tue, Sep 22, 2026 at 03:17:56PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > Add helper functions which operate directly on an ESR value rather than
> > > trying to access the register itself.
> > >
> > > These mirror equivalent KVM vCPU wrappers in kvm_emulate.h and allow those
> > > wrappers and KVM's stage-2 fault handling to operate on a plain ESR value.
> > >
> > > This is needed to later generate a synthetic fault for the stage-2 page
> > > table pre-faulting mechanism.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/esr.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 44 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > index f816f5d77f1a..9c0205983d9a 100644
> > > --- a/arch/arm64/include/asm/esr.h
> > > +++ b/arch/arm64/include/asm/esr.h
> > > @@ -437,6 +437,50 @@
> > >  #ifndef __ASSEMBLER__
> > >  #include <asm/types.h>
> > >
> > > +static __always_inline u8 esr_get_ec(unsigned long esr)
> > > +{
> > > +	return ESR_ELx_EC(esr);
> > > +}
> >
> > Why do we need to wrap the macro in an inline function?
> 
> It seemed like a more consistent way of doing this but looking through the code
> ESR_ELx_EC() is referenced directly in quite a few places so will swap out.
> 
> >
> > > +static __always_inline bool esr_trap_is_iabt(unsigned long esr)
> > > +{
> > > +	return esr_get_ec(esr) == ESR_ELx_EC_IABT_LOW;
> > > +}
> > > +
> > > +static __always_inline bool esr_abt_is_s1ptw(unsigned long esr)
> > > +{
> > > +	return esr & ESR_ELx_S1PTW;
> > > +}
> >
> > This helper doesn't make a ton of sense outside of KVM, since
> > ESR_ELx.S1PTW is RES0 (not RAZ) outside of a stage-2 abort.
> 
> OK, kvm_emulate.h better?

Works for me, thanks!

Best,
Oliver
