Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E8417CD
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 03:04:48 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id d8so1042969pjc.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Jan 2023 19:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rX+3/YzlCSm7ruJGdTlZSlcuESHe3r7TiuJbPDt7GvE=;
        b=H16mjPJg1xVUiHOtw5dcvB5G3fyc+SUjsmvm4QGOiLJP7sn8hkhbjvoJAHlZf3rjdR
         VVz5sHVT/hYMSd5iLhA9yHPN7f57eyN2Z1zT4Z9y5uw1A6aakhXXsGN8oshBLDqDGB9m
         KqfbRL78BbhnRJjA/irzKdUiqlES+hR3+ssKFhT0zw+G5jUXnC9TflCBa8cf54L2VHgr
         XABCQ02fbtUDZwrpYyU8Ju0ww/62Ofgy2XfaF1xgQteu+1WuFZetc04pM8/uopohxIFm
         ImKv98W/OPewNjNEBMzU+y8x34xEvUZuL0jhp6RojlJLYQ8C24BBcEcmyR25ajWhEA6H
         kTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rX+3/YzlCSm7ruJGdTlZSlcuESHe3r7TiuJbPDt7GvE=;
        b=BRL54DlpD+mVu9R8BYl0fr0m4GuDNyc6YIHmfxBqCYmMzTSw1HaMVieipA2RKSMeAr
         UbNwRCQDO/rwIChhD6w94Pxzdp5x8dcuOPBMZ9W2jwzC6vWMg0LPVmttvQiIuX05Ffrv
         LHsWK6xB+t0j8+DFUSRaEf8/Ylqm5gHwadToE0vbRF8fOuOwGmNbX4+FGGrjUIN1+6ja
         3CUZTG0GxXE+CabmCTDGTShuwg33PjkMC07rK7XnX+wu6ONqw5TdW55sV57u85jlIo5e
         EG+HgQE5F23gOKFIhOJtvhWhZLkEJPzcrP+5NX+OeVi03sP9TOEZIDnJx4XSIiASDy3L
         Mwlw==
X-Gm-Message-State: AFqh2kpLQX9zmFzcjCmKpn2rFJsunm7ipSeYXt/4CxwMsB7jKl7TJyfz
	GUynkamThBeDvG3xo5t8Rie4ZXGJtfudmhuG1kWoaw==
X-Google-Smtp-Source: AMrXdXs5OUY2CpNa5luMCgP2m4HvXWecfbxTnXU9nEeW8X+DJPVfnzRgojJlMGgJR0YYgLrpbhxuu1aMyRlCbyHNPuA=
X-Received: by 2002:a17:902:d1d2:b0:189:8ea3:7455 with SMTP id
 g18-20020a170902d1d200b001898ea37455mr824193plb.19.1674097488118; Wed, 18 Jan
 2023 19:04:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com> <20230117013542.371944-9-reijiw@google.com>
 <acf66ec9-9de2-7d87-c237-ade895c2bb72@redhat.com>
In-Reply-To: <acf66ec9-9de2-7d87-c237-ade895c2bb72@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 18 Jan 2023 19:04:31 -0800
Message-ID: <CAAeT=FxBuzpuQYeaKAOWEJhabFR4DUc2OFoe25kj80cB0Ka+QA@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Shaoqin,

On Tue, Jan 17, 2023 at 11:50 PM Shaoqin Huang <shahuang@redhat.com> wrote:
>
> Hi Reiji,
>
> On 1/17/23 09:35, Reiji Watanabe wrote:
> > Add a new test case to the vpmu_counter_access test to check
> > if PMU registers or their bits for unimplemented counters are not
> > accessible or are RAZ, as expected.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >   .../kvm/aarch64/vpmu_counter_access.c         | 103 +++++++++++++++++-
> >   .../selftests/kvm/include/aarch64/processor.h |   1 +
> >   2 files changed, 98 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > index 54b69c76c824..a7e34d63808b 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > @@ -5,8 +5,8 @@
> >    * Copyright (c) 2022 Google LLC.
> >    *
> >    * This test checks if the guest can see the same number of the PMU event
> > - * counters (PMCR_EL1.N) that userspace sets, and if the guest can access
> > - * those counters.
> > + * counters (PMCR_EL1.N) that userspace sets, if the guest can access
> > + * those counters, and if the guest cannot access any other counters.
> >    * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
> >    */
> >   #include <kvm_util.h>
> > @@ -179,6 +179,51 @@ struct pmc_accessor pmc_accessors[] = {
> >       { read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
> >   };
> >
> > +#define INVALID_EC   (-1ul)
> > +uint64_t expected_ec = INVALID_EC;
> > +uint64_t op_end_addr;
> > +
> > +static void guest_sync_handler(struct ex_regs *regs)
> > +{
> > +     uint64_t esr, ec;
> > +
> > +     esr = read_sysreg(esr_el1);
> > +     ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> > +     GUEST_ASSERT_4(op_end_addr && (expected_ec == ec),
> > +                    regs->pc, esr, ec, expected_ec);
> > +
> > +     /* Will go back to op_end_addr after the handler exits */
> > +     regs->pc = op_end_addr;
> > +
> > +     /*
> > +      * Clear op_end_addr, and setting expected_ec to INVALID_EC
> > +      * as a sign that an exception has occurred.
> > +      */
> > +     op_end_addr = 0;
> > +     expected_ec = INVALID_EC;
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
> > +     GUEST_ASSERT(ec != INVALID_EC);                 \
> > +     WRITE_ONCE(expected_ec, ec);                    \
> > +     dsb(ish);                                       \
> > +     ops;                                            \
> > +     asm volatile(#done_label":");                   \
> > +     GUEST_ASSERT(!op_end_addr);                     \
> > +     GUEST_ASSERT(expected_ec == INVALID_EC);        \
> > +}
> > +
> >   static void pmu_disable_reset(void)
> >   {
> >       uint64_t pmcr = read_sysreg(pmcr_el0);
> > @@ -352,16 +397,38 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
> >                      pmc_idx, acc, read_data, read_data_prev);
> >   }
> >
> > +/*
> > + * Tests for reading/writing registers for the unimplemented event counter
> > + * specified by @pmc_idx (>= PMCR_EL1.N).
> > + */
> > +static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
> > +{
> > +     /*
> > +      * Reading/writing the event count/type registers should cause
> > +      * an UNDEFINED exception.
> > +      */
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx), inv_rd_cntr);
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0), inv_wr_cntr);
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx), inv_rd_typer);
> > +     TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0), inv_wr_typer);
> > +     /*
> > +      * The bit corresponding to the (unimplemented) counter in
> > +      * {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers should be RAZ.
> > +      */
> > +     test_bitmap_pmu_regs(pmc_idx, 1);
> > +     test_bitmap_pmu_regs(pmc_idx, 0);
> > +}
> > +
> >   /*
> >    * The guest is configured with PMUv3 with @expected_pmcr_n number of
> >    * event counters.
> >    * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> > - * if reading/writing PMU registers for implemented counters can work
> > - * as expected.
> > + * if reading/writing PMU registers for implemented or unimplemented
> > + * counters can work as expected.
> >    */
> >   static void guest_code(uint64_t expected_pmcr_n)
> >   {
> > -     uint64_t pmcr, pmcr_n;
> > +     uint64_t pmcr, pmcr_n, unimp_mask;
> >       int i, pmc;
> >
> >       GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
> > @@ -372,6 +439,14 @@ static void guest_code(uint64_t expected_pmcr_n)
> >       /* Make sure that PMCR_EL0.N indicates the value userspace set */
> >       GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
> >
> > +     /*
> > +      * Make sure that (RAZ) bits corresponding to unimplemented event
> > +      * counters in {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers are reset to zero.
> > +      * (NOTE: bits for implemented event counters are reset to UNKNOWN)
> > +      */
> > +     unimp_mask = GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pmcr_n);
> > +     check_bitmap_pmu_regs(unimp_mask, false);
> > +
> >       /*
> >        * Tests for reading/writing PMU registers for implemented counters.
> >        * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
> > @@ -381,6 +456,14 @@ static void guest_code(uint64_t expected_pmcr_n)
> >                       test_access_pmc_regs(&pmc_accessors[i], pmc);
> >       }
> >
> > +     /*
> > +      * Tests for reading/writing PMU registers for unimplemented counters.
> > +      * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
> Here should be PMEV{CNTR, TYPER}<n>.

Thank you for catching this. I will fix this.

Thank you,
Reiji
