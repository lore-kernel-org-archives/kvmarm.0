Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DEB386C3D;
	Mon,  6 Jul 2026 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783351143; cv=none; b=CNblWKGtKSgK1iE6s+8fU7pmwgsxhUtiQfvIR84XKVIKSZRiKV9N80qWVkKo3j0iiQS7UMbU+nxcKR2n5+RkqvIZwSUYdioJd+5CAKkRQEA/UN3ew+shoY1XRGuQzuDU9Gk7lpGzTBG3o+QhAVIe6PxNTWzSjPK8ArOfMZyhAMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783351143; c=relaxed/simple;
	bh=6bhj6yZdNf/YLAFnO/0QsUOdJD9aPj66T9AbLiif7Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTGEsGeg3EqnBEftgBTQGYvv5cEXwYzRogZx6MXA7YG+RALMMFmJIK/UAX9NJZ9frghU11BtQdPvCEV7tpgLxMzd+UaaNpqgne3WPlGxfq9QKuF78DWWz5kOLJBDxEAX3sXo1unRR2SO9l35DdshvNoyAVeV16xpbELueRgi2GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6BYkVFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6BYkVFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FEE1F000E9;
	Mon,  6 Jul 2026 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783351139;
	bh=eJJ3rvH96jfH7HjWknKZbz82wIRHH2RKrLCdelmI5J8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C6BYkVFJHX6A1VEPT5mQ0tlXcYmjOWDyoBg6YMcHWGE1q4Y13E1pOvLE18YjW6Jj3
	 UM4ByFlZGrTSybPjJw/9zHEDgDtozySUI+SFpbQnvYQlwcmFlHzn8yTOP/mrwYyPz+
	 DSUYSEdPsmHOugxlfGHQwrgqoiBHcXXyJJUxBykyZdJQ5cVM42wRo9q0UT0Hqdl6UG
	 /lYEyC87FBcUH4VddMQmHMp3+ksfutsNVJUVR1nTH1VcYjh+Qf1MFTQ9MzY5wZuouo
	 EQYtio/NL0599nwDhtUYKgBf13lvRinxTPvvwYyNzUTckYvy66ih09uxuLQPEeKu9F
	 Eez1DZa+yFcqA==
Date: Mon, 6 Jul 2026 16:18:52 +0100
From: Will Deacon <will@kernel.org>
To: Tangnianyao <tangnianyao@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>,
	oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	"guoyang (C)" <guoyang2@huawei.com>,
	"huanglingyan (A)" <huanglingyan2@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
Message-ID: <akvHXN6Gynjw1n8m@willie-the-truck>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
 <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
 <292b5734-9005-6db0-da08-3da04628e620@huawei.com>
 <86o6gkpokm.wl-maz@kernel.org>
 <21eb51aa-443c-4d08-b4dd-3f813bbc9880@huawei.com>
 <86jyr8pkw8.wl-maz@kernel.org>
 <5685cdb9-95d8-9ead-4d24-d6ad06dd9547@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5685cdb9-95d8-9ead-4d24-d6ad06dd9547@huawei.com>

On Mon, Jul 06, 2026 at 10:15:04PM +0800, Tangnianyao wrote:
> Two SMT threads(PE0,PE1) on the same physical core share TLB.

For that to be observable, I think both PEs must be configured with CnP
enabled.

> VM0 has 2 vcpus, vcpu0 and vcpu1 that share all architectural context
> except the address translation context.
> 
> Vcpu0 may observe TLB entries that are supposed to be private to vcpu1
> in the following case:
> 
>     PE0(core0,smt0)         PE1(core0,smt1)
> vcpu0 load           
> vcpu0 va->pa0        
> vcpu0 put            
>                                        vcpu1 load
>                                        vcpu1 flush local tlb
>                                        vcpu1 modify desc to va->pa1
> vcpu0 load
> vcpu0 hit *va->pa1*

If they're "supposed to be private", why have the vCPUs configured CnP
at stage-1?

Will
