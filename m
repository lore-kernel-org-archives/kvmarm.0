Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1D7C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 10:52:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6AA8610FF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 10:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E6AA8610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B14F4B1C8;
	Fri,  3 Sep 2021 06:52:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8dmzkwyTllnl; Fri,  3 Sep 2021 06:52:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 646BC4B1A5;
	Fri,  3 Sep 2021 06:52:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 596E84B1A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 06:52:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lVNPh4FvZgXM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 06:52:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38DC04B19D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 06:52:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630666321;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=oHeIw9YVmcEgwNcQqJwIRj/uFxtFE2HXVzkecjvqdww=;
 b=hWbMxDgQSWwL9VRnXwOle6CPpBE4B4Nuit+GbW2Aa3W4tQU3uJR3iqbV2XCtwoW/yEXaUu
 UObKZ+RncBi7/hli3itwFGZ0+lhpy6BpNfVcgimxtDU3JKkEhWbndDbEWG/AstORD5Qp6Z
 UBbUgg/c8ZV8KIefdiB8LM6dIJF92WE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-sWBcHOSxNNSA2GGCgVaqHg-1; Fri, 03 Sep 2021 06:51:58 -0400
X-MC-Unique: sWBcHOSxNNSA2GGCgVaqHg-1
Received: by mail-ed1-f70.google.com with SMTP id
 s15-20020a056402520f00b003cad788f1f6so2546574edd.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 03:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oHeIw9YVmcEgwNcQqJwIRj/uFxtFE2HXVzkecjvqdww=;
 b=SVDTZnELrS7YP4JFjNC7pfkTeWKp0PViXVYTXF/zxJi9ZkQOtRXYetVcHRI/IB8fmL
 8Dm+ue3o+szyZUJSjTLEeReZrZeZ4qD1U/wejyHax8YMOjzzxNLPjWVi47mLbcG5nd8b
 AYC0pQz81Vn8JkTWO3zzg8NCMw9Y5WK/ti4Jo7QhGcCl1uCotBecRN7bakSd39BHkFdn
 DdXz3W+UP8DFmTTvEqgdVgRWut8BAfWlizIlIbSWI7j+/GCOjxLlHKt7VwNxTSeHyCMo
 2rbi8ddLfgxOAuMZHyd0Nyr3chzqqBIap5q4rRm/sFoRyaSEr1Wxcdo0yPM4IE6uOpt+
 Qhow==
X-Gm-Message-State: AOAM533uJjT3Fx76KYvty42W+AjQsHc5xoWqoJ28S7cZ3WLH3pNAdsZ6
 d8u/IJuAZPcOyl+zr56WPSRE+ntJVwN4v75jebKVSHhj4OcoNnLLCaV3xmcLka19l7AU/rXav2X
 zAI80gS80WjbiMBDr1Ukkrv5y
X-Received: by 2002:a50:954c:: with SMTP id v12mr3312814eda.313.1630666317336; 
 Fri, 03 Sep 2021 03:51:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyAFfqVO/C7ouLWgxFNht3qcnYfHlmXAIA9oHUIyykzFXWNqs4vtSc2/TiLy4hFCGFZQX0Nw==
X-Received: by 2002:a50:954c:: with SMTP id v12mr3312796eda.313.1630666317122; 
 Fri, 03 Sep 2021 03:51:57 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id d3sm2560762ejw.18.2021.09.03.03.51.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Sep 2021 03:51:56 -0700 (PDT)
Date: Fri, 3 Sep 2021 12:51:55 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: selftests: Add host support for vGIC
Message-ID: <20210903105155.dgu2bi765ngp3pgi@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-11-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-11-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 01, 2021 at 09:14:10PM +0000, Raghavendra Rao Ananta wrote:
> Implement a simple library to do perform vGIC-v3
> setup from a host of view. This includes creating
> a vGIC device, setting up distributor and redistributor
> attributes, and mapping the guest physical addresses.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> 
> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../selftests/kvm/include/aarch64/vgic.h      | 14 ++++
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 67 +++++++++++++++++++
>  3 files changed, 82 insertions(+), 1 deletion(-)
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
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> new file mode 100644
> index 000000000000..45bbf238147a
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> @@ -0,0 +1,14 @@
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
> +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa, uint32_t slot);

Having seen 5 arguments used in the vgic_v3_setup call in the next patch I
came back here to refresh my memory on that parameter. 'slot' is the one I
forgot, but...

> +
> +#endif /* SELFTEST_KVM_VGIC_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> new file mode 100644
> index 000000000000..a0e4b986d335
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM Generic Interrupt Controller (GIC) v3 host support
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/sizes.h>
> +
> +#include "kvm_util.h"
> +
> +#define VGIC_V3_GICD_SZ		(SZ_64K)
> +#define VGIC_V3_GICR_SZ		(2 * SZ_64K)
> +
> +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> +	(((uint64_t)(count) << 52) | \
> +	((uint64_t)((base) >> 16) << 16) | \
> +	((uint64_t)(flags) << 12) | \
> +	index)
> +
> +static void vgic_v3_map(struct kvm_vm *vm, uint64_t addr, unsigned int size)
> +{
> +	unsigned int n_pages = DIV_ROUND_UP(size, vm_get_page_size(vm));
> +
> +	virt_map(vm, addr, addr, n_pages);
> +}
> +
> +/*
> + * vGIC-v3 default host setup
> + *
> + * Input args:
> + *	vm - KVM VM
> + *	nr_vcpus - Number of vCPUs for this VM
> + *	gicd_base_gpa - Guest Physical Address of the Distributor region
> + *	gicr_base_gpa - Guest Physical Address of the Redistributor region
> + *
> + * Output args: None
> + *
> + * Return: GIC file-descriptor or negative error code upon failure
> + *
> + * The function creates a vGIC-v3 device and maps the distributor and
> + * redistributor regions of the guest.
> + */
> +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)

...looks like it was forgotten here too.

Thanks,
drew

> +{
> +	uint64_t redist_attr;
> +	int gic_fd;
> +
> +	TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
> +			"Invalid number of CPUs: %u\n", nr_vcpus);
> +
> +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> +
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> +	vgic_v3_map(vm, gicd_base_gpa, VGIC_V3_GICD_SZ);
> +
> +	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> +	vgic_v3_map(vm, gicr_base_gpa, VGIC_V3_GICR_SZ * nr_vcpus);
> +
> +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	return gic_fd;
> +}
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
