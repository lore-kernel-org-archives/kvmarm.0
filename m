Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB811C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 17:59:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 34A48610E6
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 17:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 34A48610E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B558A4B0C3;
	Thu,  2 Sep 2021 13:59:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wik4w5hzYfJv; Thu,  2 Sep 2021 13:59:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D03314B0F7;
	Thu,  2 Sep 2021 13:59:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57CB24B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 13:59:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g-7y5gF2zKCe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 13:59:22 -0400 (EDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com
 [209.85.219.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19D214B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 13:59:22 -0400 (EDT)
Received: by mail-yb1-f179.google.com with SMTP id a93so5520447ybi.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=I6lNmz1ZHPNmtMHcGebqNi31a0bwccl3naNODv57iB0=;
 b=hBowUWs5ABee1O6qSaIcb6Azek8v4ILJhEmiOTmf2XcZFin/3vVoktd+dfRrLP9HfS
 hM4m55PRK0rVzr030c/PL04yUtTQ2jPcHp1rubY12nnMKEkLVCCQtVChTYRS8k329YuF
 vCOt3jQI0Jb/qyYgEUCL5wPG2X1fblZWZ8LLoO+Esc5rIVSxYpUpkNiv1g8f+9+bc6HF
 9BR9ErUyBkxwNWd3yIROJd2r0lPpcEsJzQKoEdsAHj4ixE4i41o/gn6LLnOuoc8I+6df
 xxk9yXBkTMNySknd7yExpoyAn/6oRHph3/oYLLL2+oY/ryvO+Rm9Sn6ab0AWZH7HSKa1
 UhYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=I6lNmz1ZHPNmtMHcGebqNi31a0bwccl3naNODv57iB0=;
 b=B/C1XkCJyoWOcjBAotLnF5UsS+2LKpLbl0hiigHDeYap3DPqvhfsgf6q5LzCCEOXT6
 1AiXTI/nAT76ZO9fKkeGb+EBUDACVM12kaPxv07SLaPbdMH+eTL/p3TpfZ5Pj/ljNPyd
 vnlcbHd2ggw6+g7cw7zT3ZiZHG0QzkDUIvgW/6DbAhS+5ZCy9BDyT2sja//5V+HzBmyV
 v/mqHqoAFFYIKZw2TRjXNHa4mLUQ+1PsbADpEiAL4klqItYeaXYHv3KewaGDFlFU88f0
 gT4QCre5TllfSCzm4rPPU9/fL5iESgshsYUNG9e8w6t+ZoLD2itPkd0JI6A+wiryvhaH
 Zu3g==
X-Gm-Message-State: AOAM532k+5Ni9zq14z0tF7DGpo+uRyBTjwtoJNJR02p+I0Qp9M/6BKzR
 IyWn8f3bHx7AbqVNQr8s83d9YDdKOxR26nUPSDRgUg==
X-Google-Smtp-Source: ABdhPJwU2Al1PvBzdSgmpnQsQopc50AvxUK0PW3IjKLQDYe5gecpLFlqArUCMUIPs+Id17BVGWtI+q72jBUHYsGgTpY=
X-Received: by 2002:a25:38ce:: with SMTP id f197mr5816802yba.254.1630605561360; 
 Thu, 02 Sep 2021 10:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-11-rananta@google.com>
 <YTEJt2pC1cIcwvyD@google.com>
In-Reply-To: <YTEJt2pC1cIcwvyD@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 2 Sep 2021 10:59:10 -0700
Message-ID: <CAJHc60zR8q28kvbpB2USeVR154OzKLQuZOFSOOOsW0WrqD0OEw@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: selftests: Add host support for vGIC
To: Ricardo Koller <ricarkol@google.com>
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

On Thu, Sep 2, 2021 at 10:28 AM Ricardo Koller <ricarkol@google.com> wrote:
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
> > +{
> > +     uint64_t redist_attr;
> > +     int gic_fd;
> > +
> > +     TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
> > +                     "Invalid number of CPUs: %u\n", nr_vcpus);
> > +
> > +     gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
>
> Nit: you can return early if gic_fd is bad.
>
kvm_create_device() already takes care of this and the test would
simply fail if gic_fd was bad.
So, I think we can positively move on :)
> > +
> > +     kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > +                     KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
> > +     vgic_v3_map(vm, gicd_base_gpa, VGIC_V3_GICD_SZ);
>
> vgic_v3_map() implies that it's doing something vgic specific, when it's
> just converting bytes to pages. What about something like the following?
>
>         virt_map(vm, addr, addr, VM_BYTES_TO_PAGES(vm, VGIC_V3_GICD_SZ));
>
> and you add a VM_BYTES_TO_PAGES macro to include/kvm_util.h? I think
> this macro can be useful to others.
>
Yeah, good idea. Will do.

Regards,
Raghavendra
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
