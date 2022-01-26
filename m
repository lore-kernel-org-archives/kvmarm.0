Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA98C5AC75
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 01:23:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A992140B87;
	Tue, 25 Jan 2022 20:23:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5vr9wRrGuNIP; Tue, 25 Jan 2022 20:23:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00A9640B41;
	Tue, 25 Jan 2022 20:23:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 954DF4076C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 20:23:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lBhl8728akpZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 20:23:06 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A0004076A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 20:23:06 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id q63so17100799pja.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 17:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qp4BntvRZm9hTr6l3zGlLo/U2BcJeqsTUdhiP4SKrfc=;
 b=rnMb5VODVOzw+bv9bS2Xh/FWWtA0ngwR5DIt+Eo6WtS6Vq3bu0jdGnsnzLxJOCMDSF
 3sZYL4sHTlkLgSt07lNK6NTk7Ohc91R982WORpBXrfy32BHbh8apbLZbEq6iNcHcYE+6
 kLRZgGsIB7vAQDROpGqNVavQ2hWrbh94yAxs9+jhALNKxRMiMVBmQ/5l18fGqc33aSYk
 /6WzA0JspTrE0U6yjgA+l7V89fh84lGmtLjC23lM723iKZHGvqaXzXWp+uG8Pe8sAMDL
 c1pei8gFnnxoRhaxF2kRSdqzGHqGs4tQ+EwGyMmp5h+d/AElW0VuAJMeiwXS0gQBPigP
 aOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qp4BntvRZm9hTr6l3zGlLo/U2BcJeqsTUdhiP4SKrfc=;
 b=S4gsQ/p9z4loeqZ2O/H2fwIqiim/i/VMJiRsijwwbB73tzaT4g4O2R9GB3W/Y6MZEv
 GfGkhuWT5mK15iHKPsSJ4rQ8dT+0H7ysUHPJb+ONhCw7NhbLqSX+kxjSJLVKT3+J8ao7
 pdLeNuHJ9DhK6JmFob1LzZW2cY8HBInn7Mc6LDDQAaZzQRVWVNzHmldIA+vIcYHwikui
 2w6uEQt3FILe3fkGKtRYv1n2CpF2qR8Eq0YRXnC/ZmMC3Qb2vfNcm9a685yhZ9/Gbbg3
 BVXBPgdJqJxpySgymAFX+DibYu6usgy2OH/Hh7BGZGwwOqYtF7arYCCqdBJ6TAtUm9eX
 iv0Q==
X-Gm-Message-State: AOAM530sE/D/5fFz+heeGsbBRvpUV3uoXcpoXwwhHkeZcrkB+JEsYJ0l
 Az3sa3bCG1sqyHKzTLB/YpOQVw==
X-Google-Smtp-Source: ABdhPJy6cZxhtYaWpqQmPdBWff89FNYeHqo7ViO8layI33gz7tVSxvOa9Wo7gfzqkIxzBwDanL5/MA==
X-Received: by 2002:a17:90a:e38d:: with SMTP id
 b13mr6198622pjz.205.1643160184936; 
 Tue, 25 Jan 2022 17:23:04 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id u16sm220313pfg.192.2022.01.25.17.23.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 Jan 2022 17:23:04 -0800 (PST)
Date: Tue, 25 Jan 2022 17:23:00 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <YfCidIboLDMb/Hy3@google.com>
References: <20220125192851.3907611-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220125192851.3907611-1-broonie@kernel.org>
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

On Tue, Jan 25, 2022 at 07:28:51PM +0000, Mark Brown wrote:
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
>  tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 5 +++++
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 4 +++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> index 9ad38bd360a4..791d38404652 100644
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
> +		pr_info("Failed to create vgic-v3, skipping\n");
> +		exit(KSFT_SKIP);
> +	}
>  
>  	/* Make all the test's cmdline args visible to the guest */
>  	sync_global_to_guest(vm, test_args);
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index e6c7d7f8fbd1..8c6b61b8e6aa 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -761,6 +761,11 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>  
>  	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
>  			GICD_BASE_GPA, GICR_BASE_GPA);
> +	if (gic_fd < 0) {
> +		pr_info("Failed to create vgic-v3, skipping\n");
> +		exit(KSFT_SKIP);
> +	}
> +
>  
>  	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
>  		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index b3a0fca0d780..647c18733e1b 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -52,7 +52,9 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
>  			nr_vcpus, nr_vcpus_created);
>  
>  	/* Distributor setup */
> -	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
> +	if (gic_fd == -1)
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

Reviewed-by: Ricardo Koller <ricarkol@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
