Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C1E28688C
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764157769; cv=none; b=qCAYMCadtmQNQjduqKFnDssxTTq1YZSW04etARU9Xv/wnOz3I53/WL0hhoUJEs31lIGMkGQfHwMQnO0MmluU6WQ5tDEWTMg1fPrVfnYUvEM5UxXbqQCoVcU3NY21RdxNFxq01KM8NFYGwhLAUQ5dIWIkTQ/RSTpI3KtRcecDtX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764157769; c=relaxed/simple;
	bh=NMCm/cIX7311ko5Z5z4kydupzCg+tRPz6tzlyE8WmM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oAOQ/XMHjaMCQW/qfX5gt7Qf02L1ndAhPunqJh+P+p91i50n0EFk+kqPmKBopMjg8DefG5iY/GqJPCBzZ4/woBXEB5uotNFme5wd/3HtZx2Bb4lo14vdEDAmTdsEzgZGqzzmv0fd0Gklef1vNR4ecp7j6apioRH2OyvLWwIaU8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1niD3sUG; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1niD3sUG"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee147baf7bso216091cf.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 03:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764157766; x=1764762566; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kr3qwrLRk4v2y/s5BXARDD9+PbbRYtmC9PW2DSjFBz0=;
        b=1niD3sUGcFf71Q8czczoKTvimDXQNG3rSTuViB6cb8r3nnp/61IGtjmDstFefUe3Cc
         LCqzqYLXRcU2B4rmKCvGjz+1m1vRqIUUM94xxiHJJxVjvWxKVblsxPmNrKNpEu7Kou3h
         LM607vAQea1DAmQ0FhUUEWvpSQ2qeO2RBheCU+00axik3tI8qwWqvee6hVQLWLGceQFM
         UBfSOYxMtBhYvsqVjBbUKvJX2ZRxCrqfx5n7hTDZqMPiNREl5etd4lVJjl2Yu746GtnQ
         Yt/M5o5KC304HZHW8UuQV1+OOxSs7cPzbEovOkkt/JTV+GriUvhR2RpXYu6FeUaDKkhz
         smAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764157766; x=1764762566;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kr3qwrLRk4v2y/s5BXARDD9+PbbRYtmC9PW2DSjFBz0=;
        b=DmtmbQqfB+ypIrC8JLG2b4a65bYoslfbylmyLeaZqz/VqWEMb7+sHfDUU8G0eaq1Vt
         l1GsRo6yd6rl+PXDB4O+sXbglf3ruW9u5NqaIqIgTB+BIB0MLHuVlpgbgW36TNH5VSe8
         NHcbNcKcm/0q07q0ge3jotZTC7X1HMoERDhMH/OxGMJqUcSTe6R6OzQQBoAzpu7+AGss
         4Sfw+TahtInOR00FLDEWM2MEJ0+DNvGIt6pElgB+4vm9yaWnQOL0wxN1ynhjIZtN8of7
         rfZV7h7w7SamGxogkQtIpGNB823+yYhwB/8eYelCHbF14C+u4SdFllfwqB4CPX9g3xTI
         uo7A==
X-Gm-Message-State: AOJu0Yyxmz8tLe/y0cLAKYMN/IJDA0T4QZsez8ZjQRsap59ebYDPEUCA
	CPUKBCNVItpmxkj37ZD1yjob/Wp7/HwTip+2rfShVIcmyBZtQmABCZeg080HHyAa06G06HWxIVW
	rLt86AGolSanUIffZsmID/9seCswu1yCN5agDFV5W
X-Gm-Gg: ASbGncvqDi7SaeGM/G1+WgfmC4ZtQQfs1tOvUQGvjzoReDczjkfUtpQfESzain2Ahcf
	sG2umVvS1FYj15aJBStlgOpzdsC67OM9Bjxz5IUITdLX60CZy6KwMltwb6GM/z2OImEHbXhxWH1
	oES+QpodFGNVeQzPtiOAMywKnZDEOUUskj/ofS39J5mMyWuQRLo7ZdctR4GwBXJYavQ6Bng1kG6
	tSf++uI6CdVLIqs06Bs9Thm8iUxErqBti0uKm+kq3P+Kbkrm4cMbzrB1Icceqtershzni4YQlM+
	ScuPlOwGgf3jCVWEBBYn4jUoZHqDmd28oz0=
X-Google-Smtp-Source: AGHT+IFT30zb6Vmyhh/ZY3aMrC8XWe6qd4Iv+A4t88+50yH5QFBLi99beNKd09a29+A04Gvb4d9EJyYi8xds41jsviE=
X-Received: by 2002:a05:622a:3c8:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-4efc83c47e9mr3916231cf.19.1764157766175; Wed, 26 Nov 2025
 03:49:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com> <20251118103807.707500-3-tabba@google.com>
 <868qftqehe.wl-maz@kernel.org> <CA+EHjTwHrLhdHrNSA8f-+bCZ1-QEuNocQQxeiaaost9oLwaG5A@mail.gmail.com>
 <865xaxqal2.wl-maz@kernel.org>
In-Reply-To: <865xaxqal2.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Nov 2025 11:48:49 +0000
X-Gm-Features: AWmQ_bmAonQV6lX6CJR23oCHhfHyu2-Eny56MVRap83EMYa4CBEecAcKDPm5NxU
Message-ID: <CA+EHjTxhOvu-733Z-gJgc6f_EAs-tksA6u5KuQZeimP6T6M-fQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Nov 2025 at 11:47, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 26 Nov 2025 10:37:57 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Wed, 26 Nov 2025 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Tue, 18 Nov 2025 10:37:59 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> > > > register accesses. These accesses are trapped to EL2 when the bits are
> > > > clear.
> > > >
> > > > The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> > > > had the polarity inverted. When a guest did not support the Trace Buffer
> > > > feature, the code was setting E2TB. This incorrectly disabled the trap,
> > > > potentially allowing a protected guest to access registers for a feature
> > > > it was not given.
> > > >
> > > > Fix this by inverting the operation.
> > > >
> > > > Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > > index 8d06a246dfd1..f6f8996c4f97 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > > @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> > > >               val |= MDCR_EL2_TTRF;
> > > >
> > > >       if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> > > > -             val |= MDCR_EL2_E2TB_MASK;
> > > > +             val &= ~MDCR_EL2_E2TB_MASK;
> > >
> > > This does not only change the trapping logic (bit 24). It also change
> > > the ownership of the buffer (bit 25). I wonder whether you should do
> > > something for that, maybe by clearing TRBLIMITR_EL1.E, because
> > > otherwise, you keep tracing, but using an EL2 VA. What could possibly
> > > go wrong?
> > >
> > > Overall, I'm very uneasy about TRBE in the context of pKVM.
> >
> > So should we clear/restore TRBLIMITR_EL1.E on guest entry/exit in
> > protected mode?
>
> I think you need something of the sort, yes. Overall, SPE and TRBE
> should be aligned on what they are allowed to do, as they are two
> sides of the same ugly coin.

I'll fix this (or add a patch to do this, depending on how it looks)
when I respin.

Cheers,
/fuad

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
