Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73CDC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 20:48:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29502610D2
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 20:48:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 29502610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C244B212;
	Fri,  3 Sep 2021 16:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yiy-D+FqLT82; Fri,  3 Sep 2021 16:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DCBE4B1E4;
	Fri,  3 Sep 2021 16:48:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C23714B17B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 16:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RsD8UiWhGhWf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 16:48:19 -0400 (EDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com
 [209.85.219.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DEFD49DE7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 16:48:19 -0400 (EDT)
Received: by mail-yb1-f177.google.com with SMTP id e131so783686ybb.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 13:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=jdumqdU9gNUc/p8x91c5FNRB2/icYIsDIBk+jupJSu0=;
 b=NWyK5pOQlXzw905KW8xs5oC0JiBsnohXgutz955HmXNdNbbfMyIIULufhAGSkJVOCY
 zjGyPA8gstB36oX7lPvPYgm7xM4O4QG21trj1UJYpXc6FHml6UwLrs4EjobqpWmLg+cU
 w1tqVEi2Ntgw8zF+WLhtAHZsQAnOwaLoK5xTqV+Rws3XvCDwcOp27DTmrbNAxFW86lB0
 s+FS2z3eem+dKeJOt/6WN0RBU6uA/4lDov8saHgbQNT8fKZCrhmXLTDBHZ9vMFNs9Cxn
 oW9g19Juw6ODzXfGomrWWXE8Ru2UBGKImLQ73dRVUwIJwhmWqTpMBBZ8gFQeNvYRstCZ
 Rhqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=jdumqdU9gNUc/p8x91c5FNRB2/icYIsDIBk+jupJSu0=;
 b=myksiKkOz4iuqMOwi2LJNmP7EJL1xnEKgsXb9IEz87+gyuD+pvK+cdUB5WSvqW9Pzi
 E49eaPuYzoDty2sxFE8Tn6sOBqVgTpY0aFQ88pIZYKncnPDh60XjL4cfmE0yz80X9+gI
 +sVmB7nyRFrH41/7UoM0eJHY/fxN63wQLHYT+VDSfsWNqXOdoV2tJHaP/Z376lKwVfuW
 NUlBWArb9sYvgxfQDYxa7iN+p6fP6dFa3UMYu6Slrx2SQ/HJ9KhIbWnwWdT8F0VSj4pD
 r8AgQM3QGMPIHOrx8CHhdO8xabxwvVlwvoE5a1Rc1nI/CUKX0B39w0iY3/j+n2xdMuMY
 s7Dg==
X-Gm-Message-State: AOAM530Jvw8mQEjqwBU0Ytjfs712ccGPZbCUwO69eEMVQqDzPzzPfY2n
 Ti2C+XMJ/Urr1adPYCyYp5dQvSIrTDwebfHQupjphg==
X-Google-Smtp-Source: ABdhPJyuepYTpoYmEXPzK6HgxRPVtcxlu73WiwhNSpb1n3TcEnYmF7orWnAI3JSDsNV/K05sXAkceQ9pKbT1jr72OGE=
X-Received: by 2002:a25:2007:: with SMTP id g7mr1255987ybg.434.1630702098466; 
 Fri, 03 Sep 2021 13:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-11-rananta@google.com>
 <20210903105155.dgu2bi765ngp3pgi@gator.home>
In-Reply-To: <20210903105155.dgu2bi765ngp3pgi@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 3 Sep 2021 13:48:05 -0700
Message-ID: <CAJHc60yVDYUPCj2W6fhq6JkzxhPwCPON2M9vL44XNDTObRa1dA@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: selftests: Add host support for vGIC
To: Andrew Jones <drjones@redhat.com>
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

On Fri, Sep 3, 2021 at 3:52 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 09:14:10PM +0000, Raghavendra Rao Ananta wrote:
> > Implement a simple library to do perform vGIC-v3
> > setup from a host of view. This includes creating
> > a vGIC device, setting up distributor and redistributor
> > attributes, and mapping the guest physical addresses.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  2 +-
> >  .../selftests/kvm/include/aarch64/vgic.h      | 14 ++++
> >  .../testing/selftests/kvm/lib/aarch64/vgic.c  | 67 +++++++++++++++++++
> >  3 files changed, 82 insertions(+), 1 deletion(-)
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
> > index 000000000000..45bbf238147a
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
> > @@ -0,0 +1,14 @@
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
> > +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> > +             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa, uint32_t slot);
>
> Having seen 5 arguments used in the vgic_v3_setup call in the next patch I
> came back here to refresh my memory on that parameter. 'slot' is the one I
> forgot, but...
>
> > +
> > +#endif /* SELFTEST_KVM_VGIC_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > new file mode 100644
> > index 000000000000..a0e4b986d335
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -0,0 +1,67 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * ARM Generic Interrupt Controller (GIC) v3 host support
> > + */
> > +
> > +#include <linux/kvm.h>
> > +#include <linux/sizes.h>
> > +
> > +#include "kvm_util.h"
> > +
> > +#define VGIC_V3_GICD_SZ              (SZ_64K)
> > +#define VGIC_V3_GICR_SZ              (2 * SZ_64K)
> > +
> > +#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
> > +     (((uint64_t)(count) << 52) | \
> > +     ((uint64_t)((base) >> 16) << 16) | \
> > +     ((uint64_t)(flags) << 12) | \
> > +     index)
> > +
> > +static void vgic_v3_map(struct kvm_vm *vm, uint64_t addr, unsigned int size)
> > +{
> > +     unsigned int n_pages = DIV_ROUND_UP(size, vm_get_page_size(vm));
> > +
> > +     virt_map(vm, addr, addr, n_pages);
> > +}
> > +
> > +/*
> > + * vGIC-v3 default host setup
> > + *
> > + * Input args:
> > + *   vm - KVM VM
> > + *   nr_vcpus - Number of vCPUs for this VM
> > + *   gicd_base_gpa - Guest Physical Address of the Distributor region
> > + *   gicr_base_gpa - Guest Physical Address of the Redistributor region
> > + *
> > + * Output args: None
> > + *
> > + * Return: GIC file-descriptor or negative error code upon failure
> > + *
> > + * The function creates a vGIC-v3 device and maps the distributor and
> > + * redistributor regions of the guest.
> > + */
> > +int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
> > +             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
>
> ...looks like it was forgotten here too.
>
You are right. I had 'slot' to try other mechanisms, but I guess I
forgot to clean it up.
Thanks for catching this.

Regards,
Raghavendra

> Thanks,
> drew
>
> > +{
> > +     uint64_t redist_attr;
> > +     int gic_fd;
> > +
> > +     TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
> > +                     "Invalid number of CPUs: %u\n", nr_vcpus);
> > +
> > +     gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > +     vgic_v3_map(vm, gicd_base_gpa, VGIC_V3_GICD_SZ);
> > +
> > +     redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> > +     vgic_v3_map(vm, gicr_base_gpa, VGIC_V3_GICR_SZ * nr_vcpus);
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > +                             KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > +
> > +     return gic_fd;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
