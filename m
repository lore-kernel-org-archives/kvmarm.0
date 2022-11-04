Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0687310EB
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 07:00:39 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id g24so4095286plq.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 00:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OkaYBFTkTJOLws8unjECEd5re67/MivC1vGoCWgNdIA=;
        b=FKp6NbI+dU8fh5ZxoU8J2+rCaRu9ZcC1CSDUb+/iuOBdmi10+ZDR0lXKy7YyIBokBa
         hHH0sWInFczWPfNvzFp/C56hOZTbU2C+QY6zH3mN3aXSQ+n044oJ0ggkZB8h61ulJ0wJ
         HbsbkBptoJhgELan0IfRFRGRwB6sEAa/OLWKhTARy3vm4Y6W19RyJ2jnh+f0VGmBsqpu
         niSGI2IkoRU+ctTYkKJ9lYFjIzSYjRY8mWGuTuI8vjtr4ouBQDJqIO0d/L1ismojNUhx
         TDDFfzVWxpDXYPovwbBJYcGimOSXfURipT+2TMsKJmH84+yVug1aDYX0BJXM8wb5rF7e
         aO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OkaYBFTkTJOLws8unjECEd5re67/MivC1vGoCWgNdIA=;
        b=yHkCknkX5fB3jdduZORo3SyJmvHuFqeOAYZmbc0lZaq0SoWp4W5TsdUKtJYAB0ZcfP
         fK6s0xhp0JCUDikNA0KlVK7SMMsKYWXQPRfdjQuuus7dWXeggd0rzQiuHieHKbnfl4gg
         Pg2AyMGK65Ai4PGwEnhIpHnMwx7NDCbkF3VxNCVKcaRCG4+gRhWJP5Eluoq+HDyBYbzx
         gB/v3yQTSj1KYCD8UZEaF1+VU+RTn8g5cvXbRmI+bBQNqgx3GYUAR4SbBDGt5tHgFTHZ
         UfTbG2vphWFakETbCIm5yENJh5sqgl3OQCk1OwOg6dLC5GOJMDDn5uqHMvyRML5zZk7O
         7f4Q==
X-Gm-Message-State: ACrzQf0ZLA1XmtK1k3MILr/l6VfFHXodyegAHASb0wjg4MWwz67TEbDM
	6cGypCro6k32AaJnimrVWsK0vOlck4qNPgUSAKbW8A==
X-Google-Smtp-Source: AMsMyM4au6JdSEM3oUwq6uwtgVjKg0ofbyk0NdD0oa6I18qKO8X0z9DSu94dwOgaWrxqawwY5CdkCKG2mxEd+r1/z9I=
X-Received: by 2002:a17:90b:4a02:b0:213:9ba4:206a with SMTP id
 kk2-20020a17090b4a0200b002139ba4206amr37355261pjb.102.1667545239102; Fri, 04
 Nov 2022 00:00:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-12-maz@kernel.org>
 <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com> <87tu3gfi8u.wl-maz@kernel.org>
In-Reply-To: <87tu3gfi8u.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 4 Nov 2022 00:00:22 -0700
Message-ID: <CAAeT=FwViQRmyJjf3jxcWnLFQAYob8uvvx7QNhWyj6OmaYDKyg@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221104070022.UEeKld37WGJWIQWIDn065suKC02ag9e99L2Dzg9YIag@z>

Hi Marc,

On Thu, Nov 3, 2022 at 3:25 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 03 Nov 2022 05:31:56 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Fri, Oct 28, 2022 at 4:16 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> > > the PMUver field can be altered and be at most the one that was
> > > initially computed for the guest.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 37 ++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 36 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 7a4cd644b9c0..4fa14b4ae2a6 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1247,6 +1247,40 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > >         return 0;
> > >  }
> > >
> > > +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > > +                              const struct sys_reg_desc *rd,
> > > +                              u64 val)
> > > +{
> > > +       u8 pmuver, host_pmuver;
> > > +
> > > +       host_pmuver = kvm_arm_pmu_get_pmuver_limit();
> > > +
> > > +       /*
> > > +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> > > +        * as it doesn't promise more than what the HW gives us. We
> > > +        * allow an IMPDEF PMU though, only if no PMU is supported
> > > +        * (KVM backward compatibility handling).
> > > +        */
> >
> > It appears the patch allows userspace to set IMPDEF even
> > when host_pmuver == 0.  Shouldn't it be allowed only when
> > host_pmuver == IMPDEF (as before)?
> > Probably, it may not cause any real problems though.
>
> Given that we don't treat the two cases any differently, I thought it
> would be reasonable to relax this particular case, and I can't see any
> reason why we shouldn't tolerate this sort of migration.

> Given that we don't treat the two cases any differently, I thought it
> would be reasonable to relax this particular case, and I can't see any
> reason why we shouldn't tolerate this sort of migration.

That's true. I assume it won't cause any functional issues.

I have another comment related to this.
KVM allows userspace to create a guest with a mix of vCPUs with and
without PMU.  For such a guest, if the register for the vCPU without
PMU is set last, I think the PMUVER value for vCPUs with PMU could
become no PMU (0) or IMPDEF (0xf).
Also, with the current patch, userspace can set PMUv3 support value
(non-zero or non-IMPDEF) for vCPUs without the PMU.
IMHO, KVM shouldn't allow userspace to set PMUVER to the value that
is inconsistent with PMU configuration for the vCPU.
What do you think ?

I'm thinking of the following code (not tested).

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4fa14b4ae2a6..ddd849027cc3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1265,10 +1265,17 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
        if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver)
                return -EINVAL;

-       /* We already have a PMU, don't try to disable it... */
-       if (kvm_vcpu_has_pmu(vcpu) &&
-           (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF))
-               return -EINVAL;
+       if (kvm_vcpu_has_pmu(vcpu)) {
+               /* We already have a PMU, don't try to disable it... */
+               if (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+                       return -EINVAL;
+               }
+       } else {
+               /* We don't have a PMU, don't try to enable it... */
+               if (pmuver > 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+                       return -EINVAL;
+               }
+       }

        /* We can only differ with PMUver, and anything else is an error */
        val ^= read_id_reg(vcpu, rd);
@@ -1276,7 +1283,8 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
        if (val)
                return -EINVAL;

-       vcpu->kvm->arch.dfr0_pmuver = pmuver;
+       if (kvm_vcpu_has_pmu(vcpu))
+               vcpu->kvm->arch.dfr0_pmuver = pmuver;

        return 0;
 }

Thank you,
Reiji



>
> >
> >
> > > +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
> > > +       if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver)
> > > +               return -EINVAL;
> > > +
> > > +       /* We already have a PMU, don't try to disable it... */
> > > +       if (kvm_vcpu_has_pmu(vcpu) &&
> > > +           (pmuver == 0 || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF))
> > > +               return -EINVAL;
> >
> > Nit: Perhaps it might be useful to return a different error code for the
> > above two (new) error cases (I plan to use -E2BIG and -EPERM
> > respectively for those cases with my ID register series).
>
> My worry in doing so is that we don't have an established practice for
> these cases. I'm fine with introducing new error codes, but I'm not
> sure there is an existing practice in userspace to actually interpret
> them.
>
> Even -EPERM has a slightly different meaning, and although there is
> some language there saying that it is all nonsense, we should be very
> careful.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
