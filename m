Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59741C95F
	for <kvmarm@lists.linux.dev>; Thu,  9 Mar 2023 22:45:38 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id p13-20020a9d744d000000b0069438f0db7eso1975718otk.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Mar 2023 14:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678401937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/1lFO4mbxWfaPl9ZL5nAdXcftJstA4UqCnt0Nk9lLg=;
        b=NVRs1Cp5urCGTZd4WmxJFG6hRpVWYjX8JvN6u7gaPMk1eDbOtTOK3VV93KMaTp0ZeN
         4blxbuxfqrFABR3twx5fL8WO5MdAwKxrOM+XNG6XjzCI9D4AaQ/DFiUoi6CsNms1cfVJ
         Q0YQqCIt0iPZ6VZSiGaTyD674tS2DQ0x5jJC958SxmABPd/C1XEx5OhtWWNI4Ugf9Oo6
         6y4d1KEQTH1OinDJmU0AYCtaIYflctRjwBNEe87w6m9WBKf8U13tphOgpb0d0Fkb4K8r
         dJVnNM+K4SFhFxP1GKU+kr+cwvHFCTn+Q4emENChe2lP1r7y/61wnNnxclSeiofAK+xM
         zZag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/1lFO4mbxWfaPl9ZL5nAdXcftJstA4UqCnt0Nk9lLg=;
        b=UwR2zduFLQKVOPBxJTGuX8srSzBaqb4y1EBNiNlxBIMwTB8ZTBNn0CQduf96vupLl/
         qn8pk8B6taLdnSpqHN/CWEalDfevZY/8C9LvJJkmr0tgQCGT88DPuz+B9cCMWTXXvoid
         OVflaVKGcjH2atft28RZlVwJCZuEFGfQj2JhsOG1F4CS0RAuGHzRSHU3ogLpoC04TRCc
         0ezbA4yURNW/DfIyQG65qX5OZg8+iTVRewu9c4JjEy+LctdX/QBx43tHgLUOicHoGA8P
         7Sb/rfsxS3NvUrqE2NcIrH3vZOaObyS/w8kO76yo2HR10ZHLkFwa3Y3rGgju3+NTBU68
         iWUA==
X-Gm-Message-State: AO0yUKU5+izv8WIyfcKzxT+cR4GE2WxevDBriwDfejV8E7lXo5iPIeK5
	x+Pw5cercehRWYY3ACcIlECWdqFFv86766VJymgOUw==
X-Google-Smtp-Source: AK7set/GZPbMdM6DZpU1ClFlYj29j6KEHZBL5xZpPahyqDKJmqRkCkYxtXaUk4eSBC46oCtvQ5BJUNcNUO3MbNrvDPw=
X-Received: by 2002:a05:6830:3378:b0:68d:48f0:9bad with SMTP id
 l56-20020a056830337800b0068d48f09badmr7984002ott.7.1678401937160; Thu, 09 Mar
 2023 14:45:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-9-rananta@google.com>
 <CAAeT=Fzww3z1Y47gZjmeU0p+fK=gxiqNx5DHGcu4109B7DWi4A@mail.gmail.com>
In-Reply-To: <CAAeT=Fzww3z1Y47gZjmeU0p+fK=gxiqNx5DHGcu4109B7DWi4A@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Mar 2023 14:45:25 -0800
Message-ID: <CAJHc60yLOc55WQJQ1cDoQ+pcuv376xBBgmZGKBsvZ+7gshuyvw@mail.gmail.com>
Subject: Re: [REPOST PATCH 08/16] selftests: KVM: aarch64: Consider PMU event
 filters for VM creation
To: Reiji Watanabe <reijiw@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Reiji,

On Thu, Mar 2, 2023 at 8:31=E2=80=AFPM Reiji Watanabe <reijiw@google.com> w=
rote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Accept a list of KVM PMU event filters as an argument while creating
> > a VM via create_vpmu_vm(). Upcoming patches would leverage this to
> > test the event filters' functionality.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vpmu_test.c | 64 +++++++++++++++++--
> >  1 file changed, 60 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/te=
sting/selftests/kvm/aarch64/vpmu_test.c
> > index 15aebc7d7dc94..2b3a4fa3afa9c 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > @@ -15,10 +15,14 @@
> >  #include <vgic.h>
> >  #include <asm/perf_event.h>
> >  #include <linux/bitfield.h>
> > +#include <linux/bitmap.h>
> >
> >  /* The max number of the PMU event counters (excluding the cycle count=
er) */
> >  #define ARMV8_PMU_MAX_GENERAL_COUNTERS (ARMV8_PMU_MAX_COUNTERS - 1)
> >
> > +/* The max number of event numbers that's supported */
> > +#define ARMV8_PMU_MAX_EVENTS           64
>
> The name and the comment would be a bit misleading.
> (This sounds like a max number of events that are supported by ARMv8)
>
> Perhaps 'MAX_EVENT_FILTER_BITS' would be more clear ?
>
>
You are right. It should actually represent the event filter bits.
Even the value is incorrect. It should be 16 and would change the loop
iteration logic in guest_event_filter_test(). Thanks for catching
this!
> > +
> >  /*
> >   * The macros and functions below for reading/writing PMEV{CNTR,TYPER}=
<n>_EL0
> >   * were basically copied from arch/arm64/kernel/perf_event.c.
> > @@ -224,6 +228,8 @@ struct pmc_accessor pmc_accessors[] =3D {
> >         { read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pme=
vtypern },
> >  };
> >
> > +#define MAX_EVENT_FILTERS_PER_VM 10
>
> (Looking at just this patch,) it appears 'PER_VM' in the name
> might be rather misleading ?
>
Probably it's not clear. It should represent the max number of event
filter configurations that can be applied to a VM. Would a comment
help?

> > +
> >  #define INVALID_EC     (-1ul)
> >  uint64_t expected_ec =3D INVALID_EC;
> >  uint64_t op_end_addr;
> > @@ -232,6 +238,7 @@ struct vpmu_vm {
> >         struct kvm_vm *vm;
> >         struct kvm_vcpu *vcpu;
> >         int gic_fd;
> > +       unsigned long *pmu_filter;
> >  };
> >
> >  enum test_stage {
> > @@ -541,8 +548,51 @@ static void guest_code(void)
> >  #define GICD_BASE_GPA  0x8000000ULL
> >  #define GICR_BASE_GPA  0x80A0000ULL
> >
> > +static unsigned long *
> > +set_event_filters(struct kvm_vcpu *vcpu, struct kvm_pmu_event_filter *=
pmu_event_filters)
>
> Can you add a comment that explains the function ?
> (especially for @pmu_event_filters and the return value ?)
>
Yes, I'll add a comment
> > +{
> > +       int j;
> > +       unsigned long *pmu_filter;
> > +       struct kvm_device_attr filter_attr =3D {
> > +               .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> > +               .attr =3D KVM_ARM_VCPU_PMU_V3_FILTER,
> > +       };
> > +
> > +       /*
> > +        * Setting up of the bitmap is similar to what KVM does.
> > +        * If the first filter denys an event, default all the others t=
o allow, and vice-versa.
> > +        */
> > +       pmu_filter =3D bitmap_zalloc(ARMV8_PMU_MAX_EVENTS);
> > +       TEST_ASSERT(pmu_filter, "Failed to allocate the pmu_filter");
> > +
> > +       if (pmu_event_filters[0].action =3D=3D KVM_PMU_EVENT_DENY)
> > +               bitmap_fill(pmu_filter, ARMV8_PMU_MAX_EVENTS);
> > +
> > +       for (j =3D 0; j < MAX_EVENT_FILTERS_PER_VM; j++) {
> > +               struct kvm_pmu_event_filter *pmu_event_filter =3D &pmu_=
event_filters[j];
> > +
> > +               if (!pmu_event_filter->nevents)
>
> What does this mean ? (the end of the valid entry in the array ?)
>
Yes, it should represent the end of an array. I can add a comment if
it's unclear.
>
> > +                       break;
> > +
> > +               pr_debug("Applying event filter:: event: 0x%x; action: =
%s\n",
> > +                               pmu_event_filter->base_event,
> > +                               pmu_event_filter->action =3D=3D KVM_PMU=
_EVENT_ALLOW ? "ALLOW" : "DENY");
> > +
> > +               filter_attr.addr =3D (uint64_t) pmu_event_filter;
> > +               vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
> > +
> > +               if (pmu_event_filter->action =3D=3D KVM_PMU_EVENT_ALLOW=
)
> > +                       __set_bit(pmu_event_filter->base_event, pmu_fil=
ter);
> > +               else
> > +                       __clear_bit(pmu_event_filter->base_event, pmu_f=
ilter);
> > +       }
> > +
> > +       return pmu_filter;
> > +}
> > +
> >  /* Create a VM that has one vCPU with PMUv3 configured. */
> > -static struct vpmu_vm *create_vpmu_vm(void *guest_code)
> > +static struct vpmu_vm *
> > +create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_even=
t_filters)
> >  {
> >         struct kvm_vm *vm;
> >         struct kvm_vcpu *vcpu;
> > @@ -586,6 +636,9 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_c=
ode)
> >                     "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", =
pmuver);
> >
> >         /* Initialize vPMU */
> > +       if (pmu_event_filters)
> > +               vpmu_vm->pmu_filter =3D set_event_filters(vcpu, pmu_eve=
nt_filters);
> > +
> >         vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
> >         vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
> >
> > @@ -594,6 +647,8 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_c=
ode)
> >
> >  static void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm)
> >  {
> > +       if (vpmu_vm->pmu_filter)
> > +               bitmap_free(vpmu_vm->pmu_filter);
> >         close(vpmu_vm->gic_fd);
> >         kvm_vm_free(vpmu_vm->vm);
> >         free(vpmu_vm);
> > @@ -631,7 +686,7 @@ static void run_counter_access_test(uint64_t pmcr_n=
)
> >         guest_data.expected_pmcr_n =3D pmcr_n;
> >
> >         pr_debug("Test with pmcr_n %lu\n", pmcr_n);
> > -       vpmu_vm =3D create_vpmu_vm(guest_code);
> > +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
> >         vcpu =3D vpmu_vm->vcpu;
> >
> >         /* Save the initial sp to restore them later to run the guest a=
gain */
> > @@ -676,7 +731,7 @@ static void run_counter_access_error_test(uint64_t =
pmcr_n)
> >         guest_data.expected_pmcr_n =3D pmcr_n;
> >
> >         pr_debug("Error test with pmcr_n %lu (larger than the host)\n",=
 pmcr_n);
> > -       vpmu_vm =3D create_vpmu_vm(guest_code);
> > +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
> >         vcpu =3D vpmu_vm->vcpu;
> >
> >         /* Update the PMCR_EL0.N with @pmcr_n */
> > @@ -719,9 +774,10 @@ static uint64_t get_pmcr_n_limit(void)
> >         struct vpmu_vm *vpmu_vm;
> >         uint64_t pmcr;
> >
> > -       vpmu_vm =3D create_vpmu_vm(guest_code);
> > +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
> >         vcpu_get_reg(vpmu_vm->vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &p=
mcr);
> >         destroy_vpmu_vm(vpmu_vm);
> > +
> >         return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
> >  }
>
> Thank you,
> Reiji
>
>
> >
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
