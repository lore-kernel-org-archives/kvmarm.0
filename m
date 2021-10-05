Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C370C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:49:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C06F8614C8
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:49:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C06F8614C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1E74B2D9;
	Tue,  5 Oct 2021 09:49:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9T9AGWNT6jv; Tue,  5 Oct 2021 09:49:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3454B306;
	Tue,  5 Oct 2021 09:49:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 189854B2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:49:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CQexuFrbvgkn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:49:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A054B2D9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:49:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633441774;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sN1cJhbytrAM9N4QAPFZhEFWhJvN3WJabYiHuROOQxA=;
 b=HoWWg1XoCDtURU6JQisAVf+WMecfn4jtWUTlduuDMjGB/amz3hSbL+5xuVYR7ZkNOVq9ZW
 EbaL9Wsgvag/PZoXoZyFdSvw7owDSoe161UrllLfAZxR3gCUmvFzO8BuCPQy6L6c6MWdhf
 a/Wtj8+I0u6Ldx6ri3Wmz8KlxKJf2mQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-iLy0ho8eOK2HhLqwFzQBYg-1; Tue, 05 Oct 2021 09:49:33 -0400
X-MC-Unique: iLy0ho8eOK2HhLqwFzQBYg-1
Received: by mail-ed1-f71.google.com with SMTP id
 g28-20020a50d0dc000000b003dae69dfe3aso7875360edf.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 06:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sN1cJhbytrAM9N4QAPFZhEFWhJvN3WJabYiHuROOQxA=;
 b=icMbot6XUiyVwfDXz4dBpBvuqm7GZtMtDtKU+F92vh4V4oSCEtjZY2m8PRqkyqkSR6
 wMj+RrAQkG6pSdhldBV50Jmniapg3r0BIPvl0FJybOdyq+nlFxRmd6ZUB0LQl+pvYgDr
 9cqSB0e/1zOIbpNyDwz6uZ6rGXbj3Ka1Vq4iRaBQOQuxIKMmNJnYORyOjoc0nDr4M+um
 OzYs5MEn3jEGMbpm8/wrGdN1mHmikMQ3wtTSGgiELeKoQ3FEalDvSBBPw5QGLs7Lq+fk
 n0PYHx5K4EemsA6VQD8q28yl7tsNJLNxYZh+H776zR338GYZjvwZAZddhvhq8EAVp15s
 4FCQ==
X-Gm-Message-State: AOAM531T+SFOICYYJqutMyFQCI0yAyG5j+v8lBDft9+3bctR/NXWJHMk
 ckjrU7TIHxvY6dJEo0KeFSfKb+BYl4iiHmUDD+mnmhBHhb5OCfKBWyTDZJU2f9OJyRgca01P2kc
 3oVIWBT96C2OT1sHuOOJHsMtD
X-Received: by 2002:a17:906:318f:: with SMTP id
 15mr25069223ejy.206.1633441772656; 
 Tue, 05 Oct 2021 06:49:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym9/EkDza9wFdcmrvx39UdAtrbdx4cJu7y3elXK/ktXDerwTAkh0WABPphiEFfAEMKQcp2gA==
X-Received: by 2002:a17:906:318f:: with SMTP id
 15mr25069192ejy.206.1633441772425; 
 Tue, 05 Oct 2021 06:49:32 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id q17sm8857129edd.57.2021.10.05.06.49.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 06:49:32 -0700 (PDT)
Date: Tue, 5 Oct 2021 15:49:30 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 11/11] selftests: KVM: Test SYSTEM_SUSPEND PSCI call
Message-ID: <20211005134930.dxej2lgcjklzouw7@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-12-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210923191610.3814698-12-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 07:16:10PM +0000, Oliver Upton wrote:
> Assert that the vCPU exits to userspace with KVM_SYSTEM_EVENT_SUSPEND if
> it correctly executes the SYSTEM_SUSPEND PSCI call. Additionally, assert
> that the guest PSCI call fails if preconditions are not met (more than 1
> running vCPU).
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/psci_test.c | 75 +++++++++++++++++++
>  1 file changed, 75 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> index 90312be335da..5b881ca4d102 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -45,6 +45,16 @@ static uint64_t psci_affinity_info(uint64_t target_affinity,
>  	return res.a0;
>  }
>  
> +static uint64_t psci_system_suspend(uint64_t entry_addr, uint64_t context_id)
> +{
> +	struct arm_smccc_res res;
> +
> +	smccc_hvc(PSCI_1_0_FN64_SYSTEM_SUSPEND, entry_addr, context_id,
> +		  0, 0, 0, 0, 0, &res);
> +
> +	return res.a0;
> +}
> +
>  static void guest_test_cpu_on(uint64_t target_cpu)
>  {
>  	GUEST_ASSERT(!psci_cpu_on(target_cpu, CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID));
> @@ -69,6 +79,13 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
>  	vcpu_set_mp_state(vm, vcpuid, &mp_state);
>  }
>  
> +static void guest_test_system_suspend(void)
> +{
> +	uint64_t r = psci_system_suspend(CPU_ON_ENTRY_ADDR, CPU_ON_CONTEXT_ID);
> +
> +	GUEST_SYNC(r);
> +}
> +
>  static struct kvm_vm *setup_vm(void *guest_code)
>  {
>  	struct kvm_vcpu_init init;
> @@ -136,8 +153,66 @@ static void host_test_cpu_on(void)
>  	kvm_vm_free(vm);
>  }
>  
> +static void enable_system_suspend(struct kvm_vm *vm)
> +{
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
> +	};
> +
> +	vm_enable_cap(vm, &cap);
> +}
> +
> +static void host_test_system_suspend(void)
> +{
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +
> +	vm = setup_vm(guest_test_system_suspend);
> +	enable_system_suspend(vm);
> +
> +	vcpu_power_off(vm, VCPU_ID_TARGET);
> +	run = vcpu_state(vm, VCPU_ID_SOURCE);
> +
> +	enter_guest(vm, VCPU_ID_SOURCE);
> +
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
> +		    "Unhandled exit reason: %u (%s)",
> +		    run->exit_reason, exit_reason_str(run->exit_reason));
> +	TEST_ASSERT(run->system_event.type == KVM_SYSTEM_EVENT_SUSPEND,
> +		    "Unhandled system event: %u (expected: %u)",
> +		    run->system_event.type, KVM_SYSTEM_EVENT_SUSPEND);
> +
> +	assert_vcpu_reset(vm, VCPU_ID_SOURCE);
> +	kvm_vm_free(vm);
> +}
> +
> +static void host_test_system_suspend_fails(void)
> +{
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	vm = setup_vm(guest_test_system_suspend);
> +	enable_system_suspend(vm);
> +
> +	enter_guest(vm, VCPU_ID_SOURCE);
> +	TEST_ASSERT(get_ucall(vm, VCPU_ID_SOURCE, &uc) == UCALL_SYNC,
> +		    "Unhandled ucall: %lu", uc.cmd);
> +	TEST_ASSERT(uc.args[1] == PSCI_RET_DENIED,
> +		    "Unrecognized PSCI return code: %lu (expected: %u)",
> +		    uc.args[1], PSCI_RET_DENIED);
> +
> +	kvm_vm_free(vm);
> +}
> +
>  int main(void)
>  {
> +	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
> +		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
> +		exit(KSFT_SKIP);
> +	}

How about only guarding the new tests with this, so we can still do the
cpu_on test when this feature isn't present?

> +
>  	host_test_cpu_on();
> +	host_test_system_suspend();
> +	host_test_system_suspend_fails();
>  	return 0;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
> 

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
