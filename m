Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA1DECAAD2
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 07:01:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7876A4E514;
	Fri, 26 Aug 2022 03:01:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4NvCw+T4ctH6; Fri, 26 Aug 2022 03:01:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 499D44E4D6;
	Fri, 26 Aug 2022 03:01:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C964E4CA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 03:01:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G83g8wPopMiu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 03:01:41 -0400 (EDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com
 [209.85.222.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 105644E4C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 03:01:40 -0400 (EDT)
Received: by mail-ua1-f46.google.com with SMTP id ay32so254070uab.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 00:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=V4bSpRziuje5o+7gdBCVWtLAAELBDhvrH2H1U3nqZI0=;
 b=OLtuuLmLpl344WRI7J+cur9nAxPQ7ZaKG8zx2VP90fd8A0epTRXOx1f8ZLfz6ZgSMy
 +MUz3i/eKpzHMzA85hg9LnbFbm5CakGmVhtDcaiHKZVempawzMZGNM1yCbG8fHI4I7GN
 j03sd3fbZZfaYKeluJUeWa806SbFcVxSpetBj7DSCaUl2o1Wbuv7Vw9B7xntDFkMDdqC
 h5awviYj0x2uz14vESodvepbYF/G9WeIm1FK9qqT090IN323DlWVR4K034MiHlkgTeiO
 mIvEDSkW+S7hVvr/EbCKJyPd008/gIAEzx8Pr/pANmT1ek7V5vPqYYbUgt4xNRS6aPJ/
 8iXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=V4bSpRziuje5o+7gdBCVWtLAAELBDhvrH2H1U3nqZI0=;
 b=PkE99sntwLvtZ8JuWKT9bTQqkCJe+6oWN1O+l/VhOU50jlG/Hz863u3qOT0kYZv16q
 4uFR2oowMioDrUqz4AudXItuPIhPl+HGsD/KEYNii5Vj8UOG8+27rlC8Dbz2fEYijPVt
 ltFHfhbn0OoTY/+g6mXx2uKsqCnnFw03I8GhReqxzxeNdGLh6dtwYcxYQYJ53XbWbXJp
 38K/Nrl+01w+AgTflPtBEKK6eZTR0dFbSdlKSjEUwq2JTNNtqQ+VCiVMKAt7fh3TbQNT
 vzBL6B2epoMKFqq1M2d3buKDiHt0KKC9C2Pt2zoaZn/RAXnfx1IieQyfJj5Ys2scKC1U
 LotA==
X-Gm-Message-State: ACgBeo1Y2D4pOmYa7itwkf/JahOQfa5xHzhnLVEQImpEVo2qMWV6Znhk
 UgFs2jPdCWml1fBalEP5uzoEtP/ffijbNvExhY5S+oMygHpsow==
X-Google-Smtp-Source: AA6agR4BwjdlteSPdMbRx7NYLnCpMTRac4VWfKVgj3SObmnB5WEsoRlGSLWKRdvYNYXmXw42ZxTEbU4vIn1707ikLW8=
X-Received: by 2002:ab0:154a:0:b0:39e:fee3:a65d with SMTP id
 p10-20020ab0154a000000b0039efee3a65dmr2738648uae.51.1661497300388; Fri, 26
 Aug 2022 00:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-8-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-8-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 26 Aug 2022 00:01:24 -0700
Message-ID: <CAAeT=Fye1b3CbBxhzpD6V4L1qLwszWKARRDFtRom6QVTjb_OXA@mail.gmail.com>
Subject: Re: [PATCH 7/9] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be
 set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

Hi Marc,

On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 55451f49017c..c0595f31dab8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1236,6 +1236,38 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +                              const struct sys_reg_desc *rd,
> +                              u64 val)

The function prototype doesn't appear to be right as the
set_user of sys_reg_desc().
---
[From sys_regs.h]
[sys_regs.h]
        int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
                        const struct kvm_one_reg *reg, void __user *uaddr);
---

> +{
> +       u8 pmuver, host_pmuver;
> +
> +       host_pmuver = kvm_arm_pmu_get_host_pmuver();
> +
> +       /*
> +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> +        * as it doesn't promise more than what the HW gives us. We
> +        * don't allow an IMPDEF PMU though.
> +        */
> +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), val);
> +       if (pmuver == ID_AA64DFR0_PMUVER_IMP_DEF || pmuver > host_pmuver)
> +               return -EINVAL;

As mentioned in my comments for the patch-6, the vCPU's PMUVER could
currently be IMP_DEF.  So, with this IMP_DEF checking, a guest with
IMP_DEF PMU cannot be migrated to a newer KVM host.
Do we need to tolerate writes of IMP_DEF for compatibility ?

Oliver originally point this out for my ID register series, and
my V6 or newer series tried to not return an error for this by
ignoring the user requested IMP_DEF when PMU is not enabled for
the vCPU (Instead, the field is set to 0x0).

 https://lore.kernel.org/all/20220419065544.3616948-16-reijiw@google.com/

Thank you,
Reiji

> +
> +       /* We already have a PMU, don't try to disable it... */
> +       if (kvm_vcpu_has_pmu(vcpu) && pmuver == 0)
> +               return -EINVAL;
> +
> +       /* We can only differ with PMUver, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd, false);
> +       val &= ~(0xFUL << ID_AA64DFR0_PMUVER_SHIFT);
> +       if (val)
> +               return -EINVAL;
> +
> +       vcpu->kvm->arch.dfr0_pmuver = pmuver;
> +
> +       return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1510,7 +1542,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         ID_UNALLOCATED(4,7),
>
>         /* CRm=5 */
> -       ID_SANITISED(ID_AA64DFR0_EL1),
> +       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
> +         .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5,2),
>         ID_UNALLOCATED(5,3),
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
