Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45757C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 11:05:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B44886109E
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 11:05:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B44886109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30B764B1C8;
	Fri,  3 Sep 2021 07:05:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f-FaxW8ydC9w; Fri,  3 Sep 2021 07:05:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8F4E4B1B3;
	Fri,  3 Sep 2021 07:05:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E68F4B1A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 07:05:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sS0ZeBrcW-ga for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 07:05:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F2404B19D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 07:05:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630667121;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HKIY6ikHaYXPyQ8mc3z2vSwsDwCqgabZwLfvmGN6b8E=;
 b=g2waDuKh1aoBhZMAVn8sMXDTOtnLeLEbht1b36PzAduk9iA3Qkw6FSZX3rqxqhXWo6Hcjf
 8OKgimvSlL8nKvf4ILYjjhC3HxHuTyIJF9Ht+puqxKYOsI0q6qmhZDcCB3lffBBodGISn7
 mwz4qhKzjiMjbThJwvRGQGznQ2OMwkk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-Xj_rIL0uOA-e6S29WqMtEA-1; Fri, 03 Sep 2021 07:05:18 -0400
X-MC-Unique: Xj_rIL0uOA-e6S29WqMtEA-1
Received: by mail-ed1-f71.google.com with SMTP id
 i17-20020aa7c711000000b003c57b06a2caso2557068edq.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 04:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HKIY6ikHaYXPyQ8mc3z2vSwsDwCqgabZwLfvmGN6b8E=;
 b=AnHzeQ6Vsld2Pvo8b4DA3K6c47pnLVCNe/WWqH5vmniOUH9lGo4aZkCJuQ8ZrPlELU
 k20KJ7junSNII4989PRb8czGRohhCMAU3LQYPx3PHLonyC3NpLtURHYsFLrWXaYV2w5l
 RoVujvA1/cBMFhFax8lVvWAfKvXPZSxyax0jLpI52XLvhk+UuqhekaygrpXn9Vx1g7cb
 +JkfAXPtDDzrlM9YUDnPbuV50OEk+FsWCRA9YyqkxBy8wgKL2iRg4ds7UahfL1hVyuF2
 bhi11EscdFIseuYPwY39qqswWqiujadT9YwZd95sYQlTEk2ii67jgH4HcIQH5xdylL8R
 UK3Q==
X-Gm-Message-State: AOAM5330n0VOPpGx5lSz3mg8HoLd+bJr9DTEgLzkSKQdGSCvfBXR2Pb9
 CWN8jhNUhHB8HV8aF2b/Oxial6hqh6PyAZUCfcyQxdWIeCsU3YfLLkubJWBlsTP2xfNe6yyrMOG
 JRNSq5NhQ5vtuJkdEq/xWsEDb
X-Received: by 2002:aa7:c649:: with SMTP id z9mr3434777edr.304.1630667117281; 
 Fri, 03 Sep 2021 04:05:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3MQKea1R8lQ0vwpT0Bk599an+E9Z7X4uNcjB0uA7SB1DzNkJn4bAYb6lg/3Nhge6byxQIRA==
X-Received: by 2002:aa7:c649:: with SMTP id z9mr3434757edr.304.1630667117046; 
 Fri, 03 Sep 2021 04:05:17 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id n2sm2842024edi.32.2021.09.03.04.05.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Sep 2021 04:05:16 -0700 (PDT)
Date: Fri, 3 Sep 2021 13:05:14 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
Message-ID: <20210903110514.22x3txynin5hg46z@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-13-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-13-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> Since the timer stack (hardware and KVM) is per-CPU, there
> are potential chances for races to occur when the scheduler
> decides to migrate a vCPU thread to a different physical CPU.
> Hence, include an option to stress-test this part as well by
> forcing the vCPUs to migrate across physical CPUs in the
> system at a particular rate.
> 
> Originally, the bug for the fix with commit 3134cc8beb69d0d
> ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> was discovered using arch_timer test with vCPU migrations and
> can be easily reproduced.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
>  1 file changed, 107 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 1383f33850e9..de246c7afab2 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -14,6 +14,8 @@
>   *
>   * The test provides command-line options to configure the timer's
>   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> + * To stress-test the timer stack even more, an option to migrate the
> + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
>   *
>   * Copyright (c) 2021, Google LLC.
>   */
> @@ -24,6 +26,8 @@
>  #include <pthread.h>
>  #include <linux/kvm.h>
>  #include <linux/sizes.h>
> +#include <linux/bitmap.h>
> +#include <sys/sysinfo.h>
>  
>  #include "kvm_util.h"
>  #include "processor.h"
> @@ -41,12 +45,14 @@ struct test_args {
>  	int nr_vcpus;
>  	int nr_iter;
>  	int timer_period_ms;
> +	int migration_freq_ms;
>  };
>  
>  static struct test_args test_args = {
>  	.nr_vcpus = NR_VCPUS_DEF,
>  	.nr_iter = NR_TEST_ITERS_DEF,
>  	.timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> +	.migration_freq_ms = 0,		/* Turn off migrations by default */

I'd rather we enable good tests like these by default.

>  };
>  
>  #define msecs_to_usecs(msec)		((msec) * 1000LL)
> @@ -81,6 +87,9 @@ struct test_vcpu {
>  static struct test_vcpu test_vcpu[KVM_MAX_VCPUS];
>  static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
>  
> +static unsigned long *vcpu_done_map;
> +static pthread_mutex_t vcpu_done_map_lock;
> +
>  static void
>  guest_configure_timer_action(struct test_vcpu_shared_data *shared_data)
>  {
> @@ -216,6 +225,11 @@ static void *test_vcpu_run(void *arg)
>  
>  	vcpu_run(vm, vcpuid);
>  
> +	/* Currently, any exit from guest is an indication of completion */
> +	pthread_mutex_lock(&vcpu_done_map_lock);
> +	set_bit(vcpuid, vcpu_done_map);
> +	pthread_mutex_unlock(&vcpu_done_map_lock);
> +
>  	switch (get_ucall(vm, vcpuid, &uc)) {
>  	case UCALL_SYNC:
>  	case UCALL_DONE:
> @@ -235,9 +249,73 @@ static void *test_vcpu_run(void *arg)
>  	return NULL;
>  }
>  
> +static uint32_t test_get_pcpu(void)
> +{
> +	uint32_t pcpu;
> +	unsigned int nproc_conf;
> +	cpu_set_t online_cpuset;
> +
> +	nproc_conf = get_nprocs_conf();
> +	sched_getaffinity(0, sizeof(cpu_set_t), &online_cpuset);
> +
> +	/* Randomly find an available pCPU to place a vCPU on */
> +	do {
> +		pcpu = rand() % nproc_conf;
> +	} while (!CPU_ISSET(pcpu, &online_cpuset));
> +
> +	return pcpu;
> +}
> +static int test_migrate_vcpu(struct test_vcpu *vcpu)
> +{
> +	int ret;
> +	cpu_set_t cpuset;
> +	uint32_t new_pcpu = test_get_pcpu();
> +
> +	CPU_ZERO(&cpuset);
> +	CPU_SET(new_pcpu, &cpuset);
> +	ret = pthread_setaffinity_np(vcpu->pt_vcpu_run,
> +					sizeof(cpuset), &cpuset);
> +
> +	/* Allow the error where the vCPU thread is already finished */
> +	TEST_ASSERT(ret == 0 || ret == ESRCH,
> +			"Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
> +			vcpu->vcpuid, new_pcpu, ret);

It'd be good to collect stats for the two cases so we know how many
vcpus we actually migrated with a successful setaffinity and how many
just completed too early. If our stats don't look good, then we can
adjust our timeouts and frequencies.

> +
> +	return ret;
> +}
> +static void *test_vcpu_migration(void *arg)
> +{
> +	unsigned int i, n_done;
> +	bool vcpu_done;
> +
> +	do {
> +		usleep(msecs_to_usecs(test_args.migration_freq_ms));
> +
> +		for (n_done = 0, i = 0; i < test_args.nr_vcpus; i++) {
> +			pthread_mutex_lock(&vcpu_done_map_lock);
> +			vcpu_done = test_bit(i, vcpu_done_map);
> +			pthread_mutex_unlock(&vcpu_done_map_lock);
> +
> +			if (vcpu_done) {
> +				n_done++;
> +				continue;
> +			}
> +
> +			test_migrate_vcpu(&test_vcpu[i]);
> +		}
> +	} while (test_args.nr_vcpus != n_done);
> +
> +	return NULL;
> +}
> +
>  static void test_run(struct kvm_vm *vm)
>  {
>  	int i, ret;
> +	pthread_t pt_vcpu_migration;
> +
> +	pthread_mutex_init(&vcpu_done_map_lock, NULL);
> +	vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
> +	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
>  
>  	for (i = 0; i < test_args.nr_vcpus; i++) {
>  		ret = pthread_create(&test_vcpu[i].pt_vcpu_run, NULL,
> @@ -245,8 +323,23 @@ static void test_run(struct kvm_vm *vm)
>  		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
>  	}
>  
> +	/* Spawn a thread to control the vCPU migrations */
> +	if (test_args.migration_freq_ms) {
> +		srand(time(NULL));
> +
> +		ret = pthread_create(&pt_vcpu_migration, NULL,
> +					test_vcpu_migration, NULL);
> +		TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
> +	}
> +
> +
>  	for (i = 0; i < test_args.nr_vcpus; i++)
>  		pthread_join(test_vcpu[i].pt_vcpu_run, NULL);
> +
> +	if (test_args.migration_freq_ms)
> +		pthread_join(pt_vcpu_migration, NULL);
> +
> +	bitmap_free(vcpu_done_map);
>  }
>  
>  static struct kvm_vm *test_vm_create(void)
> @@ -286,6 +379,7 @@ static void test_print_help(char *name)
>  		NR_TEST_ITERS_DEF);
>  	pr_info("\t-p: Periodicity (in ms) of the guest timer (default: %u)\n",
>  		TIMER_TEST_PERIOD_MS_DEF);
> +	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: 0)\n");
>  	pr_info("\t-h: print this help screen\n");
>  }
>  
> @@ -293,7 +387,7 @@ static bool parse_args(int argc, char *argv[])
>  {
>  	int opt;
>  
> -	while ((opt = getopt(argc, argv, "hn:i:p:")) != -1) {
> +	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
>  		switch (opt) {
>  		case 'n':
>  			test_args.nr_vcpus = atoi(optarg);
> @@ -320,6 +414,13 @@ static bool parse_args(int argc, char *argv[])
>  				goto err;
>  			}
>  			break;
> +		case 'm':
> +			test_args.migration_freq_ms = atoi(optarg);
> +			if (test_args.migration_freq_ms < 0) {
> +				pr_info("0 or positive value needed for -m\n");
> +				goto err;
> +			}
> +			break;
>  		case 'h':
>  		default:
>  			goto err;
> @@ -343,6 +444,11 @@ int main(int argc, char *argv[])
>  	if (!parse_args(argc, argv))
>  		exit(KSFT_SKIP);
>  
> +	if (get_nprocs() < 2) {

if (test_args.migration_freq_ms && get_nprocs() < 2)

> +		print_skip("At least two physical CPUs needed for vCPU migration");
> +		exit(KSFT_SKIP);
> +	}
> +
>  	vm = test_vm_create();
>  	test_run(vm);
>  	kvm_vm_free(vm);
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
