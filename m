Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57911E3DC8
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 16:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734107082; cv=none; b=WJlv1rDV7AnktqYvL5kQRfTrO1UPQfd4inVL/k+duFKH/63JAX8m8svUKacegLwmiomuCnKSgkmfqo2sZ9rbNf9SublItONyfGmx0ZdpKBBMulczBeS1JKU61DpDHqFuSJsgFwWu2ZM6VlxH9cFPySBGwtRy41345nEJU2tZ5RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734107082; c=relaxed/simple;
	bh=5XEd+exWKEpwz2Vn+qFmO3TGdmdDBWvZP2sAvnwEOQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+g55CU42rKXJbO5e1fahR4wXlkNVIg9m226gsvpXdiGAgp7A9JwlI4yQZA/M1bP6xDxnC8YlEjuqv1cXs77Ua4QOXvyl1gucSm2rXPHa+57xgHLHrpC9YEXT6X4v6/uA30POay+xIks7FutQCoAU+zJQreTT1Q/Vq+ND5L47Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 545731480;
	Fri, 13 Dec 2024 08:25:08 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.1.196.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A9A1B3F5A1;
	Fri, 13 Dec 2024 08:24:38 -0800 (PST)
Date: Fri, 13 Dec 2024 16:24:36 +0000
From: =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org,
	corbet@lwn.net, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [RESEND RFC PATCH v1 1/5] arm64: Add TLB Conflict Abort
 Exception handler to KVM
Message-ID: <20241213162436.GC30314@mazurka.cambridge.arm.com>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
 <20241211160218.41404-2-miko.lenczewski@arm.com>
 <86o71irucr.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86o71irucr.wl-maz@kernel.org>

Apologies again for spam (replied instead of group-replied).

On Wed, Dec 11, 2024 at 05:40:36PM +0000, Marc Zyngier wrote:
> On Wed, 11 Dec 2024 16:01:37 +0000,
> Mikołaj Lenczewski <miko.lenczewski@arm.com> wrote:
> > 
> > Currently, KVM does not handle the case of a stage 2 TLB conflict abort
> > exception. The Arm ARM specifies that the worst-case handling of such an
> > exception requires a `tlbi vmalls12e1`.
> 
> Not quite. It says (I_JCCRT):
> 
> <quote>
> * For the EL1&0 translation regime, when stage 2 translations are in
>   use, either VMALLS12E1 or ALLE1.
> </quote>
> 
> > Perform such an invalidation when this exception is encountered.
> 
> What you fail to describe is *why* this is needed. You know it, I know
> it, but not everybody does. A reference to the ARM ARM would
> definitely be helpful.
> 

You are correct. Will update the commit message.

> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c9d46ad57e52..c8c6f5a97a1b 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1756,6 +1756,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> >  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> >  
> > +	if (esr_fsc_is_tlb_conflict_abort(esr)) {
> > +		// does a `tlbi vmalls12e1is`
> 
> nit: this isn't a very useful comment.
> 

Will remove it.

> > +		__kvm_tlb_flush_vmid(&vcpu->kvm->arch.mmu);
> > +		return 1;
> > +	}
> 
> That's not enough, unfortunately. A nested VM has *many* VMIDs (the
> flattening of all translation contexts that the guest uses).
> 
> So you can either iterate over all the valid VMIDs owned by this
> guest, or more simply issue a TLBI ALLE1, which will do the trick in a
> much more efficient way.
> 
> The other thing is that you are using an IS invalidation, which is
> farther reaching than necessary. Why would you invalidate the TLBs for
> CPUs that are only innocent bystanders? A non-shareable invalidation
> seems preferable to me.
>

You are completely correct here. I had forgotten about nested VMs, and
agree that issuing a `tlbi alle1` is simpler and more efficient. I agree
also on not using an IS invalidation.
