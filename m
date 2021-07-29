Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7C5C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 16:58:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD86460F43
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 16:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD86460F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D4C49F6C;
	Thu, 29 Jul 2021 12:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id flR0luI5+OiH; Thu, 29 Jul 2021 12:58:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A284B085;
	Thu, 29 Jul 2021 12:58:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 278A149F6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id snv294mZaSP2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 12:58:04 -0400 (EDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A383B40870
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:58:04 -0400 (EDT)
Received: by mail-lf1-f54.google.com with SMTP id bp1so12321515lfb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RuKdXCPYlWX4+A/HZDs8yt3O1yAwkaBJb4F4xsD/8VI=;
 b=W1QHQIAI6j8iZpNF5J2zbLBrdgNAVEibOQfQGg6YmmpnnUfiNNJjSnFLGuPJ/MF/w1
 d9NNDjDXHOCfeImEFP6RT/imXsIUqBAKHfemLAJj7t5qy1bUR4YIRmQYJmj3V0sKoHM0
 eBr3NwZG8L7ZXGQcjqyj2bdPMRIbkixLqrYqI/UhUDV9Rv8ezpn+jY5tWx5CtwkU1YaC
 USIyrvbeovIOPUecvAr1Es9lamqQA3odGfq4VwcQalKUueAY8F4eYHc5TQURhtj0A5GQ
 Nu0QWHmw1Hdk7WBsoTQHaxGDtuqpXlGI/AJ9u+o6xmQ8WJIqHgaYEhBsN09pG3fR8Mzz
 4mQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RuKdXCPYlWX4+A/HZDs8yt3O1yAwkaBJb4F4xsD/8VI=;
 b=sxiz9ZK2DEalHBfUDTc2FNSyzB+bBuTRYgzcee0yMWNRX6OpZpJ4g7jcINyhGVbzwL
 KWv6GL4rImCUI84NhpkzanbhznZ1RDu84xHG1xq+wNeDiFTwanqcK2J1REBx6U8QtUO3
 Pw66PsNxzJIcBA5+DCFSJnFFGdiWeqFS16r126iTLEfL7YR6JtkynQSthdjTjBrRmXRh
 SYOqgczDFOXhk7s6YsuJAR1g43Eed0kYywxQw58ZkQMcQaHXGqGrOY0Ns1cDD5xeduHB
 PR7ciKB1Khuza0rdwH49iSwoNY9IZLqNFfK4+ghA9xk/5NAAU1Mme055q7AplwtErBmG
 qx1g==
X-Gm-Message-State: AOAM5337nxqOYC7UXT2MFHI5JWZWrSZdm6k/G5aJQYu0z2P9bYaVSh1q
 Qj1U7/2yNrESBlI6ZsZB94Iq2oyFCnepcslA47jkkw==
X-Google-Smtp-Source: ABdhPJxibSl2j3YgGswhjM6VTWxm+qN7LgcfLGRL52354vQvopUp+HxRIZNQsPM+tsbuW64EZ9XR1cmRwVOq0L2cPYs=
X-Received: by 2002:a05:6512:3237:: with SMTP id
 f23mr4344159lfe.524.1627577882651; 
 Thu, 29 Jul 2021 09:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-14-oupton@google.com>
 <20210729165556.pce7dzy3ovltycxx@gator>
In-Reply-To: <20210729165556.pce7dzy3ovltycxx@gator>
From: Oliver Upton <oupton@google.com>
Date: Thu, 29 Jul 2021 09:57:51 -0700
Message-ID: <CAOQ_Qsib65YjLQD3ta3e_ttriOZ026h-A+k+=shbTaSNbgQ_jg@mail.gmail.com>
Subject: Re: [PATCH v4 13/13] selftests: KVM: Add counter emulation benchmark
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Thu, Jul 29, 2021 at 9:56 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Jul 29, 2021 at 12:10:12AM +0000, Oliver Upton wrote:
> > Add a test case for counter emulation on arm64. A side effect of how KVM
> > handles physical counter offsetting on non-ECV systems is that the
> > virtual counter will always hit hardware and the physical could be
> > emulated. Force emulation by writing a nonzero offset to the physical
> > counter and compare the elapsed cycles to a direct read of the hardware
> > register.
> >
> > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../kvm/aarch64/counter_emulation_benchmark.c | 215 ++++++++++++++++++
> >  3 files changed, 217 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> >
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 3d2585f0bffc..a23198ea6e7a 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -1,5 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  /aarch64/debug-exceptions
> > +/aarch64/counter_emulation_benchmark
> >  /aarch64/get-reg-list
> >  /aarch64/vgic_init
> >  /s390x/memop
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index fab42e7c23ee..db8706eb6104 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -88,6 +88,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
> >
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> > +TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> >  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
> >  TEST_GEN_PROGS_aarch64 += demand_paging_test
> > diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> > new file mode 100644
> > index 000000000000..73aeb6cdebfe
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> > @@ -0,0 +1,215 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * counter_emulation_benchmark.c -- test to measure the effects of counter
> > + * emulation on guest reads of the physical counter.
> > + *
> > + * Copyright (c) 2021, Google LLC.
> > + */
> > +
> > +#define _GNU_SOURCE
> > +#include <asm/kvm.h>
> > +#include <linux/kvm.h>
> > +#include <stdio.h>
> > +#include <stdint.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "test_util.h"
> > +
> > +#define VCPU_ID 0
> > +
> > +static struct counter_values {
> > +     uint64_t cntvct_start;
> > +     uint64_t cntpct;
> > +     uint64_t cntvct_end;
> > +} counter_values;
> > +
> > +static uint64_t nr_iterations = 1000;
> > +
> > +static void do_test(void)
> > +{
> > +     /*
> > +      * Open-coded approach instead of using helper methods to keep a tight
> > +      * interval around the physical counter read.
> > +      */
> > +     asm volatile("isb\n\t"
> > +                  "mrs %[cntvct_start], cntvct_el0\n\t"
> > +                  "isb\n\t"
> > +                  "mrs %[cntpct], cntpct_el0\n\t"
> > +                  "isb\n\t"
> > +                  "mrs %[cntvct_end], cntvct_el0\n\t"
> > +                  "isb\n\t"
> > +                  : [cntvct_start] "=r"(counter_values.cntvct_start),
> > +                  [cntpct] "=r"(counter_values.cntpct),
> > +                  [cntvct_end] "=r"(counter_values.cntvct_end));
> > +}
> > +
> > +static void guest_main(void)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < nr_iterations; i++) {
> > +             do_test();
> > +             GUEST_SYNC(i);
> > +     }
> > +
> > +     for (i = 0; i < nr_iterations; i++) {
> > +             do_test();
> > +             GUEST_SYNC(i);
> > +     }
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static bool enter_guest(struct kvm_vm *vm)
> > +{
> > +     struct ucall uc;
> > +
> > +     vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
> > +
> > +     switch (get_ucall(vm, VCPU_ID, &uc)) {
> > +     case UCALL_DONE:
> > +             return true;
> > +     case UCALL_SYNC:
> > +             break;
> > +     case UCALL_ABORT:
> > +             TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
> > +                         __FILE__, uc.args[1]);
> > +             break;
> > +     default:
> > +             TEST_ASSERT(false, "unexpected exit: %s",
> > +                         exit_reason_str(vcpu_state(vm, VCPU_ID)->exit_reason));
> > +             break;
> > +     }
> > +
> > +     /* more work to do in the guest */
> > +     return false;
> > +}
> > +
> > +static double counter_frequency(void)
> > +{
> > +     uint32_t freq;
> > +
> > +     asm volatile("mrs %0, cntfrq_el0"
> > +                  : "=r" (freq));
> > +
> > +     return freq / 1000000.0;
> > +}
> > +
> > +static void log_csv(FILE *csv, bool trapped)
> > +{
> > +     double freq = counter_frequency();
> > +
> > +     fprintf(csv, "%s,%.02f,%lu,%lu,%lu\n",
> > +             trapped ? "true" : "false", freq,
> > +             counter_values.cntvct_start,
> > +             counter_values.cntpct,
> > +             counter_values.cntvct_end);
> > +}
> > +
> > +static double run_loop(struct kvm_vm *vm, FILE *csv, bool trapped)
> > +{
> > +     double avg = 0;
> > +     int i;
> > +
> > +     for (i = 0; i < nr_iterations; i++) {
> > +             uint64_t delta;
> > +
> > +             TEST_ASSERT(!enter_guest(vm), "guest exited unexpectedly");
> > +             sync_global_from_guest(vm, counter_values);
> > +
> > +             if (csv)
> > +                     log_csv(csv, trapped);
> > +
> > +             delta = counter_values.cntvct_end - counter_values.cntvct_start;
> > +             avg = ((avg * i) + delta) / (i + 1);
> > +     }
> > +
> > +     return avg;
> > +}
> > +
> > +static void setup_counter(struct kvm_vm *vm, uint64_t offset)
> > +{
> > +     vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> > +                             KVM_ARM_VCPU_TIMER_OFFSET_PTIMER, &offset,
> > +                             true);
> > +}
> > +
> > +static void run_tests(struct kvm_vm *vm, FILE *csv)
> > +{
> > +     double avg_trapped, avg_native, freq;
> > +
> > +     freq = counter_frequency();
> > +
> > +     if (csv)
> > +             fputs("trapped,freq_mhz,cntvct_start,cntpct,cntvct_end\n", csv);
> > +
> > +     /* no physical offsetting; kvm allows reads of cntpct_el0 */
> > +     setup_counter(vm, 0);
> > +     avg_native = run_loop(vm, csv, false);
> > +
> > +     /* force emulation of the physical counter */
> > +     setup_counter(vm, 1);
> > +     avg_trapped = run_loop(vm, csv, true);
> > +
> > +     TEST_ASSERT(enter_guest(vm), "guest didn't run to completion");
> > +     pr_info("%lu iterations: average cycles (@%.02fMHz) native: %.02f, trapped: %.02f\n",
> > +             nr_iterations, freq, avg_native, avg_trapped);
> > +}
> > +
> > +static void usage(const char *program_name)
> > +{
> > +     fprintf(stderr,
> > +             "Usage: %s [-h] [-o csv_file] [-n iterations]\n"
> > +             "  -h prints this message\n"
> > +             "  -n number of test iterations (default: %lu)\n"
> > +             "  -o csv file to write data\n",
> > +             program_name, nr_iterations);
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +     struct kvm_vm *vm;
> > +     FILE *csv = NULL;
> > +     int opt;
> > +
> > +     while ((opt = getopt(argc, argv, "hn:o:")) != -1) {
> > +             switch (opt) {
> > +             case 'o':
> > +                     csv = fopen(optarg, "w");
> > +                     if (!csv) {
> > +                             fprintf(stderr, "failed to open file '%s': %d\n",
> > +                                     optarg, errno);
> > +                             exit(1);
> > +                     }
> > +                     break;
> > +             case 'n':
> > +                     nr_iterations = strtoul(optarg, NULL, 0);
> > +                     break;
> > +             default:
> > +                     fprintf(stderr, "unrecognized option: '-%c'\n", opt);
> > +                     /* fallthrough */
> > +             case 'h':
> > +                     usage(argv[0]);
> > +                     exit(1);
> > +             }
> > +     }
> > +
> > +     vm = vm_create_default(VCPU_ID, 0, guest_main);
> > +     sync_global_to_guest(vm, nr_iterations);
> > +     ucall_init(vm, NULL);
> > +
> > +     if (_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> > +                               KVM_ARM_VCPU_TIMER_OFFSET_PTIMER)) {
> > +             print_skip("KVM_ARM_VCPU_TIMER_OFFSET_PTIMER not supported.");
> > +             exit(KSFT_SKIP);
> > +     }
> > +
> > +     run_tests(vm, csv);
> > +     kvm_vm_free(vm);
> > +
> > +     if (csv)
> > +             fclose(csv);
> > +}
> > --
> > 2.32.0.432.gabb21c7263-goog
> >
>
> I skimmed through this, but didn't see any changes from v3 where I had a
> couple comments.

Ah, yes, I missed those comments by accident. Thanks!

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
