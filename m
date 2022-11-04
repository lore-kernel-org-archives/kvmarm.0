Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D32C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 15:53:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C87A340FD3;
	Fri,  4 Nov 2022 11:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b14sh9EI9aOb; Fri,  4 Nov 2022 11:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E8C440D23;
	Fri,  4 Nov 2022 11:53:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ACA140801
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:53:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RW164+qE2mpU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 11:53:39 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CA694079D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 11:53:39 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 v4-20020a17090a088400b00212cb0ed97eso4881470pjc.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 08:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=xZr6sJYTNthILEKnYyiTIDKUQg5L0mQcLAjlSQHKvMA=;
 b=DiPJ7hBYkHlGfJ3nf30pKFGntHtz5evEjXdhztqq8D/A407dMn5AvpQqylNiNLOMgz
 nc3YDeYheeuuT9ftKl++CoVBnE/AP2CXvbMWD4eFsUsKk87usV/usn1bcTiwreMbOlnn
 oj96CfLSJujMO64hMTma39wr1Pegh0jD6d/HM3v3N04CX9SCv4+6rKcukonUQpXHsLXz
 C+MC4lvOQ6VjVb5UlfDRziD4JvPEGDO73B2J23nJbSOm5YSurMQ/M2etiRgDKVYl3cKv
 mie5iAg0h4RxBTAn0on5XteEtmlTH/HJ/8i5Uss7Si1C4JqtOGUixIgTx9l+Rx4CHGzg
 DTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=xZr6sJYTNthILEKnYyiTIDKUQg5L0mQcLAjlSQHKvMA=;
 b=pI3qr+BTqOLE7iw676E2RdFiESys+PTCP9lQ/5Q4gqx+5tnnA+MZwymMUropnQa5Ox
 zZlOwzjj1M2dUPw6YmeLxSCoQVGsQy653UV+bLT7ZeIeWMN8M0EEcmlkiJZf/EyJkGpl
 /gwXBYeNFR8rdzsR+L0iroeePwqswuFlpPUZGagXEU5bm04CYT5BPaXnYovY3mcGc2ep
 Xlb/9OiSp74l4g9cG4PKD+lg1hKh+8704RfwDRbjiGmTSsHM8j0+5RnL+vw3TRz5K0VA
 M7KgoTK2NBMPWNbBnWgXq6AFJBroFOuxFoVq7PwJsv49h+3GAxNAENzKlOlpiHppuo4a
 0Sxg==
X-Gm-Message-State: ACrzQf0LVPj/TnxCc0RWIHw8KmEXcOlVkumHSl/S0VAa2qjvVOIE+333
 9xpYHCiT6nsZwhSrU/tPBGSZwQ9kXvredt3pjYrM7g==
X-Google-Smtp-Source: AMsMyM5RjIpowH+EtUVsYugWjK1YsJUmZijSJNVPnbkraoQT7CYAkaAcrlZjjwisP8bWz4zMTHopTTUtp17kS/ninN4=
X-Received: by 2002:a17:902:7145:b0:187:2356:c29d with SMTP id
 u5-20020a170902714500b001872356c29dmr26043238plm.154.1667577218174; Fri, 04
 Nov 2022 08:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-12-maz@kernel.org>
 <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
 <87tu3gfi8u.wl-maz@kernel.org>
 <CAAeT=FwViQRmyJjf3jxcWnLFQAYob8uvvx7QNhWyj6OmaYDKyg@mail.gmail.com>
 <86bkpmrjv8.wl-maz@kernel.org>
In-Reply-To: <86bkpmrjv8.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 4 Nov 2022 08:53:21 -0700
Message-ID: <CAAeT=Fzp-7MMBJshAAQBgFwXLH2z5ASDgmDBLNJsQoFA=MSciw@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
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

On Fri, Nov 4, 2022 at 5:21 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Reiji,
>
> On Fri, 04 Nov 2022 07:00:22 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > On Thu, Nov 3, 2022 at 3:25 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 03 Nov 2022 05:31:56 +0000,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > It appears the patch allows userspace to set IMPDEF even
> > > > when host_pmuver == 0.  Shouldn't it be allowed only when
> > > > host_pmuver == IMPDEF (as before)?
> > > > Probably, it may not cause any real problems though.
> > >
> > > Given that we don't treat the two cases any differently, I thought it
> > > would be reasonable to relax this particular case, and I can't see any
> > > reason why we shouldn't tolerate this sort of migration.
> >
> > That's true. I assume it won't cause any functional issues.
> >
> > I have another comment related to this.
> > KVM allows userspace to create a guest with a mix of vCPUs with and
> > without PMU.  For such a guest, if the register for the vCPU without
> > PMU is set last, I think the PMUVER value for vCPUs with PMU could
> > become no PMU (0) or IMPDEF (0xf).
> > Also, with the current patch, userspace can set PMUv3 support value
> > (non-zero or non-IMPDEF) for vCPUs without the PMU.
> > IMHO, KVM shouldn't allow userspace to set PMUVER to the value that
> > is inconsistent with PMU configuration for the vCPU.
> > What do you think ?
>
> Yes, this seems sensible, and we only do it one way at the moment.
>
> > I'm thinking of the following code (not tested).
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 4fa14b4ae2a6..ddd849027cc3 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1265,10 +1265,17 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver)
> >                 return -EINVAL;
> >
> > -       /* We already have a PMU, don't try to disable it... */
> > -       if (kvm_vcpu_has_pmu(vcpu) &&
> > -           (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF))
> > -               return -EINVAL;
> > +       if (kvm_vcpu_has_pmu(vcpu)) {
> > +               /* We already have a PMU, don't try to disable it... */
> > +               if (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > +                       return -EINVAL;
> > +               }
> > +       } else {
> > +               /* We don't have a PMU, don't try to enable it... */
> > +               if (pmuver > 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > +                       return -EINVAL;
> > +               }
> > +       }
>
> This is a bit ugly. I came up with this instead:
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3b28ef48a525..e104fde1a0ee 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1273,6 +1273,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>                                u64 val)
>  {
>         u8 pmuver, host_pmuver;
> +       bool valid_pmu;
>
>         host_pmuver = kvm_arm_pmu_get_pmuver_limit();
>
> @@ -1286,9 +1287,10 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>         if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver)
>                 return -EINVAL;
>
> -       /* We already have a PMU, don't try to disable it... */
> -       if (kvm_vcpu_has_pmu(vcpu) &&
> -           (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF))
> +       valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> +
> +       /* Make sure view register and PMU support do match */
> +       if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
>                 return -EINVAL;

Thanks, much better!

>
>         /* We can only differ with PMUver, and anything else is an error */
>
> and the similar check for the 32bit counterpart.
>
> >
> >         /* We can only differ with PMUver, and anything else is an error */
> >         val ^= read_id_reg(vcpu, rd);
> > @@ -1276,7 +1283,8 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       vcpu->kvm->arch.dfr0_pmuver = pmuver;
> > +       if (kvm_vcpu_has_pmu(vcpu))
> > +               vcpu->kvm->arch.dfr0_pmuver = pmuver;
>
> We need to update this unconditionally if we want to be able to
> restore an IMPDEF PMU view to the guest.

Yes, right.
BTW, if we have no intention of supporting a mix of vCPUs with and
without PMU, I think it would be nice if we have a clear comment on
that in the code.  Or I'm hoping to disallow it if possible though.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
