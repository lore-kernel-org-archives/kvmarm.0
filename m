Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79A5C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 17:00:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1194E4A534;
	Wed, 13 Apr 2022 13:00:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e2RWrNsrQmFN; Wed, 13 Apr 2022 13:00:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4674B08B;
	Wed, 13 Apr 2022 13:00:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F29F4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:00:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vlclEc4xK+WJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 13:00:08 -0400 (EDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com
 [209.85.219.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA8FB4A534
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:00:03 -0400 (EDT)
Received: by mail-yb1-f180.google.com with SMTP id q19so4869384ybd.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 10:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vdRCtLVU3X50TcY4iHoNuIOiBwEMt5lRvBw/+Xs0VMI=;
 b=kMIRN9mKDRbEoRyviFgwtpOops0VDAjJeUx0WiSH7lJhB7EUXzY4IBafJb8uqaOrAj
 TDCeCFPERjhGrpRRePDLPJFeXo5tDLxMn58gO/0rSrEOivHfnga0DiOdka35DzZeQeH7
 uugzy4Q9W8gNFfp69CNM6vHDIDScnvlkNhd8UQ5fpM4FF4nP9XRDUi4X/RXhZ9nusEzm
 aQoCo8jn2+oeMRMGIoJsKNncV5dckuGqjnkMp7B21H5M8mbuQAttzb1RNQYk+bwk3XGX
 JCCURUVU9w4w87xp+a79EAAao9ZUqIV4N0w3jjiWeyatx6W0/Xiwtpy8TOV924yPtcGU
 48LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vdRCtLVU3X50TcY4iHoNuIOiBwEMt5lRvBw/+Xs0VMI=;
 b=BRNNpnFISKF9E589oDAScmpWGMpKurvaXOka2D6N6loCFe/gAR/e2hgSXaVLK50Due
 khkIxZ5zPQoouwC3CxjUJmCoJsYrkoB77ArOc180Crjpf+a+2AfXzORouTgRncubTqUz
 gnm6ThXk/pnW8C3jhahpaXyMcC7Rpyp/a09P0hWkI2ebL67tQk9zsUkfQW3+effMZyTQ
 x0UK07AsuNNvbzIJRWlHjehXNZEH0otUO8L7QrCOXGPSFOIwn2ombAzJGiARjaAZfCAi
 X4KGYsC2LhAaVX0GwXJvGHdWcfx2iOZW3Auspvo5KnTcldJVdVp226UiHc5FzDrN+LHR
 +QoA==
X-Gm-Message-State: AOAM531CzqISLKBs7nxuZk1iKcrL/hjjEQYY3j15BL6q2SGGiXfjdNJm
 3hDedVN43FbCgZKOzzQ9uwvwXsCDpmw2IaeokzQQ+w==
X-Google-Smtp-Source: ABdhPJx47gd/eH+Wyb62dt8/Mhfz2r15xib9D7iK8r4Z30EwZZOXiiQAhDIgE+xOidNC4PiLP2UJPFrs3xCXHnztXQo=
X-Received: by 2002:a25:4d84:0:b0:633:be7f:91d4 with SMTP id
 a126-20020a254d84000000b00633be7f91d4mr31226442ybb.627.1649869202922; Wed, 13
 Apr 2022 10:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
 <20220407011605.1966778-5-rananta@google.com>
 <06b7539f-c5c0-843d-7617-a35a9f1d0e60@redhat.com>
In-Reply-To: <06b7539f-c5c0-843d-7617-a35a9f1d0e60@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 13 Apr 2022 09:59:51 -0700
Message-ID: <CAJHc60y_rbTd4uX6aZCkt_P46EgM4QKXg5YXGzit3oweSzh8Sg@mail.gmail.com>
Subject: Re: [PATCH v5 04/10] KVM: arm64: Add vendor hypervisor firmware
 register
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Apr 12, 2022 at 8:59 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Raghavendra,
>
> On 4/7/22 9:15 AM, Raghavendra Rao Ananta wrote:
> > Introduce the firmware register to hold the vendor specific
> > hypervisor service calls (owner value 6) as a bitmap. The
> > bitmap represents the features that'll be enabled for the
> > guest, as configured by the user-space. Currently, this
> > includes support for KVM-vendor features, and Precision Time
> > Protocol (PTP), represented by bit-0 and bit-1 respectively.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h |  2 ++
> >   arch/arm64/include/uapi/asm/kvm.h |  4 ++++
> >   arch/arm64/kvm/hypercalls.c       | 21 +++++++++++++++++----
> >   include/kvm/arm_hypercalls.h      |  4 ++++
> >   4 files changed, 27 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 20165242ebd9..b79161bad69a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
> >    *
> >    * @std_bmap: Bitmap of standard secure service calls
> >    * @std_hyp_bmap: Bitmap of standard hypervisor service calls
> > + * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
> >    */
> >   struct kvm_smccc_features {
> >       u64 std_bmap;
> >       u64 std_hyp_bmap;
> > +     u64 vendor_hyp_bmap;
> >   };
> >
> >   struct kvm_arch {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index 67353bf4e69d..9a5ac0ed4113 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
> >   #define KVM_REG_ARM_STD_HYP_BMAP            KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
> >   #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME             BIT(0)
> >
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP          KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
> > +#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT BIT(0)
> > +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP               BIT(1)
> > +
> >   /* Device Control API: ARM VGIC */
> >   #define KVM_DEV_ARM_VGIC_GRP_ADDR   0
> >   #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS      1
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 64ae6c7e7145..80836c341fd3 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -66,8 +66,6 @@ static const u32 hvc_func_default_allowed_list[] = {
> >       ARM_SMCCC_VERSION_FUNC_ID,
> >       ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> >       ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
> > -     ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
> > -     ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
> >   };
> >
> >   static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> > @@ -102,6 +100,12 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> >       case ARM_SMCCC_HV_PV_TIME_ST:
> >               return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_hyp_bmap,
> >                                       KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> > +     case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > +             return kvm_arm_fw_reg_feat_enabled(smccc_feat->vendor_hyp_bmap,
> > +                                     KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
> > +     case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +             return kvm_arm_fw_reg_feat_enabled(smccc_feat->vendor_hyp_bmap,
> > +                                     KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
> >       default:
> >               return kvm_hvc_call_default_allowed(vcpu, func_id);
> >       }
>
> I guess we may return SMCCC_RET_NOT_SUPPORTED for ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID
> if KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT isn't set? Otherwise, we need explain it
> in the commit log.
>
ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID is a part of the hvc
allowed-list (hvc_func_default_allowed_list[]), which means it's not
associated with any feature bit and is always enabled. If the guest
were to issue ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, we'd end up in
the 'default' case and the kvm_hvc_call_default_allowed() would return
'true'. This is documented in patch 2/10.

> KVM_REG_ARM_VENDOR_HYP_BIT_{FUNC_FEAT, PTP} aren't parallel to each other.
> I think PTP can't be on if KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT is off.
>
Actually we went through this scenario [1]. Of course, we can build
some logic around it to make sure that the userspace does the right
thing, but at this point the consensus is that, unless it's an issue
for KVM, it's treated as a userspace bug.

> > @@ -194,8 +198,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >               val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
> >               break;
> >       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > -             val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > -             val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> > +             val[0] = smccc_feat->vendor_hyp_bmap;
> >               break;
> >       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >               kvm_ptp_get_time(vcpu, val);
> > @@ -222,6 +225,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> >       KVM_REG_ARM_STD_BMAP,
> >       KVM_REG_ARM_STD_HYP_BMAP,
> > +     KVM_REG_ARM_VENDOR_HYP_BMAP,
> >   };
> >
> >   void kvm_arm_init_hypercalls(struct kvm *kvm)
> > @@ -230,6 +234,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
> >
> >       smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> >       smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> > +     smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> >   }
> >
> >   int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > @@ -322,6 +327,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >       case KVM_REG_ARM_STD_HYP_BMAP:
> >               val = READ_ONCE(smccc_feat->std_hyp_bmap);
> >               break;
> > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +             val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
> > +             break;
> >       default:
> >               return -ENOENT;
> >       }
> > @@ -348,6 +356,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> >               fw_reg_bmap = &smccc_feat->std_hyp_bmap;
> >               fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
> >               break;
> > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +             fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
> > +             fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
> > +             break;
> >       default:
> >               return -ENOENT;
> >       }
>
> If KVM_REG_ARM_VENDOR_HYP_BIT_{FUNC_FEAT, PTP} aren't parallel to each other,
> special code is needed to gurantee PTP is cleared if VENDOR_HYP is disabled.
>
Please see the above comment :)

> > @@ -453,6 +465,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >               return 0;
> >       case KVM_REG_ARM_STD_BMAP:
> >       case KVM_REG_ARM_STD_HYP_BMAP:
> > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> >               return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
> >       default:
> >               return -ENOENT;
> > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > index b0915d8c5b81..eaf4f6b318a8 100644
> > --- a/include/kvm/arm_hypercalls.h
> > +++ b/include/kvm/arm_hypercalls.h
> > @@ -9,6 +9,7 @@
> >   /* Last valid bits of the bitmapped firmware registers */
> >   #define KVM_REG_ARM_STD_BMAP_BIT_MAX                0
> >   #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX    0
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX  1
> >
> >   #define KVM_ARM_SMCCC_STD_FEATURES \
> >       GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> > @@ -16,6 +17,9 @@
> >   #define KVM_ARM_SMCCC_STD_HYP_FEATURES \
> >       GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> >
> > +#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES \
> > +     GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
> > +
> >   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> >
> >   static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> >
>
> Thanks,
> Gavin
>

Thanks for the review.

Regards,
Raghavendra

[1]: https://lore.kernel.org/lkml/YjA1AzZPlPV20kMj@google.com/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
