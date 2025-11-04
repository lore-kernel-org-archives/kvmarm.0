Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8E01DFDB8
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762270273; cv=none; b=A93S83aQ1d2NMblL0x0b2mAFGUstF+6bwYP814R7LS/KarDBBvHEUR+HaKgW4wL4v5+yGeMN8aJ+fwHAcJYt9KyfXxV9ARjvhb6nPOkA8wSzfoV+GBSCso8hvnJ1AbPa82HPZE+iaTnu9801lNvDXo2wXcEugXM4yrrI0UbBBX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762270273; c=relaxed/simple;
	bh=ENDGe1CONBOboWJ7OnEhneY0Ag3grrY3DC/HGHgEpIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E9gP0s4DiWCz3q/a8qppa3BQL/UZ9v0mohuQ9iydTnbH1S5xfy2l5o49nvPija8rMvLYYG9I2E7PiAEM9KEJWict3tJmxa7+cHtd9VGxSGfKBWE4+ckqkRnSrNQ9GbLQz8WG6MI1R0+n/lcSq9dU1cBKNa+NFPOgQSqcpH/Q9Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=veiZoH7y; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="veiZoH7y"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ed67a143c5so203681cf.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 07:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762270271; x=1762875071; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XYC/cCd0zSITxczUbxXMENMoMGUFbD0O4ppMDx0q/Ls=;
        b=veiZoH7yaJYaCh8k/EQpRsk11l5DjoOd7WPin8gNXCHBLUQwvWjO/unNdzVeQqfIGm
         yfdixSVvs0ZK8+dYIUFSubDmtgaKzafwQW5XlZfW2t4pS8i77C0E/a5Og4ew29tTLSkG
         NGdT70SBxaTB7syp0p6dS0zIXRAEqfB5UwoLqqa8lg9YSt0e+bDI3eORgr2gUqkWbuKu
         q1XPjZJo/HZnBDaI0gJtyEwGS5ihNV0XFimheD7aONPtJyPfkHvN90OmqcJkfjHPGKqI
         9dPwTkxywkoEa9fiICOgSVsa5MZ1CwRm+l5p5iCH5shQ9HrcazWe2THA4T0n02TrnIq0
         jTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762270271; x=1762875071;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYC/cCd0zSITxczUbxXMENMoMGUFbD0O4ppMDx0q/Ls=;
        b=GMol2sTQcAm4F3miXkiFYjJJPF5WDYxjXNZNqyfEHWmq2yO1Z1PcsFMX/XLMx8YbhL
         P2lfTcgD657uD0HnCuLFxAGiJnDROjcWv2jV/I1tylWmjZC6GUk4M9AfpKqu0w5/ChB4
         iSG0NlAF9h/zk6qTt0Dyl3p8RST+FuvY30SyBpOMm1alSt1ASS+Mp2TLFCFclerLSigv
         26UNOtHAqNaeTWYz0+5lZrm09N5+IbSL6CHgEFZSxr2aPvjjJe6tCK+NemwLMsh7voDD
         iJMg46EloEyCmmBSWFP5b+HAioPLmvfn3Kd0TjaDIi4nTNiDk81ONmqKUc2UKfe3aPxY
         Ip3w==
X-Gm-Message-State: AOJu0YxqmTDzIvpw7SVjcWR9Z5/eso5FAHrQpNF/2k/M0iTXWLvivly3
	+FBOfUWO0dow5ddLohf+sSdwXlHH0/rvHh0xeBdwlRqgzoCtDMKZFiDSVOMKZG7z1k0v/7bnLTn
	tzgVHsNZEF7NS5ep7XYnAr0RQIdVRnUCkJfZEE5hu
X-Gm-Gg: ASbGncsmPSNS7b3xCJ98UBBA2cMddh1bfk4xfcbGQFpucLJrmGLeg6BGc+Ke4ZK9BVo
	7LB7U3bLPZu9ygxcElSbSYx4/XWzyx6bATke0MZX4lHRP7EZw9xu28J0ExlOEmAXT7P20G9jFYJ
	RtXQdM73PH5z/K0P5lqMKAGsM4FgXO/m3fUfHi0OtZ6PMgDOLu4k/1/BiwEFdypThg0lo6HRysF
	YodalVa6GHhcYAIohysF2tJQeSVuvkY25SfpUL364QujOubjP8eL3flHyC375dJtsuvOIP/Ejc/
	uE+e7JjSdwiBKw==
X-Google-Smtp-Source: AGHT+IGjkCUOPyp9FCLMHbslLbqZzJXPypdP//fUskMq5DkFmSvtOV4TlqlZVNNTd4TNVSEXr+c4/jM98dwnWzbJCoQ=
X-Received: by 2002:ac8:7f49:0:b0:4b7:94d7:8b4c with SMTP id
 d75a77b69052e-4ed617b7589mr7544371cf.0.1762270270683; Tue, 04 Nov 2025
 07:31:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com> <20251104125906.1919426-3-tabba@google.com>
 <86h5v9vnfc.wl-maz@kernel.org>
In-Reply-To: <86h5v9vnfc.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Nov 2025 15:30:34 +0000
X-Gm-Features: AWmQ_bmhJA89LI3vSbI9WLgObKAQrN9YiB8af5ySDlbgGi81lT7jPmV-Xk_U0IE
Message-ID: <CA+EHjTw7KnXVKeyxd4kNysAOMZrJniuBdCNGV=NoWodc3H-rMw@mail.gmail.com>
Subject: Re: [PATCH v1 2/8] KVM: arm64: Trap access to ALLINT if FEAT_NMI not
 supported by the guest
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 4 Nov 2025 at 15:15, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 04 Nov 2025 12:59:00 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Access to ALLINT is part of FEAT_NMI. If a guest does not support this
> > feature, any access to this register must be trapped to the hypervisor
> > (EL2).
> >
> > KVM didn't configure this trap, potentially allowing a guest to toggle
> > all interrupt mask when it doesn't support FEAT_NMI. Fix this by
> > checking if the guest has FEAT_NMI support.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 0f8311263edf..3fc62808c548 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -688,6 +688,9 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
> >               else
> >                       vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
> >
> > +             if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
> > +                     vcpu->arch.hcrx_el2 |= HCRX_EL2_TALLINT;
> > +
> >               if (kvm_has_tcr2(kvm))
> >                       vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
> >
>
> I think this is moving in the wrong direction. We have for quite some
> time now tried to automatically derive these behaviours from the guest
> config, as we do for FGUs.
>
> I would like to see a similar behaviour being introduced for non-FGT
> bits so that we don't have to worry about these things anymore.

I agree that we should make this more like FGT, but since that will
likely require a bit more time (and probably a couple of respins),
should we fix the HCRX traps as they are now?

Thanks,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
