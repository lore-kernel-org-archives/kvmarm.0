Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C980162F
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 05:57:02 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso22531211pjt.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 21:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FccKUfbHyylDDoPjn7qZyrSP0H0soQqxoVXZoIBm/II=;
        b=CwSk/D/LJm0WdN/2/A/0NIkigAlM5tSw4X4uoxtnodtBoRqVjrnJ5JFyzHM0jDa2lt
         z1SEeB1/qTeMHDv4pO8I2Xu8vLVdCbyYtufeZU8oefg8KP2LtDSna7+7DRHS5ir0zhmC
         F1Ks1iqJJKC0KJ87JIrCJbICYdbKtRqEQVjB3g/GrLTDWJh+gtiD1py/X0ouEJtoXFE+
         Y4DKfcZYwK+FKW4ArQomr0undnrxxUKp8o4tqe08e0qTpK/AmVnaIH2vz6hH4dSm6fFr
         2SbdtCpYQqleult/37UdGDUs4MAJ9l4qfk008AbqxeNANgMAyTxKlRK2rji3YDAFQbkM
         ZJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FccKUfbHyylDDoPjn7qZyrSP0H0soQqxoVXZoIBm/II=;
        b=k99FTbzh700o10x0ohG81QODr6GB1kBuR1/xq1siIQB8DfRVdkj4DxA/FplNY1e7nr
         ksPLpvI03O2mRaKkBSoDLflJvtaTR7a1DgC8kcHLtiJG+h6bg2RmU7JsJvLNVSeqxnsW
         wknXJm7J4RP/vC8zzMGu98aTXKVf8n1aV2fS3lIHW3tZHXyBTf3HLjAoD+NewLqeQcBF
         oKnMCaALOj5TRGSgEV4OwwCHbPNSqDl+V6UITpNy67S+yc5UFldZXiQU1T8u2NK763RU
         CKQU9wmbxZW3NJZpi1I8+o8eCQ6eFfL4Y9Ha8bIzoIvnE7sKCfoz6QRfRHdS+UZpCkFG
         T9Yw==
X-Gm-Message-State: AFqh2koI723Z4MLQBIwwIhj28PXn204DvPO2kS8CCUjnDGmnG/n5Y2RW
	jZsIV0UQdsJ0fmSSm3sfx3qwfhyaAcI/62XDxLyDSA==
X-Google-Smtp-Source: AMrXdXu5en3bHy4+sUUjgbsYsBC/X8naWSSFyF6Sd/zJH1PscFq+D0rEAEwSVGJ5hUHrEQBC2IyH7pEhHZwGABFc984=
X-Received: by 2002:a17:902:bf07:b0:194:5c63:363b with SMTP id
 bi7-20020a170902bf0700b001945c63363bmr144776plb.154.1673503021915; Wed, 11
 Jan 2023 21:57:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com> <20230109211754.67144-3-ricarkol@google.com>
In-Reply-To: <20230109211754.67144-3-ricarkol@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 11 Jan 2023 21:56:45 -0800
Message-ID: <CAAeT=Fz1PHytw2rhn7pxbr1aFuvWLTJGnr9vidUqNt=tCKpvuw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/4] arm: pmu: Prepare for testing
 64-bit overflows
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev, 
	maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Ricardo,

On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> PMUv3p5 adds a knob, PMCR_EL0.LP == 1, that allows overflowing at 64-bits
> instead of 32. Prepare by doing these 3 things:
>
> 1. Add a "bool overflow_at_64bits" argument to all tests checking
>    overflows.
> 2. Extend satisfy_prerequisites() to check if the machine supports
>    "overflow_at_64bits".
> 3. Refactor the test invocations to use the new "run_test()" which adds a
>    report prefix indicating whether the test uses 64 or 32-bit overflows.
>
> A subsequent commit will actually add the 64-bit overflow tests.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 92 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 53 insertions(+), 39 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 7f0794d..0d06b59 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -164,13 +164,13 @@ static void pmu_reset(void)
>  /* event counter tests only implemented for aarch64 */
>  static void test_event_introspection(void) {}
>  static void test_event_counter_config(void) {}
> -static void test_basic_event_count(void) {}
> -static void test_mem_access(void) {}
> -static void test_sw_incr(void) {}
> -static void test_chained_counters(void) {}
> -static void test_chained_sw_incr(void) {}
> -static void test_chain_promotion(void) {}
> -static void test_overflow_interrupt(void) {}
> +static void test_basic_event_count(bool overflow_at_64bits) {}
> +static void test_mem_access(bool overflow_at_64bits) {}
> +static void test_sw_incr(bool overflow_at_64bits) {}
> +static void test_chained_counters(bool unused) {}
> +static void test_chained_sw_incr(bool unused) {}
> +static void test_chain_promotion(bool unused) {}
> +static void test_overflow_interrupt(bool overflow_at_64bits) {}
>
>  #elif defined(__aarch64__)
>  #define ID_AA64DFR0_PERFMON_SHIFT 8
> @@ -416,6 +416,7 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
>                         return false;
>                 }
>         }
> +

Nit: Unnecessary addition of the line.

>         return true;
>  }
>
> @@ -435,13 +436,24 @@ static uint64_t pmevcntr_mask(void)
>         return (uint32_t)~0;
>  }
>
> -static void test_basic_event_count(void)
> +static bool check_overflow_prerequisites(bool overflow_at_64bits)
> +{
> +       if (overflow_at_64bits && pmu.version < ID_DFR0_PMU_V3_8_5) {
> +               report_skip("Skip test as 64 overflows need FEAT_PMUv3p5");
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
> +static void test_basic_event_count(bool overflow_at_64bits)
>  {
>         uint32_t implemented_counter_mask, non_implemented_counter_mask;
>         uint32_t counter_mask;
>         uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
>
> -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +           !check_overflow_prerequisites(overflow_at_64bits))
>                 return;
>
>         implemented_counter_mask = BIT(pmu.nb_implemented_counters) - 1;
> @@ -515,12 +527,13 @@ static void test_basic_event_count(void)
>                 "check overflow happened on #0 only");
>  }
>
> -static void test_mem_access(void)
> +static void test_mem_access(bool overflow_at_64bits)
>  {
>         void *addr = malloc(PAGE_SIZE);
>         uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
>
> -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +           !check_overflow_prerequisites(overflow_at_64bits))
>                 return;
>
>         pmu_reset();
> @@ -551,13 +564,14 @@ static void test_mem_access(void)
>                         read_sysreg(pmovsclr_el0));
>  }
>
> -static void test_sw_incr(void)
> +static void test_sw_incr(bool overflow_at_64bits)
>  {
>         uint32_t events[] = {SW_INCR, SW_INCR};
>         uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
>         int i;
>
> -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +           !check_overflow_prerequisites(overflow_at_64bits))
>                 return;
>
>         pmu_reset();
> @@ -597,7 +611,7 @@ static void test_sw_incr(void)
>                 "overflow on counter #0 after 100 SW_INCR");
>  }
>
> -static void test_chained_counters(void)
> +static void test_chained_counters(bool unused)
>  {
>         uint32_t events[] = {CPU_CYCLES, CHAIN};
>
> @@ -638,7 +652,7 @@ static void test_chained_counters(void)
>         report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>
> -static void test_chained_sw_incr(void)
> +static void test_chained_sw_incr(bool unused)
>  {
>         uint32_t events[] = {SW_INCR, CHAIN};
>         uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> @@ -691,7 +705,7 @@ static void test_chained_sw_incr(void)
>                     read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
>  }
>
> -static void test_chain_promotion(void)
> +static void test_chain_promotion(bool unused)
>  {
>         uint32_t events[] = {MEM_ACCESS, CHAIN};
>         void *addr = malloc(PAGE_SIZE);
> @@ -840,13 +854,14 @@ static bool expect_interrupts(uint32_t bitmap)
>         return true;
>  }
>
> -static void test_overflow_interrupt(void)
> +static void test_overflow_interrupt(bool overflow_at_64bits)
>  {
>         uint32_t events[] = {MEM_ACCESS, SW_INCR};
>         void *addr = malloc(PAGE_SIZE);
>         int i;
>
> -       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +       if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +           !check_overflow_prerequisites(overflow_at_64bits))
>                 return;
>
>         gic_enable_defaults();
> @@ -1070,6 +1085,19 @@ static bool pmu_probe(void)
>         return true;
>  }
>
> +static void run_test(char *name, void (*test)(bool), bool overflow_at_64bits)
> +{
> +       const char *prefix = overflow_at_64bits ? "64-bit overflows" : "32-bit overflows";
> +
> +       report_prefix_push(name);
> +       report_prefix_push(prefix);
> +
> +       test(overflow_at_64bits);
> +
> +       report_prefix_pop();
> +       report_prefix_pop();
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         int cpi = 0;
> @@ -1102,33 +1130,19 @@ int main(int argc, char *argv[])
>                 test_event_counter_config();
>                 report_prefix_pop();
>         } else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> -               report_prefix_push(argv[1]);
> -               test_basic_event_count();
> -               report_prefix_pop();
> +               run_test(argv[1], test_basic_event_count, false);
>         } else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> -               report_prefix_push(argv[1]);
> -               test_mem_access();
> -               report_prefix_pop();
> +               run_test(argv[1], test_mem_access, false);
>         } else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> -               report_prefix_push(argv[1]);
> -               test_sw_incr();
> -               report_prefix_pop();
> +               run_test(argv[1], test_sw_incr, false);
>         } else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> -               report_prefix_push(argv[1]);
> -               test_chained_counters();
> -               report_prefix_pop();
> +               run_test(argv[1], test_chained_counters, false);
>         } else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> -               report_prefix_push(argv[1]);
> -               test_chained_sw_incr();
> -               report_prefix_pop();
> +               run_test(argv[1], test_chained_sw_incr, false);
>         } else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
> -               report_prefix_push(argv[1]);
> -               test_chain_promotion();
> -               report_prefix_pop();
> +               run_test(argv[1], test_chain_promotion, false);
>         } else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> -               report_prefix_push(argv[1]);
> -               test_overflow_interrupt();
> -               report_prefix_pop();
> +               run_test(argv[1], test_overflow_interrupt, false);
>         } else {
>                 report_abort("Unknown sub-test '%s'", argv[1]);
>         }

Perhaps it might be useful to generalize run_test() a bit more so that it
can be used for other existing test cases as well ?
(e.g. "pmu-event-counter-config", etc)
---
i.e (The following are not all of the changes though).

-static void run_test(char *name, void (*test)(bool), bool overflow_at_64bits)
+static void run_test(const char *name, const char *prefix, void
(*test)(bool), void *arg)
 {
-       const char *prefix = overflow_at_64bits ? "64-bit overflows" :
"32-bit overflows";
-
        report_prefix_push(name);
        report_prefix_push(prefix);

-       test(overflow_at_64bits);
+       test(arg);

        report_prefix_pop();
        report_prefix_pop();
 }

+static void run_event_test(char *name, void (*test)(bool), bool
overflow_at_64bits)
+{
+       const char *prefix = overflow_at_64bits ? "64-bit overflows" :
"32-bit overflows";
+
+       run_test(name, prefix, test, (void *)overflow_at_64bits);
+}
---

Having said that, the patch already improves the code,
and I don't see any issue.

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji
