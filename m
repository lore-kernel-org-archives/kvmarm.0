Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A9EC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 06:51:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BF29610EA
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 06:51:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2BF29610EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A20004B2DE;
	Tue,  5 Oct 2021 02:51:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sik6UVHT35bk; Tue,  5 Oct 2021 02:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3544B2BC;
	Tue,  5 Oct 2021 02:51:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15EB24B2BC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 02:51:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YL84rsh2Zd5L for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 02:51:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B81A4B286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 02:51:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633416699;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ATL/Z7pwoAKlVQnmhrcwmy5WPmx5pRikF/Eu1y18bWg=;
 b=CoJWMe0qtyfRlc0VAzyrMWRx2RYzDKUOSFyADfpIQpTbn6hwx1pj0A6ETJksdEc727FVBG
 1KUCmAu1s4nS1JcDHumChwLKa5suzWTMN34Fl/TqF743oSftKIvcK25YEBJdadZ3Vatl8M
 GzU3a2dx7NpBdp0oUytOe/W/i3Rl9zI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-gyM0RfdCN9W5d_AhkZcXFw-1; Tue, 05 Oct 2021 02:51:35 -0400
X-MC-Unique: gyM0RfdCN9W5d_AhkZcXFw-1
Received: by mail-ed1-f72.google.com with SMTP id
 d23-20020a50f697000000b003daf215e1efso5316761edn.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 23:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ATL/Z7pwoAKlVQnmhrcwmy5WPmx5pRikF/Eu1y18bWg=;
 b=ZDJvU4TF1GhOGTy3+xhPULNxl3W5oQOZ3kIpth4RkriGbaUhcYP3Tk/YnJ44mFXXC5
 2G2ECpV6XiFzkZbt0S8h0cLmxdBpKmkRS/yBJFXAxRz2Lk0N4ngmgPPjaQxUOqmEcZMy
 Byk1tW3i54EclsYZg6n9xMPkg/yg+K10DgBFHgkBf2anSglvyCGANZyMQ2i+T3MIdhly
 whFZmMcSvRteuz7cdeoYuF/xlaDEaJwPjm3Lu6kDD0Dyr8ODWtWCzfuNN5mUBz2C7LxW
 FlMeqlFl43hyIMnsiF2i9nGud4fUnqI2uumc7S8/imQ0lcLjJzFDvY9iU/Trp66XYmt9
 ELkA==
X-Gm-Message-State: AOAM532jFIk6/WC5gL5rYTb/7ypHiFjWw2cPIsguVFGXw4c+W3rrNjnt
 o1dP9D3Iq4BoIqMsCs0GXcUh0aJDijevmoPf4+NdtaOk3MBfYaJ8xSbLdBkNQ7nZFmxeMbpvrC+
 AMXt7Rs8kKhEmCzZJXPyNpiMB
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr23549458ede.74.1633416694712; 
 Mon, 04 Oct 2021 23:51:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxigcxbQYchzfLiHELsK68J2hy+v4lwrmjvc5Z06F9MqSzYOLZZuW1BC9P4dB9urMdsBIM66w==
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr23549435ede.74.1633416694519; 
 Mon, 04 Oct 2021 23:51:34 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id b5sm8244575edu.13.2021.10.04.23.51.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 23:51:34 -0700 (PDT)
Date: Tue, 5 Oct 2021 08:51:32 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v8 2/9] selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
Message-ID: <20211005065132.wrgapeepngcay34w@gator.home>
References: <20210916181555.973085-1-oupton@google.com>
 <20210916181555.973085-3-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210916181555.973085-3-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
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

On Thu, Sep 16, 2021 at 06:15:48PM +0000, Oliver Upton wrote:
> Add a selftest for the new KVM clock UAPI that was introduced. Ensure
> that the KVM clock is consistent between userspace and the guest, and
> that the difference in realtime will only ever cause the KVM clock to
> advance forward.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++++
>  4 files changed, 208 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 98053d3afbda..86a063d1cd3e 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -12,6 +12,7 @@
>  /x86_64/emulator_error_test
>  /x86_64/get_cpuid_test
>  /x86_64/get_msr_index_features
> +/x86_64/kvm_clock_test
>  /x86_64/kvm_pv_test
>  /x86_64/hyperv_clock
>  /x86_64/hyperv_cpuid
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5d05801ab816..1f969b0192f6 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -46,6 +46,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
> +TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..a8ac5d52e17b 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -19,6 +19,8 @@
>  #define KVM_DEV_PATH "/dev/kvm"
>  #define KVM_MAX_VCPUS 512
>  
> +#define NSEC_PER_SEC 1000000000L
> +
>  /*
>   * Callers of kvm_util only have an incomplete/opaque description of the
>   * structure kvm_util is using to maintain the state of a VM.
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> new file mode 100644
> index 000000000000..e0dcc27ae9f1
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> @@ -0,0 +1,204 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021, Google LLC.
> + *
> + * Tests for adjusting the KVM clock from userspace
> + */
> +#include <asm/kvm_para.h>
> +#include <asm/pvclock.h>
> +#include <asm/pvclock-abi.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <time.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +#define VCPU_ID 0
> +
> +struct test_case {
> +	uint64_t kvmclock_base;
> +	int64_t realtime_offset;
> +};
> +
> +static struct test_case test_cases[] = {
> +	{ .kvmclock_base = 0 },
> +	{ .kvmclock_base = 180 * NSEC_PER_SEC },
> +	{ .kvmclock_base = 0, .realtime_offset = -180 * NSEC_PER_SEC },
> +	{ .kvmclock_base = 0, .realtime_offset = 180 * NSEC_PER_SEC },
> +};
> +
> +#define GUEST_SYNC_CLOCK(__stage, __val)			\
> +		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
> +
> +static void guest_main(vm_paddr_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
> +{
> +	int i;
> +
> +	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
> +		GUEST_SYNC_CLOCK(i, __pvclock_read_cycles(pvti, rdtsc()));
> +}
> +
> +#define EXPECTED_FLAGS (KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
> +
> +static inline void assert_flags(struct kvm_clock_data *data)
> +{
> +	TEST_ASSERT((data->flags & EXPECTED_FLAGS) == EXPECTED_FLAGS,
> +		    "unexpected clock data flags: %x (want set: %x)",
> +		    data->flags, EXPECTED_FLAGS);
> +}
> +
> +static void handle_sync(struct ucall *uc, struct kvm_clock_data *start,
> +			struct kvm_clock_data *end)
> +{
> +	uint64_t obs, exp_lo, exp_hi;
> +
> +	obs = uc->args[2];
> +	exp_lo = start->clock;
> +	exp_hi = end->clock;
> +
> +	assert_flags(start);
> +	assert_flags(end);
> +
> +	TEST_ASSERT(exp_lo <= obs && obs <= exp_hi,
> +		    "unexpected kvm-clock value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
> +		    obs, exp_lo, exp_hi);
> +
> +	pr_info("kvm-clock value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
> +		obs, exp_lo, exp_hi);
> +}
> +
> +static void handle_abort(struct ucall *uc)
> +{
> +	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
> +		  __FILE__, uc->args[1]);
> +}
> +
> +static void setup_clock(struct kvm_vm *vm, struct test_case *test_case)
> +{
> +	struct kvm_clock_data data;
> +
> +	memset(&data, 0, sizeof(data));
> +
> +	data.clock = test_case->kvmclock_base;
> +	if (test_case->realtime_offset) {
> +		struct timespec ts;
> +		int r;
> +
> +		data.flags |= KVM_CLOCK_REALTIME;
> +		do {
> +			r = clock_gettime(CLOCK_REALTIME, &ts);
> +			if (!r)
> +				break;
> +		} while (errno == EINTR);
> +
> +		TEST_ASSERT(!r, "clock_gettime() failed: %d\n", r);
> +
> +		data.realtime = ts.tv_sec * NSEC_PER_SEC;
> +		data.realtime += ts.tv_nsec;
> +		data.realtime += test_case->realtime_offset;
> +	}
> +
> +	vm_ioctl(vm, KVM_SET_CLOCK, &data);
> +}
> +
> +static void enter_guest(struct kvm_vm *vm)
> +{
> +	struct kvm_clock_data start, end;
> +	struct kvm_run *run;
> +	struct ucall uc;
> +	int i, r;
> +
> +	run = vcpu_state(vm, VCPU_ID);
> +
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> +		setup_clock(vm, &test_cases[i]);
> +
> +		vm_ioctl(vm, KVM_GET_CLOCK, &start);
> +
> +		r = _vcpu_run(vm, VCPU_ID);
> +		vm_ioctl(vm, KVM_GET_CLOCK, &end);
> +
> +		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);

_vcpu_run doesn't return until success, so I don't think this assert is
necessary.


> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "unexpected exit reason: %u (%s)",
> +			    run->exit_reason, exit_reason_str(run->exit_reason));

You can leave this to the ucall switch, since if
exit_reason != KVM_EXIT_IO, then you'll get UCALL_NONE

> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_SYNC:
> +			handle_sync(&uc, &start, &end);
> +			break;
> +		case UCALL_ABORT:
> +			handle_abort(&uc);
> +			return;

guest_main() doesn't call GUEST_ASSERT, so this case can't be used, but
maybe it's fine to leave it if there's a chance somebody will add a
GUEST_ASSERT later.


> +		default:
> +			TEST_ASSERT(0, "unhandled ucall: %ld\n",
> +				    get_ucall(vm, VCPU_ID, &uc));

This can be a TEST_FAIL and no need to refetch uc, can just print uc.cmd.

> +		}
> +	}
> +}
> +
> +#define CLOCKSOURCE_PATH "/sys/devices/system/clocksource/clocksource0/current_clocksource"
> +
> +static void check_clocksource(void)
> +{
> +	char *clk_name;
> +	struct stat st;
> +	FILE *fp;
> +
> +	fp = fopen(CLOCKSOURCE_PATH, "r");
> +	if (!fp) {
> +		pr_info("failed to open clocksource file: %d; assuming TSC.\n",
> +			errno);
> +		return;
> +	}
> +
> +	if (fstat(fileno(fp), &st)) {
> +		pr_info("failed to stat clocksource file: %d; assuming TSC.\n",
> +			errno);
> +		goto out;
> +	}
> +
> +	clk_name = malloc(st.st_size);
> +	TEST_ASSERT(clk_name, "failed to allocate buffer to read file\n");
> +
> +	if (!fgets(clk_name, st.st_size, fp)) {
> +		pr_info("failed to read clocksource file: %d; assuming TSC.\n",
> +			ferror(fp));
> +		goto out;
> +	}
> +
> +	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
> +		    "clocksource not supported: %s", clk_name);
> +out:
> +	fclose(fp);
> +}
> +
> +int main(void)
> +{
> +	vm_vaddr_t pvti_gva;
> +	vm_paddr_t pvti_gpa;
> +	struct kvm_vm *vm;
> +	int flags;
> +
> +	flags = kvm_check_cap(KVM_CAP_ADJUST_CLOCK);
> +	if (!(flags & KVM_CLOCK_REALTIME)) {
> +		print_skip("KVM_CLOCK_REALTIME not supported; flags: %x",
> +			   flags);
> +		exit(KSFT_SKIP);
> +	}
> +
> +	check_clocksource();
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_main);
> +
> +	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
> +	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
> +	vcpu_args_set(vm, VCPU_ID, 2, pvti_gpa, pvti_gva);
> +
> +	enter_guest(vm);
> +	kvm_vm_free(vm);
> +}
> -- 
> 2.33.0.464.g1972c5931b-goog
> 


All I did was a drive-by review wrt framework APIs, but, besides the ucall
nits, the test looks good to me.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
