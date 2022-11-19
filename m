Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924277C
	for <kvmarm@lists.linux.dev>; Sat, 19 Nov 2022 05:53:13 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so6927574pjl.3
        for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 21:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wz8dYcxR3+yX3z3xmnU9Zu+0PZxNi4yPWJhB9721SRM=;
        b=fUpTDtRxfjg6unyhlyNX9OdDnqKxaHSz88G5lgmqtHNpZpgAscvHJbdGqXZDnqpM9P
         aegcZohdOVti2VieOCToDG20TFNykHNuYhjenxkdyLHL/2PPEdFGHNMP9eEJ9oAH5UOF
         y2Na9pK/LY93pqbyMf57qVXQwmz9kFgYXmWVTwbmDd7YbTxFa0pNtmUbtL3bk+3yB42D
         wATYzmC1cI6yQnEwNioy14jOcYLzuE0qAxp2YRg39ebNgSzUbRALJWt7mpBOM0++z+RD
         royoIERiovEGL861hFzs//PxiAzc4W8TKiVEnINoQn/91VzXXHFS7vrLRQ9fWmJlMQT9
         0IKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wz8dYcxR3+yX3z3xmnU9Zu+0PZxNi4yPWJhB9721SRM=;
        b=USqkJIFAUjfCy14m/FKjmzfZtN/Z1S+akBdlFx/PmaQWtqMePQz4knxK6ysinRxTeu
         pLusEEZK9jQdeBOH7cBadAjr9P/qoX11sEyjjgWjivtkLsgX4DHxQ/D/gFUBEXpN1v7A
         MAw4ArUatofYzMsGDhp5+LsDIIExji7853oI9nN1cVsgVzU6MTjjvI/LTUDt3lCCRrIE
         CMBQOqc49CcexqF5x8Q0ycpn6Hq1brr/Jxn3zKToj4LO5UsLdwbxrGWyad1J+OeKilin
         nMe8tUzLEdB5/pjDwJm4cJfmFAr2ZSx5QIvRax91g5uEVtfRSTwS1tkbBlcE0QtQC2eF
         FmZQ==
X-Gm-Message-State: ANoB5plHnb6U++5pZ7l1wqQd0/73gCPiJ8su9oMl/KVVvRqfPBvtrPbR
	1X60tKuq4e8hOF78uQspNmT6WQVRLdvzFQxXb/PHig==
X-Google-Smtp-Source: AA0mqf4kXBS5cv71+AQu54rPe1r6va354rE1Kqu4awgYk/aGAewIyvsWXPmKv1Nwztx5XCKtF6ysqdChVX62y5oIrQk=
X-Received: by 2002:a17:902:cacb:b0:188:5e78:be0 with SMTP id
 y11-20020a170902cacb00b001885e780be0mr2780600pld.18.1668837192845; Fri, 18
 Nov 2022 21:53:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-13-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-13-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 18 Nov 2022 21:52:56 -0800
Message-ID: <CAAeT=Fwq8wcBvoWE+5RJt4og4uD5KgQ0kzhDZorGPjHmTguwzw@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be
 set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221119055256.BhXjORxSmy67Na6jKsAR1J8jk9TmVs8GQwcqrpFnVfo@z>

Hi Marc,

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_DFR0_EL1, on the condition that only
> the PerfMon field can be altered and be something that is compatible
> with what was computed for the AArch64 view of the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 57 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3cbcda665d23..dc201a0557c0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1070,6 +1070,19 @@ static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>         return vcpu->kvm->arch.dfr0_pmuver.unimp;
>  }
>
> +static u8 perfmon_to_pmuver(u8 perfmon)
> +{
> +       switch (perfmon) {
> +       case ID_DFR0_PERFMON_8_0:
> +               return ID_AA64DFR0_EL1_PMUVer_IMP;
> +       case ID_DFR0_PERFMON_IMP_DEF:
> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;

Nit: Since IMP_DEF is 0xf for both PMUVER and PERFMON,
I think the 'default' can handle IMP_DEF (I have the same
comment for pmuver_to_perfmon in the patch-10).

> +       default:
> +               /* Anything ARMv8.1+ has the same value. For now. */

Nit: Shouldn't the comment also mention NI (and IMP_DEF) ?
(I have the same comment for pmuver_to_perfmon in the patch-10)

Otherwise:
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji

> +               return perfmon;
> +       }
> +}
> +
>  static u8 pmuver_to_perfmon(u8 pmuver)
>  {
>         switch (pmuver) {
> @@ -1281,6 +1294,46 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +                          const struct sys_reg_desc *rd,
> +                          u64 val)
> +{
> +       u8 perfmon, host_perfmon;
> +       bool valid_pmu;
> +
> +       host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
> +
> +       /*
> +        * Allow DFR0_EL1.PerfMon to be set from userspace as long as
> +        * it doesn't promise more than what the HW gives us on the
> +        * AArch64 side (as everything is emulated with that), and
> +        * that this is a PMUv3.
> +        */
> +       perfmon = FIELD_GET(ARM64_FEATURE_MASK(ID_DFR0_PERFMON), val);
> +       if ((perfmon != ID_DFR0_PERFMON_IMP_DEF && perfmon > host_perfmon) ||
> +           (perfmon != 0 && perfmon < ID_DFR0_PERFMON_8_0))
> +               return -EINVAL;
> +
> +       valid_pmu = (perfmon != 0 && perfmon != ID_DFR0_PERFMON_IMP_DEF);
> +
> +       /* Make sure view register and PMU support do match */
> +       if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
> +               return -EINVAL;
> +
> +       /* We can only differ with PerfMon, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd);
> +       val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
> +       if (val)
> +               return -EINVAL;
> +
> +       if (valid_pmu)
> +               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> +       else
> +               vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> +
> +       return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1502,7 +1555,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         /* CRm=1 */
>         AA32_ID_SANITISED(ID_PFR0_EL1),
>         AA32_ID_SANITISED(ID_PFR1_EL1),
> -       AA32_ID_SANITISED(ID_DFR0_EL1),
> +       { SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
> +         .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
> +         .visibility = aa32_id_visibility, },
>         ID_HIDDEN(ID_AFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR0_EL1),
>         AA32_ID_SANITISED(ID_MMFR1_EL1),
> --
> 2.34.1
>
