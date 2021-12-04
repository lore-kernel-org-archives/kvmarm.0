Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FDEC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Dec 2021 07:59:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 687C34A7FD;
	Sat,  4 Dec 2021 02:59:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4jXCJ3fk9JuJ; Sat,  4 Dec 2021 02:59:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AC2049F8F;
	Sat,  4 Dec 2021 02:59:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 489E7407ED
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Dec 2021 02:59:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KBjISey-5T79 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Dec 2021 02:59:42 -0500 (EST)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9476540642
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Dec 2021 02:59:42 -0500 (EST)
Received: by mail-pl1-f170.google.com with SMTP id k4so3651489plx.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Dec 2021 23:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/HNVa0CxFfdOsv36W3pOGvXrawzXJwdYz3KBqa4NE8A=;
 b=TeXbYPX+C4uPkxaaFLcgtGGJEujSGWZEHwDDrNsBd0VadDAJvtlEj0Iag/3oEQobME
 mSCi0i0sZxUT82ObDMEopmUc5fT1bocwKCmhlzBsTpDBbCM/IqCMysRkVQSU+hIZ7W7T
 LTv4Eu4l4MZEJbIFAIRPLCZ4Oft79rV92CR8Xiiu6hhYA3+cI+eJSANmXynO6hNagk+X
 PsCdOG46OFzs4b6BiZDMZmsQq2WBmlBcTLm2zeMSzGeWSsiUNSVYe8vzONKfJp3U3FZM
 b5P+jP/tiAN+/CZkQbUBIlshH4OQzIoWIa9LTfHBBeOTC7XD3aQW/gMTBYmwZQrugEgI
 PE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/HNVa0CxFfdOsv36W3pOGvXrawzXJwdYz3KBqa4NE8A=;
 b=oUF6qq6ML7BZMDLirzNYo1fj00bq1HJLGtYGBSbDTogYOl10J4onS1nwQePfpu/fp/
 /hWK7E+MEB8wn1B3bHDuH7u5NiejBQUMRGvMPfczU0fTBavtBG7vRWT/t7xzDsbnQ//L
 Cv7QYtZL6FoCLE19bxNacfHDaN+DisHG8afsdlx/z6SnAuYXtUEK51gctjvPRV6tj6si
 c3gSV9IL82x5lELjOu0m8aAj2kYEMOyQf7wpYkLc1JIt/Km58LTJ8OzwYsq/9NNvEoW5
 RGhC0MiMEAR06oX3LXyTtDloKU7TJjAV2uPRi+ac6mpSBuEJBKRX0Of5BRMRPdlL/ob3
 dzbA==
X-Gm-Message-State: AOAM5333C3Q/d7QfviV9DqgJa/W9BtCz6J6OxJaCzg8jCvxG3oTl8Zvs
 144vZPwd0uwxjmfirjMCZJY3R+sd54ksUe9/J+mRMw==
X-Google-Smtp-Source: ABdhPJz/LZkSzORmcnKM+1dzW2Nc3IsEy0R3q6edufSEOKTPTDCILwf40IG7uWOovBicDJ7eg3FHc1anE6oqqnkjUB0=
X-Received: by 2002:a17:90b:4acd:: with SMTP id
 mh13mr20584196pjb.230.1638604781530; 
 Fri, 03 Dec 2021 23:59:41 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-5-reijiw@google.com>
 <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com>
 <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
 <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
In-Reply-To: <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 3 Dec 2021 23:59:25 -0800
Message-ID: <CAAeT=Fz2tLMDOkZ4kQYV0tS44MEtSUxPH71+XD3r+VyJxbjd_g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To: Eric Auger <eauger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Eric,

On Thu, Dec 2, 2021 at 5:02 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/30/21 2:29 AM, Reiji Watanabe wrote:
> > Hi Eric,
> >
> > On Thu, Nov 25, 2021 at 7:35 AM Eric Auger <eauger@redhat.com> wrote:
> >>
> >> Hi Reiji,
> >>
> >> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>> This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
> >>> userspace.
> >>>
> >>> The CSV2/CSV3 fields of the register were already writable and values
> >>> that were written for them affected all vCPUs before. Now they only
> >>> affect the vCPU.
> >>> Return an error if userspace tries to set SVE/GIC field of the register
> >>> to a value that conflicts with SVE/GIC configuration for the guest.
> >>> SIMD/FP/SVE fields of the requested value are validated according to
> >>> Arm ARM.
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> ---
> >>>  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
> >>>  1 file changed, 103 insertions(+), 56 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 1552cd5581b7..35400869067a 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
> >>>               id_reg->init(id_reg);
> >>>  }
> >>>
> >>> +#define      kvm_has_gic3(kvm)               \
> >>> +     (irqchip_in_kernel(kvm) &&      \
> >>> +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> >> you may move this macro to kvm/arm_vgic.h as this may be used in
> >> vgic/vgic-v3.c too
> >
> > Thank you for the suggestion. I will move that to kvm/arm_vgic.h.
> >
> >
> >>> +
> >>> +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >>> +                                 const struct id_reg_info *id_reg, u64 val)
> >>> +{
> >>> +     int fp, simd;
> >>> +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
> >>> +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
> >>> +     int gic;
> >>> +
> >>> +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
> >>> +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
> >>> +     if (simd != fp)
> >>> +             return -EINVAL;
> >>> +
> >>> +     /* fp must be supported when sve is supported */
> >>> +     if (pfr0_has_sve && (fp < 0))
> >>> +             return -EINVAL;
> >>> +
> >>> +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> >>> +     if (vcpu_has_sve ^ pfr0_has_sve)
> >>> +             return -EPERM;
> >>> +
> >>> +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
> >>> +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
> >>> +             return -EPERM;
> >>
> >> Sometimes from a given architecture version, some lower values are not
> >> allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
> >> Shouldn't we handle that kind of check?
> >
> > As far as I know, there is no way for guests to identify the
> > architecture revision (e.g. v8.1, v8.2, etc).  It might be able
> > to indirectly infer the revision though (from features that are
> > available or etc).
>
> OK. That sounds weird to me as we do many checks accross different IDREG
> settings but we may eventually have a wrong "CPU model" exposed by the
> user space violating those spec revision minima. Shouldn't we introduce
> some way for the userspace to provide his requirements? via new VCPU
> targets for instance?

Thank you for sharing your thoughts and providing the suggestion !

Does the "new vCPU targets" mean Armv8.0, armv8.1, and so on ?

The ID registers' consistency checking in the series is to not
promise more to userspace than what KVM (on the host) can provide,
and to not expose ID register values that are not supported on
any ARM v8 architecture for guests (I think those are what the
current KVM is trying to assure).  I'm not trying to have KVM
provide full consistency checking of ID registers to completely
prevent userspace's bugs in setting ID registers.

I agree that it's quite possible that userspace exposes such wrong
CPU models, and KVM's providing more consistency checking would be
nicer in general.  But should it be KVM's responsibility to completely
prevent such ID register issues due to userspace bugs ?

Honestly, I'm a bit reluctant to do that so far yet:)
If that is something useful that userspace or we (KVM developers)
really want or need, or such userspace issue could affect KVM,
I would be happy to add such extra consistency checking though.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
