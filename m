Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE8F2EC097
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762283100; cv=none; b=rUYjFGaZV/tIFHYZF3s5/ua6UoCA9ClMAVUCYueYcdMgJN6b1hKUDQx6z9BOO6PFGY43ZvEYrMnZ7e10rVXvjeewqWsBlBRQ4byFFuHkoidw1PPqljxLgB9yIdSd2MQyct5AeMwfIrih6ru7No9L7cmZ/vwZIQWM2cm+PG4Un28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762283100; c=relaxed/simple;
	bh=89V8K2+Hy3pddx5jQv0NDgbSCgtJqc438ejFwmQAP/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgwAGtBz42spcuX8uvn4j2wIAGfdTNsMVz8cVb99JJdJZ2I9S+PSqmHQBuFSXMUjzd/6iL5tsDRo41+/CJ8re1hIjCOPXJDTClAqrvinQTPGJZLNXTODnOJRZRpp7SbdHCh4Pncgz3zDrkpbTVQ4MgSyM5QwHnm7iXuqJsRDqbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JF+PNC7v; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JF+PNC7v"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ed67a143c5so30651cf.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 11:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762283098; x=1762887898; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5T9Z6UoyDLZbu/1k5b1T2wqbCAFrlV4h6XEJSvtC98=;
        b=JF+PNC7veXjiuFznjgs3pyLWLQOZXHEBvcnrHk/ywkQ2+uTp7MoeieBc2sFlSMvB4U
         Aw7WOKa6LN+cP3Z3Iymj8tZgGWNSAlsiAfF3O5zh/oD50pPDM6PSbqctBZIk+tVY15n2
         gJGapcFdh1w585GrMQr+stsBqwG/4Fli99RUz275E2p6VzzGh+y3dKcFmpU20FHsdyrT
         aS4UdCH3D7aHbfljSSqg/GhhBVxm0NEzSG2oRLEmSuy23h3ECp+3YgLvJEaBihsXnBpE
         CTZLC5tL0Y6qiM5zr+83fEa9r2bw7Y4F6X8ODT1w+O+jLLdkSKQkgKlmKpGClFfpzalG
         N3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762283098; x=1762887898;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q5T9Z6UoyDLZbu/1k5b1T2wqbCAFrlV4h6XEJSvtC98=;
        b=FJR3bMxpdoo8N4lbNA2scl2Wm/rtFywzzg3uq8eVc8S3xDZ+RKOJhlY8W33zngVzqJ
         +AGGdrEYWgvp0fiKgGY6CpbBH6zGUiQ+ekmzQ+c57Bid86fbeNamoyamWwdllaUQDWu5
         Nnckr3I//n5zdbJiFMiSRFlYyXd5aNd8kggOxr5WS5tZye6py2EaCCMzS5x9MpJd2SIA
         Y3VT70oWgx2Av3Xk2wQFPF8El7NKlFQti9MXXisBigJL7Vm8K6RPYEmFdTf0LDo20y5O
         3OYw6mvBVAz2+G3YmsYJDb1subYZupqJYRlqsl7D0VMiSfAKdwkbcKZ+m5MpLnJ9tGeK
         F5qA==
X-Gm-Message-State: AOJu0YwM+k1+RDXJUaHX0sRRsccyPQH1iqEY556Y5WnH+efifQIS3RZP
	8PDiq5/LuVrhPgUg+ViCUhqqykK71WIL5HJFvc1YEZGL/s//Am+4TK+jDyZNAtHFglC2w/EOVYC
	BLdLq2e7jTxS1rZDDVDduV6Y414xL1D7M+NncB1rY
X-Gm-Gg: ASbGncu9R6qJTuIlOR9Qk2L0cy/fptLAz57glb5EWAS2d0haaK+cFdVA4FxYGa4XoVH
	zRbpJSJNS7O2pOMJbz02s+bV90LNCThKlPLE4L+Vr3JA1tZfQ5HSo+i3Jh2kPkdcvTNLhbWa+wX
	VuS/Bm3kTvqvwWUOGTWctuXz5XysRuUfqz2jAb4hXTnU/cVFHntDkF39Wrw8dJ5R7Sl/WCOiTso
	mtFDGCdy+DQ6i3nmjSIELnGg/l/kAECOtab31bqnTb7BN4t6fL6yuEKVXWwPg==
X-Google-Smtp-Source: AGHT+IEXght+18UDdhRYqn8WNnXdZZ8DDF1K4rJ6QojfMfxG5vWmOJEkSqYHurrMJLnbhgGwTwCMYgkHt1EiuY3Gy5Q=
X-Received: by 2002:a05:622a:14d4:b0:4e8:85ac:f7a7 with SMTP id
 d75a77b69052e-4ed7369911dmr416821cf.9.1762283097763; Tue, 04 Nov 2025
 11:04:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com> <20251104125906.1919426-6-tabba@google.com>
 <a0b19558-dbcb-4231-b0c4-302cc10652db@arm.com> <CA+EHjTwPqm5wkmdGK60sn+S9BizK6LG5bSqWQLigsZVgXoJmUw@mail.gmail.com>
 <fbe0d81a-c4c2-46f5-b809-1b74f9307c98@arm.com>
In-Reply-To: <fbe0d81a-c4c2-46f5-b809-1b74f9307c98@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Nov 2025 19:04:20 +0000
X-Gm-Features: AWmQ_blncW2qCzgwgBP6dGyIM6hPJ2g29b3o7-4BRp6ltNDvSRRT2ZrMeg3mfYI
Message-ID: <CA+EHjTxVFOj+NXt4eQupHNUBB4UwwMQEuhGiGo8F=nX3tjmZOw@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Nov 2025 at 18:03, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> On 04/11/2025 17:56, Fuad Tabba wrote:
> > Hi Suzuki,
> >
> > On Tue, 4 Nov 2025 at 17:50, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> >>
> >> On 04/11/2025 12:59, Fuad Tabba wrote:
> >>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> >>> register accesses. These accesses are trapped to EL2 when the bits are
> >>> clear.
> >>>
> >>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> >>> had the polarity inverted. When a guest did not support the ExtTrcBuff
> >>> feature, the code was setting E2TB. This incorrectly disabled the trap,
> >>> potentially allowing a protected guest to access registers for a feature
> >>> it was not given.
> >>>
> >>> Fix this by inverting the operation.
> >>>
> >>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
> >>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>> index 43bde061b65d..df0c59a29b35 100644
> >>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> >>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> >>>                val |= MDCR_EL2_TTRF;
> >>>
> >>>        if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
> >>
> >> Why are we checkin ExtTrcBuff ? Shouldn't that be TraceBuffer ?
> >
> > This is an existing bug that needs to be fixed. Thank for spotting it.
> >
> >>> -             val |= MDCR_EL2_E2TB_MASK;
> >>> +             val &= ~MDCR_EL2_E2TB_MASK;
> >> This looks correct to me.
> >
> > I don't thin it's correct. E2TB traps when clear, not set:
> > https://developer.arm.com/documentation/ddi0601/2025-09/AArch64-Registers/MDCR-EL2--Monitor-Debug-Configuration-Register--EL2-
>
> I meant your change to val looks correct.

I see, thanks :) I'll fix the existing bug when I respin this.

Cheers,
/fuad

> Suzuki
>
> >
> >> Suzuki
> >>
> >>>
> >>>        /* Trap Debug Communications Channel registers */
> >>>        if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
> >>
> >>
>
