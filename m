Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0153B2C3253
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764260657; cv=none; b=pCjg/7pSRKVaY+W/lkQIMoB47NXZQlLYq+YNlpETkVtpEj9VIIzQuwVgdg2KJEtpJYEU8etBuQsE/tZK5W6awyf28nW4agL8kvScJbISCf9119lvYiT0mz34gHPyGIEoZNal4Moxte4DOxOT6wGX+fiTGm1jA9bRFnnS4g71z/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764260657; c=relaxed/simple;
	bh=m/n3xG2H8J+3xmOadoOLeBMtU2Xbxx8IGN22bDxy4iE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oBxrbpAELtD668NboLmKdigP/LV5ELrewBWYYd3zDN6gjS3AlyMJdj+wP6933J2pMVUz58t/OX1C5S2TVJRp77tQcEyAHZDkjf2RIH87mxCutxF6AjeGfrREtG00WF6kCiCllvgD1Ybt97ER1f9tZCt0brYdpP6fU8C3vzH39s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YIah7uXl; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YIah7uXl"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee147baf7bso294221cf.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 08:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764260655; x=1764865455; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KDrq4Mc2hK/U8sfxbgazMAArpTKo1U5Tb3vPp4StZnw=;
        b=YIah7uXlWcl2K0hieteJmYkMsOE7Cuy20ZQJeBMhZZyzfljKzi8Y1kmDG4Agwc7+u2
         yC3c40HNyjrv7/aqklBfALKqnt+a67da6rLBkckYGqVLMGEYktpP8AxJS7FbSCdZYmBu
         CvGvl72w8VskOOVW6xExWQS5X1hl+9tlhI1QZW4jeQm85xk/WcCyW8a8PvWZWpTd1cDV
         oGUB/HgyVPQHQQ5jClGd94UNRkKrk1TiMrSazrnEVv6hcz6eqscILh4yL9Te6NBaLLAy
         SL9iL/6/0SCx2mSzHzWKLJrCEQZAPlW2yhrLRI5ySKeBhfjCr1o0oxZ69dGBQgXzRjrx
         9cvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764260655; x=1764865455;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDrq4Mc2hK/U8sfxbgazMAArpTKo1U5Tb3vPp4StZnw=;
        b=LSOETcObRcpQrycEh78NZm48wh/OIXeap/wGGYRBXTLbDRiPkO6X573Ha8MKgL6xMO
         xCf4xekPR5VTfDs9jNnvsoHR708JAXhzJyvLaIVg9K11rULPEqLcorhS//0rdIx313Np
         0h6DrKQ/gdWQeM5BtMxYYf613a9565sNTOx33/sfM4e2Sn7zUy7BLgfdcicBNVliSaLx
         QcyqmtRre23yXlUB1ud6MF0q0ssGDg6hr8JXs6LRSH+96J0fAskPL9DlGJItcxX+NtVh
         UmPkvpb2X9yQPetYk9bqtHpPfcZ3qVfz7XzA671ncaCXjK09nzhQvfLQNQRdlouS4ymz
         HBNw==
X-Forwarded-Encrypted: i=1; AJvYcCVh67L6hkatp2yk9atN64xAcCtQTDTN4L+SAaeXPUdr6if3A9Si69WC0Aub1q8UU++eQTpm9cU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxppGSlYOXEuoqZjAkjwi+z3ToP0dxNTVw/WilYmVh3beq4XcsA
	eSj13NX5FTk4xWlvbUp5vbZiT7yaK1ncpmmgRJ93wfHQ43m9D43fFcwGNfetLzhk7VASDPeHvfz
	8dvp5uvPMmRy1JKOmzbHRetzDyDRnvAEw493beJiy
X-Gm-Gg: ASbGncuB2AjSmmZAEY0UANkLJSQItCq+lfqyoViHCtb0WXXnwPk2PvSiUbC+3fXEpeU
	aQkSGa/mybLSF5z14n2MaHLTIohQdzue+Tn1k81F6jH+3cmG+jKrK4ZypUsudEqXVdi3WZ6rz4k
	TYqI2nDI1o/6l+ly+cKdIrRuzjKJxxRS0iMeERtbu/vzoBdE3ZYgdcQZIXzE3TLg84vL8sTWphD
	4Lt2ZUP1pY4He+3vn77QTvb4vAXsL5vnFPyhBesXjArBFlC6ZxNQxBL9rbUEp2ljsZ57UI=
X-Google-Smtp-Source: AGHT+IHUROWxuoISlEOryPuGRbWM6oCmISGZW+YubY2toLfzoVx3V91s8k+8Qv7E/WvcOmzpN43HiE9VuLU76nSzyVs=
X-Received: by 2002:a05:622a:15ca:b0:4eb:7681:d90 with SMTP id
 d75a77b69052e-4efd0ca4493mr4908951cf.16.1764260654699; Thu, 27 Nov 2025
 08:24:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com> <20251118103807.707500-3-tabba@google.com>
 <868qftqehe.wl-maz@kernel.org> <CA+EHjTwHrLhdHrNSA8f-+bCZ1-QEuNocQQxeiaaost9oLwaG5A@mail.gmail.com>
 <865xaxqal2.wl-maz@kernel.org> <CA+EHjTxhOvu-733Z-gJgc6f_EAs-tksA6u5KuQZeimP6T6M-fQ@mail.gmail.com>
 <7f1c187b-0f94-49c5-b4c9-2f414ab0ac8a@linaro.org> <CA+EHjTxpTKFQwWHR6vBVxC_a6dpza_bgCmxTXSbWjT7wfJh2TA@mail.gmail.com>
 <7dadacee-b95d-49a2-88b0-73367dab25ed@linaro.org>
In-Reply-To: <7dadacee-b95d-49a2-88b0-73367dab25ed@linaro.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 27 Nov 2025 16:23:37 +0000
X-Gm-Features: AWmQ_bkf0yOaE3gheZNJ4N8MjFaCXAfQTgEbm5B-UzmgIGp-A6s4wvhZ9Jzyj3E
Message-ID: <CA+EHjTxNLMYH-jejcv-aJXieSnXDvGn0q1CS2vXz3eczre0QPg@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: James Clark <james.clark@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Nov 2025 at 16:06, James Clark <james.clark@linaro.org> wrote:
>
>
>
> On 27/11/2025 3:38 pm, Fuad Tabba wrote:
> > On Thu, 27 Nov 2025 at 15:26, James Clark <james.clark@linaro.org> wrote:
> >>
> >>
> >>
> >> On 26/11/2025 11:48 am, Fuad Tabba wrote:
> >>> On Wed, 26 Nov 2025 at 11:47, Marc Zyngier <maz@kernel.org> wrote:
> >>>>
> >>>> On Wed, 26 Nov 2025 10:37:57 +0000,
> >>>> Fuad Tabba <tabba@google.com> wrote:
> >>>>>
> >>>>> Hi Marc,
> >>>>>
> >>>>> On Wed, 26 Nov 2025 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
> >>>>>>
> >>>>>> On Tue, 18 Nov 2025 10:37:59 +0000,
> >>>>>> Fuad Tabba <tabba@google.com> wrote:
> >>>>>>>
> >>>>>>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> >>>>>>> register accesses. These accesses are trapped to EL2 when the bits are
> >>>>>>> clear.
> >>>>>>>
> >>>>>>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> >>>>>>> had the polarity inverted. When a guest did not support the Trace Buffer
> >>>>>>> feature, the code was setting E2TB. This incorrectly disabled the trap,
> >>>>>>> potentially allowing a protected guest to access registers for a feature
> >>>>>>> it was not given.
> >>>>>>>
> >>>>>>> Fix this by inverting the operation.
> >>>>>>>
> >>>>>>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> >>>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>>>>>> ---
> >>>>>>>    arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
> >>>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>>
> >>>>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>>>>>> index 8d06a246dfd1..f6f8996c4f97 100644
> >>>>>>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>>>>>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>>>>>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> >>>>>>>                 val |= MDCR_EL2_TTRF;
> >>>>>>>
> >>>>>>>         if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> >>>>>>> -             val |= MDCR_EL2_E2TB_MASK;
> >>>>>>> +             val &= ~MDCR_EL2_E2TB_MASK;
> >>>>>>
> >>>>>> This does not only change the trapping logic (bit 24). It also change
> >>>>>> the ownership of the buffer (bit 25). I wonder whether you should do
> >>>>>> something for that, maybe by clearing TRBLIMITR_EL1.E, because
> >>>>>> otherwise, you keep tracing, but using an EL2 VA. What could possibly
> >>>>>> go wrong?
> >>>>>>
> >>>>>> Overall, I'm very uneasy about TRBE in the context of pKVM.
> >>>>>
> >>>>> So should we clear/restore TRBLIMITR_EL1.E on guest entry/exit in
> >>>>> protected mode?
> >>>>
> >>>> I think you need something of the sort, yes. Overall, SPE and TRBE
> >>>> should be aligned on what they are allowed to do, as they are two
> >>>> sides of the same ugly coin.
> >>>
> >>> I'll fix this (or add a patch to do this, depending on how it looks)
> >>> when I respin.
> >>>
> >>> Cheers,
> >>> /fuad
> >>>
> >>
> >> To understand this, is it just belt-and-braces because you don't trust
> >> the current filter clearing in TRFCR_EL1? And to reduce the potential
> >> for mistakes leading to trace leakages? I suppose even the hardware
> >> itself could have some errata where it tries to access the buffer, even
> >> if we've completely filtered out trace and flushed before going into the
> >> guest.
> >
> > Yes, we don't trust the host. The pKVM threat model is to protect
> > against a malicious host.
> >
> > Getting into hardware errata... that's a can of worms. I haven't
> > considered that.
> >
> > Cheers,
> > /fuad
> >
> >
>
> But the hypervisor already clears the filters, equivalent to clearing
> TRBLIMITR_EL1.E. Which is why I was wondering if there was something
> extra on top of the model where the host isn't trusted. I would assume
> that without anything more specific that just clearing the filters is
> enough. If we trust the hardware then it is anyway.

We trust the hardware, yes. Marc, what do you think?

/fuad

> >> Thanks
> >> James
> >>
> >>>>           M.
> >>>>
> >>>> --
> >>>> Without deviation from the norm, progress is not possible.
> >>>
> >>
>
