Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAFE7481
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 14:53:14 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so2019666pjl.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Nov 2022 07:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+EOoy7YAYLFDl3hhNdNz/Dei5v7yTMufGMRoDAJQwns=;
        b=DtlCiaFP2I1bckyWh5G0FM0i+CkRoJ8mvsBb/FLYQ5vsiNn+K5Kfn7De9s3JQXuFWh
         H7mPuPNypG5Va/KzQj7+sGaovbWc+tl9ROBGVKX1lFNt3evPO2v0Ei2ctaqdE05U/zux
         ZiXZpPEwzB4r3+qncQCDYv4T/92auL3oUUc02wrbgRMQherqPxfkT4821kjSGSum4WAF
         cGlsnWBV0J+2ixoR0C1djo6X1hgD0NHBSynA4HTves7BwMiQrC8xwko7rm9oM4O2V6Uy
         qFUKvrrxD2R6qqNFAeG1x4eHJdcQUJhvaSkqajPP+WL+NtH6rCIZ4qohw7R1BfLL7kTB
         g1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+EOoy7YAYLFDl3hhNdNz/Dei5v7yTMufGMRoDAJQwns=;
        b=eoXDKblPcOy/BpFokymjfnwxyDej5AiB3waEBT4huQAxiKoKzWXZlvML0SdGWq1yZH
         SKX32cJw6IVWILEsg5SuYisTvpxdhfNWUHb1/NPRxtory7HcD5Xs8oCHOp7WFZjOJG5v
         AtbT6oqfPn+DTFuMo+AzLeuQSL6NUS69R0zk/lHBihLeyZY8k1QQp7vH0nMjQjsdL8yO
         SPdabMYTrrqXpOHaAe2h9DCmEwb43LB8s33iCIMh7gkancp9RJOsKphZuk5S6Gep3Ad9
         EpDTJMQ+jHp/YqMDmnf4GuMwB2+tIsPmLCcRiirD67a+/dk1j1gcjXWAMeupAA6m5SUD
         LAnA==
X-Gm-Message-State: ACrzQf33AStTNLzDT2QOrTThpyrvjSCiqpUo02jiRrakGkXCO3QeA1nu
	Zzh/oUTbxNSnB8BER5RSNYii50GlL4WQLMUqK7upxQ==
X-Google-Smtp-Source: AMsMyM4WzkVgP+HlYu/hXxndYVEW+ikrBgoVSC2s61IT60dLmVa4lu36WrgsBoYQ7rj4vYLHvfKQny4wvHwqFcAzXQE=
X-Received: by 2002:a17:903:22c1:b0:187:2ced:455f with SMTP id
 y1-20020a17090322c100b001872ced455fmr17805199plg.18.1667487193938; Thu, 03
 Nov 2022 07:53:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-11-maz@kernel.org>
 <CAAeT=FycObU5eHaR23OZ_PeR6-cQeNrmGs=Mi-VnrVuWR6ovSg@mail.gmail.com> <87v8nwfmwb.wl-maz@kernel.org>
In-Reply-To: <87v8nwfmwb.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 3 Nov 2022 07:52:57 -0700
Message-ID: <CAAeT=Fz9pKey3=bc=Nzn=c8HZ=PhGmv4tTGkwmi2yiEHG9eM3Q@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221103145257.ukcEy-ANy9MSYP3GTcE4cWRwwJi-58odQgi_bVu6Bbo@z>

Hi Marc,

On Thu, Nov 3, 2022 at 1:44 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Reiji,
>
> On Thu, 03 Nov 2022 04:55:52 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Fri, Oct 28, 2022 at 4:16 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > >         case SYS_ID_DFR0_EL1:
> > > -               /* Limit guests to PMUv3 for ARMv8.4 */
> > > -               val = cpuid_feature_cap_perfmon_field(val,
> > > -                                                     ID_DFR0_PERFMON_SHIFT,
> > > -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> > > +               val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
> > > +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_PERFMON),
> > > +                                 pmuver_to_perfmon(vcpu_pmuver(vcpu)));
> >
> > Shouldn't KVM expose the sanitized value as it is when AArch32 is
> > not supported at EL0 ? Since the register value is UNKNOWN when AArch32
> > is not supported at EL0, I would think this code might change the PERFMON
> > field value on such systems (could cause live migration to fail).
>
> I'm not sure this would cause anything to fail as we now treat all
> AArch32 idregs as RAZ/WI when AArch32 isn't supported (and the
> visibility callback still applies here).

Oops, sorry I totally forgot about that change...

> But it doesn't hurt to make pmuver_to_perfmon() return 0 when AArch32
> isn't supported, and it will at least make the ID register consistent
> from a guest perspective.

I believe the register will be consistent (0) even from a guest
perspective with the current patch when AArch32 isn't supported
because read_id_reg() checks that with sysreg_visible_as_raz()
in the beginning.

I withdraw my comment, and the patch looks good to me.

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji

>
> I plan to squash the following (untested) hack in:
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 8f4412cd4bf6..3b28ef48a525 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1094,6 +1094,10 @@ static u8 perfmon_to_pmuver(u8 perfmon)
>
>  static u8 pmuver_to_perfmon(u8 pmuver)
>  {
> +       /* If no AArch32, make the field RAZ */
> +       if (!kvm_supports_32bit_el0())
> +               return 0;
> +
>         switch (pmuver) {
>         case ID_AA64DFR0_EL1_PMUVer_IMP:
>                 return ID_DFR0_PERFMON_8_0;
> @@ -1302,10 +1306,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>                            const struct sys_reg_desc *rd,
>                            u64 val)
>  {
> -       u8 perfmon, host_perfmon = 0;
> +       u8 perfmon, host_perfmon;
>
> -       if (system_supports_32bit_el0())
> -               host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
> +       host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
>
>         /*
>          * Allow DFR0_EL1.PerfMon to be set from userspace as long as
>
> > I should have noticed this with the previous version...
>
> No worries, thanks a lot for having had a look!
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
