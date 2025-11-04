Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC4A262FC0
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762279058; cv=none; b=q2B81B+vxTuvZ8hGabFMtW3jvhLUTRK3rYL1LGmATGKGe8e1PeEXnMCNy7/LrK7mWjg0covqg37/skYrGeVVoEd1DAaszXyRdGQcasJ+2dvzxVK1YvXQXSeF5UXUIETCP3eUHVIGUDwvfiD8tajYUKlJaCFod0U0Q5R2tSmRGos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762279058; c=relaxed/simple;
	bh=2jPSWKegOMg7faVyLaQnSgZp5kDRxl6Borpiag/vnLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y15pKMUavCbbyUZz/oYkL0Ad4ETC9C+ykmuvj+9VoU2sIY/oUmP2+46HoD8my4R+LNT18tcq38FHCJ/cDhO788i9JHgohmJyaJBfH/5oUi/q93O+sATUOF7FkDBSvTOj/CrY4Rq3AzCrh7FZ0UUVcQK4M77UrpC8qMqsEmCDxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F7uE7uE3; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F7uE7uE3"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ed6ca52a0bso11851cf.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 09:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762279056; x=1762883856; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jb4EiG1cKlRDr3ZrWg4hV76AaJf8Zy383HOlZZBw2Lk=;
        b=F7uE7uE3BZyfTol+iDoVVXxhkWDKYPxEiRfsh4SiPb8IuhRdrFOp/+Sk8erTYKr/9H
         zQXaqrgiKNFWpYnkuvf1D3g6f2NZHYKfqpHEq+TjlgY2dSECCW4q8p9uSH0Ta3GYH+Nv
         6rcl7FkrcRpJr2Zxlis/C7NAqzn52/ORJp4O/X73bhttnZDBFIWGH7TWWX7SD8Y/1LDB
         aRI/h9pRfH0MevJzdOnzfA5VD1fCShwgVHCkCgtYQuKIMPmY5Bbpl/MWLgLBfTlnLQay
         ma2XtRqwrzbQgMBfUd/RoSd8Eb9ddoIYmFjk9Ar3agMeAURASZ6KKsYGY2FnzhhQ6I1j
         JKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762279056; x=1762883856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jb4EiG1cKlRDr3ZrWg4hV76AaJf8Zy383HOlZZBw2Lk=;
        b=TxL4Z6C4wNnoWqQImd+iVPHDjrIrRKjrPFCX/YU+pnlZpre0BxsLUBWFiGXYdd+r0g
         FtGeH21X30rQWV5ou+WmoBniNfecE7LzAM1AObotvlJijlgEKUbezyyP6wh/39HGk24K
         CKeZRMEjKVvF7nSshTXIuu8lW/WHCaHI/Pjllbp9vXHrHW+oThCUvxBVUOt6/cxVFpYb
         EGn/SZTtHMgcOJfKk61YtHnYJFor1+shvyglytrQMBX4eyrY2ZQ2hPdLljmXimB9//ll
         jEzw1frnEsmpz3gqQ3nq+GiX7WeZZjkAvP8hqBD4ORtqs6c+9a+MJd/Y1l9r20IlCwVq
         zf2Q==
X-Gm-Message-State: AOJu0YwTfkTdpdPZQz/y4IuHdl9lHKC8OquWe4GKZ8TR42amRzztqw5R
	v0iSYRx+Z4gqFfZBLoGN+e8y4lbDaNixH0P8tTyTggn+7FoZE/YHJgSvradvo807H0g8toPdMxM
	NZQhzjdwMmvN6FtUn7F71aky1Y3dXx2bCkgfijPKH
X-Gm-Gg: ASbGncslI2td39uAaFFWw35uRMX1slYujlMchTirDFTLpGUqaexwsjGxzVO377WCQst
	rYTcb3ap+KtoHMTIF5VxiENCUnIu2P6UDk253qWgdoUnJrfJD0rCrmF1N0UeZHWZsH+7mADX8WP
	aQuLBT54iadbIFOX55HR/o9R2cPJSdFAM1WM6mzUEDRs0CIqhhkl+Baezw/r94dn/y7XgmYsIw4
	IyRanWfPK89urh5CRc9VT5DY8P095bmrgVyAwvyJqZAOcp8MMe9HucxUpb0zQ==
X-Google-Smtp-Source: AGHT+IG0VJh2q9I6lpulhETeYqGjsEZHYw4x4EcIq2IDc3ASKPP8Z/KUgikANjcaHrTbKg5xgVZq38OQMSkaxmAXg7k=
X-Received: by 2002:ac8:5e51:0:b0:4e8:b04a:82e3 with SMTP id
 d75a77b69052e-4ed61bf9464mr7281931cf.10.1762279055815; Tue, 04 Nov 2025
 09:57:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com> <20251104125906.1919426-6-tabba@google.com>
 <a0b19558-dbcb-4231-b0c4-302cc10652db@arm.com>
In-Reply-To: <a0b19558-dbcb-4231-b0c4-302cc10652db@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Nov 2025 17:56:59 +0000
X-Gm-Features: AWmQ_bnag7lXsJ9mn0GfG63SyUcw-QZVD7to_jR_Go2OWvRrYrrbE7F4qdFrXGA
Message-ID: <CA+EHjTwPqm5wkmdGK60sn+S9BizK6LG5bSqWQLigsZVgXoJmUw@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 4 Nov 2025 at 17:50, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> On 04/11/2025 12:59, Fuad Tabba wrote:
> > The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> > register accesses. These accesses are trapped to EL2 when the bits are
> > clear.
> >
> > The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> > had the polarity inverted. When a guest did not support the ExtTrcBuff
> > feature, the code was setting E2TB. This incorrectly disabled the trap,
> > potentially allowing a protected guest to access registers for a feature
> > it was not given.
> >
> > Fix this by inverting the operation.
> >
> > Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 43bde061b65d..df0c59a29b35 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> >               val |= MDCR_EL2_TTRF;
> >
> >       if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
>
> Why are we checkin ExtTrcBuff ? Shouldn't that be TraceBuffer ?

This is an existing bug that needs to be fixed. Thank for spotting it.

> > -             val |= MDCR_EL2_E2TB_MASK;
> > +             val &= ~MDCR_EL2_E2TB_MASK;
> This looks correct to me.

I don't thin it's correct. E2TB traps when clear, not set:
https://developer.arm.com/documentation/ddi0601/2025-09/AArch64-Registers/MDCR-EL2--Monitor-Debug-Configuration-Register--EL2-

> Suzuki
>
> >
> >       /* Trap Debug Communications Channel registers */
> >       if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
>
>
