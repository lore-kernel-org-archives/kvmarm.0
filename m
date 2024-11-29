Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8305345C14
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 07:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732865213; cv=none; b=NdgaKWYHT8OWXa4Ut1Xrjd/LXFO22NmWYkjwV5qTA6KgBPUlH1Pz2gAy2SYdX4ySvPRPhK8WmOdhtIEFC3SwsDV8mS+q8pQbqAkcmK+zbHMXcwp0b/paBEQftd3g4UOaJjopJQhkCRqt9V+vtTaAgA2rPT/Nw4Xv7pBFq9nnRbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732865213; c=relaxed/simple;
	bh=2sXAxscyFEEY3aNBPrB6zBL9wfwg975eEleczH6muYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkTlDMwHVdR8DfBDLARRSk1p38FLzwLz3c+TmkGFzwytjc+5n+b6EiL7uzaqjPgC+VIb7snzZFyvRCslfTKDF0SS52qgfCGuqgy9GGMDW25mnbgZRuA36/TUIfvaoKoEqF/vCI13Y23/u8TcK7/NJAdVjQB369w/5UzFYljheKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ORfqKRo/; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ORfqKRo/"
Date: Thu, 28 Nov 2024 23:26:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732865209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=44JcxRae4fQUKGTMGOSQkaQ/3AVkh0KeoIfo8IhfQzk=;
	b=ORfqKRo/Fz7VA6LoN70t9lJN7KUPidLpcj1opnibycK6j2PCYkR4ny2wV6ac+fGJ0roO2k
	hFQ6zGpXMy9Xk6yOZ0fcYl90GoUpHweFfycD12Jnh2aKfcul1RcN+QRyGV0f6JXLg7Ntpo
	2uJwEs/AHZEBsv1toCKNgkgUZYHeCGM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mizhang@google.com,
	alexandru.elisei@arm.com
Subject: Re: [PATCH v2 02/16] KVM: arm64: Get rid of __kvm_get_mdcr_el2() and
 related warts
Message-ID: <Z0lsr3PwMULIst14@linux.dev>
References: <20241115224924.2132364-3-oliver.upton@linux.dev>
 <gsntcyif179t.fsf@coltonlewis-kvm.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntcyif179t.fsf@coltonlewis-kvm.c.googlers.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Thu, Nov 28, 2024 at 07:35:10PM +0000, Colton Lewis wrote:
> Oliver Upton <oliver.upton@linux.dev> writes:
> > -/**
> > - * kvm_arm_init_debug - grab what we need for debug
> > - *
> > - * Currently the sole task of this function is to retrieve the initial
> > - * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
> > - * presumably been set-up by some knowledgeable bootcode.
> > - *
> > - * It is called once per-cpu during CPU hyp initialisation.
> > - */
> > -
> > -void kvm_arm_init_debug(void)
> > -{
> > -	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
> > -}
> > -
> >   /**
> >    * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
> >    *
> > @@ -94,7 +77,8 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu
> > *vcpu)
> >   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
> >   	 * to disable guest access to the profiling and trace buffers
> >   	 */
> > -	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
> > +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
> 
> MDCR_EL2_HPMN is not defined

As of commit 641630313e9c ("arm64: sysreg: Migrate MDCR_EL2 definition to
table") the field definitions for MDCR_EL2 are generated from the sysreg
table.

The generated header defines this macro.

-- 
Thanks,
Oliver
