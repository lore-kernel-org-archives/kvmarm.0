Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26671DDA17
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 10:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737024075; cv=none; b=JY/ynk8nCszPVwj8/roEZqBZlLemHYc3rAv/8irdtilBllgGH/K/scSbowURg2oESUnSbJyGMgWbcYxa/TuWYU4i7iTcgP42v8w8DsF3kWnzEZF6zz/kt4XJCVy1xQTfLSl6MemoPZdI3CLC/1KCuM1ye2k7aDsON/J4fCUAzgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737024075; c=relaxed/simple;
	bh=ovrQiNl+EzPno96GYFJ9gfyXLQAyGXjWYEzGkkCaqvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ON1/5bAkZxNZ7f1pdcyMSDrKXF6dm4DeC8j6DA0Xof/EACuIFljRTTNkMNRd3Ax+fxZeySBmwCabJH36qBQHQW8R8oNSiIIk8j+qwa7bixX2QklIvNxDGRFm89ziGK82m+UZZTSBL728fO98uTp0pWwgu3SIbt781yo+T20f8C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C98111FB;
	Thu, 16 Jan 2025 02:41:40 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.2.80.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 275473F77D;
	Thu, 16 Jan 2025 02:41:10 -0800 (PST)
Date: Thu, 16 Jan 2025 10:41:07 +0000
From: =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com,
	will@kernel.org, maz@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v1] arm64: Add TLB Conflict Abort Exception handler to KVM
Message-ID: <20250116104107.GA17031@mazurka.cambridge.arm.com>
References: <20250110172411.39845-3-miko.lenczewski@arm.com>
 <Z4Fr1HkKCm9AXSIA@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z4Fr1HkKCm9AXSIA@linux.dev>

On Fri, Jan 10, 2025 at 10:49:56AM -0800, Oliver Upton wrote:
> On Fri, Jan 10, 2025 at 05:24:07PM +0000, Mikołaj Lenczewski wrote:
> > Currently, KVM does not handle the case of a stage 2 TLB conflict abort
> > exception. This can legitimately occurs when the guest is eliding full
> > BBM semantics as permitted by BBM level 2. In this case it is possible
> > for a confclit abort to be delivered to EL2. We handle that by
> > invalidating the full TLB.
> 
> typo: conflict
> 
> Also, a bit of a nitpick, but mentioning that TLB conflict abort routing
> is implementation defined when S2 is enabled is valuable information.
> 
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
> 
> I'm not sure I follow this.
> 
> At this point we've taken a TLB conflict abort out of a specific
> hardware MMU context, and it's unclear to me why a conflict abort in one
> stage-2 MMU has any bearing on the other stage-2 MMUs that could be
> associated with this guest.
> 
> Even in NV, KVM is always responsible for the maintenance of hardware
> stage-2 MMUs. So stage-2 TLBI elision in the guest hypervisor should
> not lead to a stage-2 TLB conflict abort.
> 
> TLBI ALLE1 is a larger hammer than what's actually necessary here. Could
> you perhaps introduce a new invalidation routine,
> __kvm_tlb_flush_vmid_nsh(), that does a TLBI VMALLS12E1 behind the
> scenes?
> 
> If an NV guest is playing games at stage-1 across VMIDs then it gets to
> suffer the consequences (additional TLB conflict aborts).
> 
> -- 
> Thanks,
> Oliver

Apologies for the very late reply. Thank you for taking the time to
review my patch. Will fix the type, and work on fixing the logic there
to use a TLBI VMALLS12E1.

-- 
Kind regards,
Mikołaj Lenczewski
