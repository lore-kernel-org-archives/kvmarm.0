Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED58C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:21:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A5216113E
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A5216113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 188614B156;
	Thu,  9 Sep 2021 13:21:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xgWL8c1plDcs; Thu,  9 Sep 2021 13:21:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0C2A4B154;
	Thu,  9 Sep 2021 13:21:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE5C4B154
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:21:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOkx0O8iiOWZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 13:21:02 -0400 (EDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7204F4B121
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:21:02 -0400 (EDT)
Received: by mail-yb1-f176.google.com with SMTP id c206so5340744ybb.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 10:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Yk1xRCHa7oe+DYf+9hvXu4dgI0POdHNG4LTk33BEmSw=;
 b=mALGXMTn96O2epfdF+bedTHCxwZJaAfI7GnQx+Oo9vDJDY9dCMb8NKwL7hNgBwYC7H
 +wZelSPSgGy28NSgrim0e+CAyEcWnfauA12PfCBgT0VXgHqLwUqNwNb5feQ3d40a1+Dn
 Mpm4Mh0eomv988vE2Ocb+EjRf574xnBzOfTpkizk3t4n3IM/rPknN69vfoUfPBG2UCt3
 MPTdqOt9FcvgNnYbizlCnyCYA8tWHNmWDWKNOs+2Yz9erLSQ/9DW8chtDzMNqicEWoeA
 9WrUolRpiv2YuP2hsxjl3ujY2wwSlRAfsjdFYMkAMGIFIdv1JFnOAjaYJ37ec9QuP4Yx
 fldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Yk1xRCHa7oe+DYf+9hvXu4dgI0POdHNG4LTk33BEmSw=;
 b=m7e3IrqIsXJPwlRX/F/2mlPPjVNJ6fj3BDcVfK2s7mzSGk7Tt1/IB3e2KugujvNjms
 V1gQpXbOex7PeuNqSZ83arvSW5XVOBG31C1mxvs44oeMiQvITK3ni+GvJPqXlhjV7F4K
 Imxc7KMpznPc2i6SrzPA/JDuSQ8r9UiibnufN0ujYXD86P0+oKFRKfGIYDW1V6VoJkKB
 BipwgghStqGj9xEjSd6C6DkbNiRoeZhMr0DkHBoK/761Ox1prhND8IAXER7FuTMATmYU
 5B5BhLXeOCn6AtZkBoxBXrJ0W/iuBeVeDWEglYa+SlaAXr5QO6lkaMFagI+AH9hKCnLQ
 EHFQ==
X-Gm-Message-State: AOAM531HYonu5ni8kep+Fh/77x3AoaIKCrZkIqoRt1I1jqOJWtAojGwJ
 dWALK5qrljwniDJH3Q0oTuJk/mMzIvGS6IUJ53RqLw==
X-Google-Smtp-Source: ABdhPJxA+qKZtjUOncYqYLOYKJryq5SW7oK8uVt1u8oOXgMFawG4AMBXZi67DCvZzE4IlyJ+03LuU+yuYgkqdVYnM2s=
X-Received: by 2002:a25:ab44:: with SMTP id u62mr5186947ybi.335.1631208061767; 
 Thu, 09 Sep 2021 10:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-15-rananta@google.com>
 <YTmce6Xn+ymngA+r@google.com>
In-Reply-To: <YTmce6Xn+ymngA+r@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 10:20:50 -0700
Message-ID: <CAJHc60z-q6vsKNuJ0_xab_1F1qxWcte4PYO-8tmMCo49VVg-nA@mail.gmail.com>
Subject: Re: [PATCH v4 14/18] KVM: arm64: selftests: Add host support for vGIC
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 8, 2021 at 10:32 PM Oliver Upton <oupton@google.com> wrote:
>
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
> > +     (((uint64_t)(count) << 52) | \
> > +     ((uint64_t)((base) >> 16) << 16) | \
> > +     ((uint64_t)(flags) << 12) | \
> > +     index)
> > +
> > +int vgic_v3_setup(struct kvm_vm *vm,
> > +                             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
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
> > +#define VGIC_V3_GICD_SZ              (SZ_64K)
> > +#define VGIC_V3_GICR_SZ              (2 * SZ_64K)
>
> These values are UAPI, consider dropping them in favor of the
> definitions from asm/kvm.h
>
> > +
> > +/*
> > + * vGIC-v3 default host setup
> > + *
> > + * Input args:
> > + *   vm - KVM VM
> > + *   gicd_base_gpa - Guest Physical Address of the Distributor region
> > + *   gicr_base_gpa - Guest Physical Address of the Redistributor region
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
>
Well I guess I was focusing on Andrew's comment on v3 10/12,
"TEST_ASSERT(!list_empty(&vm->vcpus), ...) to ensure we've created
vcpus first. To be really paranoid we could even confirm the number of
vcpus in the list matches nr_vcpus."
So, instead of just getting the arg from the caller and doing all the
fancy checks, I figured let vgic_v3_setup() learn this on its own,
which made me define vm_get_nr_vcpus().

Regards,
Raghavendra

> Also note the required alignment on the GPA arguments you're taking.
>
> > + */
> > +int vgic_v3_setup(struct kvm_vm *vm,
> > +             uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
> > +{
> > +     uint64_t redist_attr;
> > +     int gic_fd, nr_vcpus;
> > +     unsigned int nr_gic_pages;
> > +
> > +     nr_vcpus = vm_get_nr_vcpus(vm);
> > +     TEST_ASSERT(nr_vcpus > 0, "Invalid number of CPUs: %u\n", nr_vcpus);
> > +
> > +     /* Distributor setup */
> > +     gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > +     nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm), VGIC_V3_GICD_SZ);
> > +     virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
> > +
> > +     /* Redistributor setup */
> > +     redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
> > +     nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm),
> > +                                             VGIC_V3_GICR_SZ * nr_vcpus);
> > +     virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> > +                             KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> > +
> > +     return gic_fd;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
