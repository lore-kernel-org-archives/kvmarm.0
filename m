Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EB8C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 06:06:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D4B14B16F;
	Thu, 25 Nov 2021 01:06:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S9uxJB4pTgkK; Thu, 25 Nov 2021 01:06:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E604B172;
	Thu, 25 Nov 2021 01:06:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AD034B15C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 01:06:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n3IbT72oUihx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Nov 2021 01:06:05 -0500 (EST)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D8824B153
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 01:06:05 -0500 (EST)
Received: by mail-pg1-f172.google.com with SMTP id f65so4322009pgc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 22:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JZfbf3v7xyL5P436YVGHzTbsqlum22g5x7lbYI8wCJU=;
 b=p0f4kKQlZwHaWfO6xiAt1QKOnrLhusilkHsKvzYVPcywVv7GGZzJASSt6qBEvE4Vl2
 HQvgSUdpMJMOqXroHZfAvYZtgEwrmfqNdnMkbccZ5UPeb+Ho2tGO6T6+Xf6BjHtWcwXo
 +F1RBVRId5264r1MJCqtHfmKlF4Z4kGETgAFhxK8u9ywfeZyvUcK8+Mko3MjdLGV1GyE
 9xp97eyAmzJ4h5sQ0sm8J9PeTkyhPYPdX2x+3A44Q3QsfZOahCWbthnZ7CQzS8MjT3pS
 JtOkQ4Am9HxyqwUAzUTAg52LIgU383xIVgphVFuyhSwE2doCAUl5/Xs3+L6lQKDze2rw
 saMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JZfbf3v7xyL5P436YVGHzTbsqlum22g5x7lbYI8wCJU=;
 b=PvzeyE1hMmkLIjQVAzXByTfdfSSlfBnNx5PszMbxCgt3btmksvCmWeZekE+FdqQBTx
 rP2Q5A6m6ygCrlPWm6kfnVe9Pp6ALsSH0ikkZUXykZiBG5TA5gH8w2CnHN0r4h4BJAb8
 rr221+541fMywthlHrRTjqJPoTZmExjFqHcfkDlMQUHNzGplsict6pIhyywaRASGsplQ
 NNXthPHsmaC0hhMLCgmMcrnUAHXfF4+sTTWmrMjrRBJ1y/YI5Rj8Qx0UrMXwR+Tp9OYN
 /z/gCmvMRP8gINhF4Ae6c06watefIVPNwZmUhL8oMw2GabKVH/RocECSAcnhI/yGgOsj
 rBHg==
X-Gm-Message-State: AOAM530z6aIPjrOd4rMcH+r8CbjZhxlmluI6jhEN0mOQlDaXUmV/IDVm
 wXp23zPOUnO1DoWoR+3TD/cfs12s+qbO+PxG4LpRvw==
X-Google-Smtp-Source: ABdhPJx7RqFVs4UpEKddskHzJBCJ5GBWEqCGsJInkNgLPMWLSTWC9w9vYCEQ4uzdDZ/fk5vo0BrqoivtKcBGAxH+qR0=
X-Received: by 2002:aa7:9438:0:b0:4a2:c941:9ac4 with SMTP id
 y24-20020aa79438000000b004a2c9419ac4mr12091377pfo.12.1637820364510; Wed, 24
 Nov 2021 22:06:04 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-4-reijiw@google.com>
 <d3fd9d6c-c96c-d7a0-b78d-af36430dbf3f@redhat.com>
 <CAAeT=FyzvGaksi+-WidHObrGYcqs4vR73ChCGpo8AFuin6UbYw@mail.gmail.com>
 <c377f63b-89e8-351f-2c95-c98deb51ecda@redhat.com>
In-Reply-To: <c377f63b-89e8-351f-2c95-c98deb51ecda@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 24 Nov 2021 22:05:48 -0800
Message-ID: <CAAeT=Fzh31UVbX3WEMYZH-K6naDw=ZCK0zizhapaP40z1S7EjQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
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

On Wed, Nov 24, 2021 at 10:22 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/19/21 5:47 AM, Reiji Watanabe wrote:
> > Hi Eric,
> >
> > On Thu, Nov 18, 2021 at 12:36 PM Eric Auger <eauger@redhat.com> wrote:
> >>
> >> Hi Reiji,
> >>
> >> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>> This patch lays the groundwork to make ID registers writable.
> >>>
> >>> Introduce struct id_reg_info for an ID register to manage the
> >>> register specific control of its value for the guest, and provide set
> >>> of functions commonly used for ID registers to make them writable.
> >>>
> >>> The id_reg_info is used to do register specific initialization,
> >>> validation of the ID register and etc.  Not all ID registers must
> >>> have the id_reg_info. ID registers that don't have the id_reg_info
> >>> are handled in a common way that is applied to all ID registers.
> >>>
> >>> At present, changing an ID register from userspace is allowed only
> >>> if the ID register has the id_reg_info, but that will be changed
> >>> by the following patches.
> >>>
> >>> No ID register has the structure yet and the following patches
> >>> will add the id_reg_info for some ID registers.
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> ---
> >>>  arch/arm64/include/asm/sysreg.h |   1 +
> >>>  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
> >>>  2 files changed, 218 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> >>> index 16b3f1a1d468..597609f26331 100644
> >>> --- a/arch/arm64/include/asm/sysreg.h
> >>> +++ b/arch/arm64/include/asm/sysreg.h
> >>> @@ -1197,6 +1197,7 @@
> >>>  #define ICH_VTR_TDS_MASK     (1 << ICH_VTR_TDS_SHIFT)
> >>>
> >>>  #define ARM64_FEATURE_FIELD_BITS     4
> >>> +#define ARM64_FEATURE_FIELD_MASK     ((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
> >>>
> >>>  /* Create a mask for the feature bits of the specified feature. */
> >>>  #define ARM64_FEATURE_MASK(x)        (GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 5608d3410660..1552cd5581b7 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >>>               return read_zero(vcpu, p);
> >>>  }
> >>>
> >>> +/*
> >>> + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> >>> + * ftr_check_types of id_reg_info.
> >>> + */
> >>> +enum feature_check_type {
> >>> +     FCT_LOWER_SAFE = 0,
> >>> +     FCT_HIGHER_SAFE,
> >>> +     FCT_HIGHER_OR_ZERO_SAFE,
> >>> +     FCT_EXACT,
> >>> +     FCT_EXACT_OR_ZERO_SAFE,
> >>> +     FCT_IGNORE,     /* Don't check (any value is fine) */
> >> Maybe you can remove the _SAFE suffix (EXACT does not have it).
> >
> > I am inclined to keep 'SAFE' (otherwise, I am likely to forget
> > if lower is safe or not).
> >
> >> s/EXACT/EQUAL ?
> >
> > I will fix that FCT_EXACT to FCT_EQUAL_SAFE.
> >
> >>> +};
> >>> +
> >>> +static int arm64_check_feature_one(enum feature_check_type type, int val,
> >>> +                                int limit)
> >>> +{
> >>> +     bool is_safe = false;
> >>> +
> >>> +     if (val == limit)
> >>> +             return 0;
> >> even if the type is unexpected?
> >
> > I will remove it.
> then you need to modify the handling of FCT_EXACT*.

Thank you for the comment. Yes, I understand.
That being said, I might probably make "val == limit" safe
unconditionally as I will move those implementations
to arch/arm64/kernel/cpufeature.c and utilize existing things
as much as I can.
(https://lore.kernel.org/linux-arm-kernel/CAAeT=FxwzRF0YZmmoEmq3xRHnhun-BCx_FeEQrOVLgzwseSy4w@mail.gmail.com/)


> >>> +
> >>> +     switch (type) {
> >>> +     case FCT_LOWER_SAFE:
> >>> +             is_safe = (val <= limit);
> >>> +             break;
> >>> +     case FCT_HIGHER_OR_ZERO_SAFE:
> >>> +             if (val == 0) {
> >>> +                     is_safe = true;
> >>> +                     break;
> >>> +             }
> >>> +             fallthrough;
> >>> +     case FCT_HIGHER_SAFE:
> >>> +             is_safe = (val >= limit);
> >>> +             break;
> >>> +     case FCT_EXACT:
> >>> +             break;
> >>> +     case FCT_EXACT_OR_ZERO_SAFE:
> >>> +             is_safe = (val == 0);
> >>> +             break;
> >>> +     case FCT_IGNORE:
> >>> +             is_safe = true;
> >>> +             break;
> >>> +     default:
> >>> +             WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     return is_safe ? 0 : -1;
> >>> +}
> >>> +
> >>> +#define      FCT_TYPE_MASK           0x7
> >>> +#define      FCT_TYPE_SHIFT          1
> >>> +#define      FCT_SIGN_MASK           0x1
> >>> +#define      FCT_SIGN_SHIFT          0
> >>> +#define      FCT_TYPE(val)   ((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
> >>> +#define      FCT_SIGN(val)   ((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
> >>> +
> >>> +#define      MAKE_FCT(shift, type, sign)                             \
> >>> +     ((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |   \
> >>> +            (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
> >>> +
> >>> +/* For signed field */
> >>> +#define      S_FCT(shift, type)      MAKE_FCT(shift, type, 1)
> >>> +/* For unigned field */
> >>> +#define      U_FCT(shift, type)      MAKE_FCT(shift, type, 0)
> >>> +
> >>> +/*
> >>> + * @val and @lim are both a value of the ID register. The function checks
> >>> + * if all features indicated in @val can be supported for guests on the host,
> >>> + * which supports features indicated in @lim. @check_types indicates how> + * features in the ID register needs to be checked.
> >>> + * See comments for id_reg_info's ftr_check_types field for more detail.
> >> What about RES0 fields which may exist? add a comment to reassure about
> >> the fact they are properly handled if there are?
> >
> > Any fields including RES0 should be checked based on check_types.
> > I will explicitly state that in the comment.
> >
> >>> + */
> >>> +static int arm64_check_features(u64 check_types, u64 val, u64 lim)
> >>> +{
> >>> +     int i;
> >>> +
> >>> +     for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
> >>> +             u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
> >>> +             bool is_sign = FCT_SIGN(ftr_check);
> >>> +             enum feature_check_type fctype = FCT_TYPE(ftr_check);
> >>> +             int fval, flim, ret;
> >>> +
> >>> +             fval = cpuid_feature_extract_field(val, i, is_sign);
> >>> +             flim = cpuid_feature_extract_field(lim, i, is_sign);
> >>> +
> >>> +             ret = arm64_check_feature_one(fctype, fval, flim);
> >>> +             if (ret)
> >>> +                     return -E2BIG;
> >>> +     }
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +struct id_reg_info {
> >>> +     u32     sys_reg;        /* Register ID */
> >> use struct kernel-doc comments instead?
> >>> +
> >>> +     /*
> >>> +      * Limit value of the register for a vcpu. The value is the sanitized
> >>> +      * system value with bits cleared for unsupported features for the
> >>> +      * guest.
> >>> +      */
> >>> +     u64     vcpu_limit_val;
> >>> +
> >>> +     /*
> >>> +      * The ftr_check_types is comprised of a set of 4 bits fields.
> >> nit: s/bits field/bit field here and below
> >
> > I will fix them.
> >
> >>> +      * Each 4 bits field is for a feature indicated by the same bits
> >>> +      * field of the ID register and indicates how the feature support
> >>> +      * for guests needs to be checked.
> >>> +      * The bit 0 indicates that the corresponding ID register field
> >>> +      * is signed(1) or unsigned(0).
> >>> +      * The bits [3:1] hold feature_check_type for the field.
> >>> +      * If all zero, all features in the ID register are treated as unsigned
> >>> +      * fields and checked based on Principles of the ID scheme for fields
> >>> +      * in ID registers (FCT_LOWER_SAFE of feature_check_type).
> >> values set by the guest are checked against host ID field values
> >> according to FCT_LOWER_SAFE test? You do not actually explicitly explain
> >> what the check is about although this may be obvious for you?
> >
> > How about this ?
> >
> >         /*
> >          * The ftr_check_types is comprised of a set of 4 bit fields.
> >          * Each 4 bit field is for a feature indicated by the same bit field
> >          * of the ID register and indicates how the field needs to be checked
> >          * (by arm64_check_feature_one) against the host's ID field when
> >          * userspace tries to set the register.
> >          * The bit 0 indicates that the corresponding ID register field is
> >          * signed(1) or unsigned(0). The bits [3:1] hold feature_check_type
> >          * for the field (FCT_LOWER_SAFE == 0, etc).
> >          * e.g. for ID_AA64PFR0_EL1.SVE(bits [35:32]), bits[35:32] of
> >          * ftr_check_types for the register should be 0. It means the SVE
> >          * field is treated as an unsigned field, and userspace can set the
> >          * field to a equal or lower value than the host's ID field value.
> >          */
> yep sounds clearer to me.

Thank you for the review !
(ftr_check_types will be gone due to the same reason above though...)

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
