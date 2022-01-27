Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761C6C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 04:17:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E96FC49F00;
	Wed, 26 Jan 2022 23:17:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OQ9uMPeZNw53; Wed, 26 Jan 2022 23:17:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B570149F03;
	Wed, 26 Jan 2022 23:17:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6B1149EED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 23:17:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x3aHcwEjQJPr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 23:17:04 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69C4A49EBB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 23:17:04 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id
 d12-20020a17090a628c00b001b4f47e2f51so6305528pjj.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 20:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MlI851lUoHdmSjJoGiyp5I4kiqlKaCdV4NPdXhxRA+8=;
 b=C8VvuZFe4rCP2uCFSONmb99RN1LdQn529TOYmrpKoK7PYZcziPiAhrOW11oPx+kR43
 opz70CnPxzxoZTYSSVhdERYlJMV8TdO2QuyuvwmFnkgUYxlX3/+xpOKrqI+Z+SedE8V0
 b2zhdCzpSnUjJajZlBYXB+FSVxcFj2HkqHfh92IhUWwU9i3Q4biweQtzgZksk14c+YiH
 52bQWQ89Jcu87pb3B4VxHhWSQojQZDN4MzrgykfnIRP/6lSrZxJ1K92QfFOGFIVPjDYw
 3UM41Q/sdGDYKwy0SqhzCI9wShehVrMqDwPAZ1e+aIL1TRmW3bpwLdmcoEgNXDTVMahN
 1OPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MlI851lUoHdmSjJoGiyp5I4kiqlKaCdV4NPdXhxRA+8=;
 b=3/ig1Wpp2fPx3dWVbnYe1uG2tDjB7wf8R0oxczr75tEwIuoezLdZbLMi16r8nvDA5Z
 G7TpyH8Ivc7u74NtT6DydaC3fpiI+GpAZ7j2FTmZ4uwYg7vHQ0MqX2/Fl/D5X+L2XZPg
 PJulHdJfNpC/QqQhUnCUtijhuIARz/XvBwsrSc7f5U0MTCesWawbDiQk68hopjLkPKqF
 VpgWhv8tCz/ynsevD6Lg22dCihLBaZoLJ08fGoIFMQMtj0pk7iroTkiOKlbN+nnFppS6
 RTQQfk6Bu59Rzcwz1egWGh0f1oUlQxUJqfIO4TfyyDBYIKSM8sNsYvM+/ezjwVstIR5O
 zAqA==
X-Gm-Message-State: AOAM532gvS4G0AaCcn9P7bs7TLKMlRDX4ZckLwEKmy5gmPkynqm3FEYY
 YGTnSAIelSxtJaiccxjN11hbFw==
X-Google-Smtp-Source: ABdhPJzz3u8vPsKiH9OPkvGE3abpQ/af8KLmu4FJ0c7+83/vDdWzlReCnpAVhOP8ndMIaORK9xGeGg==
X-Received: by 2002:a17:902:f083:: with SMTP id
 p3mr2247927pla.72.1643257023220; 
 Wed, 26 Jan 2022 20:17:03 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id z7sm3556746pfe.49.2022.01.26.20.17.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 20:17:02 -0800 (PST)
Date: Wed, 26 Jan 2022 20:16:59 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <YfIcu2DMi83eua8C@google.com>
References: <20220126145242.3473836-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220126145242.3473836-1-broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-kselftest@vger.kernel.org
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

On Wed, Jan 26, 2022 at 02:52:42PM +0000, Mark Brown wrote:
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
>  - Use custom print_skip() helper.
>  - Use internal version of _kvm_create_device.
> v2:
>  - The test for being able to create the GIC doesn't actually
>    instantiate it, add a call doing so in that case.
> 
>  tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 9ad38bd360a4..b08d30bf71c5 100644
> --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> @@ -366,6 +366,7 @@ static struct kvm_vm *test_vm_create(void)
>  {
>  	struct kvm_vm *vm;
>  	unsigned int i;
> +	int ret;
>  	int nr_vcpus = test_args.nr_vcpus;
>  
>  	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
> @@ -382,7 +383,11 @@ static struct kvm_vm *test_vm_create(void)
>  
>  	ucall_init(vm, NULL);
>  	test_init_timer_irq(vm);
> -	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +	if (ret < 0) {
> +		print_skip("Failed to create vgic-v3");
> +		exit(KSFT_SKIP);
> +	}
>  
>  	/* Make all the test's cmdline args visible to the guest */
>  	sync_global_to_guest(vm, test_args);
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index e6c7d7f8fbd1..7eca97799917 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -761,6 +761,10 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>  
>  	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
>  			GICD_BASE_GPA, GICR_BASE_GPA);
> +	if (gic_fd < 0) {
> +		print_skip("Failed to create vgic-v3, skipping");
> +		exit(KSFT_SKIP);
> +	}
>  
>  	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
>  		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index b3a0fca0d780..f5cd0c536d85 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -52,7 +52,9 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
>  			nr_vcpus, nr_vcpus_created);
>  
>  	/* Distributor setup */
> -	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	if (_kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3,
> +			       false, &gic_fd) != 0)
> +		return -1;
>  
>  	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
>  			0, &nr_irqs, true);
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Tried both gicv2 and v3 and the change works as expected.

Tested-by: Ricardo Koller <ricarkol@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
