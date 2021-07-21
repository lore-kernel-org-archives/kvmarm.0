Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AE0C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 15:17:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC16861246
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 15:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC16861246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 651A24B0D7;
	Wed, 21 Jul 2021 11:17:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mOeTKjq9cuqB; Wed, 21 Jul 2021 11:17:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11FAC405A9;
	Wed, 21 Jul 2021 11:17:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3C3D405A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:17:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cBHpOvI6cfUv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 11:17:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1623402C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:17:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626880660;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=cjz/qY9rq3iPuIQlWrJrcTCNPSV381YIh1gROWvzlnA=;
 b=XrMNAayn6Yeabbwn8QYVERwyGWiRGvXTs5XxMXnqypJVf5Ucama9xh4cYSj4UR0HB4Wg1K
 a4egj2rdYR5S92znaZJUhGU8NdaFD2KhdMZPkJ5zV7L8EzofMcEw8jLQwLcKvLQXS9RKzW
 aQL9XsSNRuioM50DnS4hX4AwcXxiv9c=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-kEd0snYCNyO-SVc3R2I5Yw-1; Wed, 21 Jul 2021 11:17:37 -0400
X-MC-Unique: kEd0snYCNyO-SVc3R2I5Yw-1
Received: by mail-il1-f197.google.com with SMTP id
 g9-20020a92cda90000b029020cc3319a86so1750587ild.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 08:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cjz/qY9rq3iPuIQlWrJrcTCNPSV381YIh1gROWvzlnA=;
 b=a/Ltkgb67cAtPk2sXDr7eMQ08zya3OyvV06oHRrG+GJH5WeMWe9R3uN+OKjAdHAcdt
 QmaodgmoYxLLr2up0bXUTn6YvtoTwzT2hqvK7+ULY5YVLfNTwRv4L9hJ1yj30ccTYFwW
 akKJKsZ2e8d20BObK4LDTYR9Bb+CNlTUzYHV5g4iQ08+U6uOyxwlqcLwLFABWCTZcHEE
 Bpm859Fg38NK9mEKG99O5Zu7+RFcjLv30WRdGNeBeVoALp3TFHEzhHSKhdtHaKeBtFmT
 aiIgsulvCywv/RJwLBUSaKjZpp1EytNmOMH3MiHFK1sH+5w226F2hRrECXMCmDVyafGj
 rebQ==
X-Gm-Message-State: AOAM530kplfPrdBk5/pzACqKbb6LdTL1RZ5M9WYncfwUyP1Ykk58MHV+
 MSkxTDhS6AB7vQ5NFdPTCbu5Tks/lUpj7CYr84rPZMPMbfPRwfTcl4FwBLlnM9CpXJw4bfM1V5Q
 dultojHA7xDk6ANYHzZc6JUkK
X-Received: by 2002:a5e:d508:: with SMTP id e8mr14388595iom.101.1626880656746; 
 Wed, 21 Jul 2021 08:17:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJ0u39et2NnLlV6EWy3+1YIXupxf89Pzxvb2E5MW4TyugGAON0zndCG+fRuGJzVGbOohzoIQ==
X-Received: by 2002:a5e:d508:: with SMTP id e8mr14388578iom.101.1626880656539; 
 Wed, 21 Jul 2021 08:17:36 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id x16sm12926397ila.84.2021.07.21.08.17.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 08:17:35 -0700 (PDT)
Date: Wed, 21 Jul 2021 17:17:33 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 07/12] selftests: KVM: Introduce system counter offset
 test
Message-ID: <20210721151733.6yj3lm3h2amwmgmf@gator>
References: <20210716212629.2232756-1-oupton@google.com>
 <20210716212629.2232756-8-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210716212629.2232756-8-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Fri, Jul 16, 2021 at 09:26:24PM +0000, Oliver Upton wrote:
> Introduce a KVM selftest to verify that userspace manipulation of the
> TSC (via the new vCPU attribute) results in the correct behavior within
> the guest.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/system_counter_offset_test.c          | 133 ++++++++++++++++++
>  3 files changed, 135 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index d0877d01e771..2752813d5090 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -50,3 +50,4 @@
>  /set_memory_region_test
>  /steal_time
>  /kvm_binary_stats_test
> +/system_counter_offset_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index f7e24f334c6e..7bf2e5fb1d5a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -83,6 +83,7 @@ TEST_GEN_PROGS_x86_64 += memslot_perf_test
>  TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> +TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> new file mode 100644
> index 000000000000..7e9015770759
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -0,0 +1,133 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021, Google LLC.
> + *
> + * Tests for adjusting the system counter from userspace
> + */
> +#include <asm/kvm_para.h>
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
> +#ifdef __x86_64__
> +
> +struct test_case {
> +	uint64_t tsc_offset;
> +};
> +
> +static struct test_case test_cases[] = {
> +	{ 0 },
> +	{ 180 * NSEC_PER_SEC },
> +	{ -180 * NSEC_PER_SEC },
> +};
> +
> +static void check_preconditions(struct kvm_vm *vm)
> +{
> +	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL, KVM_VCPU_TSC_OFFSET))
> +		return;
> +
> +	print_skip("KVM_VCPU_TSC_OFFSET not supported; skipping test");
> +	exit(KSFT_SKIP);
> +}
> +
> +static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
> +{
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL,
> +				KVM_VCPU_TSC_OFFSET, &test->tsc_offset, true);
> +}
> +
> +static uint64_t guest_read_system_counter(struct test_case *test)
> +{
> +	return rdtsc();
> +}
> +
> +static uint64_t host_read_guest_system_counter(struct test_case *test)
> +{
> +	return rdtsc() + test->tsc_offset;
> +}
> +
> +#else /* __x86_64__ */
> +
> +#error test not implemented for this architecture!
> +
> +#endif
> +
> +#define GUEST_SYNC_CLOCK(__stage, __val)			\
> +		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
> +
> +static void guest_main(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> +		struct test_case *test = &test_cases[i];
> +
> +		GUEST_SYNC_CLOCK(i, guest_read_system_counter(test));
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void handle_sync(struct ucall *uc, uint64_t start, uint64_t end)
> +{
> +	uint64_t obs = uc->args[2];
> +
> +	TEST_ASSERT(start <= obs && obs <= end,
> +		    "unexpected system counter value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
> +		    obs, start, end);
> +
> +	pr_info("system counter value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
> +		obs, start, end);
> +}
> +
> +static void handle_abort(struct ucall *uc)
> +{
> +	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
> +		  __FILE__, uc->args[1]);
> +}
> +
> +static void enter_guest(struct kvm_vm *vm)
> +{
> +	uint64_t start, end;
> +	struct ucall uc;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> +		struct test_case *test = &test_cases[i];
> +
> +		setup_system_counter(vm, test);
> +		start = host_read_guest_system_counter(test);
> +		vcpu_run(vm, VCPU_ID);
> +		end = host_read_guest_system_counter(test);
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_SYNC:
> +			handle_sync(&uc, start, end);
> +			break;
> +		case UCALL_ABORT:
> +			handle_abort(&uc);
> +			return;
> +		case UCALL_DONE:
> +			return;
> +		}
> +	}
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_main);
> +	check_preconditions(vm);
> +	ucall_init(vm, NULL);
> +
> +	enter_guest(vm);
> +	kvm_vm_free(vm);
> +}
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
