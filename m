Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFEBC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 11:14:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA85C4C831;
	Tue, 19 Jul 2022 07:14:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mfq-AKL0832f; Tue, 19 Jul 2022 07:14:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6113A4C8B7;
	Tue, 19 Jul 2022 07:14:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 280BF4C831
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 07:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rH5VhLHrTe45 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 07:14:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89ED44C80F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 07:14:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD2F51424;
 Tue, 19 Jul 2022 04:14:05 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0168F3F766;
 Tue, 19 Jul 2022 04:14:03 -0700 (PDT)
Date: Tue, 19 Jul 2022 12:14:37 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after
 sys register writing
Message-ID: <YtaSDhj2SXEzh8QI@monolith.localdoman>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220718154910.3923412-2-ricarkol@google.com>
Cc: drjones@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu
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

Hi,

Since you're touching the PMU tests, I took the liberty to suggest changes
somewhat related to this patch. If you don't want to implement them, let me
know and I'll try to make a patch/series out of them.

On Mon, Jul 18, 2022 at 08:49:08AM -0700, Ricardo Koller wrote:
> There are various pmu tests that require an isb() between enabling
> counting and the actual counting. This can lead to count registers
> reporting less events than expected; the actual enabling happens after
> some events have happened.  For example, some missing isb()'s in the
> pmu-sw-incr test lead to the following errors on bare-metal:
> 
> 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
>         PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
>         FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
>         FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
>         INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
>         PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
>         SUMMARY: 4 tests, 2 unexpected failures
> 
> Add the missing isb()'s on all failing tests, plus some others that are
> not currently required but might in the future (like an isb() after
> clearing the overflow signal in the IRQ handler).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 15c542a2..fd838392 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -307,6 +307,7 @@ static void irq_handler(struct pt_regs *regs)
>  			}
>  		}
>  		write_sysreg(ALL_SET, pmovsclr_el0);
> +		isb();
>  	} else {
>  		pmu_stats.unexpected = true;
>  	}
> @@ -534,6 +535,7 @@ static void test_sw_incr(void)
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	isb();
>  
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x1, pmswinc_el0);
> @@ -547,6 +549,7 @@ static void test_sw_incr(void)
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	isb();
>  
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x3, pmswinc_el0);
> @@ -618,6 +621,8 @@ static void test_chained_sw_incr(void)
>  
>  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	isb();
> +
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x1, pmswinc_el0);
>  
> @@ -634,6 +639,8 @@ static void test_chained_sw_incr(void)
>  	write_regn_el0(pmevcntr, 1, ALL_SET);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	isb();
> +
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x1, pmswinc_el0);
>  
> @@ -821,6 +828,8 @@ static void test_overflow_interrupt(void)
>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>  
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	isb();
> +
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x2, pmswinc_el0);

You missed the set_pmcr(pmu.pmcr_ro) call on the next line.

Also the comment "enable interrupts" below:

[..]
        report(expect_interrupts(0), "no overflow interrupt after preset");

        set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
        for (i = 0; i < 100; i++)
                write_sysreg(0x2, pmswinc_el0);

        set_pmcr(pmu.pmcr_ro);
        report(expect_interrupts(0), "no overflow interrupt after counting");

        /* enable interrupts */

        pmu_reset_stats();
[..]

is misleading, because pmu_reset_stats() doesn't enable the PMU. Unless the
intention was to call pmu_reset(), in which case the comment is correct and
the code is wrong. My guess is that the comment is incorrect, the test
seems to be working fine when the PMU is enabled in the mem_access_loop()
call.

>  
> @@ -879,6 +888,7 @@ static bool check_cycles_increase(void)
>  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>  
>  	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
> +	isb();
>  
>  	for (int i = 0; i < NR_SAMPLES; i++) {
>  		uint64_t a, b;
> @@ -894,6 +904,7 @@ static bool check_cycles_increase(void)
>  	}
>  
>  	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
> +	isb();

Those look good to me.

Thanks,
Alex

>  
>  	return success;
>  }
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
