Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F00ECAAA1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Aug 2022 03:29:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 552BE4B872;
	Tue, 30 Aug 2022 23:29:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SIkWwjf-hOWN; Tue, 30 Aug 2022 23:29:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 383C24B860;
	Tue, 30 Aug 2022 23:29:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAA1C4B843
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 23:29:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YzOwat6egW8Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 23:29:53 -0400 (EDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com
 [209.85.217.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CF574B825
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 23:29:53 -0400 (EDT)
Received: by mail-vs1-f41.google.com with SMTP id c3so13391285vsc.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 20:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=wH6SkmsubtAEMe+Oltypmgiq7J+rOERnNBJpjeaMrvA=;
 b=CDo6Z44yrRgjpbGohbYOniKRV+E/B8UYbGeUnUlkzXXIylwcDIZdQ+Sx8VOh+dVnf1
 pbOlZsl12uJKm+tUl3QyfYfGFXY4ANvoVdv4TGWJK5OuwkobzqaGZkZhHQZu9AfeUxkJ
 9YlNnxAYXeGE3Bf0CQ4FrimfXXjQpYMX6dy+WDDMg8e6OKrfgYUyVsQLL+HPgBqMolyM
 rAoByc/zvaP09HZNoVZupaSLSv8OrNdqso5qEaU/H+dKuawAbzJdxSXT60ZV2G5muzA7
 m5WWM62So7XPY82nxGWRmQCsNY0r59hR8vA+juhse5d8TOY05EAN9wmtIsPym3YxDGQ5
 yoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=wH6SkmsubtAEMe+Oltypmgiq7J+rOERnNBJpjeaMrvA=;
 b=51u/rLtsVDo+y2Ef6i20QrbMEHtEcaQc8+CNG6hnXm7JbKQ6KWaQfwK+CzHjjTObP7
 0zDt/Ea4D2Ojq83xty7egtIIZw8ta00QYJ/3pbcUTSKZxbGl7ALvRFdI7pOps9KM+G1E
 RxaOQdeWuJQzI9NaCqLW3ivNW8wJj6MPuTpCNZsN8L5vBwnxHZpMLd4FzzAlscPjAz+H
 lELEk+fV4kks/51HljvBXR3t7cBJuEGJeVkejqo80yX+ZTRaA42fE0i8pJmESE7936yC
 KGS/ytIccSKobDtxvPitGDopUE1P+U2c7VLDg0dywBtST0vzcBDQ++/0JUhKumCZCScb
 fp5w==
X-Gm-Message-State: ACgBeo2w2m2yq2o5LtTOBfKXDN5igrdXSSf8q6A9EGV/bqhP2YE9A/Ur
 XlWA64nyRBy+WHQYTkTQNDKEKQZzsjGOYJWnlqGIew==
X-Google-Smtp-Source: AA6agR4wfp0eqT1lfWS6iZGkY2lniXyKPHAVAyC2erCUgxtEjOhhAVDZK0dA8SqsKzKRoy5IARzHVLIjMCIz3tgUzA8=
X-Received: by 2002:a05:6102:1349:b0:390:e185:9541 with SMTP id
 j9-20020a056102134900b00390e1859541mr4396415vsl.58.1661916592982; Tue, 30 Aug
 2022 20:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-5-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-5-oliver.upton@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 30 Aug 2022 20:29:37 -0700
Message-ID: <CAAeT=FzQkgf7g3yXP++u_2zio1XL9mRSzPZ6hxmanwVk4QUNbQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: arm64: Add a visibility bit to ignore user writes
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> We're about to ignore writes to AArch32 ID registers on AArch64-only
> systems. Add a bit to indicate a register is handled as write ignore
> when accessed from userspace.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 3 +++
>  arch/arm64/kvm/sys_regs.h | 7 +++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 26210f3a0b27..9f06c85f26b8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1232,6 +1232,9 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> +       if (sysreg_user_write_ignore(vcpu, rd))
> +               return 0;

Since the visibility flags are not ID register specific,
have you considered checking REG_USER_WI from kvm_sys_reg_set_user()
rather than the ID register specific function ?

This patch made me reconsider my comment for the patch-2.
Perhaps it might be more appropriate to check RAZ visibility from
kvm_sys_reg_get_user() rather than the ID register specific function ?

REG_HIDDEN is already checked from kvm_sys_reg_{s,g}et_user() (indirectly).

Thank you,
Reiji

> +
>         /* This is what we mean by invariant: you can't change it. */
>         if (val != read_id_reg(vcpu, rd, raz))
>                 return -EINVAL;
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index e78b51059622..e4ebb3a379fd 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -86,6 +86,7 @@ struct sys_reg_desc {
>
>  #define REG_HIDDEN             (1 << 0) /* hidden from userspace and guest */
>  #define REG_RAZ                        (1 << 1) /* RAZ from userspace and guest */
> +#define REG_USER_WI            (1 << 2) /* WI from userspace only */
>
>  static __printf(2, 3)
>  inline void print_sys_reg_msg(const struct sys_reg_params *p,
> @@ -157,6 +158,12 @@ static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
>         return sysreg_visibility(vcpu, r) & REG_RAZ;
>  }
>
> +static inline bool sysreg_user_write_ignore(const struct kvm_vcpu *vcpu,
> +                                           const struct sys_reg_desc *r)
> +{
> +       return sysreg_visibility(vcpu, r) & REG_USER_WI;
> +}
> +
>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>                               const struct sys_reg_desc *i2)
>  {
> --
> 2.37.1.595.g718a3a8f04-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
