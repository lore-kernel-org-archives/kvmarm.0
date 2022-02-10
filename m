Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3D5C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 05:33:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A72CF49F0C;
	Thu, 10 Feb 2022 00:33:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RUfvBYadsuTD; Thu, 10 Feb 2022 00:33:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 825E849F13;
	Thu, 10 Feb 2022 00:33:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE09349F0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 00:33:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dk1GgY4VG9p3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 00:33:55 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60AD649F09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 00:33:55 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id y9so4205677pjf.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Feb 2022 21:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4S1PGlBITDbPfDHxEWfVav4BYHFT1sybX2IDUqfuWTQ=;
 b=isDaEpKYGvxkxAbKsHb9vCzaGtOkhUtqMKoKEgF+nkKbnZtS8+ac5cIFoVRR23suou
 GVcLttonHw8byyKbCHgqQ0YS8UDZ+WQkPQBf+7svOSZ7NojZkt3+H45Kl7kRIpSoawW2
 hRgvESlJS+kiKrWMJBAracoDlptVNsidTAYCHcsrI8pvYmmg2WLY5MFCmbAnCkBo7uzI
 S1U25BcrPqOG04jupyggHGdQBLvFa05TvdYN8SZ87q3tEgqOhdx4okHKJRZ3g24uFoaJ
 BsmhtRgY0YthsOyByDn65K7Uz879V77+rlGFxz9XCkn116Pnb+3C3ElFjDZrZP0WTz2S
 +FSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4S1PGlBITDbPfDHxEWfVav4BYHFT1sybX2IDUqfuWTQ=;
 b=yp75OLNE4wlf2/kdKvmTQaAbr7ahO6DdwKi4lgdIIRPiL/RV5/ZGZNhIFTv6hTsmRa
 0/dWZGPRHe3jZpbEWv3HzljmEKU/fracyW2pnOIWEG6rqGDF4tDWdNasQqflfVJs/UUR
 kV0OrKAZvvYzvjBVVzK2kMcR2epUiATwM2QEl2snhTGuysR80AN4y+ip6cZP5FUMsq6o
 HapQEK6i7ByuxqeyudGuLgHxY0gXd+P7XP77CQCrSXJ+CHwLyVVY/b8X42DyE5lSGiev
 N0vOODdv3sRVSHMxF+Fz1Ba+SLnzMffKxwhfuy1PBHf8/KjDOr8yHfPJb38p7YfojquN
 pTCg==
X-Gm-Message-State: AOAM530PS2PNYAal5wd+7ZXJGm0upj8qVuxphfuPdcmZ9l5J5v2vV1vg
 Dgv9AB2FF7EB0F06vwl3NWQL1zdeEjXg9F/IQ8jwTkvTPpA=
X-Google-Smtp-Source: ABdhPJyOYpAB/1KVlL9BpGn1hBcrVObh/j/ZODwkPJefZgNp7E9L6Xi+YRMLTn6dQNZAMk+w8rpZ0mbxDKUleu0QqeE=
X-Received: by 2002:a17:90b:390a:: with SMTP id
 ob10mr1074103pjb.110.1644471234298; 
 Wed, 09 Feb 2022 21:33:54 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-5-reijiw@google.com>
 <CA+EHjTxCWe2pFNhq+9gRUJ0RnjX4OcuV2WazDbProUaJE2ZTBg@mail.gmail.com>
 <CAAeT=FzBC+1P3jNuLvF_tLwy-aQehPyJXJ3dmAsijB8=ky-ZKA@mail.gmail.com>
 <CA+EHjTzK_We_vwu6QbR3N4J5wJqF00fKm6rf6X8RA_4Mjg=VXw@mail.gmail.com>
In-Reply-To: <CA+EHjTzK_We_vwu6QbR3N4J5wJqF00fKm6rf6X8RA_4Mjg=VXw@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 9 Feb 2022 21:33:38 -0800
Message-ID: <CAAeT=FyHGY3ypVQt_P-a8Mj8G_FMUtuwgdhos=DWV1SPeemC7A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 04/26] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Fuad,

On Tue, Feb 1, 2022 at 6:14 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> ...
>
> > > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > > index 0a06d0648970..28d9bf0e178c 100644
> > > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > > @@ -116,6 +116,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
> > > >         else
> > > >                 INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
> > > >
> > > > +       if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
> > > > +               /* Set ID_AA64PFR0_EL1.GIC to 1 */
> > > > +               (void)kvm_set_id_reg_feature(kvm, SYS_ID_AA64PFR0_EL1,
> > > > +                                    ID_AA64PFR0_GIC3, ID_AA64PFR0_GIC_SHIFT);
> > > > +
> > >
> > > If this fails wouldn't it be better to return the error?
> >
> > This should never fail because kvm_vgic_create() prevents
> > userspace from running the first KVM_RUN for any vCPUs
> > while it calls kvm_set_id_reg_feature().
> > So, I am thinking of adding WARN_ON_ONCE() for the return value
> > rather than adding an unnecessary error handling.
>
> Consider this to be a nit from my part, as I don't have any strong
> feelings about this, but kvm_vgic_create() already returns an error if
> there's a problem. So I don't think that that would be imposing any
> additional error handling.

That's true.  But, since this failure case cannot be caused by userspace
(but KVM's bug), I would still prefer using WARN_ON_ONCE.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
