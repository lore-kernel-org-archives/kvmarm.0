Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445F762B
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 03:40:41 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so962542pjg.4
        for <kvmarm@lists.linux.dev>; Tue, 07 Mar 2023 19:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678246840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QLUpNRb1Q5SbO5b6ljTZoN5cFP88001T4PHHJDtnPIY=;
        b=hvgQDq9Hx7UZ+T+wnEN/YAB03nl+H2YawT6rsZIgLQWs/jTvHj7wOlBe+kV/zOxTLL
         jftAH82U93x6DI+yV8EgM3dVqSXPKAGh1/9x69jebUA0lWdAnViH05CqLjCm6e8jI9ul
         1B08YMiyJD8CvQUNYYX8zwFzs1KEv+llJ4nK/MUMXD/uTmb7+aFpaklcGWHFjtu3ziNM
         mi2c3+ctKR2GWRPPW5dfzdAUxBQRRrndJ323cI0NoodTewkP3wPyq2jbrQPkQlMUsxha
         1cSROQvN3Od1hHzlhzQCvAJbsfgCvPuxMal2DfwqxAEhfXGkMNuqXGv/+hsxkFQWAUOS
         GuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678246840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLUpNRb1Q5SbO5b6ljTZoN5cFP88001T4PHHJDtnPIY=;
        b=W8X6UjUp6Bi8wK8fSZEruwaX3659Cd8/EwQK4VtR7XI9XCSxm1v+7+R8FF2t5Gw27q
         uE8sOgwk0gqd+b3FyipyO7cjypItNFECeJ70+fxMWtZM5GL3hkyE7EDKXn7pppBMy5rL
         tyPCDRWU2YNXZifriaLAUX1b+vLBOy1lIv+QI0gD8IauVF6sCjuLVq9ZAUzjQPzJlpFd
         iQyUIVzOg8/VJqTTSaPJIqUp76u5VAkCLGJummPt1GJc5NIN03Cg0N2P/KUp1SZaD7Y/
         f1K91X2TFx45P7nF3VWYTm9e7UVhum+1J56cv+DKavcxWC+r+L3yPFmRscFrrxdZwvL5
         2hKQ==
X-Gm-Message-State: AO0yUKVJIMII7Qwa3Hbqezf9XmzR4DSiKYHV3GAbH0KO/OEY6xRzeQVe
	9CqTxYoh3vZmDlgHjQt3v1paqdhivfkKjkiWr0hSLQ==
X-Google-Smtp-Source: AK7set951PHcH/hh6Gt6p7PVv5UViZaBErCzXeuETNU4JXbZ9TJrRbhpRClK0T35JNChyp0zlzlZSL+kUVqQoNAFMXA=
X-Received: by 2002:a17:90a:f10b:b0:23a:6ed6:7817 with SMTP id
 cc11-20020a17090af10b00b0023a6ed67817mr6298116pjb.5.1678246840511; Tue, 07
 Mar 2023 19:40:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-15-rananta@google.com>
In-Reply-To: <20230215010717.3612794-15-rananta@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 7 Mar 2023 19:40:24 -0800
Message-ID: <CAAeT=Fyu6eoYX=1U1aXr5qrXSPmQdswcrE+Dz12SLK7R-1XDAQ@mail.gmail.com>
Subject: Re: [REPOST PATCH 14/16] selftests: KVM: aarch64: Add PMU test to
 chain all the counters
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Raghu,

On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Extend the vCPU migration test to occupy all the vPMU counters,
> by configuring chained events on alternate counter-ids and chaining
> them with its corresponding predecessor counter, and verify against
> the extended behavior.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index de725f4339ad5..fd00acb9391c8 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -710,6 +710,63 @@ static void test_chained_count(int pmc_idx)
>         pmu_irq_exit(chained_pmc_idx);
>  }
>
> +static void test_chain_all_counters(void)
> +{
> +       int i;
> +       uint64_t cnt, pmcr_n =3D get_pmcr_n();
> +       struct pmc_accessor *acc =3D &pmc_accessors[0];

How do you decide whether to test with all accessors ?
Perhaps, it might be simpler and more consistent if we implement each
test case with one specified accessor as an argument, and run those
test with each accessors?


> +
> +       /*
> +        * Test the occupancy of all the event counters, by chaining the
> +        * alternate counters. The test assumes that the host hasn't
> +        * occupied any counters. Hence, if the test fails, it could be
> +        * because all the counters weren't available to the guest or
> +        * there's actually a bug in KVM.
> +        */
> +
> +       /*
> +        * Configure even numbered counters to count cpu-cycles, and chai=
n
> +        * each of them with its odd numbered counter.
> +        */

You might want to use the cycle counter as well ?

Thank you,
Reiji

> +       for (i =3D 0; i < pmcr_n; i++) {
> +               if (i % 2) {
> +                       acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CHAIN);
> +                       acc->write_cntr(i, 1);
> +               } else {
> +                       pmu_irq_init(i);
> +                       acc->write_cntr(i, PRE_OVERFLOW_32);
> +                       acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CPU_CYCLE=
S);
> +               }
> +               enable_counter(i);
> +       }
> +
> +       /* Introduce some cycles */
> +       execute_precise_instrs(500, ARMV8_PMU_PMCR_E);
> +
> +       /*
> +        * An overflow interrupt should've arrived for all the even numbe=
red
> +        * counters but none for the odd numbered ones. The odd numbered =
ones
> +        * should've incremented exactly by 1.
> +        */
> +       for (i =3D 0; i < pmcr_n; i++) {
> +               if (i % 2) {
> +                       GUEST_ASSERT_1(!pmu_irq_received(i), i);
> +
> +                       cnt =3D acc->read_cntr(i);
> +                       GUEST_ASSERT_2(cnt =3D=3D 2, i, cnt);
> +               } else {
> +                       GUEST_ASSERT_1(pmu_irq_received(i), i);
> +               }
> +       }
> +
> +       /* Cleanup the states */
> +       for (i =3D 0; i < pmcr_n; i++) {
> +               if (i % 2 =3D=3D 0)
> +                       pmu_irq_exit(i);
> +               disable_counter(i);
> +       }
> +}
> +
>  static void test_event_count(uint64_t event, int pmc_idx, bool expect_co=
unt)
>  {
>         switch (event) {
> @@ -739,6 +796,9 @@ static void test_basic_pmu_functionality(void)
>
>         /* Test chained events */
>         test_chained_count(0);
> +
> +       /* Test running chained events on all the implemented counters */
> +       test_chain_all_counters();
>  }
>
>  /*
> --
> 2.39.1.581.gbfd45094c4-goog
>
