Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D751B154BF5
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 20:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734554210; cv=none; b=bTHDEwZc1ihW7OVLI3+seKH74zqD/bxsZ3+fKl0lw/4gP10tv2KAh1VzLMS9P4UIacnGsvho2bohQliC0DnU5ribtKiDllYw/KS8g9vojLbaqrQATGCfQOCJV13JhFpK14PD/LRYN797U4IihDnXckImm44sMEJoDVPgRCasemE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734554210; c=relaxed/simple;
	bh=Tpw6S761iO8x2S4jmRvodQBmVu0JhevnglBIB+94/Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slg35OalXgoQBNtwB4iVfJu9q/bPmoUD22YXaoluoVoPN0LYJSetPgj0S9SdjvzBBJyQ5Zh7KfpM7pQ6pyJxOgI3/xHtbeyWKVrrmZ57PJj53pmvCq5VCd+bxa8y1exErp1Ug7ddM0ZBAxjo76nk9AkEbhGTifRoxiVnsX6z1ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r6PuCsFL; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r6PuCsFL"
Date: Wed, 18 Dec 2024 12:36:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734554205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7WbTkP6RqlE5rWSkc72WvweX2+xrEmwlBCpERx3uqjE=;
	b=r6PuCsFLcvbVjw+4exy3HaLbJDX3gXl2uiLkuH9VM9rkwF0+gcwkFn2/noJ7Ju2ywLIn2L
	gd/wJ3xm1SSvg55k8nj8IsJuWwURWIftDAFu8PtzNh0G+DRzai7eANCuDwsQSdkDqXu6zO
	oyrfqlV4aYasIrY46LMt8+kEd54PC0M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>
Subject: Re: [PATCH v3 10/16] KVM: arm64: Use debug_owner to track if debug
 regs need save/restore
Message-ID: <Z2MyVmxBb_8WtWcH@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
 <20241209180926.2161373-11-oliver.upton@linux.dev>
 <86frmkrhcl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frmkrhcl.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 18, 2024 at 06:11:54PM +0000, Marc Zyngier wrote:
> On Mon, 09 Dec 2024 18:09:20 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index f84306b11261..5b8982bcc0bb 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -621,40 +621,12 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
> >  	}
> >  }
> >  
> > -/*
> > - * We want to avoid world-switching all the DBG registers all the
> > - * time:
> > - *
> > - * - If we've touched any debug register, it is likely that we're
> > - *   going to touch more of them. It then makes sense to disable the
> > - *   traps and start doing the save/restore dance
> > - * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
> > - *   then mandatory to save/restore the registers, as the guest
> > - *   depends on them.
> > - *
> > - * For this, we use a DIRTY bit, indicating the guest has modified the
> > - * debug registers, used as follow:
> > - *
> > - * On guest entry:
> > - * - If the dirty bit is set (because we're coming back from trapping),
> > - *   disable the traps, save host registers, restore guest registers.
> > - * - If debug is actively in use (DBG_MDSCR_KDE or DBG_MDSCR_MDE set),
> > - *   set the dirty bit, disable the traps, save host registers,
> > - *   restore guest registers.
> > - * - Otherwise, enable the traps
> > - *
> > - * On guest exit:
> > - * - If the dirty bit is set, save guest registers, restore host
> > - *   registers and clear the dirty bit. This ensure that the host can
> > - *   now use the debug registers.
> > - */
> >  static bool trap_debug_regs(struct kvm_vcpu *vcpu,
> >  			    struct sys_reg_params *p,
> >  			    const struct sys_reg_desc *r)
> >  {
> >  	access_rw(vcpu, p, r);
> >  	if (p->is_write)
> > -		vcpu_set_flag(vcpu, DEBUG_DIRTY);
> >  
> >  	kvm_debug_set_guest_ownership(vcpu);
> >  	return true;
> 
> Sorry for stating the same thing again, but this is a repeat of [1].
> Should I add this on top?

Argh! No, thanks for catching this (again). I really ought to make sure
I squash fixes in when I say I do...

-- 
Thanks,
Oliver
