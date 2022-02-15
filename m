Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2E8C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 20:24:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C203643C8C;
	Tue, 15 Feb 2022 15:24:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DLk8rdhfEaeI; Tue, 15 Feb 2022 15:24:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB66949B0E;
	Tue, 15 Feb 2022 15:24:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5592243C8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 15:24:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iLbVQ7onGQce for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Feb 2022 15:24:20 -0500 (EST)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF65A49B26
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 15:24:19 -0500 (EST)
Received: by mail-pg1-f172.google.com with SMTP id 75so217800pgb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 12:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nuj8MtZiCZ0Lx7DBYb6yz01ZBRhvgxdg2lUl/zU+F6E=;
 b=F2tjYTu3204GP0Z5o5QyWoyBsYLUrrQbbXjjnHfIRCm4Mat4wvsB3Qzlu1x37bvd3p
 ekBrhI2Dco1JbjJcj+7EmWNcirqDVS4dpZ/IatzkIQwSH1gipIe6klukwC2cDNu2HLy1
 xkOZqO+8NKK3VdSxTYi3lt+EuOHFZ821DqL8og503gcMFIp0GSMx7NglBOv1f2ILrsJi
 HozYH5FZ/c8w0YSRxXc1tuGAn84L1fdw3H+GKos2Dj+ou7+lwpn/xjbPA3FPxAfe9upu
 uT+ykjgcSh/d9nlzsauiqjLn3Q/3KT32HkVU7ed0t9e8BxRyT+kuHOsiNALUZyCtB5rL
 3pbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nuj8MtZiCZ0Lx7DBYb6yz01ZBRhvgxdg2lUl/zU+F6E=;
 b=SWoCPRmIMmM50lkcN2GsKurHz74zWnJ/mOOH28WmLKj+ljKKspDUiYR4TKSNqseRBt
 IgzrCacYWNm1vyx+ryXvhxpNZUfHn7epFt6yKvOwuwUU3OOJlvo4eWNRa/nG+WUzAXIt
 KwygU9ZytjGkBG3wr+fw6qaA50LwLSTGE4r6dHQtNE95tkakQ18vTHENmJjE3P4HNlzl
 8pXg1J3C3/i2kTgwFDuEMR6nmupao/pFEx/qYT3bgbJRQh5SeL+HLi+uovcfk6cv/NhM
 Uct/Ed5GT9SY/z90AuVHxPZr35zSO1MapD6NwWjqLtMYoctZhcN3G6xEeiSO4B7Ib5t2
 ps8g==
X-Gm-Message-State: AOAM533uMepjgLRA1J23hd5bhbl1LsMusrb2Iz3L3bjwhpShNIfnKewG
 o0I2ZAYkUKchSP5lGVYjZPc1EqF6RRQzveCYYPl0UQ==
X-Google-Smtp-Source: ABdhPJwBHHiPnHNUy6seRtqhk/mvMIeHpjYcsa1WSVFlqUGHC6xAUb+jkxyLvyjFKU7X2vr/JyLAaZJUvuWL0JxMtig=
X-Received: by 2002:a63:2b4d:: with SMTP id r74mr512427pgr.514.1644956658930; 
 Tue, 15 Feb 2022 12:24:18 -0800 (PST)
MIME-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-10-reijiw@google.com>
 <Ygv2wS8qdlu1YnA6@google.com>
In-Reply-To: <Ygv2wS8qdlu1YnA6@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 15 Feb 2022 12:24:02 -0800
Message-ID: <CAAeT=FyGPdpBuS_-StugLMkrwX2XrypB5ZktdsjX78K8P6khuQ@mail.gmail.com>
Subject: Re: [PATCH v5 09/27] KVM: arm64: Make ID_AA64MMFR1_EL1 writable
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,

On Tue, Feb 15, 2022 at 10:53 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Feb 13, 2022 at 10:57:28PM -0800, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_AA64MMFR1_EL1 to make it
> > writable by userspace.
> >
> > Hardware update of Access flag and/or Dirty state in translation
> > table needs to be disabled for the guest to let userspace set
> > ID_AA64MMFR1_EL1.HAFDBS field to a lower value. It requires trapping
> > the guest's accessing TCR_EL1, which KVM doesn't always do (in order
> > to trap it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which
> > also traps many other virtual memory control registers).
> > So, userspace won't be allowed to modify the value of the HAFDBS field.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 4ed15ae7f160..1c137f8c236f 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -570,6 +570,30 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +static int validate_id_aa64mmfr1_el1(struct kvm_vcpu *vcpu,
> > +                                  const struct id_reg_info *id_reg, u64 val)
> > +{
> > +     u64 limit = id_reg->vcpu_limit_val;
> > +     unsigned int hafdbs, lim_hafdbs;
> > +
> > +     hafdbs = cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_HADBS_SHIFT);
> > +     lim_hafdbs = cpuid_feature_extract_unsigned_field(limit, ID_AA64MMFR1_HADBS_SHIFT);
> > +
> > +     /*
> > +      * Don't allow userspace to modify the value of HAFDBS.
> > +      * Hardware update of Access flag and/or Dirty state in translation
> > +      * table needs to be disabled for the guest to let userspace set
> > +      * HAFDBS field to a lower value. It requires trapping the guest's
> > +      * accessing TCR_EL1, which KVM doesn't always do (in order to trap
> > +      * it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which also
> > +      * traps many other virtual memory control registers).
> > +      */
> > +     if (hafdbs != lim_hafdbs)
> > +             return -EINVAL;
>
> Are we going to require that any hidden feature be trappable going
> forward? It doesn't seem to me like there's much risk to userspace
> hiding any arbitrary feature so long as identity remains architectural.

That wasn't my intention, and I will drop this patch.
(I wonder why I thought this was needed...)

Thank you for catching this !

Regards,
Reiji

>
> Another example of this is AArch32 at EL0. Without FGT, there is no
> precise trap for KVM to intervene and prevent an AArch32 EL0.
> Nonetheless, userspace might still want to hide this from its guests
> even if a misbehaved guest could still use it.
>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
