Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1152CC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 04:43:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 751F34B17C;
	Mon, 29 Nov 2021 23:43:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cbJAxz7sYE8H; Mon, 29 Nov 2021 23:43:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3528B4B1A2;
	Mon, 29 Nov 2021 23:43:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDABB4B17C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 23:43:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pdy+p-Gc1WdU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 23:43:36 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 733294B12C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 23:43:36 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 w33-20020a17090a6ba400b001a722a06212so13100052pjj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 20:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zVblajlwsHTFwr4/kmDawXP04JjCwpPiETvJq93ANRE=;
 b=mxS0CoKkNYbCUIKraOXljOmaG7huH77u0Yf93iFye0G8s2BQOkXQJjsvlpIBwx+VC/
 /4+B+Y1Y20D7dzHehIpbZbMm3hQDeRbUdOz+ITiEVZnOxx/zZBGzECeUa968tvqakzUK
 z6B3LeM7EMpsDc+xyFD/ytuR7E0ldHOqxfbOfzHqKoKC3nC2yiA/PVt3kD5JhiGH+i1r
 jNHJ49KKNQNSBJPLfgw8NFr4ZgK13tM7kR6rojwj0iE42/7GnWMdaxgs5H2Xc6ZxibER
 IqhNRoiIuOcP05DilrAsHb+WfgMOtCCF0an1a4pZir6/Z5l4zddxpcJqp1yFxtkeix3C
 1HHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zVblajlwsHTFwr4/kmDawXP04JjCwpPiETvJq93ANRE=;
 b=OJspwHYHneZ0xuxm5r9kQMauAdBjFvJiCBgm1XTpxgLGHC+N/NeCAbD3UjzCCMsIoy
 dTS89bbiZIfq9herz7EyV3mKG1dd8qlYpDWjxTTagfzwpNbWTmpXwTd4WwmGxUME0+Yc
 jFQQrfWoeE7GXtmj+7WQ5nZ5iBjK64Eq83XdjYmMzVm6qhc+zydjfuxRRu5d8y2UJxJH
 Aju6zzvrdK/qF9oGHDz5Q5rxuOz8sV8FWJew8mKViQR9iY3Dn2zhvg3hSp4vu02JPNtp
 nS5YnxopztJcpgj0P6WdlYHUaKn8UTT34okflJAiEi+vGQGdYNymKv/uaoTqetoMB9lQ
 HJMQ==
X-Gm-Message-State: AOAM5312ICWSSqyCxOm7zm9Bepz5oWa2S15YzzWv3vW6cZPjaBcvWBw6
 H439LAaH/kOC6cHfwINzcPlIU6gTul7foHP/AngKQcqs0soJvw==
X-Google-Smtp-Source: ABdhPJxQiRMp8T07oCScdVPABAnNPKrf/UKVGBMONgbGQ9HtigEAW2hokgfC8BeTFqbVkrdkNzUWgUBsSYofuF0ghRo=
X-Received: by 2002:a17:90b:4acd:: with SMTP id
 mh13mr3204157pjb.230.1638247415297; 
 Mon, 29 Nov 2021 20:43:35 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-9-reijiw@google.com>
 <cef4fecc-b2c0-6f1b-b61d-68b830ae0bcd@redhat.com>
In-Reply-To: <cef4fecc-b2c0-6f1b-b61d-68b830ae0bcd@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 29 Nov 2021 20:43:18 -0800
Message-ID: <CAAeT=FxhJWanZOep9UO66WM2T5tpxyq+5cDmAJUzr+x8q6L7aw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 08/29] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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

On Thu, Nov 25, 2021 at 7:31 AM Eric Auger <eauger@redhat.com> wrote:
>
>
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_AA64MMFR0_EL1 to make it
> > writable by userspace.
> >
> > Since ID_AA64MMFR0_EL1 stage 2 granule size fields don't follow the
> > standard ID scheme, we need a special handling to validate those fields.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 118 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 118 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 5812e39602fe..772e3d3067b2 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -519,6 +519,113 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +/*
> > + * Check if the requested stage2 translation granule size indicated in
> > + * @mmfr0 is also indicated in @mmfr0_lim.  This function assumes that
> > + * the stage1 granule size indicated in @mmfr0 has been validated already.
> I would suggest: relies on the fact TGranX fields are validated before
> through the arm64_check_features lookup

Thank you for the suggestion.  I will fix the comment as you suggested.

> > + */
> > +static int aa64mmfr0_tgran2_check(int field, u64 mmfr0, u64 mmfr0_lim)
> > +{
> > +     s64 tgran2, lim_tgran2, rtgran1;
> > +     int f1;
> > +     bool is_signed = true;
> > +
> > +     tgran2 = cpuid_feature_extract_unsigned_field(mmfr0, field);
> > +     lim_tgran2 = cpuid_feature_extract_unsigned_field(mmfr0_lim, field);
> > +     if (tgran2 == lim_tgran2)
> > +             return 0;
> > +
> > +     if (tgran2 && lim_tgran2)
> > +             return (tgran2 > lim_tgran2) ? -E2BIG : 0;
> > +
> > +     /*
> > +      * Either tgran2 or lim_tgran2 is zero.
> > +      * Need stage1 granule size to validate tgran2.
> > +      */
> > +     switch (field) {
> > +     case ID_AA64MMFR0_TGRAN4_2_SHIFT:
> > +             f1 = ID_AA64MMFR0_TGRAN4_SHIFT;
> > +             break;
> > +     case ID_AA64MMFR0_TGRAN64_2_SHIFT:
> > +             f1 = ID_AA64MMFR0_TGRAN64_SHIFT;
> > +             break;
> > +     case ID_AA64MMFR0_TGRAN16_2_SHIFT:
> > +             f1 = ID_AA64MMFR0_TGRAN16_SHIFT;
> > +             is_signed = false;
> I don't get the is_signed setting. Don't the TGRAN_x have the same
> format? Beside you can get the shift by substracting 12 to @field.

Yes, TGran16 is different from TGran64/TGran4.
 https://developer.arm.com/documentation/ddi0595/2021-09/AArch64-Registers/ID-AA64MMFR0-EL1--AArch64-Memory-Model-Feature-Register-0?lang=en

I didn't realize that we could get the shift by substracting 12 from
@field.  Thank you for the information.  I will use that.


> can't you directly compute if the granule is supported

No, I don't think we can because the value 0 in the TGranx_2 means
that its feature support is identified by another field (TGranx).


> > +             break;
> > +     default:
> > +             /* Should never happen */
> > +             WARN_ONCE(1, "Unexpected stage2 granule field (%d)\n", field);
> > +             return 0;
> > +     }
> > +
> > +     /*
> > +      * If tgran2 == 0 (&& lim_tgran2 != 0), the requested stage2 granule
> > +      * size is indicated in the stage1 granule size field of @mmfr0.
> > +      * So, validate the stage1 granule size against the stage2 limit
> > +      * granule size.
> > +      * If lim_tgran2 == 0 (&& tgran2 != 0), the stage2 limit granule size
> > +      * is indicated in the stage1 granule size field of @mmfr0_lim.
> > +      * So, validate the requested stage2 granule size against the stage1
> > +      * limit granule size.
> > +      */
> > +
> > +      /* Get the relevant stage1 granule size to validate tgran2 */
> > +     if (tgran2 == 0)
> > +             /* The requested stage1 granule size */
> > +             rtgran1 = cpuid_feature_extract_field(mmfr0, f1, is_signed);
> > +     else /* lim_tgran2 == 0 */
> > +             /* The stage1 limit granule size */
> > +             rtgran1 = cpuid_feature_extract_field(mmfr0_lim, f1, is_signed);
> > +
> > +     /*
> > +      * Adjust the value of rtgran1 to compare with stage2 granule size,
> > +      * which indicates: 1: Not supported, 2: Supported, etc.
> > +      */
> > +     if (is_signed)
> > +             /* For signed, -1: Not supported, 0: Supported, etc. */
> > +             rtgran1 += 0x2;
> > +     else
> > +             /* For unsigned, 0: Not supported, 1: Supported, etc. */
> > +             rtgran1 += 0x1;
> > +
> > +     if ((tgran2 == 0) && (rtgran1 > lim_tgran2))
> > +             /*
> > +              * The requested stage1 granule size (== the requested stage2
> > +              * granule size) is larger than the stage2 limit granule size.
> > +              */
> > +             return -E2BIG;
> > +     else if ((lim_tgran2 == 0) && (tgran2 > rtgran1))
> > +             /*
> > +              * The requested stage2 granule size is larger than the stage1
> > +              * limit granulze size (== the stage2 limit granule size).
> > +              */
> > +             return -E2BIG;
> > +
> > +     return 0;
> > +}
> > +
> > +static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
> > +                                  const struct id_reg_info *id_reg, u64 val)
> > +{
> > +     u64 limit = id_reg->vcpu_limit_val;
> > +     int ret;
>
> shouldn't you forbid reserved values for TGran4, 64?

I think what you meant is applied to all signed feature fields on
any ID registers.  Considering "Principles of the ID scheme for fields
in ID registers" that is described in Arm ARM, lower value than -1
should not indicate more or higher level of features than KVM on the
host can support.  In that sense, it doesn't matter (I would think
it won't cause any problems for guests).  So, I rather chose not to do
that check.


> > +
> > +     ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN4_2_SHIFT, val, limit);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN64_2_SHIFT, val, limit);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN16_2_SHIFT, val, limit);
> > +     if (ret)
> > +             return ret;
> > +
> > +     return 0;
> > +}
> > +
> >  static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
> >  {
> >       u64 limit = id_reg->vcpu_limit_val;
> > @@ -625,6 +732,16 @@ static struct id_reg_info id_aa64isar1_el1_info = {
> >       .get_reset_val = get_reset_id_aa64isar1_el1,
> >  };
> >
> > +static struct id_reg_info id_aa64mmfr0_el1_info = {
> > +     .sys_reg = SYS_ID_AA64MMFR0_EL1,
> > +     .ftr_check_types = S_FCT(ID_AA64MMFR0_TGRAN4_SHIFT, FCT_LOWER_SAFE) |
> > +                        S_FCT(ID_AA64MMFR0_TGRAN64_SHIFT, FCT_LOWER_SAFE) |
> the default?

They are signed fields, which are not a default.

> > +                        U_FCT(ID_AA64MMFR0_TGRAN4_2_SHIFT, FCT_IGNORE) |
> > +                        U_FCT(ID_AA64MMFR0_TGRAN64_2_SHIFT, FCT_IGNORE) |
> > +                        U_FCT(ID_AA64MMFR0_TGRAN16_2_SHIFT, FCT_IGNORE),
> maybe add comment telling the actual check is handled in the validate cb

That's a good point.
I will add a brief explanation about the validate cb.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
