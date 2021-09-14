Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD327C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 07:50:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4451A61361
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 07:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4451A61361
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B178F4B126;
	Tue, 14 Sep 2021 03:50:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xhGRNWXCXK6e; Tue, 14 Sep 2021 03:50:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 447D04B10A;
	Tue, 14 Sep 2021 03:50:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D204B10A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 03:50:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0AWlHMv2kdHb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 03:49:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 991754B106
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 03:49:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631605799;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=R6Z78UAv1kninDvhZD/qhelNjlru3f9bIEDAEEJ+aas=;
 b=civYtNuqbQXIAvfT52tsD1J3Ww44wDSkPMYFSePm5Bwgul1qmANCIolgjwP76LGepo1Q+2
 JeF+Xx6JsKPXbvgFY77iCpVscZdkaZXzbaQb+MKOl9Tr9/YCCr7/t87OzWb4zfpvnKIiHr
 sD0W5ibmJ3Rfdw6KKnhnjGURhCSAJew=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-yFIfmDOeNo6EIGW8yh6yEw-1; Tue, 14 Sep 2021 03:49:57 -0400
X-MC-Unique: yFIfmDOeNo6EIGW8yh6yEw-1
Received: by mail-ed1-f69.google.com with SMTP id
 v13-20020a056402174d00b003c25d6b2f13so6317479edx.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 00:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=R6Z78UAv1kninDvhZD/qhelNjlru3f9bIEDAEEJ+aas=;
 b=WmGbiWz+4oilVBELu10x9ho+Ee+MgnLsy30NBM3izkB+MzVjdUV97oxnVGNBEoFicB
 bc+fJV8EwQl02MirjzJn1igoLCxsGdwYbYLN04Xq+TF7WAYzIRgLn/tDpUoMGhOwwaGF
 UZf9gs9SIvTnqbpF9NtHDvtxK3xAiPCBGn/9VXYplr3v8cYdCqLXTu+UtlU6euugr2i/
 jsvkfgxLhAoz8ksGG2kcAtKCLp4bmyN7H+KQHdF4vioZlkpsi1mnBzHjeJOcnDvRsAm9
 Wzxfc+ukDgaHUaiCW77NxByaYVUY49KgvWSh2Yer+Ioqjp9uB8TcKsq8bnj51Oytt+LS
 W70g==
X-Gm-Message-State: AOAM533V0trYCD7cS84qHZIf65inoYevMXvI95meQmPYOwSkbnTm9o+e
 8FUtMaNW1il5I4XHm+Xi6yY+G5TzDy0hJ24cW9ZY6Lv8wUAgAH15sdUz/wo401yGXXe1JJC5Q9i
 CcqSvO9fS/O0lbteJNm/vYPoV
X-Received: by 2002:a17:906:50d:: with SMTP id
 j13mr10991462eja.58.1631605796665; 
 Tue, 14 Sep 2021 00:49:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJTsoIi5L3KoB/sC54f49zilK1+Lotlu4FXZaBZwCghtwsY0aj86bOujiop9u3X1CIuwd6VQ==
X-Received: by 2002:a17:906:50d:: with SMTP id
 j13mr10991428eja.58.1631605796384; 
 Tue, 14 Sep 2021 00:49:56 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id dj8sm3925587edb.53.2021.09.14.00.49.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Sep 2021 00:49:55 -0700 (PDT)
Date: Tue, 14 Sep 2021 09:49:53 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v6 12/14] KVM: arm64: selftests: Add host support for vGIC
Message-ID: <20210914074953.lijtspubonocwz4u@gator.home>
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-13-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210913230955.156323-13-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

On Mon, Sep 13, 2021 at 11:09:53PM +0000, Raghavendra Rao Ananta wrote:
> Implement a simple library to perform vGIC-v3 setup
> from a host point of view. This includes creating a
> vGIC device, setting up distributor and redistributor
> attributes, and mapping the guest physical addresses.
> 
> The definition of REDIST_REGION_ATTR_ADDR is taken from
> aarch64/vgic_init test. Hence, replace the definition
> by including vgic.h in the test file.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../testing/selftests/kvm/aarch64/vgic_init.c |  3 +-
>  .../selftests/kvm/include/aarch64/vgic.h      | 20 ++++++
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 70 +++++++++++++++++++
>  4 files changed, 92 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5476a8ddef60..8342f65c1d96 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -35,7 +35,7 @@ endif
>  
>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
>  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
> +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>  
>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 623f31a14326..157fc24f39c5 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -13,11 +13,10 @@
>  #include "test_util.h"
>  #include "kvm_util.h"
>  #include "processor.h"
> +#include "vgic.h"
>  
>  #define NR_VCPUS		4
>  
> -#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) (((uint64_t)(count) << 52) | \
> -	((uint64_t)((base) >> 16) << 16) | ((uint64_t)(flags) << 12) | index)
>  #define REG_OFFSET(vcpu, offset) (((uint64_t)vcpu << 32) | offset)
>  
>  #define GICR_TYPER 0x8
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> new file mode 100644
> index 000000000000..0ecfb253893c
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ARM Generic Interrupt Controller (GIC) host specific defines
> + */
> +
> +#ifndef SELFTEST_KVM_VGIC_H
> +#define SELFTEST_KVM_VGIC_H
> +
> +#include <linux/kvm.h>
> +
> +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> +	(((uint64_t)(count) << 52) | \
> +	((uint64_t)((base) >> 16) << 16) | \
> +	((uint64_t)(flags) << 12) | \
> +	index)
> +
> +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
> +
> +#endif /* SELFTEST_KVM_VGIC_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> new file mode 100644
> index 000000000000..9880caa8c7db
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM Generic Interrupt Controller (GIC) v3 host support
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/sizes.h>
> +#include <asm/kvm.h>
> +
> +#include "kvm_util.h"
> +#include "../kvm_util_internal.h"
> +#include "vgic.h"
> +
> +/*
> + * vGIC-v3 default host setup
> + *
> + * Input args:
> + *	vm - KVM VM
> + *	nr_vcpus - Number of vCPUs supported by this VM
> + *	gicd_base_gpa - Guest Physical Address of the Distributor region
> + *	gicr_base_gpa - Guest Physical Address of the Redistributor region
> + *
> + * Output args: None
> + *
> + * Return: GIC file-descriptor or negative error code upon failure
> + *
> + * The function creates a vGIC-v3 device and maps the distributor and
> + * redistributor regions of the guest. Since it depends on the number of
> + * vCPUs for the VM, it must be called after all the vCPUs have been created.
> + */
> +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> +{
> +	int gic_fd;
> +	uint64_t redist_attr;
> +	struct list_head *iter;
> +	unsigned int nr_gic_pages, nr_vcpus_created = 0;
> +
> +	TEST_ASSERT(nr_vcpus, "Num of vCPUs cannot be empty\n");

nit: I'd rather spell out 'Number'

> +
> +	/*
> +	 * Make sure that the caller is infact calling this
> +	 * function after all the vCPUs are added.
> +	 */
> +	list_for_each(iter, &vm->vcpus)
> +		nr_vcpus_created++;
> +	TEST_ASSERT(nr_vcpus == nr_vcpus_created,
> +			"No. of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)\n",

nit: Same nit here, s/No./Number/

> +			nr_vcpus, nr_vcpus_created);
> +
> +	/* Distributor setup */
> +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> +	nr_gic_pages = vm_calc_num_guest_pages(vm->mode, KVM_VGIC_V3_DIST_SIZE);
> +	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
> +
> +	/* Redistributor setup */
> +	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> +	nr_gic_pages = vm_calc_num_guest_pages(vm->mode,
> +						KVM_VGIC_V3_REDIST_SIZE * nr_vcpus);
> +	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
> +
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	return gic_fd;
> +}
> -- 
> 2.33.0.309.g3052b89438-goog
>

Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
