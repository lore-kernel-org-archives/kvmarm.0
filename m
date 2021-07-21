Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C88C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:46:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F265361244
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F265361244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 840CD4B0FB;
	Wed, 21 Jul 2021 12:46:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RkzhP+Sfz8WJ; Wed, 21 Jul 2021 12:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CB744B091;
	Wed, 21 Jul 2021 12:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A0F04B091
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:46:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2nYyPRyGNGr4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 12:46:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E24C24A003
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 12:46:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626886001;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SdDUG3Tlr7StcVQDE/T+VireBjyknjYEkozWsd7mGNo=;
 b=hKFrsC4EEkIstb8QmkUGGFW5qCpEIhAdaBb6qlvZdFqZTtTDxW73XlfIXjOaqierTQXTxg
 gqIYT7CWNzNW7//x3QwuUdLjd/ZI3B8By8L2CVrxgv7HeMg68wRSstgBOGTINaw0Ig8V6Z
 eDKfpYMTuvyXAsUBUmtt6mgKP4+z1l8=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-zMtLy_vcOiCLk0LstvKcRw-1; Wed, 21 Jul 2021 12:46:40 -0400
X-MC-Unique: zMtLy_vcOiCLk0LstvKcRw-1
Received: by mail-io1-f69.google.com with SMTP id
 i13-20020a5d88cd0000b02904e5ab8bdc6cso1943266iol.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 09:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SdDUG3Tlr7StcVQDE/T+VireBjyknjYEkozWsd7mGNo=;
 b=QNvzp47RdFTjy9BiVDx8llCTwO0JXTJ5CzXhnt/3pXMTJcn7/qliSPBZjAFb5mGF53
 CND5/nhQkgeE+JeKTEPnRW+5301K+REPokSRyWnekx8ALAIjaU2exQoXmzCBVUqohIe9
 uAlEus/+62pVH4oIxDq9ZJURRLsg4YQolzZeIcNFq1LqBibD+9etIHZOIvdOzc+Gyy8b
 3lHnDTsv7d1lYlBob2g5+BlfO3OeVsUPkXaHEidr2H+6lOH80fwN7NzEGBVnxXSQD1FL
 e2P4Da7W8m11/XaubTwmFJSQpBqzMraDyEOCetZHe1wTqklSDOdXZeWFkf/TIo7R8lFj
 NV4Q==
X-Gm-Message-State: AOAM530TM+7931SjrST1QbTHtoF5JxG09NqrTc3AXsVaAL+qGnrfeqgJ
 mspuGU8H0vfcfOrcDxGqZ/NPrq0sTSamiD0ZYS9swgnDowPhumW4KVHQNDhOP5v1wcu5Oujs5ub
 SkGY/S/J0QNs+U1ZBm1kvyb+H
X-Received: by 2002:a92:d58f:: with SMTP id a15mr8037172iln.18.1626885999247; 
 Wed, 21 Jul 2021 09:46:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhXSZhbJ3Y7T2Mveqj1UY3BfD2Zr2HtG+rzw/5HH87b6MDaadStM2r2qKfE3lFkz+licmK8w==
X-Received: by 2002:a92:d58f:: with SMTP id a15mr8037150iln.18.1626885999068; 
 Wed, 21 Jul 2021 09:46:39 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id y198sm14555037iof.25.2021.07.21.09.46.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 09:46:38 -0700 (PDT)
Date: Wed, 21 Jul 2021 18:46:36 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 11/12] selftests: KVM: Test physical counter offsetting
Message-ID: <20210721164636.yzzhguwzjrtj3ty6@gator>
References: <20210719184949.1385910-1-oupton@google.com>
 <20210719184949.1385910-12-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210719184949.1385910-12-oupton@google.com>
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

On Mon, Jul 19, 2021 at 06:49:48PM +0000, Oliver Upton wrote:
> Test that userpace adjustment of the guest physical counter-timer
> results in the correct view of within the guest.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 12 ++++++++
>  .../kvm/system_counter_offset_test.c          | 29 ++++++++++++++++---
>  2 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 3168cdbae6ee..7f53d90e9512 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -141,4 +141,16 @@ static inline uint64_t read_cntvct_ordered(void)
>  	return r;
>  }
>  
> +static inline uint64_t read_cntpct_ordered(void)
> +{
> +	uint64_t r;
> +
> +	__asm__ __volatile__("isb\n\t"
> +			     "mrs %0, cntpct_el0\n\t"
> +			     "isb\n\t"
> +			     : "=r"(r));
> +
> +	return r;
> +}
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> index 88ad997f5b69..3eed9dcb7693 100644
> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -57,6 +57,7 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
>  
>  enum arch_counter {
>  	VIRTUAL,
> +	PHYSICAL,
>  };
>  
>  struct test_case {
> @@ -68,23 +69,41 @@ static struct test_case test_cases[] = {
>  	{ .counter = VIRTUAL, .offset = 0 },
>  	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
>  	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = 0 },
> +	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
>  };
>  
>  static void check_preconditions(struct kvm_vm *vm)
>  {
>  	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> -				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
> +				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER) &&
> +	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				   KVM_ARM_VCPU_TIMER_OFFSET_PTIMER))
>  		return;
>  
> -	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
> +	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_{VTIMER,PTIMER} not supported; skipping test");
>  	exit(KSFT_SKIP);
>  }
>  
>  static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
>  {
> +	u64 attr = 0;
> +
> +	switch (test->counter) {
> +	case VIRTUAL:
> +		attr = KVM_ARM_VCPU_TIMER_OFFSET_VTIMER;
> +		break;
> +	case PHYSICAL:
> +		attr = KVM_ARM_VCPU_TIMER_OFFSET_PTIMER;
> +		break;
> +	default:
> +		TEST_ASSERT(false, "unrecognized counter index %u",
> +			    test->counter);
> +	}
> +
>  	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> -				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
> -				true);
> +				attr, &test->offset, true);
>  }
>  
>  static uint64_t guest_read_system_counter(struct test_case *test)
> @@ -92,6 +111,8 @@ static uint64_t guest_read_system_counter(struct test_case *test)
>  	switch (test->counter) {
>  	case VIRTUAL:
>  		return read_cntvct_ordered();
> +	case PHYSICAL:
> +		return read_cntpct_ordered();
>  	default:
>  		GUEST_ASSERT(0);
>  	}
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
