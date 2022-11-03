Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCEE7E2
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 05:32:13 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id b185so672372pfb.9
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 22:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=plrjvAdTS0nKqwkjAzFhlx4V983yw9yOIJecZW8zvnc=;
        b=NcV+yCiuxWOVxIsZo319+y5TyEFngethA6CQP6BOwGlsAkmNTjQraFrrswRtPZlkpD
         SJRUCsZfHhroDFuc1HWmkqwVEVc2RVFlGiP5zvsmzzPynvcbshB4QamTuDtUOEEi6JX4
         BmUNoa7MFmnhIEnLohD39eY/9J7H2XyS5v3+5c2obyaUdJSs75ghA1uFF39Ky7NSG8YJ
         Fs1aAEnOM6YE3UXbpbHYeTtl8vatHs5B63YYsi93lW77Z447BjQnB4MN173r79lfZNfs
         EeCfl2gHHg6Bb2KUGH/aEOT1ThtG05EipcaO2uura2cCTvv3plIIwNol/Hx+i5Ii5y9/
         Z3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=plrjvAdTS0nKqwkjAzFhlx4V983yw9yOIJecZW8zvnc=;
        b=cV1MOAS8oyHr8aYJ4Sa05AG1qG8xuM+9RySa3LpQRCfoQondiZLonIwzQMD9aAudlm
         LE7aSGmjc0jDjhFAtAC5+/xgvTJKw6xo/lF9i1YC8Wl/eucfZODvKYVDQQdeMZKLKfXq
         WH0PTG49LBNezo6Adc7YtnRCsbE6ffPX4BSTM5jGoLl1L0+ojlrSDDlJT8Q2kuaz1TAq
         AjD1sO2652uvNDL/RkuhsLrDcvn/Pg+P9OgFBKljhnab0mPi/pHKdOPUTg9fmH+qkt6I
         DaCCCQYdwkeIK5l6I5BdajzAsGGthWNBNtRCqxkWrX2DK5lagQEj5QNNVVkIA9cesZqN
         gTpw==
X-Gm-Message-State: ACrzQf0B1a0tflLcfgdOOjuC1UTB83OuB8ysSgEU6K9PyU5bYiYtVewD
	gGwW39l14YADlEPPhG3iOFr6qua9OYZn5BFkICPkLA==
X-Google-Smtp-Source: AMsMyM4AzbIHrwu7GJ3+G6SgGpmo5sXra8QVKVVvusdM6c9LC+09ZHIwSIQNdprt/hyAqQXhcjpMftwwP6uibr705Fk=
X-Received: by 2002:a63:db58:0:b0:443:575e:d1ed with SMTP id
 x24-20020a63db58000000b00443575ed1edmr24344874pgi.468.1667453533101; Wed, 02
 Nov 2022 22:32:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-12-maz@kernel.org>
In-Reply-To: <20221028105402.2030192-12-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 2 Nov 2022 22:31:56 -0700
Message-ID: <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221103053156.-IxHPyM338KJ_aATpV7-cyd8xiRwII8lTVbhT2nWEF8@z>

Hi Marc,

On Fri, Oct 28, 2022 at 4:16 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7a4cd644b9c0..4fa14b4ae2a6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1247,6 +1247,40 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +                              const struct sys_reg_desc *rd,
> +                              u64 val)
> +{
> +       u8 pmuver, host_pmuver;
> +
> +       host_pmuver = kvm_arm_pmu_get_pmuver_limit();
> +
> +       /*
> +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> +        * as it doesn't promise more than what the HW gives us. We
> +        * allow an IMPDEF PMU though, only if no PMU is supported
> +        * (KVM backward compatibility handling).
> +        */

It appears the patch allows userspace to set IMPDEF even
when host_pmuver == 0.  Shouldn't it be allowed only when
host_pmuver == IMPDEF (as before)?
Probably, it may not cause any real problems though.


> +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
> +       if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver)
> +               return -EINVAL;
> +
> +       /* We already have a PMU, don't try to disable it... */
> +       if (kvm_vcpu_has_pmu(vcpu) &&
> +           (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF))
> +               return -EINVAL;

Nit: Perhaps it might be useful to return a different error code for the
above two (new) error cases (I plan to use -E2BIG and -EPERM
respectively for those cases with my ID register series).

Thank you,
Reiji

> +
> +       /* We can only differ with PMUver, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd);
> +       val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
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
> @@ -1508,7 +1542,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
>
