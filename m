Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A574D1DE2A5
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 10:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737024147; cv=none; b=ImDyw8ZULY8yErhS/T20Ah4mmWJk0c5bYXMQ3WdcXThWIzyf3swO7wepyKHNu690dU9u92/NjJBtjrVbZMz3gZEbFSmQbVFRt8OUe6FHFlSOiyTkmPoOxEEObY83rt55nVmX08q+0cV1ExtWsglFqjBrDxYcc5vLqo6myDAUjnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737024147; c=relaxed/simple;
	bh=7rZXtru7PzxMDzyUWKoqiV7OzSEydGVItccBESVxCZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcyB3xMR3cv3Mn9kBhBnzCRaGZ1KwZGaX8NqeEkaBIcGqaAkuMHhsWKr888U1jzcBmN6TibaAzDUs33/3Nr/oVd7HiDrF5tusN1TpQ5DmrwsaUTKbdAsFoRu6ctWd8AOpoHp7U0LzExyi/WK2DtQHI8ZKpRZ4ItNEP4kwf9uZdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6358C11FB;
	Thu, 16 Jan 2025 02:42:53 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.2.80.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EFCF3F77D;
	Thu, 16 Jan 2025 02:42:23 -0800 (PST)
Date: Thu, 16 Jan 2025 10:42:21 +0000
From: =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com,
	will@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v1] arm64: Add TLB Conflict Abort Exception handler to KVM
Message-ID: <20250116104221.GB17031@mazurka.cambridge.arm.com>
References: <20250110172411.39845-3-miko.lenczewski@arm.com>
 <865xmgw1n1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <865xmgw1n1.wl-maz@kernel.org>

On Wed, Jan 15, 2025 at 03:13:54PM +0000, Marc Zyngier wrote:
> On Fri, 10 Jan 2025 17:24:07 +0000,
> Mikołaj Lenczewski <miko.lenczewski@arm.com> wrote:
> > 
> > Currently, KVM does not handle the case of a stage 2 TLB conflict abort
> > exception. This can legitimately occurs when the guest is eliding full
> > BBM semantics as permitted by BBM level 2. In this case it is possible
> > for a confclit abort to be delivered to EL2. We handle that by
> > invalidating the full TLB.
> > 
> > The Arm ARM specifies that the worst-case invalidation is either a
> > `tlbi vmalls12e1` or a `tlbi alle1` (as per DDI0487K section D8.16.3).
> > We implement `tlbi alle1` by extending the existing
> > __kvm_flush_vm_context() helper to allow for differentiating between
> > inner-shareable and cpu-local invalidations.
> > 
> > This commit applies on top of v6.13-rc2 (fac04efc5c79).
> > 
> > Signed-off-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
> > ---
> >  arch/arm64/include/asm/esr.h       |  8 ++++++++
> >  arch/arm64/include/asm/kvm_asm.h   |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/tlb.c      |  9 +++++++--
> >  arch/arm64/kvm/hyp/vhe/tlb.c       |  9 +++++++--
> >  arch/arm64/kvm/mmu.c               | 13 +++++++++++++
> >  arch/arm64/kvm/vmid.c              |  2 +-
> >  7 files changed, 38 insertions(+), 7 deletions(-)
> >
> 
> [...]
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c9d46ad57e52..7c0d97449d23 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1756,6 +1756,19 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> >  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> >  
> > +	if (esr_fsc_is_tlb_conflict_abort(esr)) {
> > +
> > +		/* Architecturely, at this stage 2 tlb conflict abort, we must
> > +		 * either perform a `tlbi vmalls12e1`, or a `tlbi alle1`. Due
> > +		 * to nesting of VMs, we would have to iterate all flattened
> > +		 * VMIDs to clean out a single guest, so we perform a `tlbi alle1`
> > +		 * instead to save time.
> > +		 */
> > +		__kvm_flush_vm_context(true);
> > +
> > +		return 1;
> > +	}
> > +
> 
> This is broken. At this stage, you are preemptible, so whatever
> invalidation you are performing might be happening on the wrong CPU
> (and I really don't want to see a broadcast invalidation).
> 
> I really don't see why this can't be handled as a fixup in the inner
> run loop, which would save *a lot* of cycles and do the right thing.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Aplogies for my very late reply. Thank you for tatking the time to
review my patch. Will work on this.

-- 
Kind regards,
Mikołaj Lenczewski
