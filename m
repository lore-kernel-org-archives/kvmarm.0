Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4AD5FBB7
	for <kvmarm@lists.linux.dev>; Wed,  6 Mar 2024 10:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709720321; cv=none; b=ryREPsUwVsl3N8Uf52Rf2PgNN+X/zlyuzBgfuYhA93gng4RsTEFXfGONpJIHIrsGmD4i6PLEjJGeuFuhZDJu3yRyrhDZp7DqUZoUwKGo8k59/GcuZmozdnBobTApRaqBFyszpQco/pZSOnuQmuvxmgC9YLj57QvjEoqaFpIFQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709720321; c=relaxed/simple;
	bh=nGB4r5hIBxEJMc7nwYA6h2cs7abokd1k2+jz64lHvYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGDDO/5/bqBUaTFboqKe1asGFyYdEUGoFqavH+KzT/eZR9RI151Rzx2eRsh83G9axfhpKwNmSfT7vo2+Uhwe1rneP886LrCFk1fmESmm4O3aoUEDuijqSfZSJ5MpRyDyUpsX3hzbotKCrfPUwBOl53fS1ximnQV7Jay/L62NEg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XrOMv/+X; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XrOMv/+X"
Date: Wed, 6 Mar 2024 02:18:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709720317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AtdpGJ1FZmUpFmjQC0Ap/CoE88KfhFzTlV6tzJv/Lfw=;
	b=XrOMv/+X1TkzcdARIwC/hyPs1dRnXyd1lyts9QYRs1fWv+Cno0WShOHbbztq+OVzV2EbUk
	+R6EjkC36Z7m6n9LVkelE/hViuhRsc2Ta8At2bHed+uGLEIj7tmtL3miyd3eDmZ3ft1qGY
	oRWsuHJ6AXl4zfUS1f509ooNFw5VKO8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: pkvm: Actually enable/disable PMU events
 when running vCPU
Message-ID: <ZehC96E3Y8lgidOC@linux.dev>
References: <20240305184840.636212-1-oliver.upton@linux.dev>
 <20240305184840.636212-2-oliver.upton@linux.dev>
 <87a5nbr7x3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5nbr7x3.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 06, 2024 at 10:06:32AM +0000, Marc Zyngier wrote:
> On Tue, 05 Mar 2024 18:48:38 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > +static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > +
> > +	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
> > +	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
> > +
> > +	/*
> > +	 * The host's PMU context cannot be trusted for protected VMs. Refer to
> > +	 * hardware to determine which PMCs need to be disabled/enabled on vCPU
> > +	 * entry/exit, respectively.
> > +	 */
> > +	if (kvm_vm_is_protected(kern_hyp_va(host_vcpu->kvm))) {
> 
> This looks wrong. We should never rely on *host* controlled data to
> make a decision at EL2 in the pKVM case. Use of this helper at EL2
> should be constrained to the hyp view of the kvm structure only.

I should've spelled this out explicitly. Looking at what we have
upstream, there's no hyp-controlled view on a VM's protection (yet).

I had imagined this hilariously wrong expression was a placeholder for
pKVM folks, much like we have in early_exit_filter() and
kvm_get_exit_handler_array(). But that's no good, and I probably
should've added one myself that can be updated with the 'right' thing
later on.

> The other thing is that most of this code is going to be thrown away,
> hopefully soon... (hint, nudge...).

I was hoping Will could provide some insight on whether or not the
'real' pKVM hyp state management carries the same bug. Nothing wrong
with fixing what we already have though...

-- 
Thanks,
Oliver
