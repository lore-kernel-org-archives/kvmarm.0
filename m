Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EBF1C3F
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 15:53:38 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so4905278pjk.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 08:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=yQDm8fiZXix/zxbz2AI0d4haCey5lY6KntuO3QR5rv32E3Q1fUvU2UAUzL5Rsd/301
         uwDiUj28JrO8Tc8/eKCclkBxYF8o10iln+GajIIEKY9oZ9kK6BIGpBWyjP8FFUr4rF0y
         UqV786XFGvErwfXsPR8TxWsgw94AJqkmXP2YjPrk6feDN2lS5rkH98panUT2RmOZ5scw
         sc5Y2EfrwA7TXakwsbeRDBH6bFgVQqSikV+hhBugvZd/9i7lPUdmEzy4FxYH2h2BKTjv
         G2yxCPpfbV68HUcrAFaRWticzh74Aidn5sYXYMEzZT5V8Tm+tImnznN97XROuGv0S4Pj
         +1lg==
X-Gm-Message-State: ACrzQf0X3gtYZ45L2hDNmPxAx+ZSH9H319ZIPQdfHba6Q+eOkJwbVSXw
	aKkyP50B8c5+xeb3N5Hh4rQQS3lRz4hbJFIp3VhWeA==
X-Google-Smtp-Source: AMsMyM5RjIpowH+EtUVsYugWjK1YsJUmZijSJNVPnbkraoQT7CYAkaAcrlZjjwisP8bWz4zMTHopTTUtp17kS/ninN4=
X-Received: by 2002:a17:902:7145:b0:187:2356:c29d with SMTP id
 u5-20020a170902714500b001872356c29dmr26043238plm.154.1667577218174; Fri, 04
 Nov 2022 08:53:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-12-maz@kernel.org>
 <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
 <87tu3gfi8u.wl-maz@kernel.org> <CAAeT=FwViQRmyJjf3jxcWnLFQAYob8uvvx7QNhWyj6OmaYDKyg@mail.gmail.com>
 <86bkpmrjv8.wl-maz@kernel.org>
In-Reply-To: <86bkpmrjv8.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 4 Nov 2022 08:53:21 -0700
Message-ID: <CAAeT=Fzp-7MMBJshAAQBgFwXLH2z5ASDgmDBLNJsQoFA=MSciw@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221104155321.iAsbs9qhR7CDbs3dSbz8Q1YSWW2BixbK1En4fX6FwTY@z>

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
