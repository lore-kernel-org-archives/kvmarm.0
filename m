Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195DD236437
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764257977; cv=none; b=jcOFEbk411v2kl9nkw1k6+Dmu3xzPKD4dvvFFQ7iNf9amEbPOxKEvYfYNxxgONYm//NDUnkVPl0VkkiGY11zbVU620yjEviBNYpEr9ZPjOy7f58seC9PHISc9Zzr3/OrSPIMwrwC5PJA0zpXHaldwc727Mzqvi7aQcB7F7UZCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764257977; c=relaxed/simple;
	bh=YSmJ8YYBAg6wZEIq9iLvpXP/Le7vnkgiJV/EeRtDVMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C10s8nYsE43uicPY9t8755zbtdnjICRAENTOxOGAiwkBECcGKbn5Ax4lrOzmeOnOwDLXPHQLn8him7g1iPwutkNVq1oM/wRk5zUNLPZDYftW+sSWiVtX2xbtHM4uvmzVDR1IGxF35rKfADOu10u0HPQpQMSfCHVRF7kC1rkW+oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cxkUt1dB; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxkUt1dB"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edb8d6e98aso405261cf.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 07:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764257975; x=1764862775; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hd0CY3ZU14atwFY3xqBMDgidv/YHSzUs9dC1+cwr/w4=;
        b=cxkUt1dBA6tLe9lVjZdDPfOx2FgofQyKb19oHV92Pc7FyM8f9C+NbHiY3b8OTUx9gr
         Qj7LT15Tj2CEcyj5UwqfSOwLqK8v0QCefWZQFBSJzQMUzAHfiy4esKKYdf1yR9sSuhvF
         4kUAzwy8Y6LuT4usy7H9FHR3amefjr60UDuXinI38CBggtAQd6szzRWU7b7QEll15tEa
         tAyTmQ75E5/RC1doBcahR97wMHkdIrmhPwxT36HdU7YvMy+bGBzMpfsMxUuKKgHfCHDi
         qs1K1pwr2UG8s0oYGzojRDFIGYJAIZXw6pjnPdqH+oAE9sh45Av4tTecv38bTTsangq+
         9plw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764257975; x=1764862775;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hd0CY3ZU14atwFY3xqBMDgidv/YHSzUs9dC1+cwr/w4=;
        b=ZkH+Pw5LqmLnoWxNwbz9Agmt+UfVAtN9bNaxK/IB+fzISgRbfpSLR3zusdCxk+wns1
         gHKPkHDRV/xJcBQXd1z8cpsrYm1TuoUUqnEE57Z7qDmAr2lh7GUWnEvU6+ss6EFkOVcu
         v30VNiTIm6L0EgCsiddzduDpPn5mUi454CPy0QInJnm490Ni12AypsEGLtrw6hqHXhGG
         22mWvDR5rlEO0CqUdTVr1ACk22QoCP7Qehiaby9vyoHZyRzdCFfYg+hZsrE8lWbH5Jnq
         rue4JUjQ/jNcha2BcmVHSaujWPK40VmuR1d2StLH+diqKqHYDYLtHtyISSqoj+4fP3pV
         8ZZA==
X-Forwarded-Encrypted: i=1; AJvYcCWh/xKSUr1ddPANrwH+4gsJ4UxtuRBW8Z4l57f2H7qQ9aV05Y8B8bxxB74AXwNe+ds/5Lxvu/A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTb52l8AlyCCIW59Fd8foW6Pee6MhR8r/6+MalF5/FR2MhI+qV
	z+dXXMwD5+/9R8kYHsJcTAJSz6hK31Bar1nO8owf9Gx+n8c7vyaGnYcp6v+4LWGLb4m9vRw4aEH
	Lv1TqXppK4FSyYxpTsYE8PbUMrod8z9zidA0JnWEi
X-Gm-Gg: ASbGnctGRwXSYRGW5RnN71cjGlbnnMM8mxfA7olrbvMvfV9O2Edz64YcwMYps5IZZuP
	79b9ozbr6PrcYqjvs1G45vnZvY701FCeXaqSxM8HghgmTqePeYRUQhf80psbfPFj4touh4xuWlN
	dMOwc12piIaYb0zJYODkhD9947qdSZUtwdJwjoyFWHkm/ysI+0uZ1FJMcYS8LDbx3oaiiU8lPzb
	wITD+RL+atD/qFzPZYL7Ye03tQmQQ1QiGaUWMEkf7IvdyU5xrqJi6vd4hdpS4J1qoCJKGI=
X-Google-Smtp-Source: AGHT+IGEsrfjcbkJGkqxXUYXJI3yjjMPThz8ftNHObRNiq98zA3po26R6DweswD54zni3BAoy53/f5b9h4FygzZZsrY=
X-Received: by 2002:a05:622a:181a:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-4efd0c63121mr5012851cf.6.1764257974659; Thu, 27 Nov 2025
 07:39:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com> <20251118103807.707500-3-tabba@google.com>
 <868qftqehe.wl-maz@kernel.org> <CA+EHjTwHrLhdHrNSA8f-+bCZ1-QEuNocQQxeiaaost9oLwaG5A@mail.gmail.com>
 <865xaxqal2.wl-maz@kernel.org> <CA+EHjTxhOvu-733Z-gJgc6f_EAs-tksA6u5KuQZeimP6T6M-fQ@mail.gmail.com>
 <7f1c187b-0f94-49c5-b4c9-2f414ab0ac8a@linaro.org>
In-Reply-To: <7f1c187b-0f94-49c5-b4c9-2f414ab0ac8a@linaro.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 27 Nov 2025 15:38:58 +0000
X-Gm-Features: AWmQ_blndo9HCJsMPCLdj3IZ8iIryYV2t4AJnZgeW8Vjj_H0mejoM0lyx7lRygU
Message-ID: <CA+EHjTxpTKFQwWHR6vBVxC_a6dpza_bgCmxTXSbWjT7wfJh2TA@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: James Clark <james.clark@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Nov 2025 at 15:26, James Clark <james.clark@linaro.org> wrote:
>
>
>
> On 26/11/2025 11:48 am, Fuad Tabba wrote:
> > On Wed, 26 Nov 2025 at 11:47, Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> On Wed, 26 Nov 2025 10:37:57 +0000,
> >> Fuad Tabba <tabba@google.com> wrote:
> >>>
> >>> Hi Marc,
> >>>
> >>> On Wed, 26 Nov 2025 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
> >>>>
> >>>> On Tue, 18 Nov 2025 10:37:59 +0000,
> >>>> Fuad Tabba <tabba@google.com> wrote:
> >>>>>
> >>>>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> >>>>> register accesses. These accesses are trapped to EL2 when the bits are
> >>>>> clear.
> >>>>>
> >>>>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> >>>>> had the polarity inverted. When a guest did not support the Trace Buffer
> >>>>> feature, the code was setting E2TB. This incorrectly disabled the trap,
> >>>>> potentially allowing a protected guest to access registers for a feature
> >>>>> it was not given.
> >>>>>
> >>>>> Fix this by inverting the operation.
> >>>>>
> >>>>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> >>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>>>> ---
> >>>>>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
> >>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>>>> index 8d06a246dfd1..f6f8996c4f97 100644
> >>>>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>>>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>>>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> >>>>>                val |= MDCR_EL2_TTRF;
> >>>>>
> >>>>>        if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> >>>>> -             val |= MDCR_EL2_E2TB_MASK;
> >>>>> +             val &= ~MDCR_EL2_E2TB_MASK;
> >>>>
> >>>> This does not only change the trapping logic (bit 24). It also change
> >>>> the ownership of the buffer (bit 25). I wonder whether you should do
> >>>> something for that, maybe by clearing TRBLIMITR_EL1.E, because
> >>>> otherwise, you keep tracing, but using an EL2 VA. What could possibly
> >>>> go wrong?
> >>>>
> >>>> Overall, I'm very uneasy about TRBE in the context of pKVM.
> >>>
> >>> So should we clear/restore TRBLIMITR_EL1.E on guest entry/exit in
> >>> protected mode?
> >>
> >> I think you need something of the sort, yes. Overall, SPE and TRBE
> >> should be aligned on what they are allowed to do, as they are two
> >> sides of the same ugly coin.
> >
> > I'll fix this (or add a patch to do this, depending on how it looks)
> > when I respin.
> >
> > Cheers,
> > /fuad
> >
>
> To understand this, is it just belt-and-braces because you don't trust
> the current filter clearing in TRFCR_EL1? And to reduce the potential
> for mistakes leading to trace leakages? I suppose even the hardware
> itself could have some errata where it tries to access the buffer, even
> if we've completely filtered out trace and flushed before going into the
> guest.

Yes, we don't trust the host. The pKVM threat model is to protect
against a malicious host.

Getting into hardware errata... that's a can of worms. I haven't
considered that.

Cheers,
/fuad


> Thanks
> James
>
> >>          M.
> >>
> >> --
> >> Without deviation from the norm, progress is not possible.
> >
>
