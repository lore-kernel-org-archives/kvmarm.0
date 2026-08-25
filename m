Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD063B8920
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 07:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787642555; cv=none; b=ASuaMCb7geNkMNq2MSC0kldi/HS3Ttgy0I/uKejIV9hZPgqjJ350e7fWUOvcFxUJjPuentd43zbB8ZuIcApbmn8OpXgwAyIgN0yRBXsTY1OnY9cnap1SMtZeCAIfxySbYhSNAe88gRmTN6Q2u7xTm5sCvRe2fPx5OubOeHlEEEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787642555; c=relaxed/simple;
	bh=3zM0QJcSGVE9fFDjAv2RmdnKoPmIMzgW1FFqwHFF/7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6WDUjmErrxu/hbwxrnV+aUc+g19PMHwP2fBUPi9Y6e/6j1Uq7hDl1aqVT5W4ZhkDq7Pn/VaatBF5eJPese4P7YYATmmezq/KLZsFi/UJa06zCt2Bp15pjjZsPWBX1LSli98o42gmBRvNhe9jGT8tILgMAv3gmfZf5AVXRgB510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gx12hFD5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gx12hFD5"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso43227235e9.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 00:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787642552; x=1788247352; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AeanF6wV5Vz38rcMNLwzqqdAl64h6z9Xktwn4H66zlo=;
        b=Gx12hFD5FoU1jRGUxY2vb0E/sO2xRtjurm1WM/+UBV1Wb6egzkMGEt5/99W17XsOFF
         IJTmBYSGNkd5/p9mj9mM+jfDyEpZKOJUPueyG0KjIleBCctYnhdz7V79WxQzDtMAaZmP
         Qbfzc2aYuA4ktYrfgQj8b68eDRkEU7hXHfkQRyS70XFnBpv2MaJzqvaA3GA4BGNmPWRV
         DRIPp1w9zzfmSPSGZ1vlEgSz0xryvpwxvZAWI9tsIyTxfkTsnTyw6u7moWsuyxez/MMJ
         RjCfKLKvukAmqh8/2O08Pwo98bxOk4f6Ii1hCFMOXfCqjv2Uv5TyE0gbm1L5pnrsXbDf
         f5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787642552; x=1788247352;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AeanF6wV5Vz38rcMNLwzqqdAl64h6z9Xktwn4H66zlo=;
        b=Is2gmjkFBRQtu47I6kKg2WIm7OSyet0Rcxq5Wztw02QnZ9wh0lHotGy/jmSWgzD3AK
         lHtsSjDgoxTqD/6rTJWzNFpXs9UlQxPkfDpvLkZ0mv3ZlVN9CRQLE4gOPGR8upmSCc13
         4xTLmpHpfNxtg+7FsROacepqR2MEVne83qQWAsHllaXVpR1E+uSGp66HNnalYN01JLEu
         LqRcX68hEfv/lv3oht81TmmAcNCepFuUpnDYOw+ovXx/Ld746p/CWAgtO0g4/0AxSfxj
         sQoOzKIeyfeZP86db+UeVOPo6isUvLdn4Y2cleBcSSfiOQiVtIGOPNO/ozPBAlvI5izp
         MXxQ==
X-Forwarded-Encrypted: i=1; AHgh+RrSWwPmC7+QohH54nMorZF1e3fHzkPe5W0TGcoj5dP5Or1t5KRlSlqWOd555hHWYAZpeuSelLo=@lists.linux.dev
X-Gm-Message-State: AFuF++mJp43fA+ztqiJPrcQInvgVEOjQVDT6pht7Z++90OaRJqzOfjF4
	Km9eWtruMNJWdbnbrgU4UP1sXGkj9nG0V7cBBv/EDHHp2Tuxppa/1w9BBw5Q1dHNbw==
X-Gm-Gg: AR+sD13O9Yi3CRBmqmCMmFCnCezYCan706KYihPQ9f0G99Hm0fpn6JXlFntD8FkMC8Y
	QD0Ct6z19rnM1uouoIumlRE3GtRB105wv7pdpdlxSFAKROKS2XcgYNavKt9LScM/APEkRBgSg0C
	YZqsLK2evZSbG9dWthdb+k7rEhD/UmIOiUvksGYcZ7iqQUcqbTNuclmk1qYUK+xc+OvT+tFhAsL
	YV6iwp86A+oowztID6qqtWcZQjTN+nvbspo0YmmIt7mpBzjbSQA8fDNKLHEqSaV1esBcaN0jY+s
	nIra1wsepkTRqJ69Ysh/EcTdE2Kz/SPdc2Iz6qcpxwA5olm8Bc9UgWLnkPoGhAg4AuDpnddrTEE
	fCgk3qFLleBUkumA9brrNOHtBpJxcQNuUxa8AonD0Lyu9IyLhbG4+0meSicHKhxTExTDfl6jQ5d
	CdhC1ybf+AGXBs1vlnyuGpCbf2knEcR+hncH1w+z9XN9l2zjHXKoUmMCHWT6vAO057lhz3Nv1sh
	kRBlfNLiD6g+hAPSAxLrymrGd03Vwqa
X-Received: by 2002:a05:600c:6088:b0:499:621a:2ec2 with SMTP id 5b1f17b1804b1-499c19977e0mr323691785e9.3.1787642551487;
        Tue, 25 Aug 2026 00:22:31 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499d638fc8esm18764925e9.11.2026.08.25.00.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 00:22:30 -0700 (PDT)
Date: Tue, 25 Aug 2026 08:22:26 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v4 10/17] KVM: arm64: Add a shrinker for pKVM
Message-ID: <ao1CspwFUHyhj0dE@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-11-vdonnefort@google.com>
 <CA+EHjTxU2GCpSR587oR_EaMOvXfu+teCnfC2KCg=vpOtf4sgRA@mail.gmail.com>
 <aoxzjag7xr_emuvX@google.com>
 <CA+EHjTxraCfN1bfZ9ygRiyxxyEPeHw4mg6f6O0qzPBpFi165Qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxraCfN1bfZ9ygRiyxxyEPeHw4mg6f6O0qzPBpFi165Qg@mail.gmail.com>

On Mon, Aug 24, 2026 at 07:10:37PM +0100, Fuad Tabba wrote:
> On Mon, 24 Aug 2026 at 17:38, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > On Tue, Aug 18, 2026 at 04:28:38PM +0100, Fuad Tabba wrote:
> > > Hi Vincent,
> > >
> > > On Fri, 31 Jul 2026 at 15:36, 'Vincent Donnefort' via kernel-team
> > > <kernel-team@android.com> wrote:
> > > >
> > > > Integrate the pKVM memory reclaim interface with the host's memory
> > > > management subsystem.
> > > >
> > > > This allows the host to automatically recover unused memory fom the
> > > > hypervisor's heap allocator when the host is under memory pressure.
> > > >
> > > > Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > > >
> > > > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > > > index d28422f5c3d6..bfbb1266491d 100644
> > > > --- a/arch/arm64/kvm/pkvm.c
> > > > +++ b/arch/arm64/kvm/pkvm.c
> > > > @@ -115,7 +115,7 @@ static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
> > > >         return ret;
> > > >  }
> > > >
> > > > -static __maybe_unused unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> > > > +static unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target)
> > >
> > > This is the first caller of these, so it is where reclaim starts
> > > running against a concurrent top-up.
> > >
> > > Nothing marks the pages a top-up just put in allocator->mc as spoken
> > > for, and hyp_allocator_reclaim() ends with an unbounded drain of it,
> > > so a shrink with target 1 hands back the lot. Land that between a
> > > top-up and the retry it was for, and the retry asks again, and
> > > pkvm_call_hyp_req() goes round.
> >
> > Sorry, I am not sure I follow here.
> >
> > IIRC, the shrinker will only reclaim half of what is available. So the pressure
> > should be proportional to what is available and limit races with topup!
> 
> It's the ordering, not the amount.

Do you think we should first try to reclaim from the mapped pages before
draining the allocator->mc? 

Mapped pages are more valuable hence why I have started with allocator->mc.

But, it is true it might make sense. It is unlikely to have pages left unused
into that mc. If that mc has been topped-up that's because it is about to be
allocated from...

> 
> topup and its retry are separate hypercalls, lock dropped between
> them, so a shrink on another CPU can slip in, right? .
> hyp_allocator_reclaim() drains allocator->mc, where the topup pages
> sit, before any chunk, so half still comes out of them first: a target
> of 1 fails the retry.

I do not see where a target == 1 fails.

> 
> >
> > However now looking at it. I wonder if I don't want to ratelimit here the number
> > of pages reclaimed in one go to limit the time spent at EL2. Especially we do
> > all that with the allocator lock taken...
> 
> Ratelimiting would cap the time under the lock, but it wouldn't stop a
> concurrent shrink from taking the topup pages, would it?

Yes, my only intent is to avoid blocking at EL2 for too long.

-- 
Vincent

> 
> Cheers,
> /fuad
> 
> 
> >

[...]
