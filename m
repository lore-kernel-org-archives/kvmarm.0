Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AB837C8C
	for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R7YtIjhp"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c9b70b9671so19025ad.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 11:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697738965; x=1698343765; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IK0HfDM/pytLY9c5KYZvIPmccvSU6yoBacjjcBqv8Jc=;
        b=R7YtIjhp2v4ev8JAo/fVI5SE2Vm2UA6rQotCDKBKMqh7w1B5VW78yLfhjofiVbhePH
         v+/7GWc6t1wc1kShp74jBx4M3kWwaw/MuUHu5NJyTbVdQX9BPn0v2MpAy8Kq3Jg9+H3Q
         QXjOQp6r/He7j/30DFKKUIyeVmWbwzt9cnOWwf7fwzfoLwmLgs39C7ITyXsqE5sJ83H7
         zhaOP6VKduv8mRVjUAv/WugcWrAf7paYHUnmDFwpeuDtC0Uo7HG0KtZKtDSQDeTpN1e+
         qL+RTvxkHEjI1jQGdMWexRP0IdfpET4CeyCrPlKxItzKqro4AaG/bSZZFjevneODlKSr
         s23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697738965; x=1698343765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IK0HfDM/pytLY9c5KYZvIPmccvSU6yoBacjjcBqv8Jc=;
        b=jys+LbbHglViOH6IGV3L8t1Fbic2Pc/MpR0swtUGOy6OuycUrRWXq1ILF3B4gycnPp
         VFdA74sTNXXpg2GuRA93M0C7zAeXEif6I0xaaahe3kjmzDNeWz8Uol1wj5eKscYZCNl1
         h5zU+KnJRY/A7zWC1mi5NWFanlUbg/Fumj9r+Xx3z396UprqTDErK60UgHxaxjZCdVw4
         hG29BbljyfpfUUFF7O7FpcCgwuBBMgH1eZnYvYH7wtlPkaKLMNRxWjJXBNR3r+BX7zdV
         I0qdZ5Gs5V+CR0tdSSUjupL61kJ1MkMcR71e9zPl/0tehTAec6bO3Usad9hdLjLVKus6
         THEg==
X-Gm-Message-State: AOJu0Yy9yZy4b3nqqps8HWa/vN0lrrfFSzjTbgxZMSRio4xCM7RI2zQv
	T2086xjjqhIaxowN6sS3a7/mKduh/6Rw5HFpmK9CWA==
X-Google-Smtp-Source: AGHT+IHngjZq2LQbGXMWIQOfbgX+FzpNSJGqCuZI0bAJP0wT2MkUfGozN/riDUdLmn/vtm3xKAw1HUFQ67bsFlpj0BM=
X-Received: by 2002:a17:902:9047:b0:1ca:42a:1771 with SMTP id
 w7-20020a170902904700b001ca042a1771mr5868plz.24.1697738964780; Thu, 19 Oct
 2023 11:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-13-rananta@google.com>
 <3e6e6c25-7b20-46b4-ffce-d34841aca209@redhat.com>
In-Reply-To: <3e6e6c25-7b20-46b4-ffce-d34841aca209@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 19 Oct 2023 11:09:13 -0700
Message-ID: <CAJHc60xTVgx8L1MxFshnD455p=qjvH4_RP6hiQZDb7P4MUbvkw@mail.gmail.com>
Subject: Re: [PATCH v7 12/12] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
To: Eric Auger <eauger@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2023 at 11:54=E2=80=AFPM Eric Auger <eauger@redhat.com> wro=
te:
>
> Hi Raghavendra,
>
> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Add a new test case to the vpmu_counter_access test to check
> > if PMU registers or their bits for unimplemented counters are not
> > accessible or are RAZ, as expected.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../kvm/aarch64/vpmu_counter_access.c         | 95 +++++++++++++++++--
> >  .../selftests/kvm/include/aarch64/processor.h |  1 +
> >  2 files changed, 87 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c =
b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > index e92af3c0db03..788386ac0894 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > @@ -5,8 +5,8 @@
> >   * Copyright (c) 2022 Google LLC.
> >   *
> >   * This test checks if the guest can see the same number of the PMU ev=
ent
> > - * counters (PMCR_EL0.N) that userspace sets, and if the guest can acc=
ess
> > - * those counters.
> > + * counters (PMCR_EL0.N) that userspace sets, if the guest can access
> > + * those counters, and if the guest cannot access any other counters.
> I would suggest: if the guest is prevented from accessing any other count=
ers
> >   * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the hos=
t.
> >   */
> >  #include <kvm_util.h>
> > @@ -131,9 +131,9 @@ static void write_pmevtypern(int n, unsigned long v=
al)
> >  }
> >
> >  /*
> > - * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
> > + * The pmc_accessor structure has pointers to PMEV{CNTR,TYPER}<n>_EL0
> >   * accessors that test cases will use. Each of the accessors will
> > - * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
> > + * either directly reads/writes PMEV{CNTR,TYPER}<n>_EL0
> I guess this should belong to the previous patch?
> >   * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them throug=
h
> >   * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
> >   *
> > @@ -291,25 +291,85 @@ static void test_access_pmc_regs(struct pmc_acces=
sor *acc, int pmc_idx)
> >                      pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_dat=
a);
> >  }
> >
> > +#define INVALID_EC   (-1ul)
> > +uint64_t expected_ec =3D INVALID_EC;
> > +uint64_t op_end_addr;
> > +
> >  static void guest_sync_handler(struct ex_regs *regs)
> >  {
> >       uint64_t esr, ec;
> >
> >       esr =3D read_sysreg(esr_el1);
> >       ec =3D (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> > -     __GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, e=
sr, ec);
> > +
> > +     __GUEST_ASSERT(op_end_addr && (expected_ec =3D=3D ec),
> > +                     "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx; EC expected: 0=
x%lx",
> > +                     regs->pc, esr, ec, expected_ec);
> > +
> > +     /* Will go back to op_end_addr after the handler exits */
> > +     regs->pc =3D op_end_addr;
> > +
> > +     /*
> > +      * Clear op_end_addr, and setting expected_ec to INVALID_EC
> and set
> > +      * as a sign that an exception has occurred.
> > +      */
> > +     op_end_addr =3D 0;
> > +     expected_ec =3D INVALID_EC;
> > +}
> > +
> > +/*
> > + * Run the given operation that should trigger an exception with the
> > + * given exception class. The exception handler (guest_sync_handler)
> > + * will reset op_end_addr to 0, and expected_ec to INVALID_EC, and
> > + * will come back to the instruction at the @done_label.
> > + * The @done_label must be a unique label in this test program.
> > + */
> > +#define TEST_EXCEPTION(ec, ops, done_label)          \
> > +{                                                    \
> > +     extern int done_label;                          \
> > +                                                     \
> > +     WRITE_ONCE(op_end_addr, (uint64_t)&done_label); \
> > +     GUEST_ASSERT(ec !=3D INVALID_EC);                 \
> > +     WRITE_ONCE(expected_ec, ec);                    \
> > +     dsb(ish);                                       \
> > +     ops;                                            \
> > +     asm volatile(#done_label":");                   \
> > +     GUEST_ASSERT(!op_end_addr);                     \
> > +     GUEST_ASSERT(expected_ec =3D=3D INVALID_EC);        \
> > +}
> > +
> > +/*
> > + * Tests for reading/writing registers for the unimplemented event cou=
nter
> > + * specified by @pmc_idx (>=3D PMCR_EL0.N).
> > + */
> > +static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int=
 pmc_idx)
> > +{
> > +     /*
> > +      * Reading/writing the event count/type registers should cause
> > +      * an UNDEFINED exception.
> > +      */
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx), inv_rd_cn=
tr);
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0), inv_w=
r_cntr);
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx), inv_rd_t=
yper);
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0), inv_=
wr_typer);
> > +     /*
> > +      * The bit corresponding to the (unimplemented) counter in
> > +      * {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers should be RAZ.
> {PMCNTEN,PMINTEN,PMOVS}{SET,CLR}
> > +      */
> > +     test_bitmap_pmu_regs(pmc_idx, 1);
> > +     test_bitmap_pmu_regs(pmc_idx, 0);
> >  }
> >
> >  /*
> >   * The guest is configured with PMUv3 with @expected_pmcr_n number of
> >   * event counters.
> >   * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> > - * if reading/writing PMU registers for implemented counters can work
> > - * as expected.
> > + * if reading/writing PMU registers for implemented or unimplemented
> > + * counters can work as expected.
> >   */
> >  static void guest_code(uint64_t expected_pmcr_n)
> >  {
> > -     uint64_t pmcr, pmcr_n;
> > +     uint64_t pmcr, pmcr_n, unimp_mask;
> >       int i, pmc;
> >
> >       __GUEST_ASSERT(expected_pmcr_n <=3D ARMV8_PMU_MAX_GENERAL_COUNTER=
S,
> > @@ -324,15 +384,32 @@ static void guest_code(uint64_t expected_pmcr_n)
> >                       "Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> >                       pmcr_n, expected_pmcr_n);
> >
> > +     /*
> > +      * Make sure that (RAZ) bits corresponding to unimplemented event
> > +      * counters in {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers are reset t=
o zero.
> > +      * (NOTE: bits for implemented event counters are reset to UNKNOW=
N)
> > +      */
> > +     unimp_mask =3D GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pm=
cr_n);
> > +     check_bitmap_pmu_regs(unimp_mask, false);
> wrt above comment, this also checks pmintenset|clr_el1.
> > +
> >       /*
> >        * Tests for reading/writing PMU registers for implemented counte=
rs.
> > -      * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor func=
tions.
> > +      * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor funct=
ions.
> >        */
> >       for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> >               for (pmc =3D 0; pmc < pmcr_n; pmc++)
> >                       test_access_pmc_regs(&pmc_accessors[i], pmc);
> >       }
> >
> > +     /*
> > +      * Tests for reading/writing PMU registers for unimplemented coun=
ters.
> > +      * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor funct=
ions.
> > +      */
> > +     for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> > +             for (pmc =3D pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS=
; pmc++)
> > +                     test_access_invalid_pmc_regs(&pmc_accessors[i], p=
mc);
> > +     }
> > +
> >       GUEST_DONE();
> >  }
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/=
tools/testing/selftests/kvm/include/aarch64/processor.h
> > index cb537253a6b9..c42d683102c7 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -104,6 +104,7 @@ enum {
> >  #define ESR_EC_SHIFT         26
> >  #define ESR_EC_MASK          (ESR_EC_NUM - 1)
> >
> > +#define ESR_EC_UNKNOWN               0x0
> >  #define ESR_EC_SVC64         0x15
> >  #define ESR_EC_IABT          0x21
> >  #define ESR_EC_DABT          0x25
>
> Thanks
>
> Eric
>
Thanks for the comments, Eric. I'll fix these.

- Raghavendra
