Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9282027145E
	for <kvmarm@lists.linux.dev>; Thu, 10 Jul 2025 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752164581; cv=none; b=V1r3cTx2++CNWG++QTiH0oJVIBUZM1D0fZGZDn4WdkdUGE7XzJ2ePLRzWJKcdYYY/zqfDuZWvNTcPVeH2+nKsze4pppPjFpygNikcPwAM10DYe0XNIiDqg4I0TFMj/XDQ91oFTyTszVUAIjzgUdADerA6QpgaSqM+uwdpiETZt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752164581; c=relaxed/simple;
	bh=egXs/h6TJ5e0WNrsSuWm0qCC04MbxgUcU+n1LmpoCJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKpBCa0NwWPJFJxjGT1t4TFcarrLGOp/UxuDpyh+RFSnxKKBz6PIepLMlpTrma1vVWHebv3jBlCeJ6XQKiZLlbM2CnBNKHff+mn3HcRlKHf/OS6C86PQIA1bWTJ34W4WaLRWjRxcdaLhL/JHIJ0bIKpukkkaV86PGfy0ZrUkOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bu5W6y4J; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bu5W6y4J"
Date: Thu, 10 Jul 2025 09:22:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752164576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cUQo1M1Ufg0cd8GMAEIRN65VukqumJAMqw2POUQlyxI=;
	b=bu5W6y4Jf7edtpwGc2xlQQAuCL7Ge/iP4NuAzUh31Bi9QCSxp3Rnb7yx9kEWJvp6sDFb5F
	TMA3H5KQb6BX4cuwWSxXNJzI5PvF/s+6tNwMetwxhV/rSvUi0yn/77Dn8g2gGVGPFXnTY+
	CqhMR8Qq5t6JP/IrZVwnj8paIFoKa8E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ben Horgan <ben.horgan@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v4 1/6] KVM: arm64: Disambiguate support for vSGIs v.
 vLPIs
Message-ID: <aG_o11qaUwJYfvfE@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-2-oliver.upton@linux.dev>
 <e421874a-322b-4da1-9fe9-f3a94e9036f5@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e421874a-322b-4da1-9fe9-f3a94e9036f5@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 10, 2025 at 09:59:14AM +0100, Ben Horgan wrote:
> Hi Oliver,
> 
> On 7/9/25 22:14, Oliver Upton wrote:
> > vgic_supports_direct_msis() is a bit of a misnomer, as it returns true
> > if either vSGIs or vLPIs are supported. Pick it apart into a few
> > predicates and replace some open-coded checks for vSGIs.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >   arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
> >   arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
> >   arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
> >   arch/arm64/kvm/vgic/vgic.c         |  4 ++--
> >   arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
> >   5 files changed, 23 insertions(+), 12 deletions(-)
> > 
> [snip]
> >   		/* Dist stays enabled? nASSGIreq is RO */
> > @@ -133,7 +137,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
> >   		if (is_hwsgi != dist->nassgireq)
> >   			vgic_v4_configure_vsgis(vcpu->kvm);
> > -		if (kvm_vgic_global_state.has_gicv4_1 &&
> > +		if (vgic_supports_direct_sgis(vcpu->kvm) &&
> >   		    was_enabled != dist->enabled)
> >   			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
> >   		else if (!was_enabled && dist->enabled)
> > @@ -178,7 +182,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
> >   		}
> >   	case GICD_CTLR:
> >   		/* Not a GICv4.1? No HW SGIs */
> > -		if (!kvm_vgic_global_state.has_gicv4_1)
> > +		if (vgic_supports_direct_sgis(vcpu->kvm))
> Missing negation.

Oops, very well spotted. Thanks Ben!

Thanks,
Oliver
