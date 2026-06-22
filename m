Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451112E7F39;
	Mon, 22 Jun 2026 17:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782148694; cv=none; b=NsowRtMGHUxMUqPOH0DS/9LQa84dK+RfNqCQ+OI5u2Upa0JrQhERllxNgHTXBgBe/ULe6BdVP1C7RB2HtfW8j8D0W3BIy59kghxhYEOvwC/ty0TPR3+aX3OHFvYsXqUWt7/ASOGOJSbJTCbqOgfISynbH/V9I2g2qizGeXfz4HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782148694; c=relaxed/simple;
	bh=BPBVlQRhTovC9q2tbSui95zXgj4QbMnoXVAtnT9LsSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V92Sz2HiSPH5qOcTvDGYLVgVnXwoUdjSRlfoY23HjsgLSELuBcMCZmKYj3flhtLwE44uo6OfDgrmF5KbKn7fUc2pv4jyDp2+/Z506T52zAJA/mZnqQO5Wt7+Yc1JYkHKoq1TmoR2ejnP9DtnsN0OzI3gVTcAIcXf0rdHmSJNoAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geKekISS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geKekISS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EE41F000E9;
	Mon, 22 Jun 2026 17:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782148692;
	bh=1cPvP81H1b5BRIhxAghvo1wc+boTiYB73/wR5pZYpvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=geKekISSvrMZhJnlCjFCeNlCDDPvA+sod1Q0kIN2u2s7o/YAGeC/YVOZYLT0oXFIJ
	 lGQtnQFPfWKSRF6OxX3xXMgyzIc5Ada16O2t5lcMXaw8bmjAMGdV8FgB8hIhExw8AM
	 DB9IfrIsvb8Fgvext8/QZMFmfi3AS3y4AvMmzatK5cBUP6GHpDjFuEQl8wzgH5cy2a
	 sUumPrIV0+9HGX7tCMRoIm2HzgRQNBuKqOPKEJflOfA8CF6Pz75AWa2pASF3Q4fdZE
	 GxCJeYP+w+vtWakHeHCyFvJZkw/Rh3AgkkAXUvgqxAwCGHoN+8pvXVoAUs1EFV+0Az
	 rR6yXFFR5fl6w==
Date: Mon, 22 Jun 2026 10:18:11 -0700
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 3/5] KVM: arm64: nv: Re-translate VNCR before
 injecting abort
Message-ID: <ajluUzbMsicbJ5Ci@kernel.org>
References: <20260618234207.1063941-1-oupton@kernel.org>
 <20260618234207.1063941-4-oupton@kernel.org>
 <20260619000034.7F2511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619000034.7F2511F000E9@smtp.kernel.org>

On Fri, Jun 19, 2026 at 12:00:33AM +0000, sashiko-bot@kernel.org wrote:
> > -			handle_vncr_perm(vcpu);
> > -			break;
> > -		case 0:
> > -			break;
> > -		}
> > -	} else {
> > -		WARN_ONCE(1, "Unhandled VNCR abort, ESR=%llx\n", esr);
> > +	case 0:
> > +		perm = kvm_is_write_fault(vcpu) ? vt->wr.pw && vt->hpa_writable : vt->wr.pr;
> > +		if (!perm)
> >  			handle_vncr_perm(vcpu);
> > +		break;
> >  	}
> >  
> >  	return 1;
> 
> [Severity: High]
> Does removing the -EPERM loop breaker introduce a host CPU livelock for
> Write-Only guest VNCR mappings?
> 
> If the guest configures a Write-Only mapping, kvm_map_l1_vncr() falls back
> to mapping it as PAGE_NONE. When the hardware accesses the fixmap, it triggers
> a Data Abort. KVM then traps and re-translates the mapping.
> 
> Because vt->wr.pw is true, the perm check evaluates to true, and KVM returns 1
> to resume the guest instead of injecting a fault. The hardware will then fault
> again indefinitely.

Advertising NV2 to the VM should've been conditioned on hiding S1PIE
because there's no way to fix this. As the access passes the guest
permission check, we have no fault that can be injected for stage-1.

> [Severity: High]
> Also, does calling kvm_translate_vncr() unconditionally request FOLL_WRITE
> on a write fault without verifying if the guest's own Stage-1 mapping
> actually permits writes?
> 
> In kvm_translate_vncr(), __kvm_faultin_pfn() is called with FOLL_WRITE if it's
> a write fault. If the host memslot happens to be read-only, __kvm_faultin_pfn()
> fails and returns -EFAULT.
> 
> This error bubbles up to the switch statement above, which injects an External
> Abort into the guest. Should the guest instead receive a Stage-1 Permission
> Fault if its own Stage-1 translation does not permit writes, regardless of the
> memslot permissions?

Again, this is below the bar of stable fixes (intent of this series).

Thanks,
Oliver
