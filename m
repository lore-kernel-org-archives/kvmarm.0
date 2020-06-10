Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3A2C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72F0B20812
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="W6J9UkKF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72F0B20812
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3804B1DD;
	Thu, 11 Jun 2020 03:22:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4mRSIjcuzPaF; Thu, 11 Jun 2020 03:22:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E45E4B1D3;
	Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE7B34B159
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 17:58:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VJEotSuWX7lg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 17:58:33 -0400 (EDT)
Received: from mail-vs1-f67.google.com (mail-vs1-f67.google.com
 [209.85.217.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D8074B14B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 17:58:33 -0400 (EDT)
Received: by mail-vs1-f67.google.com with SMTP id o2so2259005vsr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 14:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Q55NYjy9IRmkKRciGyl293b435BFJrXWdUL8I09kIMU=;
 b=W6J9UkKFqBOh6IZVBDPOthBCXab0QZziKeEa8pn13Vr5J8K7h1X58Xb6OmuCCjEhOb
 92gem+OhVNk7kSF2F0BUdLkFKKg5ROVVbpsqxDgCpafDITiIZamI2Vry6Aog71jIZo8h
 NiD26bt+GKRoofdVOB/75RW7uwmApZl8QFmK1s6MT//oW9G+svD3zlytHSextcXbDuOv
 y9pQW8NIgzMZzDeYq/95xGCrFZR1LNU3HnOc4zwE/u+v8axp4rGvGkkNauOwDQCqQjf9
 2j8VU13YtK2Z4G+LXtKQblPwmmZ0YbNkS/g2LzBxhn7LOE6G4a9uJFutNjZyOutkrtp+
 BPZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Q55NYjy9IRmkKRciGyl293b435BFJrXWdUL8I09kIMU=;
 b=a2ugePjA2I2yHTwVc7cRP6NhsNAkFtMDPKIkGt3j2VJDbrfGrOOoJqXJ+k9vAHe6uy
 da2R/rAVnYqKd0Qd4VibPRaJTGbgnOSAx7wjvQQoAEDUrW9PTWlTA6EEdzA3YC73wxVJ
 xmWAyl2H0HIbD4IbjBVQGXPMf70lMt4K2H+wuAUvX1Xsn8Hklse+80tNiB6V+PF4CUse
 30OASsYnn5Lm7c3ZFF7MlKJPo8WWkX7XsR19fvWXTl0R3B6aTD+i+Za52Tv41IuBJ8t0
 TXFuwYBrj4lBeWkIb+FQ3pHfgumsV5jL3ItRF/4hglCLr27Qe+BrS0bBsi/HjmNbLFo7
 ziHg==
X-Gm-Message-State: AOAM533xnReAJd6IIiQdqZxQADExuJJP+oHAM7RQXo/m//AZbVi6A3QO
 WtJZXCqCEvTAfq/0fVcv7fq27pWZbna1VrJmCTWZzw==
X-Google-Smtp-Source: ABdhPJw6lF5ItCEwInvZaqrMjCHdyoCSi+CaoOEbwdfTwpuV0Gz1ZwsXr/d3YOGarQap09er1s6bIDnIsVVF9gciZiY=
X-Received: by 2002:a67:f982:: with SMTP id b2mr4385200vsq.202.1591826312742; 
 Wed, 10 Jun 2020 14:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-15-sean.j.christopherson@intel.com>
 <CANgfPd_v31zC5-mKsT14hd7W=X2Pvg3RBPjn2d4tFSChdbsr3A@mail.gmail.com>
In-Reply-To: <CANgfPd_v31zC5-mKsT14hd7W=X2Pvg3RBPjn2d4tFSChdbsr3A@mail.gmail.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 14:58:21 -0700
Message-ID: <CANgfPd-iH8AShSPPJiaDCxV1H76kfpTOQMZSMP_+nP3LoXbYBg@mail.gmail.com>
Subject: Re: [PATCH 14/21] KVM: Move x86's version of struct
 kvm_mmu_memory_cache to common code
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Thu, 11 Jun 2020 03:22:32 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Wed, Jun 10, 2020 at 12:01 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Move x86's 'struct kvm_mmu_memory_cache' to common code in anticipation
> > of moving the entire x86 implementation code to common KVM and reusing
> > it for arm64 and MIPS.  Add a new architecture specific asm/kvm_types.h
> > to control the existence and parameters of the struct.  The new header
> > is needed to avoid a chicken-and-egg problem with asm/kvm_host.h as all
> > architectures define instances of the struct in their vCPU structs.
> >
> > Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_types.h   |  6 ++++++
> >  arch/mips/include/asm/kvm_types.h    |  5 +++++
> >  arch/powerpc/include/asm/kvm_types.h |  5 +++++
> >  arch/s390/include/asm/kvm_types.h    |  5 +++++
> >  arch/x86/include/asm/kvm_host.h      | 13 -------------
> >  arch/x86/include/asm/kvm_types.h     |  7 +++++++
> >  include/linux/kvm_types.h            | 19 +++++++++++++++++++
> >  7 files changed, 47 insertions(+), 13 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/kvm_types.h
> >  create mode 100644 arch/mips/include/asm/kvm_types.h
> >  create mode 100644 arch/powerpc/include/asm/kvm_types.h
> >  create mode 100644 arch/s390/include/asm/kvm_types.h
> >  create mode 100644 arch/x86/include/asm/kvm_types.h
> >
> > diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..d0987007d581
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_types.h
> > @@ -0,0 +1,6 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_ARM64_KVM_TYPES_H
> > +#define _ASM_ARM64_KVM_TYPES_H
> > +
> > +#endif /* _ASM_ARM64_KVM_TYPES_H */
> > +
> > diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..5efeb32a5926
> > --- /dev/null
> > +++ b/arch/mips/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_MIPS_KVM_TYPES_H
> > +#define _ASM_MIPS_KVM_TYPES_H
> > +
> > +#endif /* _ASM_MIPS_KVM_TYPES_H */
> > diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..f627eceaa314
> > --- /dev/null
> > +++ b/arch/powerpc/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_POWERPC_KVM_TYPES_H
> > +#define _ASM_POWERPC_KVM_TYPES_H
> > +
> > +#endif /* _ASM_POWERPC_KVM_TYPES_H */
> > diff --git a/arch/s390/include/asm/kvm_types.h b/arch/s390/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..b66a81f8a354
> > --- /dev/null
> > +++ b/arch/s390/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_S390_KVM_TYPES_H
> > +#define _ASM_S390_KVM_TYPES_H
> > +
> > +#endif /* _ASM_S390_KVM_TYPES_H */
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index fb99e6776e27..8e8fea13b6c7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -193,8 +193,6 @@ struct x86_exception;
> >  enum x86_intercept;
> >  enum x86_intercept_stage;
> >
> > -#define KVM_NR_MEM_OBJS 40
> > -
Oops I didn't catch this on my first read through, but in patch 16 in
this series I see some references to KVM_NR_MEM_OBJS being removed. As
a result I would not expect this patch to build. Other references to
this value should probably replaced with
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE as well.
> >  #define KVM_NR_DB_REGS 4
> >
> >  #define DR6_BD         (1 << 13)
> > @@ -245,17 +243,6 @@ enum x86_intercept_stage;
> >
> >  struct kvm_kernel_irq_routing_entry;
> >
> > -/*
> > - * We don't want allocation failures within the mmu code, so we preallocate
> > - * enough memory for a single page fault in a cache.
> > - */
> > -struct kvm_mmu_memory_cache {
> > -       int nobjs;
> > -       gfp_t gfp_zero;
> > -       struct kmem_cache *kmem_cache;
> > -       void *objects[KVM_NR_MEM_OBJS];
> > -};
> > -
> >  /*
> >   * the pages used as guest page table on soft mmu are tracked by
> >   * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
> > diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..08f1b57d3b62
> > --- /dev/null
> > +++ b/arch/x86/include/asm/kvm_types.h
> > @@ -0,0 +1,7 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_X86_KVM_TYPES_H
> > +#define _ASM_X86_KVM_TYPES_H
> > +
> > +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > +
> > +#endif /* _ASM_X86_KVM_TYPES_H */
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 68e84cf42a3f..a7580f69dda0 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -20,6 +20,8 @@ enum kvm_mr_change;
> >
> >  #include <linux/types.h>
> >
> > +#include <asm/kvm_types.h>
> > +
> >  /*
> >   * Address types:
> >   *
> > @@ -58,4 +60,21 @@ struct gfn_to_pfn_cache {
> >         bool dirty;
> >  };
> >
> > +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> > +/*
> > + * Memory caches are used to preallocate memory ahead of various MMU flows,
> > + * e.g. page fault handlers.  Gracefully handling allocation failures deep in
> > + * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> > + * holding MMU locks.  Note, these caches act more like prefetch buffers than
> > + * classical caches, i.e. objects are not returned to the cache on being freed.
> > + */
> > +struct kvm_mmu_memory_cache {
> > +       int nobjs;
> > +       gfp_t gfp_zero;
> > +       struct kmem_cache *kmem_cache;
> > +       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> > +};
> > +#endif
> > +
> > +
> >  #endif /* __KVM_TYPES_H__ */
> > --
> > 2.26.0
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
