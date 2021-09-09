Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62940C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:34:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEFBC611C7
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 13:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CEFBC611C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 464B64B153;
	Thu,  9 Sep 2021 09:34:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WOz+pM4YxU4L; Thu,  9 Sep 2021 09:34:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C03564B115;
	Thu,  9 Sep 2021 09:34:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FFF74048A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:34:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mkrKwlzHy78M for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 09:34:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6233D402DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 09:34:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631194466;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=2Q7pFBb41mM6ea1MZnjVghiyEWdoCaTiHYJmPRbmHnQ=;
 b=Z8aDLShh1s0kRe4EiMauK5n6/U7dtFYZDLpJUc/ytFT+9DI3losV71SF/KH158S1VVZjGc
 yGyLnrQV7X1CkhZF8TLPAwoLO86y9VazRljPvKbgkFqAcsInX4U6NMoGSeaRbbdra5d2wD
 MAb+L1iCTHsfg8/gc6loRi+TbQc1VmY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-sstOcZFJP36SNWa1b6OvoQ-1; Thu, 09 Sep 2021 09:34:25 -0400
X-MC-Unique: sstOcZFJP36SNWa1b6OvoQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 k5-20020a7bc3050000b02901e081f69d80so775721wmj.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 06:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2Q7pFBb41mM6ea1MZnjVghiyEWdoCaTiHYJmPRbmHnQ=;
 b=k0Fu5sxgzyVR7ya92bnC7JN8BgUMMhFGu0GNsZ/lhyu2tu4wjfmn1AiMkQWnlUtsgG
 Eala3IDpXfU6voVx5uGOVkXdCBwuo/fZey1vNESquMHx2LKcTkuGKwJ7FKJAZJ/6R0gX
 B71Rsh/lyGmdFfXsfEyKd/xZ0Rr9hGAJVIcCKdp6iybMPw4GqMZghcEyLtZUER39N7t/
 EVC5fCvBjPavmhSPy2YUYv/xQeYR1BGCPqU2ELh0dlmK+Pq1GLowpefB0D58I26hG9C8
 +okyDtw0a8melzLmMVTcx965PKCxdAVkAV0Sn7gz8v8WZ+xJ2v7MeNSBh1IKxIwvp9JC
 E7rA==
X-Gm-Message-State: AOAM531aaM2ea0/+EmdLKyc/muokyg5z8LbXcqJStAO/YIhSPa3dYAZN
 qfOqDe952RxUNS1WAHJ7rOEJL9urRwF7E0EFCDdV3fTbU2YxgeVrAc7SVj7lZgWf1ZdL7u4Lm4v
 tUY/TucR1wZlCuFSVXOGSvG3g
X-Received: by 2002:adf:b60f:: with SMTP id f15mr3665003wre.257.1631194463933; 
 Thu, 09 Sep 2021 06:34:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAa/35Y8EeWRcAEuDGOq75zQKTD2hppp6pTHEcWPqQ1zyn1QeYm1M8X/dALPxOElMhuVHRDQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr3664972wre.257.1631194463710; 
 Thu, 09 Sep 2021 06:34:23 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id o10sm2053571wrc.16.2021.09.09.06.34.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 06:34:23 -0700 (PDT)
Date: Thu, 9 Sep 2021 15:34:21 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 14/18] KVM: arm64: selftests: Add host support for vGIC
Message-ID: <20210909133421.rdkueb627glve6uz@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-15-rananta@google.com>
 <YTmce6Xn+ymngA+r@google.com>
MIME-Version: 1.0
In-Reply-To: <YTmce6Xn+ymngA+r@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
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

On Thu, Sep 09, 2021 at 05:32:43AM +0000, Oliver Upton wrote:
> Hi Raghu,
> 
> On Thu, Sep 09, 2021 at 01:38:14AM +0000, Raghavendra Rao Ananta wrote:
> > Implement a simple library to perform vGIC-v3 setup
> > from a host point of view. This includes creating a
> > vGIC device, setting up distributor and redistributor
> > attributes, and mapping the guest physical addresses.
> > 
> > The definition of REDIST_REGION_ATTR_ADDR is taken
> > from aarch64/vgic_init test.
> >
> 
> Consider dropping the macro from vgic_init.c and have it just include
> vgic.h

Yes, I agree 18/18 should be squashed into this one.

> 
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  2 +-
> >  .../selftests/kvm/include/aarch64/vgic.h      | 20 +++++++
> >  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 60 +++++++++++++++++++
> >  3 files changed, 81 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > 
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 5476a8ddef60..8342f65c1d96 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -35,7 +35,7 @@ endif
> >  
> >  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> >  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> > -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
> > +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> >  
> >  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > new file mode 100644
> > index 000000000000..3a776af958a0
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > @@ -0,0 +1,20 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) host specific defines
> > + */
> > +
> > +#ifndef SELFTEST_KVM_VGIC_H
> > +#define SELFTEST_KVM_VGIC_H
> > +
> > +#include <linux/kvm.h>
> > +
> > +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> > +	(((uint64_t)(count) << 52) | \
> > +	((uint64_t)((base) >> 16) << 16) | \
> > +	((uint64_t)(flags) << 12) | \
> > +	index)
> > +
> > +int vgic_v3_setup(struct kvm_vm *vm,
> > +				uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
> > +
> > +#endif /* SELFTEST_KVM_VGIC_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > new file mode 100644
> > index 000000000000..2318912ab134
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -0,0 +1,60 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) v3 host support
> > + */
> > +
> > +#include <linux/kvm.h>
> > +#include <linux/sizes.h>
> > +
> > +#include "kvm_util.h"
> > +#include "vgic.h"
> > +
> > +#define VGIC_V3_GICD_SZ		(SZ_64K)
> > +#define VGIC_V3_GICR_SZ		(2 * SZ_64K)
> 
> These values are UAPI, consider dropping them in favor of the
> definitions from asm/kvm.h

Yes, please.

> 
> > +
> > +/*
> > + * vGIC-v3 default host setup
> > + *
> > + * Input args:
> > + *	vm - KVM VM
> > + *	gicd_base_gpa - Guest Physical Address of the Distributor region
> > + *	gicr_base_gpa - Guest Physical Address of the Redistributor region
> > + *
> > + * Output args: None
> > + *
> > + * Return: GIC file-descriptor or negative error code upon failure
> > + *
> > + * The function creates a vGIC-v3 device and maps the distributor and
> > + * redistributor regions of the guest. Since it depends on the number of
> > + * vCPUs for the VM, it must be called after all the vCPUs have been created.
> 
> You could avoid the ordering dependency by explicitly taking nr_vcpus as
> an arg. It would also avoid the need for 12/18.

All the vcpus need to be created prior to calling
KVM_DEV_ARM_VGIC_CTRL_INIT, so even though I don't disagree with
simply passing nr_vcpus to this function, we should still assert
if the VM's idea of the number doesn't match. But, this is a lib
file, so there's no reason not to do

#include "../kvm_util_internal.h"

and just access the vcpu list to get the count or, if we add a
new internal nr_vcpus member, access it directly. IOW, so far
I don't believe we need vm_get_nr_vcpus().

> 
> Also note the required alignment on the GPA arguments you're taking.
> 
> > + */
> > +int vgic_v3_setup(struct kvm_vm *vm,
> > +		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> > +{
> > +	uint64_t redist_attr;
> > +	int gic_fd, nr_vcpus;
> > +	unsigned int nr_gic_pages;
> > +
> > +	nr_vcpus = vm_get_nr_vcpus(vm);
> > +	TEST_ASSERT(nr_vcpus > 0, "Invalid number of CPUs: %u\n", nr_vcpus);
> > +
> > +	/* Distributor setup */
> > +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > +	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm), VGIC_V3_GICD_SZ);
> > +	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
> > +
> > +	/* Redistributor setup */
> > +	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> > +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> > +	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm),
> > +						VGIC_V3_GICR_SZ * nr_vcpus);
> > +	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
> > +
> > +	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > +				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > +
> > +	return gic_fd;
> > +}
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
