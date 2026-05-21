Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2610839EF33
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 10:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779359411; cv=none; b=duLadUyHZ7qhSp68DR/3wCREeEx6Zf51PG/0wZghbfAd5u9f+bk7gldklmRkywsRSGzFj42ubSHec8dmVTOH9iwNS4VU2BToO730fxBJNK5EFSy5vyIu4vCUEnj85/FcVd7HB+B3cr4y2O55p3sXSNWsVz9xvqWVvQA+2odVKe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779359411; c=relaxed/simple;
	bh=NmD9mUNzX/y6DlpDoXIS6qMuNwv/jfPgZo+xoA3y7wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bKPtQ7edab5/a55kLRuwmivbIV8f0iIbFGjr8AZkzEfjCsnY4RTyzZna6UFJhIk7YAqTo5VAPyxmScJ8ojQc8bRlkWIk+C0YmqjgCdeV/udi7/cFze0y8shtGuv/XniuAGzfuVb6SmzpXEZPrijZn6MeM1oBv2QePGGI+UBBHEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S4L2WZA9; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S4L2WZA9"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so4655e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 03:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779359408; x=1779964208; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOcR2ywmAIsHfMOA6/DbnreILk4QaSYQyzKUA6hoOMk=;
        b=S4L2WZA9T4FOGurFFd4hfPIIuS6W6WwLX1YV8iQIluQ1+cAoD1T3IRnLKo+Fl58QGO
         AN2BFylMmIfQ+HV/pTDK4qePH9STaug4kS+QfXtFlxjZ3lUfP3TBclFc1WFYh949oCpD
         NRlX5ihNcZTdgARB94J1kDpA2865nSz45cRAIegZ1aQ+K5urHAMC+GykBXsUvTNNgzgB
         UcYob4CLCtwzfc//8yuNB7j8JZIyL1km1YJgsaqaDDEEF+bYP0ZWUwiOo2+pXxMxnhIA
         VUzNFx2jykKWo9mYqU9GIb/u30Gfx+j2kGJKzMwOUjNhufP0OtIGQbJ9/NCupZQWF4b8
         MgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779359408; x=1779964208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZOcR2ywmAIsHfMOA6/DbnreILk4QaSYQyzKUA6hoOMk=;
        b=JnTAGeCWcEDN+2nKKwGqI9r8P0uFFMMcjWGalJaYhEKpJPWC+ikO685z1NllGVFdnn
         4N58BDa7YZby00YonIcxuHS1kFiSs4r9XhlerxXzTKy5JiXrBNrMJP6yY2nvl8A3rS+S
         k3w1W+ayThFT531QEr662tydlV+ENIaVu4CYxbPhaPr+wpTM9wJrIh7HL211NxDfRo0+
         GegQfmA2MOwA89iUpWUadmk+aBLBKOyZrbe1/IfGB24y40XMZeLoXW3Otuskqxk8G74R
         sM3WHd4uB++a7uCXamcwBUJgp7tfwm838Ds1eu06Rwdb6UJ56HpOtWPGaBFST58xEZ0x
         GrEg==
X-Forwarded-Encrypted: i=1; AFNElJ/0Ufbe3rJuw/NL7PXjg2OKWncPLhP0ozlXDcMsLXze6TwdTDweEXd711GL1xBSq9NDT//EzUo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWDCk96kgbnXeKqppgNSrDxcVV4iH2HVbHIsnZqzyFngI3oLxv
	Vu1MxNLhqayBkO/dfBf5ppBpHNFGi7PfltkQtPSp4UPZ0FpZ6ZR46Fl9LDSnmSZ22Q==
X-Gm-Gg: Acq92OHN+9KyVTuWlkjR5ESDSub22JWsjehp+c2koogHGqtKhzXFhhNEsMldmlTEm1x
	97cP/GMMcG1XEnyxS0ohbsB016TAFlc6MHfOnwCVYCc4NkmQtyK0ohZYzrXbrJ5bjlP/+S5oeNe
	ELxHSHBl6Oiv77q9NrI033FummrgN492L3uRP8h+HmG1HN87LVKALgCr94expSI1/DXVD/94uXG
	1HoGxDdE6JX56r7TY39z81q/RAKhAYMmga9Nwvu26KI65Ny0tWKwYPABDXvIIqcvW9ZmAgrHJhQ
	UHQ7xkAetWKN3AGe2/n8ganPotk2JJlhNcGaR3ES0P47epmEZwX1OaUPQZ2VDiV/hVXYxIVLRqt
	9ljxHhJwqWzDli8YiBSN7p4mENvdN6cw+Hvo9XP0tBx6GeSAAsSx8uJ8cnq+KfNGyI6AJ+TU0te
	D/TiQO0zQ+EZGr+QyG14XhKGDVTMrZ/61L2phjp9rQ8AoM0njJf6xOczX91TZdhixSzKfLVujFx
	/g=
X-Received: by 2002:a05:600c:1551:b0:489:1f6a:4ac0 with SMTP id 5b1f17b1804b1-49035c64bccmr990775e9.0.1779359407929;
        Thu, 21 May 2026 03:30:07 -0700 (PDT)
Received: from google.com (136.41.155.104.bc.googleusercontent.com. [104.155.41.136])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eaa7cf23bsm1764718f8f.5.2026.05.21.03.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 03:30:07 -0700 (PDT)
Date: Thu, 21 May 2026 10:30:03 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	catalin.marinas@arm.com, jens.wiklander@linaro.org,
	sumit.garg@kernel.org, sebastianene@google.com,
	vdonnefort@google.com, sudeep.holla@kernel.org
Subject: Re: [PATCH v4 4/5] KVM: arm64: Fix bounds checking in
 do_ffa_mem_reclaim()
Message-ID: <ag7eq3bfBOxfaZ59@google.com>
References: <20260520204948.2440882-1-smostafa@google.com>
 <20260520204948.2440882-5-smostafa@google.com>
 <86ldddw4ht.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ldddw4ht.wl-maz@kernel.org>

Hi Marc,

On Thu, May 21, 2026 at 09:28:46AM +0100, Marc Zyngier wrote:
> On Wed, 20 May 2026 21:49:47 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > Sashiko (locally) reports out of bound write possiblity if SPMD
> > returns an invalid data.
> > 
> > While SPMD is considered trusted, pKVM does some basic checks,
> > for offset to be less than or equal len.
> > 
> > However, that is incorrect as even if the offset is smaller than
> > len pKVM can still access out of bound memory in the next
> > ffa_host_unshare_ranges().
> > 
> > Split this check into 2:
> > 1- Check that the fixed portion of the descriptor fits.
> > 2- After getting reg, check the variable array size addr_range_cnt
> >    fits.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1af722771178..e6aa2bfa63b1 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -607,7 +607,7 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
> >  	 * check that we end up with something that doesn't look _completely_
> >  	 * bogus.
> >  	 */
> > -	if (WARN_ON(offset > len ||
> > +	if (WARN_ON(offset + CONSTITUENTS_OFFSET(0) > len ||
> >  		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
> 
> Do you really want to keep this a WARN_ON(), given that this results
> in a panic in most pKVM configurations?

Which kind of configuration will that check fail on?
Does that mean at the moment pKVM does out-of-bound access for
the header?

Thanks,
Mostafa

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
