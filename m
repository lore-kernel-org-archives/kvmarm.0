Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7537731A057
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764153517; cv=none; b=s9LnkieFgriAnGfLRcwXQJJGycsVQX4dV9T3wcYUu/dwkM99m26FjShEcxT3JiEYZzuoE7fsscUFFwbLP3OwCl8838VgzfwNJ4LQe9pBjuD5Iya4WGWwtc0FnEZ6/FJvNB5Nn1RmLEX7BrgZ6Q02FNJFMZ6EH/OtGovYvkeYMRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764153517; c=relaxed/simple;
	bh=QdURJ8mzlMi6AChazO2LtwSmmBW0bO3LbzNcNqM4ZUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMdJ92qVRrM8J2CuGSMRnyTR9K6R/J5u+IXco/OADDo8cEDGkGgGcAT84gtnStpBqUHdygxHUoYpxlc1s5BEwJzgN1QAhX7TwqsrFz5jNxwXuEyqweaXOvR7BlFnflw2jRNGDKOxTo5c92IdCIQzud3cBvWjakulKNj7aIPYN0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s+xcryfK; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s+xcryfK"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee243b98caso192221cf.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 02:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764153514; x=1764758314; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kqXHzvwmvoGg6pqZSjb2mOgsez6Y0zUfBWYZPKgQD0M=;
        b=s+xcryfKoQiYhjSdqn/e2aBF5tLjzL/CEmGb5H2CYcm9IKwmsRfd2WzwQ5a4N8CUmU
         ZoDdaQlsSQPy9/itLwzcGMMYjWphSxXcttiQaEUphHurE9/cIYCL7etUj9/MxpRxmODr
         Zj+3uBxRgIMetjMBocUDhwQK17qSXOrRb2NDpQ2rPjeVJIrvnj/f8b1XSfdLdyNWqFLT
         sNslbvLThaH0XDynmS6J1r2LOU+xMb7m0wAnZmWaf9hC0ujkjM6q5XHN9zfyJUMYuajC
         GhAt+OO2C+qAKaMAvNi0Rv2F/M3rGkrcjHyVg1MQ2Q6vEN1AeepI2YBZsAb2POE+d0WV
         2z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764153514; x=1764758314;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqXHzvwmvoGg6pqZSjb2mOgsez6Y0zUfBWYZPKgQD0M=;
        b=AvqlHb/lY8VfZfBI6/9Pbi1MI9eDkPRliqZA6RGn8LS4Yp17NCju0iIaT9rdoYtiBT
         ESw9FUuA6Be525mZGfKxSCcc+boeMPrhhPWuNcXcqvUHIpFUMbFSTqEUfiwZ3tfxJ3yq
         9NwRjAxUrKh4ovW0bb1YnkNfWthkbKx6HI+C2puU6niNNMoCNsg4/DKu25mVhbhlNs2K
         sSPTZ2TMqbq5Bmct0uqU6plVWTptBF/oZ0mQJTjq/QpIHTxNb4chsHWaluBQjbLoGoZN
         ACNtm6uX8kenUV/+T1sV35X7sRYcJ9rbPsGlQNmGb2E2zR4fSWy1yfAdb9w8h1NO8oQ7
         V6Lw==
X-Gm-Message-State: AOJu0YzZ7xLEyRiZ+gpaWfGfROMOEI9+C4YnoWFe8JCaq1dnSlIucRm1
	6302dY949PDD3g3dZe/Bh1/z6oc3/+zhf7wte2eKFZNA8A0ljk2akfAdjkX0SVhm0HbZD1NrBQs
	Tq5tYkmHvpLVVikqPx9EoopV5b5gEE5c/CLsPtxYxA8bcMPwpf/4zeCt3KGA=
X-Gm-Gg: ASbGncvBoSCuybOC+S8eyMzDrsx1uqW7Jx5h4NM2uj3u0R7bL8HgLghjR75TRLZG966
	4tZ88//lXQ1f5NFAwvM2HS/7bI8Yjzq5Gc42EaDw57b1WBNXc+bMq6+dNiDUYWSm3rDnK13/KN1
	fLEPDMHeyrXTpi3UC7zcyme1lokGHlAYZpOWPBkcIh4yWfFGNzcFxcSHb4nVz6bpoET7ULGvvkh
	oABN02niNVBEoxT4W7R1QBQJuA7lPiyTDI7J0qSyHj2hyLre+/+qMV6tjI2jNqMLhgPSaJw0eNj
	J5Ic8DrEpdpCvPKXG4Ma1Nr9
X-Google-Smtp-Source: AGHT+IFEItoaU8n1dUE+RT80BKVjrf9iLlu1HIXY0cBSskpScSOIaQL/NClTMCE9saVAiaioP1yxTQtsh+6JQd2KBrw=
X-Received: by 2002:ac8:5e06:0:b0:4ee:40fb:d2e8 with SMTP id
 d75a77b69052e-4efc83c3b78mr3072821cf.21.1764153513797; Wed, 26 Nov 2025
 02:38:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com> <20251118103807.707500-3-tabba@google.com>
 <868qftqehe.wl-maz@kernel.org>
In-Reply-To: <868qftqehe.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Nov 2025 10:37:57 +0000
X-Gm-Features: AWmQ_bl986BZK6mXylg70DosjYrRxjqNJ_REYpEjIxvfAOZqy8dAVrL8-eyJLDY
Message-ID: <CA+EHjTwHrLhdHrNSA8f-+bCZ1-QEuNocQQxeiaaost9oLwaG5A@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 26 Nov 2025 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 18 Nov 2025 10:37:59 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> > register accesses. These accesses are trapped to EL2 when the bits are
> > clear.
> >
> > The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> > had the polarity inverted. When a guest did not support the Trace Buffer
> > feature, the code was setting E2TB. This incorrectly disabled the trap,
> > potentially allowing a protected guest to access registers for a feature
> > it was not given.
> >
> > Fix this by inverting the operation.
> >
> > Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 8d06a246dfd1..f6f8996c4f97 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> >               val |= MDCR_EL2_TTRF;
> >
> >       if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> > -             val |= MDCR_EL2_E2TB_MASK;
> > +             val &= ~MDCR_EL2_E2TB_MASK;
>
> This does not only change the trapping logic (bit 24). It also change
> the ownership of the buffer (bit 25). I wonder whether you should do
> something for that, maybe by clearing TRBLIMITR_EL1.E, because
> otherwise, you keep tracing, but using an EL2 VA. What could possibly
> go wrong?
>
> Overall, I'm very uneasy about TRBE in the context of pKVM.

So should we clear/restore TRBLIMITR_EL1.E on guest entry/exit in
protected mode?

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
