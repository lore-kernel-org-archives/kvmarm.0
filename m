Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851C8C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 15:52:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA85F4A500;
	Thu, 27 Jan 2022 10:52:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9lQUaR+TTANN; Thu, 27 Jan 2022 10:52:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A55144B08A;
	Thu, 27 Jan 2022 10:52:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A26384A100
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 14:22:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bYQqysluA5qm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 14:22:45 -0500 (EST)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70F1C49F56
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 14:22:45 -0500 (EST)
Received: by mail-io1-f46.google.com with SMTP id z199so811192iof.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 11:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linuxfoundation.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=n9wWO2kF4rFaljRmemUKUUwcl0pD1c9sVZULop7qOg0=;
 b=T3vyHziaToGv/jTvQ8gtXQni9vPZRAE+hFYHOT48z3CIDJYOmh5jobc1XdoEV1opZA
 4liTl0zTfDT41yyLD6hYTTKZM2T8dQTdCqBuUbgvVlnQ5ukm+PZ2k+mXOyHfautMlFNT
 An/W+h/uRDUoL79mrVx/OoUq/ppAdHDv8DkqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=n9wWO2kF4rFaljRmemUKUUwcl0pD1c9sVZULop7qOg0=;
 b=R96cD72wYP3/Fqy38W1zen0zmrZzeX2pYbHE44VjzEEeoZaiBCpnq8fDBl7HvdGK9o
 kUfMLzW51fS0w4sFCh7OOq0RmYxx1UmndTk8bJDj3ogG3oompcUar7phOorFv+j78lrl
 F0xgA7Qs+PgaAPCfs8UGraW8HJmSUbTiAplHX3cQm26/UZ9C12OErsotw6Y58PoQTcmH
 E6dYysQw9Gxy1qqXlnZAwEv2eaUAlkzngBa1gC1TWH84aSQj1o5wAvz+c1nAWugn03lN
 YqDHwn/JxVV3EjHhTNDbAscfQscE5cjfkg6DFu4QdH7GOc295K6QpyaU7eAbsLdDWPJQ
 /GHw==
X-Gm-Message-State: AOAM531kB6y6pjYGi7WekOte9cOyk+Sx4hiytbBE1DTPEQLZhjnHuT4G
 4D+0Og728zom4fd1ZPlJ8mlUHg==
X-Google-Smtp-Source: ABdhPJwCblxPTMhz5uV/5mImMlyinQgVdSuG+SpZApm13O6P9XQysEdwJNkXJcFFMW5ikGL+WP8yog==
X-Received: by 2002:a05:6638:1186:: with SMTP id f6mr75676jas.52.1643224964734; 
 Wed, 26 Jan 2022 11:22:44 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
 by smtp.gmail.com with ESMTPSA id y6sm2489246iow.48.2022.01.26.11.22.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 26 Jan 2022 11:22:44 -0800 (PST)
Subject: Re: [PATCH v3] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <shuah@kernel.org>
References: <20220126145242.3473836-1-broonie@kernel.org>
From: Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4424dd30-f74b-006f-b540-dbaf02e45e28@linuxfoundation.org>
Date: Wed, 26 Jan 2022 12:22:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220126145242.3473836-1-broonie@kernel.org>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 27 Jan 2022 10:52:41 -0500
Cc: linux-kselftest@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 1/26/22 7:52 AM, Mark Brown wrote:
> The arch_timer and vgic_irq kselftests assume that they can create a
> vgic-v3, using the library function vgic_v3_setup() which aborts with a
> test failure if it is not possible to do so. Since vgic-v3 can only be
> instantiated on systems where the host has GICv3 this leads to false
> positives on older systems where that is not the case.
> 
> Fix this by changing vgic_v3_setup() to return an error if the vgic can't
> be instantiated and have the callers skip if this happens. We could also
> exit flagging a skip in vgic_v3_setup() but this would prevent future test
> cases conditionally deciding which GIC to use or generally doing more
> complex output.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> 
> v3:
>   - Use custom print_skip() helper.
>   - Use internal version of _kvm_create_device.
> v2:
>   - The test for being able to create the GIC doesn't actually
>     instantiate it, add a call doing so in that case.
> 
>   tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
>   tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
>   tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
>   3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 9ad38bd360a4..b08d30bf71c5 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -366,6 +366,7 @@ static struct kvm_vm *test_vm_create(void)
>   {
>   	struct kvm_vm *vm;
>   	unsigned int i;
> +	int ret;
>   	int nr_vcpus = test_args.nr_vcpus;
>   
>   	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
> @@ -382,7 +383,11 @@ static struct kvm_vm *test_vm_create(void)
>   
>   	ucall_init(vm, NULL);
>   	test_init_timer_irq(vm);
> -	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +	if (ret < 0) {
> +		print_skip("Failed to create vgic-v3");

Printing the negative error code returned by vgic_v3_setup will be useful.

> +		exit(KSFT_SKIP);
> +	}
>   
>   	/* Make all the test's cmdline args visible to the guest */
>   	sync_global_to_guest(vm, test_args);
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index e6c7d7f8fbd1..7eca97799917 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -761,6 +761,10 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>   
>   	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
>   			GICD_BASE_GPA, GICR_BASE_GPA);
> +	if (gic_fd < 0) {
> +		print_skip("Failed to create vgic-v3, skipping");

Same here.

> +		exit(KSFT_SKIP);
> +	}
>   
>   	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
>   		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index b3a0fca0d780..f5cd0c536d85 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -52,7 +52,9 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
>   			nr_vcpus, nr_vcpus_created);
>   
>   	/* Distributor setup */
> -	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	if (_kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3,
> +			       false, &gic_fd) != 0)
> +		return -1;
>   
>   	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
>   			0, &nr_irqs, true);
> 

With these fixed:

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
