Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAE6C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 11:03:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 370E760F43
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 11:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 370E760F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A53C54066E;
	Wed,  4 Aug 2021 07:03:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MDSmuSIWK8GE; Wed,  4 Aug 2021 07:03:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F56C4079D;
	Wed,  4 Aug 2021 07:03:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18A36406DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 07:03:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9KuQYtzXxsCI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 07:03:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1006D4066E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 07:03:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628075002;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=S1iL8Km0oaU1hyCCL5LNwK2V4oZKfOIQ2vsQgM5B4Go=;
 b=VQdqtEFkSPnQmezoBacTC4SxggA6qP/67ubsz/sPhxCXOEUM4u3VjsixsGlA8AMplujGdv
 TjdXWjaGfGPxPGxAVGhfqERU6kb6/ITyYiY8A5soT0sKDXmbwDjCHiO9Sj+YCwIbFcdbHM
 1rgadCqhgyA/mG940pJN2R5/jsatt2c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-EMugngQ9PWqqHGTxRMg6GA-1; Wed, 04 Aug 2021 07:03:21 -0400
X-MC-Unique: EMugngQ9PWqqHGTxRMg6GA-1
Received: by mail-ed1-f69.google.com with SMTP id
 de5-20020a0564023085b02903bb92fd182eso1279630edb.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 04:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=S1iL8Km0oaU1hyCCL5LNwK2V4oZKfOIQ2vsQgM5B4Go=;
 b=qhnuJXZan7SbkQ/sQzF5s4NgJjND5sqv2G+FoDe9A95yfTsRS4pFjE3ueIX8+RdhHJ
 LoxMYY6AGY4BUbUOeTku70VmomiQHVhNfDXX9d4JnEHZiKJNQecOWdxP321IaTvMCCBO
 P1lSlVpsdv06WUefcjRigKXgiir9FatEvc/Iz7IG/Ys7Xp8y5ym41Q6pK9PuKRrtWYyE
 tZAvghkO23ss14but6+0Cq20xYwqxr8wHyJG/nwojlsQW/zut11IqiMFB9i4BUBhTRJX
 OkmLZW4Zctk7M3QnaXrODC+LSd8TYdQlaT7/zsDJQNI18uL6HOWxQWj7r31rFOXTuDNM
 dlwQ==
X-Gm-Message-State: AOAM533G4hzPKvFXTok4DNw4bz35WqyNfoN2zU6l6IcYGK42xY3FxTi1
 PHT/w56ZpulOZM2iZ8/n0yvTq+9x+HLxkBeJEv7z5YKGWYlozLn+/HnVPRKQu1W13CG1SV8Gku/
 cjOMj+bb/PRSVCN3LFkZV9wmV
X-Received: by 2002:aa7:c042:: with SMTP id k2mr31971989edo.104.1628075000522; 
 Wed, 04 Aug 2021 04:03:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytmqyypODz5oMdPE5pY9yGVOKv6+wiZO2uHQgs8zCZ3FrZMIHAYmG5P5O16ooSFth4kPz6sQ==
X-Received: by 2002:aa7:c042:: with SMTP id k2mr31971957edo.104.1628075000291; 
 Wed, 04 Aug 2021 04:03:20 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id fr4sm571351ejc.42.2021.08.04.04.03.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 Aug 2021 04:03:19 -0700 (PDT)
Date: Wed, 4 Aug 2021 13:03:17 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 20/21] selftests: KVM: Test physical counter offsetting
Message-ID: <20210804110317.z7iqgbtbiyfvy45h@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-21-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-21-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
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

On Wed, Aug 04, 2021 at 08:58:18AM +0000, Oliver Upton wrote:
> Test that userspace adjustment of the guest physical counter-timer
> results in the correct view within the guest.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 12 +++++++
>  .../kvm/system_counter_offset_test.c          | 31 +++++++++++++++++--
>  2 files changed, 40 insertions(+), 3 deletions(-)
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
> index ac933db83d03..82d26a45cc48 100644
> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -57,6 +57,9 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
>  
>  enum arch_counter {
>  	VIRTUAL,
> +	PHYSICAL,
> +	/* offset physical, read virtual */
> +	PHYSICAL_READ_VIRTUAL,
>  };
>  
>  struct test_case {
> @@ -68,32 +71,54 @@ static struct test_case test_cases[] = {
>  	{ .counter = VIRTUAL, .offset = 0 },
>  	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
>  	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = 0 },
> +	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 0 },
> +	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = -180 * NSEC_PER_SEC },
>  };
>  
>  static void check_preconditions(struct kvm_vm *vm)
>  {
> -	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
> +	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET) &&
> +	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				   KVM_ARM_VCPU_TIMER_OFFSET))
>  		return;
>  
> -	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
> +	print_skip("KVM_REG_ARM_TIMER_OFFSET|KVM_ARM_VCPU_TIMER_OFFSET not supported; skipping test");
>  	exit(KSFT_SKIP);
>  }
>  
>  static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
>  {
> +	uint64_t cntvoff, cntpoff;
>  	struct kvm_one_reg reg = {
>  		.id = KVM_REG_ARM_TIMER_OFFSET,
> -		.addr = (__u64)&test->offset,
> +		.addr = (__u64)&cntvoff,
>  	};
>  
> +	if (test->counter == VIRTUAL) {
> +		cntvoff = test->offset;
> +		cntpoff = 0;
> +	} else {
> +		cntvoff = 0;
> +		cntpoff = test->offset;
> +	}
> +
>  	vcpu_set_reg(vm, VCPU_ID, &reg);
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				KVM_ARM_VCPU_TIMER_OFFSET, &cntpoff, true);
>  }
>  
>  static uint64_t guest_read_system_counter(struct test_case *test)
>  {
>  	switch (test->counter) {
>  	case VIRTUAL:
> +	case PHYSICAL_READ_VIRTUAL:
>  		return read_cntvct_ordered();
> +	case PHYSICAL:
> +		return read_cntpct_ordered();
>  	default:
>  		GUEST_ASSERT(0);
>  	}
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
