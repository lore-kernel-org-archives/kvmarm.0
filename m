Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AB6C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:34:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 853B0611C9
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:34:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 853B0611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D5994B18A;
	Thu,  9 Sep 2021 13:34:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4EPGI-tjxej5; Thu,  9 Sep 2021 13:34:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB4B349F5D;
	Thu,  9 Sep 2021 13:34:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F5C4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:34:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y6biR5kUWTYd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 13:34:00 -0400 (EDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com
 [209.85.219.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C20A40D0A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:34:00 -0400 (EDT)
Received: by mail-yb1-f171.google.com with SMTP id s16so5530666ybe.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 10:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XqHjuGgRhd53kfR40OyBo5y76L66nYApGqlRgV8dib0=;
 b=c/MQu92tH08pfBlQ+f2h+5BTP9O9NOJdrxL4dDNqCWeGgkKgKplmmlr7+I9DTuEB8H
 /xowODEFAVSIiSoEeCSOsxunt7b+8jwcirvdZnvQHGVbG9PrAhz2r/+93/sarxoJLpZV
 0oLQ4pr3iLj7hvWOfLVyIoUn3fkCNk/FUpL+AmzV6vA31ChfwdTTPfThY/Ez9AK+Pv51
 55irTB722ovasyzS80DtzHEte7ifGl50b+ozWSdgbWOz9qtvGPrEZ6QO1aFK90TTsL4f
 4j1R0gYFR8jksjXduAXYZceuQVvV7JVLt4I2JO0juF2EyCulkevz4nonQvUn/GpJvgvg
 zUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XqHjuGgRhd53kfR40OyBo5y76L66nYApGqlRgV8dib0=;
 b=7UWUhYnHxj3TxRw9fHR34k7XuAOo5A0A+vIzUl86tjClW2jP/H5nvQYd8uaZA4Z6XD
 kZvAGSX/9m9TQ0XsAOVSYtCauJgqZRbnvkQcCn7Pmd5ry/2xxm7IxtE2E7g2se4ukVxe
 UUl/ptM2QXlMVeZPJwLJ2iJLunUp5PCVjDQHGJmnE+IAQGxcb1NhMWhrRd+oeBTFmuZj
 w0V4Gq4t+zLa3LXaZzC8k+3IKG5JI/BzjsQsuYaenxczI1JetjC4jsiIQveJwBRp4Vf4
 fqAWnzbThXUaUK1uVvvqp8MI5HVihJv+FqPKI2iJXbuBqY5cjqSdTVqAMSwzcSFa21Vt
 CrIw==
X-Gm-Message-State: AOAM531lH6VAZR3Nyne1TD9aJD9bl4ZZRI5k3pT28ULGWgz6+aqLFX8A
 aP5bQ7vttCUODJC92B5PCQawBts4cZcWKWkoIjVNfQ==
X-Google-Smtp-Source: ABdhPJzDM0my2zsTOKwfUsRrFm3fZu5v6rZyyixD1c3rSO5zAxCR1j0GXOzF7oglZEKoEkqrXgG18A6yuTg+n0twgoU=
X-Received: by 2002:a25:21c5:: with SMTP id h188mr4984145ybh.23.1631208839114; 
 Thu, 09 Sep 2021 10:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-17-rananta@google.com>
 <20210909134520.yxrjestdwsishce2@gator>
In-Reply-To: <20210909134520.yxrjestdwsishce2@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 10:33:47 -0700
Message-ID: <CAJHc60yth9RpUf5MQLZxJHWsdqM_Jo611ReyJJ0HRdM1q7K6AQ@mail.gmail.com>
Subject: Re: [PATCH v4 16/18] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Sep 9, 2021 at 6:45 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:16AM +0000, Raghavendra Rao Ananta wrote:
> > Since the timer stack (hardware and KVM) is per-CPU, there
> > are potential chances for races to occur when the scheduler
> > decides to migrate a vCPU thread to a different physical CPU.
> > Hence, include an option to stress-test this part as well by
> > forcing the vCPUs to migrate across physical CPUs in the
> > system at a particular rate.
> >
> > Originally, the bug for the fix with commit 3134cc8beb69d0d
> > ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> > was discovered using arch_timer test with vCPU migrations and
> > can be easily reproduced.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/aarch64/arch_timer.c        | 113 +++++++++++++++++-
> >  1 file changed, 112 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > index 6141c387e6dc..aac7bcea4352 100644
> > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > @@ -14,6 +14,8 @@
> >   *
> >   * The test provides command-line options to configure the timer's
> >   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> > + * To stress-test the timer stack even more, an option to migrate the
> > + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
> >   *
> >   * Copyright (c) 2021, Google LLC.
> >   */
> > @@ -24,6 +26,8 @@
> >  #include <pthread.h>
> >  #include <linux/kvm.h>
> >  #include <linux/sizes.h>
> > +#include <linux/bitmap.h>
> > +#include <sys/sysinfo.h>
> >
> >  #include "kvm_util.h"
> >  #include "processor.h"
> > @@ -36,17 +40,20 @@
> >  #define NR_TEST_ITERS_DEF            5
> >  #define TIMER_TEST_PERIOD_MS_DEF     10
> >  #define TIMER_TEST_ERR_MARGIN_US     100
> > +#define TIMER_TEST_MIGRATION_FREQ_MS 2
> >
> >  struct test_args {
> >       int nr_vcpus;
> >       int nr_iter;
> >       int timer_period_ms;
> > +     int migration_freq_ms;
> >  };
> >
> >  static struct test_args test_args = {
> >       .nr_vcpus = NR_VCPUS_DEF,
> >       .nr_iter = NR_TEST_ITERS_DEF,
> >       .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > +     .migration_freq_ms = TIMER_TEST_MIGRATION_FREQ_MS,
> >  };
> >
> >  #define msecs_to_usecs(msec)         ((msec) * 1000LL)
> > @@ -81,6 +88,9 @@ struct test_vcpu {
> >  static struct test_vcpu test_vcpu[KVM_MAX_VCPUS];
> >  static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
> >
> > +static unsigned long *vcpu_done_map;
> > +static pthread_mutex_t vcpu_done_map_lock;
> > +
> >  static void
> >  guest_configure_timer_action(struct test_vcpu_shared_data *shared_data)
> >  {
> > @@ -216,6 +226,11 @@ static void *test_vcpu_run(void *arg)
> >
> >       vcpu_run(vm, vcpuid);
> >
> > +     /* Currently, any exit from guest is an indication of completion */
> > +     pthread_mutex_lock(&vcpu_done_map_lock);
> > +     set_bit(vcpuid, vcpu_done_map);
> > +     pthread_mutex_unlock(&vcpu_done_map_lock);
> > +
> >       switch (get_ucall(vm, vcpuid, &uc)) {
> >       case UCALL_SYNC:
> >       case UCALL_DONE:
> > @@ -234,9 +249,76 @@ static void *test_vcpu_run(void *arg)
> >       return NULL;
> >  }
> >
> > +static uint32_t test_get_pcpu(void)
> > +{
> > +     uint32_t pcpu;
> > +     unsigned int nproc_conf;
> > +     cpu_set_t online_cpuset;
> > +
> > +     nproc_conf = get_nprocs_conf();
> > +     sched_getaffinity(0, sizeof(cpu_set_t), &online_cpuset);
> > +
> > +     /* Randomly find an available pCPU to place a vCPU on */
> > +     do {
> > +             pcpu = rand() % nproc_conf;
> > +     } while (!CPU_ISSET(pcpu, &online_cpuset));
> > +
> > +     return pcpu;
> > +}
>
> Missing blank line here.
>
> > +static int test_migrate_vcpu(struct test_vcpu *vcpu)
> > +{
> > +     int ret;
> > +     cpu_set_t cpuset;
> > +     uint32_t new_pcpu = test_get_pcpu();
> > +
> > +     CPU_ZERO(&cpuset);
> > +     CPU_SET(new_pcpu, &cpuset);
> > +
> > +     pr_debug("Migrating vCPU: %u to pCPU: %u\n", vcpu->vcpuid, new_pcpu);
> > +
> > +     ret = pthread_setaffinity_np(vcpu->pt_vcpu_run,
> > +                                     sizeof(cpuset), &cpuset);
> > +
> > +     /* Allow the error where the vCPU thread is already finished */
> > +     TEST_ASSERT(ret == 0 || ret == ESRCH,
> > +                     "Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
> > +                     vcpu->vcpuid, new_pcpu, ret);
> > +
> > +     return ret;
> > +}
>
> Missing blank line here.
>
> > +static void *test_vcpu_migration(void *arg)
> > +{
> > +     unsigned int i, n_done;
> > +     bool vcpu_done;
> > +
> > +     do {
> > +             usleep(msecs_to_usecs(test_args.migration_freq_ms));
> > +
> > +             for (n_done = 0, i = 0; i < test_args.nr_vcpus; i++) {
> > +                     pthread_mutex_lock(&vcpu_done_map_lock);
> > +                     vcpu_done = test_bit(i, vcpu_done_map);
> > +                     pthread_mutex_unlock(&vcpu_done_map_lock);
> > +
> > +                     if (vcpu_done) {
> > +                             n_done++;
> > +                             continue;
> > +                     }
> > +
> > +                     test_migrate_vcpu(&test_vcpu[i]);
> > +             }
> > +     } while (test_args.nr_vcpus != n_done);
> > +
> > +     return NULL;
> > +}
> > +
> >  static void test_run(struct kvm_vm *vm)
> >  {
> >       int i, ret;
> > +     pthread_t pt_vcpu_migration;
> > +
> > +     pthread_mutex_init(&vcpu_done_map_lock, NULL);
> > +     vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
> > +     TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
> >
> >       for (i = 0; i < test_args.nr_vcpus; i++) {
> >               ret = pthread_create(&test_vcpu[i].pt_vcpu_run, NULL,
> > @@ -244,8 +326,23 @@ static void test_run(struct kvm_vm *vm)
> >               TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
> >       }
> >
> > +     /* Spawn a thread to control the vCPU migrations */
> > +     if (test_args.migration_freq_ms) {
> > +             srand(time(NULL));
> > +
> > +             ret = pthread_create(&pt_vcpu_migration, NULL,
> > +                                     test_vcpu_migration, NULL);
> > +             TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
> > +     }
> > +
> > +
> >       for (i = 0; i < test_args.nr_vcpus; i++)
> >               pthread_join(test_vcpu[i].pt_vcpu_run, NULL);
> > +
> > +     if (test_args.migration_freq_ms)
> > +             pthread_join(pt_vcpu_migration, NULL);
> > +
> > +     bitmap_free(vcpu_done_map);
> >  }
> >
> >  static struct kvm_vm *test_vm_create(void)
> > @@ -286,6 +383,8 @@ static void test_print_help(char *name)
> >               NR_TEST_ITERS_DEF);
> >       pr_info("\t-p: Periodicity (in ms) of the guest timer (default: %u)\n",
> >               TIMER_TEST_PERIOD_MS_DEF);
> > +     pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: %u)\n",
> > +             TIMER_TEST_MIGRATION_FREQ_MS);
> >       pr_info("\t-h: print this help screen\n");
> >  }
> >
> > @@ -293,7 +392,7 @@ static bool parse_args(int argc, char *argv[])
> >  {
> >       int opt;
> >
> > -     while ((opt = getopt(argc, argv, "hn:i:p:")) != -1) {
> > +     while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
> >               switch (opt) {
> >               case 'n':
> >                       test_args.nr_vcpus = atoi(optarg);
> > @@ -320,6 +419,13 @@ static bool parse_args(int argc, char *argv[])
> >                               goto err;
> >                       }
> >                       break;
> > +             case 'm':
> > +                     test_args.migration_freq_ms = atoi(optarg);
> > +                     if (test_args.migration_freq_ms < 0) {
> > +                             pr_info("0 or positive value needed for -m\n");
> > +                             goto err;
> > +                     }
> > +                     break;
> >               case 'h':
> >               default:
> >                       goto err;
> > @@ -343,6 +449,11 @@ int main(int argc, char *argv[])
> >       if (!parse_args(argc, argv))
> >               exit(KSFT_SKIP);
> >
> > +     if (get_nprocs() < 2) {
>
> Even though the chance of being on a uniprocessor is low and the migration
> test is now on by default, we could still do
>
>  if (test_args.migration_freq_ms && get_nprocs() < 2)
>
huh, I had the check earlier; must have dropped it somewhere. Will
place it back.
And I'll fix all the blank line comments.

Regards,
Raghavendra

> since that's why the skip message says it needs two cpus.
>
> > +             print_skip("At least two physical CPUs needed for vCPU migration");
> > +             exit(KSFT_SKIP);
> > +     }
> > +
> >       vm = test_vm_create();
> >       test_run(vm);
> >       kvm_vm_free(vm);
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
