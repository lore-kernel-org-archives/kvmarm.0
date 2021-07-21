Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1E1C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:26:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F62761242
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F62761242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4E14B100;
	Wed, 21 Jul 2021 12:26:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qMjMYXLvv9SS; Wed, 21 Jul 2021 12:26:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 914E04B115;
	Wed, 21 Jul 2021 12:26:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2B854B100
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:26:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R+jZR+6OwbIu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 12:26:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B00094086F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:26:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626884810;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=m+x1aVmvJEpbSpTNhe+gSPdN5GMbbTZag6bLJsVFPDU=;
 b=iKhz1ocfWiID1lGL82qLvbKTY6rDNO4EZ5esICYOx6HgdgVVn790sOduhYWCYDZnAk+Xxx
 hiNQNR2SVfBAl1wxH+UWOoSiX95pCOIxoy9rLlufNs2YC8BDacCE0eIg6b9P5w7hA8C8+e
 3dbe4fUD+cz5hzFhI+eSAr4gtEH+kQA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-Hw8DzDMRPfS9d1SkOs-2lw-1; Wed, 21 Jul 2021 12:26:49 -0400
X-MC-Unique: Hw8DzDMRPfS9d1SkOs-2lw-1
Received: by mail-io1-f71.google.com with SMTP id
 p7-20020a6b63070000b029050017e563a6so1955574iog.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 09:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=m+x1aVmvJEpbSpTNhe+gSPdN5GMbbTZag6bLJsVFPDU=;
 b=LnawvxeI8XZhuWy2oq+kRYdk6LFovumXXh95/2gBrr6bQMAN2uHLnXN2mFXz+s5RoF
 4pKwpeOu7GeenCPTLFGarVj2nwDQgVyOWltOKHWDw+vkZP2l1cfr2+aOJZGR434F8CgU
 b5od2f+PLMex1j3ZOCQJC8q3FVzW2HOUYYEXlPo1vPISEHC2QuXOFXeNg2MGqAZhMaNE
 ULvwveLiBZNc6mmVOps0aUnFA2N24IcX9q8CRlhr5j1q8JgXzkQNSgfRWdXYaMHM0YtP
 pHTQVdkSQfAr+OE2/x/LgX5SxGs8yNEzJgnQM36GhGLtLF5NJxJpdIRbBgN82iYB5mbQ
 ZWag==
X-Gm-Message-State: AOAM533O8vchkQTjPpK6ujbJAyPjTGg3h4yv95p7xQB3XlRkdg3DFude
 LXsnfn2csCTPafhaM07PHXJmgINuBfbbMZfo9tSwVoQ+XZ15/BIFAzEzd92UlgsKkFgEEbJq1M2
 B7LcCOb2HC6DUMR7R72cbze9p
X-Received: by 2002:a6b:fe03:: with SMTP id x3mr7853643ioh.120.1626884808828; 
 Wed, 21 Jul 2021 09:26:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwgzuS9Yi4VtCvnXQZWmI5CguoZwANnXgiGFfIgiUSl1f7p3if1KjZl/ILBiSx0bJnXvz5BQ==
X-Received: by 2002:a6b:fe03:: with SMTP id x3mr7853623ioh.120.1626884808633; 
 Wed, 21 Jul 2021 09:26:48 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id m1sm14838987iok.33.2021.07.21.09.26.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 09:26:48 -0700 (PDT)
Date: Wed, 21 Jul 2021 18:26:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 09/12] selftests: KVM: Add support for aarch64 to
 system_counter_offset_test
Message-ID: <20210721162645.5frobtrhtniyanng@gator>
References: <20210719184949.1385910-1-oupton@google.com>
 <20210719184949.1385910-10-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210719184949.1385910-10-oupton@google.com>
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

On Mon, Jul 19, 2021 at 06:49:46PM +0000, Oliver Upton wrote:
> KVM/arm64 now allows userspace to adjust the guest virtual counter-timer
> via a vCPU device attribute. Test that changes to the virtual
> counter-timer offset result in the correct view being presented to the
> guest.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/include/aarch64/processor.h | 12 +++++
>  .../kvm/system_counter_offset_test.c          | 54 ++++++++++++++++++-
>  3 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 7bf2e5fb1d5a..d89908108c97 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -96,6 +96,7 @@ TEST_GEN_PROGS_aarch64 += kvm_page_table_test
>  TEST_GEN_PROGS_aarch64 += set_memory_region_test
>  TEST_GEN_PROGS_aarch64 += steal_time
>  TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
> +TEST_GEN_PROGS_aarch64 += system_counter_offset_test
>  
>  TEST_GEN_PROGS_s390x = s390x/memop
>  TEST_GEN_PROGS_s390x += s390x/resets
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 27dc5c2e56b9..3168cdbae6ee 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -129,4 +129,16 @@ void vm_install_sync_handler(struct kvm_vm *vm,
>  
>  #define isb()	asm volatile("isb" : : : "memory")
>  
> +static inline uint64_t read_cntvct_ordered(void)
> +{
> +	uint64_t r;
> +
> +	__asm__ __volatile__("isb\n\t"
> +			     "mrs %0, cntvct_el0\n\t"
> +			     "isb\n\t"
> +			     : "=r"(r));
> +
> +	return r;
> +}
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> index 7e9015770759..88ad997f5b69 100644
> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -53,7 +53,59 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
>  	return rdtsc() + test->tsc_offset;
>  }
>  
> -#else /* __x86_64__ */
> +#elif __aarch64__ /* __x86_64__ */
> +
> +enum arch_counter {
> +	VIRTUAL,
> +};
> +
> +struct test_case {
> +	enum arch_counter counter;
> +	uint64_t offset;
> +};
> +
> +static struct test_case test_cases[] = {
> +	{ .counter = VIRTUAL, .offset = 0 },
> +	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
> +};
> +
> +static void check_preconditions(struct kvm_vm *vm)
> +{
> +	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
> +		return;
> +
> +	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
> +	exit(KSFT_SKIP);
> +}
> +
> +static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
> +{
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
> +				true);
> +}
> +
> +static uint64_t guest_read_system_counter(struct test_case *test)
> +{
> +	switch (test->counter) {
> +	case VIRTUAL:
> +		return read_cntvct_ordered();
> +	default:
> +		GUEST_ASSERT(0);
> +	}
> +
> +	/* unreachable */
> +	return 0;
> +}
> +
> +static uint64_t host_read_guest_system_counter(struct test_case *test)
> +{
> +	return read_cntvct_ordered() - test->offset;
> +}
> +
> +#else /* __aarch64__ */
>  
>  #error test not implemented for this architecture!
>  
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
