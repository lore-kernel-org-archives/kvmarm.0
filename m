Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A18DC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 14:14:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C9B49F4E;
	Tue,  1 Feb 2022 09:14:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aHAHxSdN5f2o; Tue,  1 Feb 2022 09:14:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9E5449EFB;
	Tue,  1 Feb 2022 09:14:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2FBE49EFB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rpYntJsyGNdx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 09:14:39 -0500 (EST)
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com
 [209.85.161.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B353F49EC2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:39 -0500 (EST)
Received: by mail-oo1-f42.google.com with SMTP id
 q145-20020a4a3397000000b002e85c7234b1so4169814ooq.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 06:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0Mv4cSUeeZweAnsTUqHW1wUxBTbYbtVcIHd+m/V5bGY=;
 b=fCCNxq817wuHQ5Hn6FTacPjcK+/v53kFh+ve+RyVcCTl2IImJNlBc4v9ZWuz7GHzBG
 hZXiRsmVBAn83cRk3DvYCZw0iixXJ/SjeLeIKfD6ReQEE4rQAfzSYUks1JwL6RDNCS0B
 tTrU4+GdmPOQ9b50/Tor9wI+iPKsH9NqYJtnJkG/eO0gNrHOiy6MuNiqTHPbakMZ7nDC
 sYYAguuq7dKuQ+sPHxbM3CMdhDYcUkJ/O6l8MzkPxf6ZGCrkwHwUyqBMXumAKXrglZmB
 bBHTacSaxw4YmH30TKTHRbgz8ucxl+vvk4YeWwmdH3leORh2dRhMJxwd831YzwjtPPGD
 8MfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0Mv4cSUeeZweAnsTUqHW1wUxBTbYbtVcIHd+m/V5bGY=;
 b=yneFzsxIM6TAsPDa1UqoGpgy3cqO+yF+zjwqjF5L16tPBBLew39w6n7VNy0P6b3CUt
 dTOYBYZLdbxVbEL9Ibz8GHJyb3vq8es//u/HvfrAHTnt/4Zqcp+gfSShA8WgP22dbAny
 LsbGHRzyv/PgZjsHzbrhUYOtMPlOD9HVnJcTMdzTB+GJ+YQLJIqPc7Q7MDkeAdB+21/C
 6pIl++dWUkdXDy9AWQmowg3MN8h+pBIoGIcUCY7RGuRWhtNp1Tf3Zhl/xJxxFuaE147n
 Bm9klScyIlrO768j1beJgLGwh582+YPguVFmn6w69hklgk4OMm7VkThi32XU3Tf2P+DG
 zE3A==
X-Gm-Message-State: AOAM530hXTPp9Hs1AYbkAo0kqxFedh6D3EKlL5sqe10m2rzSUeNVMq/B
 xriOvDd7BCMl1OOyFZhHAn23skPmMfC0mOoe2WOBBg==
X-Google-Smtp-Source: ABdhPJxgxV32gOPH0Pj3ssxlVkD9gYwHxKl1vEQqOy/sFPwMIt/lSCEnnpsJKSJLfZZnQKuvk0/voIHWnwUup9EJpU0=
X-Received: by 2002:a4a:a3c1:: with SMTP id t1mr8840770ool.31.1643724878826;
 Tue, 01 Feb 2022 06:14:38 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-5-reijiw@google.com>
 <CA+EHjTxCWe2pFNhq+9gRUJ0RnjX4OcuV2WazDbProUaJE2ZTBg@mail.gmail.com>
 <CAAeT=FzBC+1P3jNuLvF_tLwy-aQehPyJXJ3dmAsijB8=ky-ZKA@mail.gmail.com>
In-Reply-To: <CAAeT=FzBC+1P3jNuLvF_tLwy-aQehPyJXJ3dmAsijB8=ky-ZKA@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 1 Feb 2022 14:14:02 +0000
Message-ID: <CA+EHjTzK_We_vwu6QbR3N4J5wJqF00fKm6rf6X8RA_4Mjg=VXw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 04/26] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To: Reiji Watanabe <reijiw@google.com>
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

Hi Reiji,

...

> > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > index 0a06d0648970..28d9bf0e178c 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > @@ -116,6 +116,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
> > >         else
> > >                 INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
> > >
> > > +       if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
> > > +               /* Set ID_AA64PFR0_EL1.GIC to 1 */
> > > +               (void)kvm_set_id_reg_feature(kvm, SYS_ID_AA64PFR0_EL1,
> > > +                                    ID_AA64PFR0_GIC3, ID_AA64PFR0_GIC_SHIFT);
> > > +
> >
> > If this fails wouldn't it be better to return the error?
>
> This should never fail because kvm_vgic_create() prevents
> userspace from running the first KVM_RUN for any vCPUs
> while it calls kvm_set_id_reg_feature().
> So, I am thinking of adding WARN_ON_ONCE() for the return value
> rather than adding an unnecessary error handling.

Consider this to be a nit from my part, as I don't have any strong
feelings about this, but kvm_vgic_create() already returns an error if
there's a problem. So I don't think that that would be imposing any
additional error handling.

Thanks,
/fuad

> Thanks,
> Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
