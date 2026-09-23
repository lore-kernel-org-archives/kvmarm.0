Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF533F86FB
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182012; cv=none; b=QeFs76m8aLm2e/Kfcsw/kadqkwD0AgVgCR3oMR0PF6kxWegcHS/YF2oqZLA/KAhCKormkP8bAPyU/yeZeLyb3o19CJvetjQtyK5ko/3xpX9NFpxIecdjTZRXceZdPbBDFv5zH2+l+jggn8GwkhY2aRyHYrD5xxGnDxeQOm4GQjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182012; c=relaxed/simple;
	bh=xE7aIcCdoxZ77tjspcGqIkYlBdrJPyR+SebhU3abYIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+508LrrWyCdcn67Cw9QfwF5JeE8IfRQceaT5FDdIrQSGvo7WZ2o1wrQhKH1aStYO5AXm54HiRoSXL8otO+FaMFRwDqansmG3VAS2h3ZoxCJd1ueN6F15PdTx4z/cbFMpeVBclCRYbH8gcCigbyiiL98ZhWPYIBn7YKjX8CLg8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VrAOW1ik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VrAOW1ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6621F000FF;
	Wed, 23 Sep 2026 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790182006;
	bh=USv/TSMbul4KfLclS5I9G5LpoxQtVzuJiMwF6EvsWPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VrAOW1ikJtp2tv9weqY21QThRNyoAGK1d5HlEeD2ZZwOBbjRwKra+KceJto9hgsJH
	 4NDLZZqH5OshtIQAaoqnW5LYe96pW+7kunE9W1hBk1wJMWtt5DHvUzuCVfS3aVvurd
	 IjaIlX9sSKrxzefJ1ZuIH8LhPewR3lovJMGhV92zYt4h5G9pazpMLBVjNKAyLR7bXd
	 GR21ah3nh99lsMSXY1wNSjEeabr8ccHP+yfPFigZhhZ3ioX4N3uTiI6bMUOBXB56PO
	 Edqsg0vm2GLdI8jVUOO9SybH3aUCdeTz75ctRvnElzwD6fZ3U40leXOWEpVJ4Mh5HR
	 xCmHVa3aXDIqg==
Date: Wed, 23 Sep 2026 09:46:45 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 07/22] KVM: arm64: nv: Set dirty state at stage-2
Message-ID: <arQCdTIbVRawhq3a@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-8-oupton@kernel.org>
 <arPdh3ybzm71k07O@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arPdh3ybzm71k07O@LeoBrasDK>

On Wed, Sep 23, 2026 at 03:09:11PM +0100, Leonardo Bras wrote:
> > @@ -518,6 +540,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
> >  			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
> >  	wi->ha = vtcr & VTCR_EL2_HA;
> >  	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
> > +	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
> 
> Should we not check if the feature is available before setting the HD bit?
> Or does it being RES0 mean that it can't be 1 in any case? 
> (The Arm ARM's Glossary seems to allow direct writes to RES0 sometimes, 
> IIUC)

VTCR_EL2 is a sanitised sysreg, the enforcement of RESx happens
implicitly on read... Start looking at config.c and follow the masks.

> >  }
> >  
> >  int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
> > -- 
> > 2.47.3
> > 
> 
> 
> IIUC here you add the hd bit for the walk info, and set it based on VTCR, 
> using it to decide on automatically uptating the dirty-state if it's also a 
> write fault and the page is writable.
> 
> Then you move the the kvm_walk_nested_s2() and AF testing code to after the 
> functions that fill the out struct, so you can use it to figure out the 
> writable part used above.
> 
> Everything seems right, but one part:
> 
> IIRC, HAFDBS would need HD=1, and DBM=1 set to be able to properly update 
> the dirty bit. DBM should be the 'writable' here, but you are using S2AP[1] 
> to decide on writable instead, which I understand to be incorrect according 
> to documentation. I am sure you have reason for that here, thogh.
> 
> On the other hand, since you are effectively making dirty=writable in a
> previous patch, the HAFDBS mechanism here seems not to work at all:
> 
> compute_s2_permissions(): trans->writable = ws->desc.S2AP[1];
> ('trans' is 'out')
> handle_desc_update() 	: new = ws->desc;
> 			  if (... && out->writable)
> 				new |= S2AP[1];
>  
> So 'new' will only get the dirty bit, if it already has the dirty bit. :(
> 
> (I can be missing something here, though)

Patch ordering could be better here, have a look at patch #8.
compute_s2_permissions() will interpret the DBM bit as writable when
VTCR_EL2.HD is set.

Thanks,
Oliver
