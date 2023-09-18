Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4C81F5E9
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:20:30 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-34fc9b461b6so4785ab.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 10:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057630; x=1695662430; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rF32PRmjZZ1Iz4N+4Hfz4EP9hn7ahoRvM+LildeQDJw=;
        b=raNELmiZDs3LFZ/pfWNkP7XgqKcfdMBq7l9HRCC8DTbKNFs5GxLNTzaP/Wkqk02vMx
         pHpteFd1ccOl9DgBe7AOgXe/1Ld3NryjhYq+t6CeCm0RdvUXsOfwg9+0uZ31PhyMCpWT
         3bzozL6Vcz/UBgAVoUbblpSjXW+1v3jeu59VCjklJxsV9FAqMAlbBxaawexNCB4HiNDQ
         C7eyEscS8TDiD9O3WBTtw7Fr/IypxWR//qpMRszvDLLU9V2YnSz29VVu6fgCLC1TKIJk
         cvgKakLJim7Hy+cZLukdZXmLt4Qxa6/SsD+VHguVU0iCExFAPtCMkB/Z2Nbt/weW2O8v
         35gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057630; x=1695662430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rF32PRmjZZ1Iz4N+4Hfz4EP9hn7ahoRvM+LildeQDJw=;
        b=vf/bdiKbEfKCffWqRLw4mR5UddmCdcgQBfneEv814Tnq/fTJjA8DOiIGERXBNnl3oy
         l+wW8fG2I/VHflkMLV90WbRSGDW6mFmm1nT9kTCa8vHQLOrY5ScC1DAX4QYC4qBiX+r3
         WSnv6ztBENRjM9jzjnz0520ShX/DvVRwRWEQ7WiD1URuckSahaDwoLjOfuEqQkPKlFDm
         iYT4moVns/oZjavId8YdbeU5S06cnVQSnR0nXSbjx2ty6XNzbxU3vZ2d/ls27Ptsrnpv
         k9QRjv1OnwFX2zLT3OQLWQOfBom15WThKKfwrvSaogA9/0NB2BZzb5MxKEfEcuLd34VB
         pU4Q==
X-Gm-Message-State: AOJu0YwOpKf8C+Xa9zFJ7B+CsI8FPHx7bJhRZekd1Z/8Ixh6wejfk1pu
	PMLeMRc6zH/k3L+zEvT+FUUn8iqLPZkz1pwRQroHFw==
X-Google-Smtp-Source: AGHT+IHmF+Ty2jZW+aDwReK81ghAbLya+nO6jZpFOf5lfLtttpTt9kgWl3DhNeeH1FFACtMFrKbqqUuZS5lqAAl1n7g=
X-Received: by 2002:a92:c562:0:b0:34d:ff4c:5e3a with SMTP id
 b2-20020a92c562000000b0034dff4c5e3amr3562ilj.10.1695057630005; Mon, 18 Sep
 2023 10:20:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-11-rananta@google.com>
 <ZQTF0bxzXN2kUPTI@linux.dev>
In-Reply-To: <ZQTF0bxzXN2kUPTI@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 10:20:18 -0700
Message-ID: <CAJHc60xxNaT3Sq9s-663qNhrBke_Hmh+CTWsy4eAFCjGCrRndg@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, Sep 15, 2023 at 2:00=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> On Thu, Aug 17, 2023 at 12:30:27AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Introduce vpmu_counter_access test for arm64 platforms.
> > The test configures PMUv3 for a vCPU, sets PMCR_EL0.N for the vCPU,
> > and check if the guest can consistently see the same number of the
> > PMU event counters (PMCR_EL0.N) that userspace sets.
> > This test case is done with each of the PMCR_EL0.N values from
> > 0 to 31 (With the PMCR_EL0.N values greater than the host value,
> > the test expects KVM_SET_ONE_REG for the PMCR_EL0 to fail).
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../kvm/aarch64/vpmu_counter_access.c         | 235 ++++++++++++++++++
> >  2 files changed, 236 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_ac=
cess.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> > index c692cc86e7da8..a1599e2b82e38 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -148,6 +148,7 @@ TEST_GEN_PROGS_aarch64 +=3D aarch64/smccc_filter
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/vcpu_width_config
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/vgic_init
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/vgic_irq
> > +TEST_GEN_PROGS_aarch64 +=3D aarch64/vpmu_counter_access
> >  TEST_GEN_PROGS_aarch64 +=3D access_tracking_perf_test
> >  TEST_GEN_PROGS_aarch64 +=3D demand_paging_test
> >  TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c =
b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > new file mode 100644
> > index 0000000000000..d0afec07948ef
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > @@ -0,0 +1,235 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * vpmu_counter_access - Test vPMU event counter access
> > + *
> > + * Copyright (c) 2022 Google LLC.
> > + *
> > + * This test checks if the guest can see the same number of the PMU ev=
ent
> > + * counters (PMCR_EL0.N) that userspace sets.
> > + * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the hos=
t.
> > + */
> > +#include <kvm_util.h>
> > +#include <processor.h>
> > +#include <test_util.h>
> > +#include <vgic.h>
> > +#include <perf/arm_pmuv3.h>
> > +#include <linux/bitfield.h>
> > +
> > +/* The max number of the PMU event counters (excluding the cycle count=
er) */
> > +#define ARMV8_PMU_MAX_GENERAL_COUNTERS       (ARMV8_PMU_MAX_COUNTERS -=
 1)
> > +
> > +struct vpmu_vm {
> > +     struct kvm_vm *vm;
> > +     struct kvm_vcpu *vcpu;
> > +     int gic_fd;
> > +};
> > +
>
> nit: this test is single threaded, so there will only ever be a single
> instance of a VM at a time. Dynamically allocating a backing structure
> doesn't add any value, IMO.
>
> You can just get away with using globals.
>
Probably. I can try to have a single global.

> > +/*
> > + * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
> > + * the vCPU to @pmcr_n, which is larger than the host value.
> > + * The attempt should fail as @pmcr_n is too big to set for the vCPU.
> > + */
> > +static void run_error_test(uint64_t pmcr_n)
> > +{
> > +     struct vpmu_vm *vpmu_vm;
> > +     struct kvm_vcpu *vcpu;
> > +     int ret;
> > +     uint64_t pmcr, pmcr_orig;
> > +
> > +     pr_debug("Error test with pmcr_n %lu (larger than the host)\n", p=
mcr_n);
> > +     vpmu_vm =3D create_vpmu_vm(guest_code);
> > +     vcpu =3D vpmu_vm->vcpu;
> > +
> > +     /* Update the PMCR_EL0.N with @pmcr_n */
> > +     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
> > +     pmcr =3D pmcr_orig & ~ARMV8_PMU_PMCR_N;
> > +     pmcr |=3D (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> > +
> > +     /* This should fail as @pmcr_n is too big to set for the vCPU */
> > +     ret =3D __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmc=
r);
> > +     TEST_ASSERT(ret, "Setting PMCR to 0x%lx (orig PMCR 0x%lx) didn't =
fail",
> > +                 pmcr, pmcr_orig);
>
> The failure pattern for this should now be the write to PMCR_EL0.N had
> no effect.
>
Right. I'll make the change.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
