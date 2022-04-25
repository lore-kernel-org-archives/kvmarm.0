Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C279BC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 16:52:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2224B1E9;
	Mon, 25 Apr 2022 12:52:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fGqAUHL-PuO9; Mon, 25 Apr 2022 12:52:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D83F54B1F0;
	Mon, 25 Apr 2022 12:52:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBBF54B1A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 12:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lFF5mJLMOUvQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 12:52:08 -0400 (EDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6708B4B11A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 12:52:08 -0400 (EDT)
Received: by mail-yw1-f179.google.com with SMTP id
 00721157ae682-2f7c424c66cso63312867b3.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 09:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zFVXbK88HMZ7irS1EV3QbO6i92VJWq/msMeGHj6PNxc=;
 b=bUVEaQ2wIuKybo7kKQmoFYoEvIZ5UirP/KvquexNzuYtWoi/ArniVP0TSRhp/xPvF4
 pjO88yRVQp/fFable34gX1YDVyJpMA9C9G2vEf8Kz486GPzw+RzufdXY/0jM7gTVCCsg
 PidMDRcF1CNXJn+3SjKJOWvA3RIB/cb9JqrhsFBu+iWytoAeilSrA/RMTgGjycGiMs+r
 5N3rDehjoLGsJNyxZeUrYK3zFPcD2g2ZEbJpTAcnk8wQD7D/F/BZsTof8SScGzFdqDS7
 6k9Kc58dLAu+v9oHuXu7fYVxWXbc48epu/owuKJq0cWH+V02p84jlw6M/HppCcWvNYzi
 MMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zFVXbK88HMZ7irS1EV3QbO6i92VJWq/msMeGHj6PNxc=;
 b=l5Xgw2hFeRRFMngvpAObYiLve05xt/dt5oU1fY8cjhA9mV0U+pUCOpAheI4Pnup8V0
 fP6+9IxWgZt6b7AoRVf2Km1PO1QO/bz9vP7/QgIMFcWkuQK4STWjdF+2gho/Gf+ep9Fw
 2ugWY2Xx3yh1vn1/lokzDtykVoT8aNPQw2yHOlBvKPkzttX+t146mvZjp4mn2ax4jnVJ
 jvvDfb0yYtq5kxfeIPLcR7tJ0C7DKzfTTYEBWQ5fr9NLDwk3/B8AYk2W1iHnO3WKd2Ap
 v9sDjrzhTGvgZoI7/LEsmCQRZARnPZPs1JPNO7Z7ODVkzK3pEzP48Y1RYciYMEq7GD2k
 XG/Q==
X-Gm-Message-State: AOAM530N0GFwEAaHinYNuw4+iHOlKNqf4baZyk6k1kcD5qoJXiA4QhLg
 PC+0ozxbjNkQIA5E8lfIVxDVmwH9uuJxYMKF3ozv7w==
X-Google-Smtp-Source: ABdhPJxTfEfeqBKHmxyw2CtMbyEAYltfx7GpPViRfckEPW8IinZNEjDVmPt5S7rAbMebL6fc8qUZBmNt0weWMmdOubU=
X-Received: by 2002:a0d:f007:0:b0:2f4:ce96:514b with SMTP id
 z7-20020a0df007000000b002f4ce96514bmr17915775ywe.148.1650905527631; Mon, 25
 Apr 2022 09:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-5-rananta@google.com>
 <CAAeT=Fyc3=uoOdeXrLKfYxKtL3PFV0U_Bwj_g+bca_Em63wGhw@mail.gmail.com>
In-Reply-To: <CAAeT=Fyc3=uoOdeXrLKfYxKtL3PFV0U_Bwj_g+bca_Em63wGhw@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 25 Apr 2022 09:51:56 -0700
Message-ID: <CAJHc60zR4Pa=y-Y4Dp27FoAvqpBrONCN727KbnhSoxNGRiBGuA@mail.gmail.com>
Subject: Re: [PATCH v6 4/9] KVM: arm64: Add vendor hypervisor firmware register
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

Hi Reiji,

On Sun, Apr 24, 2022 at 11:22 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Raghu,
>
> On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Introduce the firmware register to hold the vendor specific
> > hypervisor service calls (owner value 6) as a bitmap. The
> > bitmap represents the features that'll be enabled for the
> > guest, as configured by the user-space. Currently, this
> > includes support for KVM-vendor features along with
> > reading the UID, represented by bit-0, and Precision Time
> > Protocol (PTP), represented by bit-1.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
> >  arch/arm64/kvm/hypercalls.c       | 23 ++++++++++++++++++-----
> >  include/kvm/arm_hypercalls.h      |  2 ++
> >  4 files changed, 26 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 27d4b2a7970e..a025c2ba012a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
> >   *
> >   * @std_bmap: Bitmap of standard secure service calls
> >   * @std_hyp_bmap: Bitmap of standard hypervisor service calls
> > + * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
> >   */
> >  struct kvm_smccc_features {
> >         unsigned long std_bmap;
> >         unsigned long std_hyp_bmap;
> > +       unsigned long vendor_hyp_bmap;
> >  };
> >
> >  struct kvm_arch {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 9eecc7ee8c14..e7d5ae222684 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_STD_HYP_BMAP               KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
> >  #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME                0
> >
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP            KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
> > +#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT   0
> > +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP         1
> > +
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR      0
> >  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index f097bebdad39..76e626d0e699 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -72,9 +72,6 @@ static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> >          */
> >         case ARM_SMCCC_VERSION_FUNC_ID:
> >         case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > -       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> > -       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > -       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >                 return true;
> >         default:
> >                 return kvm_psci_func_id_is_valid(vcpu, func_id);
> > @@ -97,6 +94,13 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> >         case ARM_SMCCC_HV_PV_TIME_ST:
> >                 return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
> >                                         KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> > +       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > +       case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> > +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
> > +                                       KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
> > +       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +               return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
> > +                                       KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
> >         default:
> >                 return kvm_hvc_call_default_allowed(vcpu, func_id);
> >         }
> > @@ -189,8 +193,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >                 val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
> >                 break;
> >         case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > -               val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > -               val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> > +               val[0] = smccc_feat->vendor_hyp_bmap;
> >                 break;
> >         case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >                 kvm_ptp_get_time(vcpu, val);
> > @@ -217,6 +220,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> >         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> >         KVM_REG_ARM_STD_BMAP,
> >         KVM_REG_ARM_STD_HYP_BMAP,
> > +       KVM_REG_ARM_VENDOR_HYP_BMAP,
> >  };
> >
> >  void kvm_arm_init_hypercalls(struct kvm *kvm)
> > @@ -225,6 +229,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
> >
> >         smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> >         smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> > +       smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> >  }
> >
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > @@ -317,6 +322,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >         case KVM_REG_ARM_STD_HYP_BMAP:
> >                 val = READ_ONCE(smccc_feat->std_hyp_bmap);
> >                 break;
> > +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +               val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
> > +               break;
> >         default:
> >                 return -ENOENT;
> >         }
> > @@ -343,6 +351,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> >                 fw_reg_bmap = &smccc_feat->std_hyp_bmap;
> >                 fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> >                 break;
> > +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +               fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
> > +               fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> > +               break;
> >         default:
> >                 return -ENOENT;
> >         }
> > @@ -445,6 +457,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >                 return 0;
> >         case KVM_REG_ARM_STD_BMAP:
> >         case KVM_REG_ARM_STD_HYP_BMAP:
> > +       case KVM_REG_ARM_VENDOR_HYP_BMAP:
> >                 return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
> >         default:
> >                 return -ENOENT;
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index aadd6ae3ab72..4ebfdd26e486 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -9,9 +9,11 @@
> >  /* Last valid bits of the bitmapped firmware registers */
> >  #define KVM_REG_ARM_STD_BMAP_BIT_MAX           0
> >  #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX       0
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX    1
>
> Nit: IMHO perhaps it might be more convenient to define the MAX macro
> in arch/arm64/include/uapi/asm/kvm.h like below for maintenance ?
> (The same comments are applied to other KVM_REG_ARM_*_BMAP_BIT_MAX)
>
> #define KVM_REG_ARM_VENDOR_HYP_BIT_MAX KVM_REG_ARM_VENDOR_HYP_BIT_PTP
>
We have been going back and forth on this :)
It made sense for me to keep it in uapi as well, but I took Oliver's
suggestion of keeping it outside of uapi since this is something that
could be constantly changing [1].

Thank you.
Raghavendra

[1]: https://lore.kernel.org/lkml/CAJHc60wz5WsZWTn66i41+G4-dsjCFuFkthXU_Vf6QeXHkgzrZg@mail.gmail.com/

> Thanks,
> Reiji
>
>
> >
> >  #define KVM_ARM_SMCCC_STD_FEATURES             GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> >  #define KVM_ARM_SMCCC_STD_HYP_FEATURES         GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> > +#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES      GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
> >
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> >
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
