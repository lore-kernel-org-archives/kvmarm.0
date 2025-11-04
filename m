Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA99302165
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 17:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762277454; cv=none; b=XQuqJMYEwnEO+R9uYVRZvriZqLc7EI1GeiE/HTO9dREu1QWY5Cx3sZfg345IqxAyHP9WtwJ8C/2BiD9s/GAF+a7cVDixRJ0WCFkglUJ00ywbtegGl6WqE5J5LgYqt6LTjiD5X7G31lgqamt7/B5h3/3rSsWAXV0V4k3QyOaxQ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762277454; c=relaxed/simple;
	bh=v8bk79uKwbhsxBB7rvYaH9pZrPfxdCFM5IFgje6X098=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BoDUJPRtV7i2xiYGki471O8ksFU2phpoawH89jtBUAFkjpdpcQLjtwY4Qek+kZo9F/nxx4bflU7pMb1KJGR2EZoqUGEkB2wHqSuzZVq7vytJMkY1K3ea6PwR0JKZY4pyET5CjxR1nQb2pOyQkxj0zHKCLmDy0u+3jCpw7kuHOhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KirEkdD1; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KirEkdD1"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ed6ca52a0bso173401cf.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 09:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762277451; x=1762882251; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=awe61BJaN6OAuRksC/JK1rM8AwR4j7lc1rsLmD6YWSg=;
        b=KirEkdD1OqIlYhQKNHHRt9du0nglyJ2FxJfKxJFPKwvYevdKuUZwNo9TjKUEi39mWN
         P/pod2F4d6Y+3Of532+MwxlW56hnzgkWbEq24Q5KPjUl49emOadWRg1G/Hj51fucQhzp
         ORy8i6yCzxsAkXQ8tPOPuq5iAQuDi8RIFjDjqvZAvUT1CNGEE8eerbwT3kFs3e/5ZkcG
         3S8GiIxUDZK00xLnTX/HmnhTH/XrjxBi55wMje7DeTFbEe4naAMxGrpAsDwqh34vQ5u0
         iU/oQSZL2pEytCIzp0hjmhpZZHu8AubcRA83f/Z7TlXEMpkNq3e5g3afF47Z77uVx4QL
         WPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762277451; x=1762882251;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=awe61BJaN6OAuRksC/JK1rM8AwR4j7lc1rsLmD6YWSg=;
        b=YWQyIuPZI41u7El0iyp5l3pJvFmFOhIqHt3OQeH77FSHR6ZQuNUAlDhf74P/Dfiw+V
         DQhLAAI50sthvLPZwPIc1PsIzNqlRH5PJYP6S3i7CjAoxnWeMjwmLf8u+tlmVTjxDaTj
         9QxpUYnvgbQMm9peQHUvc5gKDBmlH0SZEXg6K5gsQsffTtcEY/D9J2m9r8fmC7KxUsjG
         W+Q8ZraIxHTzrpaDh9eXUf5qabnFfLsIPbHSAczn+oQF58u+SqMX7wFLgIKzoVWl0BoB
         J6D48rtP5irDqnkF0nvD7jKpxzf/7cUC/9nC+JHPSg0TQL8tP/KNRBohD51gRxMlanV6
         r9Uw==
X-Gm-Message-State: AOJu0Yz+Fvovyny1LEJi72deFB3QC18LmYI3sIxUviJ4J3DTpvWeNExj
	5Dp/+qQbQ6JaDmp3DIPKmt2KUEosNxZ3dOqT4ULEUMvVRL5tjIbrzYIl5UUi7aOHOvgf16cCZHn
	QfEoJBJ6E+DdR1do7MlH2qpbf75/nCcZ/XtQVWrqW
X-Gm-Gg: ASbGncv0tbQxo2pKLocHRjj5GgGXIgs8qLTSnePkhGx50G29HoO2BoLG7p+WQd7DgV3
	BUGzXEPFUTvOvaSr4rnluByL4SBeo/i5ejDe7H/FMD73ATTzqFoaaZAkRV+sucjSAqpk0NZArc4
	2Qs3gMqBJk80m0ua+R+SgfvOOXQBJCTUul5JE3e5ZjHoNx6X9TK6R943GvM+gE5ZHRld9LrDw46
	jMdJu8ySRIDldEYC5CUUaBJpuxbve2Y34SwdpLm7LWPGgJxDYS6dzp2sSbHdw==
X-Google-Smtp-Source: AGHT+IH8OXBy7BFfRFn05NDCo7PgyCzEnxa6zf1c0iFH9l4wPXRMCXywAxQHI8bFY1HB7DcqLoyPvy/jm3Gx3juAFeU=
X-Received: by 2002:ac8:57d2:0:b0:4e5:7827:f4b9 with SMTP id
 d75a77b69052e-4ed63645c68mr7879891cf.3.1762277450955; Tue, 04 Nov 2025
 09:30:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com> <20251104125906.1919426-3-tabba@google.com>
 <86h5v9vnfc.wl-maz@kernel.org> <CA+EHjTw7KnXVKeyxd4kNysAOMZrJniuBdCNGV=NoWodc3H-rMw@mail.gmail.com>
 <86ecqdvhk5.wl-maz@kernel.org>
In-Reply-To: <86ecqdvhk5.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Nov 2025 17:30:14 +0000
X-Gm-Features: AWmQ_bk3ESFlcrVaimrCr7Ll-opZglXriMvY88QUUeSlFyQFCbdDPvb3Jp9FL-I
Message-ID: <CA+EHjTxc8zbTj_f-d5uY6euYHyKXUG+XLs-Qa6n2UyGo0OmOrg@mail.gmail.com>
Subject: Re: [PATCH v1 2/8] KVM: arm64: Trap access to ALLINT if FEAT_NMI not
 supported by the guest
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Nov 2025 at 17:22, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 04 Nov 2025 15:30:34 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Tue, 4 Nov 2025 at 15:15, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Tue, 04 Nov 2025 12:59:00 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > Access to ALLINT is part of FEAT_NMI. If a guest does not support this
> > > > feature, any access to this register must be trapped to the hypervisor
> > > > (EL2).
> > > >
> > > > KVM didn't configure this trap, potentially allowing a guest to toggle
> > > > all interrupt mask when it doesn't support FEAT_NMI. Fix this by
> > > > checking if the guest has FEAT_NMI support.
> > > >
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_emulate.h | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > > > index 0f8311263edf..3fc62808c548 100644
> > > > --- a/arch/arm64/include/asm/kvm_emulate.h
> > > > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > > > @@ -688,6 +688,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
> > > >               else
> > > >                       vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
> > > >
> > > > +             if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
> > > > +                     vcpu->arch.hcrx_el2 |= HCRX_EL2_TALLINT;
> > > > +
> > > >               if (kvm_has_tcr2(kvm))
> > > >                       vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
> > > >
> > >
> > > I think this is moving in the wrong direction. We have for quite some
> > > time now tried to automatically derive these behaviours from the guest
> > > config, as we do for FGUs.
> > >
> > > I would like to see a similar behaviour being introduced for non-FGT
> > > bits so that we don't have to worry about these things anymore.
> >
> > I agree that we should make this more like FGT, but since that will
> > likely require a bit more time (and probably a couple of respins),
> > should we fix the HCRX traps as they are now?
>
> I don't think this is fixing anything. Where does the trap go? There
> is no triaging, no handling. At the very least, this needs to be
> defined.

Right... I was thinking of protected VMs, but much of that code isn't
yet upstream. I'll start working on handling these traps similar to
the FGU handling, so it's ready when we start upstreaming the rest of
pKVM (soon I hope).

Cheers,
/fuad


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
