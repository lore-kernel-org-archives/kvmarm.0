Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAE2C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 06:17:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 417D940C67;
	Mon, 21 Mar 2022 02:17:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0s0VfABOKWdz; Mon, 21 Mar 2022 02:17:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE12649F28;
	Mon, 21 Mar 2022 02:17:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1400F40F93
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 02:17:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hByEnJotk3Oi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 02:17:48 -0400 (EDT)
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com
 [209.85.166.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4B7C40C67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 02:17:48 -0400 (EDT)
Received: by mail-il1-f169.google.com with SMTP id r11so9686108ila.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Mar 2022 23:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lGKC2mf0hFQiICGRSwDpr31aUdSdil5bq9Oeg3ycDy4=;
 b=VgVfWD+xuTx6hWPzin2mUTC5QyNORCrheUp+VG9r7TLYlvdlcy/8SZ64iFey4jdfEy
 +rSQoh9METHR98K8MIjHjuNfbm4sQxlclg9KfjF0SbLD5ke66R3X4NVpwmHCm/nNnZy0
 x/+OJ/Vy1KRLRFCicm5gvmWUJx1pWcSnGAcNMGo35VzD2vrQldN4FTUf8Fg3VoRb18aU
 53wl/F/S2YAmG6egNAvohzya/k3Vmpc+P/4ttpyfd8+DpTcnuwrgO4eYQ3rC9lhF2sJa
 oGEUSdk8G+/ddK0vmkslzLk+E34DBBJx6eLyyYfmAKsb6N+wMAdrrQCkFcjMFGW6CTDF
 Mwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lGKC2mf0hFQiICGRSwDpr31aUdSdil5bq9Oeg3ycDy4=;
 b=jENFqXP7bEyVcD0vj0iq4d5kOsZe+gOli9LTleYGN74uVuiE3NrcSlIo9T/jok+lw6
 V5RvyO+ZmUViDriVuQmF/Zbvb4bsDIQQSXikMoRTAH8edLr4nxZdB5k+boOFztBPN/65
 9PyZtQCMLE/rPYomcp9sfonsgUSw4qrNmaV5nRYusQS/j+Jl+TXNHCB0V78mU2gvLx02
 LWi9ttL21ZErsRumwUCDcOPUMDnwBEBfTx0NMnCmOss0GFZcRCbmo6GT3/NCKcHofD2X
 UIg2ZFz6xZ3JBpqnJ3h+Li5MT48At6W4okgTvLzzmUhkLHp1zXPlC8CBbJXZznML+vx9
 FWGQ==
X-Gm-Message-State: AOAM5304fMNT4pOyRgJLgW+gWA1BB8GX/OwlAsdDp9Q2Z+DYmq80URCH
 CmHOAHz5WFXVEkspr/umhN3yOA==
X-Google-Smtp-Source: ABdhPJzOrGVLB1JiFQLEvSi9X8lxn5/7v/JdeM80Oe/gKRYTq6ddxKx8ab8SVFMZnFP88Vi4nWSzsg==
X-Received: by 2002:a05:6e02:1a8e:b0:2c8:1deb:d981 with SMTP id
 k14-20020a056e021a8e00b002c81debd981mr3003519ilv.304.1647843467593; 
 Sun, 20 Mar 2022 23:17:47 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 d15-20020a92360f000000b002c81e1fdae1sm2394674ila.85.2022.03.20.23.17.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 20 Mar 2022 23:17:46 -0700 (PDT)
Date: Mon, 21 Mar 2022 06:17:43 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v5 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
Message-ID: <YjgYh89k8s+w34FQ@google.com>
References: <20220321050804.2701035-1-reijiw@google.com>
 <20220321050804.2701035-3-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220321050804.2701035-3-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

Hi Reiji,

On Sun, Mar 20, 2022 at 10:08:04PM -0700, Reiji Watanabe wrote:
> Introduce a test for aarch64 that ensures non-mixed-width vCPUs
> (all 64bit vCPUs or all 32bit vcPUs) can be configured, and
> mixed-width vCPUs cannot be configured.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

Tiny nits, but looks fine to me. Only bother addressing if you do
another spin, otherwise:

Reviewed-by: Oliver Upton <oupton@google.com>


> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
>  3 files changed, 127 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index dce7de7755e6..4e884e29b2a8 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -3,6 +3,7 @@
>  /aarch64/debug-exceptions
>  /aarch64/get-reg-list
>  /aarch64/psci_cpu_on_test
> +/aarch64/vcpu_width_config
>  /aarch64/vgic_init
>  /aarch64/vgic_irq
>  /s390x/memop
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 0e4926bc9a58..06a5a982123e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -104,6 +104,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
> +TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
> diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
> new file mode 100644
> index 000000000000..6e6e6a9f69e3
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
> @@ -0,0 +1,125 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vcpu_width_config - Test KVM_ARM_VCPU_INIT() with KVM_ARM_VCPU_EL1_32BIT.
> + *
> + * Copyright (c) 2022 Google LLC.
> + *
> + * This is a test that ensures that non-mixed-width vCPUs (all 64bit vCPUs
> + * or all 32bit vcPUs) can be configured and mixed-width vCPUs cannot be
> + * configured.
> + */
> +
> +#define _GNU_SOURCE

In other instances where we define _GNU_SOURCE, it is said we do it for
program_invocation_short_name. Nonetheless, I cannot find anywhere that
the symbol is actually being used.

This looks to be some leftover crud from our internal test library
before we upstreamed KVM selftests a few years ago.

> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +
> +/*
> + * Add a vCPU, run KVM_ARM_VCPU_INIT with @init1, and then
> + * add another vCPU, and run KVM_ARM_VCPU_INIT with @init2.
> + */
> +static int add_init_2vcpus(struct kvm_vcpu_init *init1,
> +			   struct kvm_vcpu_init *init2)
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +
> +	vm_vcpu_add(vm, 0);
> +	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
> +	if (ret)
> +		goto free_exit;
> +
> +	vm_vcpu_add(vm, 1);
> +	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
> +
> +free_exit:
> +	kvm_vm_free(vm);
> +	return ret;
> +}
> +
> +/*
> + * Add two vCPUs, then run KVM_ARM_VCPU_INIT for one vCPU with @init1,
> + * and run KVM_ARM_VCPU_INIT for another vCPU with @init2.
> + */
> +static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
> +				  struct kvm_vcpu_init *init2)
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +
> +	vm_vcpu_add(vm, 0);
> +	vm_vcpu_add(vm, 1);
> +
> +	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
> +	if (ret)
> +		goto free_exit;
> +
> +	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
> +
> +free_exit:
> +	kvm_vm_free(vm);
> +	return ret;
> +}
> +
> +/*
> + * Tests that two 64bit vCPUs can be configured, two 32bit vCPUs can be
> + * configured, and two mixed-witgh vCPUs cannot be configured.

mixed-width

> + * Each of those three cases, configure vCPUs in two different orders.
> + * The one is running KVM_CREATE_VCPU for 2 vCPUs, and then running
> + * KVM_ARM_VCPU_INIT for them.
> + * The other is running KVM_CREATE_VCPU and KVM_ARM_VCPU_INIT for a vCPU,
> + * and then run those commands for another vCPU.
> + */
> +int main(void)
> +{
> +	struct kvm_vcpu_init init1, init2;
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	if (kvm_check_cap(KVM_CAP_ARM_EL1_32BIT) <= 0) {

nit: this is fine, but KVM_CHECK_EXTENSION returns exactly 0 if a
capability is not supported.

> +		print_skip("KVM_CAP_ARM_EL1_32BIT is not supported");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	/* Get the preferred target type and copy that to init2 */
> +	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
> +	kvm_vm_free(vm);
> +	memcpy(&init2, &init1, sizeof(init2));

nit: I think you can just assign init2 = init1.

> +	/* Test with 64bit vCPUs */
> +	ret = add_init_2vcpus(&init1, &init2);
> +	TEST_ASSERT(ret == 0,
> +		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
> +	ret = add_2vcpus_init_2vcpus(&init1, &init2);

nit: for the homogeneous vCPU configuration tests, you could pass two
pointers to the same init structure to really drive the point home that
the vCPUs are the same. The underlying ioctl does not write back
anything to userspace.

> +	TEST_ASSERT(ret == 0,
> +		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
> +
> +	/* Test with 32bit vCPUs */
> +	init1.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
> +	init2.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
> +	ret = add_init_2vcpus(&init1, &init2);
> +	TEST_ASSERT(ret == 0,
> +		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
> +	ret = add_2vcpus_init_2vcpus(&init1, &init2);
> +	TEST_ASSERT(ret == 0,
> +		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
> +
> +	/* Test with mixed-width vCPUs  */
> +	init1.features[0] = 0;
> +	init2.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
> +	ret = add_init_2vcpus(&init1, &init2);
> +	TEST_ASSERT(ret != 0,
> +		    "Configuring mixed-width vCPUs worked unexpectedly");
> +	ret = add_2vcpus_init_2vcpus(&init1, &init2);
> +	TEST_ASSERT(ret != 0,
> +		    "Configuring mixed-width vCPUs worked unexpectedly");
> +
> +	return 0;
> +}
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
