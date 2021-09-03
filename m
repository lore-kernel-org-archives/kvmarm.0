Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F821C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 20:46:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D98B2600CC
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 20:46:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D98B2600CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 539864B215;
	Fri,  3 Sep 2021 16:46:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dwAm2HjydAX1; Fri,  3 Sep 2021 16:46:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 160C94B1DB;
	Fri,  3 Sep 2021 16:46:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B0D4B191
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 16:46:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8piTkSXz4Bl5 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 16:46:01 -0400 (EDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com
 [209.85.219.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 512564B17B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 16:46:01 -0400 (EDT)
Received: by mail-yb1-f169.google.com with SMTP id c6so752499ybm.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 13:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kzulTbYinCcR11pDJdzRGn8oPiWnTihEe16/yeEf5xc=;
 b=XWg1xQcEqy8AyCjf6nSYusGBje7hJ7ELSYUb1Eh3o2jLDF6NEu2FFcKBkxiD1AT51a
 i5P2T6WRvpcaZxPoBhn406OR80qdDS2YWyxRbWMz+XPrcPd3Q/rQaD37LhAnws4hvRMn
 xBPu/Fn11ukxdV2rbyRqDTs1JEML6qq47qgUN9nO1Vkazo+7XhOHfgtPnbLGz8OI779e
 PRxyAwcqADABqmBQtJsxX7QeUz+WpcvLPXmaY4L0UML2LtG4AsAFNgVNYfr3Qi5QrN7S
 yZTK7ecKeXjd8zdqNGMYTnsF7dPzyMiKeN5Zx3RTs0Zyh5opVidaNwKoz0v3xNn4V76g
 gyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kzulTbYinCcR11pDJdzRGn8oPiWnTihEe16/yeEf5xc=;
 b=guslrPIK23wUT12APe64hJ2KLnPGBvZaFOpUeYfnuTt/9SORyGot84t95x8izsJy4k
 W4b4DwnU79OplBKeQV+GybALfGdGT+LeGrs420IrEesFuGhIWUyCuTiCXgwdjviFfHYS
 GEWZf3g+Zzt8uZd+e4w77/GfcVi6A/wh27ZKv0b6tiqOXyOHRgu4yAncHLyGDVGJgAb8
 cC0NWZQc1ZVCOAdTfD2N3m9xV4CYbgg4GJmj4C1g4u4WR+CyYdls8deq0HpEQJpvSuUO
 CNlyhDwP2eDawv1rz5sJjr3YVkrZZqy48C7qKcP0cN9Mzvt80f5fSEOFUmJxbItP0OdG
 DqOA==
X-Gm-Message-State: AOAM530JRpMHl8Hisk8ZJAG9eYMusE78+CFsHyYAAqnTbDUKZu8cWGDR
 h3qaPtBFZKnpNMXsqVPNa0+iHEPPAqu9FMoV4r9h1w==
X-Google-Smtp-Source: ABdhPJxeHeESiJAghEHTj0gTD1ujj5k2ZYlYp8Q63ZKLIx+d+NM2zNaGNw3BjWA6VMD3pkCCSZs98ZEMNfOynzJl4cs=
X-Received: by 2002:a25:af81:: with SMTP id g1mr1126405ybh.457.1630701960546; 
 Fri, 03 Sep 2021 13:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-11-rananta@google.com>
 <20210903100031.hptfzo5vqsgjteod@gator.home>
In-Reply-To: <20210903100031.hptfzo5vqsgjteod@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 3 Sep 2021 13:45:47 -0700
Message-ID: <CAJHc60wD1UA0U8ydEH1Xnc6ns8jxJ4CEaoK3zXaAjDQR2SR0AA@mail.gmail.com>
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

On Fri, Sep 3, 2021 at 3:00 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 09:14:10PM +0000, Raghavendra Rao Ananta wrote:
> > Implement a simple library to do perform vGIC-v3
>
> s/do//
>
> > setup from a host of view.
>                    ^ point
>
> > This includes creating
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
>
> This could go in vgic.h allowing us to share it in aarch64/vgic_init.c,
> where we already have the same definition.
>
Sure, I will move this.

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
> > +{
> > +     uint64_t redist_attr;
> > +     int gic_fd;
> > +
> > +     TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
> > +                     "Invalid number of CPUs: %u\n", nr_vcpus);
>
> TEST_ASSERT(!list_empty(&vm->vcpus), ...) to ensure we've created vcpus
> first. To be really paranoid we could even confirm the number of vcpus in
> the list matches nr_vcpus.
>
Great idea! I'll add these checks too.

Regards
Raghavendra
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
>
> Otherwise
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
