Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDDDC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 14:53:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E94834B39B;
	Thu,  3 Nov 2022 10:53:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IluibXDgMaA0; Thu,  3 Nov 2022 10:53:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B754B282;
	Thu,  3 Nov 2022 10:53:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9AB4B27C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 10:53:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 91qqvAC8AT1E for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 10:53:15 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CF724B20F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 10:53:15 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id u6so2134592plq.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 07:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=fUYH+j0pJshe0eBRSGa7UnpKHAvviUtFiXIjH/Zp8Wlp0epXVejTeVAmEgqxPMpRO3
 9XGJ5L3iZBXVKWx8bt5HUxfnb3SsThuvIO/oxGdZDLEuF357Ezy4JjjH2djmVCuVWISG
 pIwmB8zJB59IRJrhHBxLNMspveq+Kv0WFfGDvSmtVmJhshUyZ54aA/0uDRjGwsiowUdK
 815K6hzpdqPtHimhmZGrBhx8Ym3zrj8QlB+CMff/PhRvbTlDr0ncF3+LySNB1K2g5wLg
 G0F30rWJVjCWLXJJfHpNAd7XUTIdwRAQmGadtbzccJisTju6PDeBBwVuF+I4zG0Xp4jj
 wySw==
X-Gm-Message-State: ACrzQf1nPPe1l5lwQusaHoSbyaIpNss0EHg4/+RmiS8zvbsk5dON0IKO
 pxvjgGLklMI2jj6FyemfRSW7/vzKFSMLLrhaAq4wNA==
X-Google-Smtp-Source: AMsMyM4WzkVgP+HlYu/hXxndYVEW+ikrBgoVSC2s61IT60dLmVa4lu36WrgsBoYQ7rj4vYLHvfKQny4wvHwqFcAzXQE=
X-Received: by 2002:a17:903:22c1:b0:187:2ced:455f with SMTP id
 y1-20020a17090322c100b001872ced455fmr17805199plg.18.1667487193938; Thu, 03
 Nov 2022 07:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-11-maz@kernel.org>
 <CAAeT=FycObU5eHaR23OZ_PeR6-cQeNrmGs=Mi-VnrVuWR6ovSg@mail.gmail.com>
 <87v8nwfmwb.wl-maz@kernel.org>
In-Reply-To: <87v8nwfmwb.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 3 Nov 2022 07:52:57 -0700
Message-ID: <CAAeT=Fz9pKey3=bc=Nzn=c8HZ=PhGmv4tTGkwmi2yiEHG9eM3Q@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
