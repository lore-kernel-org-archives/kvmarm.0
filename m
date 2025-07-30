Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5881D61BC
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753897573; cv=none; b=Sgf/i6apUuduL7dH0phVJ3Zq3dWkhcPiyYR60I8XfewE3M7/cpWZeNiiE0ViJNtxTrQCu6Fy8fFrdON+iMc1yuxFomBnTNlXumzhb4g4iAitV6sTytYk4yE7PS7slkMIk9PEW4k5s6k3Pw5J38gNfjLqAQMrpwUGGrdpFKkjjrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753897573; c=relaxed/simple;
	bh=q0+DKK/Xz8SIvvmDyx+kHFhJ0e61nTuqLzo66JlQnvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5PlZSyeUp4pKHmXDEdbFaa2RaiN9zMTnNcunKo8YItVa2v0QnQzHzyS8nFAEnIsFq5NY3dVFMUgRgltmLCCusz9SxJGHcQbTM5THUVCLsvPlTgbVBAEneAqJ8dBGRkEnC/VdQh9Z+CcLhQe42yI9M9Iv/hnpj0iplwviEvycjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K/r8usxv; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K/r8usxv"
Date: Wed, 30 Jul 2025 10:34:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753897568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LIvzPdX709pHAMdScvlkXvnyfkT8vGL4ieYGkxtQG5o=;
	b=K/r8usxvIQI/dOwBMseYqTK1s2KVEuSCYcnZIHkfRy8IgXwM/rbObCm+f1WHKavr9fH2Gj
	GjX3VCgHJhK3Cn44+hz+xm7sQ4dwe9UvMJ0OSAviIgizpZJ8RtVHYKQgeoLP76XLEuU8t5
	6+cF3xUaOBobLi1FAhZkmTzWsk8bSd4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH] KVM: arm64: nv: Handle SEAs due to VNCR redirection
Message-ID: <aIpXnURI112162jC@linux.dev>
References: <20250729182342.3281742-1-oliver.upton@linux.dev>
 <8634ae80lx.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634ae80lx.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 30, 2025 at 10:54:50AM +0100, Marc Zyngier wrote:
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index efb37aad11ec..4f741ba24b48 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1289,6 +1289,9 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
> >  
> >  	BUG_ON(!(esr & ESR_ELx_VNCR_SHIFT));
> 
> Urgh. This is hilarious. We don't trigger this thing by pure luck (13
> is a lucky number, apparently...). I'll post a separate fix for that.

LOL! I totally missed this when I wrote the patch. I'll grab your fix,
thx for posting.

> >  
> > +	if (kvm_vcpu_abt_issea(vcpu))
> > +		return kvm_handle_guest_sea(vcpu);
> > +
> >  	if (esr_fsc_is_permission_fault(esr)) {
> >  		inject_vncr_perm(vcpu);
> >  	} else if (esr_fsc_is_translation_fault(esr)) {
> > 
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Appreciated :)

Thanks,
Oliver
