Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF9CC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 09:41:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 441364C43E;
	Wed, 23 Feb 2022 04:41:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KMZZFEZ0nVJQ; Wed, 23 Feb 2022 04:41:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BB464C441;
	Wed, 23 Feb 2022 04:41:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D21664C43C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 04:41:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zcfYwRbHvsL7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 04:41:33 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BD834C43A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 04:41:33 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id d28so10803584wra.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 01:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tl3Q6tIjcFKq2GHD2bvKaW/A92aDkBq4WVoWmAd0uPw=;
 b=Nq5hT2/yKVKP5JdJPHIXKoNrs3VVER/3ThbIAUDjyZLMU7BdABRaKfDHJbHabFIhPi
 IQ1apSYMFHwjY3ohe+zU3nKHE2QgSItGPJYL+czcy1VQdUz3BNtFa5zzodB/4vOCsdPn
 ZVuHgRiBImsFUpNP5Y0SMCWaBqk6p1FH5q+uKI0l/LmwKkXQfYzil0WU8Mz8rpIsjBIe
 JhY85xILuxfR5qZ4VJ2e7AovoLisKcgylKwfmyCyvqGK8iAZicPn9m8E1QzzetWFHoOq
 0vgZo4yX74ahAqxq3QVe5zYH9PEhVPld/9pNWLF8k4P8Yf25NjmNGtTgudE0JUE4s0gO
 EDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tl3Q6tIjcFKq2GHD2bvKaW/A92aDkBq4WVoWmAd0uPw=;
 b=z0AJN3GubNJOTNKqCrCCPtgapJkX3JCJnHFfXKmog3vBmD5dhAdaJgUly7infpr6YJ
 b3I1f7uQsDlV7biuLR6g/sJDF6H6oMtASjWVQD45ZVoEjOFR1Yej1pL9vteYBieGxhBM
 oCrMGciEZzaCiVubeiiArtkJavuPy0M5JLC0T+ZfayetXDEpqdMbdWvPF6Wj5zcQXl7I
 6CWGuYQNt455i2TYIJVJXXhuNscYGlZXeHWx4Oshg1URCZ06mQUkIYiL0E0uUc1ahaXT
 OZ0rm0lRR0V9/XVaoCMfC8Nj7IYHK4O081Z863Zk+U74k5ODlOZWQMwZfhBqj2I9mYpx
 idlQ==
X-Gm-Message-State: AOAM530DLYFFbsjMlY4rdcSTC63+h3+vghGbmP9AOfrZTq91HR76/8Ni
 KfaX2xQqVpGFO49/rQ86VdQayg==
X-Google-Smtp-Source: ABdhPJw1cx5A+OZgagGGL2+5Y9HR5kcIQLAYm5xK8QWZ6Q7yX2St2YlMmahoyUS6+v+wnwRtWEvtYQ==
X-Received: by 2002:a5d:64e7:0:b0:1e4:bb8b:d3eb with SMTP id
 g7-20020a5d64e7000000b001e4bb8bd3ebmr22498610wri.403.1645609290486; 
 Wed, 23 Feb 2022 01:41:30 -0800 (PST)
Received: from google.com (203.75.199.104.bc.googleusercontent.com.
 [104.199.75.203])
 by smtp.gmail.com with ESMTPSA id l12sm53801683wrs.11.2022.02.23.01.41.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Feb 2022 01:41:30 -0800 (PST)
Date: Wed, 23 Feb 2022 09:41:28 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v3] aarch64: Add stolen time support
Message-ID: <YhYBSB4wP3NXIgS6@google.com>
References: <YhS2Htrzwks/allO@google.com>
 <YhTsGfoAh4NDo8+j@monolith.localdoman>
 <d5a3d28a964813bd28c79c63e8e3b247@kernel.org>
 <YhTy9j+4HIsnrsSG@monolith.localdoman>
 <2772b40f99a30ecd475fa83641d40994@kernel.org>
 <YhT4UJ99SXCx0YlM@monolith.localdoman>
 <20220222171558.1a77d501@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220222171558.1a77d501@donnerap.cambridge.arm.com>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Feb 22, 2022 at 05:15:57PM +0000, Andre Przywara wrote:
> On Tue, 22 Feb 2022 14:50:56 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> > Hi,
> > 
> > On Tue, Feb 22, 2022 at 02:35:24PM +0000, Marc Zyngier wrote:
> > > On 2022-02-22 14:28, Alexandru Elisei wrote:  
> > > > Hi,
> > > > 
> > > > On Tue, Feb 22, 2022 at 02:18:40PM +0000, Marc Zyngier wrote:  
> > > > > On 2022-02-22 13:58, Alexandru Elisei wrote:  
> > > > > > Hi,
> > > > > >
> > > > > > On Tue, Feb 22, 2022 at 10:08:30AM +0000, Sebastian Ene wrote:  
> > > > > > > This patch adds support for stolen time by sharing a memory region
> > > > > > > with the guest which will be used by the hypervisor to store the
> > > > > > > stolen
> > > > > > > time information. The exact format of the structure stored by the
> > > > > > > hypervisor is described in the ARM DEN0057A document.
> > > > > > >
> > > > > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > > > > ---
> > > > > > >  Changelog since v2:
> > > > > > >  - Moved the AARCH64_PVTIME_* definitions from arm-common/kvm-arch.h
> > > > > > > to
> > > > > > >    arm64/pvtime.c as pvtime is only available for arm64.
> > > > > > >
> > > > > > >  Changelog since v1:
> > > > > > >  - Removed the pvtime.h header file and moved the definitions to
> > > > > > > kvm-cpu-arch.h
> > > > > > >    Verified if the stolen time capability is supported before
> > > > > > > allocating
> > > > > > >    and mapping the memory.
> > > > > > >
> > > > > > >  Makefile                               |  1 +
> > > > > > >  arm/aarch64/arm-cpu.c                  |  1 +
> > > > > > >  arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
> > > > > > >  arm/aarch64/pvtime.c                   | 89
> > > > > > > ++++++++++++++++++++++++++
> > > > > > >  arm/kvm-cpu.c                          | 14 ++--
> > > > > > >  5 files changed, 99 insertions(+), 7 deletions(-)
> > > > > > >  create mode 100644 arm/aarch64/pvtime.c
> > > > > > >
> > > > > > > diff --git a/Makefile b/Makefile
> > > > > > > index f251147..e9121dc 100644
> > > > > > > --- a/Makefile
> > > > > > > +++ b/Makefile
> > > > > > > @@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
> > > > > > >  	OBJS		+= arm/aarch64/arm-cpu.o
> > > > > > >  	OBJS		+= arm/aarch64/kvm-cpu.o
> > > > > > >  	OBJS		+= arm/aarch64/kvm.o
> > > > > > > +	OBJS		+= arm/aarch64/pvtime.o
> > > > > > >  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
> > > > > > >  	ARCH_INCLUDE	+= -Iarm/aarch64/include
> > > > > > >
> > > > > > > diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
> > > > > > > index d7572b7..326fb20 100644
> > > > > > > --- a/arm/aarch64/arm-cpu.c
> > > > > > > +++ b/arm/aarch64/arm-cpu.c
> > > > > > > @@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct
> > > > > > > kvm *kvm)
> > > > > > >  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
> > > > > > >  {
> > > > > > >  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
> > > > > > > +	kvm_cpu__setup_pvtime(vcpu);
> > > > > > >  	return 0;
> > > > > > >  }
> > > > > > >
> > > > > > > diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > > > > > > b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > > > > > > index 8dfb82e..b57d6e6 100644
> > > > > > > --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > > > > > > +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> > > > > > > @@ -19,5 +19,6 @@
> > > > > > >
> > > > > > >  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init
> > > > > > > *init);
> > > > > > >  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
> > > > > > > +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
> > > > > > >
> > > > > > >  #endif /* KVM__KVM_CPU_ARCH_H */
> > > > > > > diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> > > > > > > new file mode 100644
> > > > > > > index 0000000..247e4f3
> > > > > > > --- /dev/null
> > > > > > > +++ b/arm/aarch64/pvtime.c
> > > > > > > @@ -0,0 +1,89 @@
> > > > > > > +#include "kvm/kvm.h"
> > > > > > > +#include "kvm/kvm-cpu.h"
> > > > > > > +#include "kvm/util.h"
> > > > > > > +
> > > > > > > +#include <linux/byteorder.h>
> > > > > > > +#include <linux/types.h>
> > > > > > > +
> > > > > > > +#define AARCH64_PVTIME_IPA_MAX_SIZE	SZ_64K
> > > > > > > +#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
> > > > > > > +					 AARCH64_PVTIME_IPA_MAX_SIZE)  
> > > > > >
> > > > > > This doesn't change the fact that it overlaps with KVM_PCI_MMIO_AREA,
> > > > > > which is
> > > > > > exposed to the guest in the DTB (see my reply to v2).  
> > > > > 
> > > > > Yup, this is a bit of a problem, and overlapping regions are
> > > > > a big no-no. Why can't the pvtime region be dynamically placed
> > > > > after the RAM (after checking that there is enough space to
> > > > > register it in the IPA space)?  
> > > > 
> > > > In theory, is there something to stop someone from creating a VM with
> > > > enough
> > > > memory to reach the end of the IPA space?  
> > > 
> > > No, but we can either steal 64kB from that upper limit if that's the
> > > case, or let the user know that stolen time is disabled because they
> > > have been greedy...  
> > 
> > If we decide to go with having the pvtime region after RAM, I would prefer to
> > disable it if there's no room, and print a big warning letting the user know
> > what is happening and why, instead of silently shrinking the memory size
> > specified by the user.
> > 
> > I've CC'ed Andre, he's the last one who made changes to the memory layout when
> > he added the flash device.

Hi,

> 
> Why don't we just put that inside the MMIO "region", so after the RTC, for
> instance? This is in a separate memslot anyway, and there is plenty of
> space there for a 64K page.
> I'd just add some lines to arm/include/arm-common/kvm-arch.h to that
> effect.
> 

I think that should work, thanks for the suggestion.

> Cheers,
> Andre

Thanks,
Sebastian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
