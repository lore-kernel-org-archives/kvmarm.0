Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B63225D6
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 21:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453304; cv=none; b=IX1og0BfXv3BUsIcwfbmPpQJQ3i8fooiopv6qPBn63fHPfmFGH0l2joscboIlJI66W66Kg8HAS8Et/sqLOtwj55kvKh+AJi5OylaPH/Yg8HgclwVN46bNTh8ie9X1y4Jvu9gTxCAtVMTd7ARbw81ZUep/w2vEPXCy1Kfbxe8/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453304; c=relaxed/simple;
	bh=IoSduTfwHtXHMAGHN/n7NAoi9cy+8bi2ChZ3M2oXKmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmsRgu9G0/arfl33uE+a+0SopcH6OQRPDULz0jIMnK7Mm5H77kZls66EfBRu8YmcAEAGmGIr9QePEiXdp+d0pwPpEC4nyzfs8wdTQtQ4HmiNs9QBmW9WbfXr5ycN6SSxcKT16QGctNFDD/STG3Zriz9XfXWqi5YY97mG1UQ+DXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E+fGH1Mq; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E+fGH1Mq"
Date: Tue, 9 Sep 2025 14:28:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757453300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJ9Vxazb02MCfvkJVNx2suvWyakubwitaFTpjRv2xjI=;
	b=E+fGH1Mq6e2Qc9WzPKrVzgKJHQljCUeqHeORnv19sek0lJaLn5ReZ/mTx87G6h0483lu+P
	rQVuqWibDMdq9vwbj6JVcf/4yy5CXyYWUal8koxe3hoxCtB4jwn6gK6GFo4AUrM0DjFvwT
	Q3nLJC9CHn42BlaIvtv8zypr4VmWvCU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Exclude guest's TWED configuration when
 TWE isn't set
Message-ID: <aMCb7buQmr-SQAGm@linux.dev>
References: <20250909071602.294783-1-oliver.upton@linux.dev>
 <86ms74c7ue.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ms74c7ue.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 09, 2025 at 10:07:21AM +0100, Marc Zyngier wrote:
> On Tue, 09 Sep 2025 08:16:02 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > KVM blindly OR's the guest values for TWEDEL and TWEDEn into the
> > programmed value even if the guest has WFE traps disabled. Exclude these
> > fields from the final value when TWE isn't set to avoid potentially
> > delaying a trap desired by the host.
> > 
> > Note that KVM doesn't use FEAT_TWED currently so there's no need to
> > empty out these fields the other way around (i.e. host TWE=0, guest
> > TWE=1).
> > 
> > Fixes: 04ab519bb86d ("KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2")
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/vhe/switch.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > index 0998ad4a2552..e4955b49c0d2 100644
> > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > @@ -95,6 +95,13 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
> >  			/* Force NV2 in case the guest is forgetful... */
> >  			guest_hcr |= HCR_NV2;
> >  		}
> > +
> > +		/*
> > +		 * Exclude the guest's TWED configuration if it hasn't set TWE
> > +		 * to avoid potentially delaying traps for the host.
> > +		 */
> > +		if (!(guest_hcr & HCR_TWE))
> > +			guest_hcr &= (HCR_EL2_TWEDEn | HCR_EL2_TWEDEL);
> >  	}
> >  
> >  	BUG_ON(host_data_test_flag(VCPU_IN_HYP_CONTEXT) &&
> > 
> > base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> 
> I'm a bit lost here.

No more than I was, apparently...

> We seem to sanitise ID_AA64MMFR1_EL1 in a way that totally removes
> TWED from the feature set (see limit_nv_id_reg()). Therefore,
> HCR_EL2.(TWEDEn,TWEDEL} should be RES0, no matter what.
> 
> Is there another way the guest can set these bits?

No, I just saw Jinqian's changes making this field writable and failed
to check the limit. I'd like to reduce the amount of NV limitations we
have, I'll just send this with the relaxation as a v2.

Thanks,
Oliver
