Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5D0C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Nov 2021 06:40:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6817A4B08F;
	Thu, 25 Nov 2021 01:40:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iiuQnOiEIAq6; Thu, 25 Nov 2021 01:40:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA694B192;
	Thu, 25 Nov 2021 01:40:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5654B190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 01:40:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DiKeqkncKgA1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Nov 2021 01:40:49 -0500 (EST)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 194E64B08F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Nov 2021 01:40:49 -0500 (EST)
Received: by mail-pl1-f173.google.com with SMTP id o14so3797007plg.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 22:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=D1RYje+PCYqZsPfLK7s7y/IRS9cjxQyf0CMrO3/xSrc=;
 b=rNkZyu+N7Yym1NzmAo6q7NA+nCsHL1zSv4j41jHy5uuI0UwcnIW5PWPySWkQ+5rYAL
 mgl/raaaWTAhxcB1PQW+uqdMny/JpKxBzspIPtycIHPjkPADaAMwkJyDfaVihzxEVeVY
 Enp4fmyhCB5rbdEbyktyNMeWPzkJSCYsIsZWr1Bg/4ez0LiA/3nBRnsxO8dGOtBq/4Tb
 Prszvbu/AXfSUk9as4B1t8BxvC/fE8bYkg1WfQLNpXnutzqVS4orTrm7QnqHwJ6WhTrK
 ErWf69Q3Pzn9vBmrzmpEYWJTOHRmEi+jptJ++Fp1K1vuCJC8hNndmPczNM7qcq2qLZKB
 W6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=D1RYje+PCYqZsPfLK7s7y/IRS9cjxQyf0CMrO3/xSrc=;
 b=sAT22j0skp6SNKhQAVU8PQNFwadxlA4ZM7XShIGbsxGDXKrYMiR9osLj9i2a1O77gc
 ru6sGeJFff9O23jBczdZpfZ1sRuv7dF9tw+nE5HaTORcdqIgVLKRf6AYb/c7BVQK1ayG
 lJVZm5hk6f88+zTbfl5p4Ti8+HI44a7V5ktKGymtP+e1WjsCa9EZ75DHLmFQQ55uWrFr
 1+78nO+/lnGMv4iQPdC+AzY/lEgSkLFFVYKCnVoIG2ZKVr9XjB0P0j4EBvd1bkZCxQzv
 lZ2u/jBqZ7AqSuH4E3nfNfVsYwdb/fN691+mzHXMorwQZevOceIdcgeypSjCWhzm/oHR
 sdPg==
X-Gm-Message-State: AOAM5328vAvqjKgc1Rdc1UCix8I2xPV88GRDtJoBeqTGoBMKXJrs572x
 6hUNapIZ3yGzJ3JQbysrW457rTVWZICIzhDrRbJ5aQ==
X-Google-Smtp-Source: ABdhPJxk8EJxvu4OyMIvTaNh/09irmr6NEN1cBHNSk7ZAo6K/TTeMK/De3q/IU39RNOG79YqwrGTJHOy1Bt4SW0l8l0=
X-Received: by 2002:a17:90b:380d:: with SMTP id
 mq13mr4391591pjb.110.1637822447922; 
 Wed, 24 Nov 2021 22:40:47 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-4-reijiw@google.com>
 <57519386-0a30-40a6-b46f-d20595df0b86@redhat.com>
In-Reply-To: <57519386-0a30-40a6-b46f-d20595df0b86@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 24 Nov 2021 22:40:31 -0800
Message-ID: <CAAeT=Fx8Z_W0ePxb+5O4OO4myJOr5SRLAFY38FrJJVtXXTxJQw@mail.gmail.com>
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

On Wed, Nov 24, 2021 at 1:07 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch lays the groundwork to make ID registers writable.
> >
> > Introduce struct id_reg_info for an ID register to manage the
> > register specific control of its value for the guest, and provide set
> > of functions commonly used for ID registers to make them writable.
> >
> > The id_reg_info is used to do register specific initialization,
> > validation of the ID register and etc.  Not all ID registers must
> > have the id_reg_info. ID registers that don't have the id_reg_info
> > are handled in a common way that is applied to all ID registers.
> >
> > At present, changing an ID register from userspace is allowed only
> > if the ID register has the id_reg_info, but that will be changed
> > by the following patches.
> >
> > No ID register has the structure yet and the following patches
> > will add the id_reg_info for some ID registers.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |   1 +
> >  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
> >  2 files changed, 218 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 16b3f1a1d468..597609f26331 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -1197,6 +1197,7 @@
> >  #define ICH_VTR_TDS_MASK     (1 << ICH_VTR_TDS_SHIFT)
> >
> >  #define ARM64_FEATURE_FIELD_BITS     4
> > +#define ARM64_FEATURE_FIELD_MASK     ((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
> >
> >  /* Create a mask for the feature bits of the specified feature. */
> >  #define ARM64_FEATURE_MASK(x)        (GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 5608d3410660..1552cd5581b7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >               return read_zero(vcpu, p);
> >  }
> >
> > +/*
> > + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> > + * ftr_check_types of id_reg_info.
> > + */
> > +enum feature_check_type {
> > +     FCT_LOWER_SAFE = 0,
> > +     FCT_HIGHER_SAFE,
> > +     FCT_HIGHER_OR_ZERO_SAFE,
> > +     FCT_EXACT,
> > +     FCT_EXACT_OR_ZERO_SAFE,
> > +     FCT_IGNORE,     /* Don't check (any value is fine) */
> > +};
> > +
> > +static int arm64_check_feature_one(enum feature_check_type type, int val,
> > +                                int limit)
> > +{
> > +     bool is_safe = false;
> > +
> > +     if (val == limit)
> > +             return 0;
> > +
> > +     switch (type) {
> > +     case FCT_LOWER_SAFE:
> > +             is_safe = (val <= limit);
> > +             break;
> > +     case FCT_HIGHER_OR_ZERO_SAFE:
> > +             if (val == 0) {
> > +                     is_safe = true;
> > +                     break;
> > +             }
> > +             fallthrough;
> > +     case FCT_HIGHER_SAFE:
> > +             is_safe = (val >= limit);
> > +             break;
> > +     case FCT_EXACT:
> > +             break;
> > +     case FCT_EXACT_OR_ZERO_SAFE:
> > +             is_safe = (val == 0);
> > +             break;
> > +     case FCT_IGNORE:
> > +             is_safe = true;
> > +             break;
> > +     default:
> > +             WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
> > +             break;
> > +     }
> > +
> > +     return is_safe ? 0 : -1;
> > +}
> > +
> > +#define      FCT_TYPE_MASK           0x7
> > +#define      FCT_TYPE_SHIFT          1
> > +#define      FCT_SIGN_MASK           0x1
> > +#define      FCT_SIGN_SHIFT          0
> > +#define      FCT_TYPE(val)   ((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
> > +#define      FCT_SIGN(val)   ((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
> > +
> > +#define      MAKE_FCT(shift, type, sign)                             \
> > +     ((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |   \
> > +            (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
> > +
> > +/* For signed field */
> > +#define      S_FCT(shift, type)      MAKE_FCT(shift, type, 1)
> > +/* For unigned field */
> > +#define      U_FCT(shift, type)      MAKE_FCT(shift, type, 0)
> > +
> > +/*
> > + * @val and @lim are both a value of the ID register. The function checks
> > + * if all features indicated in @val can be supported for guests on the host,
> > + * which supports features indicated in @lim. @check_types indicates how
> > + * features in the ID register needs to be checked.
> > + * See comments for id_reg_info's ftr_check_types field for more detail.
> > + */
> > +static int arm64_check_features(u64 check_types, u64 val, u64 lim)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
> > +             u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
> > +             bool is_sign = FCT_SIGN(ftr_check);
> > +             enum feature_check_type fctype = FCT_TYPE(ftr_check);
> > +             int fval, flim, ret;
> > +
> > +             fval = cpuid_feature_extract_field(val, i, is_sign);
> > +             flim = cpuid_feature_extract_field(lim, i, is_sign);
> > +
> > +             ret = arm64_check_feature_one(fctype, fval, flim);
> > +             if (ret)
> > +                     return -E2BIG;
> nit: -EINVAL may be better because depending on the check type this may
> not mean too big.

Yes, that is correct.

This error case means that userspace tried to configure features
or a higher level of features that were not supported on the host.
In that sense, I chose -E2BIG.

I wanted to use an error code specific to this particular case, which
I think makes debugging userspace issue easier when KVM_SET_ONE_REG
fails, and I couldn't find other error codes that fit this case better.
So, I'm trying to avoid using -EINVAL, which is used for other failure
cases.

If you have any other suggested error code for this,
that would be very helpful:)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
